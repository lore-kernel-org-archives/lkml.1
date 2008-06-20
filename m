Return-Path: <linux-kernel-owner+w=401wt.eu-S932923AbYFTUoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932923AbYFTUoT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760785AbYFTUY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:24:57 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58365 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762041AbYFTUYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:24:54 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 70/70] tty-usb-mos7720: Coding style
To: linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 21:07:29 +0100
Message-ID: <20080620200727.1479.63751.stgit@localhost.localdomain>
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

 drivers/usb/serial/mos7720.c |  227 +++++++++++++++++++++---------------------
 1 files changed, 116 insertions(+), 111 deletions(-)


diff --git a/drivers/usb/serial/mos7720.c b/drivers/usb/serial/mos7720.c
index d47f081..7c4917d 100644
--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -33,7 +33,7 @@
 #include <linux/serial_reg.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 
 /*
@@ -64,8 +64,7 @@
 #define URB_TRANSFER_BUFFER_SIZE	32	/* URB Size */
 
 /* This structure holds all of the local port information */
-struct moschip_port
-{
+struct moschip_port {
 	__u8	shadowLCR;		/* last LCR value received */
 	__u8	shadowMCR;		/* last MCR value received */
 	__u8	shadowMSR;		/* last MSR value received */
@@ -76,8 +75,7 @@ struct moschip_port
 };
 
 /* This structure holds all of the individual serial device information */
-struct moschip_serial
-{
+struct moschip_serial {
 	int interrupt_started;
 };
 
@@ -88,7 +86,7 @@ static int debug;
 #define MOSCHIP_DEVICE_ID_7715		0x7715
 
 static struct usb_device_id moschip_port_id_table [] = {
-	{ USB_DEVICE(USB_VENDOR_ID_MOSCHIP,MOSCHIP_DEVICE_ID_7720) },
+	{ USB_DEVICE(USB_VENDOR_ID_MOSCHIP, MOSCHIP_DEVICE_ID_7720) },
 	{ } /* terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, moschip_port_id_table);
@@ -108,7 +106,7 @@ static void mos7720_interrupt_callback(struct urb *urb)
 	__u8 sp1;
 	__u8 sp2;
 
-	dbg("%s"," : Entering\n");
+	dbg("%s", " : Entering\n");
 
 	switch (status) {
 	case 0:
@@ -208,7 +206,7 @@ static void mos7720_bulk_in_callback(struct urb *urb)
 
 	mos7720_port = urb->context;
 	if (!mos7720_port) {
-		dbg("%s","NULL mos7720_port pointer \n");
+		dbg("%s", "NULL mos7720_port pointer \n");
 		return ;
 	}
 
@@ -284,17 +282,16 @@ static int send_mos_cmd(struct usb_serial *serial, __u8 request, __u16 value,
 	__u16 size = 0x0000;
 
 	if (value < MOS_MAX_PORT) {
-		if (product == MOSCHIP_DEVICE_ID_7715) {
+		if (product == MOSCHIP_DEVICE_ID_7715)
 			value = value*0x100+0x100;
-		} else {
+		else
 			value = value*0x100+0x200;
-		}
 	} else {
 		value = 0x0000;
 		if ((product == MOSCHIP_DEVICE_ID_7715) &&
 		    (index != 0x08)) {
 			dbg("serial->product== MOSCHIP_DEVICE_ID_7715");
-			//index = 0x01 ;
+			/* index = 0x01 ; */
 		}
 	}
 
@@ -308,20 +305,20 @@ static int send_mos_cmd(struct usb_serial *serial, __u8 request, __u16 value,
 		request = (__u8)MOS_READ;
 		requesttype = (__u8)0xC0;
 		size = 0x01;
-		pipe = usb_rcvctrlpipe(serial->dev,0);
+		pipe = usb_rcvctrlpipe(serial->dev, 0);
 	}
 
 	status = usb_control_msg(serial->dev, pipe, request, requesttype,
 				 value, index, data, size, MOS_WDR_TIMEOUT);
 
 	if (status < 0)
-		dbg("Command Write failed Value %x index %x\n",value,index);
+		dbg("Command Write failed Value %x index %x\n", value, index);
 
 	return status;
 }
 
 static int mos7720_open(struct tty_struct *tty,
-			struct usb_serial_port *port, struct file * filp)
+			struct usb_serial_port *port, struct file *filp)
 {
 	struct usb_serial *serial;
 	struct usb_serial_port *port0;
@@ -352,7 +349,7 @@ static int mos7720_open(struct tty_struct *tty,
 
 	/* Initialising the write urb pool */
 	for (j = 0; j < NUM_URBS; ++j) {
-		urb = usb_alloc_urb(0,GFP_KERNEL);
+		urb = usb_alloc_urb(0, GFP_KERNEL);
 		mos7720_port->write_urb_pool[j] = urb;
 
 		if (urb == NULL) {
@@ -386,7 +383,7 @@ static int mos7720_open(struct tty_struct *tty,
 	  */
 	port_number = port->number - port->serial->minor;
 	send_mos_cmd(port->serial, MOS_READ, port_number, UART_LSR, &data);
-	dbg("SS::%p LSR:%x\n",mos7720_port, data);
+	dbg("SS::%p LSR:%x\n", mos7720_port, data);
 
 	dbg("Check:Sending Command ..........");
 
@@ -403,10 +400,10 @@ static int mos7720_open(struct tty_struct *tty,
 	data = 0xCF;
 	send_mos_cmd(serial, MOS_WRITE, port_number, 0x02, &data);
 	data = 0x03;
-        mos7720_port->shadowLCR  = data;
+	mos7720_port->shadowLCR  = data;
 	send_mos_cmd(serial, MOS_WRITE, port_number, 0x03, &data);
 	data = 0x0b;
-        mos7720_port->shadowMCR  = data;
+	mos7720_port->shadowMCR  = data;
 	send_mos_cmd(serial, MOS_WRITE, port_number, 0x04, &data);
 	data = 0x0b;
 	send_mos_cmd(serial, MOS_WRITE, port_number, 0x04, &data);
@@ -421,7 +418,8 @@ static int mos7720_open(struct tty_struct *tty,
 	data = 0x03;
 	send_mos_cmd(serial, MOS_WRITE, MOS_MAX_PORT, port_number + 1, &data);
 	data = 0x00;
-	send_mos_cmd(port->serial, MOS_WRITE, MOS_MAX_PORT, port_number + 1, &data);
+	send_mos_cmd(port->serial, MOS_WRITE, MOS_MAX_PORT,
+						port_number + 1, &data);
 */
 	data = 0x00;
 	send_mos_cmd(serial, MOS_READ, MOS_MAX_PORT, 0x08, &data);
@@ -430,14 +428,14 @@ static int mos7720_open(struct tty_struct *tty,
 	send_mos_cmd(serial, MOS_WRITE, MOS_MAX_PORT, 0x08, &data);
 
 	data = 0x83;
-        mos7720_port->shadowLCR  = data;
+	mos7720_port->shadowLCR  = data;
 	send_mos_cmd(serial, MOS_WRITE, port_number, 0x03, &data);
 	data = 0x0c;
 	send_mos_cmd(serial, MOS_WRITE, port_number, 0x00, &data);
 	data = 0x00;
 	send_mos_cmd(serial, MOS_WRITE, port_number, 0x01, &data);
 	data = 0x03;
-        mos7720_port->shadowLCR  = data;
+	mos7720_port->shadowLCR  = data;
 	send_mos_cmd(serial, MOS_WRITE, port_number, 0x03, &data);
 	data = 0x0c;
 	send_mos_cmd(serial, MOS_WRITE, port_number, 0x01, &data);
@@ -464,15 +462,15 @@ static int mos7720_open(struct tty_struct *tty,
 
 		/* set up our interrupt urb */
 		usb_fill_int_urb(port0->interrupt_in_urb, serial->dev,
-				 usb_rcvintpipe(serial->dev,
-				 		port->interrupt_in_endpointAddress),
-				 port0->interrupt_in_buffer,
-				 port0->interrupt_in_urb->transfer_buffer_length,
-				 mos7720_interrupt_callback, mos7720_port,
-				 port0->interrupt_in_urb->interval);
+			 usb_rcvintpipe(serial->dev,
+				port->interrupt_in_endpointAddress),
+			 port0->interrupt_in_buffer,
+			 port0->interrupt_in_urb->transfer_buffer_length,
+			 mos7720_interrupt_callback, mos7720_port,
+			 port0->interrupt_in_urb->interval);
 
 		/* start interrupt read for this mos7720 this interrupt *
-	         * will continue as long as the mos7720 is connected    */
+		 * will continue as long as the mos7720 is connected    */
 		dbg("Submit URB over !!!");
 		response = usb_submit_urb(port0->interrupt_in_urb, GFP_KERNEL);
 		if (response)
@@ -484,14 +482,14 @@ static int mos7720_open(struct tty_struct *tty,
 	/* set up our bulk in urb */
 	usb_fill_bulk_urb(port->read_urb, serial->dev,
 			  usb_rcvbulkpipe(serial->dev,
-			  		  port->bulk_in_endpointAddress),
+				port->bulk_in_endpointAddress),
 			  port->bulk_in_buffer,
 			  port->read_urb->transfer_buffer_length,
 			  mos7720_bulk_in_callback, mos7720_port);
 	response = usb_submit_urb(port->read_urb, GFP_KERNEL);
 	if (response)
-		dev_err(&port->dev,
-			"%s - Error %d submitting read urb\n", __func__, response);
+		dev_err(&port->dev, "%s - Error %d submitting read urb\n",
+							__func__, response);
 
 	/* initialize our icount structure */
 	memset(&(mos7720_port->icount), 0x00, sizeof(mos7720_port->icount));
@@ -530,7 +528,8 @@ static int mos7720_chars_in_buffer(struct tty_struct *tty)
 	}
 
 	for (i = 0; i < NUM_URBS; ++i) {
-		if (mos7720_port->write_urb_pool[i] && mos7720_port->write_urb_pool[i]->status == -EINPROGRESS)
+		if (mos7720_port->write_urb_pool[i] &&
+		    mos7720_port->write_urb_pool[i]->status == -EINPROGRESS)
 			chars += URB_TRANSFER_BUFFER_SIZE;
 	}
 	dbg("%s - returns %d", __func__, chars);
@@ -576,12 +575,12 @@ static void mos7720_close(struct tty_struct *tty,
 	 * been disconnected */
 	if (!serial->disconnected) {
 		data = 0x00;
-		send_mos_cmd(serial, MOS_WRITE, port->number - port->serial->minor,
-			     0x04, &data);
+		send_mos_cmd(serial, MOS_WRITE,
+			port->number - port->serial->minor, 0x04, &data);
 
 		data = 0x00;
-		send_mos_cmd(serial, MOS_WRITE, port->number - port->serial->minor,
-			     0x01, &data);
+		send_mos_cmd(serial, MOS_WRITE,
+			port->number - port->serial->minor, 0x01, &data);
 	}
 	mutex_unlock(&serial->disc_mutex);
 	mos7720_port->open = 0;
@@ -592,7 +591,7 @@ static void mos7720_close(struct tty_struct *tty,
 static void mos7720_break(struct tty_struct *tty, int break_state)
 {
 	struct usb_serial_port *port = tty->driver_data;
-        unsigned char data;
+	unsigned char data;
 	struct usb_serial *serial;
 	struct moschip_port *mos7720_port;
 
@@ -640,7 +639,8 @@ static int mos7720_write_room(struct tty_struct *tty)
 
 	/* FIXME: Locking */
 	for (i = 0; i < NUM_URBS; ++i) {
-		if (mos7720_port->write_urb_pool[i] && mos7720_port->write_urb_pool[i]->status != -EINPROGRESS)
+		if (mos7720_port->write_urb_pool[i] &&
+		    mos7720_port->write_urb_pool[i]->status != -EINPROGRESS)
 			room += URB_TRANSFER_BUFFER_SIZE;
 	}
 
@@ -675,9 +675,10 @@ static int mos7720_write(struct tty_struct *tty, struct usb_serial_port *port,
 	urb = NULL;
 
 	for (i = 0; i < NUM_URBS; ++i) {
-		if (mos7720_port->write_urb_pool[i] && mos7720_port->write_urb_pool[i]->status != -EINPROGRESS) {
+		if (mos7720_port->write_urb_pool[i] &&
+		    mos7720_port->write_urb_pool[i]->status != -EINPROGRESS) {
 			urb = mos7720_port->write_urb_pool[i];
-			dbg("URB:%d",i);
+			dbg("URB:%d", i);
 			break;
 		}
 	}
@@ -695,7 +696,7 @@ static int mos7720_write(struct tty_struct *tty, struct usb_serial_port *port,
 			goto exit;
 		}
 	}
-	transfer_size = min (count, URB_TRANSFER_BUFFER_SIZE);
+	transfer_size = min(count, URB_TRANSFER_BUFFER_SIZE);
 
 	memcpy(urb->transfer_buffer, current_position, transfer_size);
 	usb_serial_debug_data(debug, &port->dev, __func__, transfer_size,
@@ -704,12 +705,12 @@ static int mos7720_write(struct tty_struct *tty, struct usb_serial_port *port,
 	/* fill urb with data and submit  */
 	usb_fill_bulk_urb(urb, serial->dev,
 			  usb_sndbulkpipe(serial->dev,
-			  		  port->bulk_out_endpointAddress),
+					port->bulk_out_endpointAddress),
 			  urb->transfer_buffer, transfer_size,
 			  mos7720_bulk_out_data_callback, mos7720_port);
 
 	/* send it down the pipe */
-	status = usb_submit_urb(urb,GFP_ATOMIC);
+	status = usb_submit_urb(urb, GFP_ATOMIC);
 	if (status) {
 		err("%s - usb_submit_urb(write bulk) failed with status = %d",
 		    __func__, status);
@@ -810,9 +811,9 @@ static int set_higher_rates(struct moschip_port *mos7720_port,
 	port = mos7720_port->port;
 	serial = port->serial;
 
-        /***********************************************
-         *      Init Sequence for higher rates
-         ***********************************************/
+	 /***********************************************
+	 *      Init Sequence for higher rates
+	 ***********************************************/
 	dbg("Sending Setting Commands ..........");
 	port_number = port->number - port->serial->minor;
 
@@ -823,7 +824,7 @@ static int set_higher_rates(struct moschip_port *mos7720_port,
 	data = 0x0CF;
 	send_mos_cmd(serial, MOS_WRITE, port->number, 0x02, &data);
 	data = 0x00b;
-        mos7720_port->shadowMCR  = data;
+	mos7720_port->shadowMCR  = data;
 	send_mos_cmd(serial, MOS_WRITE, port_number, 0x04, &data);
 	data = 0x00b;
 	send_mos_cmd(serial, MOS_WRITE, port_number, 0x04, &data);
@@ -834,12 +835,12 @@ static int set_higher_rates(struct moschip_port *mos7720_port,
 	send_mos_cmd(serial, MOS_WRITE, MOS_MAX_PORT, 0x08, &data);
 
 
-        /***********************************************
-         *              Set for higher rates           *
-         ***********************************************/
+	/***********************************************
+	 *              Set for higher rates           *
+	 ***********************************************/
 
 	data = baud * 0x10;
-	send_mos_cmd(serial, MOS_WRITE, MOS_MAX_PORT, port_number + 1,&data);
+	send_mos_cmd(serial, MOS_WRITE, MOS_MAX_PORT, port_number + 1, &data);
 
 	data = 0x003;
 	send_mos_cmd(serial, MOS_READ, MOS_MAX_PORT, 0x08, &data);
@@ -847,34 +848,33 @@ static int set_higher_rates(struct moschip_port *mos7720_port,
 	send_mos_cmd(serial, MOS_WRITE, MOS_MAX_PORT, 0x08, &data);
 
 	data = 0x02b;
-        mos7720_port->shadowMCR  = data;
+	mos7720_port->shadowMCR  = data;
 	send_mos_cmd(serial, MOS_WRITE, port_number, 0x04, &data);
 	data = 0x02b;
 	send_mos_cmd(serial, MOS_WRITE, port_number, 0x04, &data);
 
-        /***********************************************
-         *              Set DLL/DLM
-         ***********************************************/
+	/***********************************************
+	 *              Set DLL/DLM
+	 ***********************************************/
 
 	data = mos7720_port->shadowLCR | UART_LCR_DLAB;
-        mos7720_port->shadowLCR  = data;
+	mos7720_port->shadowLCR  = data;
 	send_mos_cmd(serial, MOS_WRITE, port_number, 0x03, &data);
 
 	data =  0x001; /* DLL */
-        send_mos_cmd(serial, MOS_WRITE, port_number, 0x00, &data);
+	send_mos_cmd(serial, MOS_WRITE, port_number, 0x00, &data);
 	data =  0x000; /* DLM */
-        send_mos_cmd(serial, MOS_WRITE, port_number, 0x01, &data);
+	send_mos_cmd(serial, MOS_WRITE, port_number, 0x01, &data);
 
 	data = mos7720_port->shadowLCR & ~UART_LCR_DLAB;
-        mos7720_port->shadowLCR  = data;
+	mos7720_port->shadowLCR  = data;
 	send_mos_cmd(serial, MOS_WRITE, port_number, 0x03, &data);
 
 	return 0;
 }
 
 /* baud rate information */
-struct divisor_table_entry
-{
+struct divisor_table_entry {
 	__u32  baudrate;
 	__u16  divisor;
 };
@@ -923,8 +923,8 @@ static int calc_baud_rate_divisor(int baudrate, int *divisor)
 		}
 	}
 
-        /* After trying for all the standard baud rates    *
-         * Try calculating the divisor for this baud rate  */
+	/* After trying for all the standard baud rates    *
+	 * Try calculating the divisor for this baud rate  */
 	if (baudrate > 75 &&  baudrate < 230400) {
 		/* get the divisor */
 		custom = (__u16)(230400L  / baudrate);
@@ -936,7 +936,7 @@ static int calc_baud_rate_divisor(int baudrate, int *divisor)
 			custom++;
 		*divisor = custom;
 
-		dbg("Baud %d = %d",baudrate, custom);
+		dbg("Baud %d = %d", baudrate, custom);
 		return 0;
 	}
 
@@ -970,29 +970,29 @@ static int send_cmd_write_baud_rate(struct moschip_port *mos7720_port,
 	number = port->number - port->serial->minor;
 	dbg("%s - port = %d, baud = %d", __func__, port->number, baudrate);
 
-        /* Calculate the Divisor */
+	/* Calculate the Divisor */
 	status = calc_baud_rate_divisor(baudrate, &divisor);
 	if (status) {
 		err("%s - bad baud rate", __func__);
 		return status;
 	}
 
-        /* Enable access to divisor latch */
-        data = mos7720_port->shadowLCR | UART_LCR_DLAB;
-        mos7720_port->shadowLCR  = data;
-        send_mos_cmd(serial, MOS_WRITE, number, UART_LCR, &data);
+	/* Enable access to divisor latch */
+	data = mos7720_port->shadowLCR | UART_LCR_DLAB;
+	mos7720_port->shadowLCR  = data;
+	send_mos_cmd(serial, MOS_WRITE, number, UART_LCR, &data);
 
 	/* Write the divisor */
 	data = ((unsigned char)(divisor & 0xff));
-        send_mos_cmd(serial, MOS_WRITE, number, 0x00, &data);
+	send_mos_cmd(serial, MOS_WRITE, number, 0x00, &data);
 
 	data = ((unsigned char)((divisor & 0xff00) >> 8));
-        send_mos_cmd(serial, MOS_WRITE, number, 0x01, &data);
+	send_mos_cmd(serial, MOS_WRITE, number, 0x01, &data);
 
-        /* Disable access to divisor latch */
-        data = mos7720_port->shadowLCR & ~UART_LCR_DLAB;
-        mos7720_port->shadowLCR = data;
-        send_mos_cmd(serial, MOS_WRITE, number, 0x03, &data);
+	/* Disable access to divisor latch */
+	data = mos7720_port->shadowLCR & ~UART_LCR_DLAB;
+	mos7720_port->shadowLCR = data;
+	send_mos_cmd(serial, MOS_WRITE, number, 0x03, &data);
 
 	return status;
 }
@@ -1095,29 +1095,31 @@ static void change_port_settings(struct tty_struct *tty,
 #define LCR_PAR_MASK		0x38	/* Mask for parity field */
 
 	/* Update the LCR with the correct value */
-	mos7720_port->shadowLCR &= ~(LCR_BITS_MASK | LCR_STOP_MASK | LCR_PAR_MASK);
+	mos7720_port->shadowLCR &=
+			~(LCR_BITS_MASK | LCR_STOP_MASK | LCR_PAR_MASK);
 	mos7720_port->shadowLCR |= (lData | lParity | lStop);
 
 
 	/* Disable Interrupts */
 	data = 0x00;
-        send_mos_cmd(serial,MOS_WRITE,port->number - port->serial->minor, UART_IER, &data);
+	send_mos_cmd(serial, MOS_WRITE, port->number - port->serial->minor,
+							UART_IER, &data);
 
 	data = 0x00;
-        send_mos_cmd(serial, MOS_WRITE, port_number, UART_FCR, &data);
+	send_mos_cmd(serial, MOS_WRITE, port_number, UART_FCR, &data);
 
 	data = 0xcf;
-        send_mos_cmd(serial, MOS_WRITE, port_number, UART_FCR, &data);
+	send_mos_cmd(serial, MOS_WRITE, port_number, UART_FCR, &data);
 
 	/* Send the updated LCR value to the mos7720 */
 	data = mos7720_port->shadowLCR;
-        send_mos_cmd(serial, MOS_WRITE, port_number, UART_LCR, &data);
+	send_mos_cmd(serial, MOS_WRITE, port_number, UART_LCR, &data);
 
-        data = 0x00b;
-        mos7720_port->shadowMCR = data;
-        send_mos_cmd(serial, MOS_WRITE, port_number, 0x04, &data);
-        data = 0x00b;
-        send_mos_cmd(serial, MOS_WRITE, port_number, 0x04, &data);
+	data = 0x00b;
+	mos7720_port->shadowMCR = data;
+	send_mos_cmd(serial, MOS_WRITE, port_number, 0x04, &data);
+	data = 0x00b;
+	send_mos_cmd(serial, MOS_WRITE, port_number, 0x04, &data);
 
 	/* set up the MCR register and send it to the mos7720 */
 	mos7720_port->shadowMCR = UART_MCR_OUT2;
@@ -1126,9 +1128,8 @@ static void change_port_settings(struct tty_struct *tty,
 
 	if (cflag & CRTSCTS) {
 		mos7720_port->shadowMCR |= (UART_MCR_XONANY);
-
-                /* To set hardware flow control to the specified *
-                 * serial port, in SP1/2_CONTROL_REG             */
+		/* To set hardware flow control to the specified *
+		 * serial port, in SP1/2_CONTROL_REG             */
 		if (port->number) {
 			data = 0x001;
 			send_mos_cmd(serial, MOS_WRITE, MOS_MAX_PORT,
@@ -1207,7 +1208,7 @@ static void mos7720_set_termios(struct tty_struct *tty,
 		return;
 	}
 
-	dbg("%s\n","setting termios - ASPIRE");
+	dbg("%s\n", "setting termios - ASPIRE");
 
 	cflag = tty->termios->c_cflag;
 
@@ -1224,12 +1225,12 @@ static void mos7720_set_termios(struct tty_struct *tty,
 	/* change the port settings to the new ones specified */
 	change_port_settings(tty, mos7720_port, old_termios);
 
-	if(!port->read_urb) {
-		dbg("%s","URB KILLED !!!!!\n");
+	if (!port->read_urb) {
+		dbg("%s", "URB KILLED !!!!!\n");
 		return;
 	}
 
-	if(port->read_urb->status != -EINPROGRESS) {
+	if (port->read_urb->status != -EINPROGRESS) {
 		port->read_urb->dev = serial->dev;
 		status = usb_submit_urb(port->read_urb, GFP_ATOMIC);
 		if (status)
@@ -1249,8 +1250,8 @@ static void mos7720_set_termios(struct tty_struct *tty,
  * 	    transmit holding register is empty.  This functionality
  * 	    allows an RS485 driver to be written in user space.
  */
-static int get_lsr_info(struct tty_struct *tty, struct moschip_port *mos7720_port,
-			unsigned int __user *value)
+static int get_lsr_info(struct tty_struct *tty,
+		struct moschip_port *mos7720_port, unsigned int __user *value)
 {
 	int count;
 	unsigned int result = 0;
@@ -1301,7 +1302,7 @@ static int set_modem_info(struct moschip_port *mos7720_port, unsigned int cmd,
 	if (mos7720_port == NULL)
 		return -1;
 
-	port = (struct usb_serial_port*)mos7720_port->port;
+	port = (struct usb_serial_port *)mos7720_port->port;
 	mcr = mos7720_port->shadowMCR;
 
 	if (copy_from_user(&arg, value, sizeof(int)))
@@ -1382,7 +1383,7 @@ static int get_serial_info(struct moschip_port *mos7720_port,
 	tmp.port		= mos7720_port->port->number;
 	tmp.irq			= 0;
 	tmp.flags		= ASYNC_SKIP_TEST | ASYNC_AUTO_IRQ;
-        tmp.xmit_fifo_size	= NUM_URBS * URB_TRANSFER_BUFFER_SIZE;
+	tmp.xmit_fifo_size	= NUM_URBS * URB_TRANSFER_BUFFER_SIZE;
 	tmp.baud_base		= 9600;
 	tmp.close_delay		= 5*HZ;
 	tmp.closing_wait	= 30*HZ;
@@ -1417,15 +1418,16 @@ static int mos7720_ioctl(struct tty_struct *tty, struct file *file,
 
 	case TIOCSERGETLSR:
 		dbg("%s (%d) TIOCSERGETLSR", __func__,  port->number);
-		return get_lsr_info(tty, mos7720_port, (unsigned int __user *)arg);
+		return get_lsr_info(tty, mos7720_port,
+					(unsigned int __user *)arg);
 		return 0;
 
 	/* FIXME: These should be using the mode methods */
 	case TIOCMBIS:
 	case TIOCMBIC:
 	case TIOCMSET:
-		dbg("%s (%d) TIOCMSET/TIOCMBIC/TIOCMSET", __func__,
-		    port->number);
+		dbg("%s (%d) TIOCMSET/TIOCMBIC/TIOCMSET",
+					__func__, port->number);
 		return set_modem_info(mos7720_port, cmd,
 				      (unsigned int __user *)arg);
 
@@ -1452,7 +1454,7 @@ static int mos7720_ioctl(struct tty_struct *tty, struct file *file,
 			if (((arg & TIOCM_RNG) && (cnow.rng != cprev.rng)) ||
 			    ((arg & TIOCM_DSR) && (cnow.dsr != cprev.dsr)) ||
 			    ((arg & TIOCM_CD)  && (cnow.dcd != cprev.dcd)) ||
-			    ((arg & TIOCM_CTS) && (cnow.cts != cprev.cts)) ) {
+			    ((arg & TIOCM_CTS) && (cnow.cts != cprev.cts))) {
 				return 0;
 			}
 			cprev = cnow;
@@ -1475,7 +1477,7 @@ static int mos7720_ioctl(struct tty_struct *tty, struct file *file,
 		icount.buf_overrun = cnow.buf_overrun;
 
 		dbg("%s (%d) TIOCGICOUNT RX=%d, TX=%d", __func__,
-		    port->number, icount.rx, icount.tx );
+		    port->number, icount.rx, icount.tx);
 		if (copy_to_user((void __user *)arg, &icount, sizeof(icount)))
 			return -EFAULT;
 		return 0;
@@ -1526,7 +1528,8 @@ static int mos7720_startup(struct usb_serial *serial)
 		/* Initialize all port interrupt end point to port 0 int
 		 * endpoint.  Our device has only one interrupt endpoint
 		 * comman to all ports */
-		serial->port[i]->interrupt_in_endpointAddress = serial->port[0]->interrupt_in_endpointAddress;
+		serial->port[i]->interrupt_in_endpointAddress =
+				serial->port[0]->interrupt_in_endpointAddress;
 
 		mos7720_port->port = serial->port[i];
 		usb_set_serial_port_data(serial->port[i], mos7720_port);
@@ -1538,13 +1541,15 @@ static int mos7720_startup(struct usb_serial *serial)
 
 	/* setting configuration feature to one */
 	usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
-			(__u8)0x03, 0x00,0x01,0x00, NULL, 0x00, 5*HZ);
+			(__u8)0x03, 0x00, 0x01, 0x00, NULL, 0x00, 5*HZ);
 
-	send_mos_cmd(serial,MOS_READ,0x00, UART_LSR, &data);  // LSR For Port 1
-	dbg("LSR:%x",data);
+	/* LSR For Port 1 */
+	send_mos_cmd(serial, MOS_READ, 0x00, UART_LSR, &data);
+	dbg("LSR:%x", data);
 
-	send_mos_cmd(serial,MOS_READ,0x01, UART_LSR, &data);  // LSR For Port 2
-	dbg("LSR:%x",data);
+	/* LSR For Port 2 */
+	send_mos_cmd(serial, MOS_READ, 0x01, UART_LSR, &data);
+	dbg("LSR:%x", data);
 
 	return 0;
 }
@@ -1554,7 +1559,7 @@ static void mos7720_shutdown(struct usb_serial *serial)
 	int i;
 
 	/* free private structure allocated for serial port */
-	for (i=0; i < serial->num_ports; ++i) {
+	for (i = 0; i < serial->num_ports; ++i) {
 		kfree(usb_get_serial_port_data(serial->port[i]));
 		usb_set_serial_port_data(serial->port[i], NULL);
 	}
@@ -1634,8 +1639,8 @@ module_init(moschip7720_init);
 module_exit(moschip7720_exit);
 
 /* Module information */
-MODULE_AUTHOR( DRIVER_AUTHOR );
-MODULE_DESCRIPTION( DRIVER_DESC );
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
 
 module_param(debug, bool, S_IRUGO | S_IWUSR);

