#!/bin/bash
set -e

# propagate DOCKER_HOST env var if set
if [ $DOCKER_HOST ]; then
  echo "export DOCKER_HOST=$DOCKER_HOST" >> /etc/profile
fi

# if a non-root user is provided, create if it does not exist
if [ $DEVUSER ]; then
  PASSWORD="${PASSWORD:-Passw0rd}"

  if [ ! -d /home/$DEVUSER ]; then
    adduser --disabled-password --gecos '' $DEVUSER
    usermod -aG docker $DEVUSER
    cp -rf /root/.bluemix /home/$DEVUSER/.bluemix
    rm -rf /home/$DEVUSER/.bluemix/analytics
    chown -R $DEVUSER:$DEVUSER /home/$DEVUSER/.bluemix
    echo "$DEVUSER:$PASSWORD" | chpasswd
  fi
fi

# set up root user password from ENV
PASSWORD="${PASSWORD:-Passw0rd}"
echo "root:$PASSWORD" | chpasswd

exec "$@"