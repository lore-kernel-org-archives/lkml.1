Return-Path: <linux-kernel-owner+w=401wt.eu-S1757347AbYFTUhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347AbYFTUhR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762325AbYFTUW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:22:56 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35239 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762302AbYFTUWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:22:54 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 55/70] tty-usb-kobil-sct: Coding style
To: linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 21:05:29 +0100
Message-ID: <20080620200516.1479.29824.stgit@localhost.localdomain>
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

 drivers/usb/serial/kl5kusb105.c |    4 
 drivers/usb/serial/kobil_sct.c  |  557 +++++++++++++++++++++------------------
 2 files changed, 299 insertions(+), 262 deletions(-)


diff --git a/drivers/usb/serial/kl5kusb105.c b/drivers/usb/serial/kl5kusb105.c
index d898dc4..e7e3df6 100644
--- a/drivers/usb/serial/kl5kusb105.c
+++ b/drivers/usb/serial/kl5kusb105.c
@@ -88,7 +88,7 @@ static void klsi_105_set_termios(struct tty_struct *tty,
 			struct usb_serial_port *port, struct ktermios *old);
 static void klsi_105_throttle(struct tty_struct *tty);
 static void klsi_105_unthrottle(struct tty_struct *tty);
-static int  klsi_105_tiocmget((struct tty_struct *tty, struct file *file);
+static int  klsi_105_tiocmget(struct tty_struct *tty, struct file *file);
 static int  klsi_105_tiocmset(struct tty_struct *tty, struct file *file,
 			unsigned int set, unsigned int clear);
 
@@ -433,7 +433,7 @@ static int  klsi_105_open(struct tty_struct *tty,
 	if (rc >= 0) {
 		spin_lock_irqsave(&priv->lock, flags);
 		priv->line_state = line_state;
-		spin_unlock_irqrestore*&priv->lock, flags);
+		spin_unlock_irqrestore(&priv->lock, flags);
 		dbg("%s - read line state 0x%lx", __func__, line_state);
 		retval = 0;
 	} else
diff --git a/drivers/usb/serial/kobil_sct.c b/drivers/usb/serial/kobil_sct.c
index 40c67f0..f0f8353 100644
--- a/drivers/usb/serial/kobil_sct.c
+++ b/drivers/usb/serial/kobil_sct.c
@@ -1,7 +1,7 @@
 /*
  *  KOBIL USB Smart Card Terminal Driver
  *
- *  Copyright (C) 2002  KOBIL Systems GmbH 
+ *  Copyright (C) 2002  KOBIL Systems GmbH
  *  Author: Thomas Wahrenbruch
  *
  *  Contact: linuxusb@kobil.de
@@ -20,7 +20,7 @@
  *
  * Supported readers: USB TWIN, KAAN Standard Plus and SecOVID Reader Plus
  * (Adapter K), B1 Professional and KAAN Professional (Adapter B)
- * 
+ *
  * (21/05/2004) tw
  *      Fix bug with P'n'P readers
  *
@@ -44,7 +44,7 @@
 #include <linux/tty_flip.h>
 #include <linux/module.h>
 #include <linux/spinlock.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
 #include <linux/ioctl.h>
@@ -68,13 +68,13 @@ static int debug;
 
 
 /* Function prototypes */
-static int  kobil_startup (struct usb_serial *serial);
-static void kobil_shutdown (struct usb_serial *serial);
-static int  kobil_open (struct tty_struct *tty,
+static int  kobil_startup(struct usb_serial *serial);
+static void kobil_shutdown(struct usb_serial *serial);
+static int  kobil_open(struct tty_struct *tty,
 			struct usb_serial_port *port, struct file *filp);
-static void kobil_close (struct tty_struct *tty, struct usb_serial_port *port,
+static void kobil_close(struct tty_struct *tty, struct usb_serial_port *port,
 			struct file *filp);
-static int  kobil_write (struct tty_struct *tty, struct usb_serial_port *port, 
+static int  kobil_write(struct tty_struct *tty, struct usb_serial_port *port,
 			 const unsigned char *buf, int count);
 static int  kobil_write_room(struct tty_struct *tty);
 static int  kobil_ioctl(struct tty_struct *tty, struct file *file,
@@ -82,9 +82,9 @@ static int  kobil_ioctl(struct tty_struct *tty, struct file *file,
 static int  kobil_tiocmget(struct tty_struct *tty, struct file *file);
 static int  kobil_tiocmset(struct tty_struct *tty, struct file *file,
 			   unsigned int set, unsigned int clear);
-static void kobil_read_int_callback( struct urb *urb );
-static void kobil_write_callback( struct urb *purb );
-static void kobil_set_termios(struct tty_struct *tty, 
+static void kobil_read_int_callback(struct urb *urb);
+static void kobil_write_callback(struct urb *purb);
+static void kobil_set_termios(struct tty_struct *tty,
 			struct usb_serial_port *port, struct ktermios *old);
 
 
@@ -97,7 +97,7 @@ static struct usb_device_id id_table [] = {
 };
 
 
-MODULE_DEVICE_TABLE (usb, id_table);
+MODULE_DEVICE_TABLE(usb, id_table);
 
 static struct usb_driver kobil_driver = {
 	.name =		"kobil",
@@ -134,14 +134,14 @@ static struct usb_serial_driver kobil_device = {
 struct kobil_private {
 	int write_int_endpoint_address;
 	int read_int_endpoint_address;
-	unsigned char buf[KOBIL_BUF_LENGTH]; // buffer for the APDU to send
-	int filled;  // index of the last char in buf
-	int cur_pos; // index of the next char to send in buf
+	unsigned char buf[KOBIL_BUF_LENGTH]; /* buffer for the APDU to send */
+	int filled;  /* index of the last char in buf */
+	int cur_pos; /* index of the next char to send in buf */
 	__u16 device_type;
 };
 
 
-static int kobil_startup (struct usb_serial *serial)
+static int kobil_startup(struct usb_serial *serial)
 {
 	int i;
 	struct kobil_private *priv;
@@ -152,20 +152,20 @@ static int kobil_startup (struct usb_serial *serial)
 	struct usb_host_endpoint *endpoint;
 
 	priv = kmalloc(sizeof(struct kobil_private), GFP_KERNEL);
-	if (!priv){
+	if (!priv)
 		return -ENOMEM;
-	}
 
 	priv->filled = 0;
 	priv->cur_pos = 0;
 	priv->device_type = le16_to_cpu(serial->dev->descriptor.idProduct);
 
-	switch (priv->device_type){
+	switch (priv->device_type) {
 	case KOBIL_ADAPTER_B_PRODUCT_ID:
 		printk(KERN_DEBUG "KOBIL B1 PRO / KAAN PRO detected\n");
 		break;
 	case KOBIL_ADAPTER_K_PRODUCT_ID:
-		printk(KERN_DEBUG "KOBIL KAAN Standard Plus / SecOVID Reader Plus detected\n");
+		printk(KERN_DEBUG
+		  "KOBIL KAAN Standard Plus / SecOVID Reader Plus detected\n");
 		break;
 	case KOBIL_USBTWIN_PRODUCT_ID:
 		printk(KERN_DEBUG "KOBIL USBTWIN detected\n");
@@ -176,37 +176,40 @@ static int kobil_startup (struct usb_serial *serial)
 	}
 	usb_set_serial_port_data(serial->port[0], priv);
 
-	// search for the necessary endpoints
+	/* search for the necessary endpoints */
 	pdev = serial->dev;
- 	actconfig = pdev->actconfig;
- 	interface = actconfig->interface[0];
+	actconfig = pdev->actconfig;
+	interface = actconfig->interface[0];
 	altsetting = interface->cur_altsetting;
- 	endpoint = altsetting->endpoint;
-  
- 	for (i = 0; i < altsetting->desc.bNumEndpoints; i++) {
+	endpoint = altsetting->endpoint;
+
+	for (i = 0; i < altsetting->desc.bNumEndpoints; i++) {
 		endpoint = &altsetting->endpoint[i];
 		if (usb_endpoint_is_int_out(&endpoint->desc)) {
-		 	dbg("%s Found interrupt out endpoint. Address: %d", __func__, endpoint->desc.bEndpointAddress);
-		 	priv->write_int_endpoint_address = endpoint->desc.bEndpointAddress;
- 		}
+			dbg("%s Found interrupt out endpoint. Address: %d",
+				__func__, endpoint->desc.bEndpointAddress);
+			priv->write_int_endpoint_address =
+				endpoint->desc.bEndpointAddress;
+		}
 		if (usb_endpoint_is_int_in(&endpoint->desc)) {
-		 	dbg("%s Found interrupt in  endpoint. Address: %d", __func__, endpoint->desc.bEndpointAddress);
-		 	priv->read_int_endpoint_address = endpoint->desc.bEndpointAddress;
-	 	}
+			dbg("%s Found interrupt in  endpoint. Address: %d",
+				__func__, endpoint->desc.bEndpointAddress);
+			priv->read_int_endpoint_address =
+				endpoint->desc.bEndpointAddress;
+		}
 	}
 	return 0;
 }
 
 
-static void kobil_shutdown (struct usb_serial *serial)
+static void kobil_shutdown(struct usb_serial *serial)
 {
 	int i;
 	dbg("%s - port %d", __func__, serial->port[0]->number);
 
-	for (i=0; i < serial->num_ports; ++i) {
-		while (serial->port[i]->port.count > 0) {
-			kobil_close (NULL, serial->port[i], NULL);
-		}
+	for (i = 0; i < serial->num_ports; ++i) {
+		while (serial->port[i]->port.count > 0)
+			kobil_close(NULL, serial->port[i], NULL);
 		kfree(usb_get_serial_port_data(serial->port[i]));
 		usb_set_serial_port_data(serial->port[i], NULL);
 	}
@@ -225,7 +228,7 @@ static int kobil_open(struct tty_struct *tty,
 	dbg("%s - port %d", __func__, port->number);
 	priv = usb_get_serial_port_data(port);
 
-	// someone sets the dev to 0 if the close method has been called
+	/* someone sets the dev to 0 if the close method has been called */
 	port->interrupt_in_urb->dev = port->serial->dev;
 
 
@@ -238,96 +241,110 @@ static int kobil_open(struct tty_struct *tty,
 
 		/* Default to echo off and other sane device settings */
 		tty->termios->c_lflag = 0;
-		tty->termios->c_lflag &= ~(ISIG | ICANON | ECHO | IEXTEN | XCASE);
+		tty->termios->c_lflag &= ~(ISIG | ICANON | ECHO | IEXTEN |
+								 XCASE);
 		tty->termios->c_iflag = IGNBRK | IGNPAR | IXOFF;
-		tty->termios->c_oflag &= ~ONLCR; // do NOT translate CR to CR-NL (0x0A -> 0x0A 0x0D)
-	}	
-	// allocate memory for transfer buffer
+		/* do NOT translate CR to CR-NL (0x0A -> 0x0A 0x0D) */
+		tty->termios->c_oflag &= ~ONLCR;
+	}
+	/* allocate memory for transfer buffer */
 	transfer_buffer = kzalloc(transfer_buffer_length, GFP_KERNEL);
-	if (! transfer_buffer) {
+	if (!transfer_buffer)
 		return -ENOMEM;
-	}
-	
-	// allocate write_urb
-	if (!port->write_urb) { 
-		dbg("%s - port %d  Allocating port->write_urb", __func__, port->number);
-		port->write_urb = usb_alloc_urb(0, GFP_KERNEL);  
+
+	/* allocate write_urb */
+	if (!port->write_urb) {
+		dbg("%s - port %d  Allocating port->write_urb",
+						__func__, port->number);
+		port->write_urb = usb_alloc_urb(0, GFP_KERNEL);
 		if (!port->write_urb) {
-			dbg("%s - port %d usb_alloc_urb failed", __func__, port->number);
+			dbg("%s - port %d usb_alloc_urb failed",
+						__func__, port->number);
 			kfree(transfer_buffer);
 			return -ENOMEM;
 		}
 	}
 
-	// allocate memory for write_urb transfer buffer
-	port->write_urb->transfer_buffer = kmalloc(write_urb_transfer_buffer_length, GFP_KERNEL);
-	if (! port->write_urb->transfer_buffer) {
+	/* allocate memory for write_urb transfer buffer */
+	port->write_urb->transfer_buffer =
+			kmalloc(write_urb_transfer_buffer_length, GFP_KERNEL);
+	if (!port->write_urb->transfer_buffer) {
 		kfree(transfer_buffer);
 		usb_free_urb(port->write_urb);
 		port->write_urb = NULL;
 		return -ENOMEM;
-	} 
-
-	// get hardware version
-	result = usb_control_msg( port->serial->dev, 
-				  usb_rcvctrlpipe(port->serial->dev, 0 ), 
-				  SUSBCRequest_GetMisc,
-				  USB_TYPE_VENDOR | USB_RECIP_ENDPOINT | USB_DIR_IN,
-				  SUSBCR_MSC_GetHWVersion,
-				  0,
-				  transfer_buffer,
-				  transfer_buffer_length,
-				  KOBIL_TIMEOUT
+	}
+
+	/* get hardware version */
+	result = usb_control_msg(port->serial->dev,
+			  usb_rcvctrlpipe(port->serial->dev, 0),
+			  SUSBCRequest_GetMisc,
+			  USB_TYPE_VENDOR | USB_RECIP_ENDPOINT | USB_DIR_IN,
+			  SUSBCR_MSC_GetHWVersion,
+			  0,
+			  transfer_buffer,
+			  transfer_buffer_length,
+			  KOBIL_TIMEOUT
+	);
+	dbg("%s - port %d Send get_HW_version URB returns: %i",
+		__func__, port->number, result);
+	dbg("Harware version: %i.%i.%i",
+		transfer_buffer[0], transfer_buffer[1], transfer_buffer[2]);
+
+	/* get firmware version */
+	result = usb_control_msg(port->serial->dev,
+			  usb_rcvctrlpipe(port->serial->dev, 0),
+			  SUSBCRequest_GetMisc,
+			  USB_TYPE_VENDOR | USB_RECIP_ENDPOINT | USB_DIR_IN,
+			  SUSBCR_MSC_GetFWVersion,
+			  0,
+			  transfer_buffer,
+			  transfer_buffer_length,
+			  KOBIL_TIMEOUT
+	);
+	dbg("%s - port %d Send get_FW_version URB returns: %i",
+					__func__, port->number, result);
+	dbg("Firmware version: %i.%i.%i",
+		transfer_buffer[0], transfer_buffer[1], transfer_buffer[2]);
+
+	if (priv->device_type == KOBIL_ADAPTER_B_PRODUCT_ID ||
+			priv->device_type == KOBIL_ADAPTER_K_PRODUCT_ID) {
+		/* Setting Baudrate, Parity and Stopbits */
+		result = usb_control_msg(port->serial->dev,
+			  usb_rcvctrlpipe(port->serial->dev, 0),
+			  SUSBCRequest_SetBaudRateParityAndStopBits,
+			  USB_TYPE_VENDOR | USB_RECIP_ENDPOINT | USB_DIR_OUT,
+			  SUSBCR_SBR_9600 | SUSBCR_SPASB_EvenParity |
+							SUSBCR_SPASB_1StopBit,
+			  0,
+			  transfer_buffer,
+			  0,
+			  KOBIL_TIMEOUT
 		);
-	dbg("%s - port %d Send get_HW_version URB returns: %i", __func__, port->number, result);
-	dbg("Harware version: %i.%i.%i", transfer_buffer[0], transfer_buffer[1], transfer_buffer[2] );
-	
-	// get firmware version
-	result = usb_control_msg( port->serial->dev, 
-				  usb_rcvctrlpipe(port->serial->dev, 0 ), 
-				  SUSBCRequest_GetMisc,
-				  USB_TYPE_VENDOR | USB_RECIP_ENDPOINT | USB_DIR_IN,
-				  SUSBCR_MSC_GetFWVersion,
-				  0,
-				  transfer_buffer,
-				  transfer_buffer_length,
-				  KOBIL_TIMEOUT
+		dbg("%s - port %d Send set_baudrate URB returns: %i",
+					__func__, port->number, result);
+
+		/* reset all queues */
+		result = usb_control_msg(port->serial->dev,
+			  usb_rcvctrlpipe(port->serial->dev, 0),
+			  SUSBCRequest_Misc,
+			  USB_TYPE_VENDOR | USB_RECIP_ENDPOINT | USB_DIR_OUT,
+			  SUSBCR_MSC_ResetAllQueues,
+			  0,
+			  transfer_buffer,
+			  0,
+			  KOBIL_TIMEOUT
 		);
-	dbg("%s - port %d Send get_FW_version URB returns: %i", __func__, port->number, result);
-	dbg("Firmware version: %i.%i.%i", transfer_buffer[0], transfer_buffer[1], transfer_buffer[2] );
-
-	if (priv->device_type == KOBIL_ADAPTER_B_PRODUCT_ID || priv->device_type == KOBIL_ADAPTER_K_PRODUCT_ID) {
-		// Setting Baudrate, Parity and Stopbits
-		result = usb_control_msg( port->serial->dev, 
-					  usb_rcvctrlpipe(port->serial->dev, 0 ), 
-					  SUSBCRequest_SetBaudRateParityAndStopBits,
-					  USB_TYPE_VENDOR | USB_RECIP_ENDPOINT | USB_DIR_OUT,
-					  SUSBCR_SBR_9600 | SUSBCR_SPASB_EvenParity | SUSBCR_SPASB_1StopBit,
-					  0,
-					  transfer_buffer,
-					  0,
-					  KOBIL_TIMEOUT
-			);
-		dbg("%s - port %d Send set_baudrate URB returns: %i", __func__, port->number, result);
-		
-		// reset all queues
-		result = usb_control_msg( port->serial->dev, 
-					  usb_rcvctrlpipe(port->serial->dev, 0 ), 
-					  SUSBCRequest_Misc,
-					  USB_TYPE_VENDOR | USB_RECIP_ENDPOINT | USB_DIR_OUT,
-					  SUSBCR_MSC_ResetAllQueues,
-					  0,
-					  transfer_buffer,
-					  0,
-					  KOBIL_TIMEOUT
-			);
-		dbg("%s - port %d Send reset_all_queues URB returns: %i", __func__, port->number, result);
+		dbg("%s - port %d Send reset_all_queues URB returns: %i",
+					__func__, port->number, result);
 	}
-	if (priv->device_type == KOBIL_USBTWIN_PRODUCT_ID || priv->device_type == KOBIL_ADAPTER_B_PRODUCT_ID ||
+	if (priv->device_type == KOBIL_USBTWIN_PRODUCT_ID ||
+	    priv->device_type == KOBIL_ADAPTER_B_PRODUCT_ID ||
 	    priv->device_type == KOBIL_KAAN_SIM_PRODUCT_ID) {
-		// start reading (Adapter B 'cause PNP string)
-		result = usb_submit_urb( port->interrupt_in_urb, GFP_ATOMIC  ); 
-		dbg("%s - port %d Send read URB returns: %i", __func__, port->number, result);
+		/* start reading (Adapter B 'cause PNP string) */
+		result = usb_submit_urb(port->interrupt_in_urb, GFP_ATOMIC);
+		dbg("%s - port %d Send read URB returns: %i",
+					__func__, port->number, result);
 	}
 
 	kfree(transfer_buffer);
@@ -342,7 +359,7 @@ static void kobil_close(struct tty_struct *tty,
 
 	if (port->write_urb) {
 		usb_kill_urb(port->write_urb);
-		usb_free_urb( port->write_urb );
+		usb_free_urb(port->write_urb);
 		port->write_urb = NULL;
 	}
 	usb_kill_urb(port->interrupt_in_urb);
@@ -356,7 +373,7 @@ static void kobil_read_int_callback(struct urb *urb)
 	struct tty_struct *tty;
 	unsigned char *data = urb->transfer_buffer;
 	int status = urb->status;
-//	char *dbg_data;
+/*	char *dbg_data; */
 
 	dbg("%s - port %d", __func__, port->number);
 
@@ -369,48 +386,50 @@ static void kobil_read_int_callback(struct urb *urb)
 	tty = port->port.tty;
 	if (urb->actual_length) {
 
-		// BEGIN DEBUG
+		/* BEGIN DEBUG */
 		/*
-		  dbg_data = kzalloc((3 *  purb->actual_length + 10) * sizeof(char), GFP_KERNEL);
+		  dbg_data = kzalloc((3 *  purb->actual_length + 10)
+						* sizeof(char), GFP_KERNEL);
 		  if (! dbg_data) {
-		  return;
+			  return;
 		  }
-		  for (i = 0; i < purb->actual_length; i++) { 
-		  sprintf(dbg_data +3*i, "%02X ", data[i]); 
+		  for (i = 0; i < purb->actual_length; i++) {
+			  sprintf(dbg_data +3*i, "%02X ", data[i]);
 		  }
-		  dbg(" <-- %s", dbg_data );
+		  dbg(" <-- %s", dbg_data);
 		  kfree(dbg_data);
 		*/
-		// END DEBUG
+		/* END DEBUG */
 
 		tty_buffer_request_room(tty, urb->actual_length);
 		tty_insert_flip_string(tty, data, urb->actual_length);
 		tty_flip_buffer_push(tty);
 	}
-
-	// someone sets the dev to 0 if the close method has been called
+	/* someone sets the dev to 0 if the close method has been called */
 	port->interrupt_in_urb->dev = port->serial->dev;
 
 	result = usb_submit_urb(port->interrupt_in_urb, GFP_ATOMIC);
-	dbg("%s - port %d Send read URB returns: %i", __func__, port->number, result);
+	dbg("%s - port %d Send read URB returns: %i",
+			__func__, port->number, result);
 }
 
 
-static void kobil_write_callback( struct urb *purb )
+static void kobil_write_callback(struct urb *purb)
 {
 }
 
 
-static int kobil_write (struct tty_struct *tty, struct usb_serial_port *port, 
+static int kobil_write(struct tty_struct *tty, struct usb_serial_port *port,
 			const unsigned char *buf, int count)
 {
 	int length = 0;
 	int result = 0;
 	int todo = 0;
-	struct kobil_private * priv;
+	struct kobil_private *priv;
 
 	if (count == 0) {
-		dbg("%s - port %d write request of 0 bytes", __func__, port->number);
+		dbg("%s - port %d write request of 0 bytes",
+						__func__, port->number);
 		return 0;
 	}
 
@@ -421,69 +440,77 @@ static int kobil_write (struct tty_struct *tty, struct usb_serial_port *port,
 		return -ENOMEM;
 	}
 
-	// Copy data to buffer
-	memcpy (priv->buf + priv->filled, buf, count);
-	usb_serial_debug_data(debug, &port->dev, __func__, count, priv->buf + priv->filled);
+	/* Copy data to buffer */
+	memcpy(priv->buf + priv->filled, buf, count);
+	usb_serial_debug_data(debug, &port->dev, __func__, count,
+						priv->buf + priv->filled);
 	priv->filled = priv->filled + count;
 
-	// only send complete block. TWIN, KAAN SIM and adapter K use the same protocol.
-	if ( ((priv->device_type != KOBIL_ADAPTER_B_PRODUCT_ID) && (priv->filled > 2) && (priv->filled >= (priv->buf[1] + 3))) || 
-	     ((priv->device_type == KOBIL_ADAPTER_B_PRODUCT_ID) && (priv->filled > 3) && (priv->filled >= (priv->buf[2] + 4))) ) {
-		
-		// stop reading (except TWIN and KAAN SIM)
-		if ( (priv->device_type == KOBIL_ADAPTER_B_PRODUCT_ID) || (priv->device_type == KOBIL_ADAPTER_K_PRODUCT_ID) )
+	/* only send complete block. TWIN, KAAN SIM and adapter K
+	   use the same protocol. */
+	if (((priv->device_type != KOBIL_ADAPTER_B_PRODUCT_ID) && (priv->filled > 2) && (priv->filled >= (priv->buf[1] + 3))) ||
+	     ((priv->device_type == KOBIL_ADAPTER_B_PRODUCT_ID) && (priv->filled > 3) && (priv->filled >= (priv->buf[2] + 4)))) {
+		/* stop reading (except TWIN and KAAN SIM) */
+		if ((priv->device_type == KOBIL_ADAPTER_B_PRODUCT_ID)
+			|| (priv->device_type == KOBIL_ADAPTER_K_PRODUCT_ID))
 			usb_kill_urb(port->interrupt_in_urb);
 
 		todo = priv->filled - priv->cur_pos;
 
-		while(todo > 0) {
-			// max 8 byte in one urb (endpoint size)
+		while (todo > 0) {
+			/* max 8 byte in one urb (endpoint size) */
 			length = (todo < 8) ? todo : 8;
-			// copy data to transfer buffer
-			memcpy(port->write_urb->transfer_buffer, priv->buf + priv->cur_pos, length );
-			usb_fill_int_urb( port->write_urb,
-					  port->serial->dev,
-					  usb_sndintpipe(port->serial->dev, priv->write_int_endpoint_address),
-					  port->write_urb->transfer_buffer,
-					  length,
-					  kobil_write_callback,
-					  port,
-					  8
-				);
+			/* copy data to transfer buffer */
+			memcpy(port->write_urb->transfer_buffer,
+					priv->buf + priv->cur_pos, length);
+			usb_fill_int_urb(port->write_urb,
+				  port->serial->dev,
+				  usb_sndintpipe(port->serial->dev,
+					priv->write_int_endpoint_address),
+				  port->write_urb->transfer_buffer,
+				  length,
+				  kobil_write_callback,
+				  port,
+				  8
+			);
 
 			priv->cur_pos = priv->cur_pos + length;
-			result = usb_submit_urb( port->write_urb, GFP_NOIO );
-			dbg("%s - port %d Send write URB returns: %i", __func__, port->number, result);
+			result = usb_submit_urb(port->write_urb, GFP_NOIO);
+			dbg("%s - port %d Send write URB returns: %i",
+					__func__, port->number, result);
 			todo = priv->filled - priv->cur_pos;
 
-			if (todo > 0) {
+			if (todo > 0)
 				msleep(24);
-			}
+		}
 
-		} // end while
-		
 		priv->filled = 0;
 		priv->cur_pos = 0;
 
-		// someone sets the dev to 0 if the close method has been called
+		/* someone sets the dev to 0 if the close method
+		   has been called */
 		port->interrupt_in_urb->dev = port->serial->dev;
-		
-		// start reading (except TWIN and KAAN SIM)
-		if ( (priv->device_type == KOBIL_ADAPTER_B_PRODUCT_ID) || (priv->device_type == KOBIL_ADAPTER_K_PRODUCT_ID) ) {
-			// someone sets the dev to 0 if the close method has been called
+
+		/* start reading (except TWIN and KAAN SIM) */
+		if (priv->device_type == KOBIL_ADAPTER_B_PRODUCT_ID ||
+			priv->device_type == KOBIL_ADAPTER_K_PRODUCT_ID) {
+			/* someone sets the dev to 0 if the close method has
+			   been called */
 			port->interrupt_in_urb->dev = port->serial->dev;
-			
-			result = usb_submit_urb( port->interrupt_in_urb, GFP_NOIO ); 
-			dbg("%s - port %d Send read URB returns: %i", __func__, port->number, result);
+
+			result = usb_submit_urb(port->interrupt_in_urb,
+								GFP_NOIO);
+			dbg("%s - port %d Send read URB returns: %i",
+					__func__, port->number, result);
 		}
 	}
 	return count;
 }
 
 
-static int kobil_write_room (struct tty_struct *tty)
+static int kobil_write_room(struct tty_struct *tty)
 {
-	//dbg("%s - port %d", __func__, port->number);
+	/* dbg("%s - port %d", __func__, port->number); */
 	/* FIXME */
 	return 8;
 }
@@ -492,34 +519,34 @@ static int kobil_write_room (struct tty_struct *tty)
 static int kobil_tiocmget(struct tty_struct *tty, struct file *file)
 {
 	struct usb_serial_port *port = tty->driver_data;
-	struct kobil_private * priv;
+	struct kobil_private *priv;
 	int result;
 	unsigned char *transfer_buffer;
 	int transfer_buffer_length = 8;
 
 	priv = usb_get_serial_port_data(port);
-	if ((priv->device_type == KOBIL_USBTWIN_PRODUCT_ID) || (priv->device_type == KOBIL_KAAN_SIM_PRODUCT_ID)) {
-		// This device doesn't support ioctl calls
+	if (priv->device_type == KOBIL_USBTWIN_PRODUCT_ID
+			|| priv->device_type == KOBIL_KAAN_SIM_PRODUCT_ID) {
+		/* This device doesn't support ioctl calls */
 		return -EINVAL;
 	}
 
-	// allocate memory for transfer buffer
+	/* allocate memory for transfer buffer */
 	transfer_buffer = kzalloc(transfer_buffer_length, GFP_KERNEL);
-	if (!transfer_buffer) {
+	if (!transfer_buffer)
 		return -ENOMEM;
-	}
 
-	result = usb_control_msg( port->serial->dev, 
-				  usb_rcvctrlpipe(port->serial->dev, 0 ), 
-				  SUSBCRequest_GetStatusLineState,
-				  USB_TYPE_VENDOR | USB_RECIP_ENDPOINT | USB_DIR_IN,
-				  0,
-				  0,
-				  transfer_buffer,
-				  transfer_buffer_length,
-				  KOBIL_TIMEOUT);
-
-	dbg("%s - port %d Send get_status_line_state URB returns: %i. Statusline: %02x", 
+	result = usb_control_msg(port->serial->dev,
+			  usb_rcvctrlpipe(port->serial->dev, 0),
+			  SUSBCRequest_GetStatusLineState,
+			  USB_TYPE_VENDOR | USB_RECIP_ENDPOINT | USB_DIR_IN,
+			  0,
+			  0,
+			  transfer_buffer,
+			  transfer_buffer_length,
+			  KOBIL_TIMEOUT);
+
+	dbg("%s - port %d Send get_status_line_state URB returns: %i. Statusline: %02x",
 	    __func__, port->number, result, transfer_buffer[0]);
 
 	result = 0;
@@ -533,7 +560,7 @@ static int kobil_tiocmset(struct tty_struct *tty, struct file *file,
 			   unsigned int set, unsigned int clear)
 {
 	struct usb_serial_port *port = tty->driver_data;
-	struct kobil_private * priv;
+	struct kobil_private *priv;
 	int result;
 	int dtr = 0;
 	int rts = 0;
@@ -542,16 +569,16 @@ static int kobil_tiocmset(struct tty_struct *tty, struct file *file,
 
 	/* FIXME: locking ? */
 	priv = usb_get_serial_port_data(port);
-	if ((priv->device_type == KOBIL_USBTWIN_PRODUCT_ID) || (priv->device_type == KOBIL_KAAN_SIM_PRODUCT_ID)) {
-		// This device doesn't support ioctl calls
+	if (priv->device_type == KOBIL_USBTWIN_PRODUCT_ID
+		|| priv->device_type == KOBIL_KAAN_SIM_PRODUCT_ID) {
+		/* This device doesn't support ioctl calls */
 		return -EINVAL;
 	}
 
-	// allocate memory for transfer buffer
+	/* allocate memory for transfer buffer */
 	transfer_buffer = kzalloc(transfer_buffer_length, GFP_KERNEL);
-	if (! transfer_buffer) {
+	if (!transfer_buffer)
 		return -ENOMEM;
-	}
 
 	if (set & TIOCM_RTS)
 		rts = 1;
@@ -564,34 +591,39 @@ static int kobil_tiocmset(struct tty_struct *tty, struct file *file,
 
 	if (priv->device_type == KOBIL_ADAPTER_B_PRODUCT_ID) {
 		if (dtr != 0)
-			dbg("%s - port %d Setting DTR", __func__, port->number);
+			dbg("%s - port %d Setting DTR",
+						__func__, port->number);
 		else
-			dbg("%s - port %d Clearing DTR", __func__, port->number);
-		result = usb_control_msg( port->serial->dev, 
-					  usb_rcvctrlpipe(port->serial->dev, 0 ), 
-					  SUSBCRequest_SetStatusLinesOrQueues,
-					  USB_TYPE_VENDOR | USB_RECIP_ENDPOINT | USB_DIR_OUT,
-					  ((dtr != 0) ? SUSBCR_SSL_SETDTR : SUSBCR_SSL_CLRDTR),
-					  0,
-					  transfer_buffer,
-					  0,
-					  KOBIL_TIMEOUT);
+			dbg("%s - port %d Clearing DTR",
+						__func__, port->number);
+		result = usb_control_msg(port->serial->dev,
+			  usb_rcvctrlpipe(port->serial->dev, 0),
+			  SUSBCRequest_SetStatusLinesOrQueues,
+			  USB_TYPE_VENDOR | USB_RECIP_ENDPOINT | USB_DIR_OUT,
+			  ((dtr != 0) ? SUSBCR_SSL_SETDTR : SUSBCR_SSL_CLRDTR),
+			  0,
+			  transfer_buffer,
+			  0,
+			  KOBIL_TIMEOUT);
 	} else {
 		if (rts != 0)
-			dbg("%s - port %d Setting RTS", __func__, port->number);
+			dbg("%s - port %d Setting RTS",
+						__func__, port->number);
 		else
-			dbg("%s - port %d Clearing RTS", __func__, port->number);
-		result = usb_control_msg( port->serial->dev, 
-					  usb_rcvctrlpipe(port->serial->dev, 0 ), 
-					  SUSBCRequest_SetStatusLinesOrQueues,
-					  USB_TYPE_VENDOR | USB_RECIP_ENDPOINT | USB_DIR_OUT,
-					  ((rts != 0) ? SUSBCR_SSL_SETRTS : SUSBCR_SSL_CLRRTS),
-					  0,
-					  transfer_buffer,
-					  0,
-					  KOBIL_TIMEOUT);
+			dbg("%s - port %d Clearing RTS",
+						__func__, port->number);
+		result = usb_control_msg(port->serial->dev,
+			usb_rcvctrlpipe(port->serial->dev, 0),
+			SUSBCRequest_SetStatusLinesOrQueues,
+			USB_TYPE_VENDOR | USB_RECIP_ENDPOINT | USB_DIR_OUT,
+			((rts != 0) ? SUSBCR_SSL_SETRTS : SUSBCR_SSL_CLRRTS),
+			0,
+			transfer_buffer,
+			0,
+			KOBIL_TIMEOUT);
 	}
-	dbg("%s - port %d Send set_status_line URB returns: %i", __func__, port->number, result);
+	dbg("%s - port %d Send set_status_line URB returns: %i",
+					__func__, port->number, result);
 	kfree(transfer_buffer);
 	return (result < 0) ? result : 0;
 }
@@ -599,32 +631,35 @@ static int kobil_tiocmset(struct tty_struct *tty, struct file *file,
 static void kobil_set_termios(struct tty_struct *tty,
 			struct usb_serial_port *port, struct ktermios *old)
 {
-	struct kobil_private * priv;
+	struct kobil_private *priv;
 	int result;
 	unsigned short urb_val = 0;
 	int c_cflag = tty->termios->c_cflag;
 	speed_t speed;
-	void * settings;
+	void *settings;
 
 	priv = usb_get_serial_port_data(port);
-	if (priv->device_type == KOBIL_USBTWIN_PRODUCT_ID || priv->device_type == KOBIL_KAAN_SIM_PRODUCT_ID)
-		// This device doesn't support ioctl calls
+	if (priv->device_type == KOBIL_USBTWIN_PRODUCT_ID ||
+			priv->device_type == KOBIL_KAAN_SIM_PRODUCT_ID)
+		/* This device doesn't support ioctl calls */
 		return;
 
-	switch (speed = tty_get_baud_rate(tty)) {
-		case 1200:
-			urb_val = SUSBCR_SBR_1200;
-			break;
-		default:
-			speed = 9600;
-		case 9600:
-			urb_val = SUSBCR_SBR_9600;
-			break;
+	speed = tty_get_baud_rate(tty);
+	switch (speed) {
+	case 1200:
+		urb_val = SUSBCR_SBR_1200;
+		break;
+	default:
+		speed = 9600;
+	case 9600:
+		urb_val = SUSBCR_SBR_9600;
+		break;
 	}
-	urb_val |= (c_cflag & CSTOPB) ? SUSBCR_SPASB_2StopBits : SUSBCR_SPASB_1StopBit;
+	urb_val |= (c_cflag & CSTOPB) ? SUSBCR_SPASB_2StopBits :
+							SUSBCR_SPASB_1StopBit;
 
 	settings = kzalloc(50, GFP_KERNEL);
-	if (! settings)
+	if (!settings)
 		return;
 
 	sprintf(settings, "%d ", speed);
@@ -644,48 +679,50 @@ static void kobil_set_termios(struct tty_struct *tty,
 	tty->termios->c_cflag &= ~CMSPAR;
 	tty_encode_baud_rate(tty, speed, speed);
 
-	result = usb_control_msg( port->serial->dev,
-				  usb_rcvctrlpipe(port->serial->dev, 0 ),
-				  SUSBCRequest_SetBaudRateParityAndStopBits,
-				  USB_TYPE_VENDOR | USB_RECIP_ENDPOINT | USB_DIR_OUT,
-				  urb_val,
-				  0,
-				  settings,
-				  0,
-				  KOBIL_TIMEOUT
+	result = usb_control_msg(port->serial->dev,
+		  usb_rcvctrlpipe(port->serial->dev, 0),
+		  SUSBCRequest_SetBaudRateParityAndStopBits,
+		  USB_TYPE_VENDOR | USB_RECIP_ENDPOINT | USB_DIR_OUT,
+		  urb_val,
+		  0,
+		  settings,
+		  0,
+		  KOBIL_TIMEOUT
 		);
 	kfree(settings);
 }
 
-static int kobil_ioctl(struct tty_struct *tty, struct file * file, unsigned int cmd, unsigned long arg)
+static int kobil_ioctl(struct tty_struct *tty, struct file *file,
+					unsigned int cmd, unsigned long arg)
 {
 	struct usb_serial_port *port = tty->driver_data;
-	struct kobil_private * priv = usb_get_serial_port_data(port);
+	struct kobil_private *priv = usb_get_serial_port_data(port);
 	unsigned char *transfer_buffer;
 	int transfer_buffer_length = 8;
 	int result;
 
-	if (priv->device_type == KOBIL_USBTWIN_PRODUCT_ID || priv->device_type == KOBIL_KAAN_SIM_PRODUCT_ID)
-		// This device doesn't support ioctl calls
+	if (priv->device_type == KOBIL_USBTWIN_PRODUCT_ID ||
+			priv->device_type == KOBIL_KAAN_SIM_PRODUCT_ID)
+		/* This device doesn't support ioctl calls */
 		return 0;
 
 	switch (cmd) {
 	case TCFLSH:
 		transfer_buffer = kmalloc(transfer_buffer_length, GFP_KERNEL);
-		if (! transfer_buffer)
-		 	return -ENOBUFS;
-
-		result = usb_control_msg( port->serial->dev, 
-		 			  usb_rcvctrlpipe(port->serial->dev, 0 ), 
-					  SUSBCRequest_Misc,
-					  USB_TYPE_VENDOR | USB_RECIP_ENDPOINT | USB_DIR_OUT,
-					  SUSBCR_MSC_ResetAllQueues,
-					  0,
-					  NULL,//transfer_buffer,
-					  0,
-					  KOBIL_TIMEOUT
+		if (!transfer_buffer)
+			return -ENOBUFS;
+
+		result = usb_control_msg(port->serial->dev,
+			  usb_rcvctrlpipe(port->serial->dev, 0),
+			  SUSBCRequest_Misc,
+			  USB_TYPE_VENDOR | USB_RECIP_ENDPOINT | USB_DIR_OUT,
+			  SUSBCR_MSC_ResetAllQueues,
+			  0,
+			  NULL, /* transfer_buffer, */
+			  0,
+			  KOBIL_TIMEOUT
 			);
-		
+
 		dbg("%s - port %d Send reset_all_queues (FLUSH) URB returns: %i", __func__, port->number, result);
 		kfree(transfer_buffer);
 		return (result < 0) ? -EIO: 0;
@@ -694,14 +731,14 @@ static int kobil_ioctl(struct tty_struct *tty, struct file * file, unsigned int
 	}
 }
 
-static int __init kobil_init (void)
+static int __init kobil_init(void)
 {
 	int retval;
 	retval = usb_serial_register(&kobil_device);
 	if (retval)
 		goto failed_usb_serial_register;
 	retval = usb_register(&kobil_driver);
-	if (retval) 
+	if (retval)
 		goto failed_usb_register;
 
 	info(DRIVER_VERSION " " DRIVER_AUTHOR);
@@ -715,18 +752,18 @@ failed_usb_serial_register:
 }
 
 
-static void __exit kobil_exit (void)
+static void __exit kobil_exit(void)
 {
-	usb_deregister (&kobil_driver);
-	usb_serial_deregister (&kobil_device);
+	usb_deregister(&kobil_driver);
+	usb_serial_deregister(&kobil_device);
 }
 
 module_init(kobil_init);
 module_exit(kobil_exit);
 
-MODULE_AUTHOR( DRIVER_AUTHOR );
-MODULE_DESCRIPTION( DRIVER_DESC );
-MODULE_LICENSE( "GPL" );
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_LICENSE("GPL");
 
 module_param(debug, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(debug, "Debug enabled or not");

