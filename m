Return-Path: <linux-kernel-owner+w=401wt.eu-S1757456AbYE2Wq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757456AbYE2Wq6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 18:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753613AbYE2Wqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 18:46:48 -0400
Received: from tesla.comm.utoronto.ca ([128.100.11.1]:40028 "EHLO
	tesla.comm.toronto.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508AbYE2Wqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 18:46:48 -0400
Message-ID: <36765.142.151.170.214.1212101197.squirrel@webmail.comm.utoronto.ca>
Date: Thu, 29 May 2008 18:46:37 -0400 (EDT)
Subject: [PATCH] usbhid: Fix fn key on Macbook Pro 4,1 and Macbook Air 
From: alexander@comm.utoronto.ca
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.9a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added device ids to hid-quriks for detection of keyboards on 4th generation Macbook Pro and Macbook Air

Signed-off-by: Alexandre Karpenko <alexander@comm.utoronto.ca>
---
The naming scheme is consistent with past Apple keyboards in hid-quirks; as defined by Apple (including device ids) in:
/System/Library/Extensions/AppleUSBTopCase.kext/Contents/PlugIns/AppleUSBTCKeyboard.kext/Contents/Info.plist
Patch was originally posted and tested at:
https://bugs.launchpad.net/mactel-support/+bug/207127

--- linux-source-2.6.24/drivers/hid/usbhid/hid-quirks.c.orig	2008-05-29 17:50:42.000000000 -0400
+++ linux-source-2.6.24/drivers/hid/usbhid/hid-quirks.c	2008-05-19 19:59:19.000000000 -0400
@@ -68,6 +68,12 @@
 #define USB_DEVICE_ID_APPLE_ALU_WIRELESS_ANSI  0x022c
 #define USB_DEVICE_ID_APPLE_ALU_WIRELESS_ISO   0x022d
 #define USB_DEVICE_ID_APPLE_ALU_WIRELESS_JIS   0x022e
+#define USB_DEVICE_ID_APPLE_WELLSPRING_ANSI   0x0223
+#define USB_DEVICE_ID_APPLE_WELLSPRING_ISO    0x0224
+#define USB_DEVICE_ID_APPLE_WELLSPRING_JIS    0x0225
+#define USB_DEVICE_ID_APPLE_WELLSPRING2_ANSI   0x0230
+#define USB_DEVICE_ID_APPLE_WELLSPRING2_ISO    0x0231
+#define USB_DEVICE_ID_APPLE_WELLSPRING2_JIS    0x0232
 #define USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY	0x030a
 #define USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY	0x030b
 #define USB_DEVICE_ID_APPLE_IRCONTROL4	0x8242
@@ -572,6 +578,12 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_ANSI, HID_QUIRK_APPLE_HAS_FN },
 	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_ISO, HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_APPLE_ISO_KEYBOARD },
 	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_JIS, HID_QUIRK_APPLE_HAS_FN },
+	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING_ANSI, HID_QUIRK_APPLE_HAS_FN },
+	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING_ISO, HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_APPLE_ISO_KEYBOARD },
+	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING_JIS, HID_QUIRK_APPLE_HAS_FN },
+	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING2_ANSI, HID_QUIRK_APPLE_HAS_FN },
+	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING2_ISO, HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_APPLE_ISO_KEYBOARD },
+	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING2_JIS, HID_QUIRK_APPLE_HAS_FN },
 	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY, HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },
 	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY, HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },


