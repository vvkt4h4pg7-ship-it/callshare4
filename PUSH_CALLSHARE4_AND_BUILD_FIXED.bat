@echo off
setlocal EnableExtensions
chcp 65001 >nul
set "PROJECT=C:\Users\ugur_\OneDrive\Desktop\CALLSHARE GAYMAK\CALLSHARE_WIFI_R3_CONTROL_FIX\CALLSHARE_WIFI_R3_CONTROL_FIX\CALLSHARE-iOS"
set "REMOTE=https://github.com/vvkt4h4pg7-ship-it/callshare4.git"

echo ==========================================================
echo CALLSHARE4 - Push iOS project to GitHub
echo ==========================================================
echo Default project: %PROJECT%
echo Remote         : %REMOTE%
echo.

if not exist "%PROJECT%\J7Bridge.xcodeproj\project.pbxproj" (
  echo [INFO] Default project path could not be confirmed.
  echo Paste the FULL path of the CALLSHARE-iOS folder.
  echo Example: C:\Users\ugur_\OneDrive\Desktop\...\CALLSHARE-iOS
  echo.
  set /p "PROJECT=Project folder path: "
)

if not exist "%PROJECT%\J7Bridge.xcodeproj\project.pbxproj" (
  echo.
  echo [ERROR] J7Bridge.xcodeproj\project.pbxproj not found at:
  echo "%PROJECT%"
  echo Make sure the path points to the CALLSHARE-iOS project root.
  pause
  exit /b 1
)

cd /d "%PROJECT%"
if errorlevel 1 (
  echo [ERROR] Could not enter project folder: "%PROJECT%"
  pause
  exit /b 1
)

if not exist ".github\workflows\build.yml" (
  echo [WARNING] .github\workflows\build.yml not found.
  echo Source files can still be pushed, but Actions may not build automatically.
  choice /C YN /M "Continue anyway"
  if errorlevel 2 exit /b 1
)

git --version >nul 2>&1
if errorlevel 1 (
  echo [ERROR] Git is not installed or not in PATH.
  pause
  exit /b 1
)

if not exist ".git" (
  echo [INFO] Initializing Git repository...
  git init
  if errorlevel 1 goto :fail
)

git branch -M main
if errorlevel 1 goto :fail

echo.
echo [INFO] Staging project files...
git add -A
if errorlevel 1 goto :fail

echo.
echo [INFO] Files to be committed:
git status --short

echo.
choice /C YN /M "Yukaridaki proje dosyalarini callshare4 reposuna gonderelim mi"
if errorlevel 2 (
  echo [INFO] Cancelled; nothing was pushed.
  pause
  exit /b 0
)

git diff --cached --quiet
if errorlevel 1 (
  git commit -m "CALLSHARE Wi-Fi R3 control uplink fix"
  if errorlevel 1 (
    echo [ERROR] Commit failed. Git identity may need configuration.
    pause
    exit /b 1
  )
) else (
  echo [INFO] No staged changes to commit.
)

git remote get-url origin >nul 2>&1
if errorlevel 1 (
  git remote add origin "%REMOTE%"
) else (
  git remote set-url origin "%REMOTE%"
)
if errorlevel 1 goto :fail

echo.
echo [INFO] Pushing main to GitHub...
git push -u origin main
if errorlevel 1 (
  echo.
  echo [ERROR] Push failed.
  echo Do NOT force-push. Send the exact error text for safe recovery.
  pause
  exit /b 1
)

echo.
echo [SUCCESS] Push completed. Check GitHub Actions:
echo https://github.com/vvkt4h4pg7-ship-it/callshare4/actions
echo Expected artifact: CALLSHARE-Final-unsigned
pause
exit /b 0

:fail
echo.
echo [ERROR] Git operation failed. Review output above.
pause
exit /b 1
