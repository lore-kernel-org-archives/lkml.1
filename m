Return-Path: <linux-kernel-owner+w=401wt.eu-S1755068Ab0AFB2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab0AFB2w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 20:28:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755162Ab0AFB2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 20:28:50 -0500
Received: from isepic.quincunx.at ([173.45.232.79]:40848 "EHLO
	isepic.quincunx.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754931Ab0AFB2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 20:28:49 -0500
X-Greylist: delayed 607 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Jan 2010 20:28:49 EST
From: Christian Schuerer <csw@xray.at>
To: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] linux-2.6.33-rc2 - Re: Device IDs for new Apple Wireless Keyboard
Date: Wed, 6 Jan 2010 02:16:47 +0100
User-Agent: KMail/1.13.0 (Linux/2.6.31-17-generic; KDE/4.3.85; x86_64; ; )
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-input@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
References: <4B38AFDE.8000203@gmail.com> <alpine.LNX.2.00.1001041155560.2277@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1001041155560.2277@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001060216.47958.csw@xray.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 January 2010 11:57:33 Jiri Kosina wrote:
> On Mon, 28 Dec 2009, Jiri Slaby wrote:
> > Hi, I added some proper CCs. For me they look good. Care to add
> > signed-off-by line? Thanks.
> thanks for the patch. Could you please make the following two updates to
> it, and send it to me, so that I could merge it? Thanks.
> 
> - add a proper Signed-off-by: line, as described in
>   Documentation/SubmittingPatches
> - keep the list of Apple IDs ordered by the product number

Jiri,

here is the patch for linux-2.6.33-rc2:

Changes:

Added device IDs for the new model of the Apple Wireless Keyboard (November 
2009).

Signed-off-by: Christian Schuerer-Waldheim <csw@xray.at>

diff -uprN -X linux-2.6.33-rc2-vanilla/Documentation/dontdiff linux-2.6.33-
rc2-vanilla/drivers/hid/hid-apple.c linux-2.6.33-rc2-apple/drivers/hid/hid-
apple.c
--- linux-2.6.33-rc2-vanilla/drivers/hid/hid-apple.c	2009-12-24 
22:09:41.000000000 +0100
+++ linux-2.6.33-rc2-apple/drivers/hid/hid-apple.c	2010-01-06 
01:39:29.000000000 +0100
@@ -431,6 +431,13 @@ static const struct hid_device_id apple_
 		.driver_data = APPLE_HAS_FN | APPLE_ISO_KEYBOARD },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, 
USB_DEVICE_ID_APPLE_WELLSPRING3_JIS),
 		.driver_data = APPLE_HAS_FN | APPLE_RDESC_JIS },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, 
USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ANSI),
+		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, 
USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ISO),
+		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN |
+			APPLE_ISO_KEYBOARD },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, 
USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_JIS),
+		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, 
USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY),
 		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, 
USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY),
diff -uprN -X linux-2.6.33-rc2-vanilla/Documentation/dontdiff linux-2.6.33-
rc2-vanilla/drivers/hid/hid-core.c linux-2.6.33-rc2-apple/drivers/hid/hid-
core.c
--- linux-2.6.33-rc2-vanilla/drivers/hid/hid-core.c	2009-12-24 
22:09:41.000000000 +0100
+++ linux-2.6.33-rc2-apple/drivers/hid/hid-core.c	2010-01-06 01:41:21.000000000 
+0100
@@ -1285,6 +1285,9 @@ static const struct hid_device_id hid_bl
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, 
USB_DEVICE_ID_APPLE_WELLSPRING3_ANSI) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING3_ISO) 
},
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING3_JIS) 
},
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, 
USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ANSI) },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, 
USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ISO) },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, 
USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_JIS) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, 
USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY) 
},
 	{ HID_USB_DEVICE(USB_VENDOR_ID_BELKIN, USB_DEVICE_ID_FLIP_KVM) },
diff -uprN -X linux-2.6.33-rc2-vanilla/Documentation/dontdiff linux-2.6.33-
rc2-vanilla/drivers/hid/hid-ids.h linux-2.6.33-rc2-apple/drivers/hid/hid-ids.h
--- linux-2.6.33-rc2-vanilla/drivers/hid/hid-ids.h	2009-12-24 
22:09:41.000000000 +0100
+++ linux-2.6.33-rc2-apple/drivers/hid/hid-ids.h	2010-01-06 01:42:30.000000000 
+0100
@@ -88,6 +88,9 @@
 #define USB_DEVICE_ID_APPLE_WELLSPRING3_ANSI	0x0236
 #define USB_DEVICE_ID_APPLE_WELLSPRING3_ISO	0x0237
 #define USB_DEVICE_ID_APPLE_WELLSPRING3_JIS	0x0238
+#define USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ANSI  0x0239
+#define USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ISO   0x023a
+#define USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_JIS   0x023b
 #define USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY	0x030a
 #define USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY	0x030b
 #define USB_DEVICE_ID_APPLE_ATV_IRCONTROL	0x8241
