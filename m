Return-Path: <linux-kernel-owner+w=401wt.eu-S1763414AbYFTU0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763414AbYFTU0g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760966AbYFTUTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:19:37 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35191 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760946AbYFTUTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:19:36 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 31/70] cyberjack: Coding style
To: linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 21:02:11 +0100
Message-ID: <20080620200210.1479.47644.stgit@localhost.localdomain>
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

Coding style fixups

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/usb/serial/cyberjack.c |  131 +++++++++++++++++++++-------------------
 1 files changed, 69 insertions(+), 62 deletions(-)


diff --git a/drivers/usb/serial/cyberjack.c b/drivers/usb/serial/cyberjack.c
index 546178e..b4d7235 100644
--- a/drivers/usb/serial/cyberjack.c
+++ b/drivers/usb/serial/cyberjack.c
@@ -37,7 +37,7 @@
 #include <linux/tty_flip.h>
 #include <linux/module.h>
 #include <linux/spinlock.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
 
@@ -65,7 +65,7 @@ static void cyberjack_close(struct tty_struct *tty,
 			struct usb_serial_port *port, struct file *filp);
 static int cyberjack_write(struct tty_struct *tty,
 	struct usb_serial_port *port, const unsigned char *buf, int count);
-static int cyberjack_write_room( struct tty_struct *tty);
+static int cyberjack_write_room(struct tty_struct *tty);
 static void cyberjack_read_int_callback(struct urb *urb);
 static void cyberjack_read_bulk_callback(struct urb *urb);
 static void cyberjack_write_bulk_callback(struct urb *urb);
@@ -75,7 +75,7 @@ static struct usb_device_id id_table [] = {
 	{ }			/* Terminating entry */
 };
 
-MODULE_DEVICE_TABLE (usb, id_table);
+MODULE_DEVICE_TABLE(usb, id_table);
 
 static struct usb_driver cyberjack_driver = {
 	.name =		"cyberjack",
@@ -138,20 +138,20 @@ static int cyberjack_startup(struct usb_serial *serial)
 	for (i = 0; i < serial->num_ports; ++i) {
 		int result;
 		serial->port[i]->interrupt_in_urb->dev = serial->dev;
-		result = usb_submit_urb(serial->port[i]->interrupt_in_urb, 
+		result = usb_submit_urb(serial->port[i]->interrupt_in_urb,
 					GFP_KERNEL);
 		if (result)
 			err(" usb_submit_urb(read int) failed");
 		dbg("%s - usb_submit_urb(int urb)", __func__);
 	}
 
-	return( 0 );
+	return 0;
 }
 
 static void cyberjack_shutdown(struct usb_serial *serial)
 {
 	int i;
-	
+
 	dbg("%s", __func__);
 
 	for (i = 0; i < serial->num_ports; ++i) {
@@ -161,7 +161,7 @@ static void cyberjack_shutdown(struct usb_serial *serial)
 		usb_set_serial_port_data(serial->port[i], NULL);
 	}
 }
-	
+
 static int  cyberjack_open(struct tty_struct *tty,
 			struct usb_serial_port *port, struct file *filp)
 {
@@ -171,7 +171,7 @@ static int  cyberjack_open(struct tty_struct *tty,
 
 	dbg("%s - port %d", __func__, port->number);
 
-	dbg("%s - usb_clear_halt", __func__ );
+	dbg("%s - usb_clear_halt", __func__);
 	usb_clear_halt(port->serial->dev, port->write_urb->pipe);
 
 	/* force low_latency on so that our tty_push actually forces
@@ -230,7 +230,7 @@ static int cyberjack_write(struct tty_struct *tty,
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	if( (count+priv->wrfilled) > sizeof(priv->wrbuf) ) {
+	if (count+priv->wrfilled > sizeof(priv->wrbuf)) {
 		/* To much data for buffer. Reset buffer. */
 		priv->wrfilled = 0;
 		port->write_urb_busy = 0;
@@ -239,42 +239,43 @@ static int cyberjack_write(struct tty_struct *tty,
 	}
 
 	/* Copy data */
-	memcpy (priv->wrbuf+priv->wrfilled, buf, count);
+	memcpy(priv->wrbuf + priv->wrfilled, buf, count);
 
 	usb_serial_debug_data(debug, &port->dev, __func__, count,
-		priv->wrbuf+priv->wrfilled);
+		priv->wrbuf + priv->wrfilled);
 	priv->wrfilled += count;
 
-	if( priv->wrfilled >= 3 ) {
+	if (priv->wrfilled >= 3) {
 		wrexpected = ((int)priv->wrbuf[2]<<8)+priv->wrbuf[1]+3;
 		dbg("%s - expected data: %d", __func__, wrexpected);
-	} else {
+	} else
 		wrexpected = sizeof(priv->wrbuf);
-	}
 
-	if( priv->wrfilled >= wrexpected ) {
+	if (priv->wrfilled >= wrexpected) {
 		/* We have enough data to begin transmission */
 		int length;
 
 		dbg("%s - transmitting data (frame 1)", __func__);
-		length = (wrexpected > port->bulk_out_size) ? port->bulk_out_size : wrexpected;
+		length = (wrexpected > port->bulk_out_size) ?
+					port->bulk_out_size : wrexpected;
 
-		memcpy (port->write_urb->transfer_buffer, priv->wrbuf, length );
-		priv->wrsent=length;
+		memcpy(port->write_urb->transfer_buffer, priv->wrbuf, length);
+		priv->wrsent = length;
 
 		/* set up our urb */
-		usb_fill_bulk_urb(port->write_urb, serial->dev, 
+		usb_fill_bulk_urb(port->write_urb, serial->dev,
 			      usb_sndbulkpipe(serial->dev, port->bulk_out_endpointAddress),
 			      port->write_urb->transfer_buffer, length,
-			      ((serial->type->write_bulk_callback) ? 
-			       serial->type->write_bulk_callback : 
-			       cyberjack_write_bulk_callback), 
+			      ((serial->type->write_bulk_callback) ?
+			       serial->type->write_bulk_callback :
+			       cyberjack_write_bulk_callback),
 			      port);
 
 		/* send the data out the bulk port */
 		result = usb_submit_urb(port->write_urb, GFP_ATOMIC);
 		if (result) {
-			err("%s - failed submitting write urb, error %d", __func__, result);
+			err("%s - failed submitting write urb, error %d",
+							__func__, result);
 			/* Throw away data. No better idea what to do with it. */
 			priv->wrfilled = 0;
 			priv->wrsent = 0;
@@ -283,12 +284,12 @@ static int cyberjack_write(struct tty_struct *tty,
 			return 0;
 		}
 
-		dbg("%s - priv->wrsent=%d", __func__,priv->wrsent);
-		dbg("%s - priv->wrfilled=%d", __func__,priv->wrfilled);
+		dbg("%s - priv->wrsent=%d", __func__, priv->wrsent);
+		dbg("%s - priv->wrfilled=%d", __func__, priv->wrfilled);
 
-		if( priv->wrsent>=priv->wrfilled ) {
+		if (priv->wrsent >= priv->wrfilled) {
 			dbg("%s - buffer cleaned", __func__);
-			memset( priv->wrbuf, 0, sizeof(priv->wrbuf) );
+			memset(priv->wrbuf, 0, sizeof(priv->wrbuf));
 			priv->wrfilled = 0;
 			priv->wrsent = 0;
 		}
@@ -296,8 +297,8 @@ static int cyberjack_write(struct tty_struct *tty,
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	return (count);
-} 
+	return count;
+}
 
 static int cyberjack_write_room(struct tty_struct *tty)
 {
@@ -319,10 +320,11 @@ static void cyberjack_read_int_callback(struct urb *urb)
 	if (status)
 		return;
 
-	usb_serial_debug_data(debug, &port->dev, __func__, urb->actual_length, data);
+	usb_serial_debug_data(debug, &port->dev, __func__,
+						urb->actual_length, data);
 
 	/* React only to interrupts signaling a bulk_in transfer */
-	if( (urb->actual_length == 4) && (data[0] == 0x01) ) {
+	if (urb->actual_length == 4 && data[0] == 0x01) {
 		short old_rdtodo;
 
 		/* This is a announcement of coming bulk_ins. */
@@ -332,8 +334,8 @@ static void cyberjack_read_int_callback(struct urb *urb)
 
 		old_rdtodo = priv->rdtodo;
 
-		if( (old_rdtodo+size)<(old_rdtodo) ) {
-			dbg( "To many bulk_in urbs to do." );
+		if (old_rdtodo + size < old_rdtodo) {
+			dbg("To many bulk_in urbs to do.");
 			spin_unlock(&priv->lock);
 			goto resubmit;
 		}
@@ -345,10 +347,10 @@ static void cyberjack_read_int_callback(struct urb *urb)
 
 		spin_unlock(&priv->lock);
 
-		if( !old_rdtodo ) {
+		if (!old_rdtodo) {
 			port->read_urb->dev = port->serial->dev;
 			result = usb_submit_urb(port->read_urb, GFP_ATOMIC);
-			if( result )
+			if (result)
 				err("%s - failed resubmitting read urb, error %d", __func__, result);
 			dbg("%s - usb_submit_urb(read urb)", __func__);
 		}
@@ -374,7 +376,8 @@ static void cyberjack_read_bulk_callback(struct urb *urb)
 
 	dbg("%s - port %d", __func__, port->number);
 
-	usb_serial_debug_data(debug, &port->dev, __func__, urb->actual_length, data);
+	usb_serial_debug_data(debug, &port->dev, __func__,
+						urb->actual_length, data);
 	if (status) {
 		dbg("%s - nonzero read bulk status received: %d",
 		    __func__, status);
@@ -389,15 +392,16 @@ static void cyberjack_read_bulk_callback(struct urb *urb)
 	if (urb->actual_length) {
 		tty_buffer_request_room(tty, urb->actual_length);
 		tty_insert_flip_string(tty, data, urb->actual_length);
-	  	tty_flip_buffer_push(tty);
+		tty_flip_buffer_push(tty);
 	}
 
 	spin_lock(&priv->lock);
 
 	/* Reduce urbs to do by one. */
-	priv->rdtodo-=urb->actual_length;
+	priv->rdtodo -= urb->actual_length;
 	/* Just to be sure */
-	if ( priv->rdtodo<0 ) priv->rdtodo = 0;
+	if (priv->rdtodo < 0)
+		priv->rdtodo = 0;
 	todo = priv->rdtodo;
 
 	spin_unlock(&priv->lock);
@@ -405,11 +409,12 @@ static void cyberjack_read_bulk_callback(struct urb *urb)
 	dbg("%s - rdtodo: %d", __func__, todo);
 
 	/* Continue to read if we have still urbs to do. */
-	if( todo /* || (urb->actual_length==port->bulk_in_endpointAddress)*/ ) {
+	if (todo /* || (urb->actual_length==port->bulk_in_endpointAddress)*/) {
 		port->read_urb->dev = port->serial->dev;
 		result = usb_submit_urb(port->read_urb, GFP_ATOMIC);
 		if (result)
-			err("%s - failed resubmitting read urb, error %d", __func__, result);
+			err("%s - failed resubmitting read urb, error %d",
+				__func__, result);
 		dbg("%s - usb_submit_urb(read urb)", __func__);
 	}
 }
@@ -432,7 +437,7 @@ static void cyberjack_write_bulk_callback(struct urb *urb)
 	spin_lock(&priv->lock);
 
 	/* only do something if we have more data to send */
-	if( priv->wrfilled ) {
+	if (priv->wrfilled) {
 		int length, blksize, result;
 
 		dbg("%s - transmitting data (frame n)", __func__);
@@ -440,37 +445,39 @@ static void cyberjack_write_bulk_callback(struct urb *urb)
 		length = ((priv->wrfilled - priv->wrsent) > port->bulk_out_size) ?
 			port->bulk_out_size : (priv->wrfilled - priv->wrsent);
 
-		memcpy (port->write_urb->transfer_buffer, priv->wrbuf + priv->wrsent,
-			length );
-		priv->wrsent+=length;
+		memcpy(port->write_urb->transfer_buffer,
+					priv->wrbuf + priv->wrsent, length);
+		priv->wrsent += length;
 
 		/* set up our urb */
-		usb_fill_bulk_urb(port->write_urb, port->serial->dev, 
+		usb_fill_bulk_urb(port->write_urb, port->serial->dev,
 			      usb_sndbulkpipe(port->serial->dev, port->bulk_out_endpointAddress),
 			      port->write_urb->transfer_buffer, length,
-			      ((port->serial->type->write_bulk_callback) ? 
-			       port->serial->type->write_bulk_callback : 
-			       cyberjack_write_bulk_callback), 
+			      ((port->serial->type->write_bulk_callback) ?
+			       port->serial->type->write_bulk_callback :
+			       cyberjack_write_bulk_callback),
 			      port);
 
 		/* send the data out the bulk port */
 		result = usb_submit_urb(port->write_urb, GFP_ATOMIC);
 		if (result) {
-			err("%s - failed submitting write urb, error %d", __func__, result);
+			err("%s - failed submitting write urb, error %d",
+								__func__, result);
 			/* Throw away data. No better idea what to do with it. */
 			priv->wrfilled = 0;
 			priv->wrsent = 0;
 			goto exit;
 		}
 
-		dbg("%s - priv->wrsent=%d", __func__,priv->wrsent);
-		dbg("%s - priv->wrfilled=%d", __func__,priv->wrfilled);
+		dbg("%s - priv->wrsent=%d", __func__, priv->wrsent);
+		dbg("%s - priv->wrfilled=%d", __func__, priv->wrfilled);
 
 		blksize = ((int)priv->wrbuf[2]<<8)+priv->wrbuf[1]+3;
 
-		if( (priv->wrsent>=priv->wrfilled) || (priv->wrsent>=blksize) ) {
+		if (priv->wrsent >= priv->wrfilled ||
+					priv->wrsent >= blksize) {
 			dbg("%s - buffer cleaned", __func__);
-			memset( priv->wrbuf, 0, sizeof(priv->wrbuf) );
+			memset(priv->wrbuf, 0, sizeof(priv->wrbuf));
 			priv->wrfilled = 0;
 			priv->wrsent = 0;
 		}
@@ -481,14 +488,14 @@ exit:
 	usb_serial_port_softint(port);
 }
 
-static int __init cyberjack_init (void)
+static int __init cyberjack_init(void)
 {
 	int retval;
 	retval  = usb_serial_register(&cyberjack_device);
 	if (retval)
 		goto failed_usb_serial_register;
 	retval = usb_register(&cyberjack_driver);
-	if (retval) 
+	if (retval)
 		goto failed_usb_register;
 
 	info(DRIVER_VERSION " " DRIVER_AUTHOR);
@@ -501,18 +508,18 @@ failed_usb_serial_register:
 	return retval;
 }
 
-static void __exit cyberjack_exit (void)
+static void __exit cyberjack_exit(void)
 {
-	usb_deregister (&cyberjack_driver);
-	usb_serial_deregister (&cyberjack_device);
+	usb_deregister(&cyberjack_driver);
+	usb_serial_deregister(&cyberjack_device);
 }
 
 module_init(cyberjack_init);
 module_exit(cyberjack_exit);
 
-MODULE_AUTHOR( DRIVER_AUTHOR );
-MODULE_DESCRIPTION( DRIVER_DESC );
-MODULE_VERSION( DRIVER_VERSION );
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_VERSION(DRIVER_VERSION);
 MODULE_LICENSE("GPL");
 
 module_param(debug, bool, S_IRUGO | S_IWUSR);

