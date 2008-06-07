Return-Path: <linux-kernel-owner+w=401wt.eu-S1757894AbYFGCqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894AbYFGCqw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 22:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756849AbYFGCqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 22:46:39 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:33807 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756834AbYFGCqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 22:46:37 -0400
Date: Sat, 7 Jun 2008 03:46:31 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: jkosina@suse.cz
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Input: Add newer Apple keyboards to hid quirks table
Message-ID: <20080607024631.GA24254@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The keyboards in recent Apple hardware are still not properly supported 
by Linux due to them not being in the hid quirks table. This patch adds 
the current hardware. Device IDs come from the Mactel Linux project.

Signed-off-by: Matthew Garrett <mjg@redhat.com>

---

Would be nice to get these in for 2.6.26 if possible - I just spent some 
time trying to work out why my brightness keys didnt work, before 
finally realising that it was just the kernel being awkward.

diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
index 1df832a..5214b0d 100644
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -69,12 +69,19 @@
 #define USB_DEVICE_ID_APPLE_ALU_ANSI	0x0220
 #define USB_DEVICE_ID_APPLE_ALU_ISO	0x0221
 #define USB_DEVICE_ID_APPLE_ALU_JIS	0x0222
+#define USB_DEVICE_ID_APPLE_WELLSPRING_ANSI    0x0223
+#define USB_DEVICE_ID_APPLE_WELLSPRING_ISO     0x0224
+#define USB_DEVICE_ID_APPLE_WELLSPRING_JIS     0x0225
 #define USB_DEVICE_ID_APPLE_GEYSER4_HF_ANSI    0x0229
 #define USB_DEVICE_ID_APPLE_GEYSER4_HF_ISO     0x022a
 #define USB_DEVICE_ID_APPLE_GEYSER4_HF_JIS     0x022b
 #define USB_DEVICE_ID_APPLE_ALU_WIRELESS_ANSI  0x022c
 #define USB_DEVICE_ID_APPLE_ALU_WIRELESS_ISO   0x022d
 #define USB_DEVICE_ID_APPLE_ALU_WIRELESS_JIS   0x022e
+#define USB_DEVICE_ID_APPLE_WELLSPRING2_ANSI   0x0230
+#define USB_DEVICE_ID_APPLE_WELLSPRING2_ISO    0x0231
+#define USB_DEVICE_ID_APPLE_WELLSPRING2_JIS    0x0232
+
 #define USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY	0x030a
 #define USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY	0x030b
 #define USB_DEVICE_ID_APPLE_IRCONTROL4	0x8242
@@ -644,6 +651,12 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_JIS, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN },
 	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },
 	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },
+	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING_ANSI, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN },
+	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING_ISO, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_APPLE_ISO_KEYBOARD },
+	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING_JIS, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN },
+	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING2_ANSI, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN },
+	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING2_ISO, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_APPLE_ISO_KEYBOARD },
+	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING2_JIS, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN },
 
 	{ USB_VENDOR_ID_DELL, USB_DEVICE_ID_DELL_W7658, HID_QUIRK_RESET_LEDS },
 	{ USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_KBD, HID_QUIRK_RESET_LEDS },

-- 
Matthew Garrett | mjg59@srcf.ucam.org
