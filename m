Return-Path: <linux-kernel-owner+w=401wt.eu-S1764810AbYFTUdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764810AbYFTUdA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761848AbYFTUVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:21:35 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35221 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761825AbYFTUVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:21:34 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 46/70] ipaq: Coding style
To: linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 21:04:09 +0100
Message-ID: <20080620200408.1479.93185.stgit@localhost.localdomain>
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

 drivers/usb/serial/ipaq.c |   97 ++++++++++++++++++++++++---------------------
 1 files changed, 52 insertions(+), 45 deletions(-)


diff --git a/drivers/usb/serial/ipaq.c b/drivers/usb/serial/ipaq.c
index 437982a..5f07f62 100644
--- a/drivers/usb/serial/ipaq.c
+++ b/drivers/usb/serial/ipaq.c
@@ -53,7 +53,7 @@
 #include <linux/tty_flip.h>
 #include <linux/module.h>
 #include <linux/spinlock.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
 #include "ipaq.h"
@@ -82,10 +82,10 @@ static int  ipaq_startup(struct usb_serial *serial);
 static void ipaq_shutdown(struct usb_serial *serial);
 static int ipaq_write(struct tty_struct *tty, struct usb_serial_port *port,
 			const unsigned char *buf, int count);
-static int ipaq_write_bulk(struct usb_serial_port *port, const unsigned char *buf,
-			int count);
+static int ipaq_write_bulk(struct usb_serial_port *port,
+				const unsigned char *buf, int count);
 static void ipaq_write_gather(struct usb_serial_port *port);
-static void ipaq_read_bulk_callback (struct urb *urb);
+static void ipaq_read_bulk_callback(struct urb *urb);
 static void ipaq_write_bulk_callback(struct urb *urb);
 static int ipaq_write_room(struct tty_struct *tty);
 static int ipaq_chars_in_buffer(struct tty_struct *tty);
@@ -552,7 +552,7 @@ static struct usb_device_id ipaq_id_table [] = {
 	{ }                             /* Terminating entry */
 };
 
-MODULE_DEVICE_TABLE (usb, ipaq_id_table);
+MODULE_DEVICE_TABLE(usb, ipaq_id_table);
 
 static struct usb_driver ipaq_driver = {
 	.name =		"ipaq",
@@ -615,9 +615,9 @@ static int ipaq_open(struct tty_struct *tty,
 
 	for (i = 0; i < URBDATA_QUEUE_MAX / PACKET_SIZE; i++) {
 		pkt = kmalloc(sizeof(struct ipaq_packet), GFP_KERNEL);
-		if (pkt == NULL) {
+		if (pkt == NULL)
 			goto enomem;
-		}
+
 		pkt->data = kmalloc(PACKET_SIZE, GFP_KERNEL);
 		if (pkt->data == NULL) {
 			kfree(pkt);
@@ -661,8 +661,9 @@ static int ipaq_open(struct tty_struct *tty,
 	port->read_urb->transfer_buffer = port->bulk_in_buffer;
 	port->write_urb->transfer_buffer = port->bulk_out_buffer;
 	port->read_urb->transfer_buffer_length = URBDATA_SIZE;
-	port->bulk_out_size = port->write_urb->transfer_buffer_length = URBDATA_SIZE;
-	
+	port->bulk_out_size = port->write_urb->transfer_buffer_length
+							= URBDATA_SIZE;
+
 	msleep(1000*initial_wait);
 
 	/*
@@ -691,13 +692,15 @@ static int ipaq_open(struct tty_struct *tty,
 
 	/* Start reading from the device */
 	usb_fill_bulk_urb(port->read_urb, serial->dev,
-		      usb_rcvbulkpipe(serial->dev, port->bulk_in_endpointAddress),
-		      port->read_urb->transfer_buffer, port->read_urb->transfer_buffer_length,
-		      ipaq_read_bulk_callback, port);
+		usb_rcvbulkpipe(serial->dev, port->bulk_in_endpointAddress),
+		port->read_urb->transfer_buffer,
+		port->read_urb->transfer_buffer_length,
+		ipaq_read_bulk_callback, port);
 
 	result = usb_submit_urb(port->read_urb, GFP_KERNEL);
 	if (result) {
-		err("%s - failed submitting read urb, error %d", __func__, result);
+		err("%s - failed submitting read urb, error %d",
+						__func__, result);
 		goto error;
 	}
 
@@ -719,7 +722,7 @@ static void ipaq_close(struct tty_struct *tty,
 	struct ipaq_private	*priv = usb_get_serial_port_data(port);
 
 	dbg("%s - port %d", __func__, port->number);
-			 
+
 	/*
 	 * shut down bulk read and write
 	 */
@@ -729,7 +732,8 @@ static void ipaq_close(struct tty_struct *tty,
 	kfree(priv);
 	usb_set_serial_port_data(port, NULL);
 
-	/* Uncomment the following line if you want to see some statistics in your syslog */
+	/* Uncomment the following line if you want to see some statistics
+	 * in your syslog */
 	/* info ("Bytes In = %d  Bytes Out = %d", bytes_in, bytes_out); */
 }
 
@@ -749,7 +753,8 @@ static void ipaq_read_bulk_callback(struct urb *urb)
 		return;
 	}
 
-	usb_serial_debug_data(debug, &port->dev, __func__, urb->actual_length, data);
+	usb_serial_debug_data(debug, &port->dev, __func__,
+						urb->actual_length, data);
 
 	tty = port->port.tty;
 	if (tty && urb->actual_length) {
@@ -760,13 +765,15 @@ static void ipaq_read_bulk_callback(struct urb *urb)
 	}
 
 	/* Continue trying to always read  */
-	usb_fill_bulk_urb(port->read_urb, port->serial->dev, 
-		      usb_rcvbulkpipe(port->serial->dev, port->bulk_in_endpointAddress),
-		      port->read_urb->transfer_buffer, port->read_urb->transfer_buffer_length,
-		      ipaq_read_bulk_callback, port);
+	usb_fill_bulk_urb(port->read_urb, port->serial->dev,
+	    usb_rcvbulkpipe(port->serial->dev, port->bulk_in_endpointAddress),
+	    port->read_urb->transfer_buffer,
+	    port->read_urb->transfer_buffer_length,
+	    ipaq_read_bulk_callback, port);
 	result = usb_submit_urb(port->read_urb, GFP_ATOMIC);
 	if (result)
-		err("%s - failed resubmitting read urb, error %d", __func__, result);
+		err("%s - failed resubmitting read urb, error %d",
+							__func__, result);
 	return;
 }
 
@@ -781,9 +788,8 @@ static int ipaq_write(struct tty_struct *tty, struct usb_serial_port *port,
 
 	while (count > 0) {
 		transfer_size = min(count, PACKET_SIZE);
-		if (ipaq_write_bulk(port, current_position, transfer_size)) {
+		if (ipaq_write_bulk(port, current_position, transfer_size))
 			break;
-		}
 		current_position += transfer_size;
 		bytes_sent += transfer_size;
 		count -= transfer_size;
@@ -791,10 +797,10 @@ static int ipaq_write(struct tty_struct *tty, struct usb_serial_port *port,
 	}
 
 	return bytes_sent;
-} 
+}
 
-static int ipaq_write_bulk(struct usb_serial_port *port, const unsigned char *buf,
-			   int count)
+static int ipaq_write_bulk(struct usb_serial_port *port,
+					const unsigned char *buf, int count)
 {
 	struct ipaq_private	*priv = usb_get_serial_port_data(port);
 	struct ipaq_packet	*pkt = NULL;
@@ -831,9 +837,9 @@ static int ipaq_write_bulk(struct usb_serial_port *port, const unsigned char *bu
 		ipaq_write_gather(port);
 		spin_unlock_irqrestore(&write_list_lock, flags);
 		result = usb_submit_urb(port->write_urb, GFP_ATOMIC);
-		if (result) {
-			err("%s - failed submitting write urb, error %d", __func__, result);
-		}
+		if (result)
+			err("%s - failed submitting write urb, error %d",
+				__func__, result);
 	} else {
 		spin_unlock_irqrestore(&write_list_lock, flags);
 	}
@@ -860,16 +866,15 @@ static void ipaq_write_gather(struct usb_serial_port *port)
 			list_move(&pkt->list, &priv->freelist);
 			priv->free_len += PACKET_SIZE;
 		}
-		if (room == 0) {
+		if (room == 0)
 			break;
-		}
 	}
 
 	count = URBDATA_SIZE - room;
-	usb_fill_bulk_urb(port->write_urb, serial->dev, 
-		      usb_sndbulkpipe(serial->dev, port->bulk_out_endpointAddress),
-		      port->write_urb->transfer_buffer, count, ipaq_write_bulk_callback,
-		      port);
+	usb_fill_bulk_urb(port->write_urb, serial->dev,
+		usb_sndbulkpipe(serial->dev, port->bulk_out_endpointAddress),
+		port->write_urb->transfer_buffer, count,
+		ipaq_write_bulk_callback, port);
 	return;
 }
 
@@ -894,9 +899,9 @@ static void ipaq_write_bulk_callback(struct urb *urb)
 		ipaq_write_gather(port);
 		spin_unlock_irqrestore(&write_list_lock, flags);
 		result = usb_submit_urb(port->write_urb, GFP_ATOMIC);
-		if (result) {
-			err("%s - failed submitting write urb, error %d", __func__, result);
-		}
+		if (result)
+			err("%s - failed submitting write urb, error %d",
+					__func__, result);
 	} else {
 		priv->active = 0;
 		spin_unlock_irqrestore(&write_list_lock, flags);
@@ -947,7 +952,7 @@ static int ipaq_startup(struct usb_serial *serial)
 			serial->dev->actconfig->desc.bConfigurationValue);
 		return -ENODEV;
 	}
-	return usb_reset_configuration (serial->dev);
+	return usb_reset_configuration(serial->dev);
 }
 
 static void ipaq_shutdown(struct usb_serial *serial)
@@ -960,7 +965,7 @@ static int __init ipaq_init(void)
 	int retval;
 	spin_lock_init(&write_list_lock);
 	retval = usb_serial_register(&ipaq_device);
-	if (retval) 
+	if (retval)
 		goto failed_usb_serial_register;
 	info(DRIVER_DESC " " DRIVER_VERSION);
 	if (vendor) {
@@ -970,7 +975,7 @@ static int __init ipaq_init(void)
 	retval = usb_register(&ipaq_driver);
 	if (retval)
 		goto failed_usb_register;
-		  
+
 	return 0;
 failed_usb_register:
 	usb_serial_deregister(&ipaq_device);
@@ -989,8 +994,8 @@ static void __exit ipaq_exit(void)
 module_init(ipaq_init);
 module_exit(ipaq_exit);
 
-MODULE_AUTHOR( DRIVER_AUTHOR );
-MODULE_DESCRIPTION( DRIVER_DESC );
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
 
 module_param(debug, bool, S_IRUGO | S_IWUSR);
@@ -1003,7 +1008,9 @@ module_param(product, ushort, 0);
 MODULE_PARM_DESC(product, "User specified USB idProduct");
 
 module_param(connect_retries, int, S_IRUGO|S_IWUSR);
-MODULE_PARM_DESC(connect_retries, "Maximum number of connect retries (one second each)");
+MODULE_PARM_DESC(connect_retries,
+		"Maximum number of connect retries (one second each)");
 
 module_param(initial_wait, int, S_IRUGO|S_IWUSR);
-MODULE_PARM_DESC(initial_wait, "Time to wait before attempting a connection (in seconds)");
+MODULE_PARM_DESC(initial_wait,
+		"Time to wait before attempting a connection (in seconds)");

