Return-Path: <linux-kernel-owner+w=401wt.eu-S1754301AbYGMGrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301AbYGMGrT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 02:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbYGMGrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 02:47:11 -0400
Received: from imsc1.euromail.se ([217.174.79.93]:35048 "HELO
	garland.euromail.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752342AbYGMGrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 02:47:10 -0400
Subject: [PATCH] input: wellspring device quirks
From: Henrik Rydberg <rydberg@euromail.se>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       dmitry.torokhov@gmail.com, robfitz@273k.net, akpm@osdl.org,
       jikos@jikos.cz, vojtech@suse.cz, dmonakhov@openvz.org
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Date: Sun, 13 Jul 2008 08:47:02 +0200
Message-Id: <1215931622.15888.0.camel@alnilam>
Mime-Version: 1.0
X-OriginalArrivalTime: 13 Jul 2008 06:46:56.0353 (UTC) FILETIME=[3DE20D10:01C8E4B4]
X-NAI-Spam-Score: 0
X-NAI-Spam-Report: 3 Rules triggered
	*  0 -- HAS_X_HELO -- Mail contains HAS_X-HELO header
	*  0 -- RV3058 -- BODY: Version number
	*  0 -- XH_GE5 -- Mail contains X-HELO header
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sat, 12 Jul 2008 18:15:15 +0200
Message-Id: <1215879315.13937.0.camel@alnilam>

From: Henrik Rydberg <rydberg@euromail.se>

This patch adds usbhid-quirks for the Apple USB multitouch devices
based on BCM5974, aka Wellspring. Quirks for these devices have already
been submitted by others; this patch adds the HID_QUIRK_IGNORE_MOUSE,
anticipating the trackpad to be picked up by the bcm5974 driver.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---

diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
index 1df832a..4dd11f4 100644
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -75,6 +75,12 @@
 #define USB_DEVICE_ID_APPLE_ALU_WIRELESS_ANSI  0x022c
 #define USB_DEVICE_ID_APPLE_ALU_WIRELESS_ISO   0x022d
 #define USB_DEVICE_ID_APPLE_ALU_WIRELESS_JIS   0x022e
+#define USB_DEVICE_ID_APPLE_WELLSPRING_ANSI    0x0223
+#define USB_DEVICE_ID_APPLE_WELLSPRING_ISO     0x0224
+#define USB_DEVICE_ID_APPLE_WELLSPRING_JIS     0x0225
+#define USB_DEVICE_ID_APPLE_WELLSPRING2_ANSI   0x0230
+#define USB_DEVICE_ID_APPLE_WELLSPRING2_ISO    0x0231
+#define USB_DEVICE_ID_APPLE_WELLSPRING2_JIS    0x0232
 #define USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY	0x030a
 #define USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY	0x030b
 #define USB_DEVICE_ID_APPLE_IRCONTROL4	0x8242
@@ -642,6 +648,12 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_ANSI, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN },
 	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_ISO, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_APPLE_ISO_KEYBOARD },
 	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_JIS, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN },
+	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING_ANSI, HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },
+	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING_ISO, HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_APPLE_ISO_KEYBOARD | HID_QUIRK_IGNORE_MOUSE},
+	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING_JIS, HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE},
+	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING2_ANSI, HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE},
+	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING2_ISO, HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_APPLE_ISO_KEYBOARD | HID_QUIRK_IGNORE_MOUSE },
+	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING2_JIS, HID_QUIRK_APPLE_HAS_FN  | HID_QUIRK_IGNORE_MOUSE },
 	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },
 	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },



