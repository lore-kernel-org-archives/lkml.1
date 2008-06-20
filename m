Return-Path: <linux-kernel-owner+w=401wt.eu-S1762958AbYFTUZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762958AbYFTUZg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:25:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760865AbYFTUTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:19:16 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35185 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760855AbYFTUTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:19:14 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 28/70] tty-usb-console: tidy the USB console code
To: linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 21:01:50 +0100
Message-ID: <20080620200148.1479.44046.stgit@localhost.localdomain>
In-Reply-To: <20080620195406.1479.12620.stgit@localhost.localdomain>
References: <20080620195406.1479.12620.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>

Code tidy

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/usb/serial/console.c |  127 ++++++++++++++++++++++--------------------
 1 files changed, 66 insertions(+), 61 deletions(-)


diff --git a/drivers/usb/serial/console.c b/drivers/usb/serial/console.c
index 940f5de..9a4cd0a 100644
--- a/drivers/usb/serial/console.c
+++ b/drivers/usb/serial/console.c
@@ -6,7 +6,7 @@
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License version
  *	2 as published by the Free Software Foundation.
- * 
+ *
  * Thanks to Randy Dunlap for the original version of this code.
  *
  */
@@ -67,7 +67,7 @@ static int usb_console_setup(struct console *co, char *options)
 	struct tty_struct *tty = NULL;
 	struct ktermios *termios = NULL, dummy;
 
-	dbg ("%s", __func__);
+	dbg("%s", __func__);
 
 	if (options) {
 		baud = simple_strtoul(options, NULL, 10);
@@ -84,52 +84,52 @@ static int usb_console_setup(struct console *co, char *options)
 
 	/* build a cflag setting */
 	switch (baud) {
-		case 1200:
-			cflag |= B1200;
-			break;
-		case 2400:
-			cflag |= B2400;
-			break;
-		case 4800:
-			cflag |= B4800;
-			break;
-		case 19200:
-			cflag |= B19200;
-			break;
-		case 38400:
-			cflag |= B38400;
-			break;
-		case 57600:
-			cflag |= B57600;
-			break;
-		case 115200:
-			cflag |= B115200;
-			break;
-		case 9600:
-		default:
-			cflag |= B9600;
-			/*
-			 * Set this to a sane value to prevent a divide error
-			 */
-			baud  = 9600;
-			break;
+	case 1200:
+		cflag |= B1200;
+		break;
+	case 2400:
+		cflag |= B2400;
+		break;
+	case 4800:
+		cflag |= B4800;
+		break;
+	case 19200:
+		cflag |= B19200;
+		break;
+	case 38400:
+		cflag |= B38400;
+		break;
+	case 57600:
+		cflag |= B57600;
+		break;
+	case 115200:
+		cflag |= B115200;
+		break;
+	case 9600:
+	default:
+		cflag |= B9600;
+		/*
+		 * Set this to a sane value to prevent a divide error
+		 */
+		baud  = 9600;
+		break;
 	}
 	switch (bits) {
-		case 7:
-			cflag |= CS7;
-			break;
-		default:
-		case 8:
-			cflag |= CS8;
-			break;
+	case 7:
+		cflag |= CS7;
+		break;
+	default:
+	case 8:
+		cflag |= CS8;
+		break;
 	}
 	switch (parity) {
-		case 'o': case 'O':
-			cflag |= PARODD;
-			break;
-		case 'e': case 'E':
-			cflag |= PARENB;
-			break;
+	case 'o': case 'O':
+		cflag |= PARODD;
+		break;
+	case 'e': case 'E':
+		cflag |= PARENB;
+		break;
 	}
 	co->cflag = cflag;
 
@@ -140,7 +140,7 @@ static int usb_console_setup(struct console *co, char *options)
 	serial = usb_serial_get_by_index(co->index);
 	if (serial == NULL) {
 		/* no device is connected yet, sorry :( */
-		err ("No USB device connected to ttyUSB%i", co->index);
+		err("No USB device connected to ttyUSB%i", co->index);
 		return -ENODEV;
 	}
 
@@ -148,7 +148,7 @@ static int usb_console_setup(struct console *co, char *options)
 	port->port.tty = NULL;
 
 	info->port = port;
-	 
+
 	++port->port.count;
 	if (port->port.count == 1) {
 		if (serial->type->set_termios) {
@@ -174,7 +174,7 @@ static int usb_console_setup(struct console *co, char *options)
 			port->port.tty = tty;
 		}
 
-		/* only call the device specific open if this 
+		/* only call the device specific open if this
 		 * is the first time the port is opened */
 		if (serial->type->open)
 			retval = serial->type->open(NULL, port, NULL);
@@ -211,7 +211,8 @@ reset_open_count:
 goto out;
 }
 
-static void usb_console_write(struct console *co, const char *buf, unsigned count)
+static void usb_console_write(struct console *co,
+					const char *buf, unsigned count)
 {
 	static struct usbcons_info *info = &usbcons_info;
 	struct usb_serial_port *port = info->port;
@@ -228,7 +229,7 @@ static void usb_console_write(struct console *co, const char *buf, unsigned coun
 	dbg("%s - port %d, %d byte(s)", __func__, port->number, count);
 
 	if (!port->port.count) {
-		dbg ("%s - port not opened", __func__);
+		dbg("%s - port not opened", __func__);
 		return;
 	}
 
@@ -236,14 +237,15 @@ static void usb_console_write(struct console *co, const char *buf, unsigned coun
 		unsigned int i;
 		unsigned int lf;
 		/* search for LF so we can insert CR if necessary */
-		for (i=0, lf=0 ; i < count ; i++) {
+		for (i = 0, lf = 0 ; i < count ; i++) {
 			if (*(buf + i) == 10) {
 				lf = 1;
 				i++;
 				break;
 			}
 		}
-		/* pass on to the driver specific version of this function if it is available */
+		/* pass on to the driver specific version of this function if
+		   it is available */
 		if (serial->type->write)
 			retval = serial->type->write(NULL, port, buf, i);
 		else
@@ -253,9 +255,11 @@ static void usb_console_write(struct console *co, const char *buf, unsigned coun
 			/* append CR after LF */
 			unsigned char cr = 13;
 			if (serial->type->write)
-				retval = serial->type->write(NULL, port, &cr, 1);
+				retval = serial->type->write(NULL,
+								port, &cr, 1);
 			else
-				retval = usb_serial_generic_write(NULL, port, &cr, 1);
+				retval = usb_serial_generic_write(NULL,
+								port, &cr, 1);
 			dbg("%s - return value : %d", __func__, retval);
 		}
 		buf += i;
@@ -273,18 +277,19 @@ static struct console usbcons = {
 
 void usb_serial_console_disconnect(struct usb_serial *serial)
 {
-	if (serial && serial->port && serial->port[0] && serial->port[0] == usbcons_info.port) {
+	if (serial && serial->port && serial->port[0]
+				&& serial->port[0] == usbcons_info.port) {
 		usb_serial_console_exit();
 		usb_serial_put(serial);
 	}
 }
 
-void usb_serial_console_init (int serial_debug, int minor)
+void usb_serial_console_init(int serial_debug, int minor)
 {
 	debug = serial_debug;
 
 	if (minor == 0) {
-		/* 
+		/*
 		 * Call register_console() if this is the first device plugged
 		 * in.  If we call it earlier, then the callback to
 		 * console_setup() will fail, as there is not a device seen by
@@ -293,16 +298,16 @@ void usb_serial_console_init (int serial_debug, int minor)
 		/*
 		 * Register console.
 		 * NOTES:
-		 * console_setup() is called (back) immediately (from register_console).
-		 * console_write() is called immediately from register_console iff
-		 * CON_PRINTBUFFER is set in flags.
+		 * console_setup() is called (back) immediately (from
+		 * register_console). console_write() is called immediately
+		 * from register_console iff CON_PRINTBUFFER is set in flags.
 		 */
-		dbg ("registering the USB serial console.");
+		dbg("registering the USB serial console.");
 		register_console(&usbcons);
 	}
 }
 
-void usb_serial_console_exit (void)
+void usb_serial_console_exit(void)
 {
 	if (usbcons_info.port) {
 		unregister_console(&usbcons);

