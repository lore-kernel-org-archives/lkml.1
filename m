Return-Path: <linux-kernel-owner+w=401wt.eu-S936054AbXGZW2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936054AbXGZW2H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 18:28:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932115AbXGZW14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 18:27:56 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44327 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765532AbXGZW1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 18:27:55 -0400
Date: Thu, 26 Jul 2007 15:27:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christian Lamparter <chunkeey@web.de>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net,
       linux-input@atrey.karlin.mff.cuni.cz
Subject: Re: [PATCH] usbhid: add ASUS LCM to the blacklist
Message-Id: <20070726152709.6daa1c96.akpm@linux-foundation.org>
In-Reply-To: <200707240228.39421.chunkeey@web.de>
References: <200707240228.39421.chunkeey@web.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jul 2007 02:28:39 +0200 Christian Lamparter <chunkeey@web.de> wrote:

> Some of ASUS' notebooks (e.g G Series) include a tiny oled display, which is 
> attached to an internal USB bus. Unfortunatly the device reports a wrong
> DeviceDescriptor and is therefore identified as a HID device...
> 
> Signed-off-by: Christian Lamparter <chunkeey@web.de>
> CC: linux-input@atrey.karlin.mff.cuni.cz
> CC: linux-usb-devel@lists.sourceforge.net
> 
> ---
> (keep the cc!)
> for those who are interested in the userspace display driver:
> https://launchpad.net/asusoled  
> 
> 
> 
> [asus-lcm-hid-blacklist.diff  text/x-diff (865B)]
> diff -up drivers/hid/usbhid/hid-quirks.c.orig drivers/hid/usbhid/hid-quirks.c
> --- a/drivers/hid/usbhid/hid-quirks.c.orig	2007-07-24 02:23:36.000000000 +0200
> +++ b/drivers/hid/usbhid/hid-quirks.c	2007-07-24 02:25:26.000000000 +0200
> @@ -63,6 +63,9 @@
>  #define USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY	0x030b
>  #define USB_DEVICE_ID_APPLE_IR		0x8240
>  
> +#define USB_VENDOR_ID_ASUS		0x0b05
> +#define USB_DEVICE_ID_ASUS_LCM		0x1726
> +
>  #define USB_VENDOR_ID_ATEN		0x0557
>  #define USB_DEVICE_ID_ATEN_UC100KM	0x2004
>  #define USB_DEVICE_ID_ATEN_CS124U	0x2202
> @@ -452,6 +455,8 @@ static const struct hid_blacklist {
>  	{ USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_BARCODE_1, HID_QUIRK_SWAPPED_MIN_MAX },
>  	{ USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_BARCODE_2, HID_QUIRK_SWAPPED_MIN_MAX },
>  
> +	{ USB_VENDOR_ID_ASUS, USB_DEVICE_ID_ASUS_LCM, HID_QUIRK_IGNORE},
> +
>  	{ 0, 0 }
>  };

diff -p said that the second hnk goes into the hid_blacklist[] array, but
your patch actually places it in the hid_rdesc_blacklist[] array.

I suspect what we have here is a diff against 2.6.22?  Things changed
a lot since then - please prepare patches against the latest kernel you can get
your hands on, thanks.
