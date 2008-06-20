Return-Path: <linux-kernel-owner+w=401wt.eu-S1764876AbYFTUdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764876AbYFTUdl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761943AbYFTUVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:21:43 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35223 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761923AbYFTUVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:21:41 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 47/70] tty-usb-ipw: Coding style
To: linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 21:04:17 +0100
Message-ID: <20080620200415.1479.36548.stgit@localhost.localdomain>
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

 drivers/usb/serial/ipw.c |  279 ++++++++++++++++++++++++----------------------
 1 files changed, 144 insertions(+), 135 deletions(-)


diff --git a/drivers/usb/serial/ipw.c b/drivers/usb/serial/ipw.c
index a89ebfe..a842025 100644
--- a/drivers/usb/serial/ipw.c
+++ b/drivers/usb/serial/ipw.c
@@ -10,27 +10,27 @@
  *   (at your option) any later version.
  *
  * All information about the device was acquired using SnoopyPro
- * on MSFT's O/S, and examing the MSFT drivers' debug output 
+ * on MSFT's O/S, and examing the MSFT drivers' debug output
  * (insanely left _on_ in the enduser version)
  *
  * It was written out of frustration with the IPWireless USB modem
  * supplied by Axity3G/Sentech South Africa not supporting
  * Linux whatsoever.
  *
- * Nobody provided any proprietary information that was not already 
+ * Nobody provided any proprietary information that was not already
  * available for this device.
- * 
- * The modem adheres to the "3GPP TS  27.007 AT command set for 3G 
- * User Equipment (UE)" standard, available from 
+ *
+ * The modem adheres to the "3GPP TS  27.007 AT command set for 3G
+ * User Equipment (UE)" standard, available from
  * http://www.3gpp.org/ftp/Specs/html-info/27007.htm
  *
  * The code was only tested the IPWireless handheld modem distributed
  * in South Africa by Sentech.
- * 
+ *
  * It may work for Woosh Inc in .nz too, as it appears they use the
  * same kit.
  *
- * There is still some work to be done in terms of handling 
+ * There is still some work to be done in terms of handling
  * DCD, DTR, RTS, CTS which are currently faked.
  * It's good enough for PPP at this point. It's based off all kinds of
  * code found in usb/serial and usb/class
@@ -47,7 +47,7 @@
 #include <linux/spinlock.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 /*
  * Version Information
@@ -64,7 +64,7 @@
 
 /* Message sizes */
 #define EVENT_BUFFER_SIZE	0xFF
-#define CHAR2INT16(c1,c0)	(((u32)((c1) & 0xff) << 8) + (u32)((c0) & 0xff))
+#define CHAR2INT16(c1, c0)	(((u32)((c1) & 0xff) << 8) + (u32)((c0) & 0xff))
 #define NUM_BULK_URBS		24
 #define NUM_CONTROL_URBS	16
 
@@ -94,33 +94,34 @@ enum {
 
 /* data bits */
 #define ipw_dtb_7		0x700
-#define ipw_dtb_8		0x810	// ok so the define is misleading, I know, but forces 8,n,1
-					// I mean, is there a point to any other setting these days? :)	
+#define ipw_dtb_8		0x810	/* ok so the define is misleading, I know, but forces 8,n,1 */
+					/* I mean, is there a point to any other setting these days? :) */
 
 /* usb control request types : */
-#define IPW_SIO_RXCTL		0x00	// control bulk rx channel transmissions, value=1/0 (on/off)
-#define IPW_SIO_SET_BAUD	0x01	// set baud, value=requested ipw_sio_bxxxx
-#define IPW_SIO_SET_LINE	0x03	// set databits, parity. value=ipw_dtb_x
-#define IPW_SIO_SET_PIN		0x03	// set/clear dtr/rts value=ipw_pin_xxx
-#define IPW_SIO_POLL		0x08	// get serial port status byte, call with value=0
-#define IPW_SIO_INIT		0x11	// initializes ? value=0 (appears as first thing todo on open)
-#define IPW_SIO_PURGE		0x12	// purge all transmissions?, call with value=numchar_to_purge
-#define IPW_SIO_HANDFLOW	0x13	// set xon/xoff limits value=0, and a buffer of 0x10 bytes
-#define IPW_SIO_SETCHARS	0x13	// set the flowcontrol special chars, value=0, buf=6 bytes, 
-					// last 2 bytes contain flowcontrol chars e.g. 00 00 00 00 11 13
+#define IPW_SIO_RXCTL		0x00	/* control bulk rx channel transmissions, value=1/0 (on/off) */
+#define IPW_SIO_SET_BAUD	0x01	/* set baud, value=requested ipw_sio_bxxxx */
+#define IPW_SIO_SET_LINE	0x03	/* set databits, parity. value=ipw_dtb_x */
+#define IPW_SIO_SET_PIN		0x03	/* set/clear dtr/rts value=ipw_pin_xxx */
+#define IPW_SIO_POLL		0x08	/* get serial port status byte, call with value=0 */
+#define IPW_SIO_INIT		0x11	/* initializes ? value=0 (appears as first thing todo on open) */
+#define IPW_SIO_PURGE		0x12	/* purge all transmissions?, call with value=numchar_to_purge */
+#define IPW_SIO_HANDFLOW	0x13	/* set xon/xoff limits value=0, and a buffer of 0x10 bytes */
+#define IPW_SIO_SETCHARS	0x13	/* set the flowcontrol special chars, value=0, buf=6 bytes, */
+					/* last 2 bytes contain flowcontrol chars e.g. 00 00 00 00 11 13 */
 
 /* values used for request IPW_SIO_SET_PIN */
 #define IPW_PIN_SETDTR		0x101
 #define IPW_PIN_SETRTS		0x202
 #define IPW_PIN_CLRDTR		0x100
-#define IPW_PIN_CLRRTS		0x200 // unconfirmed
+#define IPW_PIN_CLRRTS		0x200 /* unconfirmed */
 
 /* values used for request IPW_SIO_RXCTL */
 #define IPW_RXBULK_ON		1
 #define IPW_RXBULK_OFF		0
 
 /* various 16 byte hardcoded transferbuffers used by flow control */
-#define IPW_BYTES_FLOWINIT	{ 0x01, 0, 0, 0, 0x40, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
+#define IPW_BYTES_FLOWINIT	{ 0x01, 0, 0, 0, 0x40, 0, 0, 0, \
+					0, 0, 0, 0, 0, 0, 0, 0 }
 
 /* Interpretation of modem status lines */
 /* These need sorting out by individually connecting pins and checking
@@ -132,17 +133,6 @@ enum {
 #define IPW_CTS			((1<<5) | (1<<4))
 
 #define IPW_WANTS_TO_SEND	0x30
-//#define IPW_DTR			/* Data Terminal Ready */
-//#define IPW_CTS			/* Clear To Send */
-//#define IPW_CD			/* Carrier Detect */
-//#define IPW_DSR			/* Data Set Ready */
-//#define IPW_RxD			/* Receive pin */
-
-//#define IPW_LE
-//#define IPW_RTS		
-//#define IPW_ST		
-//#define IPW_SR		
-//#define IPW_RI			/* Ring Indicator */
 
 static struct usb_device_id usb_ipw_ids[] = {
 	{ USB_DEVICE(IPW_VID, IPW_PID) },
@@ -177,7 +167,8 @@ static void ipw_read_bulk_callback(struct urb *urb)
 		return;
 	}
 
-	usb_serial_debug_data(debug, &port->dev, __func__, urb->actual_length, data);
+	usb_serial_debug_data(debug, &port->dev, __func__,
+					urb->actual_length, data);
 
 	tty = port->port.tty;
 	if (tty && urb->actual_length) {
@@ -187,15 +178,17 @@ static void ipw_read_bulk_callback(struct urb *urb)
 	}
 
 	/* Continue trying to always read  */
-	usb_fill_bulk_urb (port->read_urb, port->serial->dev,
-			   usb_rcvbulkpipe(port->serial->dev,
+	usb_fill_bulk_urb(port->read_urb, port->serial->dev,
+			  usb_rcvbulkpipe(port->serial->dev,
 					   port->bulk_in_endpointAddress),
-			   port->read_urb->transfer_buffer,
-			   port->read_urb->transfer_buffer_length,
-			   ipw_read_bulk_callback, port);
+			  port->read_urb->transfer_buffer,
+			  port->read_urb->transfer_buffer_length,
+			  ipw_read_bulk_callback, port);
 	result = usb_submit_urb(port->read_urb, GFP_ATOMIC);
 	if (result)
-		dev_err(&port->dev, "%s - failed resubmitting read urb, error %d\n", __func__, result);
+		dev_err(&port->dev,
+			"%s - failed resubmitting read urb, error %d\n",
+							__func__, result);
 	return;
 }
 
@@ -216,26 +209,30 @@ static int ipw_open(struct tty_struct *tty,
 	if (tty)
 		tty->low_latency = 1;
 
-	/* --1: Tell the modem to initialize (we think) From sniffs this is always the
-	 * first thing that gets sent to the modem during opening of the device */
-	dbg("%s: Sending SIO_INIT (we guess)",__func__);
-	result = usb_control_msg(dev, usb_sndctrlpipe(dev,0),
-				 IPW_SIO_INIT,
-				 USB_TYPE_VENDOR | USB_RECIP_INTERFACE | USB_DIR_OUT,
-				 0,
-				 0, /* index */
-				 NULL,
-				 0,
-				 100000);
+	/* --1: Tell the modem to initialize (we think) From sniffs this is
+	 *	always the first thing that gets sent to the modem during
+	 *	opening of the device */
+	dbg("%s: Sending SIO_INIT (we guess)", __func__);
+	result = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
+			 IPW_SIO_INIT,
+			 USB_TYPE_VENDOR | USB_RECIP_INTERFACE | USB_DIR_OUT,
+			 0,
+			 0, /* index */
+			 NULL,
+			 0,
+			 100000);
 	if (result < 0)
-		dev_err(&port->dev, "Init of modem failed (error = %d)\n", result);
+		dev_err(&port->dev,
+			"Init of modem failed (error = %d)\n", result);
 
 	/* reset the bulk pipes */
-	usb_clear_halt(dev, usb_rcvbulkpipe(dev, port->bulk_in_endpointAddress));
-	usb_clear_halt(dev, usb_sndbulkpipe(dev, port->bulk_out_endpointAddress));
+	usb_clear_halt(dev,
+			usb_rcvbulkpipe(dev, port->bulk_in_endpointAddress));
+	usb_clear_halt(dev,
+			usb_sndbulkpipe(dev, port->bulk_out_endpointAddress));
 
-	/*--2: Start reading from the device */	
-	dbg("%s: setting up bulk read callback",__func__);
+	/*--2: Start reading from the device */
+	dbg("%s: setting up bulk read callback", __func__);
 	usb_fill_bulk_urb(port->read_urb, dev,
 			  usb_rcvbulkpipe(dev, port->bulk_in_endpointAddress),
 			  port->bulk_in_buffer,
@@ -243,67 +240,72 @@ static int ipw_open(struct tty_struct *tty,
 			  ipw_read_bulk_callback, port);
 	result = usb_submit_urb(port->read_urb, GFP_KERNEL);
 	if (result < 0)
-		dbg("%s - usb_submit_urb(read bulk) failed with status %d", __func__, result);
+		dbg("%s - usb_submit_urb(read bulk) failed with status %d",
+							__func__, result);
 
 	/*--3: Tell the modem to open the floodgates on the rx bulk channel */
-	dbg("%s:asking modem for RxRead (RXBULK_ON)",__func__);
+	dbg("%s:asking modem for RxRead (RXBULK_ON)", __func__);
 	result = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
-				 IPW_SIO_RXCTL,
-				 USB_TYPE_VENDOR | USB_RECIP_INTERFACE | USB_DIR_OUT,
-				 IPW_RXBULK_ON,
-				 0, /* index */
-				 NULL,
-				 0,
-				 100000);
-	if (result < 0) 
-		dev_err(&port->dev, "Enabling bulk RxRead failed (error = %d)\n", result);
+			 IPW_SIO_RXCTL,
+			 USB_TYPE_VENDOR | USB_RECIP_INTERFACE | USB_DIR_OUT,
+			 IPW_RXBULK_ON,
+			 0, /* index */
+			 NULL,
+			 0,
+			 100000);
+	if (result < 0)
+		dev_err(&port->dev,
+			"Enabling bulk RxRead failed (error = %d)\n", result);
 
 	/*--4: setup the initial flowcontrol */
-	dbg("%s:setting init flowcontrol (%s)",__func__,buf_flow_init);
+	dbg("%s:setting init flowcontrol (%s)", __func__, buf_flow_init);
 	result = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
-				 IPW_SIO_HANDFLOW,
-				 USB_TYPE_VENDOR | USB_RECIP_INTERFACE | USB_DIR_OUT,
-				 0,
-				 0,
-				 buf_flow_init,
-				 0x10,
-				 200000);
+			 IPW_SIO_HANDFLOW,
+			 USB_TYPE_VENDOR | USB_RECIP_INTERFACE | USB_DIR_OUT,
+			 0,
+			 0,
+			 buf_flow_init,
+			 0x10,
+			 200000);
 	if (result < 0)
-		dev_err(&port->dev, "initial flowcontrol failed (error = %d)\n", result);
+		dev_err(&port->dev,
+			"initial flowcontrol failed (error = %d)\n", result);
 
 
 	/*--5: raise the dtr */
-	dbg("%s:raising dtr",__func__);
+	dbg("%s:raising dtr", __func__);
 	result = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
-				 IPW_SIO_SET_PIN,
-				 USB_TYPE_VENDOR | USB_RECIP_INTERFACE | USB_DIR_OUT,
-				 IPW_PIN_SETDTR,
-				 0,
-				 NULL,
-				 0,
-				 200000);
+			 IPW_SIO_SET_PIN,
+			 USB_TYPE_VENDOR | USB_RECIP_INTERFACE | USB_DIR_OUT,
+			 IPW_PIN_SETDTR,
+			 0,
+			 NULL,
+			 0,
+			 200000);
 	if (result < 0)
-		dev_err(&port->dev, "setting dtr failed (error = %d)\n", result);
+		dev_err(&port->dev,
+				"setting dtr failed (error = %d)\n", result);
 
 	/*--6: raise the rts */
-	dbg("%s:raising rts",__func__);
+	dbg("%s:raising rts", __func__);
 	result = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
-				 IPW_SIO_SET_PIN,
-				 USB_TYPE_VENDOR | USB_RECIP_INTERFACE | USB_DIR_OUT,
-				 IPW_PIN_SETRTS,
-				 0,
-				 NULL,
-				 0,
-				 200000);
+			 IPW_SIO_SET_PIN,
+			 USB_TYPE_VENDOR | USB_RECIP_INTERFACE | USB_DIR_OUT,
+			 IPW_PIN_SETRTS,
+			 0,
+			 NULL,
+			 0,
+			 200000);
 	if (result < 0)
-		dev_err(&port->dev, "setting dtr failed (error = %d)\n", result);
-	
+		dev_err(&port->dev,
+				"setting dtr failed (error = %d)\n", result);
+
 	kfree(buf_flow_init);
 	return 0;
 }
 
 static void ipw_close(struct tty_struct *tty,
-			struct usb_serial_port *port, struct file * filp)
+			struct usb_serial_port *port, struct file *filp)
 {
 	struct usb_device *dev = port->serial->dev;
 	int result;
@@ -314,56 +316,62 @@ static void ipw_close(struct tty_struct *tty,
 	}
 
 	/*--1: drop the dtr */
-	dbg("%s:dropping dtr",__func__);
+	dbg("%s:dropping dtr", __func__);
 	result = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
-				 IPW_SIO_SET_PIN,
-				 USB_TYPE_VENDOR | USB_RECIP_INTERFACE | USB_DIR_OUT,
-				 IPW_PIN_CLRDTR,
-				 0,
-				 NULL,
-				 0,
-				 200000);
+			 IPW_SIO_SET_PIN,
+			 USB_TYPE_VENDOR | USB_RECIP_INTERFACE | USB_DIR_OUT,
+			 IPW_PIN_CLRDTR,
+			 0,
+			 NULL,
+			 0,
+			 200000);
 	if (result < 0)
-		dev_err(&port->dev, "dropping dtr failed (error = %d)\n", result);
+		dev_err(&port->dev, "dropping dtr failed (error = %d)\n",
+								result);
 
 	/*--2: drop the rts */
-	dbg("%s:dropping rts",__func__);
+	dbg("%s:dropping rts", __func__);
 	result = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
-				 IPW_SIO_SET_PIN, USB_TYPE_VENDOR | USB_RECIP_INTERFACE | USB_DIR_OUT,
-				 IPW_PIN_CLRRTS,
-				 0,
-				 NULL,
-				 0,
-				 200000);
+			 IPW_SIO_SET_PIN, USB_TYPE_VENDOR |
+			 		USB_RECIP_INTERFACE | USB_DIR_OUT,
+			 IPW_PIN_CLRRTS,
+			 0,
+			 NULL,
+			 0,
+			 200000);
 	if (result < 0)
-		dev_err(&port->dev, "dropping rts failed (error = %d)\n", result);
+		dev_err(&port->dev,
+				"dropping rts failed (error = %d)\n", result);
 
 
 	/*--3: purge */
-	dbg("%s:sending purge",__func__);
+	dbg("%s:sending purge", __func__);
 	result = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
-				 IPW_SIO_PURGE, USB_TYPE_VENDOR | USB_RECIP_INTERFACE | USB_DIR_OUT,
-				 0x03,
-				 0,
-				 NULL,
-				 0,
-				 200000);
+			 IPW_SIO_PURGE, USB_TYPE_VENDOR |
+			 		USB_RECIP_INTERFACE | USB_DIR_OUT,
+			 0x03,
+			 0,
+			 NULL,
+			 0,
+			 200000);
 	if (result < 0)
 		dev_err(&port->dev, "purge failed (error = %d)\n", result);
 
 
-	/* send RXBULK_off (tell modem to stop transmitting bulk data on rx chan) */
+	/* send RXBULK_off (tell modem to stop transmitting bulk data on
+	   rx chan) */
 	result = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
-				 IPW_SIO_RXCTL,
-				 USB_TYPE_VENDOR | USB_RECIP_INTERFACE | USB_DIR_OUT,
-				 IPW_RXBULK_OFF,
-				 0, /* index */
-				 NULL,
-				 0,
-				 100000);
+			 IPW_SIO_RXCTL,
+			 USB_TYPE_VENDOR | USB_RECIP_INTERFACE | USB_DIR_OUT,
+			 IPW_RXBULK_OFF,
+			 0, /* index */
+			 NULL,
+			 0,
+			 100000);
 
 	if (result < 0)
-		dev_err(&port->dev, "Disabling bulk RxRead failed (error = %d)\n", result);
+		dev_err(&port->dev,
+			"Disabling bulk RxRead failed (error = %d)\n", result);
 
 	/* shutdown any in-flight urbs that we know about */
 	usb_kill_urb(port->read_urb);
@@ -393,7 +401,7 @@ static int ipw_write(struct tty_struct *tty, struct usb_serial_port *port,
 	int ret;
 
 	dbg("%s: TOP: count=%d, in_interrupt=%ld", __func__,
-		count, in_interrupt() );
+		count, in_interrupt());
 
 	if (count == 0) {
 		dbg("%s - write request of 0 bytes", __func__);
@@ -424,13 +432,14 @@ static int ipw_write(struct tty_struct *tty, struct usb_serial_port *port,
 	ret = usb_submit_urb(port->write_urb, GFP_ATOMIC);
 	if (ret != 0) {
 		port->write_urb_busy = 0;
-		dbg("%s - usb_submit_urb(write bulk) failed with error = %d", __func__, ret);
+		dbg("%s - usb_submit_urb(write bulk) failed with error = %d",
+								__func__, ret);
 		return ret;
 	}
 
 	dbg("%s returning %d", __func__, count);
 	return count;
-} 
+}
 
 static int ipw_probe(struct usb_serial_port *port)
 {
@@ -489,8 +498,8 @@ module_init(usb_ipw_init);
 module_exit(usb_ipw_exit);
 
 /* Module information */
-MODULE_AUTHOR( DRIVER_AUTHOR );
-MODULE_DESCRIPTION( DRIVER_DESC );
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
 
 module_param(debug, bool, S_IRUGO | S_IWUSR);

