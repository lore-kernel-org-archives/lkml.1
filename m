Return-Path: <linux-kernel-owner+w=401wt.eu-S1754849AbZCEHLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbZCEHLR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 02:11:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751933AbZCEHLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 02:11:04 -0500
Received: from feh.colobox.com ([209.177.154.210]:59613 "HELO feh.colobox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751920AbZCEHLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 02:11:03 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Mar 2009 02:11:03 EST
Date: 4 Mar 2009 23:04:19 -0800
Message-ID: <20090305070419.6175.qmail@feh.colobox.com>
From: "Ryan Finnie" <ryan@finnie.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] HID: Support Apple mini aluminum keyboard
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ryan Finnie <ryan@finnie.org>

New USB device ids and quirks for the "mini" Apple USB aluminum 
keyboards released Tuesday, model A1242.  Note that while I own the ANSI 
(0x021d) version and cannot verify that the ISO (0x021e) and JIS 
(0x021f) versions exist, previous releases have followed the triple id 
convention for awhile now, and the device ids fit perfectly between 
USB_DEVICE_ID_APPLE_GEYSER4_* and USB_DEVICE_ID_APPLE_ALU_*.

Aside: Considering the device ids for the mini aluminum come before the 
ids for the regular aluminum, and the model for the mini is A1242 while 
the regular is A1243, it appears the mini aluminum keyboard may have 
been developed before the regular, but delayed a few years.

Signed-off-by: Ryan Finnie <ryan@finnie.org>
---
 hid-apple.c |    6 ++++++
 hid-core.c  |    3 +++
 hid-ids.h   |    3 +++
 3 files changed, 12 insertions(+)
diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index aa28aed..7ed94cf 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -387,6 +387,12 @@ static const struct hid_device_id apple_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_JIS),
 		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN |
 			APPLE_RDESC_JIS },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_MINI_ANSI),
+		.driver_data = APPLE_HAS_FN },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_MINI_ISO),
+		.driver_data = APPLE_HAS_FN | APPLE_ISO_KEYBOARD },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_MINI_JIS),
+		.driver_data = APPLE_HAS_FN },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_ANSI),
 		.driver_data = APPLE_HAS_FN },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_ISO),
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 1cc9674..0e7e7f2 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1236,6 +1236,9 @@ static const struct hid_device_id hid_blacklist[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_ANSI) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_ISO) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_JIS) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_MINI_ANSI) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_MINI_ISO) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_MINI_JIS) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_ANSI) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_ISO) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_JIS) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 8851197..447a8e1 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -67,6 +67,9 @@
 #define USB_DEVICE_ID_APPLE_GEYSER4_ANSI	0x021a
 #define USB_DEVICE_ID_APPLE_GEYSER4_ISO	0x021b
 #define USB_DEVICE_ID_APPLE_GEYSER4_JIS	0x021c
+#define USB_DEVICE_ID_APPLE_ALU_MINI_ANSI	0x021d
+#define USB_DEVICE_ID_APPLE_ALU_MINI_ISO	0x021e
+#define USB_DEVICE_ID_APPLE_ALU_MINI_JIS	0x021f
 #define USB_DEVICE_ID_APPLE_ALU_ANSI	0x0220
 #define USB_DEVICE_ID_APPLE_ALU_ISO	0x0221
 #define USB_DEVICE_ID_APPLE_ALU_JIS	0x0222
