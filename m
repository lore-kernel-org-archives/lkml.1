Return-Path: <linux-kernel-owner+w=401wt.eu-S932462AbYFTUlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932462AbYFTUlo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762700AbYFTUYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:24:09 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58353 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762688AbYFTUYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:24:07 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 64/70] tty-usb-oti6858: Coding style
To: linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 21:06:42 +0100
Message-ID: <20080620200640.1479.93783.stgit@localhost.localdomain>
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

 drivers/usb/serial/oti6858.c |  136 ++++++++++++++++++++++--------------------
 1 files changed, 70 insertions(+), 66 deletions(-)


diff --git a/drivers/usb/serial/oti6858.c b/drivers/usb/serial/oti6858.c
index 069d276..81db571 100644
--- a/drivers/usb/serial/oti6858.c
+++ b/drivers/usb/serial/oti6858.c
@@ -25,7 +25,8 @@
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License.
  *
- * See Documentation/usb/usb-serial.txt for more information on using this driver
+ * See Documentation/usb/usb-serial.txt for more information on using this
+ * driver
  *
  * TODO:
  *  - implement correct flushing for ioctls and oti6858_close()
@@ -49,7 +50,7 @@
 #include <linux/spinlock.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include "oti6858.h"
 
 #define OTI6858_DESCRIPTION \
@@ -135,9 +136,9 @@ struct oti6858_control_pkt {
 
 #define OTI6858_CTRL_PKT_SIZE	sizeof(struct oti6858_control_pkt)
 #define OTI6858_CTRL_EQUALS_PENDING(a, priv) \
-	(    ((a)->divisor == (priv)->pending_setup.divisor) \
+	(((a)->divisor == (priv)->pending_setup.divisor) \
 	  && ((a)->control == (priv)->pending_setup.control) \
-	  && ((a)->frame_fmt == (priv)->pending_setup.frame_fmt) )
+	  && ((a)->frame_fmt == (priv)->pending_setup.frame_fmt))
 
 /* function prototypes */
 static int oti6858_open(struct tty_struct *tty,
@@ -220,7 +221,7 @@ struct oti6858_private {
 	struct delayed_work delayed_setup_work;
 
 	wait_queue_head_t intr_wait;
-        struct usb_serial_port *port;   /* USB port with which associated */
+	struct usb_serial_port *port;   /* USB port with which associated */
 };
 
 #undef dbg
@@ -229,7 +230,8 @@ struct oti6858_private {
 
 static void setup_line(struct work_struct *work)
 {
-	struct oti6858_private *priv = container_of(work, struct oti6858_private, delayed_setup_work.work);
+	struct oti6858_private *priv = container_of(work,
+			struct oti6858_private, delayed_setup_work.work);
 	struct usb_serial_port *port = priv->port;
 	struct oti6858_control_pkt *new_setup;
 	unsigned long flags;
@@ -237,10 +239,12 @@ static void setup_line(struct work_struct *work)
 
 	dbg("%s(port = %d)", __func__, port->number);
 
-	if ((new_setup = kmalloc(OTI6858_CTRL_PKT_SIZE, GFP_KERNEL)) == NULL) {
+	new_setup = kmalloc(OTI6858_CTRL_PKT_SIZE, GFP_KERNEL);
+	if (new_setup == NULL) {
 		dev_err(&port->dev, "%s(): out of memory!\n", __func__);
 		/* we will try again */
-		schedule_delayed_work(&priv->delayed_setup_work, msecs_to_jiffies(2));
+		schedule_delayed_work(&priv->delayed_setup_work,
+						msecs_to_jiffies(2));
 		return;
 	}
 
@@ -256,7 +260,8 @@ static void setup_line(struct work_struct *work)
 		dev_err(&port->dev, "%s(): error reading status\n", __func__);
 		kfree(new_setup);
 		/* we will try again */
-		schedule_delayed_work(&priv->delayed_setup_work, msecs_to_jiffies(2));
+		schedule_delayed_work(&priv->delayed_setup_work,
+							msecs_to_jiffies(2));
 		return;
 	}
 
@@ -297,7 +302,8 @@ static void setup_line(struct work_struct *work)
 
 void send_data(struct work_struct *work)
 {
-	struct oti6858_private *priv = container_of(work, struct oti6858_private, delayed_write_work.work);
+	struct oti6858_private *priv = container_of(work,
+			struct oti6858_private, delayed_write_work.work);
 	struct usb_serial_port *port = priv->port;
 	int count = 0, result;
 	unsigned long flags;
@@ -308,7 +314,8 @@ void send_data(struct work_struct *work)
 	spin_lock_irqsave(&priv->lock, flags);
 	if (priv->flags.write_urb_in_use) {
 		spin_unlock_irqrestore(&priv->lock, flags);
-		schedule_delayed_work(&priv->delayed_write_work, msecs_to_jiffies(2));
+		schedule_delayed_work(&priv->delayed_write_work,
+						msecs_to_jiffies(2));
 		return;
 	}
 	priv->flags.write_urb_in_use = 1;
@@ -359,8 +366,8 @@ void send_data(struct work_struct *work)
 
 static int oti6858_startup(struct usb_serial *serial)
 {
-        struct usb_serial_port *port = serial->port[0];
-        struct oti6858_private *priv;
+	struct usb_serial_port *port = serial->port[0];
+	struct oti6858_private *priv;
 	int i;
 
 	for (i = 0; i < serial->num_ports; ++i) {
@@ -375,8 +382,8 @@ static int oti6858_startup(struct usb_serial *serial)
 
 		spin_lock_init(&priv->lock);
 		init_waitqueue_head(&priv->intr_wait);
-//		INIT_WORK(&priv->setup_work, setup_line, serial->port[i]);
-//		INIT_WORK(&priv->write_work, send_data, serial->port[i]);
+/*		INIT_WORK(&priv->setup_work, setup_line, serial->port[i]); */
+/*		INIT_WORK(&priv->write_work, send_data, serial->port[i]); */
 		priv->port = port;
 		INIT_DELAYED_WORK(&priv->delayed_setup_work, setup_line);
 		INIT_DELAYED_WORK(&priv->delayed_write_work, send_data);
@@ -482,19 +489,19 @@ static void oti6858_set_termios(struct tty_struct *tty,
 
 	frame_fmt &= ~FMT_DATA_BITS_MASK;
 	switch (cflag & CSIZE) {
-		case CS5:
-			frame_fmt |= FMT_DATA_BITS_5;
-			break;
-		case CS6:
-			frame_fmt |= FMT_DATA_BITS_6;
-			break;
-		case CS7:
-			frame_fmt |= FMT_DATA_BITS_7;
-			break;
-		default:
-		case CS8:
-			frame_fmt |= FMT_DATA_BITS_8;
-			break;
+	case CS5:
+		frame_fmt |= FMT_DATA_BITS_5;
+		break;
+	case CS6:
+		frame_fmt |= FMT_DATA_BITS_6;
+		break;
+	case CS7:
+		frame_fmt |= FMT_DATA_BITS_7;
+		break;
+	default:
+	case CS8:
+		frame_fmt |= FMT_DATA_BITS_8;
+		break;
 	}
 
 	/* manufacturer claims that this device can work with baud rates
@@ -517,19 +524,17 @@ static void oti6858_set_termios(struct tty_struct *tty,
 	}
 
 	frame_fmt &= ~FMT_STOP_BITS_MASK;
-	if ((cflag & CSTOPB) != 0) {
+	if ((cflag & CSTOPB) != 0)
 		frame_fmt |= FMT_STOP_BITS_2;
-	} else {
+	else
 		frame_fmt |= FMT_STOP_BITS_1;
-	}
 
 	frame_fmt &= ~FMT_PARITY_MASK;
 	if ((cflag & PARENB) != 0) {
-		if ((cflag & PARODD) != 0) {
+		if ((cflag & PARODD) != 0)
 			frame_fmt |= FMT_PARITY_ODD;
-		} else {
+		else
 			frame_fmt |= FMT_PARITY_EVEN;
-		}
 	} else {
 		frame_fmt |= FMT_PARITY_NONE;
 	}
@@ -584,7 +589,8 @@ static int oti6858_open(struct tty_struct *tty,
 	if (port->port.count != 1)
 		return 0;
 
-	if ((buf = kmalloc(OTI6858_CTRL_PKT_SIZE, GFP_KERNEL)) == NULL) {
+	buf = kmalloc(OTI6858_CTRL_PKT_SIZE, GFP_KERNEL);
+	if (buf == NULL) {
 		dev_err(&port->dev, "%s(): out of memory!\n", __func__);
 		return -ENOMEM;
 	}
@@ -729,11 +735,10 @@ static int oti6858_tiocmset(struct tty_struct *tty, struct file *file,
 	if ((clear & TIOCM_DTR) != 0)
 		control &= ~CONTROL_DTR_HIGH;
 
-	if (control != priv->pending_setup.control) {
+	if (control != priv->pending_setup.control)
 		priv->pending_setup.control = control;
-	}
-	spin_unlock_irqrestore(&priv->lock, flags);
 
+	spin_unlock_irqrestore(&priv->lock, flags);
 	return 0;
 }
 
@@ -785,7 +790,8 @@ static int wait_modem_info(struct usb_serial_port *port, unsigned int arg)
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	while (1) {
-		wait_event_interruptible(priv->intr_wait, priv->status.pin_state != prev);
+		wait_event_interruptible(priv->intr_wait,
+					priv->status.pin_state != prev);
 		if (signal_pending(current))
 			return -ERESTARTSYS;
 
@@ -795,12 +801,11 @@ static int wait_modem_info(struct usb_serial_port *port, unsigned int arg)
 
 		changed = prev ^ status;
 		/* FIXME: check if this is correct (active high/low) */
-		if (	((arg & TIOCM_RNG) && (changed & PIN_RI)) ||
-			((arg & TIOCM_DSR) && (changed & PIN_DSR)) ||
-			((arg & TIOCM_CD)  && (changed & PIN_DCD)) ||
-			((arg & TIOCM_CTS) && (changed & PIN_CTS))) {
-				return 0;
-		}
+		if (((arg & TIOCM_RNG) && (changed & PIN_RI)) ||
+		    ((arg & TIOCM_DSR) && (changed & PIN_DSR)) ||
+		    ((arg & TIOCM_CD)  && (changed & PIN_DCD)) ||
+		    ((arg & TIOCM_CTS) && (changed & PIN_CTS)))
+			return 0;
 		prev = status;
 	}
 
@@ -817,15 +822,13 @@ static int oti6858_ioctl(struct tty_struct *tty, struct file *file,
 				__func__, port->number, cmd, arg);
 
 	switch (cmd) {
-		case TIOCMIWAIT:
-			dbg("%s(): TIOCMIWAIT", __func__);
-			return wait_modem_info(port, arg);
-
-		default:
-			dbg("%s(): 0x%04x not supported", __func__, cmd);
-			break;
+	case TIOCMIWAIT:
+		dbg("%s(): TIOCMIWAIT", __func__);
+		return wait_modem_info(port, arg);
+	default:
+		dbg("%s(): 0x%04x not supported", __func__, cmd);
+		break;
 	}
-
 	return -ENOIOCTLCMD;
 }
 
@@ -941,7 +944,7 @@ static void oti6858_read_int_callback(struct urb *urb)
 		spin_lock_irqsave(&priv->lock, flags);
 		if (priv->flags.write_urb_in_use == 0
 				&& oti6858_buf_data_avail(priv->buf) != 0) {
-			schedule_delayed_work(&priv->delayed_write_work,0);
+			schedule_delayed_work(&priv->delayed_write_work, 0);
 			resubmit = 0;
 		}
 		spin_unlock_irqrestore(&priv->lock, flags);
@@ -950,7 +953,7 @@ static void oti6858_read_int_callback(struct urb *urb)
 	if (resubmit) {
 		int result;
 
-//		dbg("%s(): submitting interrupt urb", __func__);
+/*		dbg("%s(): submitting interrupt urb", __func__); */
 		urb->dev = port->serial->dev;
 		result = usb_submit_urb(urb, GFP_ATOMIC);
 		if (result != 0) {
@@ -985,8 +988,10 @@ static void oti6858_read_bulk_callback(struct urb *urb)
 		}
 		/*
 		if (status == -EPROTO) {
-			// PL2303 mysteriously fails with -EPROTO reschedule the read
-			dbg("%s - caught -EPROTO, resubmitting the urb", __func__);
+			* PL2303 mysteriously fails with -EPROTO reschedule
+			   the read *
+			dbg("%s - caught -EPROTO, resubmitting the urb",
+								__func__);
 			result = usb_submit_urb(urb, GFP_ATOMIC);
 			if (result)
 				dev_err(&urb->dev->dev, "%s - failed resubmitting read urb, error %d\n", __func__, result);
@@ -1003,7 +1008,7 @@ static void oti6858_read_bulk_callback(struct urb *urb)
 		tty_flip_buffer_push(tty);
 	}
 
-	// schedule the interrupt urb if we are still open */
+	/* schedule the interrupt urb if we are still open */
 	if (port->port.count != 0) {
 		port->interrupt_in_urb->dev = port->serial->dev;
 		result = usb_submit_urb(port->interrupt_in_urb, GFP_ATOMIC);
@@ -1055,7 +1060,7 @@ static void oti6858_write_bulk_callback(struct urb *urb)
 
 	priv->flags.write_urb_in_use = 0;
 
-	// schedule the interrupt urb if we are still open */
+	/* schedule the interrupt urb if we are still open */
 	port->interrupt_in_urb->dev = port->serial->dev;
 	dbg("%s(): submitting interrupt urb", __func__);
 	result = usb_submit_urb(port->interrupt_in_urb, GFP_ATOMIC);
@@ -1130,7 +1135,7 @@ static unsigned int oti6858_buf_data_avail(struct oti6858_buf *pb)
 {
 	if (pb == NULL)
 		return 0;
-	return ((pb->buf_size + pb->buf_put - pb->buf_get) % pb->buf_size);
+	return (pb->buf_size + pb->buf_put - pb->buf_get) % pb->buf_size;
 }
 
 /*
@@ -1143,7 +1148,7 @@ static unsigned int oti6858_buf_space_avail(struct oti6858_buf *pb)
 {
 	if (pb == NULL)
 		return 0;
-	return ((pb->buf_size + pb->buf_get - pb->buf_put - 1) % pb->buf_size);
+	return (pb->buf_size + pb->buf_get - pb->buf_put - 1) % pb->buf_size;
 }
 
 /*
@@ -1230,13 +1235,12 @@ static int __init oti6858_init(void)
 {
 	int retval;
 
-	if ((retval = usb_serial_register(&oti6858_device)) == 0) {
-		if ((retval = usb_register(&oti6858_driver)) != 0)
+	retval = usb_serial_register(&oti6858_device);
+	if (retval == 0) {
+		retval = usb_register(&oti6858_driver);
+		if (retval)
 			usb_serial_deregister(&oti6858_device);
-		else
-			return 0;
 	}
-
 	return retval;
 }
 

