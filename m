Return-Path: <linux-kernel-owner+w=401wt.eu-S1754282AbYEPIGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282AbYEPIGZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 04:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751742AbYEPIGB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 04:06:01 -0400
Received: from topsns2.toshiba-tops.co.jp ([202.230.225.126]:58998 "EHLO
	topsns2.toshiba-tops.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750954AbYEPIF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 04:05:58 -0400
Date: Fri, 16 May 2008 17:05:50 +0900 (JST)
Message-Id: <20080516.170550.71879418.nemoto@toshiba-tops.co.jp>
To: akirat@rd.scei.sony.co.jp
Cc: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [PATCH] usb-serial: pl2303: add support for RATOC REX-USB60F
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20080118185231.0B48.4D252088@rd.scei.sony.co.jp>
References: <20080118185231.0B48.4D252088@rd.scei.sony.co.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jan 2008 18:58:28 +0900, Akira Tsukamoto <akirat@rd.scei.sony.co.jp> wrote:
> pl2303: add support for RATOC REX-USB60F
> 
> This patch adds support for RATOC REX-USB60F Serial Adapters,
> which is widely used in Japan recently.
> 
> Signed-off-by: Akira Tsukamoto <akirat@rd.scei.sony.co.jp>
> ---
> 
> diff -uprX dontdiff linux-2.6.24-rc8.orig/drivers/usb/serial/pl2303.c linux-2.6.24-rc8/drivers/usb/serial/pl2303.c
> --- linux-2.6.24-rc8.orig/drivers/usb/serial/pl2303.c	2008-01-18 18:11:51.000000000 +0900
> +++ linux-2.6.24-rc8/drivers/usb/serial/pl2303.c	2008-01-18 18:43:28.000000000 +0900
> @@ -65,6 +65,7 @@ static struct usb_device_id id_table [] 
>  	{ USB_DEVICE(ITEGNO_VENDOR_ID, ITEGNO_PRODUCT_ID_2080) },
>  	{ USB_DEVICE(MA620_VENDOR_ID, MA620_PRODUCT_ID) },
>  	{ USB_DEVICE(RATOC_VENDOR_ID, RATOC_PRODUCT_ID) },
> + 	{ USB_DEVICE(RATOC_VENDOR_ID, RATOC_PRODUCT_ID_USB60F) },
>  	{ USB_DEVICE(TRIPP_VENDOR_ID, TRIPP_PRODUCT_ID) },
>  	{ USB_DEVICE(RADIOSHACK_VENDOR_ID, RADIOSHACK_PRODUCT_ID) },
>  	{ USB_DEVICE(DCU10_VENDOR_ID, DCU10_PRODUCT_ID) },

Hi.  I tried RATOC REX-USB60F with pl2303 driver and got oops in
pl2303_open().  The pl2303 expects a interrupt_in endpoint but my
device does not have interrupt_in.  So this line in pl2303_open()
cause oops.

	port->interrupt_in_urb->dev = serial->dev;

This device works fine with the ftdi_sio driver, with "vendor=0x584
product=0xb020" module option.  (0x584 is RATOC_VENDOR_ID and 0xb020
is RATOC_PRODUCT_ID_USB60F).


Is the pl2303 driver appropriate for this device?

Here is lsusb output:

Bus 001 Device 003: ID 0584:b020 RATOC System, Inc. 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0         8
  idVendor           0x0584 RATOC System, Inc.
  idProduct          0xb020 
  bcdDevice            4.00
  iManufacturer           1 RATOC Systems,Inc.
  iProduct                2 USB-Serial Converter
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           32
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              2 USB-Serial Converter
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
Device Status:     0x0000
  (Bus Powered)



