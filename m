Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab0BCLBG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 06:01:06 -0500
Received: from cantor.suse.de ([195.135.220.2]:56676 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754624Ab0BCLBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 06:01:00 -0500
Date: Wed, 3 Feb 2010 12:00:58 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Alex Neblett <alexneblett01@yahoo.com>
Cc: Jerome Vidal <jerom3@free.fr>, Cedric Berthier <berthiec@gmail.com>,
       Dmitry Torokhov <dtor@mail.ru>,
       =?ISO-8859-15?Q?St=E9phane_Chatty?= <chatty@enac.fr>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Support Pixart Imaging Inc. Optical Touch Screen in
 Quanta TouchScreen driver
In-Reply-To: <341299.48295.qm@web82001.mail.mud.yahoo.com>
Message-ID: <alpine.LNX.2.00.1002031158470.15395@pobox.suse.cz>
References: <341299.48295.qm@web82001.mail.mud.yahoo.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Feb 2010, Alex Neblett wrote:

> 
> Added support for the Pixart Imaging Inc. Optical Touch Screen found
> in the MSI AE2220 and other new all in one computers to the Quanta
> Optical Touch dual-touch panel driver found in the latest
> git clone 
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git.
> 
> Signed-off-by: Alex Neblett <alexneblett01@yahoo.com>
> 
> 
> diff -uNr linux-next/drivers/hid/.directory linux-next-multitouch/drivers/hid/.directory
> --- linux-next/drivers/hid/.directory    1969-12-31 18:00:00.000000000 -0600
> +++ linux-next-multitouch/drivers/hid/.directory    2010-02-02 22:47:41.875840766 -0600
> @@ -0,0 +1,3 @@
> +[Dolphin]
> +Timestamp=2010,2,2,22,47,41
> +ViewMode=1

Hi Alex,

I guess you don't want this file to be added to the kernel tree, right? :)

> diff -uNr linux-next/drivers/hid/hid-core.c linux-next-multitouch/drivers/hid/hid-core.c
> --- linux-next/drivers/hid/hid-core.c    2010-02-02 22:33:15.479259757 -0600
> +++ linux-next-multitouch/drivers/hid/hid-core.c    2010-02-02 22:44:33.125442262 -0600
> @@ -1343,6 +1343,7 @@
>      { HID_USB_DEVICE(USB_VENDOR_ID_ORTEK, USB_DEVICE_ID_ORTEK_WKB2000) },
>      { HID_USB_DEVICE(USB_VENDOR_ID_PETALYNX, USB_DEVICE_ID_PETALYNX_MAXTER_REMOTE) },
>      { HID_USB_DEVICE(USB_VENDOR_IDhttp://us.mg201.mail.yahoo.com/dc/launch?dgfs=1_QUANTA, USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH) },
> +    { HID_USB_DEVICE(USB_VENDOR_ID_QUANTA, USB_DEVICE_ID_PIXART_IMAGING_INC_OPTICAL_TOUCH_SCREEN) },

Out of curiosity, where did the yahoo.com URL in the patch context come 
from?

>      { HID_USB_DEVICE(USB_VENDOR_ID_SAMSUNG, USB_DEVICE_ID_SAMSUNG_IR_REMOTE) },
>      { HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_PS3_CONTROLLER) },
>      { HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_VAIO_VGX_MOUSE) },
> diff -uNr linux-next/drivers/hid/hid-ids.h linux-next-multitouch/drivers/hid/hid-ids.h
> --- linux-next/drivers/hid/hid-ids.h    2010-02-02 22:33:15.479259757 -0600
> +++ linux-next-multitouch/drivers/hid/hid-ids.h    2010-02-02 22:45:08.318770969 -0600
> @@ -394,6 +394,7 @@
>  
>  #define USB_VENDOR_ID_QUANTA        0x0408
>  #define USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH    0x3000
> +#define USB_DEVICE_ID_PIXART_IMAGING_INC_OPTICAL_TOUCH_SCREEN    0x3001
>  
>  #define USB_VENDOR_ID_SAMSUNG        0x0419
>  #define USB_DEVICE_ID_SAMSUNG_IR_REMOTE    0x0001
> diff -uNr linux-next/drivers/hid/hid-quanta.c linux-next-multitouch/drivers/hid/hid-quanta.c
> --- linux-next/drivers/hid/hid-quanta.c    2010-02-02 22:33:15.482592844 -0600
> +++ linux-next-multitouch/drivers/hid/hid-quanta.c    2010-02-02 22:45:42.482100482 -0600
> @@ -224,6 +224,8 @@
>  static const struct hid_device_id quanta_devices[] = {
>      { HID_USB_DEVICE(USB_VENDOR_ID_QUANTA,
>              USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH) },
> +    { HID_USB_DEVICE(USB_VENDOR_ID_QUANTA,
> +            USB_DEVICE_ID_PIXART_IMAGING_INC_OPTICAL_TOUCH_SCREEN) },
>      { }
>  };
>  MODULE_DEVICE_TABLE(hid, quanta_devices);

Anyway I have fixed the above issues manually and applied your patch, but 
please be aware of this for any submissions in the future.

Thanks!

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
