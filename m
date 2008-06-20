Return-Path: <linux-kernel-owner+w=401wt.eu-S1756842AbYFTU0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842AbYFTU0M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:26:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760906AbYFTUTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:19:30 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35189 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760902AbYFTUT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:19:29 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 30/70] cp2101: coding style
To: linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 21:02:04 +0100
Message-ID: <20080620200203.1479.90065.stgit@localhost.localdomain>
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

Bring up to coding style

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/usb/serial/cp2101.c |  318 +++++++++++++++++++++----------------------
 1 files changed, 158 insertions(+), 160 deletions(-)


diff --git a/drivers/usb/serial/cp2101.c b/drivers/usb/serial/cp2101.c
index 908803e..16a0fda 100644
--- a/drivers/usb/serial/cp2101.c
+++ b/drivers/usb/serial/cp2101.c
@@ -25,7 +25,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/usb.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <linux/usb/serial.h>
 
 /*
@@ -45,12 +45,12 @@ static void cp2101_close(struct tty_struct *, struct usb_serial_port *,
 static void cp2101_get_termios(struct tty_struct *);
 static void cp2101_set_termios(struct tty_struct *, struct usb_serial_port *,
 							struct ktermios*);
-static int cp2101_tiocmget (struct tty_struct *, struct file *);
-static int cp2101_tiocmset (struct tty_struct *, struct file *,
+static int cp2101_tiocmget(struct tty_struct *, struct file *);
+static int cp2101_tiocmset(struct tty_struct *, struct file *,
 		unsigned int, unsigned int);
 static void cp2101_break_ctl(struct tty_struct *, int);
-static int cp2101_startup (struct usb_serial *);
-static void cp2101_shutdown(struct usb_serial*);
+static int cp2101_startup(struct usb_serial *);
+static void cp2101_shutdown(struct usb_serial *);
 
 
 static int debug;
@@ -96,7 +96,7 @@ static struct usb_device_id id_table [] = {
 	{ } /* Terminating Entry */
 };
 
-MODULE_DEVICE_TABLE (usb, id_table);
+MODULE_DEVICE_TABLE(usb, id_table);
 
 static struct usb_driver cp2101_driver = {
 	.name		= "cp2101",
@@ -205,12 +205,12 @@ static int cp2101_get_config(struct usb_serial_port *port, u8 request,
 	request++;
 
 	/* Issue the request, attempting to read 'size' bytes */
-	result = usb_control_msg (serial->dev,usb_rcvctrlpipe (serial->dev, 0),
+	result = usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
 				request, REQTYPE_DEVICE_TO_HOST, 0x0000,
 				0, buf, size, 300);
 
 	/* Convert data into an array of integers */
-	for (i=0; i<length; i++)
+	for (i = 0; i < length; i++)
 		data[i] = le32_to_cpu(buf[i]);
 
 	kfree(buf);
@@ -253,12 +253,12 @@ static int cp2101_set_config(struct usb_serial_port *port, u8 request,
 		buf[i] = cpu_to_le32(data[i]);
 
 	if (size > 2) {
-		result = usb_control_msg (serial->dev,
+		result = usb_control_msg(serial->dev,
 				usb_sndctrlpipe(serial->dev, 0),
 				request, REQTYPE_HOST_TO_DEVICE, 0x0000,
 				0, buf, size, 300);
 	} else {
-		result = usb_control_msg (serial->dev,
+		result = usb_control_msg(serial->dev,
 				usb_sndctrlpipe(serial->dev, 0),
 				request, REQTYPE_HOST_TO_DEVICE, data[0],
 				0, NULL, 0, 300);
@@ -274,7 +274,7 @@ static int cp2101_set_config(struct usb_serial_port *port, u8 request,
 	}
 
 	/* Single data value */
-	result = usb_control_msg (serial->dev,
+	result = usb_control_msg(serial->dev,
 			usb_sndctrlpipe(serial->dev, 0),
 			request, REQTYPE_HOST_TO_DEVICE, data[0],
 			0, NULL, 0, 300);
@@ -292,7 +292,7 @@ static inline int cp2101_set_config_single(struct usb_serial_port *port,
 	return cp2101_set_config(port, request, &data, 2);
 }
 
-static int cp2101_open (struct tty_struct *tty, struct usb_serial_port *port,
+static int cp2101_open(struct tty_struct *tty, struct usb_serial_port *port,
 				struct file *filp)
 {
 	struct usb_serial *serial = port->serial;
@@ -307,7 +307,7 @@ static int cp2101_open (struct tty_struct *tty, struct usb_serial_port *port,
 	}
 
 	/* Start reading from the device */
-	usb_fill_bulk_urb (port->read_urb, serial->dev,
+	usb_fill_bulk_urb(port->read_urb, serial->dev,
 			usb_rcvbulkpipe(serial->dev,
 			port->bulk_in_endpointAddress),
 			port->read_urb->transfer_buffer,
@@ -330,7 +330,7 @@ static int cp2101_open (struct tty_struct *tty, struct usb_serial_port *port,
 	return 0;
 }
 
-static void cp2101_cleanup (struct usb_serial_port *port)
+static void cp2101_cleanup(struct usb_serial_port *port)
 {
 	struct usb_serial *serial = port->serial;
 
@@ -346,7 +346,7 @@ static void cp2101_cleanup (struct usb_serial_port *port)
 }
 
 static void cp2101_close(struct tty_struct *tty, struct usb_serial_port *port,
-					struct file * filp)
+					struct file *filp)
 {
 	dbg("%s - port %d", __func__, port->number);
 
@@ -367,6 +367,7 @@ static void cp2101_close(struct tty_struct *tty, struct usb_serial_port *port,
  * from the device, corrects any unsupported values, and configures the
  * termios structure to reflect the state of the device
  */
+
 static void cp2101_get_termios(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
@@ -391,99 +392,97 @@ static void cp2101_get_termios(struct tty_struct *tty)
 
 	cp2101_get_config(port, CP2101_BITS, &bits, 2);
 	cflag &= ~CSIZE;
-	switch(bits & BITS_DATA_MASK) {
-		case BITS_DATA_5:
-			dbg("%s - data bits = 5", __func__);
-			cflag |= CS5;
-			break;
-		case BITS_DATA_6:
-			dbg("%s - data bits = 6", __func__);
-			cflag |= CS6;
-			break;
-		case BITS_DATA_7:
-			dbg("%s - data bits = 7", __func__);
-			cflag |= CS7;
-			break;
-		case BITS_DATA_8:
-			dbg("%s - data bits = 8", __func__);
-			cflag |= CS8;
-			break;
-		case BITS_DATA_9:
-			dbg("%s - data bits = 9 (not supported, "
-					"using 8 data bits)", __func__);
-			cflag |= CS8;
-			bits &= ~BITS_DATA_MASK;
-			bits |= BITS_DATA_8;
-			cp2101_set_config(port, CP2101_BITS, &bits, 2);
-			break;
-		default:
-			dbg("%s - Unknown number of data bits, "
-					"using 8", __func__);
-			cflag |= CS8;
-			bits &= ~BITS_DATA_MASK;
-			bits |= BITS_DATA_8;
-			cp2101_set_config(port, CP2101_BITS, &bits, 2);
-			break;
+	switch (bits & BITS_DATA_MASK) {
+	case BITS_DATA_5:
+		dbg("%s - data bits = 5", __func__);
+		cflag |= CS5;
+		break;
+	case BITS_DATA_6:
+		dbg("%s - data bits = 6", __func__);
+		cflag |= CS6;
+		break;
+	case BITS_DATA_7:
+		dbg("%s - data bits = 7", __func__);
+		cflag |= CS7;
+		break;
+	case BITS_DATA_8:
+		dbg("%s - data bits = 8", __func__);
+		cflag |= CS8;
+		break;
+	case BITS_DATA_9:
+		dbg("%s - data bits = 9 (not supported, using 8 data bits)",
+								__func__);
+		cflag |= CS8;
+		bits &= ~BITS_DATA_MASK;
+		bits |= BITS_DATA_8;
+		cp2101_set_config(port, CP2101_BITS, &bits, 2);
+		break;
+	default:
+		dbg("%s - Unknown number of data bits, using 8", __func__);
+		cflag |= CS8;
+		bits &= ~BITS_DATA_MASK;
+		bits |= BITS_DATA_8;
+		cp2101_set_config(port, CP2101_BITS, &bits, 2);
+		break;
 	}
 
-	switch(bits & BITS_PARITY_MASK) {
-		case BITS_PARITY_NONE:
-			dbg("%s - parity = NONE", __func__);
-			cflag &= ~PARENB;
-			break;
-		case BITS_PARITY_ODD:
-			dbg("%s - parity = ODD", __func__);
-			cflag |= (PARENB|PARODD);
-			break;
-		case BITS_PARITY_EVEN:
-			dbg("%s - parity = EVEN", __func__);
-			cflag &= ~PARODD;
-			cflag |= PARENB;
-			break;
-		case BITS_PARITY_MARK:
-			dbg("%s - parity = MARK (not supported, "
-					"disabling parity)", __func__);
-			cflag &= ~PARENB;
-			bits &= ~BITS_PARITY_MASK;
-			cp2101_set_config(port, CP2101_BITS, &bits, 2);
-			break;
-		case BITS_PARITY_SPACE:
-			dbg("%s - parity = SPACE (not supported, "
-					"disabling parity)", __func__);
-			cflag &= ~PARENB;
-			bits &= ~BITS_PARITY_MASK;
-			cp2101_set_config(port, CP2101_BITS, &bits, 2);
-			break;
-		default:
-			dbg("%s - Unknown parity mode, "
-					"disabling parity", __func__);
-			cflag &= ~PARENB;
-			bits &= ~BITS_PARITY_MASK;
-			cp2101_set_config(port, CP2101_BITS, &bits, 2);
-			break;
+	switch (bits & BITS_PARITY_MASK) {
+	case BITS_PARITY_NONE:
+		dbg("%s - parity = NONE", __func__);
+		cflag &= ~PARENB;
+		break;
+	case BITS_PARITY_ODD:
+		dbg("%s - parity = ODD", __func__);
+		cflag |= (PARENB|PARODD);
+		break;
+	case BITS_PARITY_EVEN:
+		dbg("%s - parity = EVEN", __func__);
+		cflag &= ~PARODD;
+		cflag |= PARENB;
+		break;
+	case BITS_PARITY_MARK:
+		dbg("%s - parity = MARK (not supported, disabling parity)",
+				__func__);
+		cflag &= ~PARENB;
+		bits &= ~BITS_PARITY_MASK;
+		cp2101_set_config(port, CP2101_BITS, &bits, 2);
+		break;
+	case BITS_PARITY_SPACE:
+		dbg("%s - parity = SPACE (not supported, disabling parity)",
+				__func__);
+		cflag &= ~PARENB;
+		bits &= ~BITS_PARITY_MASK;
+		cp2101_set_config(port, CP2101_BITS, &bits, 2);
+		break;
+	default:
+		dbg("%s - Unknown parity mode, disabling parity", __func__);
+		cflag &= ~PARENB;
+		bits &= ~BITS_PARITY_MASK;
+		cp2101_set_config(port, CP2101_BITS, &bits, 2);
+		break;
 	}
 
 	cflag &= ~CSTOPB;
-	switch(bits & BITS_STOP_MASK) {
-		case BITS_STOP_1:
-			dbg("%s - stop bits = 1", __func__);
-			break;
-		case BITS_STOP_1_5:
-			dbg("%s - stop bits = 1.5 (not supported, "
-					"using 1 stop bit)", __func__);
-			bits &= ~BITS_STOP_MASK;
-			cp2101_set_config(port, CP2101_BITS, &bits, 2);
-			break;
-		case BITS_STOP_2:
-			dbg("%s - stop bits = 2", __func__);
-			cflag |= CSTOPB;
-			break;
-		default:
-			dbg("%s - Unknown number of stop bits, "
-					"using 1 stop bit", __func__);
-			bits &= ~BITS_STOP_MASK;
-			cp2101_set_config(port, CP2101_BITS, &bits, 2);
-			break;
+	switch (bits & BITS_STOP_MASK) {
+	case BITS_STOP_1:
+		dbg("%s - stop bits = 1", __func__);
+		break;
+	case BITS_STOP_1_5:
+		dbg("%s - stop bits = 1.5 (not supported, using 1 stop bit)",
+								__func__);
+		bits &= ~BITS_STOP_MASK;
+		cp2101_set_config(port, CP2101_BITS, &bits, 2);
+		break;
+	case BITS_STOP_2:
+		dbg("%s - stop bits = 2", __func__);
+		cflag |= CSTOPB;
+		break;
+	default:
+		dbg("%s - Unknown number of stop bits, using 1 stop bit",
+								__func__);
+		bits &= ~BITS_STOP_MASK;
+		cp2101_set_config(port, CP2101_BITS, &bits, 2);
+		break;
 	}
 
 	cp2101_get_config(port, CP2101_MODEMCTL, modem_ctl, 16);
@@ -498,11 +497,11 @@ static void cp2101_get_termios(struct tty_struct *tty)
 	tty->termios->c_cflag = cflag;
 }
 
-static void cp2101_set_termios (struct tty_struct *tty,
+static void cp2101_set_termios(struct tty_struct *tty,
 		struct usb_serial_port *port, struct ktermios *old_termios)
 {
 	unsigned int cflag, old_cflag;
-	int baud=0, bits;
+	int baud = 0, bits;
 	unsigned int modem_ctl[4];
 
 	dbg("%s - port %d", __func__, port->number);
@@ -518,30 +517,30 @@ static void cp2101_set_termios (struct tty_struct *tty,
 	/* If the baud rate is to be updated*/
 	if (baud != tty_termios_baud_rate(old_termios)) {
 		switch (baud) {
-			case 0:
-			case 600:
-			case 1200:
-			case 1800:
-			case 2400:
-			case 4800:
-			case 7200:
-			case 9600:
-			case 14400:
-			case 19200:
-			case 28800:
-			case 38400:
-			case 55854:
-			case 57600:
-			case 115200:
-			case 127117:
-			case 230400:
-			case 460800:
-			case 921600:
-			case 3686400:
-				break;
-			default:
-				baud = 9600;
-				break;
+		case 0:
+		case 600:
+		case 1200:
+		case 1800:
+		case 2400:
+		case 4800:
+		case 7200:
+		case 9600:
+		case 14400:
+		case 19200:
+		case 28800:
+		case 38400:
+		case 55854:
+		case 57600:
+		case 115200:
+		case 127117:
+		case 230400:
+		case 460800:
+		case 921600:
+		case 3686400:
+			break;
+		default:
+			baud = 9600;
+			break;
 		}
 
 		if (baud) {
@@ -563,28 +562,28 @@ static void cp2101_set_termios (struct tty_struct *tty,
 		cp2101_get_config(port, CP2101_BITS, &bits, 2);
 		bits &= ~BITS_DATA_MASK;
 		switch (cflag & CSIZE) {
-			case CS5:
-				bits |= BITS_DATA_5;
-				dbg("%s - data bits = 5", __func__);
-				break;
-			case CS6:
-				bits |= BITS_DATA_6;
-				dbg("%s - data bits = 6", __func__);
-				break;
-			case CS7:
-				bits |= BITS_DATA_7;
-				dbg("%s - data bits = 7", __func__);
-				break;
-			case CS8:
-				bits |= BITS_DATA_8;
-				dbg("%s - data bits = 8", __func__);
-				break;
-			/*case CS9:
-			 	bits |= BITS_DATA_9;
-				dbg("%s - data bits = 9", __func__);
-				break;*/
-			default:
-				dev_err(&port->dev, "cp2101 driver does not "
+		case CS5:
+			bits |= BITS_DATA_5;
+			dbg("%s - data bits = 5", __func__);
+			break;
+		case CS6:
+			bits |= BITS_DATA_6;
+			dbg("%s - data bits = 6", __func__);
+			break;
+		case CS7:
+			bits |= BITS_DATA_7;
+			dbg("%s - data bits = 7", __func__);
+			break;
+		case CS8:
+			bits |= BITS_DATA_8;
+			dbg("%s - data bits = 8", __func__);
+			break;
+		/*case CS9:
+			bits |= BITS_DATA_9;
+			dbg("%s - data bits = 9", __func__);
+			break;*/
+		default:
+			dev_err(&port->dev, "cp2101 driver does not "
 					"support the number of bits requested,"
 					" using 8 bit mode\n");
 				bits |= BITS_DATA_8;
@@ -716,30 +715,29 @@ static void cp2101_break_ctl(struct tty_struct *tty, int break_state)
 	else
 		state = BREAK_ON;
 	dbg("%s - turning break %s", __func__,
-			state==BREAK_OFF ? "off" : "on");
+			state == BREAK_OFF ? "off" : "on");
 	cp2101_set_config(port, CP2101_BREAK, &state, 2);
 }
 
-static int cp2101_startup (struct usb_serial *serial)
+static int cp2101_startup(struct usb_serial *serial)
 {
 	/* CP2101 buffers behave strangely unless device is reset */
 	usb_reset_device(serial->dev);
 	return 0;
 }
 
-static void cp2101_shutdown (struct usb_serial *serial)
+static void cp2101_shutdown(struct usb_serial *serial)
 {
 	int i;
 
 	dbg("%s", __func__);
 
 	/* Stop reads and writes on all ports */
-	for (i=0; i < serial->num_ports; ++i) {
+	for (i = 0; i < serial->num_ports; ++i)
 		cp2101_cleanup(serial->port[i]);
-	}
 }
 
-static int __init cp2101_init (void)
+static int __init cp2101_init(void)
 {
 	int retval;
 
@@ -759,10 +757,10 @@ static int __init cp2101_init (void)
 	return 0;
 }
 
-static void __exit cp2101_exit (void)
+static void __exit cp2101_exit(void)
 {
-	usb_deregister (&cp2101_driver);
-	usb_serial_deregister (&cp2101_device);
+	usb_deregister(&cp2101_driver);
+	usb_serial_deregister(&cp2101_device);
 }
 
 module_init(cp2101_init);

