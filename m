Return-Path: <linux-kernel-owner+w=401wt.eu-S932605AbYFTUmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605AbYFTUmE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:42:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762726AbYFTUYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:24:18 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58355 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762712AbYFTUYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:24:14 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 65/70] tty-usb-option: Coding style
To: linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 21:06:49 +0100
Message-ID: <20080620200647.1479.8892.stgit@localhost.localdomain>
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

 drivers/usb/serial/option.c |   65 +++++++++++++++++++++++--------------------
 1 files changed, 35 insertions(+), 30 deletions(-)


diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 0e60408..bc9f54f 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -43,8 +43,10 @@
 #include <linux/usb/serial.h>
 
 /* Function prototypes */
-static int  option_open(struct tty_struct *tty, struct usb_serial_port *port, struct file *filp);
-static void option_close(struct tty_struct *tty, struct usb_serial_port *port, struct file *filp);
+static int  option_open(struct tty_struct *tty, struct usb_serial_port *port,
+							struct file *filp);
+static void option_close(struct tty_struct *tty, struct usb_serial_port *port,
+							struct file *filp);
 static int  option_startup(struct usb_serial *serial);
 static void option_shutdown(struct usb_serial *serial);
 static int  option_write_room(struct tty_struct *tty);
@@ -390,15 +392,15 @@ static int __init option_init(void)
 	return 0;
 
 failed_driver_register:
-	usb_serial_deregister (&option_1port_device);
+	usb_serial_deregister(&option_1port_device);
 failed_1port_device_register:
 	return retval;
 }
 
 static void __exit option_exit(void)
 {
-	usb_deregister (&option_driver);
-	usb_serial_deregister (&option_1port_device);
+	usb_deregister(&option_driver);
+	usb_serial_deregister(&option_1port_device);
 }
 
 module_init(option_init);
@@ -468,7 +470,7 @@ static int option_write(struct tty_struct *tty, struct usb_serial_port *port,
 
 	i = 0;
 	left = count;
-	for (i=0; left > 0 && i < N_OUT_URB; i++) {
+	for (i = 0; left > 0 && i < N_OUT_URB; i++) {
 		todo = left;
 		if (todo > OUT_BUFLEN)
 			todo = OUT_BUFLEN;
@@ -489,7 +491,7 @@ static int option_write(struct tty_struct *tty, struct usb_serial_port *port,
 			usb_pipeendpoint(this_urb->pipe), i);
 
 		/* send the data */
-		memcpy (this_urb->transfer_buffer, buf, todo);
+		memcpy(this_urb->transfer_buffer, buf, todo);
 		this_urb->transfer_buffer_length = todo;
 
 		this_urb->dev = port->serial->dev;
@@ -580,7 +582,7 @@ static void option_instat_callback(struct urb *urb)
 	struct usb_serial *serial = port->serial;
 
 	dbg("%s", __func__);
-	dbg("%s: urb %p port %p has data %p", __func__,urb,port,portdata);
+	dbg("%s: urb %p port %p has data %p", __func__, urb, port, portdata);
 
 	if (status == 0) {
 		struct usb_ctrlrequest *req_pkt =
@@ -610,7 +612,7 @@ static void option_instat_callback(struct urb *urb)
 				tty_hangup(port->port.tty);
 		} else {
 			dbg("%s: type %x req %x", __func__,
-				req_pkt->bRequestType,req_pkt->bRequest);
+				req_pkt->bRequestType, req_pkt->bRequest);
 		}
 	} else
 		dbg("%s: error %d", __func__, status);
@@ -636,7 +638,7 @@ static int option_write_room(struct tty_struct *tty)
 	portdata = usb_get_serial_port_data(port);
 
 
-	for (i=0; i < N_OUT_URB; i++) {
+	for (i = 0; i < N_OUT_URB; i++) {
 		this_urb = portdata->out_urbs[i];
 		if (this_urb && !test_bit(i, &portdata->out_busy))
 			data_len += OUT_BUFLEN;
@@ -656,7 +658,7 @@ static int option_chars_in_buffer(struct tty_struct *tty)
 
 	portdata = usb_get_serial_port_data(port);
 
-	for (i=0; i < N_OUT_URB; i++) {
+	for (i = 0; i < N_OUT_URB; i++) {
 		this_urb = portdata->out_urbs[i];
 		/* FIXME: This locking is insufficient as this_urb may
 		   go unused during the test */
@@ -686,7 +688,7 @@ static int option_open(struct tty_struct *tty,
 	/* Reset low level data toggle and start reading from endpoints */
 	for (i = 0; i < N_IN_URB; i++) {
 		urb = portdata->in_urbs[i];
-		if (! urb)
+		if (!urb)
 			continue;
 		if (urb->dev != serial->dev) {
 			dbg("%s: dev %p != %p", __func__,
@@ -711,7 +713,7 @@ static int option_open(struct tty_struct *tty,
 	/* Reset low level data toggle on out endpoints */
 	for (i = 0; i < N_OUT_URB; i++) {
 		urb = portdata->out_urbs[i];
-		if (! urb)
+		if (!urb)
 			continue;
 		urb->dev = serial->dev;
 		/* usb_settoggle(urb->dev, usb_pipeendpoint(urb->pipe),
@@ -723,7 +725,7 @@ static int option_open(struct tty_struct *tty,
 
 	option_send_setup(tty, port);
 
-	return (0);
+	return 0;
 }
 
 static void option_close(struct tty_struct *tty,
@@ -781,7 +783,7 @@ static struct urb *option_setup_urb(struct usb_serial *serial, int endpoint,
 /* Setup urbs */
 static void option_setup_urbs(struct usb_serial *serial)
 {
-	int i,j;
+	int i, j;
 	struct usb_serial_port *port;
 	struct option_port_private *portdata;
 
@@ -791,18 +793,22 @@ static void option_setup_urbs(struct usb_serial *serial)
 		port = serial->port[i];
 		portdata = usb_get_serial_port_data(port);
 
-	/* Do indat endpoints first */
+		/* Do indat endpoints first */
 		for (j = 0; j < N_IN_URB; ++j) {
-			portdata->in_urbs[j] = option_setup_urb (serial,
-                  	port->bulk_in_endpointAddress, USB_DIR_IN, port,
-                  	portdata->in_buffer[j], IN_BUFLEN, option_indat_callback);
+			portdata->in_urbs[j] = option_setup_urb(serial,
+					port->bulk_in_endpointAddress,
+					USB_DIR_IN, port,
+					portdata->in_buffer[j],
+					IN_BUFLEN, option_indat_callback);
 		}
 
 		/* outdat endpoints */
 		for (j = 0; j < N_OUT_URB; ++j) {
-			portdata->out_urbs[j] = option_setup_urb (serial,
-                  	port->bulk_out_endpointAddress, USB_DIR_OUT, port,
-                  	portdata->out_buffer[j], OUT_BUFLEN, option_outdat_callback);
+			portdata->out_urbs[j] = option_setup_urb(serial,
+					port->bulk_out_endpointAddress,
+					USB_DIR_OUT, port,
+					portdata->out_buffer[j],
+					OUT_BUFLEN, option_outdat_callback);
 		}
 	}
 }
@@ -831,8 +837,8 @@ static int option_send_setup(struct tty_struct *tty,
 			val |= 0x02;
 
 		return usb_control_msg(serial->dev,
-				usb_rcvctrlpipe(serial->dev, 0),
-				0x22,0x21,val,ifNum,NULL,0,USB_CTRL_SET_TIMEOUT);
+			usb_rcvctrlpipe(serial->dev, 0),
+			0x22, 0x21, val, ifNum, NULL, 0, USB_CTRL_SET_TIMEOUT);
 	}
 	return 0;
 }
@@ -853,7 +859,7 @@ static int option_startup(struct usb_serial *serial)
 		if (!portdata) {
 			dbg("%s: kmalloc for option_port_private (%d) failed!.",
 					__func__, i);
-			return (1);
+			return 1;
 		}
 
 		for (j = 0; j < N_IN_URB; j++) {
@@ -872,17 +878,15 @@ static int option_startup(struct usb_serial *serial)
 
 		usb_set_serial_port_data(port, portdata);
 
-		if (! port->interrupt_in_urb)
+		if (!port->interrupt_in_urb)
 			continue;
 		err = usb_submit_urb(port->interrupt_in_urb, GFP_KERNEL);
 		if (err)
 			dbg("%s: submit irq_in urb failed %d",
 				__func__, err);
 	}
-
 	option_setup_urbs(serial);
-
-	return (0);
+	return 0;
 
 bail_out_error2:
 	for (j = 0; j < N_OUT_URB; j++)
@@ -921,7 +925,8 @@ static void option_shutdown(struct usb_serial *serial)
 		for (j = 0; j < N_IN_URB; j++) {
 			if (portdata->in_urbs[j]) {
 				usb_free_urb(portdata->in_urbs[j]);
-				free_page((unsigned long)portdata->in_buffer[j]);
+				free_page((unsigned long)
+					portdata->in_buffer[j]);
 				portdata->in_urbs[j] = NULL;
 			}
 		}

