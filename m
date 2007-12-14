Return-Path: <linux-kernel-owner+w=401wt.eu-S932345AbXLNPxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345AbXLNPxn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 10:53:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754846AbXLNPxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 10:53:35 -0500
Received: from mx1.mandriva.com ([212.85.150.183]:54754 "EHLO mx1.mandriva.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803AbXLNPxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 10:53:33 -0500
X-Greylist: delayed 1521 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Dec 2007 10:53:33 EST
Subject: Re: [PATCH] usb/hid: Blacklist the Gretag-Macbeth Huey display
	colorimeter
From: Frederic Crozat <fcrozat@mandriva.com>
To: Nicolas Mailhot <nicolas.mailhot@laposte.net>
Cc: jkosina@suse.cz, linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, argyllcms@freelists.org,
       Greg KH <greg@kroah.com>
In-Reply-To: <1197626696.5281.5.camel@rousalka.dyndns.org>
References: <1197585460.28927.2.camel@rousalka.dyndns.org>
	 <20071214053853.GD7765@kroah.com>
	 <1197626696.5281.5.camel@rousalka.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-15
Organization: Mandriva
Date: Fri, 14 Dec 2007 16:28:07 +0100
Message-Id: <1197646087.31259.57.camel@trinidad.mandrakesoft.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le vendredi 14 décembre 2007 à 11:04 +0100, Nicolas Mailhot a écrit :
> Le jeudi 13 décembre 2007 à 21:38 -0800, Greg KH a écrit : 
> > On Thu, Dec 13, 2007 at 11:37:40PM +0100, Nicolas Mailhot wrote:
> 
> > > The Gretag-Macbeth Huey display colorimeter claims to be an HID device
> > > but isn't. As a result the linux HID device will claim it, preventing
> > > FLOSS software like Argyll CMS (http://www.argyllcms.com/) from talking
> > > to it,
> 
> > > Frédéric Crozat from Mandriva has such a device and may provide more
> > > info.
> 
> > Care to make up a patch as per the Documentation/SubmittingPatches file
> > and send it to this list and the HID driver maintainer?  That way you
> > get the proper credit for this change.
> 
> The things I do as a public service, I don't even have the damn Huey
> myself:(
> 
> There seems to be some complains about libusb BTW
> (http://www.freelists.org/archives/argyllcms/12-2007/msg00068.html)
> 
> 
> Signed-off-by: Nicolas Mailhot <nicolas.mailhot@laposte.net>
> 
> diff -uNr linux-2.6.24-rc5.orig/drivers/hid/usbhid/hid-quirks.c linux-2.6.24-rc5/drivers/hid/usbhid/hid-quirks.c
> --- linux-2.6.24-rc5.orig/drivers/hid/usbhid/hid-quirks.c	2007-12-11 04:48:43.000000000 +0100
> +++ linux-2.6.24-rc5/drivers/hid/usbhid/hid-quirks.c	2007-12-14 10:41:01.000000000 +0100
> @@ -85,6 +85,9 @@
>  #define USB_VENDOR_ID_CHIC		0x05fe
>  #define USB_DEVICE_ID_CHIC_GAMEPAD	0x0014
>  
> +#define USB_VENDOR_ID_GRETAGMACBETH	0x0971
> +#define USB_DEVICE_ID_GRETAGMACBETH_HUEY	0x2005
> +
>  #define USB_VENDOR_ID_CIDC		0x1677
>  
>  #define USB_VENDOR_ID_CMEDIA		0x0d8c
> @@ -423,6 +426,7 @@
>  	{ USB_VENDOR_ID_GOTOP, USB_DEVICE_ID_SUPER_Q2, HID_QUIRK_IGNORE },
>  	{ USB_VENDOR_ID_GOTOP, USB_DEVICE_ID_GOGOPEN, HID_QUIRK_IGNORE },
>  	{ USB_VENDOR_ID_GOTOP, USB_DEVICE_ID_PENPOWER, HID_QUIRK_IGNORE },
> +	{ USB_VENDOR_ID_GRETAGMACBETH, USB_DEVICE_ID_GRETAGMACBETH_HUEY, HID_QUIRK_IGNORE },
>  	{ USB_VENDOR_ID_GRIFFIN, USB_DEVICE_ID_POWERMATE, HID_QUIRK_IGNORE },
>  	{ USB_VENDOR_ID_GRIFFIN, USB_DEVICE_ID_SOUNDKNOB, HID_QUIRK_IGNORE },

Fixes the issue for me :

Tested-by: Frederic Crozat <fcrozat@mandriva.com>

-- 
Frederic Crozat <fcrozat@mandriva.com>
Mandriva

