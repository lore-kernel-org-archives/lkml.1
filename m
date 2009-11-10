Return-Path: <linux-kernel-owner+w=401wt.eu-S1756146AbZKJNHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146AbZKJNHT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 08:07:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753442AbZKJNHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 08:07:18 -0500
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:55955 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752874AbZKJNHQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 08:07:16 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: daniel.ritz@gmx.ch
Subject: Re: [RFC PATCH v2] NEXIO (or iNexio) support for usbtouchscreen
Date: Tue, 10 Nov 2009 14:07:11 +0100
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
References: <200911091537.31942.linux@rainbow-software.org>
In-Reply-To: <200911091537.31942.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200911101407.12695.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 November 2009, Ondrej Zary wrote:
> Hello,
> I have a NEXIO (or iNexio) NEX170MRT LCD monitor with integrated
> touchscreen with USB interface:
> T:  Bus=02 Lev=01 Prnt=01 Port=01 Cnt=01 Dev#= 54 Spd=12  MxCh= 0
> D:  Ver= 1.10 Cls=02(comm.) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
> P:  Vendor=1870 ProdID=0001 Rev= 1.00
> S:  Manufacturer=iNexio
> S:  Product=iNexio USB
> C:* #Ifs= 2 Cfg#= 1 Atr=c0 MxPwr=500mA
> I:* If#= 0 Alt= 0 #EPs= 1 Cls=02(comm.) Sub=02 Prot=00
> Driver=usbtouchscreen E:  Ad=83(I) Atr=03(Int.) MxPS=   8 Ivl=255ms
> I:* If#= 1 Alt= 0 #EPs= 2 Cls=0a(data ) Sub=00 Prot=00 Driver=(none)
> E:  Ad=01(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
> E:  Ad=82(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
>
>
> There's a iNexio serial touchscreen driver in kernel but it does not work
> for this touchscreen. Without a driver, it just connects and disconnects
> (after a while) repeatedly:
> usb 2-2: new full speed USB device using uhci_hcd and address 3
> usb 2-2: New USB device found, idVendor=1870, idProduct=0001
> usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> usb 2-2: Product: iNexio USB
> usb 2-2: Manufacturer: iNexio
> usb 2-2: configuration #1 chosen from 1 choice
> usb 2-2: USB disconnect, address 3
> usb 2-2: new full speed USB device using uhci_hcd and address 4
> usb 2-2: New USB device found, idVendor=1870, idProduct=0001
> usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> usb 2-2: Product: iNexio USB
> usb 2-2: Manufacturer: iNexio
> usb 2-2: configuration #1 chosen from 1 choice
> usb 2-2: USB disconnect, address 4
>
>
> I captured (using SniffUSB) the communication between the Windows driver
> and the touchscreen after plugging in:
> http://www.rainbow-software.org/linux_files/nexio/UsbSnoop-plug.log
>
> Log with some touches after plugging in:
> http://www.rainbow-software.org/linux_files/nexio/UsbSnoop-plugandtouch.log
>
> If I understand it correctly, there's system initialization (first 3 URBs),
> then the driver starts communication:
> URB 4: read, touchscreen returns 82 04 ab aa
> URB 5: read, touchscreen returns nothing
> URB 6: write 82 04 0a 0f
> URB 7: read, touchscreen returns 84 04 0a 0f
> URB 8: read, touchscreen returns 83 0a 32 2e 31 30 53 4d 53 4e (2.10SMSN -
>        firmware version as Windows driver displays)
> URB 9: read, touchscreen returns 84 09 6d 2d 4e 65 78 69 6f (m-Nexio -
> device name as Windows driver displays)
> URB 10: read, touchscreen returns nothing
>
> Then 3 reads touchscreen returns nothing and returns "82 04 ab aa" on the
> 4th read.
>
> Touchscreen sends 123 bytes of touch data:
>     00000000: e1 00 74 00 40 00 34 00 00 00 11 10 0d 00 11 00
>     00000010: 0a 00 01 07 03 04 02 03 00 05 00 0e 09 00 02 08
>     00000020: 00 01 00 01 01 06 00 0e 00 0b 14 01 0d 06 00 00
>     00000030: 02 02 00 02 11 11 06 01 00 02 01 0a 62 64 00 07
>     00000040: 05 03 00 03 00 03 00 00 03 02 03 02 00 02 0a 00
>     00000050: 02 05 00 06 64 64 64 01 02 04 03 0d 02 02 01 02
>     00000060: 07 02 02 00 00 07 03 04 03 01 04 03 03 03 00 03
>     00000070: 06 04 04 01 02 03 00 02 02 01 11
> and driver acknowledges with "aa 02".
>
> All reads are coming from endpoint 0x82 and all writes go to endpoint 0x01.
>
> The driver continuously submits read URBs to endpoint 0x82. Touchscreen
> answers after 1 second if there's no activity or immediately with touch
> data.
>
>
> I did this (but I don't know much about USB programming). The
> initialization seems to work (outputs firmware version and device name
> correctly). But the device disconnects probably because of absent
> communication. The first URB should be probably sent in nexio_init().
> Also the usbtouchscreen tries to bind to both device interfaces and it
> fails the second time. How to solve this?
>
> --- drivers/input/touchscreen/usbtouchscreen.c.orig	2009-09-10
> 00:13:59.000000000 +0200
> +++ drivers/input/touchscreen/usbtouchscreen.c	2009-11-09
> 14:39:48.000000000 +0100
> @@ -13,6 +13,7 @@
>   *  - IdealTEK URTC1000
>   *  - General Touch
>   *  - GoTop Super_Q2/GogoPen/PenPower tablets
> + *  - NEXIO/iNexio
>   *
>   * Copyright (C) 2004-2007 by Daniel Ritz <daniel.ritz@gmx.ch>
>   * Copyright (C) by Todd E. Johnson (mtouchusb.c)
> @@ -118,6 +119,7 @@
>  	DEVTYPE_IDEALTEK,
>  	DEVTYPE_GENERAL_TOUCH,
>  	DEVTYPE_GOTOP,
> +	DEVTYPE_NEXIO,
>  };
>
>  #define USB_DEVICE_HID_CLASS(vend, prod) \
> @@ -191,6 +193,11 @@
>  	{USB_DEVICE(0x08f2, 0x00f4), .driver_info = DEVTYPE_GOTOP},
>  #endif
>
> +#ifdef CONFIG_TOUCHSCREEN_USB_NEXIO
> +	{USB_DEVICE(0x10f0, 0x2002), .driver_info = DEVTYPE_NEXIO},
> +	{USB_DEVICE(0x1870, 0x0001), .driver_info = DEVTYPE_NEXIO},
> +#endif
> +
>  	{}
>  };
>
> @@ -563,6 +570,87 @@
>  }
>  #endif
>
> +/*************************************************************************
>**** + * NEXIO Part
> + */
> +#ifdef CONFIG_TOUCHSCREEN_USB_NEXIO
> +
> +#define NEXIO_OUTPUT_EP	0x01
> +#define NEXIO_INPUT_EP	0x82
> +#define NEXIO_TIMEOUT	5000
> +#define NEXIO_BUFSIZE	1024
> +
> +static int nexio_init(struct usbtouch_usb *usbtouch)
> +{
> +	struct usb_device *dev = usbtouch->udev;
> +	int ret = -ENOMEM;
> +	int actual_len;
> +	unsigned char *buf;
> +
> +	buf = kmalloc(NEXIO_BUFSIZE, GFP_KERNEL);
> +	if (!buf)
> +		goto err_nobuf;
> +	printk("1 read\n");
> +	ret = usb_bulk_msg(dev, usb_rcvbulkpipe(dev, NEXIO_INPUT_EP), buf,
> +			   NEXIO_BUFSIZE, &actual_len, NEXIO_TIMEOUT);
> +	if (ret < 0)
> +		goto err_out;
> +	printk("2 read\n");
> +	ret = usb_bulk_msg(dev, usb_rcvbulkpipe(dev, NEXIO_INPUT_EP), buf,
> +			   NEXIO_BUFSIZE, &actual_len, NEXIO_TIMEOUT);
> +	if (ret < 0)
> +		goto err_out;
> +	/* Send some command */
> +	printk("3 write \n");
> +	buf[0] = 0x82;
> +	buf[1] = 0x04;
> +	buf[2] = 0x0a;
> +	buf[3] = 0x0f;
> +	ret = usb_bulk_msg(dev, usb_sndbulkpipe(dev, NEXIO_OUTPUT_EP), buf, 4,
> +			   &actual_len, NEXIO_TIMEOUT);
> +	if (ret < 0)
> +		goto err_out;
> +	/* Read it back */
> +	printk("4 read\n");
> +	ret = usb_bulk_msg(dev, usb_rcvbulkpipe(dev, NEXIO_INPUT_EP), buf,
> +			  NEXIO_BUFSIZE, &actual_len, NEXIO_TIMEOUT);
> +	if (ret < 0)
> +		goto err_out;
> +	/* Read firmware version */
> +	printk("5 read\n");
> +	ret = usb_bulk_msg(dev, usb_rcvbulkpipe(dev, 0x82), buf, NEXIO_BUFSIZE,
> +			   &actual_len, NEXIO_TIMEOUT);
> +	if (ret < 0)
> +		goto err_out;
> +	buf[buf[1]] = 0;
> +	printk("Firmware version %s\n", &buf[2]);
> +	/* Read device name */
> +	printk("6 read\n");
> +	ret = usb_bulk_msg(dev, usb_rcvbulkpipe(dev, 0x82), buf, NEXIO_BUFSIZE,
> +			   &actual_len, NEXIO_TIMEOUT);
> +	if (ret < 0)
> +		goto err_out;
> +	buf[buf[1]] = 0;
> +	printk("Device name %s\n", &buf[2]);
> +	if (usb_submit_urb(usbtouch->irq, GFP_KERNEL))
> +		return -EIO;
> +err_out:
> +	kfree(buf);
> +err_nobuf:
> +	return ret;
> +}
> +
> +static int nexio_read_data(struct usbtouch_usb *dev, unsigned char *pkt)
> +{
> +	int i;
> +	printk("nexio_read_data: ");
> +	for (i = 0; i < pkt[1]; i++)
> +		printk("%02X", pkt[i]);
> +
> +	return 0;
> +}
> +#endif
> +
>
> 
> /**************************************************************************
>*** * the different device descriptors
> @@ -702,6 +790,18 @@
>  		.read_data	= gotop_read_data,
>  	},
>  #endif
> +
> +#ifdef CONFIG_TOUCHSCREEN_USB_NEXIO
> +	[DEVTYPE_NEXIO] = {
> +		.min_xc		= 0x0,
> +		.max_xc		= 0x03ff,
> +		.min_yc		= 0x0,
> +		.max_yc		= 0x03ff,
> +		.rept_size	= 4,
> +		.read_data	= nexio_read_data,
> +		.init		= nexio_init,
> +	},
> +#endif
>  };

Here's another patch. It's getting better - the device does not disconnect
anymore and I get the touch data (but don't know its structure). Either I
don't understand it correctly or the device's USB implementation is broken.
Sending the interrupt URB to endpoint 0x83 but it works with endpoint 0x82.

--- drivers/input/touchscreen/usbtouchscreen.c.orig	2009-09-10 00:13:59.000000000 +0200
+++ drivers/input/touchscreen/usbtouchscreen.c	2009-11-10 13:36:14.000000000 +0100
@@ -13,6 +13,7 @@
  *  - IdealTEK URTC1000
  *  - General Touch
  *  - GoTop Super_Q2/GogoPen/PenPower tablets
+ *  - NEXIO/iNexio
  *
  * Copyright (C) 2004-2007 by Daniel Ritz <daniel.ritz@gmx.ch>
  * Copyright (C) by Todd E. Johnson (mtouchusb.c)
@@ -40,7 +41,7 @@
  *
  *****************************************************************************/
 
-//#define DEBUG
+#define DEBUG
 
 #include <linux/kernel.h>
 #include <linux/slab.h>
@@ -118,6 +119,7 @@
 	DEVTYPE_IDEALTEK,
 	DEVTYPE_GENERAL_TOUCH,
 	DEVTYPE_GOTOP,
+	DEVTYPE_NEXIO,
 };
 
 #define USB_DEVICE_HID_CLASS(vend, prod) \
@@ -191,6 +193,15 @@
 	{USB_DEVICE(0x08f2, 0x00f4), .driver_info = DEVTYPE_GOTOP},
 #endif
 
+#ifdef CONFIG_TOUCHSCREEN_USB_NEXIO
+	/* ignore the comm interface */
+	{USB_DEVICE_AND_INTERFACE_INFO(0x10f0, 0x2002, 0x02, 0x02, 0x00), .driver_info = DEVTYPE_IGNORE},
+	{USB_DEVICE_AND_INTERFACE_INFO(0x1870, 0x0001, 0x02, 0x02, 0x00), .driver_info = DEVTYPE_IGNORE},
+	/* normal device IDs */
+	{USB_DEVICE(0x10f0, 0x2002), .driver_info = DEVTYPE_NEXIO},
+	{USB_DEVICE(0x1870, 0x0001), .driver_info = DEVTYPE_NEXIO},
+#endif
+
 	{}
 };
 
@@ -563,6 +574,94 @@
 }
 #endif
 
+/*****************************************************************************
+ * NEXIO Part
+ */
+#ifdef CONFIG_TOUCHSCREEN_USB_NEXIO
+
+#define NEXIO_OUTPUT_EP	0x01
+#define NEXIO_INPUT_EP	0x82
+#define NEXIO_TIMEOUT	5000
+#define NEXIO_BUFSIZE	1024
+#define NEXIO_PKT_LEN	 122
+
+static int nexio_init(struct usbtouch_usb *usbtouch)
+{
+	struct usb_device *dev = usbtouch->udev;
+	int ret = -ENOMEM;
+	int actual_len;
+	unsigned char *buf;
+
+	buf = kmalloc(NEXIO_BUFSIZE, GFP_KERNEL);
+	if (!buf)
+		goto err_nobuf;
+	printk("1 read\n");
+	ret = usb_bulk_msg(dev, usb_rcvbulkpipe(dev, NEXIO_INPUT_EP), buf,
+			   NEXIO_BUFSIZE, &actual_len, NEXIO_TIMEOUT);
+	if (ret < 0)
+		goto err_out;
+	printk("2 read\n");
+	ret = usb_bulk_msg(dev, usb_rcvbulkpipe(dev, NEXIO_INPUT_EP), buf,
+			   NEXIO_BUFSIZE, &actual_len, NEXIO_TIMEOUT);
+	if (ret < 0)
+		goto err_out;
+	/* send some command */
+	printk("3 write \n");
+	buf[0] = 0x82;
+	buf[1] = 0x04;
+	buf[2] = 0x0a;
+	buf[3] = 0x0f;
+	ret = usb_bulk_msg(dev, usb_sndbulkpipe(dev, NEXIO_OUTPUT_EP), buf, 4,
+			   &actual_len, NEXIO_TIMEOUT);
+	if (ret < 0)
+		goto err_out;
+	/* read it back */
+	printk("4 read\n");
+	ret = usb_bulk_msg(dev, usb_rcvbulkpipe(dev, NEXIO_INPUT_EP), buf,
+			  NEXIO_BUFSIZE, &actual_len, NEXIO_TIMEOUT);
+	if (ret < 0)
+		goto err_out;
+	/* read firmware version */
+	printk("5 read\n");
+	ret = usb_bulk_msg(dev, usb_rcvbulkpipe(dev, 0x82), buf, NEXIO_BUFSIZE,
+			   &actual_len, NEXIO_TIMEOUT);
+	if (ret < 0)
+		goto err_out;
+	buf[buf[1]] = 0;
+	printk("Firmware version %s\n", &buf[2]);
+	/* read device name */
+	printk("6 read\n");
+	ret = usb_bulk_msg(dev, usb_rcvbulkpipe(dev, 0x82), buf, NEXIO_BUFSIZE,
+			   &actual_len, NEXIO_TIMEOUT);
+	if (ret < 0)
+		goto err_out;
+	buf[buf[1]] = 0;
+	printk("Device name %s\n", &buf[2]);
+	ret = usb_submit_urb(usbtouch->irq, GFP_KERNEL);
+err_out:
+	kfree(buf);
+err_nobuf:
+	return ret;
+}
+
+static int nexio_read_data(struct usbtouch_usb *usbtouch, unsigned char *pkt)
+{
+	int i, ret, actual_len;
+	unsigned char ack[2] = { 0xaa, 0x02 };
+	struct usb_device *dev = usbtouch->udev;
+
+	printk("nexio_read_data: ");
+	for (i = 0; i < pkt[1]; i++)
+		printk("%02X ", pkt[i]);
+	/* got touch data? */
+	if (pkt[0] & 0xe0 == 0xe0) {
+		for (i = 0; i < NEXIO_PKT_LEN; i++)
+			printk("%02X ", pkt[i]);
+	}
+	return 0;
+}
+#endif
+
 
 /*****************************************************************************
  * the different device descriptors
@@ -702,6 +801,18 @@
 		.read_data	= gotop_read_data,
 	},
 #endif
+
+#ifdef CONFIG_TOUCHSCREEN_USB_NEXIO
+	[DEVTYPE_NEXIO] = {
+		.min_xc		= 0x0,
+		.max_xc		= 0x03ff,
+		.min_yc		= 0x0,
+		.max_yc		= 0x03ff,
+		.rept_size	= 128,
+		.read_data	= nexio_read_data,
+		.init		= nexio_init,
+	},
+#endif
 };
 
 
@@ -814,7 +925,7 @@
 {
 	struct usbtouch_usb *usbtouch = urb->context;
 	int retval;
-
+	printk("usbtouch_irq\n");
 	switch (urb->status) {
 	case 0:
 		/* success */
@@ -841,6 +952,7 @@
 
 exit:
 	retval = usb_submit_urb(urb, GFP_ATOMIC);
+	printk("new submit_urb\n");
 	if (retval)
 		err("%s - usb_submit_urb failed with result: %d",
 		    __func__, retval);
@@ -960,10 +1072,10 @@
 		                     type->max_press, 0, 0);
 
 	usb_fill_int_urb(usbtouch->irq, usbtouch->udev,
-			 usb_rcvintpipe(usbtouch->udev, endpoint->bEndpointAddress),
+			 usb_rcvintpipe(usbtouch->udev, /*endpoint->bEndpointAddress*/0x82),
 			 usbtouch->data, type->rept_size,
-			 usbtouch_irq, usbtouch, endpoint->bInterval);
-
+			 usbtouch_irq, usbtouch, /*endpoint->bInterval*/255);
+	printk("bEndpointAddress: %d, bInterval %d\n", endpoint->bEndpointAddress, endpoint->bInterval);
 	usbtouch->irq->dev = usbtouch->udev;
 	usbtouch->irq->transfer_dma = usbtouch->data_dma;
 	usbtouch->irq->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;



-- 
Ondrej Zary
