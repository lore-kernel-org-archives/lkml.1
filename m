Return-Path: <linux-kernel-owner+w=401wt.eu-S1755795AbYKETHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795AbYKETHZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 14:07:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753231AbYKETHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 14:07:13 -0500
Received: from cerberus.snarc.org ([212.85.155.21]:44188 "EHLO
	cerberus.snarc.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbYKETHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 14:07:12 -0500
X-Greylist: delayed 584 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Nov 2008 14:07:11 EST
Date: Wed, 5 Nov 2008 19:01:43 +0000
From: Vincent Hanquez <tab@snarc.org>
To: Jiri Kosina <jkosina@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] hid update for macbook brick fn key
Message-ID: <20081105190143.GA4529@snarc.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Email may contain unsmilyfied humor and/or satire.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri and LKML,

The following patch add support for late 2008 macbook (apparently
codename 'brick') keyboard that was missing the fn key behavior.

I only have and tested the _ISO flavor, but i've added ANSI (usa) and
RIS (japan) keyboard ids too, by following the same order as all previous
apple keyboard quirks.

-----

add HID support for fn key on late2008 macbook.

Signed-off-by: Vincent Hanquez <tab@snarc.org>

diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index c6ab4ba..d7c6a4c 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -418,6 +418,12 @@ static const struct hid_device_id apple_devices[] = {
 		.driver_data = APPLE_HAS_FN | APPLE_ISO_KEYBOARD },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING2_JIS),
 		.driver_data = APPLE_HAS_FN | APPLE_RDESC_JIS },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_BRICK_ANSI),
+		.driver_data = APPLE_HAS_FN },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_BRICK_ISO),
+		.driver_data = APPLE_HAS_FN | APPLE_ISO_KEYBOARD },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_BRICK_JIS),
+		.driver_data = APPLE_HAS_FN | APPLE_RDESC_JIS },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY),
 		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY),
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 1903e75..9e58950 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1250,6 +1250,9 @@ static const struct hid_device_id hid_blacklist[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING2_ANSI) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING2_ISO) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING2_JIS) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_BRICK_ANSI) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_BRICK_ISO) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_BRICK_JIS) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_AVERMEDIA, USB_DEVICE_ID_AVER_FM_MR800) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 5cc4042..98b090e 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -82,6 +82,9 @@
 #define USB_DEVICE_ID_APPLE_WELLSPRING2_ANSI	0x0230
 #define USB_DEVICE_ID_APPLE_WELLSPRING2_ISO	0x0231
 #define USB_DEVICE_ID_APPLE_WELLSPRING2_JIS	0x0232
+#define USB_DEVICE_ID_APPLE_BRICK_ANSI		0x0236
+#define USB_DEVICE_ID_APPLE_BRICK_ISO		0x0237
+#define USB_DEVICE_ID_APPLE_BRICK_JIS		0x0238
 #define USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY	0x030a
 #define USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY	0x030b
 #define USB_DEVICE_ID_APPLE_ATV_IRCONTROL	0x8241
