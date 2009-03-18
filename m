Return-Path: <linux-kernel-owner+w=401wt.eu-S1754495AbZCRIOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495AbZCRIOK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 04:14:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593AbZCRINs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 04:13:48 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:60460 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbZCRINq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 04:13:46 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: jkosina@suse.cz
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] HID: remove compat stuff
Date: Wed, 18 Mar 2009 09:13:37 +0100
Message-Id: <1237364017-27361-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removal was scheduled and there is no problem with later
distros to adapt for the new bus, thanks to aliases.

module-init-tools map files are deprecated nowadays, so that
the patch which introduced hid ones into the m-i-t won't be
accepted and hence there is no reason for leaving compat stuff in.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>
---
 Documentation/feature-removal-schedule.txt |    7 --
 drivers/hid/Kconfig                        |   12 ----
 drivers/hid/Makefile                       |    4 -
 drivers/hid/hid-a4tech.c                   |    2 -
 drivers/hid/hid-apple.c                    |    2 -
 drivers/hid/hid-belkin.c                   |    2 -
 drivers/hid/hid-cherry.c                   |    2 -
 drivers/hid/hid-chicony.c                  |    2 -
 drivers/hid/hid-core.c                     |    4 -
 drivers/hid/hid-cypress.c                  |    2 -
 drivers/hid/hid-drff.c                     |    2 -
 drivers/hid/hid-dummy.c                    |   87 ----------------------------
 drivers/hid/hid-ezkey.c                    |    2 -
 drivers/hid/hid-gaff.c                     |    2 -
 drivers/hid/hid-gyration.c                 |    2 -
 drivers/hid/hid-kensington.c               |    2 -
 drivers/hid/hid-kye.c                      |    2 -
 drivers/hid/hid-lg.c                       |    2 -
 drivers/hid/hid-microsoft.c                |    2 -
 drivers/hid/hid-monterey.c                 |    2 -
 drivers/hid/hid-ntrig.c                    |    2 -
 drivers/hid/hid-petalynx.c                 |    2 -
 drivers/hid/hid-pl.c                       |    2 -
 drivers/hid/hid-samsung.c                  |    2 -
 drivers/hid/hid-sony.c                     |    2 -
 drivers/hid/hid-sunplus.c                  |    2 -
 drivers/hid/hid-tmff.c                     |    2 -
 drivers/hid/hid-topseed.c                  |    2 -
 drivers/hid/hid-zpff.c                     |    2 -
 include/linux/hid.h                        |   16 -----
 30 files changed, 0 insertions(+), 178 deletions(-)
 delete mode 100644 drivers/hid/hid-dummy.c

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 4cc571b..50e02af 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -264,13 +264,6 @@ Who:	Glauber Costa <gcosta@redhat.com>
 
 ---------------------------
 
-What:	remove HID compat support
-When:	2.6.29
-Why:	needed only as a temporary solution until distros fix themselves up
-Who:	Jiri Slaby <jirislaby@gmail.com>
-
----------------------------
-
 What: print_fn_descriptor_symbol()
 When: October 2009
 Why:  The %pF vsprintf format provides the same functionality in a
diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 906ac1c..7e67dcb 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -70,18 +70,6 @@ source "drivers/hid/usbhid/Kconfig"
 menu "Special HID drivers"
 	depends on HID
 
-config HID_COMPAT
-	bool "Load all HID drivers on hid core load"
-	default y
-	---help---
-	Compatible option for older userspace. If you have system without udev
-	support of module loading through aliases and also old
-	module-init-tools which can't handle hid bus, choose Y here. Otherwise
-	say N. If you say N and your userspace is old enough, the only
-	functionality you lose is modules autoloading.
-
-	If unsure, say Y.
-
 config HID_A4TECH
 	tristate "A4 tech" if EMBEDDED
 	depends on USB_HID
diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index e6b72ed..1f7cb0f 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -8,10 +8,6 @@ obj-$(CONFIG_HID)		+= hid.o
 hid-$(CONFIG_HID_DEBUG)		+= hid-debug.o
 hid-$(CONFIG_HIDRAW)		+= hidraw.o
 
-ifdef CONFIG_HID_COMPAT
-obj-m				+= hid-dummy.o
-endif
-
 hid-logitech-objs		:= hid-lg.o
 ifdef CONFIG_LOGITECH_FF
 	hid-logitech-objs	+= hid-lgff.o
diff --git a/drivers/hid/hid-a4tech.c b/drivers/hid/hid-a4tech.c
index ebca00e..42ea359 100644
--- a/drivers/hid/hid-a4tech.c
+++ b/drivers/hid/hid-a4tech.c
@@ -158,5 +158,3 @@ static void a4_exit(void)
 module_init(a4_init);
 module_exit(a4_exit);
 MODULE_LICENSE("GPL");
-
-HID_COMPAT_LOAD_DRIVER(a4tech);
diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index 7ed94cf..a6dbd74 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -474,5 +474,3 @@ static void apple_exit(void)
 module_init(apple_init);
 module_exit(apple_exit);
 MODULE_LICENSE("GPL");
-
-HID_COMPAT_LOAD_DRIVER(apple);
diff --git a/drivers/hid/hid-belkin.c b/drivers/hid/hid-belkin.c
index 12c8a9b..2f67231 100644
--- a/drivers/hid/hid-belkin.c
+++ b/drivers/hid/hid-belkin.c
@@ -101,5 +101,3 @@ static void belkin_exit(void)
 module_init(belkin_init);
 module_exit(belkin_exit);
 MODULE_LICENSE("GPL");
-
-HID_COMPAT_LOAD_DRIVER(belkin);
diff --git a/drivers/hid/hid-cherry.c b/drivers/hid/hid-cherry.c
index b833b97..ab8209e 100644
--- a/drivers/hid/hid-cherry.c
+++ b/drivers/hid/hid-cherry.c
@@ -83,5 +83,3 @@ static void ch_exit(void)
 module_init(ch_init);
 module_exit(ch_exit);
 MODULE_LICENSE("GPL");
-
-HID_COMPAT_LOAD_DRIVER(cherry);
diff --git a/drivers/hid/hid-chicony.c b/drivers/hid/hid-chicony.c
index a54d409..7f91076 100644
--- a/drivers/hid/hid-chicony.c
+++ b/drivers/hid/hid-chicony.c
@@ -76,5 +76,3 @@ static void ch_exit(void)
 module_init(ch_init);
 module_exit(ch_exit);
 MODULE_LICENSE("GPL");
-
-HID_COMPAT_LOAD_DRIVER(chicony);
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 2a1e89d..5746a59 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1849,10 +1849,6 @@ static int __init hid_init(void)
 	if (ret)
 		goto err_bus;
 
-#ifdef CONFIG_HID_COMPAT
-	request_module_nowait("hid-dummy");
-#endif
-
 	return 0;
 err_bus:
 	bus_unregister(&hid_bus_type);
diff --git a/drivers/hid/hid-cypress.c b/drivers/hid/hid-cypress.c
index 5d69d27..9d6d3b9 100644
--- a/drivers/hid/hid-cypress.c
+++ b/drivers/hid/hid-cypress.c
@@ -154,5 +154,3 @@ static void cp_exit(void)
 module_init(cp_init);
 module_exit(cp_exit);
 MODULE_LICENSE("GPL");
-
-HID_COMPAT_LOAD_DRIVER(cypress);
diff --git a/drivers/hid/hid-drff.c b/drivers/hid/hid-drff.c
index 785d249..34f3eb6 100644
--- a/drivers/hid/hid-drff.c
+++ b/drivers/hid/hid-drff.c
@@ -186,5 +186,3 @@ static void __exit dr_exit(void)
 module_init(dr_init);
 module_exit(dr_exit);
 MODULE_LICENSE("GPL");
-
-HID_COMPAT_LOAD_DRIVER(dragonrise);
diff --git a/drivers/hid/hid-dummy.c b/drivers/hid/hid-dummy.c
deleted file mode 100644
index 74d765f..0000000
--- a/drivers/hid/hid-dummy.c
+++ /dev/null
@@ -1,87 +0,0 @@
-#include <linux/autoconf.h>
-#include <linux/module.h>
-#include <linux/hid.h>
-
-static int __init hid_dummy_init(void)
-{
-#ifdef CONFIG_HID_A4TECH_MODULE
-	HID_COMPAT_CALL_DRIVER(a4tech);
-#endif
-#ifdef CONFIG_HID_APPLE_MODULE
-	HID_COMPAT_CALL_DRIVER(apple);
-#endif
-#ifdef CONFIG_HID_BELKIN_MODULE
-	HID_COMPAT_CALL_DRIVER(belkin);
-#endif
-#ifdef CONFIG_HID_BRIGHT_MODULE
-	HID_COMPAT_CALL_DRIVER(bright);
-#endif
-#ifdef CONFIG_HID_CHERRY_MODULE
-	HID_COMPAT_CALL_DRIVER(cherry);
-#endif
-#ifdef CONFIG_HID_CHICONY_MODULE
-	HID_COMPAT_CALL_DRIVER(chicony);
-#endif
-#ifdef CONFIG_HID_CYPRESS_MODULE
-	HID_COMPAT_CALL_DRIVER(cypress);
-#endif
-#ifdef CONFIG_HID_DELL_MODULE
-	HID_COMPAT_CALL_DRIVER(dell);
-#endif
-#ifdef CONFIG_DRAGONRISE_FF_MODULE
-	HID_COMPAT_CALL_DRIVER(dragonrise);
-#endif
-#ifdef CONFIG_HID_EZKEY_MODULE
-	HID_COMPAT_CALL_DRIVER(ezkey);
-#endif
-#ifdef CONFIG_HID_KYE_MODULE
-	HID_COMPAT_CALL_DRIVER(kye);
-#endif
-#ifdef CONFIG_HID_GYRATION_MODULE
-	HID_COMPAT_CALL_DRIVER(gyration);
-#endif
-#ifdef CONFIG_HID_KENSINGTON_MODULE
-	HID_COMPAT_CALL_DRIVER(kensington);
-#endif
-#ifdef CONFIG_HID_LOGITECH_MODULE
-	HID_COMPAT_CALL_DRIVER(logitech);
-#endif
-#ifdef CONFIG_HID_MICROSOFT_MODULE
-	HID_COMPAT_CALL_DRIVER(microsoft);
-#endif
-#ifdef CONFIG_HID_MONTEREY_MODULE
-	HID_COMPAT_CALL_DRIVER(monterey);
-#endif
-#ifdef CONFIG_HID_NTRIG_MODULE
-	HID_COMPAT_CALL_DRIVER(ntrig);
-#endif
-#ifdef CONFIG_HID_PANTHERLORD_MODULE
-	HID_COMPAT_CALL_DRIVER(pantherlord);
-#endif
-#ifdef CONFIG_HID_PETALYNX_MODULE
-	HID_COMPAT_CALL_DRIVER(petalynx);
-#endif
-#ifdef CONFIG_HID_SAMSUNG_MODULE
-	HID_COMPAT_CALL_DRIVER(samsung);
-#endif
-#ifdef CONFIG_HID_SONY_MODULE
-	HID_COMPAT_CALL_DRIVER(sony);
-#endif
-#ifdef CONFIG_HID_SUNPLUS_MODULE
-	HID_COMPAT_CALL_DRIVER(sunplus);
-#endif
-#ifdef CONFIG_GREENASIA_FF_MODULE
-	HID_COMPAT_CALL_DRIVER(greenasia);
-#endif
-#ifdef CONFIG_THRUSTMASTER_FF_MODULE
-	HID_COMPAT_CALL_DRIVER(thrustmaster);
-#endif
-#ifdef CONFIG_ZEROPLUS_FF_MODULE
-	HID_COMPAT_CALL_DRIVER(zeroplus);
-#endif
-
-	return -EIO;
-}
-module_init(hid_dummy_init);
-
-MODULE_LICENSE("GPL");
diff --git a/drivers/hid/hid-ezkey.c b/drivers/hid/hid-ezkey.c
index deb42f9..0a1fe05 100644
--- a/drivers/hid/hid-ezkey.c
+++ b/drivers/hid/hid-ezkey.c
@@ -91,5 +91,3 @@ static void ez_exit(void)
 module_init(ez_init);
 module_exit(ez_exit);
 MODULE_LICENSE("GPL");
-
-HID_COMPAT_LOAD_DRIVER(ezkey);
diff --git a/drivers/hid/hid-gaff.c b/drivers/hid/hid-gaff.c
index 71211f6..510ad3a 100644
--- a/drivers/hid/hid-gaff.c
+++ b/drivers/hid/hid-gaff.c
@@ -181,5 +181,3 @@ static void __exit ga_exit(void)
 module_init(ga_init);
 module_exit(ga_exit);
 MODULE_LICENSE("GPL");
-
-HID_COMPAT_LOAD_DRIVER(greenasia);
diff --git a/drivers/hid/hid-gyration.c b/drivers/hid/hid-gyration.c
index 04a0afe..d42d222 100644
--- a/drivers/hid/hid-gyration.c
+++ b/drivers/hid/hid-gyration.c
@@ -94,5 +94,3 @@ static void gyration_exit(void)
 module_init(gyration_init);
 module_exit(gyration_exit);
 MODULE_LICENSE("GPL");
-
-HID_COMPAT_LOAD_DRIVER(gyration);
diff --git a/drivers/hid/hid-kensington.c b/drivers/hid/hid-kensington.c
index 747fee5..7353bd7 100644
--- a/drivers/hid/hid-kensington.c
+++ b/drivers/hid/hid-kensington.c
@@ -61,5 +61,3 @@ static void ks_exit(void)
 module_init(ks_init);
 module_exit(ks_exit);
 MODULE_LICENSE("GPL");
-
-HID_COMPAT_LOAD_DRIVER(kensington);
diff --git a/drivers/hid/hid-kye.c b/drivers/hid/hid-kye.c
index ea7f412..72ee3fe 100644
--- a/drivers/hid/hid-kye.c
+++ b/drivers/hid/hid-kye.c
@@ -67,5 +67,3 @@ static void kye_exit(void)
 module_init(kye_init);
 module_exit(kye_exit);
 MODULE_LICENSE("GPL");
-
-HID_COMPAT_LOAD_DRIVER(kye);
diff --git a/drivers/hid/hid-lg.c b/drivers/hid/hid-lg.c
index 83e07c9..7b80cb6 100644
--- a/drivers/hid/hid-lg.c
+++ b/drivers/hid/hid-lg.c
@@ -326,5 +326,3 @@ static void lg_exit(void)
 module_init(lg_init);
 module_exit(lg_exit);
 MODULE_LICENSE("GPL");
-
-HID_COMPAT_LOAD_DRIVER(logitech);
diff --git a/drivers/hid/hid-microsoft.c b/drivers/hid/hid-microsoft.c
index 25b10dc..5e9e37a 100644
--- a/drivers/hid/hid-microsoft.c
+++ b/drivers/hid/hid-microsoft.c
@@ -210,5 +210,3 @@ static void ms_exit(void)
 module_init(ms_init);
 module_exit(ms_exit);
 MODULE_LICENSE("GPL");
-
-HID_COMPAT_LOAD_DRIVER(microsoft);
diff --git a/drivers/hid/hid-monterey.c b/drivers/hid/hid-monterey.c
index f3a85a0..240f876 100644
--- a/drivers/hid/hid-monterey.c
+++ b/drivers/hid/hid-monterey.c
@@ -78,5 +78,3 @@ static void mr_exit(void)
 module_init(mr_init);
 module_exit(mr_exit);
 MODULE_LICENSE("GPL");
-
-HID_COMPAT_LOAD_DRIVER(monterey);
diff --git a/drivers/hid/hid-ntrig.c b/drivers/hid/hid-ntrig.c
index db44fbd..c5b252b 100644
--- a/drivers/hid/hid-ntrig.c
+++ b/drivers/hid/hid-ntrig.c
@@ -78,5 +78,3 @@ static void ntrig_exit(void)
 module_init(ntrig_init);
 module_exit(ntrig_exit);
 MODULE_LICENSE("GPL");
-
-HID_COMPAT_LOAD_DRIVER(ntrig);
diff --git a/drivers/hid/hid-petalynx.c b/drivers/hid/hid-petalynx.c
index 10945fe..2e83e8f 100644
--- a/drivers/hid/hid-petalynx.c
+++ b/drivers/hid/hid-petalynx.c
@@ -118,5 +118,3 @@ static void pl_exit(void)
 module_init(pl_init);
 module_exit(pl_exit);
 MODULE_LICENSE("GPL");
-
-HID_COMPAT_LOAD_DRIVER(petalynx);
diff --git a/drivers/hid/hid-pl.c b/drivers/hid/hid-pl.c
index 9ad76bf..4db9a34 100644
--- a/drivers/hid/hid-pl.c
+++ b/drivers/hid/hid-pl.c
@@ -230,5 +230,3 @@ static void pl_exit(void)
 module_init(pl_init);
 module_exit(pl_exit);
 MODULE_LICENSE("GPL");
-
-HID_COMPAT_LOAD_DRIVER(pantherlord);
diff --git a/drivers/hid/hid-samsung.c b/drivers/hid/hid-samsung.c
index 15f3c04..07083aa 100644
--- a/drivers/hid/hid-samsung.c
+++ b/drivers/hid/hid-samsung.c
@@ -96,5 +96,3 @@ static void samsung_exit(void)
 module_init(samsung_init);
 module_exit(samsung_exit);
 MODULE_LICENSE("GPL");
-
-HID_COMPAT_LOAD_DRIVER(samsung);
diff --git a/drivers/hid/hid-sony.c b/drivers/hid/hid-sony.c
index dd5a397..c259938 100644
--- a/drivers/hid/hid-sony.c
+++ b/drivers/hid/hid-sony.c
@@ -148,5 +148,3 @@ static void sony_exit(void)
 module_init(sony_init);
 module_exit(sony_exit);
 MODULE_LICENSE("GPL");
-
-HID_COMPAT_LOAD_DRIVER(sony);
diff --git a/drivers/hid/hid-sunplus.c b/drivers/hid/hid-sunplus.c
index 5ba68f7..e0a8fd3 100644
--- a/drivers/hid/hid-sunplus.c
+++ b/drivers/hid/hid-sunplus.c
@@ -78,5 +78,3 @@ static void sp_exit(void)
 module_init(sp_init);
 module_exit(sp_exit);
 MODULE_LICENSE("GPL");
-
-HID_COMPAT_LOAD_DRIVER(sunplus);
diff --git a/drivers/hid/hid-tmff.c b/drivers/hid/hid-tmff.c
index 1b7cba0..7c1f7b5 100644
--- a/drivers/hid/hid-tmff.c
+++ b/drivers/hid/hid-tmff.c
@@ -265,5 +265,3 @@ static void tm_exit(void)
 module_init(tm_init);
 module_exit(tm_exit);
 MODULE_LICENSE("GPL");
-
-HID_COMPAT_LOAD_DRIVER(thrustmaster);
diff --git a/drivers/hid/hid-topseed.c b/drivers/hid/hid-topseed.c
index cca64a0..152ccfa 100644
--- a/drivers/hid/hid-topseed.c
+++ b/drivers/hid/hid-topseed.c
@@ -73,5 +73,3 @@ static void ts_exit(void)
 module_init(ts_init);
 module_exit(ts_exit);
 MODULE_LICENSE("GPL");
-
-HID_COMPAT_LOAD_DRIVER(topseed);
diff --git a/drivers/hid/hid-zpff.c b/drivers/hid/hid-zpff.c
index ea82f37..85a198a 100644
--- a/drivers/hid/hid-zpff.c
+++ b/drivers/hid/hid-zpff.c
@@ -158,5 +158,3 @@ static void zp_exit(void)
 module_init(zp_init);
 module_exit(zp_exit);
 MODULE_LICENSE("GPL");
-
-HID_COMPAT_LOAD_DRIVER(zeroplus);
diff --git a/include/linux/hid.h b/include/linux/hid.h
index faa5ab0..a72876e 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -798,21 +798,5 @@ dbg_hid(const char *fmt, ...)
 		__FILE__ , ## arg)
 #endif /* HID_FF */
 
-#ifdef __KERNEL__
-#ifdef CONFIG_HID_COMPAT
-#define HID_COMPAT_LOAD_DRIVER(name)	\
-/* prototype to avoid sparse warning */	\
-extern void hid_compat_##name(void);	\
-void hid_compat_##name(void) { }	\
-EXPORT_SYMBOL(hid_compat_##name)
-#else
-#define HID_COMPAT_LOAD_DRIVER(name)
-#endif /* HID_COMPAT */
-#define HID_COMPAT_CALL_DRIVER(name)	do {	\
-	extern void hid_compat_##name(void);	\
-	hid_compat_##name();			\
-} while (0)
-#endif /* __KERNEL__ */
-
 #endif
 
-- 
1.6.2

