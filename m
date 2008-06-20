Return-Path: <linux-kernel-owner+w=401wt.eu-S1762876AbYFTUYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762876AbYFTUYu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760785AbYFTUTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:19:13 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35181 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760827AbYFTUTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:19:01 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 26/70] belkin_sa: clean up code
To: linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 21:01:36 +0100
Message-ID: <20080620200134.1479.39579.stgit@localhost.localdomain>
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

Coding style tidy up for belkin_sa

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/usb/serial/belkin_sa.c |  148 +++++++++++++++++++++++-----------------
 drivers/usb/serial/belkin_sa.h |   15 ++--
 2 files changed, 94 insertions(+), 69 deletions(-)


diff --git a/drivers/usb/serial/belkin_sa.c b/drivers/usb/serial/belkin_sa.c
index 1a76269..2ebe06c 100644
--- a/drivers/usb/serial/belkin_sa.c
+++ b/drivers/usb/serial/belkin_sa.c
@@ -7,13 +7,14 @@
  *  This program is largely derived from work by the linux-usb group
  *  and associated source files.  Please see the usb/serial files for
  *  individual credits and copyrights.
- *  
+ *
  * 	This program is free software; you can redistribute it and/or modify
  * 	it under the terms of the GNU General Public License as published by
  * 	the Free Software Foundation; either version 2 of the License, or
  * 	(at your option) any later version.
  *
- * See Documentation/usb/usb-serial.txt for more information on using this driver
+ * See Documentation/usb/usb-serial.txt for more information on using this
+ * driver
  *
  * TODO:
  * -- Add true modem contol line query capability.  Currently we track the
@@ -28,7 +29,8 @@
  * 	compressed all the differnent device entries into 1.
  *
  * 30-May-2001 gkh
- *	switched from using spinlock to a semaphore, which fixes lots of problems.
+ *	switched from using spinlock to a semaphore, which fixes lots of
+ *	problems.
  *
  * 08-Apr-2001 gb
  *	- Identify version on module load.
@@ -41,7 +43,7 @@
  *	- Added support for the old Belkin and Peracom devices.
  *	- Made the port able to be opened multiple times.
  *	- Added some defaults incase the line settings are things these devices
- *	  can't support. 
+ *	  can't support.
  *
  * 18-Oct-2000 William Greathouse
  *    Released into the wild (linux-usb-devel)
@@ -72,7 +74,7 @@
 #include <linux/tty_flip.h>
 #include <linux/module.h>
 #include <linux/spinlock.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
 #include "belkin_sa.h"
@@ -87,15 +89,19 @@ static int debug;
 #define DRIVER_DESC "USB Belkin Serial converter driver"
 
 /* function prototypes for a Belkin USB Serial Adapter F5U103 */
-static int  belkin_sa_startup		(struct usb_serial *serial);
-static void belkin_sa_shutdown		(struct usb_serial *serial);
-static int  belkin_sa_open		(struct tty_struct *tty, struct usb_serial_port *port, struct file *filp);
-static void belkin_sa_close		(struct tty_struct *tty, struct usb_serial_port *port, struct file *filp);
-static void belkin_sa_read_int_callback (struct urb *urb);
-static void belkin_sa_set_termios	(struct tty_struct *tty, struct usb_serial_port *port, struct ktermios * old);
-static void belkin_sa_break_ctl		(struct tty_struct *tty, int break_state );
-static int  belkin_sa_tiocmget		(struct tty_struct *tty, struct file *file);
-static int  belkin_sa_tiocmset		(struct tty_struct *tty, struct file *file, unsigned int set, unsigned int clear);
+static int  belkin_sa_startup(struct usb_serial *serial);
+static void belkin_sa_shutdown(struct usb_serial *serial);
+static int  belkin_sa_open(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp);
+static void belkin_sa_close(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp);
+static void belkin_sa_read_int_callback(struct urb *urb);
+static void belkin_sa_set_termios(struct tty_struct *tty,
+			struct usb_serial_port *port, struct ktermios * old);
+static void belkin_sa_break_ctl(struct tty_struct *tty, int break_state);
+static int  belkin_sa_tiocmget(struct tty_struct *tty, struct file *file);
+static int  belkin_sa_tiocmset(struct tty_struct *tty, struct file *file,
+					unsigned int set, unsigned int clear);
 
 
 static struct usb_device_id id_table_combined [] = {
@@ -105,10 +111,10 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(GOHUBS_VID, GOHUBS_PID) },
 	{ USB_DEVICE(GOHUBS_VID, HANDYLINK_PID) },
 	{ USB_DEVICE(BELKIN_DOCKSTATION_VID, BELKIN_DOCKSTATION_PID) },
-	{ }							/* Terminating entry */
+	{ }	/* Terminating entry */
 };
 
-MODULE_DEVICE_TABLE (usb, id_table_combined);
+MODULE_DEVICE_TABLE(usb, id_table_combined);
 
 static struct usb_driver belkin_driver = {
 	.name =		"belkin",
@@ -130,7 +136,8 @@ static struct usb_serial_driver belkin_device = {
 	.num_ports =		1,
 	.open =			belkin_sa_open,
 	.close =		belkin_sa_close,
-	.read_int_callback =	belkin_sa_read_int_callback,	/* How we get the status info */
+	.read_int_callback =	belkin_sa_read_int_callback,
+					/* How we get the status info */
 	.set_termios =		belkin_sa_set_termios,
 	.break_ctl =		belkin_sa_break_ctl,
 	.tiocmget =		belkin_sa_tiocmget,
@@ -158,12 +165,12 @@ struct belkin_sa_private {
 #define WDR_TIMEOUT 5000 /* default urb timeout */
 
 /* assumes that struct usb_serial *serial is available */
-#define BSA_USB_CMD(c,v) usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0), \
+#define BSA_USB_CMD(c, v) usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0), \
 					    (c), BELKIN_SA_SET_REQUEST_TYPE, \
 					    (v), 0, NULL, 0, WDR_TIMEOUT)
 
 /* do some startup allocations not currently performed by usb_serial_probe() */
-static int belkin_sa_startup (struct usb_serial *serial)
+static int belkin_sa_startup(struct usb_serial *serial)
 {
 	struct usb_device *dev = serial->dev;
 	struct belkin_sa_private *priv;
@@ -171,20 +178,23 @@ static int belkin_sa_startup (struct usb_serial *serial)
 	/* allocate the private data structure */
 	priv = kmalloc(sizeof(struct belkin_sa_private), GFP_KERNEL);
 	if (!priv)
-		return (-1); /* error */
+		return -1; /* error */
 	/* set initial values for control structures */
 	spin_lock_init(&priv->lock);
 	priv->control_state = 0;
 	priv->last_lsr = 0;
 	priv->last_msr = 0;
 	/* see comments at top of file */
-	priv->bad_flow_control = (le16_to_cpu(dev->descriptor.bcdDevice) <= 0x0206) ? 1 : 0;
-	info("bcdDevice: %04x, bfc: %d", le16_to_cpu(dev->descriptor.bcdDevice), priv->bad_flow_control);
+	priv->bad_flow_control =
+		(le16_to_cpu(dev->descriptor.bcdDevice) <= 0x0206) ? 1 : 0;
+	info("bcdDevice: %04x, bfc: %d",
+					le16_to_cpu(dev->descriptor.bcdDevice),
+					priv->bad_flow_control);
 
 	init_waitqueue_head(&serial->port[0]->write_wait);
 	usb_set_serial_port_data(serial->port[0], priv);
-	
-	return (0);
+
+	return 0;
 }
 
 
@@ -192,11 +202,11 @@ static void belkin_sa_shutdown(struct usb_serial *serial)
 {
 	struct belkin_sa_private *priv;
 	int i;
-	
-	dbg ("%s", __func__);
+
+	dbg("%s", __func__);
 
 	/* stop reads and writes on all ports */
-	for (i=0; i < serial->num_ports; ++i) {
+	for (i = 0; i < serial->num_ports; ++i) {
 		/* My special items, the standard routines free my urbs */
 		priv = usb_get_serial_port_data(serial->port[i]);
 		kfree(priv);
@@ -204,7 +214,8 @@ static void belkin_sa_shutdown(struct usb_serial *serial)
 }
 
 
-static int  belkin_sa_open(struct tty_struct *tty, struct usb_serial_port *port, struct file *filp)
+static int  belkin_sa_open(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp)
 {
 	int retval = 0;
 
@@ -233,7 +244,7 @@ exit:
 } /* belkin_sa_open */
 
 
-static void belkin_sa_close (struct tty_struct *tty,
+static void belkin_sa_close(struct tty_struct *tty,
 			struct usb_serial_port *port, struct file *filp)
 {
 	dbg("%s port %d", __func__, port->number);
@@ -271,7 +282,8 @@ static void belkin_sa_read_int_callback(struct urb *urb)
 		goto exit;
 	}
 
-	usb_serial_debug_data(debug, &port->dev, __func__, urb->actual_length, data);
+	usb_serial_debug_data(debug, &port->dev, __func__,
+					urb->actual_length, data);
 
 	/* Handle known interrupt data */
 	/* ignore data[0] and data[1] */
@@ -279,7 +291,7 @@ static void belkin_sa_read_int_callback(struct urb *urb)
 	priv = usb_get_serial_port_data(port);
 	spin_lock_irqsave(&priv->lock, flags);
 	priv->last_msr = data[BELKIN_SA_MSR_INDEX];
-	
+
 	/* Record Control Line states */
 	if (priv->last_msr & BELKIN_SA_MSR_DSR)
 		priv->control_state |= TIOCM_DSR;
@@ -327,9 +339,9 @@ static void belkin_sa_read_int_callback(struct urb *urb)
 #endif
 	spin_unlock_irqrestore(&priv->lock, flags);
 exit:
-	retval = usb_submit_urb (urb, GFP_ATOMIC);
+	retval = usb_submit_urb(urb, GFP_ATOMIC);
 	if (retval)
-		err ("%s - usb_submit_urb failed with result %d",
+		err("%s - usb_submit_urb failed with result %d",
 		     __func__, retval);
 }
 
@@ -348,7 +360,7 @@ static void belkin_sa_set_termios(struct tty_struct *tty,
 	int bad_flow_control;
 	speed_t baud;
 	struct ktermios *termios = tty->termios;
-	
+
 	iflag = termios->c_iflag;
 	cflag = termios->c_cflag;
 
@@ -359,20 +371,21 @@ static void belkin_sa_set_termios(struct tty_struct *tty,
 	control_state = priv->control_state;
 	bad_flow_control = priv->bad_flow_control;
 	spin_unlock_irqrestore(&priv->lock, flags);
-	
+
 	old_iflag = old_termios->c_iflag;
 	old_cflag = old_termios->c_cflag;
 
 	/* Set the baud rate */
 	if ((cflag & CBAUD) != (old_cflag & CBAUD)) {
 		/* reassert DTR and (maybe) RTS on transition from B0 */
-		if( (old_cflag&CBAUD) == B0 ) {
+		if ((old_cflag & CBAUD) == B0) {
 			control_state |= (TIOCM_DTR|TIOCM_RTS);
 			if (BSA_USB_CMD(BELKIN_SA_SET_DTR_REQUEST, 1) < 0)
 				err("Set DTR error");
 			/* don't set RTS if using hardware flow control */
 			if (!(old_cflag & CRTSCTS))
-				if (BSA_USB_CMD(BELKIN_SA_SET_RTS_REQUEST, 1) < 0)
+				if (BSA_USB_CMD(BELKIN_SA_SET_RTS_REQUEST
+								, 1) < 0)
 					err("Set RTS error");
 		}
 	}
@@ -392,7 +405,8 @@ static void belkin_sa_set_termios(struct tty_struct *tty,
 			err("Set baudrate error");
 	} else {
 		/* Disable flow control */
-		if (BSA_USB_CMD(BELKIN_SA_SET_FLOW_CTRL_REQUEST, BELKIN_SA_FLOW_NONE) < 0)
+		if (BSA_USB_CMD(BELKIN_SA_SET_FLOW_CTRL_REQUEST,
+						BELKIN_SA_FLOW_NONE) < 0)
 			err("Disable flowcontrol error");
 		/* Drop RTS and DTR */
 		control_state &= ~(TIOCM_DTR | TIOCM_RTS);
@@ -403,9 +417,10 @@ static void belkin_sa_set_termios(struct tty_struct *tty,
 	}
 
 	/* set the parity */
-	if( (cflag&(PARENB|PARODD)) != (old_cflag&(PARENB|PARODD)) ) {
+	if ((cflag ^ old_cflag) & (PARENB | PARODD)) {
 		if (cflag & PARENB)
-			urb_value = (cflag & PARODD) ?  BELKIN_SA_PARITY_ODD : BELKIN_SA_PARITY_EVEN;
+			urb_value = (cflag & PARODD) ?  BELKIN_SA_PARITY_ODD
+						: BELKIN_SA_PARITY_EVEN;
 		else
 			urb_value = BELKIN_SA_PARITY_NONE;
 		if (BSA_USB_CMD(BELKIN_SA_SET_PARITY_REQUEST, urb_value) < 0)
@@ -413,31 +428,40 @@ static void belkin_sa_set_termios(struct tty_struct *tty,
 	}
 
 	/* set the number of data bits */
-	if( (cflag&CSIZE) != (old_cflag&CSIZE) ) {
+	if ((cflag & CSIZE) != (old_cflag & CSIZE)) {
 		switch (cflag & CSIZE) {
-			case CS5: urb_value = BELKIN_SA_DATA_BITS(5); break;
-			case CS6: urb_value = BELKIN_SA_DATA_BITS(6); break;
-			case CS7: urb_value = BELKIN_SA_DATA_BITS(7); break;
-			case CS8: urb_value = BELKIN_SA_DATA_BITS(8); break;
-			default: dbg("CSIZE was not CS5-CS8, using default of 8");
-				urb_value = BELKIN_SA_DATA_BITS(8);
-				break;
+		case CS5:
+			urb_value = BELKIN_SA_DATA_BITS(5);
+			break;
+		case CS6:
+			urb_value = BELKIN_SA_DATA_BITS(6);
+			break;
+		case CS7:
+			urb_value = BELKIN_SA_DATA_BITS(7);
+			break;
+		case CS8:
+			urb_value = BELKIN_SA_DATA_BITS(8);
+			break;
+		default: dbg("CSIZE was not CS5-CS8, using default of 8");
+			urb_value = BELKIN_SA_DATA_BITS(8);
+			break;
 		}
 		if (BSA_USB_CMD(BELKIN_SA_SET_DATA_BITS_REQUEST, urb_value) < 0)
 			err("Set data bits error");
 	}
 
 	/* set the number of stop bits */
-	if( (cflag&CSTOPB) != (old_cflag&CSTOPB) ) {
-		urb_value = (cflag & CSTOPB) ? BELKIN_SA_STOP_BITS(2) : BELKIN_SA_STOP_BITS(1);
-		if (BSA_USB_CMD(BELKIN_SA_SET_STOP_BITS_REQUEST, urb_value) < 0)
+	if ((cflag & CSTOPB) != (old_cflag & CSTOPB)) {
+		urb_value = (cflag & CSTOPB) ? BELKIN_SA_STOP_BITS(2)
+						: BELKIN_SA_STOP_BITS(1);
+		if (BSA_USB_CMD(BELKIN_SA_SET_STOP_BITS_REQUEST,
+							urb_value) < 0)
 			err("Set stop bits error");
 	}
 
 	/* Set flow control */
-	if( (iflag&IXOFF)   != (old_iflag&IXOFF)
-	||	(iflag&IXON)    != (old_iflag&IXON)
-	||  (cflag&CRTSCTS) != (old_cflag&CRTSCTS) ) {
+	if (((iflag ^ old_iflag) & (IXOFF | IXON)) ||
+		((cflag ^ old_cflag) & CRTSCTS)) {
 		urb_value = 0;
 		if ((iflag & IXOFF) || (iflag & IXON))
 			urb_value |= (BELKIN_SA_FLOW_OXON | BELKIN_SA_FLOW_IXON);
@@ -479,7 +503,7 @@ static int belkin_sa_tiocmget(struct tty_struct *tty, struct file *file)
 	struct belkin_sa_private *priv = usb_get_serial_port_data(port);
 	unsigned long control_state;
 	unsigned long flags;
-	
+
 	dbg("%s", __func__);
 
 	spin_lock_irqsave(&priv->lock, flags);
@@ -501,7 +525,7 @@ static int belkin_sa_tiocmset(struct tty_struct *tty, struct file *file,
 	int retval;
 	int rts = 0;
 	int dtr = 0;
-	
+
 	dbg("%s", __func__);
 
 	spin_lock_irqsave(&priv->lock, flags);
@@ -563,17 +587,17 @@ failed_usb_serial_register:
 
 static void __exit belkin_sa_exit (void)
 {
-	usb_deregister (&belkin_driver);
+	usb_deregister(&belkin_driver);
 	usb_serial_deregister(&belkin_device);
 }
 
 
-module_init (belkin_sa_init);
-module_exit (belkin_sa_exit);
+module_init(belkin_sa_init);
+module_exit(belkin_sa_exit);
 
-MODULE_AUTHOR( DRIVER_AUTHOR );
-MODULE_DESCRIPTION( DRIVER_DESC );
-MODULE_VERSION( DRIVER_VERSION );
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_VERSION(DRIVER_VERSION);
 MODULE_LICENSE("GPL");
 
 module_param(debug, bool, S_IRUGO | S_IWUSR);
diff --git a/drivers/usb/serial/belkin_sa.h b/drivers/usb/serial/belkin_sa.h
index 9116b92..c66a673 100644
--- a/drivers/usb/serial/belkin_sa.h
+++ b/drivers/usb/serial/belkin_sa.h
@@ -7,13 +7,14 @@
  *  This program is largely derived from work by the linux-usb group
  *  and associated source files.  Please see the usb/serial files for
  *  individual credits and copyrights.
- *  
+ *
  * 	This program is free software; you can redistribute it and/or modify
  * 	it under the terms of the GNU General Public License as published by
  * 	the Free Software Foundation; either version 2 of the License, or
  * 	(at your option) any later version.
  *
- * See Documentation/usb/usb-serial.txt for more information on using this driver
+ * See Documentation/usb/usb-serial.txt for more information on using this
+ * driver
  *
  * 12-Mar-2001 gkh
  *	Added GoHubs GO-COM232 device id.
@@ -27,7 +28,7 @@
  *    adapter, so pardon any stupid mistakes.  All of the information
  *    I am using to write this driver was acquired by using a modified
  *    UsbSnoop on Windows2000.
- *    
+ *
  */
 
 #ifndef __LINUX_USB_SERIAL_BSA_H
@@ -96,20 +97,20 @@
 
 /*
  * It seems that the interrupt pipe is closely modelled after the
- * 16550 register layout.  This is probably because the adapter can 
+ * 16550 register layout.  This is probably because the adapter can
  * be used in a "DOS" environment to simulate a standard hardware port.
  */
-#define BELKIN_SA_LSR_INDEX		2		/* Line Status Register */
+#define BELKIN_SA_LSR_INDEX		2	/*     Line Status Register */
 #define BELKIN_SA_LSR_RDR		0x01	/* receive data ready */
 #define BELKIN_SA_LSR_OE		0x02	/* overrun error */
 #define BELKIN_SA_LSR_PE		0x04	/* parity error */
 #define BELKIN_SA_LSR_FE		0x08	/* framing error */
 #define BELKIN_SA_LSR_BI		0x10	/* break indicator */
-#define BELKIN_SA_LSR_THE		0x20	/* transmit holding register empty */
+#define BELKIN_SA_LSR_THE		0x20	/* tx holding register empty */
 #define BELKIN_SA_LSR_TE		0x40	/* transmit register empty */
 #define BELKIN_SA_LSR_ERR		0x80	/* OE | PE | FE | BI */
 
-#define BELKIN_SA_MSR_INDEX		3		/* Modem Status Register */
+#define BELKIN_SA_MSR_INDEX		3	/*     Modem Status Register */
 #define BELKIN_SA_MSR_DCTS		0x01	/* Delta CTS */
 #define BELKIN_SA_MSR_DDSR		0x02	/* Delta DSR */
 #define BELKIN_SA_MSR_DRI		0x04	/* Delta RI */

