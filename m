Return-Path: <linux-kernel-owner+w=401wt.eu-S1759084AbZGCVJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759084AbZGCVJu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 17:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757308AbZGCVJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 17:09:41 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:40749 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757148AbZGCVJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 17:09:40 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: gregkh@suse.de
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] USB: usb-serial, remove unused variables
Date: Fri,  3 Jul 2009 23:09:41 +0200
Message-Id: <1246655381-18007-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are some unused variables in serial_do_down. Remove them.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/usb/serial/usb-serial.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 9e6027b..0d9bd45 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -281,8 +281,6 @@ bailout_serial_put:
 static void serial_do_down(struct usb_serial_port *port)
 {
 	struct usb_serial_driver *drv = port->serial->type;
-	struct usb_serial *serial;
-	struct module *owner;
 
 	/* The console is magical, do not hang up the console hardware
 	   or there will be tears */
@@ -290,12 +288,8 @@ static void serial_do_down(struct usb_serial_port *port)
 		return;
 
 	mutex_lock(&port->mutex);
-	serial = port->serial;
-	owner = serial->type->driver.owner;
-
 	if (drv->close)
 		drv->close(port);
-
 	mutex_unlock(&port->mutex);
 }
 
-- 
1.6.3.2

