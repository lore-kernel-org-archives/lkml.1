Return-Path: <linux-kernel-owner+w=401wt.eu-S1764303AbXLNKH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764303AbXLNKH1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 05:07:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757520AbXLNKHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 05:07:18 -0500
Received: from fb1.tech.numericable.fr ([82.216.111.51]:56869 "EHLO
	fb1.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbXLNKHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 05:07:15 -0500
Subject: [PATCH] usb/hid: Blacklist the Gretag-Macbeth Huey display
	colorimeter
From: Nicolas Mailhot <nicolas.mailhot@laposte.net>
To: jkosina@suse.cz
Cc: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, argyllcms@freelists.org,
       Frederic Crozat <fcrozat@mandriva.com>, Greg KH <greg@kroah.com>
In-Reply-To: <20071214053853.GD7765@kroah.com>
References: <1197585460.28927.2.camel@rousalka.dyndns.org>
	 <20071214053853.GD7765@kroah.com>
Content-Type: text/plain; charset=UTF-8
Organization: Perso
Date: Fri, 14 Dec 2007 11:04:56 +0100
Message-Id: <1197626696.5281.5.camel@rousalka.dyndns.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.3 (2.21.3-4.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le jeudi 13 décembre 2007 à 21:38 -0800, Greg KH a écrit : 
> On Thu, Dec 13, 2007 at 11:37:40PM +0100, Nicolas Mailhot wrote:

> > The Gretag-Macbeth Huey display colorimeter claims to be an HID device
> > but isn't. As a result the linux HID device will claim it, preventing
> > FLOSS software like Argyll CMS (http://www.argyllcms.com/) from talking
> > to it,

> > Frédéric Crozat from Mandriva has such a device and may provide more
> > info.

> Care to make up a patch as per the Documentation/SubmittingPatches file
> and send it to this list and the HID driver maintainer?  That way you
> get the proper credit for this change.

The things I do as a public service, I don't even have the damn Huey
myself:(

There seems to be some complains about libusb BTW
(http://www.freelists.org/archives/argyllcms/12-2007/msg00068.html)


Signed-off-by: Nicolas Mailhot <nicolas.mailhot@laposte.net>

diff -uNr linux-2.6.24-rc5.orig/drivers/hid/usbhid/hid-quirks.c linux-2.6.24-rc5/drivers/hid/usbhid/hid-quirks.c
--- linux-2.6.24-rc5.orig/drivers/hid/usbhid/hid-quirks.c	2007-12-11 04:48:43.000000000 +0100
+++ linux-2.6.24-rc5/drivers/hid/usbhid/hid-quirks.c	2007-12-14 10:41:01.000000000 +0100
@@ -85,6 +85,9 @@
 #define USB_VENDOR_ID_CHIC		0x05fe
 #define USB_DEVICE_ID_CHIC_GAMEPAD	0x0014
 
+#define USB_VENDOR_ID_GRETAGMACBETH	0x0971
+#define USB_DEVICE_ID_GRETAGMACBETH_HUEY	0x2005
+
 #define USB_VENDOR_ID_CIDC		0x1677
 
 #define USB_VENDOR_ID_CMEDIA		0x0d8c
@@ -423,6 +426,7 @@
 	{ USB_VENDOR_ID_GOTOP, USB_DEVICE_ID_SUPER_Q2, HID_QUIRK_IGNORE },
 	{ USB_VENDOR_ID_GOTOP, USB_DEVICE_ID_GOGOPEN, HID_QUIRK_IGNORE },
 	{ USB_VENDOR_ID_GOTOP, USB_DEVICE_ID_PENPOWER, HID_QUIRK_IGNORE },
+	{ USB_VENDOR_ID_GRETAGMACBETH, USB_DEVICE_ID_GRETAGMACBETH_HUEY, HID_QUIRK_IGNORE },
 	{ USB_VENDOR_ID_GRIFFIN, USB_DEVICE_ID_POWERMATE, HID_QUIRK_IGNORE },
 	{ USB_VENDOR_ID_GRIFFIN, USB_DEVICE_ID_SOUNDKNOB, HID_QUIRK_IGNORE },

-- 
Nicolas Mailhot

