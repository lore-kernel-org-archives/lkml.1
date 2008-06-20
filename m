Return-Path: <linux-kernel-owner+w=401wt.eu-S1764186AbYFTU3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764186AbYFTU3u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:29:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761394AbYFTUUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:20:36 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35207 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761033AbYFTUUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:20:34 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 39/70] tty-usb-generic: Code cleanup
To: linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 21:03:10 +0100
Message-ID: <20080620200308.1479.27536.stgit@localhost.localdomain>
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

 drivers/usb/serial/generic.c |   87 ++++++++++++++++++++++++------------------
 1 files changed, 49 insertions(+), 38 deletions(-)


diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index 5128018..fe84c88 100644
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -18,7 +18,7 @@
 #include <linux/moduleparam.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 
 static int debug;
@@ -81,7 +81,7 @@ static int generic_probe(struct usb_interface *interface,
 }
 #endif
 
-int usb_serial_generic_register (int _debug)
+int usb_serial_generic_register(int _debug)
 {
 	int retval = 0;
 
@@ -89,10 +89,11 @@ int usb_serial_generic_register (int _debug)
 #ifdef CONFIG_USB_SERIAL_GENERIC
 	generic_device_ids[0].idVendor = vendor;
 	generic_device_ids[0].idProduct = product;
-	generic_device_ids[0].match_flags = USB_DEVICE_ID_MATCH_VENDOR | USB_DEVICE_ID_MATCH_PRODUCT;
+	generic_device_ids[0].match_flags =
+		USB_DEVICE_ID_MATCH_VENDOR | USB_DEVICE_ID_MATCH_PRODUCT;
 
 	/* register our generic driver with ourselves */
-	retval = usb_serial_register (&usb_serial_generic_device);
+	retval = usb_serial_register(&usb_serial_generic_device);
 	if (retval)
 		goto exit;
 	retval = usb_register(&generic_driver);
@@ -103,12 +104,12 @@ exit:
 	return retval;
 }
 
-void usb_serial_generic_deregister (void)
+void usb_serial_generic_deregister(void)
 {
 #ifdef CONFIG_USB_SERIAL_GENERIC
 	/* remove our generic driver */
 	usb_deregister(&generic_driver);
-	usb_serial_deregister (&usb_serial_generic_device);
+	usb_serial_deregister(&usb_serial_generic_device);
 #endif
 }
 
@@ -121,9 +122,9 @@ int usb_serial_generic_open(struct tty_struct *tty,
 
 	dbg("%s - port %d", __func__, port->number);
 
-	/* force low_latency on so that our tty_push actually forces the data through, 
-	   otherwise it is scheduled, and with high data rates (like with OHCI) data
-	   can get lost. */
+	/* force low_latency on so that our tty_push actually forces the data
+	   through, otherwise it is scheduled, and with high data rates (like
+	   with OHCI) data can get lost. */
 	if (tty)
 		tty->low_latency = 1;
 
@@ -136,8 +137,9 @@ int usb_serial_generic_open(struct tty_struct *tty,
 	/* if we have a bulk endpoint, start reading from it */
 	if (serial->num_bulk_in) {
 		/* Start reading from the device */
-		usb_fill_bulk_urb (port->read_urb, serial->dev,
-				   usb_rcvbulkpipe(serial->dev, port->bulk_in_endpointAddress),
+		usb_fill_bulk_urb(port->read_urb, serial->dev,
+				   usb_rcvbulkpipe(serial->dev,
+						port->bulk_in_endpointAddress),
 				   port->read_urb->transfer_buffer,
 				   port->read_urb->transfer_buffer_length,
 				   ((serial->type->read_bulk_callback) ?
@@ -146,7 +148,9 @@ int usb_serial_generic_open(struct tty_struct *tty,
 				   port);
 		result = usb_submit_urb(port->read_urb, GFP_KERNEL);
 		if (result)
-			dev_err(&port->dev, "%s - failed resubmitting read urb, error %d\n", __func__, result);
+			dev_err(&port->dev,
+			    "%s - failed resubmitting read urb, error %d\n",
+							__func__, result);
 	}
 
 	return result;
@@ -194,10 +198,10 @@ int usb_serial_generic_resume(struct usb_serial *serial)
 }
 
 void usb_serial_generic_close(struct tty_struct *tty,
-			struct usb_serial_port *port, struct file * filp)
+			struct usb_serial_port *port, struct file *filp)
 {
 	dbg("%s - port %d", __func__, port->number);
-	generic_cleanup (port);
+	generic_cleanup(port);
 }
 
 int usb_serial_generic_write(struct tty_struct *tty,
@@ -211,7 +215,7 @@ int usb_serial_generic_write(struct tty_struct *tty,
 
 	if (count == 0) {
 		dbg("%s - write request of 0 bytes", __func__);
-		return (0);
+		return 0;
 	}
 
 	/* only do something if we have a bulk out endpoint */
@@ -226,27 +230,32 @@ int usb_serial_generic_write(struct tty_struct *tty,
 		port->write_urb_busy = 1;
 		spin_unlock_irqrestore(&port->lock, flags);
 
-		count = (count > port->bulk_out_size) ? port->bulk_out_size : count;
+		count = (count > port->bulk_out_size) ?
+					port->bulk_out_size : count;
 
-		memcpy (port->write_urb->transfer_buffer, buf, count);
+		memcpy(port->write_urb->transfer_buffer, buf, count);
 		data = port->write_urb->transfer_buffer;
 		usb_serial_debug_data(debug, &port->dev, __func__, count, data);
 
 		/* set up our urb */
-		usb_fill_bulk_urb (port->write_urb, serial->dev,
-				   usb_sndbulkpipe (serial->dev,
-						    port->bulk_out_endpointAddress),
+		usb_fill_bulk_urb(port->write_urb, serial->dev,
+				   usb_sndbulkpipe(serial->dev,
+					port->bulk_out_endpointAddress),
 				   port->write_urb->transfer_buffer, count,
-				   ((serial->type->write_bulk_callback) ? 
+				   ((serial->type->write_bulk_callback) ?
 				     serial->type->write_bulk_callback :
-				     usb_serial_generic_write_bulk_callback), port);
+				     usb_serial_generic_write_bulk_callback),
+				   port);
 
 		/* send the data out the bulk port */
 		port->write_urb_busy = 1;
 		result = usb_submit_urb(port->write_urb, GFP_ATOMIC);
 		if (result) {
-			dev_err(&port->dev, "%s - failed submitting write urb, error %d\n", __func__, result);
-			/* don't have to grab the lock here, as we will retry if != 0 */
+			dev_err(&port->dev,
+				"%s - failed submitting write urb, error %d\n",
+							__func__, result);
+			/* don't have to grab the lock here, as we will
+			   retry if != 0 */
 			port->write_urb_busy = 0;
 		} else
 			result = count;
@@ -258,7 +267,7 @@ int usb_serial_generic_write(struct tty_struct *tty,
 	return 0;
 }
 
-int usb_serial_generic_write_room (struct tty_struct *tty)
+int usb_serial_generic_write_room(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	struct usb_serial *serial = port->serial;
@@ -302,17 +311,19 @@ static void resubmit_read_urb(struct usb_serial_port *port, gfp_t mem_flags)
 	int result;
 
 	/* Continue reading from device */
-	usb_fill_bulk_urb (urb, serial->dev,
-			   usb_rcvbulkpipe (serial->dev,
-				   	    port->bulk_in_endpointAddress),
+	usb_fill_bulk_urb(urb, serial->dev,
+			   usb_rcvbulkpipe(serial->dev,
+					port->bulk_in_endpointAddress),
 			   urb->transfer_buffer,
 			   urb->transfer_buffer_length,
-			   ((serial->type->read_bulk_callback) ? 
-			     serial->type->read_bulk_callback : 
+			   ((serial->type->read_bulk_callback) ?
+			     serial->type->read_bulk_callback :
 			     usb_serial_generic_read_bulk_callback), port);
 	result = usb_submit_urb(urb, mem_flags);
 	if (result)
-		dev_err(&port->dev, "%s - failed resubmitting read urb, error %d\n", __func__, result);
+		dev_err(&port->dev,
+			"%s - failed resubmitting read urb, error %d\n",
+							__func__, result);
 }
 
 /* Push data to tty layer and resubmit the bulk read URB */
@@ -349,16 +360,17 @@ void usb_serial_generic_read_bulk_callback(struct urb *urb)
 		return;
 	}
 
-	usb_serial_debug_data(debug, &port->dev, __func__, urb->actual_length, data);
+	usb_serial_debug_data(debug, &port->dev, __func__,
+						urb->actual_length, data);
 
 	/* Throttle the device if requested by tty */
 	spin_lock_irqsave(&port->lock, flags);
-	if (!(port->throttled = port->throttle_req)) {
+	port->throttled = port->throttle_req;
+	if (!port->throttled) {
 		spin_unlock_irqrestore(&port->lock, flags);
 		flush_and_resubmit_read_urb(port);
-	} else {
+	} else
 		spin_unlock_irqrestore(&port->lock, flags);
-	}
 }
 EXPORT_SYMBOL_GPL(usb_serial_generic_read_bulk_callback);
 
@@ -413,15 +425,14 @@ void usb_serial_generic_unthrottle(struct tty_struct *tty)
 	}
 }
 
-void usb_serial_generic_shutdown (struct usb_serial *serial)
+void usb_serial_generic_shutdown(struct usb_serial *serial)
 {
 	int i;
 
 	dbg("%s", __func__);
 
 	/* stop reads and writes on all ports */
-	for (i=0; i < serial->num_ports; ++i) {
+	for (i = 0; i < serial->num_ports; ++i)
 		generic_cleanup(serial->port[i]);
-	}
 }
 

