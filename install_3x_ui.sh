#!/bin/bash

# Установка 3x-ui
echo "🔄 Устанавливаем 3x-ui..."
bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)

# Ожидание запуска панели
sleep 5

# Используем встроенные команды для извлечения данных панели
echo "🔍 Извлекаем данные панели..."
USERNAME=$(x-ui settings -show true | grep -Eo 'username: .+' | awk '{print $2}')
PASSWORD=$(x-ui settings -show true | grep -Eo 'password: .+' | awk '{print $2}')
PORT=$(x-ui settings -show true | grep -Eo 'port: .+' | awk '{print $2}')
WEB_BASE_PATH=$(x-ui settings -show true | grep -Eo 'webBasePath: .+' | awk '{print $2}')
SERVER_IP=$(curl -s https://api.ipify.org)

# Проверяем, удалось ли получить данные
if [[ -z "$USERNAME" || -z "$PASSWORD" || -z "$PORT" || -z "$WEB_BASE_PATH" ]]; then
    echo "❌ Ошибка: Не удалось получить данные панели x-ui."
    exit 1
fi

# Вывод информации
ACCESS_URL="http://$SERVER_IP:$PORT$WEB_BASE_PATH"

echo "┌───────────────────────────────────────────────────────────────┐"
echo "│  🗡️  𝕊𝕥𝕖𝕒𝕝𝕥𝕙 𝕄𝕠𝕕𝕖 𝔸𝕔𝕥𝕚𝕧𝕒𝕥𝕖𝕕!  🗡️ │"
echo "│    ⚔️   𝕏-𝕌𝕀 𝕊𝕖𝕥𝕦𝕡 𝕊𝕦𝕔𝕔𝕖𝕤𝕤𝕗𝕦𝕝!   ⚔️    │"
echo "├───────────────────────────────────────────────────────────────┤"
echo "│ 🌍 Доступ:       $ACCESS_URL"
echo "│ 👤 Логин:        $USERNAME"
echo "│ 🔑 Пароль:       $PASSWORD"
echo "│ 📂 WebBasePath:  $WEB_BASE_PATH"
echo "│ 🎯 Панельный порт: $PORT"
echo "└───────────────────────────────────────────────────────────────┘"

# 🔥 **Настраиваем UFW**
echo "⚙️ Настраиваем UFW..."
ufw status >/dev/null 2>&1 || yes | ufw enable

# Открываем панельный порт
ufw allow "$PORT"/tcp
ufw allow "$PORT"/udp

# Добавляем нужные порты (SSH, HTTP, HTTPS, CDN)
ufw allow 22/tcp
ufw allow 443/tcp
ufw allow 80/tcp
ufw allow 2053/tcp

ufw reload
echo "✅ Открыли порты $PORT, 22, 443, 80, 2053 в UFW"