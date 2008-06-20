Return-Path: <linux-kernel-owner+w=401wt.eu-S1762332AbYFTUeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762332AbYFTUeH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:34:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761996AbYFTUVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:21:52 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35225 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761976AbYFTUVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:21:50 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 48/70] tty-usb-ir-usb: Clean up to coding style
To: linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 21:04:25 +0100
Message-ID: <20080620200422.1479.61540.stgit@localhost.localdomain>
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



Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/usb/serial/ir-usb.c |  373 +++++++++++++++++++++++--------------------
 1 files changed, 201 insertions(+), 172 deletions(-)


diff --git a/drivers/usb/serial/ir-usb.c b/drivers/usb/serial/ir-usb.c
index 43dd970..19bff6a 100644
--- a/drivers/usb/serial/ir-usb.c
+++ b/drivers/usb/serial/ir-usb.c
@@ -19,7 +19,8 @@
  * was written by Roman Weissgaerber <weissg@vienna.at>, Dag Brattli
  * <dag@brattli.net>, and Jean Tourrilhes <jt@hpl.hp.com>
  *
- * See Documentation/usb/usb-serial.txt for more information on using this driver
+ * See Documentation/usb/usb-serial.txt for more information on using this
+ * driver
  *
  * 2007_Jun_21  Alan Cox <alan@redhat.com>
  *	Minimal cleanups for some of the driver problens and tty layer abuse.
@@ -59,7 +60,7 @@
 #include <linux/tty_flip.h>
 #include <linux/module.h>
 #include <linux/spinlock.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
 
@@ -105,28 +106,32 @@ static int buffer_size;
 /* if overridden by the user, then use the specified number of XBOFs */
 static int xbof = -1;
 
-static int  ir_startup (struct usb_serial *serial);
-static int  ir_open(struct tty_struct *tty, struct usb_serial_port *port, struct file *filep);
-static void ir_close(struct tty_struct *tty, struct usb_serial_port *port, struct file *filep);
-static int  ir_write(struct tty_struct *tty, struct usb_serial_port *port, const unsigned char *buf, int count);
-static void ir_write_bulk_callback (struct urb *urb);
-static void ir_read_bulk_callback (struct urb *urb);
-static void ir_set_termios(struct tty_struct *tty, struct usb_serial_port *port, struct ktermios *old_termios);
+static int ir_startup(struct usb_serial *serial);
+static int ir_open(struct tty_struct *tty, struct usb_serial_port *port,
+		struct file *filep);
+static void ir_close(struct tty_struct *tty, struct usb_serial_port *port,
+		struct file *filep);
+static int ir_write(struct tty_struct *tty, struct usb_serial_port *port,
+		const unsigned char *buf, int count);
+static void ir_write_bulk_callback(struct urb *urb);
+static void ir_read_bulk_callback(struct urb *urb);
+static void ir_set_termios(struct tty_struct *tty,
+		struct usb_serial_port *port, struct ktermios *old_termios);
 
-/* Not that this lot means you can only have one per system */
-static u8 ir_baud = 0;
-static u8 ir_xbof = 0;
-static u8 ir_add_bof = 0;
+/* FIXME: Note that this lot means you can only have one per system */
+static u8 ir_baud;
+static u8 ir_xbof;
+static u8 ir_add_bof;
 
 static struct usb_device_id id_table [] = {
 	{ USB_DEVICE(0x050f, 0x0180) },		/* KC Technology, KC-180 */
 	{ USB_DEVICE(0x08e9, 0x0100) },		/* XTNDAccess */
 	{ USB_DEVICE(0x09c4, 0x0011) },		/* ACTiSys ACT-IR2000U */
-	{ USB_INTERFACE_INFO (USB_CLASS_APP_SPEC, USB_CLASS_IRDA, 0) },
+	{ USB_INTERFACE_INFO(USB_CLASS_APP_SPEC, USB_CLASS_IRDA, 0) },
 	{ }					/* Terminating entry */
 };
 
-MODULE_DEVICE_TABLE (usb, id_table);
+MODULE_DEVICE_TABLE(usb, id_table);
 
 static struct usb_driver ir_driver = {
 	.name =		"ir-usb",
@@ -159,7 +164,7 @@ static inline void irda_usb_dump_class_desc(struct irda_class_desc *desc)
 {
 	dbg("bLength=%x", desc->bLength);
 	dbg("bDescriptorType=%x", desc->bDescriptorType);
-	dbg("bcdSpecRevision=%x", desc->bcdSpecRevision); 
+	dbg("bcdSpecRevision=%x", desc->bcdSpecRevision);
 	dbg("bmDataSize=%x", desc->bmDataSize);
 	dbg("bmWindowSize=%x", desc->bmWindowSize);
 	dbg("bmMinTurnaroundTime=%d", desc->bmMinTurnaroundTime);
@@ -181,25 +186,26 @@ static inline void irda_usb_dump_class_desc(struct irda_class_desc *desc)
  *
  * Based on the same function in drivers/net/irda/irda-usb.c
  */
-static struct irda_class_desc *irda_usb_find_class_desc(struct usb_device *dev, unsigned int ifnum)
+static struct irda_class_desc *irda_usb_find_class_desc(struct usb_device *dev,
+						unsigned int ifnum)
 {
 	struct irda_class_desc *desc;
 	int ret;
-		
-	desc = kzalloc(sizeof (struct irda_class_desc), GFP_KERNEL);
-	if (desc == NULL) 
+
+	desc = kzalloc(sizeof(struct irda_class_desc), GFP_KERNEL);
+	if (desc == NULL)
 		return NULL;
-	
-	ret = usb_control_msg(dev, usb_rcvctrlpipe(dev,0),
+
+	ret = usb_control_msg(dev, usb_rcvctrlpipe(dev, 0),
 			IU_REQ_GET_CLASS_DESC,
 			USB_DIR_IN | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
 			0, ifnum, desc, sizeof(*desc), 1000);
-	
+
 	dbg("%s -  ret=%d", __func__, ret);
 	if (ret < sizeof(*desc)) {
 		dbg("%s - class descriptor read %s (%d)",
 				__func__,
-				(ret<0) ? "failed" : "too short",
+				(ret < 0) ? "failed" : "too short",
 				ret);
 		goto error;
 	}
@@ -207,7 +213,7 @@ static struct irda_class_desc *irda_usb_find_class_desc(struct usb_device *dev,
 		dbg("%s - bad class descriptor type", __func__);
 		goto error;
 	}
-	
+
 	irda_usb_dump_class_desc(desc);
 	return desc;
 error:
@@ -220,34 +226,44 @@ static u8 ir_xbof_change(u8 xbof)
 {
 	u8 result;
 	/* reference irda-usb.c */
-	switch(xbof) {
-		case 48: result = 0x10; break;
-		case 28:
-		case 24: result = 0x20; break;
-		default:
-		case 12: result = 0x30; break;
-		case  5:
-		case  6: result = 0x40; break;
-		case  3: result = 0x50; break;
-		case  2: result = 0x60; break;
-		case  1: result = 0x70; break;
-		case  0: result = 0x80; break;
+	switch (xbof) {
+	case 48:
+		result = 0x10;
+		break;
+	case 28:
+	case 24:result = 0x20;
+		break;
+	default:
+	case 12:result = 0x30;
+		break;
+	case  5:
+	case  6:result = 0x40;
+		break;
+	case  3:result = 0x50;
+		break;
+	case  2:result = 0x60;
+		break;
+	case  1:result = 0x70;
+		break;
+	case  0:result = 0x80;
+		break;
 	}
-	return(result);
+	return result;
 }
 
 
-static int ir_startup (struct usb_serial *serial)
+static int ir_startup(struct usb_serial *serial)
 {
 	struct irda_class_desc *irda_desc;
 
-	irda_desc = irda_usb_find_class_desc (serial->dev, 0);
+	irda_desc = irda_usb_find_class_desc(serial->dev, 0);
 	if (irda_desc == NULL) {
-		dev_err (&serial->dev->dev, "IRDA class descriptor not found, device not bound\n");
+		dev_err(&serial->dev->dev,
+			"IRDA class descriptor not found, device not bound\n");
 		return -ENODEV;
 	}
 
-	dbg ("%s - Baud rates supported:%s%s%s%s%s%s%s%s%s",
+	dbg("%s - Baud rates supported:%s%s%s%s%s%s%s%s%s",
 		__func__,
 		(irda_desc->wBaudRate & 0x0001) ? " 2400"    : "",
 		(irda_desc->wBaudRate & 0x0002) ? " 9600"    : "",
@@ -259,21 +275,35 @@ static int ir_startup (struct usb_serial *serial)
 		(irda_desc->wBaudRate & 0x0080) ? " 1152000" : "",
 		(irda_desc->wBaudRate & 0x0100) ? " 4000000" : "");
 
-	switch( irda_desc->bmAdditionalBOFs ) {
-		case 0x01: ir_add_bof = 48; break;
-		case 0x02: ir_add_bof = 24; break;
-		case 0x04: ir_add_bof = 12; break;
-		case 0x08: ir_add_bof =  6; break;
-		case 0x10: ir_add_bof =  3; break;
-		case 0x20: ir_add_bof =  2; break;
-		case 0x40: ir_add_bof =  1; break;
-		case 0x80: ir_add_bof =  0; break;
-		default:;
+	switch (irda_desc->bmAdditionalBOFs) {
+	case 0x01:
+		ir_add_bof = 48;
+		break;
+	case 0x02:
+		ir_add_bof = 24;
+		break;
+	case 0x04:
+		ir_add_bof = 12;
+		break;
+	case 0x08:
+		ir_add_bof =  6;
+		break;
+	case 0x10:
+		ir_add_bof =  3;
+		break;
+	case 0x20:
+		ir_add_bof =  2;
+		break;
+	case 0x40:
+		ir_add_bof =  1;
+		break;
+	case 0x80:
+		ir_add_bof =  0;
+		break;
+	default:;
 	}
-
-	kfree (irda_desc);
-
-	return 0;		
+	kfree(irda_desc);
+	return 0;
 }
 
 static int ir_open(struct tty_struct *tty,
@@ -286,47 +316,48 @@ static int ir_open(struct tty_struct *tty,
 
 	if (buffer_size) {
 		/* override the default buffer sizes */
-		buffer = kmalloc (buffer_size, GFP_KERNEL);
+		buffer = kmalloc(buffer_size, GFP_KERNEL);
 		if (!buffer) {
-			dev_err (&port->dev, "%s - out of memory.\n", __func__);
+			dev_err(&port->dev, "%s - out of memory.\n", __func__);
 			return -ENOMEM;
 		}
-		kfree (port->read_urb->transfer_buffer);
+		kfree(port->read_urb->transfer_buffer);
 		port->read_urb->transfer_buffer = buffer;
 		port->read_urb->transfer_buffer_length = buffer_size;
 
-		buffer = kmalloc (buffer_size, GFP_KERNEL);
+		buffer = kmalloc(buffer_size, GFP_KERNEL);
 		if (!buffer) {
-			dev_err (&port->dev, "%s - out of memory.\n", __func__);
+			dev_err(&port->dev, "%s - out of memory.\n",
+								__func__);
 			return -ENOMEM;
 		}
-		kfree (port->write_urb->transfer_buffer);
+		kfree(port->write_urb->transfer_buffer);
 		port->write_urb->transfer_buffer = buffer;
 		port->write_urb->transfer_buffer_length = buffer_size;
 		port->bulk_out_size = buffer_size;
 	}
 
 	/* Start reading from the device */
-	usb_fill_bulk_urb (
-		port->read_urb,
-		port->serial->dev, 
-		usb_rcvbulkpipe(port->serial->dev, port->bulk_in_endpointAddress),
-		port->read_urb->transfer_buffer,
-		port->read_urb->transfer_buffer_length,
-		ir_read_bulk_callback,
-		port);
+	usb_fill_bulk_urb(port->read_urb, port->serial->dev,
+			usb_rcvbulkpipe(port->serial->dev,
+						port->bulk_in_endpointAddress),
+			port->read_urb->transfer_buffer,
+			port->read_urb->transfer_buffer_length,
+			ir_read_bulk_callback, port);
 	result = usb_submit_urb(port->read_urb, GFP_KERNEL);
 	if (result)
-		dev_err(&port->dev, "%s - failed submitting read urb, error %d\n", __func__, result);
+		dev_err(&port->dev,
+			"%s - failed submitting read urb, error %d\n",
+							__func__, result);
 
 	return result;
 }
 
 static void ir_close(struct tty_struct *tty,
-			struct usb_serial_port *port, struct file * filp)
+			struct usb_serial_port *port, struct file *filp)
 {
 	dbg("%s - port %d", __func__, port->number);
-			 
+
 	/* shutdown our bulk read */
 	usb_kill_urb(port->read_urb);
 }
@@ -365,31 +396,29 @@ static int ir_write(struct tty_struct *tty, struct usb_serial_port *port,
 	*transfer_buffer = ir_xbof | ir_baud;
 	++transfer_buffer;
 
-	memcpy (transfer_buffer, buf, transfer_size);
+	memcpy(transfer_buffer, buf, transfer_size);
 
-	usb_fill_bulk_urb (
-		port->write_urb,
-		port->serial->dev,
-		usb_sndbulkpipe(port->serial->dev,
-			port->bulk_out_endpointAddress),
-		port->write_urb->transfer_buffer,
-		transfer_size + 1,
-		ir_write_bulk_callback,
-		port);
+	usb_fill_bulk_urb(port->write_urb, port->serial->dev,
+			usb_sndbulkpipe(port->serial->dev,
+				port->bulk_out_endpointAddress),
+			port->write_urb->transfer_buffer,
+			transfer_size + 1, ir_write_bulk_callback, port);
 
 	port->write_urb->transfer_flags = URB_ZERO_PACKET;
 
-	result = usb_submit_urb (port->write_urb, GFP_ATOMIC);
+	result = usb_submit_urb(port->write_urb, GFP_ATOMIC);
 	if (result) {
 		port->write_urb_busy = 0;
-		dev_err(&port->dev, "%s - failed submitting write urb, error %d\n", __func__, result);
+		dev_err(&port->dev,
+			"%s - failed submitting write urb, error %d\n",
+							__func__, result);
 	} else
 		result = transfer_size;
 
 	return result;
 }
 
-static void ir_write_bulk_callback (struct urb *urb)
+static void ir_write_bulk_callback(struct urb *urb)
 {
 	struct usb_serial_port *port = urb->context;
 	int status = urb->status;
@@ -403,17 +432,13 @@ static void ir_write_bulk_callback (struct urb *urb)
 		return;
 	}
 
-	usb_serial_debug_data (
-		debug,
-		&port->dev,
-		__func__,
-		urb->actual_length,
-		urb->transfer_buffer);
+	usb_serial_debug_data(debug, &port->dev, __func__, urb->actual_length,
+						urb->transfer_buffer);
 
 	usb_serial_port_softint(port);
 }
 
-static void ir_read_bulk_callback (struct urb *urb)
+static void ir_read_bulk_callback(struct urb *urb)
 {
 	struct usb_serial_port *port = urb->context;
 	struct tty_struct *tty;
@@ -429,64 +454,52 @@ static void ir_read_bulk_callback (struct urb *urb)
 	}
 
 	switch (status) {
-		case 0: /* Successful */
-
-			/*
-			 * The first byte of the packet we get from the device
-			 * contains a busy indicator and baud rate change.
-			 * See section 5.4.1.2 of the USB IrDA spec.
-			 */
-			if ((*data & 0x0f) > 0)
-				ir_baud = *data & 0x0f;
-
-			usb_serial_debug_data (
-				debug,
-				&port->dev,
-				__func__,
-				urb->actual_length,
-				data);
-
-			tty = port->port.tty;
-
-			if (tty_buffer_request_room(tty, urb->actual_length - 1)) {
-				tty_insert_flip_string(tty, data+1, urb->actual_length - 1);
-				tty_flip_buffer_push(tty);
-			}
-
-			/*
-			 * No break here.
-			 * We want to resubmit the urb so we can read
-			 * again.
-			 */
+	case 0: /* Successful */
+
+		/*
+		 * The first byte of the packet we get from the device
+		 * contains a busy indicator and baud rate change.
+		 * See section 5.4.1.2 of the USB IrDA spec.
+		 */
+		if ((*data & 0x0f) > 0)
+			ir_baud = *data & 0x0f;
+
+		usb_serial_debug_data(debug, &port->dev, __func__,
+					urb->actual_length, data);
+		tty = port->port.tty;
+
+		if (tty_buffer_request_room(tty, urb->actual_length - 1)) {
+			tty_insert_flip_string(tty, data + 1,
+						urb->actual_length - 1);
+			tty_flip_buffer_push(tty);
+		}
 
-		case -EPROTO: /* taking inspiration from pl2303.c */
+		/*
+		 * No break here.
+		 * We want to resubmit the urb so we can read
+		 * again.
+		 */
 
-			/* Continue trying to always read */
-			usb_fill_bulk_urb (
-				port->read_urb,
-				port->serial->dev, 
+	case -EPROTO: /* taking inspiration from pl2303.c */
+		/* Continue trying to always read */
+		usb_fill_bulk_urb(port->read_urb, port->serial->dev,
 				usb_rcvbulkpipe(port->serial->dev,
 					port->bulk_in_endpointAddress),
 				port->read_urb->transfer_buffer,
 				port->read_urb->transfer_buffer_length,
-				ir_read_bulk_callback,
-				port);
-
-			result = usb_submit_urb(port->read_urb, GFP_ATOMIC);
-			if (result)
-				dev_err(&port->dev, "%s - failed resubmitting read urb, error %d\n",
-					__func__, result);
-
-			break ;
-
-		default:
-			dbg("%s - nonzero read bulk status received: %d",
-				__func__,
-				status);
-			break ;
-
+				ir_read_bulk_callback, port);
+
+		result = usb_submit_urb(port->read_urb, GFP_ATOMIC);
+		if (result)
+			dev_err(&port->dev,
+			    "%s - failed resubmitting read urb, error %d\n",
+				__func__, result);
+		break;
+	default:
+		dbg("%s - nonzero read bulk status received: %d",
+							__func__, status);
+		break;
 	}
-
 	return;
 }
 
@@ -509,19 +522,36 @@ static void ir_set_termios(struct tty_struct *tty,
 	 */
 
 	switch (baud) {
-		case 2400:	ir_baud = SPEED_2400; break;
-		case 9600:	ir_baud = SPEED_9600; break;
-		case 19200:	ir_baud = SPEED_19200; break;
-		case 38400:	ir_baud = SPEED_38400; break;
-		case 57600:	ir_baud = SPEED_57600; break;
-		case 115200:	ir_baud = SPEED_115200; break;
-		case 576000:	ir_baud = SPEED_576000; break;
-		case 1152000:	ir_baud = SPEED_1152000; break;
-		case 4000000:	ir_baud = SPEED_4000000; break;
-			break;
-		default:
-			ir_baud = SPEED_9600;
-			baud = 9600;
+	case 2400:
+		ir_baud = SPEED_2400;
+		break;
+	case 9600:
+		ir_baud = SPEED_9600;
+		break;
+	case 19200:
+		ir_baud = SPEED_19200;
+		break;
+	case 38400:
+		ir_baud = SPEED_38400;
+		break;
+	case 57600:
+		ir_baud = SPEED_57600;
+		break;
+	case 115200:
+		ir_baud = SPEED_115200;
+		break;
+	case 576000:
+		ir_baud = SPEED_576000;
+		break;
+	case 1152000:
+		ir_baud = SPEED_1152000;
+		break;
+	case 4000000:
+		ir_baud = SPEED_4000000;
+		break;
+	default:
+		ir_baud = SPEED_9600;
+		baud = 9600;
 	}
 
 	if (xbof == -1)
@@ -537,20 +567,19 @@ static void ir_set_termios(struct tty_struct *tty,
 	transfer_buffer = port->write_urb->transfer_buffer;
 	*transfer_buffer = ir_xbof | ir_baud;
 
-	usb_fill_bulk_urb (
-		port->write_urb,
-		port->serial->dev,
-		usb_sndbulkpipe(port->serial->dev, port->bulk_out_endpointAddress),
-		port->write_urb->transfer_buffer,
-		1,
-		ir_write_bulk_callback,
-		port);
+	usb_fill_bulk_urb(port->write_urb, port->serial->dev,
+			usb_sndbulkpipe(port->serial->dev,
+					port->bulk_out_endpointAddress),
+			port->write_urb->transfer_buffer,
+			1, ir_write_bulk_callback, port);
 
 	port->write_urb->transfer_flags = URB_ZERO_PACKET;
 
-	result = usb_submit_urb (port->write_urb, GFP_KERNEL);
+	result = usb_submit_urb(port->write_urb, GFP_KERNEL);
 	if (result)
-		dev_err(&port->dev, "%s - failed submitting write urb, error %d\n", __func__, result);
+		dev_err(&port->dev,
+			"%s - failed submitting write urb, error %d\n",
+							__func__, result);
 
 	/* Only speed changes are supported */
 	tty_termios_copy_hw(tty->termios, old_termios);
@@ -558,14 +587,14 @@ static void ir_set_termios(struct tty_struct *tty,
 }
 
 
-static int __init ir_init (void)
+static int __init ir_init(void)
 {
 	int retval;
 	retval = usb_serial_register(&ir_device);
 	if (retval)
 		goto failed_usb_serial_register;
 	retval = usb_register(&ir_driver);
-	if (retval) 
+	if (retval)
 		goto failed_usb_register;
 	info(DRIVER_DESC " " DRIVER_VERSION);
 	return 0;
@@ -576,10 +605,10 @@ failed_usb_serial_register:
 }
 
 
-static void __exit ir_exit (void)
+static void __exit ir_exit(void)
 {
-	usb_deregister (&ir_driver);
-	usb_serial_deregister (&ir_device);
+	usb_deregister(&ir_driver);
+	usb_serial_deregister(&ir_device);
 }
 
 

