Return-Path: <linux-kernel-owner+w=401wt.eu-S1763498AbYFTU0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763498AbYFTU0w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:26:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761088AbYFTUTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:19:46 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35193 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761044AbYFTUTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:19:44 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 32/70] cypress_m8: coding style
To: linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 21:02:19 +0100
Message-ID: <20080620200216.1479.71780.stgit@localhost.localdomain>
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

Coding style clean ups

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/usb/serial/cypress_m8.c |  617 ++++++++++++++++++++-------------------
 drivers/usb/serial/cypress_m8.h |    2 
 2 files changed, 325 insertions(+), 294 deletions(-)


diff --git a/drivers/usb/serial/cypress_m8.c b/drivers/usb/serial/cypress_m8.c
index 6999d33..bb9c7c4 100644
--- a/drivers/usb/serial/cypress_m8.c
+++ b/drivers/usb/serial/cypress_m8.c
@@ -2,7 +2,7 @@
  * USB Cypress M8 driver
  *
  * 	Copyright (C) 2004
- * 	    Lonnie Mendez (dignome@gmail.com) 
+ * 	    Lonnie Mendez (dignome@gmail.com)
  *	Copyright (C) 2003,2004
  *	    Neil Whelchel (koyama@firstlight.net)
  *
@@ -11,19 +11,21 @@
  * 	the Free Software Foundation; either version 2 of the License, or
  * 	(at your option) any later version.
  *
- * See Documentation/usb/usb-serial.txt for more information on using this driver
+ * See Documentation/usb/usb-serial.txt for more information on using this
+ * driver
  *
  * See http://geocities.com/i0xox0i for information on this driver and the
  * earthmate usb device.
  *
  *  Lonnie Mendez <dignome@gmail.com>
  *  4-29-2005
- *	Fixed problem where setting or retreiving the serial config would fail with
- * 	EPIPE.  Removed CRTS toggling so the driver behaves more like other usbserial
- * 	adapters.  Issued new interval of 1ms instead of the default 10ms.  As a
- * 	result, transfer speed has been substantially increased.  From avg. 850bps to
- * 	avg. 3300bps.  initial termios has also been modified.  Cleaned up code and
- * 	formatting issues so it is more readable.  Replaced the C++ style comments.
+ *	Fixed problem where setting or retreiving the serial config would fail
+ *	with EPIPE.  Removed CRTS toggling so the driver behaves more like
+ *	other usbserial adapters.  Issued new interval of 1ms instead of the
+ *	default 10ms.  As a result, transfer speed has been substantially
+ *	increased from avg. 850bps to avg. 3300bps.  initial termios has also
+ *	been modified.  Cleaned up code and formatting issues so it is more
+ *	readable.  Replaced the C++ style comments.
  *
  *  Lonnie Mendez <dignome@gmail.com>
  *  12-15-2004
@@ -42,10 +44,11 @@
  *
  */
 
-/* Thanks to Neil Whelchel for writing the first cypress m8 implementation for linux. */
+/* Thanks to Neil Whelchel for writing the first cypress m8 implementation
+   for linux. */
 /* Thanks to cypress for providing references for the hid reports. */
 /* Thanks to Jiang Zhang for providing links and for general help. */
-/* Code originates and was built up from ftdi_sio, belkin, pl2303 and others. */
+/* Code originates and was built up from ftdi_sio, belkin, pl2303 and others.*/
 
 
 #include <linux/kernel.h>
@@ -62,7 +65,7 @@
 #include <linux/usb/serial.h>
 #include <linux/serial.h>
 #include <linux/delay.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #include "cypress_m8.h"
 
@@ -112,7 +115,7 @@ static struct usb_device_id id_table_combined [] = {
 	{ }						/* Terminating entry */
 };
 
-MODULE_DEVICE_TABLE (usb, id_table_combined);
+MODULE_DEVICE_TABLE(usb, id_table_combined);
 
 static struct usb_driver cypress_driver = {
 	.name =		"cypress",
@@ -146,11 +149,13 @@ struct cypress_private {
 	__u8 rx_flags;			   /* throttling - used from whiteheat/ftdi_sio */
 	enum packet_format pkt_fmt;	   /* format to use for packet send / receive */
 	int get_cfg_unsafe;		   /* If true, the CYPRESS_GET_CONFIG is unsafe */
-	int baud_rate;			   /* stores current baud rate in integer form */
+	int baud_rate;			   /* stores current baud rate in
+					      integer form */
 	int isthrottled;		   /* if throttled, discard reads */
 	wait_queue_head_t delta_msr_wait;  /* used for TIOCMIWAIT */
 	char prev_status, diff_status;	   /* used for TIOCMIWAIT */
-	/* we pass a pointer to this as the arguement sent to cypress_set_termios old_termios */
+	/* we pass a pointer to this as the arguement sent to
+	   cypress_set_termios old_termios */
 	struct ktermios tmp_termios; 	   /* stores the old termios settings */
 };
 
@@ -163,33 +168,41 @@ struct cypress_buf {
 };
 
 /* function prototypes for the Cypress USB to serial device */
-static int  cypress_earthmate_startup	(struct usb_serial *serial);
-static int  cypress_hidcom_startup	(struct usb_serial *serial);
-static int  cypress_ca42v2_startup	(struct usb_serial *serial);
-static void cypress_shutdown		(struct usb_serial *serial);
-static int  cypress_open		(struct tty_struct *tty, struct usb_serial_port *port, struct file *filp);
-static void cypress_close		(struct tty_struct *tty, struct usb_serial_port *port, struct file *filp);
-static int  cypress_write		(struct tty_struct *tty, struct usb_serial_port *port, const unsigned char *buf, int count);
-static void cypress_send		(struct usb_serial_port *port);
-static int  cypress_write_room		(struct tty_struct *tty);
-static int  cypress_ioctl		(struct tty_struct *tty, struct file * file, unsigned int cmd, unsigned long arg);
-static void cypress_set_termios		(struct tty_struct *tty, struct usb_serial_port *port, struct ktermios * old);
-static int  cypress_tiocmget		(struct tty_struct *tty, struct file *file);
-static int  cypress_tiocmset		(struct tty_struct *tty, struct file *file, unsigned int set, unsigned int clear);
-static int  cypress_chars_in_buffer	(struct tty_struct *tty);
-static void cypress_throttle		(struct tty_struct *tty);
-static void cypress_unthrottle		(struct tty_struct *tty);
-static void cypress_set_dead		(struct usb_serial_port *port);
-static void cypress_read_int_callback	(struct urb *urb);
-static void cypress_write_int_callback	(struct urb *urb);
+static int  cypress_earthmate_startup(struct usb_serial *serial);
+static int  cypress_hidcom_startup(struct usb_serial *serial);
+static int  cypress_ca42v2_startup(struct usb_serial *serial);
+static void cypress_shutdown(struct usb_serial *serial);
+static int  cypress_open(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp);
+static void cypress_close(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp);
+static int  cypress_write(struct tty_struct *tty, struct usb_serial_port *port,
+			const unsigned char *buf, int count);
+static void cypress_send(struct usb_serial_port *port);
+static int  cypress_write_room(struct tty_struct *tty);
+static int  cypress_ioctl(struct tty_struct *tty, struct file *file,
+			unsigned int cmd, unsigned long arg);
+static void cypress_set_termios(struct tty_struct *tty,
+			struct usb_serial_port *port, struct ktermios *old);
+static int  cypress_tiocmget(struct tty_struct *tty, struct file *file);
+static int  cypress_tiocmset(struct tty_struct *tty, struct file *file,
+			unsigned int set, unsigned int clear);
+static int  cypress_chars_in_buffer(struct tty_struct *tty);
+static void cypress_throttle(struct tty_struct *tty);
+static void cypress_unthrottle(struct tty_struct *tty);
+static void cypress_set_dead(struct usb_serial_port *port);
+static void cypress_read_int_callback(struct urb *urb);
+static void cypress_write_int_callback(struct urb *urb);
 /* write buffer functions */
 static struct cypress_buf *cypress_buf_alloc(unsigned int size);
-static void 		  cypress_buf_free(struct cypress_buf *cb);
-static void		  cypress_buf_clear(struct cypress_buf *cb);
-static unsigned int	  cypress_buf_data_avail(struct cypress_buf *cb);
-static unsigned int	  cypress_buf_space_avail(struct cypress_buf *cb);
-static unsigned int	  cypress_buf_put(struct cypress_buf *cb, const char *buf, unsigned int count);
-static unsigned int	  cypress_buf_get(struct cypress_buf *cb, char *buf, unsigned int count);
+static void cypress_buf_free(struct cypress_buf *cb);
+static void cypress_buf_clear(struct cypress_buf *cb);
+static unsigned int cypress_buf_data_avail(struct cypress_buf *cb);
+static unsigned int cypress_buf_space_avail(struct cypress_buf *cb);
+static unsigned int cypress_buf_put(struct cypress_buf *cb,
+					const char *buf, unsigned int count);
+static unsigned int cypress_buf_get(struct cypress_buf *cb,
+					char *buf, unsigned int count);
 
 
 static struct usb_serial_driver cypress_earthmate_device = {
@@ -247,7 +260,7 @@ static struct usb_serial_driver cypress_hidcom_device = {
 static struct usb_serial_driver cypress_ca42v2_device = {
 	.driver = {
 		.owner =		THIS_MODULE,
-                .name =			"nokiaca42v2",
+		.name =			"nokiaca42v2",
 	},
 	.description =			"Nokia CA-42 V2 Adapter",
 	.usb_driver = 			&cypress_driver,
@@ -322,7 +335,7 @@ static int analyze_baud_rate(struct usb_serial_port *port, speed_t new_rate)
 
 
 /* This function can either set or retrieve the current serial line settings */
-static int cypress_serial_control (struct tty_struct *tty,
+static int cypress_serial_control(struct tty_struct *tty,
 	struct usb_serial_port *port, speed_t baud_rate, int data_bits,
 	int stop_bits, int parity_enable, int parity_type, int reset,
 	int cypress_request_type)
@@ -333,111 +346,114 @@ static int cypress_serial_control (struct tty_struct *tty,
 	unsigned long flags;
 
 	dbg("%s", __func__);
-	
+
 	priv = usb_get_serial_port_data(port);
 
 	if (!priv->comm_is_ok)
 		return -ENODEV;
 
-	switch(cypress_request_type) {
-		case CYPRESS_SET_CONFIG:
+	switch (cypress_request_type) {
+	case CYPRESS_SET_CONFIG:
+		new_baudrate = priv->baud_rate;
+		/* 0 means 'Hang up' so doesn't change the true bit rate */
+		if (baud_rate == 0)
 			new_baudrate = priv->baud_rate;
-			/* 0 means 'Hang up' so doesn't change the true bit rate */
-			if (baud_rate == 0)
-				new_baudrate = priv->baud_rate;
-			/* Change of speed ? */
-			else if (baud_rate != priv->baud_rate) {
-				dbg("%s - baud rate is changing", __func__);
-				retval = analyze_baud_rate(port, baud_rate);
-				if (retval >=  0) {
-					new_baudrate = retval;
-					dbg("%s - New baud rate set to %d",
-					    __func__, new_baudrate);
-				}
-			}
-			dbg("%s - baud rate is being sent as %d", __func__, new_baudrate);
-			
-			memset(feature_buffer, 0, sizeof(feature_buffer));
-			/* fill the feature_buffer with new configuration */
-			*((u_int32_t *)feature_buffer) = new_baudrate;
-
-			feature_buffer[4] |= data_bits;   /* assign data bits in 2 bit space ( max 3 ) */
-			/* 1 bit gap */
-			feature_buffer[4] |= (stop_bits << 3);   /* assign stop bits in 1 bit space */
-			feature_buffer[4] |= (parity_enable << 4);   /* assign parity flag in 1 bit space */
-			feature_buffer[4] |= (parity_type << 5);   /* assign parity type in 1 bit space */
-			/* 1 bit gap */
-			feature_buffer[4] |= (reset << 7);   /* assign reset at end of byte, 1 bit space */
-				
-			dbg("%s - device is being sent this feature report:", __func__);
-			dbg("%s - %02X - %02X - %02X - %02X - %02X", __func__, feature_buffer[0], feature_buffer[1],
-		            feature_buffer[2], feature_buffer[3], feature_buffer[4]);
-			
-			do {
-				retval = usb_control_msg(port->serial->dev,
-						usb_sndctrlpipe(port->serial->dev, 0),
-						HID_REQ_SET_REPORT,
-						USB_DIR_OUT | USB_RECIP_INTERFACE | USB_TYPE_CLASS,
-						0x0300, 0, feature_buffer,
-						sizeof(feature_buffer), 500);
-
-				if (tries++ >= 3)
-					break;
-
-			} while (retval != sizeof(feature_buffer) &&
-				 retval != -ENODEV);
-
-			if (retval != sizeof(feature_buffer)) {
-				err("%s - failed sending serial line settings - %d", __func__, retval);
-				cypress_set_dead(port);
-			} else {
-				spin_lock_irqsave(&priv->lock, flags);
-				priv->baud_rate = new_baudrate;
-				priv->current_config = feature_buffer[4];
-				spin_unlock_irqrestore(&priv->lock, flags);
-				/* If we asked for a speed change encode it */
-				if (baud_rate)
-					tty_encode_baud_rate(tty,
-							new_baudrate, new_baudrate);
-			}
-		break;
-		case CYPRESS_GET_CONFIG:
-			if (priv->get_cfg_unsafe) {
-				/* Not implemented for this device,
-				   and if we try to do it we're likely
-				   to crash the hardware. */
-				return -ENOTTY;
-			}
-			dbg("%s - retreiving serial line settings", __func__);
-			/* set initial values in feature buffer */
-			memset(feature_buffer, 0, sizeof(feature_buffer));
-
-			do {
-				retval = usb_control_msg(port->serial->dev,
-						usb_rcvctrlpipe(port->serial->dev, 0),
-						HID_REQ_GET_REPORT,
-						USB_DIR_IN | USB_RECIP_INTERFACE | USB_TYPE_CLASS,
-						0x0300, 0, feature_buffer,
-						sizeof(feature_buffer), 500);
-
-				if (tries++ >= 3)
-					break;
-
-			} while (retval != sizeof(feature_buffer) &&
-				 retval != -ENODEV);
-
-			if (retval != sizeof(feature_buffer)) {
-				err("%s - failed to retrieve serial line settings - %d", __func__, retval);
-				cypress_set_dead(port);
-				return retval;
-			} else {
-				spin_lock_irqsave(&priv->lock, flags);
-
-				/* store the config in one byte, and later use bit masks to check values */
-				priv->current_config = feature_buffer[4];
-				priv->baud_rate = *((u_int32_t *)feature_buffer);
-				spin_unlock_irqrestore(&priv->lock, flags);
+		/* Change of speed ? */
+		else if (baud_rate != priv->baud_rate) {
+			dbg("%s - baud rate is changing", __func__);
+			retval = analyze_baud_rate(port, baud_rate);
+			if (retval >=  0) {
+				new_baudrate = retval;
+				dbg("%s - New baud rate set to %d",
+				    __func__, new_baudrate);
 			}
+		}
+		dbg("%s - baud rate is being sent as %d",
+					__func__, new_baudrate);
+
+		memset(feature_buffer, 0, sizeof(feature_buffer));
+		/* fill the feature_buffer with new configuration */
+		*((u_int32_t *)feature_buffer) = new_baudrate;
+		feature_buffer[4] |= data_bits;   /* assign data bits in 2 bit space ( max 3 ) */
+		/* 1 bit gap */
+		feature_buffer[4] |= (stop_bits << 3);   /* assign stop bits in 1 bit space */
+		feature_buffer[4] |= (parity_enable << 4);   /* assign parity flag in 1 bit space */
+		feature_buffer[4] |= (parity_type << 5);   /* assign parity type in 1 bit space */
+		/* 1 bit gap */
+		feature_buffer[4] |= (reset << 7);   /* assign reset at end of byte, 1 bit space */
+
+		dbg("%s - device is being sent this feature report:",
+								__func__);
+		dbg("%s - %02X - %02X - %02X - %02X - %02X", __func__,
+			feature_buffer[0], feature_buffer[1],
+			feature_buffer[2], feature_buffer[3],
+			feature_buffer[4]);
+
+		do {
+			retval = usb_control_msg(port->serial->dev,
+					usb_sndctrlpipe(port->serial->dev, 0),
+					HID_REQ_SET_REPORT,
+					USB_DIR_OUT | USB_RECIP_INTERFACE | USB_TYPE_CLASS,
+					0x0300, 0, feature_buffer,
+					sizeof(feature_buffer), 500);
+
+			if (tries++ >= 3)
+				break;
+
+		} while (retval != sizeof(feature_buffer) &&
+			 retval != -ENODEV);
+
+		if (retval != sizeof(feature_buffer)) {
+			err("%s - failed sending serial line settings - %d",
+							__func__, retval);
+			cypress_set_dead(port);
+		} else {
+			spin_lock_irqsave(&priv->lock, flags);
+			priv->baud_rate = new_baudrate;
+			priv->current_config = feature_buffer[4];
+			spin_unlock_irqrestore(&priv->lock, flags);
+			/* If we asked for a speed change encode it */
+			if (baud_rate)
+				tty_encode_baud_rate(tty,
+					new_baudrate, new_baudrate);
+		}
+	break;
+	case CYPRESS_GET_CONFIG:
+		if (priv->get_cfg_unsafe) {
+			/* Not implemented for this device,
+			   and if we try to do it we're likely
+			   to crash the hardware. */
+			return -ENOTTY;
+		}
+		dbg("%s - retreiving serial line settings", __func__);
+		/* set initial values in feature buffer */
+		memset(feature_buffer, 0, sizeof(feature_buffer));
+
+		do {
+			retval = usb_control_msg(port->serial->dev,
+					usb_rcvctrlpipe(port->serial->dev, 0),
+					HID_REQ_GET_REPORT,
+					USB_DIR_IN | USB_RECIP_INTERFACE | USB_TYPE_CLASS,
+					0x0300, 0, feature_buffer,
+					sizeof(feature_buffer), 500);
+
+			if (tries++ >= 3)
+				break;
+		} while (retval != sizeof(feature_buffer)
+						&& retval != -ENODEV);
+
+		if (retval != sizeof(feature_buffer)) {
+			err("%s - failed to retrieve serial line settings - %d", __func__, retval);
+			cypress_set_dead(port);
+			return retval;
+		} else {
+			spin_lock_irqsave(&priv->lock, flags);
+			/* store the config in one byte, and later
+			   use bit masks to check values */
+			priv->current_config = feature_buffer[4];
+			priv->baud_rate = *((u_int32_t *)feature_buffer);
+			spin_unlock_irqrestore(&priv->lock, flags);
+		}
 	}
 	spin_lock_irqsave(&priv->lock, flags);
 	++priv->cmd_count;
@@ -470,14 +486,14 @@ static void cypress_set_dead(struct usb_serial_port *port)
  *****************************************************************************/
 
 
-static int generic_startup (struct usb_serial *serial)
+static int generic_startup(struct usb_serial *serial)
 {
 	struct cypress_private *priv;
 	struct usb_serial_port *port = serial->port[0];
 
 	dbg("%s - port %d", __func__, port->number);
 
-	priv = kzalloc(sizeof (struct cypress_private), GFP_KERNEL);
+	priv = kzalloc(sizeof(struct cypress_private), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
@@ -489,9 +505,9 @@ static int generic_startup (struct usb_serial *serial)
 		return -ENOMEM;
 	}
 	init_waitqueue_head(&priv->delta_msr_wait);
-	
-	usb_reset_configuration (serial->dev);
-	
+
+	usb_reset_configuration(serial->dev);
+
 	priv->cmd_ctrl = 0;
 	priv->line_control = 0;
 	priv->termios_initialized = 0;
@@ -502,30 +518,30 @@ static int generic_startup (struct usb_serial *serial)
 	   small.  Otherwise we can use the slightly more compact
 	   format.  This is in accordance with the cypress_m8 serial
 	   converter app note. */
-	if (port->interrupt_out_size > 9) {
+	if (port->interrupt_out_size > 9)
 		priv->pkt_fmt = packet_format_1;
-	} else {
+	else
 		priv->pkt_fmt = packet_format_2;
-	}
+
 	if (interval > 0) {
 		priv->write_urb_interval = interval;
 		priv->read_urb_interval = interval;
 		dbg("%s - port %d read & write intervals forced to %d",
-		    __func__,port->number,interval);
+		    __func__, port->number, interval);
 	} else {
 		priv->write_urb_interval = port->interrupt_out_urb->interval;
 		priv->read_urb_interval = port->interrupt_in_urb->interval;
 		dbg("%s - port %d intervals: read=%d write=%d",
-		    __func__,port->number,
-		    priv->read_urb_interval,priv->write_urb_interval);
+		    __func__, port->number,
+		    priv->read_urb_interval, priv->write_urb_interval);
 	}
 	usb_set_serial_port_data(port, priv);
-	
+
 	return 0;
 }
 
 
-static int cypress_earthmate_startup (struct usb_serial *serial)
+static int cypress_earthmate_startup(struct usb_serial *serial)
 {
 	struct cypress_private *priv;
 	struct usb_serial_port *port = serial->port[0];
@@ -543,7 +559,8 @@ static int cypress_earthmate_startup (struct usb_serial *serial)
 	/* All Earthmate devices use the separated-count packet
 	   format!  Idiotic. */
 	priv->pkt_fmt = packet_format_1;
-	if (serial->dev->descriptor.idProduct != cpu_to_le16(PRODUCT_ID_EARTHMATEUSB)) {
+	if (serial->dev->descriptor.idProduct !=
+				cpu_to_le16(PRODUCT_ID_EARTHMATEUSB)) {
 		/* The old original USB Earthmate seemed able to
 		   handle GET_CONFIG requests; everything they've
 		   produced since that time crashes if this command is
@@ -557,7 +574,7 @@ static int cypress_earthmate_startup (struct usb_serial *serial)
 } /* cypress_earthmate_startup */
 
 
-static int cypress_hidcom_startup (struct usb_serial *serial)
+static int cypress_hidcom_startup(struct usb_serial *serial)
 {
 	struct cypress_private *priv;
 
@@ -571,12 +588,12 @@ static int cypress_hidcom_startup (struct usb_serial *serial)
 
 	priv = usb_get_serial_port_data(serial->port[0]);
 	priv->chiptype = CT_CYPHIDCOM;
-	
+
 	return 0;
 } /* cypress_hidcom_startup */
 
 
-static int cypress_ca42v2_startup (struct usb_serial *serial)
+static int cypress_ca42v2_startup(struct usb_serial *serial)
 {
 	struct cypress_private *priv;
 
@@ -595,11 +612,11 @@ static int cypress_ca42v2_startup (struct usb_serial *serial)
 } /* cypress_ca42v2_startup */
 
 
-static void cypress_shutdown (struct usb_serial *serial)
+static void cypress_shutdown(struct usb_serial *serial)
 {
 	struct cypress_private *priv;
 
-	dbg ("%s - port %d", __func__, serial->port[0]->number);
+	dbg("%s - port %d", __func__, serial->port[0]->number);
 
 	/* all open ports are closed at this point */
 
@@ -650,7 +667,9 @@ static int cypress_open(struct tty_struct *tty,
 	result = cypress_write(tty, port, NULL, 0);
 
 	if (result) {
-		dev_err(&port->dev, "%s - failed setting the control lines - error %d\n", __func__, result);
+		dev_err(&port->dev,
+			"%s - failed setting the control lines - error %d\n",
+							__func__, result);
 		return result;
 	} else
 		dbg("%s - success setting the control lines", __func__);
@@ -659,19 +678,22 @@ static int cypress_open(struct tty_struct *tty,
 		cypress_set_termios(tty, port, &priv->tmp_termios);
 
 	/* setup the port and start reading from the device */
-	if(!port->interrupt_in_urb){
+	if (!port->interrupt_in_urb) {
 		err("%s - interrupt_in_urb is empty!", __func__);
-		return(-1);
+		return -1;
 	}
 
 	usb_fill_int_urb(port->interrupt_in_urb, serial->dev,
 		usb_rcvintpipe(serial->dev, port->interrupt_in_endpointAddress),
-		port->interrupt_in_urb->transfer_buffer, port->interrupt_in_urb->transfer_buffer_length,
+		port->interrupt_in_urb->transfer_buffer,
+		port->interrupt_in_urb->transfer_buffer_length,
 		cypress_read_int_callback, port, priv->read_urb_interval);
 	result = usb_submit_urb(port->interrupt_in_urb, GFP_KERNEL);
 
-	if (result){
-		dev_err(&port->dev, "%s - failed submitting read urb, error %d\n", __func__, result);
+	if (result) {
+		dev_err(&port->dev,
+			"%s - failed submitting read urb, error %d\n",
+							__func__, result);
 		cypress_set_dead(port);
 	}
 
@@ -680,7 +702,7 @@ static int cypress_open(struct tty_struct *tty,
 
 
 static void cypress_close(struct tty_struct *tty,
-			struct usb_serial_port *port, struct file * filp)
+			struct usb_serial_port *port, struct file *filp)
 {
 	struct cypress_private *priv = usb_get_serial_port_data(port);
 	unsigned int c_cflag;
@@ -722,15 +744,15 @@ static void cypress_close(struct tty_struct *tty,
 	if (tty) {
 		bps = tty_get_baud_rate(tty);
 		if (bps > 1200)
-			timeout = max((HZ*2560)/bps,HZ/10);
+			timeout = max((HZ * 2560) / bps, HZ / 10);
 		else
-			timeout = 2*HZ;
+			timeout = 2 * HZ;
 		schedule_timeout_interruptible(timeout);
 	}
 
 	dbg("%s - stopping urbs", __func__);
-	usb_kill_urb (port->interrupt_in_urb);
-	usb_kill_urb (port->interrupt_out_urb);
+	usb_kill_urb(port->interrupt_in_urb);
+	usb_kill_urb(port->interrupt_out_urb);
 
 	if (tty) {
 		c_cflag = tty->termios->c_cflag;
@@ -746,8 +768,8 @@ static void cypress_close(struct tty_struct *tty,
 	}
 
 	if (stats)
-		dev_info (&port->dev, "Statistics: %d Bytes In | %d Bytes Out | %d Commands Issued\n",
-		          priv->bytes_in, priv->bytes_out, priv->cmd_count);
+		dev_info(&port->dev, "Statistics: %d Bytes In | %d Bytes Out | %d Commands Issued\n",
+			priv->bytes_in, priv->bytes_out, priv->cmd_count);
 	mutex_unlock(&port->serial->disc_mutex);
 } /* cypress_close */
 
@@ -757,7 +779,7 @@ static int cypress_write(struct tty_struct *tty, struct usb_serial_port *port,
 {
 	struct cypress_private *priv = usb_get_serial_port_data(port);
 	unsigned long flags;
-	
+
 	dbg("%s - port %d, %d bytes", __func__, port->number, count);
 
 	/* line control commands, which need to be executed immediately,
@@ -767,10 +789,10 @@ static int cypress_write(struct tty_struct *tty, struct usb_serial_port *port,
 		count = 0;
 		goto finish;
 	}
-	
+
 	if (!count)
 		return count;
-	
+
 	spin_lock_irqsave(&priv->lock, flags);
 	count = cypress_buf_put(priv->buf, buf, count);
 	spin_unlock_irqrestore(&priv->lock, flags);
@@ -787,13 +809,14 @@ static void cypress_send(struct usb_serial_port *port)
 	int count = 0, result, offset, actual_size;
 	struct cypress_private *priv = usb_get_serial_port_data(port);
 	unsigned long flags;
-	
+
 	if (!priv->comm_is_ok)
 		return;
 
 	dbg("%s - port %d", __func__, port->number);
-	dbg("%s - interrupt out size is %d", __func__, port->interrupt_out_size);
-	
+	dbg("%s - interrupt out size is %d", __func__,
+						port->interrupt_out_size);
+
 	spin_lock_irqsave(&priv->lock, flags);
 	if (priv->write_urb_in_use) {
 		dbg("%s - can't write, urb in use", __func__);
@@ -803,7 +826,8 @@ static void cypress_send(struct usb_serial_port *port)
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	/* clear buffer */
-	memset(port->interrupt_out_urb->transfer_buffer, 0, port->interrupt_out_size);
+	memset(port->interrupt_out_urb->transfer_buffer, 0,
+						port->interrupt_out_size);
 
 	spin_lock_irqsave(&priv->lock, flags);
 	switch (priv->pkt_fmt) {
@@ -834,9 +858,8 @@ static void cypress_send(struct usb_serial_port *port)
 	count = cypress_buf_get(priv->buf, &port->interrupt_out_buffer[offset],
 				port->interrupt_out_size-offset);
 
-	if (count == 0) {
+	if (count == 0)
 		return;
-	}
 
 	switch (priv->pkt_fmt) {
 	default:
@@ -860,26 +883,29 @@ send:
 		actual_size = count +
 			      (priv->pkt_fmt == packet_format_1 ? 2 : 1);
 
-	usb_serial_debug_data(debug, &port->dev, __func__, port->interrupt_out_size,
-			      port->interrupt_out_urb->transfer_buffer);
+	usb_serial_debug_data(debug, &port->dev, __func__,
+		port->interrupt_out_size,
+		port->interrupt_out_urb->transfer_buffer);
 
 	usb_fill_int_urb(port->interrupt_out_urb, port->serial->dev,
 		usb_sndintpipe(port->serial->dev, port->interrupt_out_endpointAddress),
 		port->interrupt_out_buffer, port->interrupt_out_size,
 		cypress_write_int_callback, port, priv->write_urb_interval);
-	result = usb_submit_urb (port->interrupt_out_urb, GFP_ATOMIC);
+	result = usb_submit_urb(port->interrupt_out_urb, GFP_ATOMIC);
 	if (result) {
-		dev_err(&port->dev, "%s - failed submitting write urb, error %d\n", __func__,
-			result);
+		dev_err(&port->dev,
+				"%s - failed submitting write urb, error %d\n",
+							__func__, result);
 		priv->write_urb_in_use = 0;
 		cypress_set_dead(port);
 	}
 
 	spin_lock_irqsave(&priv->lock, flags);
-	if (priv->cmd_ctrl) {
+	if (priv->cmd_ctrl)
 		priv->cmd_ctrl = 0;
-	}
-	priv->bytes_out += count; /* do not count the line control and size bytes */
+
+	/* do not count the line control and size bytes */
+	priv->bytes_out += count;
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	usb_serial_port_softint(port);
@@ -912,7 +938,7 @@ static int cypress_tiocmget(struct tty_struct *tty, struct file *file)
 	__u8 status, control;
 	unsigned int result = 0;
 	unsigned long flags;
-	
+
 	dbg("%s - port %d", __func__, port->number);
 
 	spin_lock_irqsave(&priv->lock, flags);
@@ -939,7 +965,7 @@ static int cypress_tiocmset(struct tty_struct *tty, struct file *file,
 	struct usb_serial_port *port = tty->driver_data;
 	struct cypress_private *priv = usb_get_serial_port_data(port);
 	unsigned long flags;
-	
+
 	dbg("%s - port %d", __func__, port->number);
 
 	spin_lock_irqsave(&priv->lock, flags);
@@ -958,7 +984,7 @@ static int cypress_tiocmset(struct tty_struct *tty, struct file *file,
 }
 
 
-static int cypress_ioctl(struct tty_struct *tty, struct file * file,
+static int cypress_ioctl(struct tty_struct *tty, struct file *file,
 					unsigned int cmd, unsigned long arg)
 {
 	struct usb_serial_port *port = tty->driver_data;
@@ -967,38 +993,37 @@ static int cypress_ioctl(struct tty_struct *tty, struct file * file,
 	dbg("%s - port %d, cmd 0x%.4x", __func__, port->number, cmd);
 
 	switch (cmd) {
-		/* This code comes from drivers/char/serial.c and ftdi_sio.c */
-		case TIOCMIWAIT:
-			while (priv != NULL) {
-				interruptible_sleep_on(&priv->delta_msr_wait);
-				/* see if a signal did it */
-				if (signal_pending(current))
-					return -ERESTARTSYS;
-				else {
-					char diff = priv->diff_status;
-
-					if (diff == 0) {
-						return -EIO; /* no change => error */
-					}
-					
-					/* consume all events */
-					priv->diff_status = 0;
-
-					/* return 0 if caller wanted to know about these bits */
-					if ( ((arg & TIOCM_RNG) && (diff & UART_RI)) ||
-					     ((arg & TIOCM_DSR) && (diff & UART_DSR)) ||
-					     ((arg & TIOCM_CD) && (diff & UART_CD)) ||
-					     ((arg & TIOCM_CTS) && (diff & UART_CTS)) ) {
-						return 0;
-					}
-					/* otherwise caller can't care less about what happened,
-					 * and so we continue to wait for more events.
-					 */
-				}
+	/* This code comes from drivers/char/serial.c and ftdi_sio.c */
+	case TIOCMIWAIT:
+		while (priv != NULL) {
+			interruptible_sleep_on(&priv->delta_msr_wait);
+			/* see if a signal did it */
+			if (signal_pending(current))
+				return -ERESTARTSYS;
+			else {
+				char diff = priv->diff_status;
+				if (diff == 0)
+					return -EIO; /* no change => error */
+
+				/* consume all events */
+				priv->diff_status = 0;
+
+				/* return 0 if caller wanted to know about
+				   these bits */
+				if (((arg & TIOCM_RNG) && (diff & UART_RI)) ||
+				    ((arg & TIOCM_DSR) && (diff & UART_DSR)) ||
+				    ((arg & TIOCM_CD) && (diff & UART_CD)) ||
+				    ((arg & TIOCM_CTS) && (diff & UART_CTS)))
+					return 0;
+				/* otherwise caller can't care less about what
+				 * happened, and so we continue to wait for
+				 * more events.
+				 */
 			}
-			return 0;
-		default:
-			break;
+		}
+		return 0;
+	default:
+		break;
 	}
 	dbg("%s - arg not supported - it was 0x%04x - check include/asm/ioctls.h", __func__, cmd);
 	return -ENOIOCTLCMD;
@@ -1070,23 +1095,22 @@ static void cypress_set_termios(struct tty_struct *tty,
 
 	if (cflag & CSIZE) {
 		switch (cflag & CSIZE) {
-			case CS5:
-				data_bits = 0;
-				break;
-			case CS6:
-				data_bits = 1;
-				break;
-			case CS7:
-				data_bits = 2;
-				break;
-			case CS8:
-				data_bits = 3;
-				break;
-			default:
-				err("%s - CSIZE was set, but not CS5-CS8",
-						__func__);
-				data_bits = 3;
-		}
+		case CS5:
+			data_bits = 0;
+			break;
+		case CS6:
+			data_bits = 1;
+			break;
+		case CS7:
+			data_bits = 2;
+			break;
+		case CS8:
+			data_bits = 3;
+			break;
+		default:
+			err("%s - CSIZE was set, but not CS5-CS8",
+					__func__);
+			data_bits = 3;
 	} else
 		data_bits = 3;
 
@@ -1104,8 +1128,10 @@ static void cypress_set_termios(struct tty_struct *tty,
 			"%d data_bits (+5)", __func__, stop_bits,
 			parity_enable, parity_type, data_bits);
 
-	cypress_serial_control(tty, port, tty_get_baud_rate(tty), data_bits, stop_bits,
-			parity_enable, parity_type, 0, CYPRESS_SET_CONFIG);
+	cypress_serial_control(tty, port, tty_get_baud_rate(tty),
+			data_bits, stop_bits,
+			parity_enable, parity_type,
+			0, CYPRESS_SET_CONFIG);
 
 	/* we perform a CYPRESS_GET_CONFIG so that the current settings are
 	 * filled into the private structure this should confirm that all is
@@ -1116,7 +1142,7 @@ static void cypress_set_termios(struct tty_struct *tty,
 	 * termios flag base comes from empeg.c */
 
 	spin_lock_irqsave(&priv->lock, flags);
-	if ( (priv->chiptype == CT_EARTHMATE) && (priv->baud_rate == 4800) ) {
+	if (priv->chiptype == CT_EARTHMATE && priv->baud_rate == 4800) {
 		dbg("Using custom termios settings for a baud rate of "
 				"4800bps.");
 		/* define custom termios settings for NMEA protocol */
@@ -1164,7 +1190,7 @@ static int cypress_chars_in_buffer(struct tty_struct *tty)
 	unsigned long flags;
 
 	dbg("%s - port %d", __func__, port->number);
-	
+
 	spin_lock_irqsave(&priv->lock, flags);
 	chars = cypress_buf_data_avail(priv->buf);
 	spin_unlock_irqrestore(&priv->lock, flags);
@@ -1243,12 +1269,13 @@ static void cypress_read_int_callback(struct urb *urb)
 		/* precursor to disconnect so just go away */
 		return;
 	case -EPIPE:
-		usb_clear_halt(port->serial->dev,0x81);
+		usb_clear_halt(port->serial->dev, 0x81);
 		break;
 	default:
 		/* something ugly is going on... */
-		dev_err(&urb->dev->dev,"%s - unexpected nonzero read status received: %d\n",
-			__func__, status);
+		dev_err(&urb->dev->dev,
+			"%s - unexpected nonzero read status received: %d\n",
+							__func__, status);
 		cypress_set_dead(port);
 		return;
 	}
@@ -1296,8 +1323,8 @@ static void cypress_read_int_callback(struct urb *urb)
 		goto continue_read;
 	}
 
-	usb_serial_debug_data (debug, &port->dev, __func__,
-			urb->actual_length, data);
+	usb_serial_debug_data(debug, &port->dev, __func__,
+						urb->actual_length, data);
 
 	spin_lock_irqsave(&priv->lock, flags);
 	/* check to see if status has changed */
@@ -1356,7 +1383,8 @@ continue_read:
 					port->interrupt_in_endpointAddress),
 				port->interrupt_in_urb->transfer_buffer,
 				port->interrupt_in_urb->transfer_buffer_length,
-				cypress_read_int_callback, port, priv->read_urb_interval);
+				cypress_read_int_callback, port,
+				priv->read_urb_interval);
 		result = usb_submit_urb(port->interrupt_in_urb, GFP_ATOMIC);
 		if (result) {
 			dev_err(&urb->dev->dev, "%s - failed resubmitting "
@@ -1380,42 +1408,43 @@ static void cypress_write_int_callback(struct urb *urb)
 	dbg("%s - port %d", __func__, port->number);
 
 	switch (status) {
-		case 0:
-			/* success */
+	case 0:
+		/* success */
+		break;
+	case -ECONNRESET:
+	case -ENOENT:
+	case -ESHUTDOWN:
+		/* this urb is terminated, clean up */
+		dbg("%s - urb shutting down with status: %d",
+						__func__, status);
+		priv->write_urb_in_use = 0;
+		return;
+	case -EPIPE: /* no break needed; clear halt and resubmit */
+		if (!priv->comm_is_ok)
 			break;
-		case -ECONNRESET:
-		case -ENOENT:
-		case -ESHUTDOWN:
-			/* this urb is terminated, clean up */
-			dbg("%s - urb shutting down with status: %d",
-			    __func__, status);
-			priv->write_urb_in_use = 0;
+		usb_clear_halt(port->serial->dev, 0x02);
+		/* error in the urb, so we have to resubmit it */
+		dbg("%s - nonzero write bulk status received: %d",
+			__func__, status);
+		port->interrupt_out_urb->transfer_buffer_length = 1;
+		port->interrupt_out_urb->dev = port->serial->dev;
+		result = usb_submit_urb(port->interrupt_out_urb, GFP_ATOMIC);
+		if (!result)
 			return;
-		case -EPIPE: /* no break needed; clear halt and resubmit */
-			if (!priv->comm_is_ok)
-				break;
-			usb_clear_halt(port->serial->dev, 0x02);
-			/* error in the urb, so we have to resubmit it */
-			dbg("%s - nonzero write bulk status received: %d",
-			    __func__, status);
-			port->interrupt_out_urb->transfer_buffer_length = 1;
-			port->interrupt_out_urb->dev = port->serial->dev;
-			result = usb_submit_urb(port->interrupt_out_urb, GFP_ATOMIC);
-			if (!result)
-				return;
-			dev_err(&urb->dev->dev, "%s - failed resubmitting write urb, error %d\n",
-				__func__, result);
-			cypress_set_dead(port);
-			break;
-		default:
-			dev_err(&urb->dev->dev,"%s - unexpected nonzero write status received: %d\n",
-				__func__, status);
-			cypress_set_dead(port);
-			break;
+		dev_err(&urb->dev->dev,
+			"%s - failed resubmitting write urb, error %d\n",
+							__func__, result);
+		cypress_set_dead(port);
+		break;
+	default:
+		dev_err(&urb->dev->dev,
+			 "%s - unexpected nonzero write status received: %d\n",
+							__func__, status);
+		cypress_set_dead(port);
+		break;
 	}
-	
 	priv->write_urb_in_use = 0;
-	
+
 	/* send any buffered data */
 	cypress_send(port);
 }
@@ -1497,7 +1526,8 @@ static void cypress_buf_clear(struct cypress_buf *cb)
 static unsigned int cypress_buf_data_avail(struct cypress_buf *cb)
 {
 	if (cb != NULL)
-		return ((cb->buf_size + cb->buf_put - cb->buf_get) % cb->buf_size);
+		return (cb->buf_size + cb->buf_put - cb->buf_get)
+							% cb->buf_size;
 	else
 		return 0;
 }
@@ -1513,7 +1543,8 @@ static unsigned int cypress_buf_data_avail(struct cypress_buf *cb)
 static unsigned int cypress_buf_space_avail(struct cypress_buf *cb)
 {
 	if (cb != NULL)
-		return ((cb->buf_size + cb->buf_get - cb->buf_put - 1) % cb->buf_size);
+		return (cb->buf_size + cb->buf_get - cb->buf_put - 1)
+							% cb->buf_size;
 	else
 		return 0;
 }
@@ -1613,9 +1644,9 @@ static unsigned int cypress_buf_get(struct cypress_buf *cb, char *buf,
 static int __init cypress_init(void)
 {
 	int retval;
-	
+
 	dbg("%s", __func__);
-	
+
 	retval = usb_serial_register(&cypress_earthmate_device);
 	if (retval)
 		goto failed_em_register;
@@ -1643,23 +1674,23 @@ failed_em_register:
 }
 
 
-static void __exit cypress_exit (void)
+static void __exit cypress_exit(void)
 {
 	dbg("%s", __func__);
 
-	usb_deregister (&cypress_driver);
-	usb_serial_deregister (&cypress_earthmate_device);
-	usb_serial_deregister (&cypress_hidcom_device);
-	usb_serial_deregister (&cypress_ca42v2_device);
+	usb_deregister(&cypress_driver);
+	usb_serial_deregister(&cypress_earthmate_device);
+	usb_serial_deregister(&cypress_hidcom_device);
+	usb_serial_deregister(&cypress_ca42v2_device);
 }
 
 
 module_init(cypress_init);
 module_exit(cypress_exit);
 
-MODULE_AUTHOR( DRIVER_AUTHOR );
-MODULE_DESCRIPTION( DRIVER_DESC );
-MODULE_VERSION( DRIVER_VERSION );
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_VERSION(DRIVER_VERSION);
 MODULE_LICENSE("GPL");
 
 module_param(debug, bool, S_IRUGO | S_IWUSR);
diff --git a/drivers/usb/serial/cypress_m8.h b/drivers/usb/serial/cypress_m8.h
index 0388065..e772b01 100644
--- a/drivers/usb/serial/cypress_m8.h
+++ b/drivers/usb/serial/cypress_m8.h
@@ -54,7 +54,7 @@
 #define UART_DSR	0x20	/* data set ready - flow control - device to host */
 #define CONTROL_RTS 	0x10	/* request to send - flow control - host to device */
 #define UART_CTS	0x10	/* clear to send - flow control - device to host */
-#define	UART_RI		0x10	/* ring indicator - modem - device to host */ 
+#define	UART_RI		0x10	/* ring indicator - modem - device to host */
 #define UART_CD		0x40	/* carrier detect - modem - device to host */
 #define CYP_ERROR 	0x08	/* received from input report - device to host */
 /* Note - the below has nothing to to with the "feature report" reset */

