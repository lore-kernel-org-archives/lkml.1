Return-Path: <linux-kernel-owner+w=401wt.eu-S932662AbYFTUmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932662AbYFTUmd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762745AbYFTUYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:24:24 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58357 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762737AbYFTUYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:24:22 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 66/70] tty-usb-omninet: Coding style
To: linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 21:06:57 +0100
Message-ID: <20080620200654.1479.84277.stgit@localhost.localdomain>
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

 drivers/usb/serial/omninet.c |  160 +++++++++++++++++++++++-------------------
 1 files changed, 87 insertions(+), 73 deletions(-)


diff --git a/drivers/usb/serial/omninet.c b/drivers/usb/serial/omninet.c
index 5a2d045..5a76f32 100644
--- a/drivers/usb/serial/omninet.c
+++ b/drivers/usb/serial/omninet.c
@@ -5,26 +5,28 @@
  *	modify it under the terms of the GNU General Public License version
  *	2 as published by the Free Software Foundation.
  *
- * See Documentation/usb/usb-serial.txt for more information on using this driver
+ * See Documentation/usb/usb-serial.txt for more information on using this
+ * driver
  *
  * Please report both successes and troubles to the author at omninet@kroah.com
- * 
+ *
  * (05/30/2001) gkh
- *	switched from using spinlock to a semaphore, which fixes lots of problems.
+ *	switched from using spinlock to a semaphore, which fixes lots of
+ *	problems.
  *
  * (04/08/2001) gb
  *	Identify version on module load.
  *
  * (11/01/2000) Adam J. Richter
  *	usb_device_id table support
- * 
+ *
  * (10/05/2000) gkh
  *	Fixed bug with urb->dev not being set properly, now that the usb
  *	core needs it.
- * 
+ *
  * (08/28/2000) gkh
  *	Added locks for SMP safeness.
- *	Fixed MOD_INC and MOD_DEC logic and the ability to open a port more 
+ *	Fixed MOD_INC and MOD_DEC logic and the ability to open a port more
  *	than once.
  *	Fixed potential race in omninet_write_bulk_callback
  *
@@ -43,7 +45,7 @@
 #include <linux/tty_flip.h>
 #include <linux/module.h>
 #include <linux/spinlock.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
 
@@ -58,25 +60,29 @@ static int debug;
 
 #define ZYXEL_VENDOR_ID		0x0586
 #define ZYXEL_OMNINET_ID	0x1000
-#define BT_IGNITIONPRO_ID	0x2000  /* This one seems to be a re-branded ZyXEL device */
+/* This one seems to be a re-branded ZyXEL device */
+#define BT_IGNITIONPRO_ID	0x2000
 
 /* function prototypes */
-static int  omninet_open		(struct tty_struct *tty, struct usb_serial_port *port, struct file *filp);
-static void omninet_close		(struct tty_struct *tty, struct usb_serial_port *port, struct file *filp);
-static void omninet_read_bulk_callback	(struct urb *urb);
-static void omninet_write_bulk_callback	(struct urb *urb);
-static int  omninet_write		(struct tty_struct *tty, struct usb_serial_port *port, const unsigned char *buf, int count);
-static int  omninet_write_room		(struct tty_struct *tty);
-static void omninet_shutdown		(struct usb_serial *serial);
-static int omninet_attach		(struct usb_serial *serial);
-
-static struct usb_device_id id_table [] = {
+static int  omninet_open(struct tty_struct *tty, struct usb_serial_port *port,
+							struct file *filp);
+static void omninet_close(struct tty_struct *tty, struct usb_serial_port *port,
+							struct file *filp);
+static void omninet_read_bulk_callback(struct urb *urb);
+static void omninet_write_bulk_callback(struct urb *urb);
+static int  omninet_write(struct tty_struct *tty, struct usb_serial_port *port,
+				const unsigned char *buf, int count);
+static int  omninet_write_room(struct tty_struct *tty);
+static void omninet_shutdown(struct usb_serial *serial);
+static int omninet_attach(struct usb_serial *serial);
+
+static struct usb_device_id id_table[] = {
 	{ USB_DEVICE(ZYXEL_VENDOR_ID, ZYXEL_OMNINET_ID) },
 	{ USB_DEVICE(ZYXEL_VENDOR_ID, BT_IGNITIONPRO_ID) },
 	{ }						/* Terminating entry */
 };
 
-MODULE_DEVICE_TABLE (usb, id_table);
+MODULE_DEVICE_TABLE(usb, id_table);
 
 static struct usb_driver omninet_driver = {
 	.name =		"omninet",
@@ -130,27 +136,26 @@ static struct usb_serial_driver zyxel_omninet_device = {
  *
  */
 
-struct omninet_header
-{
+struct omninet_header {
 	__u8	oh_seq;
 	__u8	oh_len;
 	__u8	oh_xxx;
 	__u8	oh_pad;
 };
 
-struct omninet_data
-{
-	__u8	od_outseq;	// Sequence number for bulk_out URBs
+struct omninet_data {
+	__u8	od_outseq;	/* Sequence number for bulk_out URBs */
 };
 
-static int omninet_attach (struct usb_serial *serial)
+static int omninet_attach(struct usb_serial *serial)
 {
 	struct omninet_data *od;
 	struct usb_serial_port *port = serial->port[0];
 
-	od = kmalloc( sizeof(struct omninet_data), GFP_KERNEL );
-	if( !od ) {
-		err("%s- kmalloc(%Zd) failed.", __func__, sizeof(struct omninet_data));
+	od = kmalloc(sizeof(struct omninet_data), GFP_KERNEL);
+	if (!od) {
+		err("%s- kmalloc(%Zd) failed.",
+				__func__, sizeof(struct omninet_data));
 		return -ENOMEM;
 	}
 	usb_set_serial_port_data(port, od);
@@ -170,20 +175,21 @@ static int omninet_open(struct tty_struct *tty,
 	wport->port.tty = tty;		/* FIXME */
 
 	/* Start reading from the device */
-	usb_fill_bulk_urb(port->read_urb, serial->dev, 
-		      usb_rcvbulkpipe(serial->dev, port->bulk_in_endpointAddress),
-		      port->read_urb->transfer_buffer, port->read_urb->transfer_buffer_length,
-		      omninet_read_bulk_callback, port);
+	usb_fill_bulk_urb(port->read_urb, serial->dev,
+			usb_rcvbulkpipe(serial->dev,
+				port->bulk_in_endpointAddress),
+			port->read_urb->transfer_buffer,
+			port->read_urb->transfer_buffer_length,
+			omninet_read_bulk_callback, port);
 	result = usb_submit_urb(port->read_urb, GFP_KERNEL);
-	if (result) {
-		err("%s - failed submitting read urb, error %d", __func__, result);
-	}
-
+	if (result)
+		err("%s - failed submitting read urb, error %d",
+							__func__, result);
 	return result;
 }
 
 static void omninet_close(struct tty_struct *tty,
-			struct usb_serial_port *port, struct file * filp)
+			struct usb_serial_port *port, struct file *filp)
 {
 	dbg("%s - port %d", __func__, port->number);
 	usb_kill_urb(port->read_urb);
@@ -194,7 +200,7 @@ static void omninet_close(struct tty_struct *tty,
 #define OMNINET_HEADERLEN	sizeof(struct omninet_header)
 #define OMNINET_BULKOUTSIZE 	(64 - OMNINET_HEADERLEN)
 
-static void omninet_read_bulk_callback (struct urb *urb)
+static void omninet_read_bulk_callback(struct urb *urb)
 {
 	struct usb_serial_port 	*port 	= urb->context;
 	unsigned char 		*data 	= urb->transfer_buffer;
@@ -211,31 +217,34 @@ static void omninet_read_bulk_callback (struct urb *urb)
 		return;
 	}
 
-	if ((debug) && (header->oh_xxx != 0x30)) {
+	if (debug && header->oh_xxx != 0x30) {
 		if (urb->actual_length) {
-			printk (KERN_DEBUG __FILE__ ": omninet_read %d: ", header->oh_len);
-			for (i = 0; i < (header->oh_len + OMNINET_HEADERLEN); i++) {
-				printk ("%.2x ", data[i]);
-			}
-			printk ("\n");
+			printk(KERN_DEBUG __FILE__
+					": omninet_read %d: ", header->oh_len);
+			for (i = 0; i < (header->oh_len +
+						OMNINET_HEADERLEN); i++)
+				printk("%.2x ", data[i]);
+			printk("\n");
 		}
 	}
 
 	if (urb->actual_length && header->oh_len) {
-		for (i = 0; i < header->oh_len; i++) {
-			 tty_insert_flip_char(port->port.tty, data[OMNINET_DATAOFFSET + i], 0);
-	  	}
-	  	tty_flip_buffer_push(port->port.tty);
+		for (i = 0; i < header->oh_len; i++)
+			 tty_insert_flip_char(port->port.tty,
+					data[OMNINET_DATAOFFSET + i], 0);
+		tty_flip_buffer_push(port->port.tty);
 	}
 
 	/* Continue trying to always read  */
-	usb_fill_bulk_urb(urb, port->serial->dev, 
-		      usb_rcvbulkpipe(port->serial->dev, port->bulk_in_endpointAddress),
-		      urb->transfer_buffer, urb->transfer_buffer_length,
-		      omninet_read_bulk_callback, port);
+	usb_fill_bulk_urb(urb, port->serial->dev,
+			usb_rcvbulkpipe(port->serial->dev,
+					port->bulk_in_endpointAddress),
+			urb->transfer_buffer, urb->transfer_buffer_length,
+			omninet_read_bulk_callback, port);
 	result = usb_submit_urb(urb, GFP_ATOMIC);
 	if (result)
-		err("%s - failed resubmitting read urb, error %d", __func__, result);
+		err("%s - failed resubmitting read urb, error %d",
+						__func__, result);
 
 	return;
 }
@@ -243,11 +252,12 @@ static void omninet_read_bulk_callback (struct urb *urb)
 static int omninet_write(struct tty_struct *tty, struct usb_serial_port *port,
 					const unsigned char *buf, int count)
 {
-	struct usb_serial 	*serial	= port->serial;
-	struct usb_serial_port 	*wport	= serial->port[1];
+	struct usb_serial *serial = port->serial;
+	struct usb_serial_port *wport = serial->port[1];
 
-	struct omninet_data 	*od 	= usb_get_serial_port_data(port);
-	struct omninet_header	*header = (struct omninet_header *) wport->write_urb->transfer_buffer;
+	struct omninet_data *od = usb_get_serial_port_data(port);
+	struct omninet_header *header = (struct omninet_header *)
+					wport->write_urb->transfer_buffer;
 
 	int			result;
 
@@ -255,7 +265,7 @@ static int omninet_write(struct tty_struct *tty, struct usb_serial_port *port,
 
 	if (count == 0) {
 		dbg("%s - write request of 0 bytes", __func__);
-		return (0);
+		return 0;
 	}
 
 	spin_lock_bh(&wport->lock);
@@ -269,9 +279,11 @@ static int omninet_write(struct tty_struct *tty, struct usb_serial_port *port,
 
 	count = (count > OMNINET_BULKOUTSIZE) ? OMNINET_BULKOUTSIZE : count;
 
-	memcpy (wport->write_urb->transfer_buffer + OMNINET_DATAOFFSET, buf, count);
+	memcpy(wport->write_urb->transfer_buffer + OMNINET_DATAOFFSET,
+								buf, count);
 
-	usb_serial_debug_data(debug, &port->dev, __func__, count, wport->write_urb->transfer_buffer);
+	usb_serial_debug_data(debug, &port->dev, __func__, count,
+					wport->write_urb->transfer_buffer);
 
 	header->oh_seq 	= od->od_outseq++;
 	header->oh_len 	= count;
@@ -285,7 +297,8 @@ static int omninet_write(struct tty_struct *tty, struct usb_serial_port *port,
 	result = usb_submit_urb(wport->write_urb, GFP_ATOMIC);
 	if (result) {
 		wport->write_urb_busy = 0;
-		err("%s - failed submitting write urb, error %d", __func__, result);
+		err("%s - failed submitting write urb, error %d",
+							__func__, result);
 	} else
 		result = count;
 
@@ -293,7 +306,7 @@ static int omninet_write(struct tty_struct *tty, struct usb_serial_port *port,
 }
 
 
-static int omninet_write_room (struct tty_struct *tty)
+static int omninet_write_room(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	struct usb_serial 	*serial = port->serial;
@@ -307,12 +320,13 @@ static int omninet_write_room (struct tty_struct *tty)
 
 	dbg("%s - returns %d", __func__, room);
 
-	return (room);
+	return room;
 }
 
-static void omninet_write_bulk_callback (struct urb *urb)
+static void omninet_write_bulk_callback(struct urb *urb)
 {
-/*	struct omninet_header	*header = (struct omninet_header  *) urb->transfer_buffer; */
+/*	struct omninet_header	*header = (struct omninet_header  *)
+						urb->transfer_buffer; */
 	struct usb_serial_port 	*port   =  urb->context;
 	int status = urb->status;
 
@@ -329,18 +343,18 @@ static void omninet_write_bulk_callback (struct urb *urb)
 }
 
 
-static void omninet_shutdown (struct usb_serial *serial)
+static void omninet_shutdown(struct usb_serial *serial)
 {
 	struct usb_serial_port *wport = serial->port[1];
 	struct usb_serial_port *port = serial->port[0];
-	dbg ("%s", __func__);
+	dbg("%s", __func__);
 
 	usb_kill_urb(wport->write_urb);
 	kfree(usb_get_serial_port_data(port));
 }
 
 
-static int __init omninet_init (void)
+static int __init omninet_init(void)
 {
 	int retval;
 	retval = usb_serial_register(&zyxel_omninet_device);
@@ -358,18 +372,18 @@ failed_usb_serial_register:
 }
 
 
-static void __exit omninet_exit (void)
+static void __exit omninet_exit(void)
 {
-	usb_deregister (&omninet_driver);
-	usb_serial_deregister (&zyxel_omninet_device);
+	usb_deregister(&omninet_driver);
+	usb_serial_deregister(&zyxel_omninet_device);
 }
 
 
 module_init(omninet_init);
 module_exit(omninet_exit);
 
-MODULE_AUTHOR( DRIVER_AUTHOR );
-MODULE_DESCRIPTION( DRIVER_DESC );
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
 
 module_param(debug, bool, S_IRUGO | S_IWUSR);

