Return-Path: <linux-kernel-owner+w=401wt.eu-S1764470AbXF1RYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764470AbXF1RYS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 13:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756812AbXF1RYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 13:24:09 -0400
Received: from twin.jikos.cz ([213.151.79.26]:58100 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758220AbXF1RYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 13:24:08 -0400
Date: Thu, 28 Jun 2007 19:24:04 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Antonino Ingargiola <tritemio@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [Possible BUG] Logitech USB keyboard inconsistent led state
In-Reply-To: <5486cca80706280059pabcaa59u7f44440134490590@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706281923230.31463@twin.jikos.cz>
References: <5486cca80706270758x540f75a9vfdd4aa5b6a7d8e4f@mail.gmail.com> 
 <Pine.LNX.4.64.0706272144280.9610@twin.jikos.cz>
 <5486cca80706280059pabcaa59u7f44440134490590@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2007, Antonino Ingargiola wrote:

> $ cat /sys/bus/usb/devices/1-1.2/idVendor
> 046d
> $ cat /sys/bus/usb/devices/1-1.2/idProduct
> c311

Please try the patch below (against any post-2.6.22-rc1 kernel)

diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
index f6c4145..adc3752 100644
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -196,6 +196,7 @@
 #define USB_VENDOR_ID_LOGITECH		0x046d
 #define USB_DEVICE_ID_LOGITECH_RECEIVER	0xc101
 #define USB_DEVICE_ID_LOGITECH_WHEEL	0xc294
+#define USB_DEVICE_ID_LOGITECH_KBD	0xc311
 #define USB_DEVICE_ID_S510_RECEIVER	0xc50c
 #define USB_DEVICE_ID_S510_RECEIVER_2	0xc517
 #define USB_DEVICE_ID_MX3000_RECEIVER	0xc513
@@ -448,6 +449,7 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY, HID_QUIRK_POWERBOOK_HAS_FN | HID_QUIRK_IGNORE_MOUSE },
 
 	{ USB_VENDOR_ID_DELL, USB_DEVICE_ID_DELL_W7658, HID_QUIRK_RESET_LEDS },
+	{ USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_KBD, HID_QUIRK_RESET_LEDS },
 
 	{ USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_BARCODE_1, HID_QUIRK_SWAPPED_MIN_MAX },
 	{ USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_BARCODE_2, HID_QUIRK_SWAPPED_MIN_MAX },

-- 
Jiri Kosina
