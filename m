Return-Path: <linux-kernel-owner+w=401wt.eu-S1755850Ab0AFM52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850Ab0AFM52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 07:57:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755835Ab0AFM51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 07:57:27 -0500
Received: from isepic.quincunx.at ([173.45.232.79]:38222 "EHLO
	isepic.quincunx.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755785Ab0AFM50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 07:57:26 -0500
From: Christian Schuerer <csw@xray.at>
To: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] linux-2.6.31.9, linux-2.6.32.2, linux-2.6.33-rc2 -- Re: Device IDs for new Apple Wireless Keyboard
Date: Wed, 6 Jan 2010 13:57:22 +0100
User-Agent: KMail/1.13.0 (Linux/2.6.31-17-generic; KDE/4.3.85; x86_64; ; )
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-input@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
References: <4B38AFDE.8000203@gmail.com> <201001060216.47958.csw@xray.at> <alpine.LNX.2.00.1001061113060.2277@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1001061113060.2277@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_yiIRLq5rT3O1x54"
Message-Id: <201001061357.22447.csw@xray.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_yiIRLq5rT3O1x54
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

Hello Jiri,

On Wednesday 06 January 2010 11:14:38 Jiri Kosina wrote:
> On Wed, 6 Jan 2010, Christian Schuerer wrote:
> > here is the patch for linux-2.6.33-rc2:
> > Thanks. Unfortunately, it's wordwrapped, so it can't be easily applied.
> Could you please fix up your e-mail client so that it doesn't mangle long
> lines, or eventually send is as an attachment?

I'm sorry, I have attached all three patches as text files.

> > Added device IDs for the new model of the Apple Wireless Keyboard
> > (November 2009).
> These are solely Bluetooth device, and there is no USB variant, right?

As far as I know of only a new variant of the wireless (bluetooth) keyboard 
has been released in November 2009.

Greetings,
Christian

--Boundary-00=_yiIRLq5rT3O1x54
Content-Type: text/plain;
  charset="UTF-8";
  name="patch-2.6.31.9"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="patch-2.6.31.9"

Added device IDs for the new model of the Apple Wireless Keyboard (November 2009).

Signed-off-by: Christian Schuerer-Waldheim <csw@xray.at>

diff -uprN -X linux-2.6.31.9-vanilla/Documentation/dontdiff linux-2.6.31.9-vanilla/drivers/hid/hid-apple.c linux-2.6.31.9-apple/drivers/hid/hid-apple.c
--- linux-2.6.31.9-vanilla/drivers/hid/hid-apple.c	2009-12-18 22:47:01.000000000 +0100
+++ linux-2.6.31.9-apple/drivers/hid/hid-apple.c	2010-01-06 01:39:33.000000000 +0100
@@ -431,6 +431,13 @@ static const struct hid_device_id apple_
 		.driver_data = APPLE_HAS_FN | APPLE_ISO_KEYBOARD },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING3_JIS),
 		.driver_data = APPLE_HAS_FN | APPLE_RDESC_JIS },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ANSI),
+		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ISO),
+		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN |
+			APPLE_ISO_KEYBOARD },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_JIS),
+		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY),
 		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY),
diff -uprN -X linux-2.6.31.9-vanilla/Documentation/dontdiff linux-2.6.31.9-vanilla/drivers/hid/hid-core.c linux-2.6.31.9-apple/drivers/hid/hid-core.c
--- linux-2.6.31.9-vanilla/drivers/hid/hid-core.c	2009-12-18 22:47:01.000000000 +0100
+++ linux-2.6.31.9-apple/drivers/hid/hid-core.c	2010-01-06 01:40:39.000000000 +0100
@@ -1259,6 +1259,9 @@ static const struct hid_device_id hid_bl
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING3_ANSI) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING3_ISO) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING3_JIS) },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ANSI) },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ISO) },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_JIS) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_BELKIN, USB_DEVICE_ID_FLIP_KVM) },
diff -uprN -X linux-2.6.31.9-vanilla/Documentation/dontdiff linux-2.6.31.9-vanilla/drivers/hid/hid-ids.h linux-2.6.31.9-apple/drivers/hid/hid-ids.h
--- linux-2.6.31.9-vanilla/drivers/hid/hid-ids.h	2009-12-18 22:47:01.000000000 +0100
+++ linux-2.6.31.9-apple/drivers/hid/hid-ids.h	2010-01-06 01:41:51.000000000 +0100
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

--Boundary-00=_yiIRLq5rT3O1x54
Content-Type: text/plain;
  charset="UTF-8";
  name="patch-2.6.32.2"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="patch-2.6.32.2"

Added device IDs for the new model of the Apple Wireless Keyboard (November 2009).

Signed-off-by: Christian Schuerer-Waldheim <csw@xray.at>

diff -uprN -X linux-2.6.32.2-vanilla/Documentation/dontdiff linux-2.6.32.2-vanilla/drivers/hid/hid-apple.c linux-2.6.32.2-apple/drivers/hid/hid-apple.c
--- linux-2.6.32.2-vanilla/drivers/hid/hid-apple.c	2009-12-18 23:27:07.000000000 +0100
+++ linux-2.6.32.2-apple/drivers/hid/hid-apple.c	2010-01-06 01:39:31.000000000 +0100
@@ -431,6 +431,13 @@ static const struct hid_device_id apple_
 		.driver_data = APPLE_HAS_FN | APPLE_ISO_KEYBOARD },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING3_JIS),
 		.driver_data = APPLE_HAS_FN | APPLE_RDESC_JIS },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ANSI),
+		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ISO),
+		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN |
+			APPLE_ISO_KEYBOARD },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_JIS),
+		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY),
 		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY),
diff -uprN -X linux-2.6.32.2-vanilla/Documentation/dontdiff linux-2.6.32.2-vanilla/drivers/hid/hid-core.c linux-2.6.32.2-apple/drivers/hid/hid-core.c
--- linux-2.6.32.2-vanilla/drivers/hid/hid-core.c	2009-12-18 23:27:07.000000000 +0100
+++ linux-2.6.32.2-apple/drivers/hid/hid-core.c	2010-01-06 01:41:01.000000000 +0100
@@ -1287,6 +1287,9 @@ static const struct hid_device_id hid_bl
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING3_ANSI) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING3_ISO) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING3_JIS) },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ANSI) },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ISO) },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_JIS) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_BELKIN, USB_DEVICE_ID_FLIP_KVM) },
diff -uprN -X linux-2.6.32.2-vanilla/Documentation/dontdiff linux-2.6.32.2-vanilla/drivers/hid/hid-ids.h linux-2.6.32.2-apple/drivers/hid/hid-ids.h
--- linux-2.6.32.2-vanilla/drivers/hid/hid-ids.h	2009-12-18 23:27:07.000000000 +0100
+++ linux-2.6.32.2-apple/drivers/hid/hid-ids.h	2010-01-06 01:42:02.000000000 +0100
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

--Boundary-00=_yiIRLq5rT3O1x54
Content-Type: text/plain;
  charset="UTF-8";
  name="patch-2.6.33-rc2"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="patch-2.6.33-rc2"

Added device IDs for the new model of the Apple Wireless Keyboard (November 2009).

Signed-off-by: Christian Schuerer-Waldheim <csw@xray.at>

diff -uprN -X linux-2.6.33-rc2-vanilla/Documentation/dontdiff linux-2.6.33-rc2-vanilla/drivers/hid/hid-apple.c linux-2.6.33-rc2-apple/drivers/hid/hid-apple.c
--- linux-2.6.33-rc2-vanilla/drivers/hid/hid-apple.c	2009-12-24 22:09:41.000000000 +0100
+++ linux-2.6.33-rc2-apple/drivers/hid/hid-apple.c	2010-01-06 01:39:29.000000000 +0100
@@ -431,6 +431,13 @@ static const struct hid_device_id apple_
 		.driver_data = APPLE_HAS_FN | APPLE_ISO_KEYBOARD },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING3_JIS),
 		.driver_data = APPLE_HAS_FN | APPLE_RDESC_JIS },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ANSI),
+		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ISO),
+		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN |
+			APPLE_ISO_KEYBOARD },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_JIS),
+		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY),
 		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY),
diff -uprN -X linux-2.6.33-rc2-vanilla/Documentation/dontdiff linux-2.6.33-rc2-vanilla/drivers/hid/hid-core.c linux-2.6.33-rc2-apple/drivers/hid/hid-core.c
--- linux-2.6.33-rc2-vanilla/drivers/hid/hid-core.c	2009-12-24 22:09:41.000000000 +0100
+++ linux-2.6.33-rc2-apple/drivers/hid/hid-core.c	2010-01-06 01:41:21.000000000 +0100
@@ -1285,6 +1285,9 @@ static const struct hid_device_id hid_bl
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING3_ANSI) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING3_ISO) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING3_JIS) },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ANSI) },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ISO) },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_JIS) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_BELKIN, USB_DEVICE_ID_FLIP_KVM) },
diff -uprN -X linux-2.6.33-rc2-vanilla/Documentation/dontdiff linux-2.6.33-rc2-vanilla/drivers/hid/hid-ids.h linux-2.6.33-rc2-apple/drivers/hid/hid-ids.h
--- linux-2.6.33-rc2-vanilla/drivers/hid/hid-ids.h	2009-12-24 22:09:41.000000000 +0100
+++ linux-2.6.33-rc2-apple/drivers/hid/hid-ids.h	2010-01-06 01:42:30.000000000 +0100
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

--Boundary-00=_yiIRLq5rT3O1x54--
