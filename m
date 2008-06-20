Return-Path: <linux-kernel-owner+w=401wt.eu-S932151AbYFTUjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932151AbYFTUjg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:39:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762480AbYFTUXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:23:31 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58343 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762465AbYFTUX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:23:29 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 59/70] tty-usb-pl2303: Coding style
To: linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 21:06:05 +0100
Message-ID: <20080620200602.1479.242.stgit@localhost.localdomain>
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

 drivers/usb/serial/pl2303.c |   64 ++++++++++++++++++++++++-------------------
 1 files changed, 36 insertions(+), 28 deletions(-)


diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index 8eec785..a65328a 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -10,7 +10,8 @@
  *	modify it under the terms of the GNU General Public License version
  *	2 as published by the Free Software Foundation.
  *
- * See Documentation/usb/usb-serial.txt for more information on using this driver
+ * See Documentation/usb/usb-serial.txt for more information on using this
+ * driver
  *
  */
 
@@ -25,7 +26,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/spinlock.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
 #include "pl2303.h"
@@ -115,7 +116,7 @@ static struct usb_driver pl2303_driver = {
 #define CONTROL_RTS			0x02
 
 #define BREAK_REQUEST_TYPE		0x21
-#define BREAK_REQUEST			0x23	
+#define BREAK_REQUEST			0x23
 #define BREAK_ON			0xffff
 #define BREAK_OFF			0x0000
 
@@ -221,7 +222,7 @@ static unsigned int pl2303_buf_data_avail(struct pl2303_buf *pb)
 	if (pb == NULL)
 		return 0;
 
-	return ((pb->buf_size + pb->buf_put - pb->buf_get) % pb->buf_size);
+	return (pb->buf_size + pb->buf_put - pb->buf_get) % pb->buf_size;
 }
 
 /*
@@ -235,7 +236,7 @@ static unsigned int pl2303_buf_space_avail(struct pl2303_buf *pb)
 	if (pb == NULL)
 		return 0;
 
-	return ((pb->buf_size + pb->buf_get - pb->buf_put - 1) % pb->buf_size);
+	return (pb->buf_size + pb->buf_get - pb->buf_put - 1) % pb->buf_size;
 }
 
 /*
@@ -394,7 +395,7 @@ static int pl2303_startup(struct usb_serial *serial)
 
 cleanup:
 	kfree(buf);
-	for (--i; i>=0; --i) {
+	for (--i; i >= 0; --i) {
 		priv = usb_get_serial_port_data(serial->port[i]);
 		pl2303_buf_free(priv->buf);
 		kfree(priv);
@@ -406,7 +407,7 @@ cleanup:
 static int set_control_lines(struct usb_device *dev, u8 value)
 {
 	int retval;
-	
+
 	retval = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
 				 SET_CONTROL_REQUEST, SET_CONTROL_REQUEST_TYPE,
 				 value, 0, NULL, 0, 100);
@@ -451,7 +452,7 @@ static void pl2303_send(struct usb_serial_port *port)
 		dev_err(&port->dev, "%s - failed submitting write urb,"
 			" error %d\n", __func__, result);
 		priv->write_urb_in_use = 0;
-		// TODO: reschedule pl2303_send
+		/* TODO: reschedule pl2303_send */
 	}
 
 	usb_serial_port_softint(port);
@@ -560,11 +561,19 @@ static void pl2303_set_termios(struct tty_struct *tty,
 
 	if (cflag & CSIZE) {
 		switch (cflag & CSIZE) {
-			case CS5:	buf[6] = 5;	break;
-			case CS6:	buf[6] = 6;	break;
-			case CS7:	buf[6] = 7;	break;
-			default:
-			case CS8:	buf[6] = 8;	break;
+		case CS5:
+			buf[6] = 5;
+			break;
+		case CS6:
+			buf[6] = 6;
+			break;
+		case CS7:
+			buf[6] = 7;
+			break;
+		default:
+		case CS8:
+			buf[6] = 8;
+			break;
 		}
 		dbg("%s - data bits = %d", __func__, buf[6]);
 	}
@@ -693,7 +702,7 @@ static void pl2303_close(struct tty_struct *tty,
 	/* that is not unnecessarily long) */
 	bps = tty_get_baud_rate(tty);
 	if (bps > 1200)
-		timeout = max((HZ*2560)/bps,HZ/10);
+		timeout = max((HZ*2560)/bps, HZ/10);
 	else
 		timeout = 2*HZ;
 	schedule_timeout_interruptible(timeout);
@@ -739,7 +748,7 @@ static int pl2303_open(struct tty_struct *tty,
 	if (tty)
 		pl2303_set_termios(tty, port, &tmp_termios);
 
-	//FIXME: need to assert RTS and DTR if CRTSCTS off
+	/* FIXME: need to assert RTS and DTR if CRTSCTS off */
 
 	dbg("%s - submitting read urb", __func__);
 	port->read_urb->dev = serial->dev;
@@ -842,12 +851,12 @@ static int wait_modem_info(struct usb_serial_port *port, unsigned int arg)
 		status = priv->line_status;
 		spin_unlock_irqrestore(&priv->lock, flags);
 
-		changed=prevstatus^status;
+		changed = prevstatus ^ status;
 
 		if (((arg & TIOCM_RNG) && (changed & UART_RING)) ||
 		    ((arg & TIOCM_DSR) && (changed & UART_DSR)) ||
 		    ((arg & TIOCM_CD)  && (changed & UART_DCD)) ||
-		    ((arg & TIOCM_CTS) && (changed & UART_CTS)) ) {
+		    ((arg & TIOCM_CTS) && (changed & UART_CTS))) {
 			return 0;
 		}
 		prevstatus = status;
@@ -863,15 +872,13 @@ static int pl2303_ioctl(struct tty_struct *tty, struct file *file,
 	dbg("%s (%d) cmd = 0x%04x", __func__, port->number, cmd);
 
 	switch (cmd) {
-		case TIOCMIWAIT:
-			dbg("%s (%d) TIOCMIWAIT", __func__,  port->number);
-			return wait_modem_info(port, arg);
-
-		default:
-			dbg("%s not supported = 0x%04x", __func__, cmd);
-			break;
+	case TIOCMIWAIT:
+		dbg("%s (%d) TIOCMIWAIT", __func__,  port->number);
+		return wait_modem_info(port, arg);
+	default:
+		dbg("%s not supported = 0x%04x", __func__, cmd);
+		break;
 	}
-
 	return -ENOIOCTLCMD;
 }
 
@@ -888,7 +895,8 @@ static void pl2303_break_ctl(struct tty_struct *tty, int break_state)
 		state = BREAK_OFF;
 	else
 		state = BREAK_ON;
-	dbg("%s - turning break %s", __func__, state==BREAK_OFF ? "off" : "on");
+	dbg("%s - turning break %s", __func__,
+			state == BREAK_OFF ? "off" : "on");
 
 	result = usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
 				 BREAK_REQUEST, BREAK_REQUEST_TYPE, state,
@@ -942,7 +950,7 @@ static void pl2303_update_line_status(struct usb_serial_port *port,
 	if (actual_length < length)
 		return;
 
-        /* Save off the uart status for others to look at */
+	/* Save off the uart status for others to look at */
 	spin_lock_irqsave(&priv->lock, flags);
 	priv->line_status = data[status_idx];
 	spin_unlock_irqrestore(&priv->lock, flags);
@@ -1041,7 +1049,7 @@ static void pl2303_read_bulk_callback(struct urb *urb)
 
 	/* break takes precedence over parity, */
 	/* which takes precedence over framing errors */
-	if (line_status & UART_BREAK_ERROR )
+	if (line_status & UART_BREAK_ERROR)
 		tty_flag = TTY_BREAK;
 	else if (line_status & UART_PARITY_ERROR)
 		tty_flag = TTY_PARITY;

