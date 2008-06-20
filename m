Return-Path: <linux-kernel-owner+w=401wt.eu-S1765344AbYFTUfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765344AbYFTUfq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762128AbYFTUWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:22:21 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35233 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762115AbYFTUWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:22:20 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 52/70] tty-usb-keyspan-pda: Coding style
To: linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 21:04:55 +0100
Message-ID: <20080620200451.1479.57647.stgit@localhost.localdomain>
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

 drivers/usb/serial/keyspan_pda.c |  168 +++++++++++++++++++++-----------------
 1 files changed, 95 insertions(+), 73 deletions(-)


diff --git a/drivers/usb/serial/keyspan_pda.c b/drivers/usb/serial/keyspan_pda.c
index a7538d7..928f545 100644
--- a/drivers/usb/serial/keyspan_pda.c
+++ b/drivers/usb/serial/keyspan_pda.c
@@ -10,8 +10,9 @@
  *	the Free Software Foundation; either version 2 of the License, or
  *	(at your option) any later version.
  *
- * See Documentation/usb/usb-serial.txt for more information on using this driver
- * 
+ * See Documentation/usb/usb-serial.txt for more information on using this
+ * driver
+ *
  * (09/07/2001) gkh
  *	cleaned up the Xircom support.  Added ids for Entregra device which is
  *	the same as the Xircom device.  Enabled the code to be compiled for
@@ -21,23 +22,24 @@
  *	support for Xircom PGSDB9
  *
  * (05/31/2001) gkh
- *	switched from using spinlock to a semaphore, which fixes lots of problems.
+ *	switched from using spinlock to a semaphore, which fixes lots of
+ *	problems.
  *
  * (04/08/2001) gb
  *	Identify version on module load.
- * 
+ *
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
- * 
+ *
  * (07/20/2000) borchers
  *	- keyspan_pda_write no longer sleeps if it is called on interrupt time;
  *	  PPP and the line discipline with stty echo on can call write on
@@ -55,14 +57,14 @@
  *	  than done directly from the callback to avoid the race in write_chan
  *	- keyspan_pda_chars_in_buffer also indicates its buffer is full if the
  *	  urb status is -EINPROGRESS, meaning it cannot write at the moment
- *      
+ *
  * (07/19/2000) gkh
  *	Added module_init and module_exit functions to handle the fact that this
  *	driver is a loadable module now.
  *
  * (03/26/2000) gkh
  *	Split driver up into device specific pieces.
- * 
+ *
  */
 
 
@@ -76,7 +78,7 @@
 #include <linux/module.h>
 #include <linux/spinlock.h>
 #include <linux/workqueue.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
 
@@ -88,7 +90,8 @@ struct ezusb_hex_record {
 	__u8 data[16];
 };
 
-/* make a simple define to handle if we are compiling keyspan_pda or xircom support */
+/* make a simple define to handle if we are compiling keyspan_pda
+   or xircom support */
 #if defined(CONFIG_USB_SERIAL_KEYSPAN_PDA) || defined(CONFIG_USB_SERIAL_KEYSPAN_PDA_MODULE)
 	#define KEYSPAN
 #else
@@ -147,7 +150,7 @@ static struct usb_device_id id_table_combined [] = {
 	{ }						/* Terminating entry */
 };
 
-MODULE_DEVICE_TABLE (usb, id_table_combined);
+MODULE_DEVICE_TABLE(usb, id_table_combined);
 
 static struct usb_driver keyspan_pda_driver = {
 	.name =		"keyspan_pda",
@@ -171,9 +174,9 @@ static struct usb_device_id id_table_fake [] = {
 
 #ifdef XIRCOM
 static struct usb_device_id id_table_fake_xircom [] = {
-        { USB_DEVICE(XIRCOM_VENDOR_ID, XIRCOM_FAKE_ID) },
-        { USB_DEVICE(ENTREGRA_VENDOR_ID, ENTREGRA_FAKE_ID) },
-        { }                                             
+	{ USB_DEVICE(XIRCOM_VENDOR_ID, XIRCOM_FAKE_ID) },
+	{ USB_DEVICE(ENTREGRA_VENDOR_ID, ENTREGRA_FAKE_ID) },
+	{ }
 };
 #endif
 
@@ -196,7 +199,7 @@ static void keyspan_pda_request_unthrottle(struct work_struct *work)
 	dbg(" request_unthrottle");
 	/* ask the device to tell us when the tx buffer becomes
 	   sufficiently empty */
-	result = usb_control_msg(serial->dev, 
+	result = usb_control_msg(serial->dev,
 				 usb_sndctrlpipe(serial->dev, 0),
 				 7, /* request_unthrottle */
 				 USB_TYPE_VENDOR | USB_RECIP_INTERFACE
@@ -207,15 +210,15 @@ static void keyspan_pda_request_unthrottle(struct work_struct *work)
 				 0,
 				 2000);
 	if (result < 0)
-		dbg("%s - error %d from usb_control_msg", 
+		dbg("%s - error %d from usb_control_msg",
 		    __func__, result);
 }
 
 
-static void keyspan_pda_rx_interrupt (struct urb *urb)
+static void keyspan_pda_rx_interrupt(struct urb *urb)
 {
 	struct usb_serial_port *port = urb->context;
-       	struct tty_struct *tty = port->port.tty;
+	struct tty_struct *tty = port->port.tty;
 	unsigned char *data = urb->transfer_buffer;
 	int i;
 	int retval;
@@ -240,14 +243,13 @@ static void keyspan_pda_rx_interrupt (struct urb *urb)
 		goto exit;
 	}
 
- 	/* see if the message is data or a status interrupt */
+	/* see if the message is data or a status interrupt */
 	switch (data[0]) {
 	case 0:
 		/* rest of message is rx data */
 		if (urb->actual_length) {
-			for (i = 1; i < urb->actual_length ; ++i) {
+			for (i = 1; i < urb->actual_length ; ++i)
 				tty_insert_flip_char(tty, data[i], 0);
-			}
 			tty_flip_buffer_push(tty);
 		}
 		break;
@@ -271,9 +273,9 @@ static void keyspan_pda_rx_interrupt (struct urb *urb)
 	}
 
 exit:
-	retval = usb_submit_urb (urb, GFP_ATOMIC);
+	retval = usb_submit_urb(urb, GFP_ATOMIC);
 	if (retval)
-		err ("%s - usb_submit_urb failed with result %d",
+		err("%s - usb_submit_urb failed with result %d",
 		     __func__, retval);
 }
 
@@ -304,32 +306,52 @@ static void keyspan_pda_rx_unthrottle(struct tty_struct *tty)
 }
 
 
-static speed_t keyspan_pda_setbaud (struct usb_serial *serial, speed_t baud)
+static speed_t keyspan_pda_setbaud(struct usb_serial *serial, speed_t baud)
 {
 	int rc;
 	int bindex;
 
-	switch(baud) {
-		case 110: bindex = 0; break;
-		case 300: bindex = 1; break;
-		case 1200: bindex = 2; break;
-		case 2400: bindex = 3; break;
-		case 4800: bindex = 4; break;
-		case 9600: bindex = 5; break;
-		case 19200: bindex = 6; break;
-		case 38400: bindex = 7; break;
-		case 57600: bindex = 8; break;
-		case 115200: bindex = 9; break;
-		default:
-			bindex = 5;	/* Default to 9600 */
-			baud = 9600;
+	switch (baud) {
+	case 110:
+		bindex = 0;
+		break;
+	case 300:
+		bindex = 1;
+		break;
+	case 1200:
+		bindex = 2;
+		break;
+	case 2400:
+		bindex = 3;
+		break;
+	case 4800:
+		bindex = 4;
+		break;
+	case 9600:
+		bindex = 5;
+		break;
+	case 19200:
+		bindex = 6;
+		break;
+	case 38400:
+		bindex = 7;
+		break;
+	case 57600:
+		bindex = 8;
+		break;
+	case 115200:
+		bindex = 9;
+		break;
+	default:
+		bindex = 5;	/* Default to 9600 */
+		baud = 9600;
 	}
 
 	/* rather than figure out how to sleep while waiting for this
 	   to complete, I just use the "legacy" API. */
 	rc = usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
 			     0, /* set baud */
-			     USB_TYPE_VENDOR 
+			     USB_TYPE_VENDOR
 			     | USB_RECIP_INTERFACE
 			     | USB_DIR_OUT, /* type */
 			     bindex, /* value */
@@ -355,11 +377,11 @@ static void keyspan_pda_break_ctl(struct tty_struct *tty, int break_state)
 	else
 		value = 0; /* clear break */
 	result = usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
-				4, /* set break */
-				USB_TYPE_VENDOR | USB_RECIP_INTERFACE | USB_DIR_OUT,
-				value, 0, NULL, 0, 2000);
+			4, /* set break */
+			USB_TYPE_VENDOR | USB_RECIP_INTERFACE | USB_DIR_OUT,
+			value, 0, NULL, 0, 2000);
 	if (result < 0)
-		dbg("%s - error %d from usb_control_msg", 
+		dbg("%s - error %d from usb_control_msg",
 		    __func__, result);
 	/* there is something funky about this.. the TCSBRK that 'cu' performs
 	   ought to translate into a break_ctl(-1),break_ctl(0) pair HZ/4
@@ -502,10 +524,10 @@ static int keyspan_pda_write(struct tty_struct *tty,
 	   select() or poll() too) until we receive that unthrottle interrupt.
 	   Block if we can't write anything at all, otherwise write as much as
 	   we can. */
-	dbg("keyspan_pda_write(%d)",count);
+	dbg("keyspan_pda_write(%d)", count);
 	if (count == 0) {
 		dbg(" write request of 0 bytes");
-		return (0);
+		return 0;
 	}
 
 	/* we might block because of:
@@ -532,7 +554,7 @@ static int keyspan_pda_write(struct tty_struct *tty,
 	   scheduler time, since usb_control_msg() sleeps. */
 	if (count > priv->tx_room && !in_interrupt()) {
 		unsigned char room;
-		rc = usb_control_msg(serial->dev, 
+		rc = usb_control_msg(serial->dev,
 				     usb_rcvctrlpipe(serial->dev, 0),
 				     6, /* write_room */
 				     USB_TYPE_VENDOR | USB_RECIP_INTERFACE
@@ -563,7 +585,7 @@ static int keyspan_pda_write(struct tty_struct *tty,
 
 	if (count) {
 		/* now transfer data */
-		memcpy (port->write_urb->transfer_buffer, buf, count);
+		memcpy(port->write_urb->transfer_buffer, buf, count);
 		/* send the data out the bulk port */
 		port->write_urb->transfer_buffer_length = count;
 
@@ -575,8 +597,7 @@ static int keyspan_pda_write(struct tty_struct *tty,
 			dbg(" usb_submit_urb(write bulk) failed");
 			goto exit;
 		}
-	}
-	else {
+	} else {
 		/* There wasn't any room left, so we are throttled until
 		   the buffer empties a bit */
 		request_unthrottle = 1;
@@ -595,7 +616,7 @@ exit:
 }
 
 
-static void keyspan_pda_write_bulk_callback (struct urb *urb)
+static void keyspan_pda_write_bulk_callback(struct urb *urb)
 {
 	struct usb_serial_port *port = urb->context;
 	struct keyspan_pda_private *priv;
@@ -616,7 +637,7 @@ static int keyspan_pda_write_room(struct tty_struct *tty)
 	/* used by n_tty.c for processing of tabs and such. Giving it our
 	   conservative guess is probably good enough, but needs testing by
 	   running a console through the device. */
-	return (priv->tx_room);
+	return priv->tx_room;
 }
 
 
@@ -674,7 +695,7 @@ static int keyspan_pda_open(struct tty_struct *tty,
 	/* the normal serial device seems to always turn on DTR and RTS here,
 	   so do the same */
 	if (tty && (tty->termios->c_cflag & CBAUD))
-		keyspan_pda_set_modem_info(serial, (1<<7) | (1<<2) );
+		keyspan_pda_set_modem_info(serial, (1<<7) | (1<<2));
 	else
 		keyspan_pda_set_modem_info(serial, 0);
 
@@ -697,7 +718,8 @@ static void keyspan_pda_close(struct tty_struct *tty,
 	struct usb_serial *serial = port->serial;
 
 	if (serial->dev) {
-		/* the normal serial device seems to always shut off DTR and RTS now */
+		/* the normal serial device seems to always shut
+		   off DTR and RTS now */
 		if (tty->termios->c_cflag & HUPCL)
 			keyspan_pda_set_modem_info(serial, 0);
 
@@ -709,7 +731,7 @@ static void keyspan_pda_close(struct tty_struct *tty,
 
 
 /* download the firmware to a "fake" device (pre-renumeration) */
-static int keyspan_pda_fake_startup (struct usb_serial *serial)
+static int keyspan_pda_fake_startup(struct usb_serial *serial)
 {
 	int response;
 	const struct ezusb_hex_record *record = NULL;
@@ -731,14 +753,14 @@ static int keyspan_pda_fake_startup (struct usb_serial *serial)
 		return -ENODEV;
 	}
 
-	while(record->address != 0xffff) {
+	while (record->address != 0xffff) {
 		response = ezusb_writememory(serial, record->address,
 					     (unsigned char *)record->data,
 					     record->data_size, 0xa0);
 		if (response < 0) {
 			err("ezusb_writememory failed for Keyspan PDA "
 			    "firmware (%d %04X %p %d)",
-			    response, 
+			    response,
 			    record->address, record->data, record->data_size);
 			break;
 		}
@@ -749,10 +771,10 @@ static int keyspan_pda_fake_startup (struct usb_serial *serial)
 	response = ezusb_set_reset(serial, 0);
 
 	/* we want this device to fail to have a driver assigned to it. */
-	return (1);
+	return 1;
 }
 
-static int keyspan_pda_startup (struct usb_serial *serial)
+static int keyspan_pda_startup(struct usb_serial *serial)
 {
 
 	struct keyspan_pda_private *priv;
@@ -762,20 +784,20 @@ static int keyspan_pda_startup (struct usb_serial *serial)
 
 	priv = kmalloc(sizeof(struct keyspan_pda_private), GFP_KERNEL);
 	if (!priv)
-		return (1); /* error */
+		return 1; /* error */
 	usb_set_serial_port_data(serial->port[0], priv);
 	init_waitqueue_head(&serial->port[0]->write_wait);
 	INIT_WORK(&priv->wakeup_work, keyspan_pda_wakeup_write);
 	INIT_WORK(&priv->unthrottle_work, keyspan_pda_request_unthrottle);
 	priv->serial = serial;
 	priv->port = serial->port[0];
-	return (0);
+	return 0;
 }
 
-static void keyspan_pda_shutdown (struct usb_serial *serial)
+static void keyspan_pda_shutdown(struct usb_serial *serial)
 {
 	dbg("%s", __func__);
-	
+
 	kfree(usb_get_serial_port_data(serial->port[0]));
 }
 
@@ -834,7 +856,7 @@ static struct usb_serial_driver keyspan_pda_device = {
 };
 
 
-static int __init keyspan_pda_init (void)
+static int __init keyspan_pda_init(void)
 {
 	int retval;
 	retval = usb_serial_register(&keyspan_pda_device);
@@ -855,7 +877,7 @@ static int __init keyspan_pda_init (void)
 		goto failed_usb_register;
 	info(DRIVER_DESC " " DRIVER_VERSION);
 	return 0;
-failed_usb_register:	
+failed_usb_register:
 #ifdef XIRCOM
 	usb_serial_deregister(&xircom_pgs_fake_device);
 failed_xircom_register:
@@ -872,15 +894,15 @@ failed_pda_register:
 }
 
 
-static void __exit keyspan_pda_exit (void)
+static void __exit keyspan_pda_exit(void)
 {
-	usb_deregister (&keyspan_pda_driver);
-	usb_serial_deregister (&keyspan_pda_device);
+	usb_deregister(&keyspan_pda_driver);
+	usb_serial_deregister(&keyspan_pda_device);
 #ifdef KEYSPAN
-	usb_serial_deregister (&keyspan_pda_fake_device);
+	usb_serial_deregister(&keyspan_pda_fake_device);
 #endif
 #ifdef XIRCOM
-	usb_serial_deregister (&xircom_pgs_fake_device);
+	usb_serial_deregister(&xircom_pgs_fake_device);
 #endif
 }
 
@@ -888,8 +910,8 @@ static void __exit keyspan_pda_exit (void)
 module_init(keyspan_pda_init);
 module_exit(keyspan_pda_exit);
 
-MODULE_AUTHOR( DRIVER_AUTHOR );
-MODULE_DESCRIPTION( DRIVER_DESC );
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
 
 module_param(debug, bool, S_IRUGO | S_IWUSR);

