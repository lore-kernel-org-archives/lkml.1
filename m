Return-Path: <linux-kernel-owner+w=401wt.eu-S1762696AbYFTUYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762696AbYFTUYI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:24:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757630AbYFTUTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:19:10 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35177 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760768AbYFTUSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:18:50 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 24/70] whiteheat: coding style
To: linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 21:01:17 +0100
Message-ID: <20080620200114.1479.93917.stgit@localhost.localdomain>
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

Bring ezusb and whiteheat into line with the coding style

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/usb/serial/ezusb.c     |   22 +-
 drivers/usb/serial/whiteheat.c |  429 ++++++++++++++++++++++------------------
 drivers/usb/serial/whiteheat.h |   78 +++++--
 3 files changed, 302 insertions(+), 227 deletions(-)


diff --git a/drivers/usb/serial/ezusb.c b/drivers/usb/serial/ezusb.c
index cc4fbd9..711e84f 100644
--- a/drivers/usb/serial/ezusb.c
+++ b/drivers/usb/serial/ezusb.c
@@ -20,7 +20,8 @@
 /* EZ-USB Control and Status Register.  Bit 0 controls 8051 reset */
 #define CPUCS_REG    0x7F92
 
-int ezusb_writememory (struct usb_serial *serial, int address, unsigned char *data, int length, __u8 bRequest)
+int ezusb_writememory(struct usb_serial *serial, int address,
+				unsigned char *data, int length, __u8 request)
 {
 	int result;
 	unsigned char *transfer_buffer;
@@ -33,26 +34,27 @@ int ezusb_writememory (struct usb_serial *serial, int address, unsigned char *da
 
 	transfer_buffer = kmemdup(data, length, GFP_KERNEL);
 	if (!transfer_buffer) {
-		dev_err(&serial->dev->dev, "%s - kmalloc(%d) failed.\n", __func__, length);
+		dev_err(&serial->dev->dev, "%s - kmalloc(%d) failed.\n",
+							__func__, length);
 		return -ENOMEM;
 	}
-	result = usb_control_msg (serial->dev, usb_sndctrlpipe(serial->dev, 0), bRequest, 0x40, address, 0, transfer_buffer, length, 3000);
-	kfree (transfer_buffer);
+	result = usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
+		     request, 0x40, address, 0, transfer_buffer, length, 3000);
+	kfree(transfer_buffer);
 	return result;
 }
+EXPORT_SYMBOL_GPL(ezusb_writememory);
 
-int ezusb_set_reset (struct usb_serial *serial, unsigned char reset_bit)
+int ezusb_set_reset(struct usb_serial *serial, unsigned char reset_bit)
 {
 	int response;
 
 	/* dbg("%s - %d", __func__, reset_bit); */
-	response = ezusb_writememory (serial, CPUCS_REG, &reset_bit, 1, 0xa0);
+	response = ezusb_writememory(serial, CPUCS_REG, &reset_bit, 1, 0xa0);
 	if (response < 0)
-		dev_err(&serial->dev->dev, "%s- %d failed\n", __func__, reset_bit);
+		dev_err(&serial->dev->dev, "%s- %d failed\n",
+						__func__, reset_bit);
 	return response;
 }
-
-
-EXPORT_SYMBOL_GPL(ezusb_writememory);
 EXPORT_SYMBOL_GPL(ezusb_set_reset);
 
diff --git a/drivers/usb/serial/whiteheat.c b/drivers/usb/serial/whiteheat.c
index fdadf39..5a3ed57 100644
--- a/drivers/usb/serial/whiteheat.c
+++ b/drivers/usb/serial/whiteheat.c
@@ -12,29 +12,31 @@
  *	the Free Software Foundation; either version 2 of the License, or
  *	(at your option) any later version.
  *
- * See Documentation/usb/usb-serial.txt for more information on using this driver
+ * See Documentation/usb/usb-serial.txt for more information on using this
+ * driver
  *
  * (10/09/2002) Stuart MacDonald (stuartm@connecttech.com)
  *	Upgrade to full working driver
  *
  * (05/30/2001) gkh
- *	switched from using spinlock to a semaphore, which fixes lots of problems.
+ *	switched from using spinlock to a semaphore, which fixes lots of
+ *	problems.
  *
  * (04/08/2001) gb
  *	Identify version on module load.
- * 
+ *
  * 2001_Mar_19 gkh
- *	Fixed MOD_INC and MOD_DEC logic, the ability to open a port more 
+ *	Fixed MOD_INC and MOD_DEC logic, the ability to open a port more
  *	than once, and the got the proper usb_device_id table entries so
  *	the driver works again.
  *
  * (11/01/2000) Adam J. Richter
  *	usb_device_id table support
- * 
+ *
  * (10/05/2000) gkh
  *	Fixed bug with urb->dev not being set properly, now that the usb
  *	core needs it.
- * 
+ *
  * (10/03/2000) smd
  *	firmware is improved to guard against crap sent to device
  *	firmware now replies CMD_FAILURE on bad things
@@ -52,9 +54,9 @@
  *	Fixed bug with port->minor that was found by Al Borchers
  *
  * (07/04/2000) gkh
- *	Added support for port settings. Baud rate can now be changed. Line signals
- *	are not transferred to and from the tty layer yet, but things seem to be 
- *	working well now.
+ *	Added support for port settings. Baud rate can now be changed. Line
+ *	signals are not transferred to and from the tty layer yet, but things
+ *	seem to be working well now.
  *
  * (05/04/2000) gkh
  *	First cut at open and close commands. Data can flow through the ports at
@@ -62,7 +64,7 @@
  *
  * (03/26/2000) gkh
  *	Split driver up into device specific pieces.
- * 
+ *
  */
 
 #include <linux/kernel.h>
@@ -75,14 +77,14 @@
 #include <linux/module.h>
 #include <linux/spinlock.h>
 #include <linux/mutex.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <asm/termbits.h>
 #include <linux/usb.h>
 #include <linux/serial_reg.h>
 #include <linux/serial.h>
 #include <linux/usb/serial.h>
-#include "whiteheat_fw.h"		/* firmware for the ConnectTech WhiteHEAT device */
-#include "whiteheat.h"			/* WhiteHEAT specific commands */
+#include "whiteheat_fw.h"	/* firmware for the ConnectTech WhiteHEAT */
+#include "whiteheat.h"		/* WhiteHEAT specific commands */
 
 static int debug;
 
@@ -124,7 +126,7 @@ static struct usb_device_id id_table_combined [] = {
 	{ }						/* Terminating entry */
 };
 
-MODULE_DEVICE_TABLE (usb, id_table_combined);
+MODULE_DEVICE_TABLE(usb, id_table_combined);
 
 static struct usb_driver whiteheat_driver = {
 	.name =		"whiteheat",
@@ -135,26 +137,34 @@ static struct usb_driver whiteheat_driver = {
 };
 
 /* function prototypes for the Connect Tech WhiteHEAT prerenumeration device */
-static int  whiteheat_firmware_download	(struct usb_serial *serial, const struct usb_device_id *id);
-static int  whiteheat_firmware_attach	(struct usb_serial *serial);
+static int  whiteheat_firmware_download(struct usb_serial *serial,
+					const struct usb_device_id *id);
+static int  whiteheat_firmware_attach(struct usb_serial *serial);
 
 /* function prototypes for the Connect Tech WhiteHEAT serial converter */
-static int  whiteheat_attach		(struct usb_serial *serial);
-static void whiteheat_shutdown		(struct usb_serial *serial);
-static int  whiteheat_open		(struct tty_struct *tty, struct usb_serial_port *port, struct file *filp);
-static void whiteheat_close		(struct tty_struct *tty, struct usb_serial_port *port, struct file *filp);
-static int  whiteheat_write		(struct tty_struct *tty, struct usb_serial_port *port, const unsigned char *buf, int count);
-static int  whiteheat_write_room	(struct tty_struct *tty);
-static int  whiteheat_ioctl		(struct tty_struct *tty, struct file * file, unsigned int cmd, unsigned long arg);
-static void whiteheat_set_termios	(struct tty_struct *tty, struct usb_serial_port *port, struct ktermios * old);
-static int  whiteheat_tiocmget		(struct tty_struct *tty, struct file *file);
-static int  whiteheat_tiocmset		(struct tty_struct *tty, struct file *file, unsigned int set, unsigned int clear);
-static void whiteheat_break_ctl		(struct tty_struct *tty, int break_state);
-static int  whiteheat_chars_in_buffer	(struct tty_struct *tty);
-static void whiteheat_throttle		(struct tty_struct *tty);
-static void whiteheat_unthrottle	(struct tty_struct *tty);
-static void whiteheat_read_callback	(struct urb *urb);
-static void whiteheat_write_callback	(struct urb *urb);
+static int  whiteheat_attach(struct usb_serial *serial);
+static void whiteheat_shutdown(struct usb_serial *serial);
+static int  whiteheat_open(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp);
+static void whiteheat_close(struct tty_struct *tty,
+			struct usb_serial_port *port, struct file *filp);
+static int  whiteheat_write(struct tty_struct *tty,
+			struct usb_serial_port *port,
+			const unsigned char *buf, int count);
+static int  whiteheat_write_room(struct tty_struct *tty);
+static int  whiteheat_ioctl(struct tty_struct *tty, struct file *file,
+			unsigned int cmd, unsigned long arg);
+static void whiteheat_set_termios(struct tty_struct *tty,
+			struct usb_serial_port *port, struct ktermios *old);
+static int  whiteheat_tiocmget(struct tty_struct *tty, struct file *file);
+static int  whiteheat_tiocmset(struct tty_struct *tty, struct file *file,
+			unsigned int set, unsigned int clear);
+static void whiteheat_break_ctl(struct tty_struct *tty, int break_state);
+static int  whiteheat_chars_in_buffer(struct tty_struct *tty);
+static void whiteheat_throttle(struct tty_struct *tty);
+static void whiteheat_unthrottle(struct tty_struct *tty);
+static void whiteheat_read_callback(struct urb *urb);
+static void whiteheat_write_callback(struct urb *urb);
 
 static struct usb_serial_driver whiteheat_fake_device = {
 	.driver = {
@@ -201,7 +211,9 @@ struct whiteheat_command_private {
 	struct mutex		mutex;
 	__u8			port_running;
 	__u8			command_finished;
-	wait_queue_head_t	wait_command;	/* for handling sleeping while waiting for a command to finish */
+	wait_queue_head_t	wait_command; /* for handling sleeping whilst
+						 waiting for a command to
+						 finish */
 	__u8			result_buffer[64];
 };
 
@@ -238,11 +250,13 @@ static void command_port_write_callback(struct urb *urb);
 static void command_port_read_callback(struct urb *urb);
 
 static int start_port_read(struct usb_serial_port *port);
-static struct whiteheat_urb_wrap *urb_to_wrap(struct urb *urb, struct list_head *head);
+static struct whiteheat_urb_wrap *urb_to_wrap(struct urb *urb,
+						struct list_head *head);
 static struct list_head *list_first(struct list_head *head);
 static void rx_data_softint(struct work_struct *work);
 
-static int firm_send_command(struct usb_serial_port *port, __u8 command, __u8 *data, __u8 datasize);
+static int firm_send_command(struct usb_serial_port *port, __u8 command,
+						__u8 *data, __u8 datasize);
 static int firm_open(struct usb_serial_port *port);
 static int firm_close(struct usb_serial_port *port);
 static int firm_setup_port(struct tty_struct *tty);
@@ -277,65 +291,67 @@ static int firm_report_tx_done(struct usb_serial_port *port);
  - device renumerated itself and comes up as new device id with all
    firmware download completed.
 */
-static int whiteheat_firmware_download (struct usb_serial *serial, const struct usb_device_id *id)
+static int whiteheat_firmware_download(struct usb_serial *serial,
+					const struct usb_device_id *id)
 {
 	int response;
 	const struct whiteheat_hex_record *record;
-	
+
 	dbg("%s", __func__);
-	
-	response = ezusb_set_reset (serial, 1);
+
+	response = ezusb_set_reset(serial, 1);
 
 	record = &whiteheat_loader[0];
 	while (record->address != 0xffff) {
-		response = ezusb_writememory (serial, record->address, 
-				(unsigned char *)record->data, record->data_size, 0xa0);
+		response = ezusb_writememory(serial, record->address,
+				(unsigned char *)record->data,
+				record->data_size, 0xa0);
 		if (response < 0) {
 			err("%s - ezusb_writememory failed for loader (%d %04X %p %d)",
-				__func__, response, record->address, record->data, record->data_size);
+				__func__, response, record->address,
+				record->data, record->data_size);
 			break;
 		}
 		++record;
 	}
 
-	response = ezusb_set_reset (serial, 0);
+	response = ezusb_set_reset(serial, 0);
 
 	record = &whiteheat_firmware[0];
-	while (record->address < 0x1b40) {
+	while (record->address < 0x1b40)
 		++record;
-	}
 	while (record->address != 0xffff) {
-		response = ezusb_writememory (serial, record->address, 
-				(unsigned char *)record->data, record->data_size, 0xa3);
+		response = ezusb_writememory(serial, record->address,
+		      (unsigned char *)record->data, record->data_size, 0xa3);
 		if (response < 0) {
-			err("%s - ezusb_writememory failed for first firmware step (%d %04X %p %d)", 
-				__func__, response, record->address, record->data, record->data_size);
+			err("%s - ezusb_writememory failed for first firmware step (%d %04X %p %d)",
+					__func__, response, record->address,
+					record->data, record->data_size);
 			break;
 		}
 		++record;
 	}
-	
-	response = ezusb_set_reset (serial, 1);
+
+	response = ezusb_set_reset(serial, 1);
 
 	record = &whiteheat_firmware[0];
 	while (record->address < 0x1b40) {
-		response = ezusb_writememory (serial, record->address, 
-				(unsigned char *)record->data, record->data_size, 0xa0);
+		response = ezusb_writememory(serial, record->address,
+		      (unsigned char *)record->data, record->data_size, 0xa0);
 		if (response < 0) {
-			err("%s - ezusb_writememory failed for second firmware step (%d %04X %p %d)", 
-				__func__, response, record->address, record->data, record->data_size);
+			err("%s - ezusb_writememory failed for second firmware step (%d %04X %p %d)",
+					__func__, response, record->address,
+					record->data, record->data_size);
 			break;
 		}
 		++record;
 	}
-
-	response = ezusb_set_reset (serial, 0);
-
+	ezusb_set_reset(serial, 0);
 	return 0;
 }
 
 
-static int whiteheat_firmware_attach (struct usb_serial *serial)
+static int whiteheat_firmware_attach(struct usb_serial *serial)
 {
 	/* We want this device to fail to have a driver assigned to it */
 	return 1;
@@ -345,7 +361,7 @@ static int whiteheat_firmware_attach (struct usb_serial *serial)
 /*****************************************************************************
  * Connect Tech's White Heat serial driver functions
  *****************************************************************************/
-static int whiteheat_attach (struct usb_serial *serial)
+static int whiteheat_attach(struct usb_serial *serial)
 {
 	struct usb_serial_port *command_port;
 	struct whiteheat_command_private *command_info;
@@ -366,43 +382,52 @@ static int whiteheat_attach (struct usb_serial *serial)
 
 	command_port = serial->port[COMMAND_PORT];
 
-	pipe = usb_sndbulkpipe (serial->dev, command_port->bulk_out_endpointAddress);
+	pipe = usb_sndbulkpipe(serial->dev,
+			command_port->bulk_out_endpointAddress);
 	command = kmalloc(2, GFP_KERNEL);
 	if (!command)
 		goto no_command_buffer;
 	command[0] = WHITEHEAT_GET_HW_INFO;
 	command[1] = 0;
-	
+
 	result = kmalloc(sizeof(*hw_info) + 1, GFP_KERNEL);
 	if (!result)
 		goto no_result_buffer;
 	/*
 	 * When the module is reloaded the firmware is still there and
 	 * the endpoints are still in the usb core unchanged. This is the
-         * unlinking bug in disguise. Same for the call below.
-         */
+	 * unlinking bug in disguise. Same for the call below.
+	 */
 	usb_clear_halt(serial->dev, pipe);
-	ret = usb_bulk_msg (serial->dev, pipe, command, 2, &alen, COMMAND_TIMEOUT_MS);
+	ret = usb_bulk_msg(serial->dev, pipe, command, 2,
+						&alen, COMMAND_TIMEOUT_MS);
 	if (ret) {
-		err("%s: Couldn't send command [%d]", serial->type->description, ret);
+		err("%s: Couldn't send command [%d]",
+				serial->type->description, ret);
 		goto no_firmware;
 	} else if (alen != 2) {
-		err("%s: Send command incomplete [%d]", serial->type->description, alen);
+		err("%s: Send command incomplete [%d]",
+				serial->type->description, alen);
 		goto no_firmware;
 	}
 
-	pipe = usb_rcvbulkpipe (serial->dev, command_port->bulk_in_endpointAddress);
+	pipe = usb_rcvbulkpipe(serial->dev,
+				command_port->bulk_in_endpointAddress);
 	/* See the comment on the usb_clear_halt() above */
 	usb_clear_halt(serial->dev, pipe);
-	ret = usb_bulk_msg (serial->dev, pipe, result, sizeof(*hw_info) + 1, &alen, COMMAND_TIMEOUT_MS);
+	ret = usb_bulk_msg(serial->dev, pipe, result,
+			sizeof(*hw_info) + 1, &alen, COMMAND_TIMEOUT_MS);
 	if (ret) {
-		err("%s: Couldn't get results [%d]", serial->type->description, ret);
+		err("%s: Couldn't get results [%d]",
+				serial->type->description, ret);
 		goto no_firmware;
 	} else if (alen != sizeof(*hw_info) + 1) {
-		err("%s: Get results incomplete [%d]", serial->type->description, alen);
+		err("%s: Get results incomplete [%d]",
+				serial->type->description, alen);
 		goto no_firmware;
 	} else if (result[0] != command[0]) {
-		err("%s: Command failed [%d]", serial->type->description, result[0]);
+		err("%s: Command failed [%d]",
+				serial->type->description, result[0]);
 		goto no_firmware;
 	}
 
@@ -416,7 +441,8 @@ static int whiteheat_attach (struct usb_serial *serial)
 
 		info = kmalloc(sizeof(struct whiteheat_private), GFP_KERNEL);
 		if (info == NULL) {
-			err("%s: Out of memory for port structures\n", serial->type->description);
+			err("%s: Out of memory for port structures\n",
+					serial->type->description);
 			goto no_private;
 		}
 
@@ -486,9 +512,11 @@ static int whiteheat_attach (struct usb_serial *serial)
 		usb_set_serial_port_data(port, info);
 	}
 
-	command_info = kmalloc(sizeof(struct whiteheat_command_private), GFP_KERNEL);
+	command_info = kmalloc(sizeof(struct whiteheat_command_private),
+								GFP_KERNEL);
 	if (command_info == NULL) {
-		err("%s: Out of memory for port structures\n", serial->type->description);
+		err("%s: Out of memory for port structures\n",
+					serial->type->description);
 		goto no_command_private;
 	}
 
@@ -505,9 +533,12 @@ static int whiteheat_attach (struct usb_serial *serial)
 
 no_firmware:
 	/* Firmware likely not running */
-	err("%s: Unable to retrieve firmware version, try replugging\n", serial->type->description);
-	err("%s: If the firmware is not running (status led not blinking)\n", serial->type->description);
-	err("%s: please contact support@connecttech.com\n", serial->type->description);
+	err("%s: Unable to retrieve firmware version, try replugging\n",
+					serial->type->description);
+	err("%s: If the firmware is not running (status led not blinking)\n",
+					serial->type->description);
+	err("%s: please contact support@connecttech.com\n",
+					serial->type->description);
 	kfree(result);
 	return -ENODEV;
 
@@ -550,7 +581,7 @@ no_command_buffer:
 }
 
 
-static void whiteheat_shutdown (struct usb_serial *serial)
+static void whiteheat_shutdown(struct usb_serial *serial)
 {
 	struct usb_serial_port *command_port;
 	struct usb_serial_port *port;
@@ -565,7 +596,7 @@ static void whiteheat_shutdown (struct usb_serial *serial)
 
 	/* free up our private data for our command port */
 	command_port = serial->port[COMMAND_PORT];
-	kfree (usb_get_serial_port_data(command_port));
+	kfree(usb_get_serial_port_data(command_port));
 
 	for (i = 0; i < serial->num_ports; i++) {
 		port = serial->port[i];
@@ -592,8 +623,7 @@ static void whiteheat_shutdown (struct usb_serial *serial)
 	return;
 }
 
-
-static int whiteheat_open (struct tty_struct *tty,
+static int whiteheat_open(struct tty_struct *tty,
 			struct usb_serial_port *port, struct file *filp)
 {
 	int		retval = 0;
@@ -635,7 +665,8 @@ static int whiteheat_open (struct tty_struct *tty,
 	/* Start reading from the device */
 	retval = start_port_read(port);
 	if (retval) {
-		err("%s - failed submitting read urb, error %d", __func__, retval);
+		err("%s - failed submitting read urb, error %d",
+				__func__, retval);
 		firm_close(port);
 		stop_command_port(port->serial);
 		goto exit;
@@ -648,7 +679,7 @@ exit:
 
 
 static void whiteheat_close(struct tty_struct *tty,
-			struct usb_serial_port *port, struct file * filp)
+			struct usb_serial_port *port, struct file *filp)
 {
 	struct whiteheat_private *info = usb_get_serial_port_data(port);
 	struct whiteheat_urb_wrap *wrap;
@@ -749,16 +780,19 @@ static int whiteheat_write(struct tty_struct *tty,
 
 		wrap = list_entry(tmp, struct whiteheat_urb_wrap, list);
 		urb = wrap->urb;
-		bytes = (count > port->bulk_out_size) ? port->bulk_out_size : count;
-		memcpy (urb->transfer_buffer, buf + sent, bytes);
+		bytes = (count > port->bulk_out_size) ?
+					port->bulk_out_size : count;
+		memcpy(urb->transfer_buffer, buf + sent, bytes);
 
-		usb_serial_debug_data(debug, &port->dev, __func__, bytes, urb->transfer_buffer);
+		usb_serial_debug_data(debug, &port->dev,
+				__func__, bytes, urb->transfer_buffer);
 
 		urb->dev = serial->dev;
 		urb->transfer_buffer_length = bytes;
 		result = usb_submit_urb(urb, GFP_ATOMIC);
 		if (result) {
-			err("%s - failed submitting write urb, error %d", __func__, result);
+			err("%s - failed submitting write urb, error %d",
+							__func__, result);
 			sent = result;
 			spin_lock_irqsave(&info->lock, flags);
 			list_add(tmp, &info->tx_urbs_free);
@@ -776,7 +810,6 @@ static int whiteheat_write(struct tty_struct *tty,
 	return sent;
 }
 
-
 static int whiteheat_write_room(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
@@ -786,7 +819,7 @@ static int whiteheat_write_room(struct tty_struct *tty)
 	unsigned long flags;
 
 	dbg("%s - port %d", __func__, port->number);
-	
+
 	spin_lock_irqsave(&info->lock, flags);
 	list_for_each(tmp, &info->tx_urbs_free)
 		room++;
@@ -797,8 +830,7 @@ static int whiteheat_write_room(struct tty_struct *tty)
 	return (room);
 }
 
-
-static int whiteheat_tiocmget (struct tty_struct *tty, struct file *file)
+static int whiteheat_tiocmget(struct tty_struct *tty, struct file *file)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	struct whiteheat_private *info = usb_get_serial_port_data(port);
@@ -815,8 +847,7 @@ static int whiteheat_tiocmget (struct tty_struct *tty, struct file *file)
 	return modem_signals;
 }
 
-
-static int whiteheat_tiocmset (struct tty_struct *tty, struct file *file,
+static int whiteheat_tiocmset(struct tty_struct *tty, struct file *file,
 			       unsigned int set, unsigned int clear)
 {
 	struct usb_serial_port *port = tty->driver_data;
@@ -840,7 +871,8 @@ static int whiteheat_tiocmset (struct tty_struct *tty, struct file *file,
 }
 
 
-static int whiteheat_ioctl (struct tty_struct *tty, struct file * file, unsigned int cmd, unsigned long arg)
+static int whiteheat_ioctl(struct tty_struct *tty, struct file *file,
+					unsigned int cmd, unsigned long arg)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	struct serial_struct serstruct;
@@ -849,50 +881,38 @@ static int whiteheat_ioctl (struct tty_struct *tty, struct file * file, unsigned
 	dbg("%s - port %d, cmd 0x%.4x", __func__, port->number, cmd);
 
 	switch (cmd) {
-		case TIOCGSERIAL:
-			memset(&serstruct, 0, sizeof(serstruct));
-			serstruct.type = PORT_16654;
-			serstruct.line = port->serial->minor;
-			serstruct.port = port->number;
-			serstruct.flags = ASYNC_SKIP_TEST | ASYNC_AUTO_IRQ;
-			serstruct.xmit_fifo_size = port->bulk_out_size;
-			serstruct.custom_divisor = 0;
-			serstruct.baud_base = 460800;
-			serstruct.close_delay = CLOSING_DELAY;
-			serstruct.closing_wait = CLOSING_DELAY;
-
-			if (copy_to_user(user_arg, &serstruct, sizeof(serstruct)))
-				return -EFAULT;
-
-			break;
-
-		case TIOCSSERIAL:
-			if (copy_from_user(&serstruct, user_arg, sizeof(serstruct)))
-				return -EFAULT;
-
-			/*
-			 * For now this is ignored. dip sets the ASYNC_[V]HI flags
-			 * but this isn't used by us at all. Maybe someone somewhere
-			 * will need the custom_divisor setting.
-			 */
-
-			break;
-
-		default:
-			break;
+	case TIOCGSERIAL:
+		memset(&serstruct, 0, sizeof(serstruct));
+		serstruct.type = PORT_16654;
+		serstruct.line = port->serial->minor;
+		serstruct.port = port->number;
+		serstruct.flags = ASYNC_SKIP_TEST | ASYNC_AUTO_IRQ;
+		serstruct.xmit_fifo_size = port->bulk_out_size;
+		serstruct.custom_divisor = 0;
+		serstruct.baud_base = 460800;
+		serstruct.close_delay = CLOSING_DELAY;
+		serstruct.closing_wait = CLOSING_DELAY;
+
+		if (copy_to_user(user_arg, &serstruct, sizeof(serstruct)))
+			return -EFAULT;
+		break;
+	default:
+		break;
 	}
 
 	return -ENOIOCTLCMD;
 }
 
 
-static void whiteheat_set_termios(struct tty_struct *tty, struct usb_serial_port *port, struct ktermios *old_termios)
+static void whiteheat_set_termios(struct tty_struct *tty,
+	struct usb_serial_port *port, struct ktermios *old_termios)
 {
+	/* FIXME */
 	firm_setup_port(tty);
 }
 
-
-static void whiteheat_break_ctl(struct tty_struct *tty, int break_state) {
+static void whiteheat_break_ctl(struct tty_struct *tty, int break_state)
+{
 	struct usb_serial_port *port = tty->driver_data;
 	firm_set_break(port, break_state);
 }
@@ -916,12 +936,12 @@ static int whiteheat_chars_in_buffer(struct tty_struct *tty)
 	}
 	spin_unlock_irqrestore(&info->lock, flags);
 
-	dbg ("%s - returns %d", __func__, chars);
+	dbg("%s - returns %d", __func__, chars);
 	return chars;
 }
 
 
-static void whiteheat_throttle (struct tty_struct *tty)
+static void whiteheat_throttle(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	struct whiteheat_private *info = usb_get_serial_port_data(port);
@@ -937,7 +957,7 @@ static void whiteheat_throttle (struct tty_struct *tty)
 }
 
 
-static void whiteheat_unthrottle (struct tty_struct *tty)
+static void whiteheat_unthrottle(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	struct whiteheat_private *info = usb_get_serial_port_data(port);
@@ -986,7 +1006,7 @@ static void command_port_read_callback(struct urb *urb)
 
 	command_info = usb_get_serial_port_data(command_port);
 	if (!command_info) {
-		dbg ("%s - command_info is NULL, exiting.", __func__);
+		dbg("%s - command_info is NULL, exiting.", __func__);
 		return;
 	}
 	if (status) {
@@ -997,7 +1017,8 @@ static void command_port_read_callback(struct urb *urb)
 		return;
 	}
 
-	usb_serial_debug_data(debug, &command_port->dev, __func__, urb->actual_length, data);
+	usb_serial_debug_data(debug, &command_port->dev,
+				__func__, urb->actual_length, data);
 
 	if (data[0] == WHITEHEAT_CMD_COMPLETE) {
 		command_info->command_finished = WHITEHEAT_CMD_COMPLETE;
@@ -1006,21 +1027,23 @@ static void command_port_read_callback(struct urb *urb)
 		command_info->command_finished = WHITEHEAT_CMD_FAILURE;
 		wake_up(&command_info->wait_command);
 	} else if (data[0] == WHITEHEAT_EVENT) {
-		/* These are unsolicited reports from the firmware, hence no waiting command to wakeup */
+		/* These are unsolicited reports from the firmware, hence no
+		   waiting command to wakeup */
 		dbg("%s - event received", __func__);
 	} else if (data[0] == WHITEHEAT_GET_DTR_RTS) {
-		memcpy(command_info->result_buffer, &data[1], urb->actual_length - 1);
+		memcpy(command_info->result_buffer, &data[1],
+						urb->actual_length - 1);
 		command_info->command_finished = WHITEHEAT_CMD_COMPLETE;
 		wake_up(&command_info->wait_command);
-	} else {
+	} else
 		dbg("%s - bad reply from firmware", __func__);
-	}
-	
+
 	/* Continue trying to always read */
 	command_port->read_urb->dev = command_port->serial->dev;
 	result = usb_submit_urb(command_port->read_urb, GFP_ATOMIC);
 	if (result)
-		dbg("%s - failed resubmitting read urb, error %d", __func__, result);
+		dbg("%s - failed resubmitting read urb, error %d",
+			__func__, result);
 }
 
 
@@ -1053,7 +1076,8 @@ static void whiteheat_read_callback(struct urb *urb)
 		return;
 	}
 
-	usb_serial_debug_data(debug, &port->dev, __func__, urb->actual_length, data);
+	usb_serial_debug_data(debug, &port->dev,
+				__func__, urb->actual_length, data);
 
 	spin_lock(&info->lock);
 	list_add_tail(&wrap->list, &info->rx_urb_q);
@@ -1100,7 +1124,8 @@ static void whiteheat_write_callback(struct urb *urb)
 /*****************************************************************************
  * Connect Tech's White Heat firmware interface
  *****************************************************************************/
-static int firm_send_command(struct usb_serial_port *port, __u8 command, __u8 *data, __u8 datasize)
+static int firm_send_command(struct usb_serial_port *port, __u8 command,
+						__u8 *data, __u8 datasize)
 {
 	struct usb_serial_port *command_port;
 	struct whiteheat_command_private *command_info;
@@ -1115,13 +1140,13 @@ static int firm_send_command(struct usb_serial_port *port, __u8 command, __u8 *d
 	command_info = usb_get_serial_port_data(command_port);
 	mutex_lock(&command_info->mutex);
 	command_info->command_finished = false;
-	
+
 	transfer_buffer = (__u8 *)command_port->write_urb->transfer_buffer;
 	transfer_buffer[0] = command;
-	memcpy (&transfer_buffer[1], data, datasize);
+	memcpy(&transfer_buffer[1], data, datasize);
 	command_port->write_urb->transfer_buffer_length = datasize + 1;
 	command_port->write_urb->dev = port->serial->dev;
-	retval = usb_submit_urb (command_port->write_urb, GFP_NOIO);
+	retval = usb_submit_urb(command_port->write_urb, GFP_NOIO);
 	if (retval) {
 		dbg("%s - submit urb failed", __func__);
 		goto exit;
@@ -1148,36 +1173,41 @@ static int firm_send_command(struct usb_serial_port *port, __u8 command, __u8 *d
 	if (command_info->command_finished == WHITEHEAT_CMD_COMPLETE) {
 		dbg("%s - command completed.", __func__);
 		switch (command) {
-			case WHITEHEAT_GET_DTR_RTS:
-				info = usb_get_serial_port_data(port);
-				memcpy(&info->mcr, command_info->result_buffer, sizeof(struct whiteheat_dr_info));
+		case WHITEHEAT_GET_DTR_RTS:
+			info = usb_get_serial_port_data(port);
+			memcpy(&info->mcr, command_info->result_buffer,
+					sizeof(struct whiteheat_dr_info));
 				break;
 		}
 	}
-
 exit:
 	mutex_unlock(&command_info->mutex);
 	return retval;
 }
 
 
-static int firm_open(struct usb_serial_port *port) {
+static int firm_open(struct usb_serial_port *port)
+{
 	struct whiteheat_simple open_command;
 
 	open_command.port = port->number - port->serial->minor + 1;
-	return firm_send_command(port, WHITEHEAT_OPEN, (__u8 *)&open_command, sizeof(open_command));
+	return firm_send_command(port, WHITEHEAT_OPEN,
+		(__u8 *)&open_command, sizeof(open_command));
 }
 
 
-static int firm_close(struct usb_serial_port *port) {
+static int firm_close(struct usb_serial_port *port)
+{
 	struct whiteheat_simple close_command;
 
 	close_command.port = port->number - port->serial->minor + 1;
-	return firm_send_command(port, WHITEHEAT_CLOSE, (__u8 *)&close_command, sizeof(close_command));
+	return firm_send_command(port, WHITEHEAT_CLOSE,
+			(__u8 *)&close_command, sizeof(close_command));
 }
 
 
-static int firm_setup_port(struct tty_struct *tty) {
+static int firm_setup_port(struct tty_struct *tty)
+{
 	struct usb_serial_port *port = tty->driver_data;
 	struct whiteheat_port_settings port_settings;
 	unsigned int cflag = tty->termios->c_cflag;
@@ -1186,14 +1216,14 @@ static int firm_setup_port(struct tty_struct *tty) {
 
 	/* get the byte size */
 	switch (cflag & CSIZE) {
-		case CS5:	port_settings.bits = 5;   break;
-		case CS6:	port_settings.bits = 6;   break;
-		case CS7:	port_settings.bits = 7;   break;
-		default:
-		case CS8:	port_settings.bits = 8;   break;
+	case CS5:	port_settings.bits = 5;   break;
+	case CS6:	port_settings.bits = 6;   break;
+	case CS7:	port_settings.bits = 7;   break;
+	default:
+	case CS8:	port_settings.bits = 8;   break;
 	}
 	dbg("%s - data bits = %d", __func__, port_settings.bits);
-	
+
 	/* determine the parity */
 	if (cflag & PARENB)
 		if (cflag & CMSPAR)
@@ -1219,7 +1249,8 @@ static int firm_setup_port(struct tty_struct *tty) {
 
 	/* figure out the flow control settings */
 	if (cflag & CRTSCTS)
-		port_settings.hflow = (WHITEHEAT_HFLOW_CTS | WHITEHEAT_HFLOW_RTS);
+		port_settings.hflow = (WHITEHEAT_HFLOW_CTS |
+						WHITEHEAT_HFLOW_RTS);
 	else
 		port_settings.hflow = WHITEHEAT_HFLOW_NONE;
 	dbg("%s - hardware flow control = %s %s %s %s", __func__,
@@ -1227,17 +1258,18 @@ static int firm_setup_port(struct tty_struct *tty) {
 	    (port_settings.hflow & WHITEHEAT_HFLOW_RTS) ? "RTS" : "",
 	    (port_settings.hflow & WHITEHEAT_HFLOW_DSR) ? "DSR" : "",
 	    (port_settings.hflow & WHITEHEAT_HFLOW_DTR) ? "DTR" : "");
-	
+
 	/* determine software flow control */
 	if (I_IXOFF(tty))
 		port_settings.sflow = WHITEHEAT_SFLOW_RXTX;
 	else
 		port_settings.sflow = WHITEHEAT_SFLOW_NONE;
 	dbg("%s - software flow control = %c", __func__, port_settings.sflow);
-	
+
 	port_settings.xon = START_CHAR(tty);
 	port_settings.xoff = STOP_CHAR(tty);
-	dbg("%s - XON = %2x, XOFF = %2x", __func__, port_settings.xon, port_settings.xoff);
+	dbg("%s - XON = %2x, XOFF = %2x",
+			__func__, port_settings.xon, port_settings.xoff);
 
 	/* get the baud rate wanted */
 	port_settings.baud = tty_get_baud_rate(tty);
@@ -1247,61 +1279,74 @@ static int firm_setup_port(struct tty_struct *tty) {
 	tty_encode_baud_rate(tty, port_settings.baud, port_settings.baud);
 	/* handle any settings that aren't specified in the tty structure */
 	port_settings.lloop = 0;
-	
+
 	/* now send the message to the device */
-	return firm_send_command(port, WHITEHEAT_SETUP_PORT, (__u8 *)&port_settings, sizeof(port_settings));
+	return firm_send_command(port, WHITEHEAT_SETUP_PORT,
+			(__u8 *)&port_settings, sizeof(port_settings));
 }
 
 
-static int firm_set_rts(struct usb_serial_port *port, __u8 onoff) {
+static int firm_set_rts(struct usb_serial_port *port, __u8 onoff)
+{
 	struct whiteheat_set_rdb rts_command;
 
 	rts_command.port = port->number - port->serial->minor + 1;
 	rts_command.state = onoff;
-	return firm_send_command(port, WHITEHEAT_SET_RTS, (__u8 *)&rts_command, sizeof(rts_command));
+	return firm_send_command(port, WHITEHEAT_SET_RTS,
+			(__u8 *)&rts_command, sizeof(rts_command));
 }
 
 
-static int firm_set_dtr(struct usb_serial_port *port, __u8 onoff) {
+static int firm_set_dtr(struct usb_serial_port *port, __u8 onoff)
+{
 	struct whiteheat_set_rdb dtr_command;
 
 	dtr_command.port = port->number - port->serial->minor + 1;
 	dtr_command.state = onoff;
-	return firm_send_command(port, WHITEHEAT_SET_RTS, (__u8 *)&dtr_command, sizeof(dtr_command));
+	return firm_send_command(port, WHITEHEAT_SET_RTS,
+			(__u8 *)&dtr_command, sizeof(dtr_command));
 }
 
 
-static int firm_set_break(struct usb_serial_port *port, __u8 onoff) {
+static int firm_set_break(struct usb_serial_port *port, __u8 onoff)
+{
 	struct whiteheat_set_rdb break_command;
 
 	break_command.port = port->number - port->serial->minor + 1;
 	break_command.state = onoff;
-	return firm_send_command(port, WHITEHEAT_SET_RTS, (__u8 *)&break_command, sizeof(break_command));
+	return firm_send_command(port, WHITEHEAT_SET_RTS,
+			(__u8 *)&break_command, sizeof(break_command));
 }
 
 
-static int firm_purge(struct usb_serial_port *port, __u8 rxtx) {
+static int firm_purge(struct usb_serial_port *port, __u8 rxtx)
+{
 	struct whiteheat_purge purge_command;
 
 	purge_command.port = port->number - port->serial->minor + 1;
 	purge_command.what = rxtx;
-	return firm_send_command(port, WHITEHEAT_PURGE, (__u8 *)&purge_command, sizeof(purge_command));
+	return firm_send_command(port, WHITEHEAT_PURGE,
+			(__u8 *)&purge_command, sizeof(purge_command));
 }
 
 
-static int firm_get_dtr_rts(struct usb_serial_port *port) {
+static int firm_get_dtr_rts(struct usb_serial_port *port)
+{
 	struct whiteheat_simple get_dr_command;
 
 	get_dr_command.port = port->number - port->serial->minor + 1;
-	return firm_send_command(port, WHITEHEAT_GET_DTR_RTS, (__u8 *)&get_dr_command, sizeof(get_dr_command));
+	return firm_send_command(port, WHITEHEAT_GET_DTR_RTS,
+			(__u8 *)&get_dr_command, sizeof(get_dr_command));
 }
 
 
-static int firm_report_tx_done(struct usb_serial_port *port) {
+static int firm_report_tx_done(struct usb_serial_port *port)
+{
 	struct whiteheat_simple close_command;
 
 	close_command.port = port->number - port->serial->minor + 1;
-	return firm_send_command(port, WHITEHEAT_REPORT_TX_DONE, (__u8 *)&close_command, sizeof(close_command));
+	return firm_send_command(port, WHITEHEAT_REPORT_TX_DONE,
+			(__u8 *)&close_command, sizeof(close_command));
 }
 
 
@@ -1313,7 +1358,7 @@ static int start_command_port(struct usb_serial *serial)
 	struct usb_serial_port *command_port;
 	struct whiteheat_command_private *command_info;
 	int retval = 0;
-	
+
 	command_port = serial->port[COMMAND_PORT];
 	command_info = usb_get_serial_port_data(command_port);
 	mutex_lock(&command_info->mutex);
@@ -1324,7 +1369,8 @@ static int start_command_port(struct usb_serial *serial)
 		command_port->read_urb->dev = serial->dev;
 		retval = usb_submit_urb(command_port->read_urb, GFP_KERNEL);
 		if (retval) {
-			err("%s - failed submitting read urb, error %d", __func__, retval);
+			err("%s - failed submitting read urb, error %d",
+							__func__, retval);
 			goto exit;
 		}
 	}
@@ -1394,7 +1440,8 @@ static int start_port_read(struct usb_serial_port *port)
 }
 
 
-static struct whiteheat_urb_wrap *urb_to_wrap(struct urb* urb, struct list_head *head)
+static struct whiteheat_urb_wrap *urb_to_wrap(struct urb *urb,
+						struct list_head *head)
 {
 	struct whiteheat_urb_wrap *wrap;
 	struct list_head *tmp;
@@ -1443,7 +1490,8 @@ static void rx_data_softint(struct work_struct *work)
 		urb = wrap->urb;
 
 		if (tty && urb->actual_length) {
-			int len = tty_buffer_request_room(tty, urb->actual_length);
+			int len = tty_buffer_request_room(tty,
+							urb->actual_length);
 			/* This stuff can go away now I suspect */
 			if (unlikely(len < urb->actual_length)) {
 				spin_lock_irqsave(&info->lock, flags);
@@ -1460,7 +1508,8 @@ static void rx_data_softint(struct work_struct *work)
 		urb->dev = port->serial->dev;
 		result = usb_submit_urb(urb, GFP_ATOMIC);
 		if (result) {
-			err("%s - failed resubmitting read urb, error %d", __func__, result);
+			err("%s - failed resubmitting read urb, error %d",
+				__func__, result);
 			spin_lock_irqsave(&info->lock, flags);
 			list_add(tmp, &info->rx_urbs_free);
 			continue;
@@ -1479,7 +1528,7 @@ static void rx_data_softint(struct work_struct *work)
 /*****************************************************************************
  * Connect Tech's White Heat module functions
  *****************************************************************************/
-static int __init whiteheat_init (void)
+static int __init whiteheat_init(void)
 {
 	int retval;
 	retval = usb_serial_register(&whiteheat_fake_device);
@@ -1502,19 +1551,19 @@ failed_fake_register:
 }
 
 
-static void __exit whiteheat_exit (void)
+static void __exit whiteheat_exit(void)
 {
-	usb_deregister (&whiteheat_driver);
-	usb_serial_deregister (&whiteheat_fake_device);
-	usb_serial_deregister (&whiteheat_device);
+	usb_deregister(&whiteheat_driver);
+	usb_serial_deregister(&whiteheat_fake_device);
+	usb_serial_deregister(&whiteheat_device);
 }
 
 
 module_init(whiteheat_init);
 module_exit(whiteheat_exit);
 
-MODULE_AUTHOR( DRIVER_AUTHOR );
-MODULE_DESCRIPTION( DRIVER_DESC );
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
 
 module_param(urb_pool_size, int, 0);
diff --git a/drivers/usb/serial/whiteheat.h b/drivers/usb/serial/whiteheat.h
index f160797..38065df 100644
--- a/drivers/usb/serial/whiteheat.h
+++ b/drivers/usb/serial/whiteheat.h
@@ -2,7 +2,7 @@
  * USB ConnectTech WhiteHEAT driver
  *
  *      Copyright (C) 2002
- *          Connect Tech Inc.	
+ *          Connect Tech Inc.
  *
  *      Copyright (C) 1999, 2000
  *          Greg Kroah-Hartman (greg@kroah.com)
@@ -12,7 +12,8 @@
  *      the Free Software Foundation; either version 2 of the License, or
  *      (at your option) any later version.
  *
- * See Documentation/usb/usb-serial.txt for more information on using this driver
+ * See Documentation/usb/usb-serial.txt for more information on using this
+ * driver
  *
  */
 
@@ -30,13 +31,16 @@
 #define WHITEHEAT_DUMP			7	/* dump memory */
 #define WHITEHEAT_STATUS		8	/* get status */
 #define WHITEHEAT_PURGE			9	/* clear the UART fifos */
-#define WHITEHEAT_GET_DTR_RTS		10	/* get the state of DTR and RTS for a port */
-#define WHITEHEAT_GET_HW_INFO		11	/* get EEPROM info and hardware ID */
+#define WHITEHEAT_GET_DTR_RTS		10	/* get the state of DTR and RTS
+							for a port */
+#define WHITEHEAT_GET_HW_INFO		11	/* get EEPROM info and
+							hardware ID */
 #define WHITEHEAT_REPORT_TX_DONE	12	/* get the next TX done */
 #define WHITEHEAT_EVENT			13	/* unsolicited status events */
-#define WHITEHEAT_ECHO			14	/* send data to the indicated IN endpoint */
-#define WHITEHEAT_DO_TEST		15	/* perform the specified test */
-#define WHITEHEAT_CMD_COMPLETE		16	/* reply for certain commands */
+#define WHITEHEAT_ECHO			14	/* send data to the indicated
+						   IN endpoint */
+#define WHITEHEAT_DO_TEST		15	/* perform specified test */
+#define WHITEHEAT_CMD_COMPLETE		16	/* reply for some commands */
 #define WHITEHEAT_CMD_FAILURE		17	/* reply for failed commands */
 
 
@@ -67,20 +71,28 @@ struct whiteheat_simple {
 #define WHITEHEAT_PAR_MARK	'1'	/* mark (force 1) parity */
 
 #define WHITEHEAT_SFLOW_NONE	'n'	/* no software flow control */
-#define WHITEHEAT_SFLOW_RX	'r'	/* XOFF/ON is sent when RX fills/empties */
-#define WHITEHEAT_SFLOW_TX	't'	/* when received XOFF/ON will stop/start TX */
+#define WHITEHEAT_SFLOW_RX	'r'	/* XOFF/ON is sent when RX
+					   fills/empties */
+#define WHITEHEAT_SFLOW_TX	't'	/* when received XOFF/ON will
+					   stop/start TX */
 #define WHITEHEAT_SFLOW_RXTX	'b'	/* both SFLOW_RX and SFLOW_TX */
 
 #define WHITEHEAT_HFLOW_NONE		0x00	/* no hardware flow control */
-#define WHITEHEAT_HFLOW_RTS_TOGGLE	0x01	/* RTS is on during transmit, off otherwise */
-#define WHITEHEAT_HFLOW_DTR		0x02	/* DTR is off/on when RX fills/empties */
-#define WHITEHEAT_HFLOW_CTS		0x08	/* when received CTS off/on will stop/start TX */
-#define WHITEHEAT_HFLOW_DSR		0x10	/* when received DSR off/on will stop/start TX */
-#define WHITEHEAT_HFLOW_RTS		0x80	/* RTS is off/on when RX fills/empties */
+#define WHITEHEAT_HFLOW_RTS_TOGGLE	0x01	/* RTS is on during transmit,
+						   off otherwise */
+#define WHITEHEAT_HFLOW_DTR		0x02	/* DTR is off/on when RX
+						   fills/empties */
+#define WHITEHEAT_HFLOW_CTS		0x08	/* when received CTS off/on
+						   will stop/start TX */
+#define WHITEHEAT_HFLOW_DSR		0x10	/* when received DSR off/on
+						   will stop/start TX */
+#define WHITEHEAT_HFLOW_RTS		0x80	/* RTS is off/on when RX
+						   fills/empties */
 
 struct whiteheat_port_settings {
 	__u8	port;		/* port number (1 to N) */
-	__u32	baud;		/* any value 7 - 460800, firmware calculates best fit; arrives little endian */
+	__u32	baud;		/* any value 7 - 460800, firmware calculates
+				   best fit; arrives little endian */
 	__u8	bits;		/* 5, 6, 7, or 8 */
 	__u8	stop;		/* 1 or 2, default 1 (2 = 1.5 if bits = 5) */
 	__u8	parity;		/* see WHITEHEAT_PAR_* above */
@@ -167,12 +179,14 @@ struct whiteheat_echo {
  */
 #define WHITEHEAT_TEST_UART_RW		0x01  /* read/write uart registers */
 #define WHITEHEAT_TEST_UART_INTR	0x02  /* uart interrupt */
-#define WHITEHEAT_TEST_SETUP_CONT	0x03  /* setup for PORT_CONT/PORT_DISCONT */
+#define WHITEHEAT_TEST_SETUP_CONT	0x03  /* setup for
+						PORT_CONT/PORT_DISCONT */
 #define WHITEHEAT_TEST_PORT_CONT	0x04  /* port connect */
 #define WHITEHEAT_TEST_PORT_DISCONT	0x05  /* port disconnect */
 #define WHITEHEAT_TEST_UART_CLK_START	0x06  /* uart clock test start */
 #define WHITEHEAT_TEST_UART_CLK_STOP	0x07  /* uart clock test stop */
-#define WHITEHEAT_TEST_MODEM_FT		0x08  /* modem signals, requires a loopback cable/connector */
+#define WHITEHEAT_TEST_MODEM_FT		0x08  /* modem signals, requires a
+						loopback cable/connector */
 #define WHITEHEAT_TEST_ERASE_EEPROM	0x09  /* erase eeprom */
 #define WHITEHEAT_TEST_READ_EEPROM	0x0a  /* read eeprom */
 #define WHITEHEAT_TEST_PROGRAM_EEPROM	0x0b  /* program eeprom */
@@ -198,19 +212,27 @@ struct whiteheat_test {
 #define WHITEHEAT_EVENT_CONNECT		0x08	/* connect field is valid */
 
 #define WHITEHEAT_FLOW_NONE		0x00	/* no flow control active */
-#define WHITEHEAT_FLOW_HARD_OUT		0x01	/* TX is stopped by CTS (waiting for CTS to go on) */
-#define WHITEHEAT_FLOW_HARD_IN		0x02	/* remote TX is stopped by RTS */
-#define WHITEHEAT_FLOW_SOFT_OUT		0x04	/* TX is stopped by XOFF received (waiting for XON) */
-#define WHITEHEAT_FLOW_SOFT_IN		0x08	/* remote TX is stopped by XOFF transmitted */
+#define WHITEHEAT_FLOW_HARD_OUT		0x01	/* TX is stopped by CTS
+						  (waiting for CTS to go on) */
+#define WHITEHEAT_FLOW_HARD_IN		0x02	/* remote TX is stopped
+						  by RTS */
+#define WHITEHEAT_FLOW_SOFT_OUT		0x04	/* TX is stopped by XOFF
+						  received (waiting for XON) */
+#define WHITEHEAT_FLOW_SOFT_IN		0x08	/* remote TX is stopped by XOFF
+						  transmitted */
 #define WHITEHEAT_FLOW_TX_DONE		0x80	/* TX has completed */
 
 struct whiteheat_status_info {
 	__u8	port;		/* port number (1 to N) */
-	__u8	event;		/* indicates what the current event is, see WHITEHEAT_EVENT_* above */
-	__u8	modem;		/* modem signal status (copy of uart's MSR register) */
+	__u8	event;		/* indicates what the current event is,
+					see WHITEHEAT_EVENT_* above */
+	__u8	modem;		/* modem signal status (copy of uart's
+					MSR register) */
 	__u8	error;		/* line status (copy of uart's LSR register) */
-	__u8	flow;		/* flow control state, see WHITEHEAT_FLOW_* above */
-	__u8	connect;	/* 0 means not connected, non-zero means connected */
+	__u8	flow;		/* flow control state, see WHITEHEAT_FLOW_*
+					above */
+	__u8	connect;	/* 0 means not connected, non-zero means
+					connected */
 };
 
 
@@ -256,7 +278,8 @@ struct whiteheat_hw_info {
 struct whiteheat_event_info {
 	__u8	port;		/* port number (1 to N) */
 	__u8	event;		/* see whiteheat_status_info.event */
-	__u8	info;		/* see whiteheat_status_info.modem, .error, .flow, .connect */
+	__u8	info;		/* see whiteheat_status_info.modem, .error,
+					.flow, .connect */
 };
 
 
@@ -269,7 +292,8 @@ struct whiteheat_event_info {
 
 struct whiteheat_test_info {
 	__u8	port;		/* port number (1 to N) */
-	__u8	test;		/* indicates which test this is a response for, see WHITEHEAT_DO_TEST above */
+	__u8	test;		/* indicates which test this is a response for,
+				   see WHITEHEAT_DO_TEST above */
 	__u8	status;		/* see WHITEHEAT_TEST_* above */
 	__u8	results[32];	/* test-dependent results */
 };

