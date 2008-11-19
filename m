Return-Path: <linux-kernel-owner+w=401wt.eu-S1753944AbYKSOnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbYKSOnt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 09:43:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753392AbYKSOnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 09:43:41 -0500
Received: from stag.SEAS.UPENN.EDU ([158.130.70.79]:39845 "EHLO
	stag.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071AbYKSOnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 09:43:40 -0500
Message-ID: <49242617.7000500@seas.upenn.edu>
Date: Wed, 19 Nov 2008 09:43:35 -0500
From: Rafi Rubin <rafi@seas.upenn.edu>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] n-trig digitizer quirks
References: <Pine.LNX.4.61.0811141207210.12963@minus.seas.upenn.edu> <alpine.LNX.1.10.0811181525490.19853@jikos.suse.cz> <49232910.2030309@seas.upenn.edu> <alpine.LNX.1.10.0811191355280.19853@jikos.suse.cz> <492417D4.4090103@seas.upenn.edu> <alpine.LNX.1.10.0811191451000.19853@jikos.suse.cz> <49241D02.6020602@seas.upenn.edu> <alpine.LNX.1.10.0811191505340.19853@jikos.suse.cz>
In-Reply-To: <alpine.LNX.1.10.0811191505340.19853@jikos.suse.cz>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Added quirks for the N-Trig digitizer.
Signed-off-by: Rafi Rubin <rafi@seas.upenn.edu>
- ---
 drivers/hid/Kconfig     |    7 ++++
 drivers/hid/Makefile    |    1 +
 drivers/hid/hid-core.c  |    1 +
 drivers/hid/hid-dummy.c |    4 +-
 drivers/hid/hid-ids.h   |    3 ++
 drivers/hid/hid-ntrig.c |   82 +++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 96 insertions(+), 2 deletions(-)
 create mode 100644 drivers/hid/hid-ntrig.c

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index b4fd8ca..9e33af9 100644
- --- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -202,6 +202,13 @@ config HID_MONTEREY
 	---help---
 	Support for Monterey Genius KB29E.

+config HID_NTRIG
+	tristate "NTrig" if EMBEDDED
+	depends on USB_HID
+	default y
+	---help---
+	Support for N-Trig touch screen.
+
 config HID_PANTHERLORD
 	tristate "Pantherlord devices support" if EMBEDDED
 	depends on USB_HID
diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index b09e43e..8b2c545 100644
- --- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -33,6 +33,7 @@ obj-$(CONFIG_HID_GYRATION)	+= hid-gyration.o
 obj-$(CONFIG_HID_LOGITECH)	+= hid-logitech.o
 obj-$(CONFIG_HID_MICROSOFT)	+= hid-microsoft.o
 obj-$(CONFIG_HID_MONTEREY)	+= hid-monterey.o
+obj-$(CONFIG_HID_NTRIG)		+= hid-ntrig.o
 obj-$(CONFIG_HID_PANTHERLORD)	+= hid-pl.o
 obj-$(CONFIG_HID_PETALYNX)	+= hid-petalynx.o
 obj-$(CONFIG_HID_SAMSUNG)	+= hid-samsung.o
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 147ec59..6ee9a64 100644
- --- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1294,6 +1294,7 @@ static const struct hid_device_id hid_blacklist[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_PRESENTER_8K_USB) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_WIRELESS_OPTICAL_DESKTOP_3_0) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MONTEREY, USB_DEVICE_ID_GENIUS_KB29E) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_TOUCH_SCREEN) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PETALYNX, USB_DEVICE_ID_PETALYNX_MAXTER_REMOTE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAMSUNG, USB_DEVICE_ID_SAMSUNG_IR_REMOTE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_PS3_CONTROLLER) },
diff --git a/drivers/hid/hid-dummy.c b/drivers/hid/hid-dummy.c
index e148f86..0d44b26 100644
- --- a/drivers/hid/hid-dummy.c
+++ b/drivers/hid/hid-dummy.c
@@ -43,8 +43,8 @@ static int __init hid_dummy_init(void)
 #ifdef CONFIG_HID_MONTEREY_MODULE
 	HID_COMPAT_CALL_DRIVER(monterey);
 #endif
- -#ifdef CONFIG_HID_PANTHERLORD_MODULE
- -	HID_COMPAT_CALL_DRIVER(pantherlord);
+#ifdef CONFIG_HID_NTRIG_MODULE
+	HID_COMPAT_CALL_DRIVER(ntrig);
 #endif
 #ifdef CONFIG_HID_PETALYNX_MODULE
 	HID_COMPAT_CALL_DRIVER(petalynx);
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index d70075d..c3c2550 100644
- --- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -338,6 +338,9 @@
 #define USB_VENDOR_ID_NEC		0x073e
 #define USB_DEVICE_ID_NEC_USB_GAME_PAD	0x0301

+#define USB_VENDOR_ID_NTRIG                0x1b96
+#define USB_DEVICE_ID_NTRIG_TOUCH_SCREEN   0x0001
+
 #define USB_VENDOR_ID_ONTRAK		0x0a07
 #define USB_DEVICE_ID_ONTRAK_ADU100	0x0064

diff --git a/drivers/hid/hid-ntrig.c b/drivers/hid/hid-ntrig.c
new file mode 100644
index 0000000..549f5e1
- --- /dev/null
+++ b/drivers/hid/hid-ntrig.c
@@ -0,0 +1,82 @@
+/*
+ *  HID driver for some ntrig "special" devices
+ *
+ *  Copyright (c) 1999 Andreas Gal
+ *  Copyright (c) 2000-2005 Vojtech Pavlik <vojtech@suse.cz>
+ *  Copyright (c) 2005 Michael Haboustak <mike-@cinci.rr.com> for Concept2, Inc
+ *  Copyright (c) 2006-2007 Jiri Kosina
+ *  Copyright (c) 2007 Paul Walmsley
+ *  Copyright (c) 2008 Jiri Slaby
+ *  Copyright (c) 2008 Rafi Rubin
+ *
+ */
+
+/*
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+#include <linux/device.h>
+#include <linux/hid.h>
+#include <linux/module.h>
+
+#include "hid-ids.h"
+
+#define NTRIG_DUPLICATE_USAGES	0x001
+
+#define nt_map_key_clear(c)	hid_map_usage_clear(hi, usage, bit, max, \
+					EV_KEY, (c))
+
+static int ntrig_input_mapping(struct hid_device *hdev, struct hid_input *hi,
+		struct hid_field *field, struct hid_usage *usage,
+		unsigned long **bit, int *max)
+{
+	if ((usage->hid & HID_USAGE_PAGE) == HID_UP_DIGITIZER &&
+			(usage->hid & 0xff) == 0x47) {
+		nt_map_key_clear(BTN_TOOL_DOUBLETAP);
+		return 1;
+	}
+	return 0;
+}
+
+static int ntrig_input_mapped(struct hid_device *hdev, struct hid_input *hi,
+		struct hid_field *field, struct hid_usage *usage,
+		unsigned long **bit, int *max)
+{
+	if (usage->type == EV_KEY || usage->type == EV_REL
+			|| usage->type == EV_ABS)
+		clear_bit(usage->code, *bit);
+
+	return 0;
+}
+static const struct hid_device_id ntrig_devices[] = {
+	{ HID_USB_DEVICE(USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_TOUCH_SCREEN),
+		.driver_data = NTRIG_DUPLICATE_USAGES },
+	{ }
+};
+MODULE_DEVICE_TABLE(hid, ntrig_devices);
+
+static struct hid_driver ntrig_driver = {
+	.name = "ntrig",
+	.id_table = ntrig_devices,
+	.input_mapping = ntrig_input_mapping,
+	.input_mapped = ntrig_input_mapped,
+};
+
+static int ntrig_init(void)
+{
+	return hid_register_driver(&ntrig_driver);
+}
+
+static void ntrig_exit(void)
+{
+	hid_unregister_driver(&ntrig_driver);
+}
+
+module_init(ntrig_init);
+module_exit(ntrig_exit);
+MODULE_LICENSE("GPL");
+
+HID_COMPAT_LOAD_DRIVER(ntrig);
- --
1.5.6.5


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkkkJhcACgkQwuRiAT9o609q4ACfcbxS0IFnt9uUmUTcxYpugywH
WcAAnRLWr+Om3xqozOcqpAeagrddmck9
=NQkr
-----END PGP SIGNATURE-----
