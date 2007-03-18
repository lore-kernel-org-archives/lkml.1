Return-Path: <linux-kernel-owner+w=401wt.eu-S1753287AbXCRVhP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287AbXCRVhP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 17:37:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751216AbXCRVhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 17:37:15 -0400
Received: from postfix1-g20.free.fr ([212.27.60.42]:50703 "EHLO
	postfix1-g20.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287AbXCRVhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 17:37:13 -0400
Message-ID: <45FDAAD4.1090404@tremplin-utc.net>
Date: Sun, 18 Mar 2007 22:10:44 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <Eric.Piel@tremplin-utc.net>
User-Agent: Thunderbird 2.0b2 (X11/20070307)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Vojtech Pavlik <vojtech@suse.cz>, mitr@volny.cz, otauber@web.de,
       linux-kernel@vger.kernel.org,
       linux-input <linux-input@atrey.karlin.mff.cuni.cz>
Subject: [PATCH 3/3] wistron_btns: Declare keymaps as initdata
References: <45ECA23A.5010503@tremplin-utc.net> <d120d5000703060536k7743ece9hb20fa4d1f7ad7ad7@mail.gmail.com> <45ED8809.70309@tremplin-utc.net> <45F72D37.6090004@tremplin-utc.net> <d120d5000703140654y4d8cb0a3oafd49c48a045bd77@mail.gmail.com> <20070314182559.GC5264@suse.cz> <d120d5000703141158t4d02b8b7pc4ab967722dac@mail.gmail.com> <20070314190254.GA5843@suse.cz> <45F91F73.8040200@tremplin-utc.net>
In-Reply-To: <45F91F73.8040200@tremplin-utc.net>
Content-Type: multipart/mixed;
 boundary="------------070902030500000501030006"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070902030500000501030006
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

This patch declares keymaps as initdata, so they are discarded at 
runtime, saving about 1kb (10% of the module size). This idea to save 
memory comes from Dmitry Torokhov.

Eric

--------------070902030500000501030006
Content-Type: text/x-patch;
 name="wistron_btns-keymap-initdata-2.6.21-b.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="wistron_btns-keymap-initdata-2.6.21-b.patch"

From: Eric Piel <eric.piel@tremplin-utc.net>

wriston_btns: Declare keymaps as initdata

As the number of keymaps increases and is very unlikely to reduce, this patch
helps to reduce the memory consumption. Declare all the keymaps as __initdata,
and copy during the detection the right keymap. On my x86, this make the module
size at runtime going from 10616 to 9428: a bit more than 1kb saved.

Signed-off-by: Eric Piel <eric.piel@tremplin-utc.net>

--- linux-2.6.21/drivers/input/misc/wistron_btns.c~full	2007-03-17 10:09:14.000000000 +0100
+++ linux-2.6.21/drivers/input/misc/wistron_btns.c	2007-03-18 19:15:57.000000000 +0100
@@ -50,7 +50,7 @@
 MODULE_AUTHOR("Miloslav Trmac <mitr@volny.cz>");
 MODULE_DESCRIPTION("Wistron laptop button driver");
 MODULE_LICENSE("GPL v2");
-MODULE_VERSION("0.1");
+MODULE_VERSION("0.2");
 
 static int force; /* = 0; */
 module_param(force, bool, 0);
@@ -266,11 +266,11 @@ static int __init dmi_matched(struct dmi
 	return 1;
 }
 
-static struct key_entry keymap_empty[] = {
+static struct key_entry keymap_empty[] __initdata = {
 	{ KE_END, 0 }
 };
 
-static struct key_entry keymap_fs_amilo_pro_v2000[] = {
+static struct key_entry keymap_fs_amilo_pro_v2000[] __initdata = {
 	{ KE_KEY,  0x01, {KEY_HELP} },
 	{ KE_KEY,  0x11, {KEY_PROG1} },
 	{ KE_KEY,  0x12, {KEY_PROG2} },
@@ -280,7 +280,7 @@ static struct key_entry keymap_fs_amilo_
 	{ KE_END,  0 }
 };
 
-static struct key_entry keymap_fujitsu_n3510[] = {
+static struct key_entry keymap_fujitsu_n3510[] __initdata = {
 	{ KE_KEY, 0x11, {KEY_PROG1} },
 	{ KE_KEY, 0x12, {KEY_PROG2} },
 	{ KE_KEY, 0x36, {KEY_WWW} },
@@ -292,7 +292,7 @@ static struct key_entry keymap_fujitsu_n
 	{ KE_END, 0 }
 };
 
-static struct key_entry keymap_wistron_ms2111[] = {
+static struct key_entry keymap_wistron_ms2111[] __initdata = {
 	{ KE_KEY,  0x11, {KEY_PROG1} },
 	{ KE_KEY,  0x12, {KEY_PROG2} },
 	{ KE_KEY,  0x13, {KEY_PROG3} },
@@ -301,7 +301,7 @@ static struct key_entry keymap_wistron_m
 	{ KE_END, FE_MAIL_LED }
 };
 
-static struct key_entry keymap_wistron_md40100[] = {
+static struct key_entry keymap_wistron_md40100[] __initdata = {
 	{ KE_KEY, 0x01, {KEY_HELP} },
 	{ KE_KEY, 0x02, {KEY_CONFIG} },
 	{ KE_KEY, 0x31, {KEY_MAIL} },
@@ -310,7 +310,7 @@ static struct key_entry keymap_wistron_m
 	{ KE_END, FE_MAIL_LED | FE_WIFI_LED | FE_UNTESTED }
 };
 
-static struct key_entry keymap_wistron_ms2141[] = {
+static struct key_entry keymap_wistron_ms2141[] __initdata = {
 	{ KE_KEY,  0x11, {KEY_PROG1} },
 	{ KE_KEY,  0x12, {KEY_PROG2} },
 	{ KE_WIFI, 0x30 },
@@ -323,7 +323,7 @@ static struct key_entry keymap_wistron_m
 	{ KE_END,  0 }
 };
 
-static struct key_entry keymap_acer_aspire_1500[] = {
+static struct key_entry keymap_acer_aspire_1500[] __initdata = {
 	{ KE_KEY, 0x01, {KEY_HELP} },
 	{ KE_KEY, 0x03, {KEY_POWER} },
 	{ KE_KEY, 0x11, {KEY_PROG1} },
@@ -336,7 +336,7 @@ static struct key_entry keymap_acer_aspi
 	{ KE_END, FE_UNTESTED }
 };
 
-static struct key_entry keymap_acer_aspire_1600[] = {
+static struct key_entry keymap_acer_aspire_1600[] __initdata = {
 	{ KE_KEY, 0x01, {KEY_HELP} },
 	{ KE_KEY, 0x03, {KEY_POWER} },
 	{ KE_KEY, 0x08, {KEY_MUTE} },
@@ -352,7 +352,7 @@ static struct key_entry keymap_acer_aspi
 };
 
 /* 3020 has been tested */
-static struct key_entry keymap_acer_aspire_5020[] = {
+static struct key_entry keymap_acer_aspire_5020[] __initdata = {
 	{ KE_KEY, 0x01, {KEY_HELP} },
 	{ KE_KEY, 0x03, {KEY_POWER} },
 	{ KE_KEY, 0x05, {KEY_SWITCHVIDEOMODE} }, /* Display selection */
@@ -366,7 +366,7 @@ static struct key_entry keymap_acer_aspi
 	{ KE_END, FE_MAIL_LED | FE_UNTESTED }
 };
 
-static struct key_entry keymap_acer_travelmate_2410[] = {
+static struct key_entry keymap_acer_travelmate_2410[] __initdata = {
 	{ KE_KEY, 0x01, {KEY_HELP} },
 	{ KE_KEY, 0x6d, {KEY_POWER} },
 	{ KE_KEY, 0x11, {KEY_PROG1} },
@@ -379,7 +379,7 @@ static struct key_entry keymap_acer_trav
 	{ KE_END, FE_MAIL_LED | FE_UNTESTED }
 };
 
-static struct key_entry keymap_acer_travelmate_110[] = {
+static struct key_entry keymap_acer_travelmate_110[] __initdata = {
 	{ KE_KEY, 0x01, {KEY_HELP} },
 	{ KE_KEY, 0x02, {KEY_CONFIG} },
 	{ KE_KEY, 0x03, {KEY_POWER} },
@@ -396,7 +396,7 @@ static struct key_entry keymap_acer_trav
 	{ KE_END, FE_MAIL_LED | FE_UNTESTED }
 };
 
-static struct key_entry keymap_acer_travelmate_300[] = {
+static struct key_entry keymap_acer_travelmate_300[] __initdata = {
 	{ KE_KEY, 0x01, {KEY_HELP} },
 	{ KE_KEY, 0x02, {KEY_CONFIG} },
 	{ KE_KEY, 0x03, {KEY_POWER} },
@@ -412,7 +412,7 @@ static struct key_entry keymap_acer_trav
 	{ KE_END, FE_MAIL_LED | FE_UNTESTED }
 };
 
-static struct key_entry keymap_acer_travelmate_380[] = {
+static struct key_entry keymap_acer_travelmate_380[] __initdata = {
 	{ KE_KEY, 0x01, {KEY_HELP} },
 	{ KE_KEY, 0x02, {KEY_CONFIG} },
 	{ KE_KEY, 0x03, {KEY_POWER} }, /* not 370 */
@@ -426,7 +426,7 @@ static struct key_entry keymap_acer_trav
 };
 
 /* unusual map */
-static struct key_entry keymap_acer_travelmate_220[] = {
+static struct key_entry keymap_acer_travelmate_220[] __initdata = {
 	{ KE_KEY, 0x01, {KEY_HELP} },
 	{ KE_KEY, 0x02, {KEY_CONFIG} },
 	{ KE_KEY, 0x11, {KEY_MAIL} },
@@ -436,7 +436,7 @@ static struct key_entry keymap_acer_trav
 	{ KE_END, FE_WIFI_LED | FE_UNTESTED }
 };
 
-static struct key_entry keymap_acer_travelmate_230[] = {
+static struct key_entry keymap_acer_travelmate_230[] __initdata = {
 	{ KE_KEY, 0x01, {KEY_HELP} },
 	{ KE_KEY, 0x02, {KEY_CONFIG} },
 	{ KE_KEY, 0x11, {KEY_PROG1} },
@@ -446,7 +446,7 @@ static struct key_entry keymap_acer_trav
 	{ KE_END, FE_WIFI_LED | FE_UNTESTED }
 };
 
-static struct key_entry keymap_acer_travelmate_240[] = {
+static struct key_entry keymap_acer_travelmate_240[] __initdata = {
 	{ KE_KEY, 0x01, {KEY_HELP} },
 	{ KE_KEY, 0x02, {KEY_CONFIG} },
 	{ KE_KEY, 0x03, {KEY_POWER} },
@@ -460,7 +460,7 @@ static struct key_entry keymap_acer_trav
 	{ KE_END, FE_UNTESTED }
 };
 
-static struct key_entry keymap_acer_travelmate_350[] = {
+static struct key_entry keymap_acer_travelmate_350[] __initdata = {
 	{ KE_KEY, 0x01, {KEY_HELP} },
 	{ KE_KEY, 0x02, {KEY_CONFIG} },
 	{ KE_KEY, 0x11, {KEY_PROG1} },
@@ -471,7 +471,7 @@ static struct key_entry keymap_acer_trav
 	{ KE_END, FE_MAIL_LED | FE_WIFI_LED | FE_UNTESTED }
 };
 
-static struct key_entry keymap_acer_travelmate_360[] = {
+static struct key_entry keymap_acer_travelmate_360[] __initdata = {
 	{ KE_KEY, 0x01, {KEY_HELP} },
 	{ KE_KEY, 0x02, {KEY_CONFIG} },
 	{ KE_KEY, 0x11, {KEY_PROG1} },
@@ -486,7 +486,7 @@ static struct key_entry keymap_acer_trav
 /* Wifi subsystem only activate the led. Therefore we need to pass
  * wifi event as a normal key, then userspace can really change the wifi state.
  * TODO we need to export led state to userspace (wifi and mail) */
-static struct key_entry keymap_acer_travelmate_610[] = {
+static struct key_entry keymap_acer_travelmate_610[] __initdata = {
 	{ KE_KEY, 0x01, {KEY_HELP} },
 	{ KE_KEY, 0x02, {KEY_CONFIG} },
 	{ KE_KEY, 0x11, {KEY_PROG1} },
@@ -498,7 +498,7 @@ static struct key_entry keymap_acer_trav
 	{ KE_END, FE_MAIL_LED | FE_WIFI_LED }
 };
 
-static struct key_entry keymap_acer_travelmate_630[] = {
+static struct key_entry keymap_acer_travelmate_630[] __initdata = {
 	{ KE_KEY, 0x01, {KEY_HELP} },
 	{ KE_KEY, 0x02, {KEY_CONFIG} },
 	{ KE_KEY, 0x03, {KEY_POWER} },
@@ -514,7 +514,7 @@ static struct key_entry keymap_acer_trav
 	{ KE_END, FE_MAIL_LED | FE_UNTESTED }
 };
 
-static struct key_entry keymap_aopen_1559as[] = {
+static struct key_entry keymap_aopen_1559as[] __initdata = {
 	{ KE_KEY,  0x01, {KEY_HELP} },
 	{ KE_KEY,  0x06, {KEY_PROG3} },
 	{ KE_KEY,  0x11, {KEY_PROG1} },
@@ -525,7 +525,7 @@ static struct key_entry keymap_aopen_155
 	{ KE_END,  0 },
 };
 
-static struct key_entry keymap_fs_amilo_d88x0[] = {
+static struct key_entry keymap_fs_amilo_d88x0[] __initdata = {
 	{ KE_KEY, 0x01, {KEY_HELP} },
 	{ KE_KEY, 0x08, {KEY_MUTE} },
 	{ KE_KEY, 0x31, {KEY_MAIL} },
@@ -536,7 +536,7 @@ static struct key_entry keymap_fs_amilo_
 	{ KE_END, FE_MAIL_LED | FE_WIFI_LED | FE_UNTESTED }
 };
 
-static struct key_entry keymap_wistron_md2900[] = {
+static struct key_entry keymap_wistron_md2900[] __initdata = {
 	{ KE_KEY, 0x01, {KEY_HELP} },
 	{ KE_KEY, 0x02, {KEY_CONFIG} },
 	{ KE_KEY, 0x11, {KEY_PROG1} },
@@ -547,7 +547,7 @@ static struct key_entry keymap_wistron_m
 	{ KE_END, FE_MAIL_LED | FE_UNTESTED }
 };
 
-static struct key_entry keymap_wistron_md96500[] = {
+static struct key_entry keymap_wistron_md96500[] __initdata = {
 	{ KE_KEY, 0x01, {KEY_HELP} },
 	{ KE_KEY, 0x02, {KEY_CONFIG} },
 	{ KE_KEY, 0x05, {KEY_SWITCHVIDEOMODE} }, /* Display selection */
@@ -568,7 +568,7 @@ static struct key_entry keymap_wistron_m
 	{ KE_END, FE_UNTESTED }
 };
 
-static struct key_entry keymap_wistron_generic[] = {
+static struct key_entry keymap_wistron_generic[] __initdata = {
 	{ KE_KEY, 0x01, {KEY_HELP} },
 	{ KE_KEY, 0x02, {KEY_CONFIG} },
 	{ KE_KEY, 0x03, {KEY_POWER} },
@@ -920,6 +920,26 @@ static struct dmi_system_id dmi_ids[] __
 	{ NULL, }
 };
 
+/* Copy the good keymap, as the original ones are free'd */
+static int __init copy_keymap(void)
+{
+	const struct key_entry *key;
+	struct key_entry *new_keymap;
+	unsigned int length = 1;
+
+	for (key = keymap; key->type != KE_END; key++)
+		length++;
+
+	new_keymap = kmalloc(length * sizeof(struct key_entry), GFP_KERNEL);
+	if (!new_keymap)
+		return -ENOMEM;
+
+	memcpy(new_keymap, keymap, length * sizeof(struct key_entry));
+	keymap = new_keymap;
+
+	return 0;
+}
+
 static int __init select_keymap(void)
 {
 	dmi_check_system(dmi_ids);
@@ -940,7 +960,8 @@ static int __init select_keymap(void)
 		}
 		keymap = keymap_empty;
 	}
-	return 0;
+
+	return copy_keymap();
 }
 
  /* Input layer interface */
@@ -1203,6 +1224,7 @@ static void __exit wb_module_exit(void)
 	platform_device_unregister(wistron_device);
 	platform_driver_unregister(&wistron_driver);
 	unmap_bios();
+	kfree(keymap);
 }
 
 module_init(wb_module_init);

--------------070902030500000501030006--
