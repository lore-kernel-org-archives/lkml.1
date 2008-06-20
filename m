Return-Path: <linux-kernel-owner+w=401wt.eu-S1764341AbYFTUav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764341AbYFTUav (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761500AbYFTUUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:20:52 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35211 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761479AbYFTUUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:20:50 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 41/70] tty-usb-visor: Coding style
To: linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 21:03:25 +0100
Message-ID: <20080620200323.1479.86379.stgit@localhost.localdomain>
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

 drivers/usb/serial/visor.c |  340 +++++++++++++++++++++++++-------------------
 1 files changed, 191 insertions(+), 149 deletions(-)


diff --git a/drivers/usb/serial/visor.c b/drivers/usb/serial/visor.c
index 373a3c7..cf8924f 100644
--- a/drivers/usb/serial/visor.c
+++ b/drivers/usb/serial/visor.c
@@ -9,7 +9,8 @@
  *	modify it under the terms of the GNU General Public License version
  *	2 as published by the Free Software Foundation.
  *
- * See Documentation/usb/usb-serial.txt for more information on using this driver
+ * See Documentation/usb/usb-serial.txt for more information on using this
+ * driver
  *
  */
 
@@ -23,7 +24,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/spinlock.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
 #include "visor.h"
@@ -35,23 +36,29 @@
 #define DRIVER_DESC "USB HandSpring Visor / Palm OS driver"
 
 /* function prototypes for a handspring visor */
-static int  visor_open		(struct tty_struct *tty, struct usb_serial_port *port, struct file *filp);
-static void visor_close		(struct tty_struct *tty, struct usb_serial_port *port, struct file *filp);
-static int  visor_write		(struct tty_struct *tty, struct usb_serial_port *port, const unsigned char *buf, int count);
-static int  visor_write_room	(struct tty_struct *tty);
-static void visor_throttle	(struct tty_struct *tty);
-static void visor_unthrottle	(struct tty_struct *tty);
-static int  visor_probe		(struct usb_serial *serial, const struct usb_device_id *id);
+static int  visor_open(struct tty_struct *tty, struct usb_serial_port *port,
+					struct file *filp);
+static void visor_close(struct tty_struct *tty, struct usb_serial_port *port,
+					struct file *filp);
+static int  visor_write(struct tty_struct *tty, struct usb_serial_port *port,
+					const unsigned char *buf, int count);
+static int  visor_write_room(struct tty_struct *tty);
+static void visor_throttle(struct tty_struct *tty);
+static void visor_unthrottle(struct tty_struct *tty);
+static int  visor_probe(struct usb_serial *serial,
+					const struct usb_device_id *id);
 static int  visor_calc_num_ports(struct usb_serial *serial);
-static void visor_shutdown	(struct usb_serial *serial);
-static void visor_write_bulk_callback	(struct urb *urb);
-static void visor_read_bulk_callback	(struct urb *urb);
-static void visor_read_int_callback	(struct urb *urb);
-static int  clie_3_5_startup	(struct usb_serial *serial);
-static int  treo_attach		(struct usb_serial *serial);
-static int clie_5_attach (struct usb_serial *serial);
-static int palm_os_3_probe (struct usb_serial *serial, const struct usb_device_id *id);
-static int palm_os_4_probe (struct usb_serial *serial, const struct usb_device_id *id);
+static void visor_shutdown(struct usb_serial *serial);
+static void visor_write_bulk_callback(struct urb *urb);
+static void visor_read_bulk_callback(struct urb *urb);
+static void visor_read_int_callback(struct urb *urb);
+static int  clie_3_5_startup(struct usb_serial *serial);
+static int  treo_attach(struct usb_serial *serial);
+static int clie_5_attach(struct usb_serial *serial);
+static int palm_os_3_probe(struct usb_serial *serial,
+					const struct usb_device_id *id);
+static int palm_os_4_probe(struct usb_serial *serial,
+					const struct usb_device_id *id);
 
 /* Parameters that may be passed into the module. */
 static int debug;
@@ -103,13 +110,13 @@ static struct usb_device_id id_table [] = {
 		.driver_info = (kernel_ulong_t)&palm_os_4_probe },
 	{ USB_DEVICE(ACER_VENDOR_ID, ACER_S10_ID),
 		.driver_info = (kernel_ulong_t)&palm_os_4_probe },
-	{ USB_DEVICE(SAMSUNG_VENDOR_ID, SAMSUNG_SCH_I330_ID), 
+	{ USB_DEVICE(SAMSUNG_VENDOR_ID, SAMSUNG_SCH_I330_ID),
 		.driver_info = (kernel_ulong_t)&palm_os_4_probe },
-	{ USB_DEVICE(SAMSUNG_VENDOR_ID, SAMSUNG_SPH_I500_ID), 
+	{ USB_DEVICE(SAMSUNG_VENDOR_ID, SAMSUNG_SPH_I500_ID),
 		.driver_info = (kernel_ulong_t)&palm_os_4_probe },
 	{ USB_DEVICE(TAPWAVE_VENDOR_ID, TAPWAVE_ZODIAC_ID),
 		.driver_info = (kernel_ulong_t)&palm_os_4_probe },
-	{ USB_DEVICE(GARMIN_VENDOR_ID, GARMIN_IQUE_3600_ID), 
+	{ USB_DEVICE(GARMIN_VENDOR_ID, GARMIN_IQUE_3600_ID),
 		.driver_info = (kernel_ulong_t)&palm_os_4_probe },
 	{ USB_DEVICE(ACEECA_VENDOR_ID, ACEECA_MEZ1000_ID),
 		.driver_info = (kernel_ulong_t)&palm_os_4_probe },
@@ -168,7 +175,7 @@ static struct usb_device_id id_table_combined [] = {
 	{ }					/* Terminating entry */
 };
 
-MODULE_DEVICE_TABLE (usb, id_table_combined);
+MODULE_DEVICE_TABLE(usb, id_table_combined);
 
 static struct usb_driver visor_driver = {
 	.name =		"visor",
@@ -178,7 +185,8 @@ static struct usb_driver visor_driver = {
 	.no_dynamic_id = 	1,
 };
 
-/* All of the device info needed for the Handspring Visor, and Palm 4.0 devices */
+/* All of the device info needed for the Handspring Visor,
+   and Palm 4.0 devices */
 static struct usb_serial_driver handspring_device = {
 	.driver = {
 		.owner =	THIS_MODULE,
@@ -266,7 +274,8 @@ static int stats;
 /******************************************************************************
  * Handspring Visor specific driver functions
  ******************************************************************************/
-static int visor_open (struct tty_struct *tty, struct usb_serial_port *port, struct file *filp)
+static int visor_open(struct tty_struct *tty, struct usb_serial_port *port,
+							struct file *filp)
 {
 	struct usb_serial *serial = port->serial;
 	struct visor_private *priv = usb_get_serial_port_data(port);
@@ -296,39 +305,41 @@ static int visor_open (struct tty_struct *tty, struct usb_serial_port *port, str
 		tty->low_latency = 1;
 
 	/* Start reading from the device */
-	usb_fill_bulk_urb (port->read_urb, serial->dev,
-			   usb_rcvbulkpipe (serial->dev, 
+	usb_fill_bulk_urb(port->read_urb, serial->dev,
+			   usb_rcvbulkpipe(serial->dev,
 					    port->bulk_in_endpointAddress),
 			   port->read_urb->transfer_buffer,
 			   port->read_urb->transfer_buffer_length,
 			   visor_read_bulk_callback, port);
 	result = usb_submit_urb(port->read_urb, GFP_KERNEL);
 	if (result) {
-		dev_err(&port->dev, "%s - failed submitting read urb, error %d\n",
-			__func__, result);
+		dev_err(&port->dev,
+			"%s - failed submitting read urb, error %d\n",
+							__func__, result);
 		goto exit;
 	}
-	
+
 	if (port->interrupt_in_urb) {
 		dbg("%s - adding interrupt input for treo", __func__);
 		result = usb_submit_urb(port->interrupt_in_urb, GFP_KERNEL);
 		if (result)
-			dev_err(&port->dev, "%s - failed submitting interrupt urb, error %d\n",
-				__func__, result);
+			dev_err(&port->dev,
+			    "%s - failed submitting interrupt urb, error %d\n",
+							__func__, result);
 	}
-exit:	
+exit:
 	return result;
 }
 
 
 static void visor_close(struct tty_struct *tty,
-			struct usb_serial_port *port, struct file * filp)
+			struct usb_serial_port *port, struct file *filp)
 {
 	struct visor_private *priv = usb_get_serial_port_data(port);
 	unsigned char *transfer_buffer;
 
 	dbg("%s - port %d", __func__, port->number);
-			 
+
 	/* shutdown our urbs */
 	usb_kill_urb(port->read_urb);
 	usb_kill_urb(port->interrupt_in_urb);
@@ -336,14 +347,14 @@ static void visor_close(struct tty_struct *tty,
 	mutex_lock(&port->serial->disc_mutex);
 	if (!port->serial->disconnected) {
 		/* Try to send shutdown message, unless the device is gone */
-		transfer_buffer =  kmalloc (0x12, GFP_KERNEL);
+		transfer_buffer =  kmalloc(0x12, GFP_KERNEL);
 		if (transfer_buffer) {
-			usb_control_msg (port->serial->dev,
+			usb_control_msg(port->serial->dev,
 					 usb_rcvctrlpipe(port->serial->dev, 0),
 					 VISOR_CLOSE_NOTIFICATION, 0xc2,
 					 0x0000, 0x0000,
 					 transfer_buffer, 0x12, 300);
-			kfree (transfer_buffer);
+			kfree(transfer_buffer);
 		}
 	}
 	mutex_unlock(&port->serial->disc_mutex);
@@ -375,7 +386,7 @@ static int visor_write(struct tty_struct *tty, struct usb_serial_port *port,
 	priv->outstanding_urbs++;
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	buffer = kmalloc (count, GFP_ATOMIC);
+	buffer = kmalloc(count, GFP_ATOMIC);
 	if (!buffer) {
 		dev_err(&port->dev, "out of memory\n");
 		count = -ENOMEM;
@@ -389,21 +400,22 @@ static int visor_write(struct tty_struct *tty, struct usb_serial_port *port,
 		goto error_no_urb;
 	}
 
-	memcpy (buffer, buf, count);
+	memcpy(buffer, buf, count);
 
 	usb_serial_debug_data(debug, &port->dev, __func__, count, buffer);
 
-	usb_fill_bulk_urb (urb, serial->dev,
-			   usb_sndbulkpipe (serial->dev,
+	usb_fill_bulk_urb(urb, serial->dev,
+			   usb_sndbulkpipe(serial->dev,
 					    port->bulk_out_endpointAddress),
-			   buffer, count, 
+			   buffer, count,
 			   visor_write_bulk_callback, port);
 
 	/* send it down the pipe */
 	status = usb_submit_urb(urb, GFP_ATOMIC);
 	if (status) {
-		dev_err(&port->dev, "%s - usb_submit_urb(write bulk) failed with status = %d\n",
-			__func__, status);
+		dev_err(&port->dev,
+		   "%s - usb_submit_urb(write bulk) failed with status = %d\n",
+							__func__, status);
 		count = status;
 		goto error;
 	} else {
@@ -429,7 +441,7 @@ error_no_buffer:
 }
 
 
-static int visor_write_room (struct tty_struct *tty)
+static int visor_write_room(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	struct visor_private *priv = usb_get_serial_port_data(port);
@@ -455,7 +467,7 @@ static int visor_write_room (struct tty_struct *tty)
 }
 
 
-static void visor_write_bulk_callback (struct urb *urb)
+static void visor_write_bulk_callback(struct urb *urb)
 {
 	struct usb_serial_port *port = urb->context;
 	struct visor_private *priv = usb_get_serial_port_data(port);
@@ -463,7 +475,7 @@ static void visor_write_bulk_callback (struct urb *urb)
 	unsigned long flags;
 
 	/* free up the transfer buffer, as usb_free_urb() does not do this */
-	kfree (urb->transfer_buffer);
+	kfree(urb->transfer_buffer);
 
 	dbg("%s - port %d", __func__, port->number);
 
@@ -479,7 +491,7 @@ static void visor_write_bulk_callback (struct urb *urb)
 }
 
 
-static void visor_read_bulk_callback (struct urb *urb)
+static void visor_read_bulk_callback(struct urb *urb)
 {
 	struct usb_serial_port *port = urb->context;
 	struct visor_private *priv = usb_get_serial_port_data(port);
@@ -497,11 +509,13 @@ static void visor_read_bulk_callback (struct urb *urb)
 		return;
 	}
 
-	usb_serial_debug_data(debug, &port->dev, __func__, urb->actual_length, data);
+	usb_serial_debug_data(debug, &port->dev, __func__,
+						urb->actual_length, data);
 
 	tty = port->port.tty;
 	if (tty && urb->actual_length) {
-		available_room = tty_buffer_request_room(tty, urb->actual_length);
+		available_room = tty_buffer_request_room(tty,
+							urb->actual_length);
 		if (available_room) {
 			tty_insert_flip_string(tty, data, available_room);
 			tty_flip_buffer_push(tty);
@@ -515,22 +529,23 @@ static void visor_read_bulk_callback (struct urb *urb)
 
 	/* Continue trying to always read if we should */
 	if (!priv->throttled) {
-		usb_fill_bulk_urb (port->read_urb, port->serial->dev,
+		usb_fill_bulk_urb(port->read_urb, port->serial->dev,
 				   usb_rcvbulkpipe(port->serial->dev,
-						   port->bulk_in_endpointAddress),
+					   port->bulk_in_endpointAddress),
 				   port->read_urb->transfer_buffer,
 				   port->read_urb->transfer_buffer_length,
 				   visor_read_bulk_callback, port);
 		result = usb_submit_urb(port->read_urb, GFP_ATOMIC);
 		if (result)
-			dev_err(&port->dev, "%s - failed resubmitting read urb, error %d\n", __func__, result);
-	} else {
+			dev_err(&port->dev,
+			    "%s - failed resubmitting read urb, error %d\n",
+							__func__, result);
+	} else
 		priv->actually_throttled = 1;
-	}
 	spin_unlock(&priv->lock);
 }
 
-static void visor_read_int_callback (struct urb *urb)
+static void visor_read_int_callback(struct urb *urb)
 {
 	struct usb_serial_port *port = urb->context;
 	int status = urb->status;
@@ -564,13 +579,14 @@ static void visor_read_int_callback (struct urb *urb)
 			      urb->actual_length, urb->transfer_buffer);
 
 exit:
-	result = usb_submit_urb (urb, GFP_ATOMIC);
+	result = usb_submit_urb(urb, GFP_ATOMIC);
 	if (result)
-		dev_err(&urb->dev->dev, "%s - Error %d submitting interrupt urb\n",
-			__func__, result);
+		dev_err(&urb->dev->dev,
+				"%s - Error %d submitting interrupt urb\n",
+							__func__, result);
 }
 
-static void visor_throttle (struct tty_struct *tty)
+static void visor_throttle(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	struct visor_private *priv = usb_get_serial_port_data(port);
@@ -583,7 +599,7 @@ static void visor_throttle (struct tty_struct *tty)
 }
 
 
-static void visor_unthrottle (struct tty_struct *tty)
+static void visor_unthrottle(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	struct visor_private *priv = usb_get_serial_port_data(port);
@@ -599,10 +615,13 @@ static void visor_unthrottle (struct tty_struct *tty)
 	port->read_urb->dev = port->serial->dev;
 	result = usb_submit_urb(port->read_urb, GFP_ATOMIC);
 	if (result)
-		dev_err(&port->dev, "%s - failed submitting read urb, error %d\n", __func__, result);
+		dev_err(&port->dev,
+			"%s - failed submitting read urb, error %d\n",
+							__func__, result);
 }
 
-static int palm_os_3_probe (struct usb_serial *serial, const struct usb_device_id *id)
+static int palm_os_3_probe(struct usb_serial *serial,
+						const struct usb_device_id *id)
 {
 	struct device *dev = &serial->dev->dev;
 	struct visor_connection_info *connection_info;
@@ -614,7 +633,7 @@ static int palm_os_3_probe (struct usb_serial *serial, const struct usb_device_i
 
 	dbg("%s", __func__);
 
-	transfer_buffer = kmalloc (sizeof (*connection_info), GFP_KERNEL);
+	transfer_buffer = kmalloc(sizeof(*connection_info), GFP_KERNEL);
 	if (!transfer_buffer) {
 		dev_err(dev, "%s - kmalloc(%Zd) failed.\n", __func__,
 			sizeof(*connection_info));
@@ -622,7 +641,7 @@ static int palm_os_3_probe (struct usb_serial *serial, const struct usb_device_i
 	}
 
 	/* send a get connection info request */
-	retval = usb_control_msg (serial->dev,
+	retval = usb_control_msg(serial->dev,
 				  usb_rcvctrlpipe(serial->dev, 0),
 				  VISOR_GET_CONNECTION_INFORMATION,
 				  0xc2, 0x0000, 0x0000, transfer_buffer,
@@ -634,29 +653,31 @@ static int palm_os_3_probe (struct usb_serial *serial, const struct usb_device_i
 	}
 
 	if (retval == sizeof(*connection_info)) {
-	        connection_info = (struct visor_connection_info *)transfer_buffer;
+			connection_info = (struct visor_connection_info *)
+							transfer_buffer;
 
 		num_ports = le16_to_cpu(connection_info->num_ports);
 		for (i = 0; i < num_ports; ++i) {
-			switch (connection_info->connections[i].port_function_id) {
-				case VISOR_FUNCTION_GENERIC:
-					string = "Generic";
-					break;
-				case VISOR_FUNCTION_DEBUGGER:
-					string = "Debugger";
-					break;
-				case VISOR_FUNCTION_HOTSYNC:
-					string = "HotSync";
-					break;
-				case VISOR_FUNCTION_CONSOLE:
-					string = "Console";
-					break;
-				case VISOR_FUNCTION_REMOTE_FILE_SYS:
-					string = "Remote File System";
-					break;
-				default:
-					string = "unknown";
-					break;
+			switch (
+			   connection_info->connections[i].port_function_id) {
+			case VISOR_FUNCTION_GENERIC:
+				string = "Generic";
+				break;
+			case VISOR_FUNCTION_DEBUGGER:
+				string = "Debugger";
+				break;
+			case VISOR_FUNCTION_HOTSYNC:
+				string = "HotSync";
+				break;
+			case VISOR_FUNCTION_CONSOLE:
+				string = "Console";
+				break;
+			case VISOR_FUNCTION_REMOTE_FILE_SYS:
+				string = "Remote File System";
+				break;
+			default:
+				string = "unknown";
+				break;
 			}
 			dev_info(dev, "%s: port %d, is for %s use\n",
 				serial->type->description,
@@ -667,11 +688,11 @@ static int palm_os_3_probe (struct usb_serial *serial, const struct usb_device_i
 	* Handle devices that report invalid stuff here.
 	*/
 	if (num_ports == 0 || num_ports > 2) {
-		dev_warn (dev, "%s: No valid connect info available\n",
+		dev_warn(dev, "%s: No valid connect info available\n",
 			serial->type->description);
 		num_ports = 2;
 	}
-  
+
 	dev_info(dev, "%s: Number of ports: %d\n", serial->type->description,
 		num_ports);
 
@@ -681,8 +702,9 @@ static int palm_os_3_probe (struct usb_serial *serial, const struct usb_device_i
 	 */
 	usb_set_serial_data(serial, (void *)(long)num_ports);
 
-	/* ask for the number of bytes available, but ignore the response as it is broken */
-	retval = usb_control_msg (serial->dev,
+	/* ask for the number of bytes available, but ignore the
+	   response as it is broken */
+	retval = usb_control_msg(serial->dev,
 				  usb_rcvctrlpipe(serial->dev, 0),
 				  VISOR_REQUEST_BYTES_AVAILABLE,
 				  0xc2, 0x0000, 0x0005, transfer_buffer,
@@ -693,12 +715,13 @@ static int palm_os_3_probe (struct usb_serial *serial, const struct usb_device_i
 	retval = 0;
 
 exit:
-	kfree (transfer_buffer);
+	kfree(transfer_buffer);
 
 	return retval;
 }
 
-static int palm_os_4_probe (struct usb_serial *serial, const struct usb_device_id *id)
+static int palm_os_4_probe(struct usb_serial *serial,
+						const struct usb_device_id *id)
 {
 	struct device *dev = &serial->dev->dev;
 	struct palm_ext_connection_info *connection_info;
@@ -707,18 +730,18 @@ static int palm_os_4_probe (struct usb_serial *serial, const struct usb_device_i
 
 	dbg("%s", __func__);
 
-	transfer_buffer =  kmalloc (sizeof (*connection_info), GFP_KERNEL);
+	transfer_buffer =  kmalloc(sizeof(*connection_info), GFP_KERNEL);
 	if (!transfer_buffer) {
 		dev_err(dev, "%s - kmalloc(%Zd) failed.\n", __func__,
 			sizeof(*connection_info));
 		return -ENOMEM;
 	}
 
-	retval = usb_control_msg (serial->dev,
-				  usb_rcvctrlpipe(serial->dev, 0), 
+	retval = usb_control_msg(serial->dev,
+				  usb_rcvctrlpipe(serial->dev, 0),
 				  PALM_GET_EXT_CONNECTION_INFORMATION,
 				  0xc2, 0x0000, 0x0000, transfer_buffer,
-				  sizeof (*connection_info), 300);
+				  sizeof(*connection_info), 300);
 	if (retval < 0)
 		dev_err(dev, "%s - error %d getting connection info\n",
 			__func__, retval);
@@ -726,15 +749,17 @@ static int palm_os_4_probe (struct usb_serial *serial, const struct usb_device_i
 		usb_serial_debug_data(debug, &serial->dev->dev, __func__,
 				      retval, transfer_buffer);
 
-	kfree (transfer_buffer);
+	kfree(transfer_buffer);
 	return 0;
 }
 
 
-static int visor_probe (struct usb_serial *serial, const struct usb_device_id *id)
+static int visor_probe(struct usb_serial *serial,
+					const struct usb_device_id *id)
 {
 	int retval = 0;
-	int (*startup) (struct usb_serial *serial, const struct usb_device_id *id);
+	int (*startup)(struct usb_serial *serial,
+					const struct usb_device_id *id);
 
 	dbg("%s", __func__);
 
@@ -752,7 +777,7 @@ static int visor_probe (struct usb_serial *serial, const struct usb_device_id *i
 	return retval;
 }
 
-static int visor_calc_num_ports (struct usb_serial *serial)
+static int visor_calc_num_ports(struct usb_serial *serial)
 {
 	int num_ports = (int)(long)(usb_get_serial_data(serial));
 
@@ -769,7 +794,7 @@ static int generic_startup(struct usb_serial *serial)
 	int i;
 
 	for (i = 0; i < serial->num_ports; ++i) {
-		priv = kzalloc (sizeof(*priv), GFP_KERNEL);
+		priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 		if (!priv) {
 			while (i-- != 0) {
 				priv = usb_get_serial_port_data(ports[i]);
@@ -784,7 +809,7 @@ static int generic_startup(struct usb_serial *serial)
 	return 0;
 }
 
-static int clie_3_5_startup (struct usb_serial *serial)
+static int clie_3_5_startup(struct usb_serial *serial)
 {
 	struct device *dev = &serial->dev->dev;
 	int result;
@@ -797,62 +822,72 @@ static int clie_3_5_startup (struct usb_serial *serial)
 	 */
 
 	/* get the config number */
-	result = usb_control_msg (serial->dev, usb_rcvctrlpipe(serial->dev, 0),
+	result = usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
 				  USB_REQ_GET_CONFIGURATION, USB_DIR_IN,
 				  0, 0, &data, 1, 3000);
 	if (result < 0) {
-		dev_err(dev, "%s: get config number failed: %d\n", __func__, result);
+		dev_err(dev, "%s: get config number failed: %d\n",
+							__func__, result);
 		return result;
 	}
 	if (result != 1) {
-		dev_err(dev, "%s: get config number bad return length: %d\n", __func__, result);
+		dev_err(dev, "%s: get config number bad return length: %d\n",
+							__func__, result);
 		return -EIO;
 	}
 
 	/* get the interface number */
-	result = usb_control_msg (serial->dev, usb_rcvctrlpipe(serial->dev, 0),
-				  USB_REQ_GET_INTERFACE, 
+	result = usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
+				  USB_REQ_GET_INTERFACE,
 				  USB_DIR_IN | USB_RECIP_INTERFACE,
 				  0, 0, &data, 1, 3000);
 	if (result < 0) {
-		dev_err(dev, "%s: get interface number failed: %d\n", __func__, result);
+		dev_err(dev, "%s: get interface number failed: %d\n",
+							__func__, result);
 		return result;
 	}
 	if (result != 1) {
-		dev_err(dev, "%s: get interface number bad return length: %d\n", __func__, result);
+		dev_err(dev,
+			"%s: get interface number bad return length: %d\n",
+							__func__, result);
 		return -EIO;
 	}
 
 	return generic_startup(serial);
 }
- 
-static int treo_attach (struct usb_serial *serial)
+
+static int treo_attach(struct usb_serial *serial)
 {
 	struct usb_serial_port *swap_port;
 
 	/* Only do this endpoint hack for the Handspring devices with
 	 * interrupt in endpoints, which for now are the Treo devices. */
-	if (!((le16_to_cpu(serial->dev->descriptor.idVendor) == HANDSPRING_VENDOR_ID) ||
-	      (le16_to_cpu(serial->dev->descriptor.idVendor) == KYOCERA_VENDOR_ID)) ||
-	    (serial->num_interrupt_in == 0))
+	if (!((le16_to_cpu(serial->dev->descriptor.idVendor)
+						== HANDSPRING_VENDOR_ID) ||
+		(le16_to_cpu(serial->dev->descriptor.idVendor)
+						== KYOCERA_VENDOR_ID)) ||
+		(serial->num_interrupt_in == 0))
 		goto generic_startup;
 
 	dbg("%s", __func__);
 
 	/*
-	* It appears that Treos and Kyoceras want to use the 
-	* 1st bulk in endpoint to communicate with the 2nd bulk out endpoint, 
-	* so let's swap the 1st and 2nd bulk in and interrupt endpoints.  
-	* Note that swapping the bulk out endpoints would break lots of 
+	* It appears that Treos and Kyoceras want to use the
+	* 1st bulk in endpoint to communicate with the 2nd bulk out endpoint,
+	* so let's swap the 1st and 2nd bulk in and interrupt endpoints.
+	* Note that swapping the bulk out endpoints would break lots of
 	* apps that want to communicate on the second port.
 	*/
 #define COPY_PORT(dest, src)						\
-	dest->read_urb = src->read_urb;					\
-	dest->bulk_in_endpointAddress = src->bulk_in_endpointAddress;	\
-	dest->bulk_in_buffer = src->bulk_in_buffer;			\
-	dest->interrupt_in_urb = src->interrupt_in_urb;			\
-	dest->interrupt_in_endpointAddress = src->interrupt_in_endpointAddress;	\
-	dest->interrupt_in_buffer = src->interrupt_in_buffer;
+	do { \
+		dest->read_urb = src->read_urb;				\
+		dest->bulk_in_endpointAddress = src->bulk_in_endpointAddress;\
+		dest->bulk_in_buffer = src->bulk_in_buffer;		\
+		dest->interrupt_in_urb = src->interrupt_in_urb;		\
+		dest->interrupt_in_endpointAddress = \
+					src->interrupt_in_endpointAddress;\
+		dest->interrupt_in_buffer = src->interrupt_in_buffer;	\
+	} while (0);
 
 	swap_port = kmalloc(sizeof(*swap_port), GFP_KERNEL);
 	if (!swap_port)
@@ -866,28 +901,30 @@ generic_startup:
 	return generic_startup(serial);
 }
 
-static int clie_5_attach (struct usb_serial *serial)
+static int clie_5_attach(struct usb_serial *serial)
 {
 	dbg("%s", __func__);
 
-	/* TH55 registers 2 ports. 
-	   Communication in from the UX50/TH55 uses bulk_in_endpointAddress from port 0 
-	   Communication out to the UX50/TH55 uses bulk_out_endpointAddress from port 1 
-	   
+	/* TH55 registers 2 ports.
+	   Communication in from the UX50/TH55 uses bulk_in_endpointAddress
+	   from port 0. Communication out to the UX50/TH55 uses
+	   bulk_out_endpointAddress from port 1
+
 	   Lets do a quick and dirty mapping
 	 */
-	
+
 	/* some sanity check */
 	if (serial->num_ports < 2)
 		return -1;
-		
+
 	/* port 0 now uses the modified endpoint Address */
-	serial->port[0]->bulk_out_endpointAddress = serial->port[1]->bulk_out_endpointAddress;
+	serial->port[0]->bulk_out_endpointAddress =
+				serial->port[1]->bulk_out_endpointAddress;
 
 	return generic_startup(serial);
 }
 
-static void visor_shutdown (struct usb_serial *serial)
+static void visor_shutdown(struct usb_serial *serial)
 {
 	struct visor_private *priv;
 	int i;
@@ -903,30 +940,35 @@ static void visor_shutdown (struct usb_serial *serial)
 	}
 }
 
-static int __init visor_init (void)
+static int __init visor_init(void)
 {
 	int i, retval;
 	/* Only if parameters were passed to us */
-	if ((vendor>0) && (product>0)) {
-		struct usb_device_id usb_dev_temp[]=
-			{{USB_DEVICE(vendor, product),
-			.driver_info = (kernel_ulong_t)&palm_os_4_probe }};
+	if (vendor > 0 && product > 0) {
+		struct usb_device_id usb_dev_temp[] = {
+			{
+				USB_DEVICE(vendor, product),
+				.driver_info =
+					(kernel_ulong_t) &palm_os_4_probe
+			}
+		};
 
 		/* Find the last entry in id_table */
-		for (i=0; ; i++) {
-			if (id_table[i].idVendor==0) {
+		for (i = 0;; i++) {
+			if (id_table[i].idVendor == 0) {
 				id_table[i] = usb_dev_temp[0];
 				break;
 			}
 		}
 		/* Find the last entry in id_table_combined */
-		for (i=0; ; i++) {
-			if (id_table_combined[i].idVendor==0) {
+		for (i = 0;; i++) {
+			if (id_table_combined[i].idVendor == 0) {
 				id_table_combined[i] = usb_dev_temp[0];
 				break;
 			}
 		}
-		info("Untested USB device specified at time of module insertion");
+		info(
+		  "Untested USB device specified at time of module insertion");
 		info("Warning: This is not guaranteed to work");
 		info("Using a newer kernel is preferred to this method");
 		info("Adding Palm OS protocol 4.x support for unknown device: 0x%x/0x%x",
@@ -942,7 +984,7 @@ static int __init visor_init (void)
 	if (retval)
 		goto failed_clie_5_register;
 	retval = usb_register(&visor_driver);
-	if (retval) 
+	if (retval)
 		goto failed_usb_register;
 	info(DRIVER_DESC);
 
@@ -960,18 +1002,18 @@ failed_handspring_register:
 
 static void __exit visor_exit (void)
 {
-	usb_deregister (&visor_driver);
-	usb_serial_deregister (&handspring_device);
-	usb_serial_deregister (&clie_3_5_device);
-	usb_serial_deregister (&clie_5_device);
+	usb_deregister(&visor_driver);
+	usb_serial_deregister(&handspring_device);
+	usb_serial_deregister(&clie_3_5_device);
+	usb_serial_deregister(&clie_5_device);
 }
 
 
 module_init(visor_init);
 module_exit(visor_exit);
 
-MODULE_AUTHOR( DRIVER_AUTHOR );
-MODULE_DESCRIPTION( DRIVER_DESC );
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
 
 module_param(debug, bool, S_IRUGO | S_IWUSR);

