Return-Path: <linux-kernel-owner+w=401wt.eu-S932384AbYFTUkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384AbYFTUkw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:40:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762636AbYFTUXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:23:54 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58349 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762616AbYFTUXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:23:52 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 62/70] tty-usb-ti-usb: Coding style
To: linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 21:06:27 +0100
Message-ID: <20080620200625.1479.23754.stgit@localhost.localdomain>
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

 drivers/usb/serial/ti_usb_3410_5052.c |  270 +++++++++++++++++++--------------
 1 files changed, 153 insertions(+), 117 deletions(-)


diff --git a/drivers/usb/serial/ti_usb_3410_5052.c b/drivers/usb/serial/ti_usb_3410_5052.c
index 9f03dcd..3da1505 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -16,7 +16,7 @@
  * For questions or problems with this driver, contact Texas Instruments
  * technical support, or Al Borchers <alborchers@steinerpoint.com>, or
  * Peter Berger <pberger@brimson.com>.
- * 
+ *
  * This driver needs this hotplug script in /etc/hotplug/usb/ti_usb_3410_5052
  * or in /etc/hotplug.d/usb/ti_usb_3410_5052.hotplug to set the device
  * configuration.
@@ -82,7 +82,7 @@
 #include <linux/serial.h>
 #include <linux/circ_buf.h>
 #include <linux/mutex.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
 
@@ -158,21 +158,22 @@ struct ti_device {
 static int ti_startup(struct usb_serial *serial);
 static void ti_shutdown(struct usb_serial *serial);
 static int ti_open(struct tty_struct *tty, struct usb_serial_port *port,
-				struct file *file);
+		struct file *file);
 static void ti_close(struct tty_struct *tty, struct usb_serial_port *port,
-				struct file *file);
+		struct file *file);
 static int ti_write(struct tty_struct *tty, struct usb_serial_port *port,
-				const unsigned char *data, int count);
+		const unsigned char *data, int count);
 static int ti_write_room(struct tty_struct *tty);
 static int ti_chars_in_buffer(struct tty_struct *tty);
 static void ti_throttle(struct tty_struct *tty);
 static void ti_unthrottle(struct tty_struct *tty);
-static int ti_ioctl(struct tty_struct *tty, struct file *file, unsigned int cmd, unsigned long arg);
-static void ti_set_termios(struct tty_struct *tty, struct usb_serial_port *port,
-	struct ktermios *old_termios);
+static int ti_ioctl(struct tty_struct *tty, struct file *file,
+		unsigned int cmd, unsigned long arg);
+static void ti_set_termios(struct tty_struct *tty,
+		struct usb_serial_port *port, struct ktermios *old_termios);
 static int ti_tiocmget(struct tty_struct *tty, struct file *file);
 static int ti_tiocmset(struct tty_struct *tty, struct file *file,
-	unsigned int set, unsigned int clear);
+		unsigned int set, unsigned int clear);
 static void ti_break(struct tty_struct *tty, int break_state);
 static void ti_interrupt_callback(struct urb *urb);
 static void ti_bulk_in_callback(struct urb *urb);
@@ -331,19 +332,25 @@ module_param(debug, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(debug, "Enable debugging, 0=no, 1=yes");
 
 module_param(low_latency, bool, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(low_latency, "TTY low_latency flag, 0=off, 1=on, default is off");
+MODULE_PARM_DESC(low_latency,
+		"TTY low_latency flag, 0=off, 1=on, default is off");
 
 module_param(closing_wait, int, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(closing_wait, "Maximum wait for data to drain in close, in .01 secs, default is 4000");
+MODULE_PARM_DESC(closing_wait,
+    "Maximum wait for data to drain in close, in .01 secs, default is 4000");
 
 module_param_array(vendor_3410, ushort, &vendor_3410_count, S_IRUGO);
-MODULE_PARM_DESC(vendor_3410, "Vendor ids for 3410 based devices, 1-5 short integers");
+MODULE_PARM_DESC(vendor_3410,
+		"Vendor ids for 3410 based devices, 1-5 short integers");
 module_param_array(product_3410, ushort, &product_3410_count, S_IRUGO);
-MODULE_PARM_DESC(product_3410, "Product ids for 3410 based devices, 1-5 short integers");
+MODULE_PARM_DESC(product_3410,
+		"Product ids for 3410 based devices, 1-5 short integers");
 module_param_array(vendor_5052, ushort, &vendor_5052_count, S_IRUGO);
-MODULE_PARM_DESC(vendor_5052, "Vendor ids for 5052 based devices, 1-5 short integers");
+MODULE_PARM_DESC(vendor_5052,
+		"Vendor ids for 5052 based devices, 1-5 short integers");
 module_param_array(product_5052, ushort, &product_5052_count, S_IRUGO);
-MODULE_PARM_DESC(product_5052, "Product ids for 5052 based devices, 1-5 short integers");
+MODULE_PARM_DESC(product_5052,
+		"Product ids for 5052 based devices, 1-5 short integers");
 
 MODULE_DEVICE_TABLE(usb, ti_id_table_combined);
 
@@ -352,18 +359,18 @@ MODULE_DEVICE_TABLE(usb, ti_id_table_combined);
 
 static int __init ti_init(void)
 {
-	int i,j;
+	int i, j;
 	int ret;
 
 	/* insert extra vendor and product ids */
 	j = ARRAY_SIZE(ti_id_table_3410) - TI_EXTRA_VID_PID_COUNT - 1;
-	for (i=0; i<min(vendor_3410_count,product_3410_count); i++,j++) {
+	for (i = 0; i < min(vendor_3410_count, product_3410_count); i++, j++) {
 		ti_id_table_3410[j].idVendor = vendor_3410[i];
 		ti_id_table_3410[j].idProduct = product_3410[i];
 		ti_id_table_3410[j].match_flags = USB_DEVICE_ID_MATCH_DEVICE;
 	}
 	j = ARRAY_SIZE(ti_id_table_5052) - TI_EXTRA_VID_PID_COUNT - 1;
-	for (i=0; i<min(vendor_5052_count,product_5052_count); i++,j++) {
+	for (i = 0; i < min(vendor_5052_count, product_5052_count); i++, j++) {
 		ti_id_table_5052[j].idVendor = vendor_5052[i];
 		ti_id_table_5052[j].idProduct = product_5052[i];
 		ti_id_table_5052[j].match_flags = USB_DEVICE_ID_MATCH_DEVICE;
@@ -432,7 +439,8 @@ static int ti_startup(struct usb_serial *serial)
 	/* determine device type */
 	if (usb_match_id(serial->interface, ti_id_table_3410))
 		tdev->td_is_3410 = 1;
-	dbg("%s - device type is %s", __func__, tdev->td_is_3410 ? "3410" : "5052");
+	dbg("%s - device type is %s", __func__,
+				tdev->td_is_3410 ? "3410" : "5052");
 
 	/* if we have only 1 configuration, download firmware */
 	if (dev->descriptor.bNumConfigurations == 1) {
@@ -451,7 +459,7 @@ static int ti_startup(struct usb_serial *serial)
 
 		status = -ENODEV;
 		goto free_tdev;
-	} 
+	}
 
 	/* the second configuration must be set (in sysfs by hotplug script) */
 	if (dev->actconfig->desc.bConfigurationValue == TI_BOOT_CONFIG) {
@@ -468,7 +476,8 @@ static int ti_startup(struct usb_serial *serial)
 			goto free_tports;
 		}
 		spin_lock_init(&tport->tp_lock);
-		tport->tp_uart_base_addr = (i == 0 ? TI_UART1_BASE_ADDR : TI_UART2_BASE_ADDR);
+		tport->tp_uart_base_addr = (i == 0 ?
+				TI_UART1_BASE_ADDR : TI_UART2_BASE_ADDR);
 		tport->tp_flags = low_latency ? ASYNC_LOW_LATENCY : 0;
 		tport->tp_closing_wait = closing_wait;
 		init_waitqueue_head(&tport->tp_msr_wait);
@@ -485,11 +494,11 @@ static int ti_startup(struct usb_serial *serial)
 		usb_set_serial_port_data(serial->port[i], tport);
 		tport->tp_uart_mode = 0;	/* default is RS232 */
 	}
-	
+
 	return 0;
 
 free_tports:
-	for (--i; i>=0; --i) {
+	for (--i; i >= 0; --i) {
 		tport = usb_get_serial_port_data(serial->port[i]);
 		ti_buf_free(tport->tp_write_buf);
 		kfree(tport);
@@ -510,7 +519,7 @@ static void ti_shutdown(struct usb_serial *serial)
 
 	dbg("%s", __func__);
 
-	for (i=0; i < serial->num_ports; ++i) {
+	for (i = 0; i < serial->num_ports; ++i) {
 		tport = usb_get_serial_port_data(serial->port[i]);
 		if (tport) {
 			ti_buf_free(tport->tp_write_buf);
@@ -533,8 +542,8 @@ static int ti_open(struct tty_struct *tty,
 	struct urb *urb;
 	int port_number;
 	int status;
-	__u16 open_settings = (__u8)(TI_PIPE_MODE_CONTINOUS | 
-			     TI_PIPE_TIMEOUT_ENABLE | 
+	__u16 open_settings = (__u8)(TI_PIPE_MODE_CONTINOUS |
+			     TI_PIPE_TIMEOUT_ENABLE |
 			     (TI_TRANSFER_TIMEOUT << 2));
 
 	dbg("%s - port %d", __func__, port->number);
@@ -565,7 +574,8 @@ static int ti_open(struct tty_struct *tty,
 		dbg("%s - start interrupt in urb", __func__);
 		urb = tdev->td_serial->port[0]->interrupt_in_urb;
 		if (!urb) {
-			dev_err(&port->dev, "%s - no interrupt urb\n", __func__);
+			dev_err(&port->dev, "%s - no interrupt urb\n",
+								__func__);
 			status = -EINVAL;
 			goto release_lock;
 		}
@@ -574,7 +584,9 @@ static int ti_open(struct tty_struct *tty,
 		urb->dev = dev;
 		status = usb_submit_urb(urb, GFP_KERNEL);
 		if (status) {
-			dev_err(&port->dev, "%s - submit interrupt urb failed, %d\n", __func__, status);
+			dev_err(&port->dev,
+				"%s - submit interrupt urb failed, %d\n",
+					__func__, status);
 			goto release_lock;
 		}
 	}
@@ -586,7 +598,8 @@ static int ti_open(struct tty_struct *tty,
 	status = ti_command_out_sync(tdev, TI_OPEN_PORT,
 		(__u8)(TI_UART1_PORT + port_number), open_settings, NULL, 0);
 	if (status) {
-		dev_err(&port->dev, "%s - cannot send open command, %d\n", __func__, status);
+		dev_err(&port->dev, "%s - cannot send open command, %d\n",
+							__func__, status);
 		goto unlink_int_urb;
 	}
 
@@ -594,7 +607,8 @@ static int ti_open(struct tty_struct *tty,
 	status = ti_command_out_sync(tdev, TI_START_PORT,
 		(__u8)(TI_UART1_PORT + port_number), 0, NULL, 0);
 	if (status) {
-		dev_err(&port->dev, "%s - cannot send start command, %d\n", __func__, status);
+		dev_err(&port->dev, "%s - cannot send start command, %d\n",
+							__func__, status);
 		goto unlink_int_urb;
 	}
 
@@ -602,13 +616,15 @@ static int ti_open(struct tty_struct *tty,
 	status = ti_command_out_sync(tdev, TI_PURGE_PORT,
 		(__u8)(TI_UART1_PORT + port_number), TI_PURGE_INPUT, NULL, 0);
 	if (status) {
-		dev_err(&port->dev, "%s - cannot clear input buffers, %d\n", __func__, status);
+		dev_err(&port->dev, "%s - cannot clear input buffers, %d\n",
+							__func__, status);
 		goto unlink_int_urb;
 	}
 	status = ti_command_out_sync(tdev, TI_PURGE_PORT,
 		(__u8)(TI_UART1_PORT + port_number), TI_PURGE_OUTPUT, NULL, 0);
 	if (status) {
-		dev_err(&port->dev, "%s - cannot clear output buffers, %d\n", __func__, status);
+		dev_err(&port->dev, "%s - cannot clear output buffers, %d\n",
+							__func__, status);
 		goto unlink_int_urb;
 	}
 
@@ -624,7 +640,8 @@ static int ti_open(struct tty_struct *tty,
 	status = ti_command_out_sync(tdev, TI_OPEN_PORT,
 		(__u8)(TI_UART1_PORT + port_number), open_settings, NULL, 0);
 	if (status) {
-		dev_err(&port->dev, "%s - cannot send open command (2), %d\n", __func__, status);
+		dev_err(&port->dev, "%s - cannot send open command (2), %d\n",
+							__func__, status);
 		goto unlink_int_urb;
 	}
 
@@ -632,7 +649,8 @@ static int ti_open(struct tty_struct *tty,
 	status = ti_command_out_sync(tdev, TI_START_PORT,
 		(__u8)(TI_UART1_PORT + port_number), 0, NULL, 0);
 	if (status) {
-		dev_err(&port->dev, "%s - cannot send start command (2), %d\n", __func__, status);
+		dev_err(&port->dev, "%s - cannot send start command (2), %d\n",
+							__func__, status);
 		goto unlink_int_urb;
 	}
 
@@ -650,7 +668,8 @@ static int ti_open(struct tty_struct *tty,
 	urb->dev = dev;
 	status = usb_submit_urb(urb, GFP_KERNEL);
 	if (status) {
-		dev_err(&port->dev, "%s - submit read urb failed, %d\n", __func__, status);
+		dev_err(&port->dev, "%s - submit read urb failed, %d\n",
+							__func__, status);
 		goto unlink_int_urb;
 	}
 
@@ -679,7 +698,7 @@ static void ti_close(struct tty_struct *tty, struct usb_serial_port *port,
 	int do_unlock;
 
 	dbg("%s - port %d", __func__, port->number);
-			 
+
 	tdev = usb_get_serial_data(port->serial);
 	tport = usb_get_serial_port_data(port);
 	if (tdev == NULL || tport == NULL)
@@ -699,7 +718,9 @@ static void ti_close(struct tty_struct *tty, struct usb_serial_port *port,
 	status = ti_command_out_sync(tdev, TI_CLOSE_PORT,
 		     (__u8)(TI_UART1_PORT + port_number), 0, NULL, 0);
 	if (status)
-		dev_err(&port->dev, "%s - cannot send close port command, %d\n" , __func__, status);
+		dev_err(&port->dev,
+			"%s - cannot send close port command, %d\n"
+							, __func__, status);
 
 	/* if mutex_lock is interrupted, continue anyway */
 	do_unlock = !mutex_lock_interruptible(&tdev->td_open_close_lock);
@@ -753,7 +774,7 @@ static int ti_write_room(struct tty_struct *tty)
 
 	if (tport == NULL)
 		return -ENODEV;
-	
+
 	spin_lock_irqsave(&tport->tp_lock, flags);
 	room = ti_buf_space_avail(tport->tp_write_buf);
 	spin_unlock_irqrestore(&tport->tp_lock, flags);
@@ -814,7 +835,8 @@ static void ti_unthrottle(struct tty_struct *tty)
 	if (I_IXOFF(tty) || C_CRTSCTS(tty)) {
 		status = ti_restart_read(tport, tty);
 		if (status)
-			dev_err(&port->dev, "%s - cannot restart read, %d\n", __func__, status);
+			dev_err(&port->dev, "%s - cannot restart read, %d\n",
+							__func__, status);
 	}
 }
 
@@ -833,44 +855,42 @@ static int ti_ioctl(struct tty_struct *tty, struct file *file,
 		return -ENODEV;
 
 	switch (cmd) {
-		case TIOCGSERIAL:
-			dbg("%s - (%d) TIOCGSERIAL", __func__, port->number);
-			return ti_get_serial_info(tport, (struct serial_struct __user *)arg);
-			break;
-
-		case TIOCSSERIAL:
-			dbg("%s - (%d) TIOCSSERIAL", __func__, port->number);
-			return ti_set_serial_info(tport, (struct serial_struct __user *)arg);
-			break;
-
-		case TIOCMIWAIT:
-			dbg("%s - (%d) TIOCMIWAIT", __func__, port->number);
-			cprev = tport->tp_icount;
-			while (1) {
-				interruptible_sleep_on(&tport->tp_msr_wait);
-				if (signal_pending(current))
-					return -ERESTARTSYS;
-				cnow = tport->tp_icount;
-				if (cnow.rng == cprev.rng && cnow.dsr == cprev.dsr &&
-				    cnow.dcd == cprev.dcd && cnow.cts == cprev.cts)
-					return -EIO; /* no change => error */
-				if (((arg & TIOCM_RNG) && (cnow.rng != cprev.rng)) ||
-				    ((arg & TIOCM_DSR) && (cnow.dsr != cprev.dsr)) ||
-				    ((arg & TIOCM_CD)  && (cnow.dcd != cprev.dcd)) ||
-				    ((arg & TIOCM_CTS) && (cnow.cts != cprev.cts)) ) {
-					return 0;
-				}
-				cprev = cnow;
-			}
-			break;
-
-		case TIOCGICOUNT:
-			dbg("%s - (%d) TIOCGICOUNT RX=%d, TX=%d", __func__, port->number, tport->tp_icount.rx, tport->tp_icount.tx);
-			if (copy_to_user((void __user *)arg, &tport->tp_icount, sizeof(tport->tp_icount)))
-				return -EFAULT;
-			return 0;
+	case TIOCGSERIAL:
+		dbg("%s - (%d) TIOCGSERIAL", __func__, port->number);
+		return ti_get_serial_info(tport,
+				(struct serial_struct __user *)arg);
+	case TIOCSSERIAL:
+		dbg("%s - (%d) TIOCSSERIAL", __func__, port->number);
+		return ti_set_serial_info(tport,
+					(struct serial_struct __user *)arg);
+	case TIOCMIWAIT:
+		dbg("%s - (%d) TIOCMIWAIT", __func__, port->number);
+		cprev = tport->tp_icount;
+		while (1) {
+			interruptible_sleep_on(&tport->tp_msr_wait);
+			if (signal_pending(current))
+				return -ERESTARTSYS;
+			cnow = tport->tp_icount;
+			if (cnow.rng == cprev.rng && cnow.dsr == cprev.dsr &&
+			    cnow.dcd == cprev.dcd && cnow.cts == cprev.cts)
+				return -EIO; /* no change => error */
+			if (((arg & TIOCM_RNG) && (cnow.rng != cprev.rng)) ||
+			    ((arg & TIOCM_DSR) && (cnow.dsr != cprev.dsr)) ||
+			    ((arg & TIOCM_CD)  && (cnow.dcd != cprev.dcd)) ||
+			    ((arg & TIOCM_CTS) && (cnow.cts != cprev.cts)))
+				return 0;
+			cprev = cnow;
+		}
+		break;
+	case TIOCGICOUNT:
+		dbg("%s - (%d) TIOCGICOUNT RX=%d, TX=%d",
+				__func__, port->number,
+				tport->tp_icount.rx, tport->tp_icount.tx);
+		if (copy_to_user((void __user *)arg, &tport->tp_icount,
+					sizeof(tport->tp_icount)))
+			return -EFAULT;
+		return 0;
 	}
-
 	return -ENOIOCTLCMD;
 }
 
@@ -880,7 +900,7 @@ static void ti_set_termios(struct tty_struct *tty,
 {
 	struct ti_port *tport = usb_get_serial_port_data(port);
 	struct ti_uart_config *config;
-	tcflag_t cflag,iflag;
+	tcflag_t cflag, iflag;
 	int baud;
 	int status;
 	int port_number = port->number - port->serial->minor;
@@ -892,7 +912,8 @@ static void ti_set_termios(struct tty_struct *tty,
 	iflag = tty->termios->c_iflag;
 
 	dbg("%s - cflag %08x, iflag %08x", __func__, cflag, iflag);
-	dbg("%s - old clfag %08x, old iflag %08x", __func__, old_termios->c_cflag, old_termios->c_iflag);
+	dbg("%s - old clfag %08x, old iflag %08x", __func__,
+				old_termios->c_cflag, old_termios->c_iflag);
 
 	if (tport == NULL)
 		return;
@@ -911,19 +932,19 @@ static void ti_set_termios(struct tty_struct *tty,
 	config->bUartMode = (__u8)(tport->tp_uart_mode);
 
 	switch (cflag & CSIZE) {
-		case CS5:
-			    config->bDataBits = TI_UART_5_DATA_BITS;
-			    break;
-		case CS6:
-			    config->bDataBits = TI_UART_6_DATA_BITS;
-			    break;
-		case CS7:
-			    config->bDataBits = TI_UART_7_DATA_BITS;
-			    break;
-		default:
-		case CS8:
-			    config->bDataBits = TI_UART_8_DATA_BITS;
-			    break;
+	case CS5:
+		    config->bDataBits = TI_UART_5_DATA_BITS;
+		    break;
+	case CS6:
+		    config->bDataBits = TI_UART_6_DATA_BITS;
+		    break;
+	case CS7:
+		    config->bDataBits = TI_UART_7_DATA_BITS;
+		    break;
+	default:
+	case CS8:
+		    config->bDataBits = TI_UART_8_DATA_BITS;
+		    break;
 	}
 
 	/* CMSPAR isn't supported by this driver */
@@ -939,7 +960,7 @@ static void ti_set_termios(struct tty_struct *tty,
 		}
 	} else {
 		config->wFlags &= ~TI_UART_ENABLE_PARITY_CHECKING;
-		config->bParity = TI_UART_NO_PARITY; 	
+		config->bParity = TI_UART_NO_PARITY;
 	}
 
 	if (cflag & CSTOPB)
@@ -992,7 +1013,8 @@ static void ti_set_termios(struct tty_struct *tty,
 		(__u8)(TI_UART1_PORT + port_number), 0, (__u8 *)config,
 		sizeof(*config));
 	if (status)
-		dev_err(&port->dev, "%s - cannot set config on port %d, %d\n", __func__, port_number, status);
+		dev_err(&port->dev, "%s - cannot set config on port %d, %d\n",
+					__func__, port_number, status);
 
 	/* SET_CONFIG asserts RTS and DTR, reset them correctly */
 	mcr = tport->tp_shadow_mcr;
@@ -1001,7 +1023,9 @@ static void ti_set_termios(struct tty_struct *tty,
 		mcr &= ~(TI_MCR_DTR | TI_MCR_RTS);
 	status = ti_set_mcr(tport, mcr);
 	if (status)
-		dev_err(&port->dev, "%s - cannot set modem control on port %d, %d\n", __func__, port_number, status);
+		dev_err(&port->dev,
+			"%s - cannot set modem control on port %d, %d\n",
+						__func__, port_number, status);
 
 	kfree(config);
 }
@@ -1143,10 +1167,12 @@ static void ti_interrupt_callback(struct urb *urb)
 	port_number = TI_GET_PORT_FROM_CODE(data[0]);
 	function = TI_GET_FUNC_FROM_CODE(data[0]);
 
-	dbg("%s - port_number %d, function %d, data 0x%02X", __func__, port_number, function, data[1]);
+	dbg("%s - port_number %d, function %d, data 0x%02X",
+				__func__, port_number, function, data[1]);
 
 	if (port_number >= serial->num_ports) {
-		dev_err(dev, "%s - bad port number, %d\n", __func__, port_number);
+		dev_err(dev, "%s - bad port number, %d\n",
+						__func__, port_number);
 		goto exit;
 	}
 
@@ -1158,7 +1184,8 @@ static void ti_interrupt_callback(struct urb *urb)
 
 	switch (function) {
 	case TI_CODE_DATA_ERROR:
-		dev_err(dev, "%s - DATA ERROR, port %d, data 0x%02X\n", __func__, port_number, data[1]);
+		dev_err(dev, "%s - DATA ERROR, port %d, data 0x%02X\n",
+					__func__, port_number, data[1]);
 		break;
 
 	case TI_CODE_MODEM_STATUS:
@@ -1168,7 +1195,8 @@ static void ti_interrupt_callback(struct urb *urb)
 		break;
 
 	default:
-		dev_err(dev, "%s - unknown interrupt code, 0x%02X\n", __func__, data[1]);
+		dev_err(dev, "%s - unknown interrupt code, 0x%02X\n",
+							__func__, data[1]);
 		break;
 	}
 
@@ -1202,7 +1230,7 @@ static void ti_bulk_in_callback(struct urb *urb)
 		return;
 	default:
 		dev_err(dev, "%s - nonzero urb status, %d\n",
-			__func__, status );
+			__func__, status);
 		tport->tp_tdev->td_urb_error = 1;
 		wake_up_interruptible(&tport->tp_write_wait);
 	}
@@ -1222,8 +1250,9 @@ static void ti_bulk_in_callback(struct urb *urb)
 		if (!tport->tp_is_open)
 			dbg("%s - port closed, dropping data", __func__);
 		else
-			ti_recv(&urb->dev->dev, port->port.tty, urb->transfer_buffer,
-				urb->actual_length);
+			ti_recv(&urb->dev->dev, port->port.tty,
+						urb->transfer_buffer,
+						urb->actual_length);
 
 		spin_lock(&tport->tp_lock);
 		tport->tp_icount.rx += urb->actual_length;
@@ -1287,8 +1316,9 @@ static void ti_recv(struct device *dev, struct tty_struct *tty,
 	do {
 		cnt = tty_buffer_request_room(tty, length);
 		if (cnt < length) {
-			dev_err(dev, "%s - dropping data, %d bytes lost\n", __func__, length - cnt);
-			if(cnt == 0)
+			dev_err(dev, "%s - dropping data, %d bytes lost\n",
+						__func__, length - cnt);
+			if (cnt == 0)
 				break;
 		}
 		tty_insert_flip_string(tty, data, cnt);
@@ -1330,7 +1360,8 @@ static void ti_send(struct ti_port *tport)
 
 	spin_unlock_irqrestore(&tport->tp_lock, flags);
 
-	usb_serial_debug_data(debug, &port->dev, __func__, count, port->write_urb->transfer_buffer);
+	usb_serial_debug_data(debug, &port->dev, __func__, count,
+					port->write_urb->transfer_buffer);
 
 	usb_fill_bulk_urb(port->write_urb, port->serial->dev,
 			   usb_sndbulkpipe(port->serial->dev,
@@ -1340,8 +1371,9 @@ static void ti_send(struct ti_port *tport)
 
 	result = usb_submit_urb(port->write_urb, GFP_ATOMIC);
 	if (result) {
-		dev_err(&port->dev, "%s - submit write urb failed, %d\n", __func__, result);
-		tport->tp_write_urb_in_use = 0; 
+		dev_err(&port->dev, "%s - submit write urb failed, %d\n",
+							__func__, result);
+		tport->tp_write_urb_in_use = 0;
 		/* TODO: reschedule ti_send */
 	} else {
 		spin_lock_irqsave(&tport->tp_lock, flags);
@@ -1376,7 +1408,7 @@ static int ti_set_mcr(struct ti_port *tport, unsigned int mcr)
 
 static int ti_get_lsr(struct ti_port *tport)
 {
-	int size,status;
+	int size, status;
 	struct ti_device *tdev = tport->tp_tdev;
 	struct usb_serial_port *port = tport->tp_port;
 	int port_number = port->number - port->serial->minor;
@@ -1394,7 +1426,9 @@ static int ti_get_lsr(struct ti_port *tport)
 	status = ti_command_in_sync(tdev, TI_GET_PORT_STATUS,
 		(__u8)(TI_UART1_PORT+port_number), 0, (__u8 *)data, size);
 	if (status) {
-		dev_err(&port->dev, "%s - get port status command failed, %d\n", __func__, status);
+		dev_err(&port->dev,
+			"%s - get port status command failed, %d\n",
+							__func__, status);
 		goto free_data;
 	}
 
@@ -1630,7 +1664,8 @@ static int ti_write_byte(struct ti_device *tdev, unsigned long addr,
 	struct ti_write_data_bytes *data;
 	struct device *dev = &tdev->td_serial->dev->dev;
 
-	dbg("%s - addr 0x%08lX, mask 0x%02X, byte 0x%02X", __func__, addr, mask, byte);
+	dbg("%s - addr 0x%08lX, mask 0x%02X, byte 0x%02X",
+					__func__, addr, mask, byte);
 
 	size = sizeof(struct ti_write_data_bytes) + 2;
 	data = kmalloc(size, GFP_KERNEL);
@@ -1667,12 +1702,12 @@ static int ti_do_download(struct usb_device *dev, int pipe,
 	struct ti_firmware_header *header;
 	int status;
 	int len;
-	
-	for(pos = sizeof(struct ti_firmware_header); pos < size; pos++)
+
+	for (pos = sizeof(struct ti_firmware_header); pos < size; pos++)
 		cs = (__u8)(cs + buffer[pos]);
 
 	header = (struct ti_firmware_header *)buffer;
-	header->wLength = cpu_to_le16((__u16)(size 
+	header->wLength = cpu_to_le16((__u16)(size
 					- sizeof(struct ti_firmware_header)));
 	header->bCheckSum = cs;
 
@@ -1731,11 +1766,12 @@ static int ti_download_firmware(struct ti_device *tdev, int type)
 		ti_do_download(dev, pipe, buffer, fw_p->size);
 		kfree(buffer);
 	}
-#ifdef CONFIG_USB_SERIAL_TI_FIRMWARE	
+#ifdef CONFIG_USB_SERIAL_TI_FIRMWARE
 	release_firmware(fw_p);
-#endif	
+#endif
 	if (status) {
-		dev_err(&dev->dev, "%s - error downloading firmware, %d\n", __func__, status);
+		dev_err(&dev->dev, "%s - error downloading firmware, %d\n",
+							__func__, status);
 		return status;
 	}
 
@@ -1807,7 +1843,7 @@ static void ti_buf_clear(struct circ_buf *cb)
 
 static int ti_buf_data_avail(struct circ_buf *cb)
 {
-	return CIRC_CNT(cb->head,cb->tail,TI_WRITE_BUF_SIZE);
+	return CIRC_CNT(cb->head, cb->tail, TI_WRITE_BUF_SIZE);
 }
 
 
@@ -1820,7 +1856,7 @@ static int ti_buf_data_avail(struct circ_buf *cb)
 
 static int ti_buf_space_avail(struct circ_buf *cb)
 {
-	return CIRC_SPACE(cb->head,cb->tail,TI_WRITE_BUF_SIZE);
+	return CIRC_SPACE(cb->head, cb->tail, TI_WRITE_BUF_SIZE);
 }
 
 

