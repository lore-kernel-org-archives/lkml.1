Return-Path: <linux-kernel-owner+w=401wt.eu-S932652AbXCRVl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932652AbXCRVl4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 17:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932853AbXCRVl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 17:41:56 -0400
Received: from postfix2-g20.free.fr ([212.27.60.43]:37421 "EHLO
	postfix2-g20.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932652AbXCRVl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 17:41:56 -0400
Message-ID: <45FDAACE.9060303@tremplin-utc.net>
Date: Sun, 18 Mar 2007 22:10:38 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <Eric.Piel@tremplin-utc.net>
User-Agent: Thunderbird 2.0b2 (X11/20070307)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Vojtech Pavlik <vojtech@suse.cz>, mitr@volny.cz, otauber@web.de,
       linux-kernel@vger.kernel.org,
       linux-input <linux-input@atrey.karlin.mff.cuni.cz>
Subject: [PATCH 2/3] wistron_btns: Generic keymap
References: <45ECA23A.5010503@tremplin-utc.net> <d120d5000703060536k7743ece9hb20fa4d1f7ad7ad7@mail.gmail.com> <45ED8809.70309@tremplin-utc.net> <45F72D37.6090004@tremplin-utc.net> <d120d5000703140654y4d8cb0a3oafd49c48a045bd77@mail.gmail.com> <20070314182559.GC5264@suse.cz> <d120d5000703141158t4d02b8b7pc4ab967722dac@mail.gmail.com> <20070314190254.GA5843@suse.cz> <45F91F73.8040200@tremplin-utc.net>
In-Reply-To: <45F91F73.8040200@tremplin-utc.net>
Content-Type: multipart/mixed;
 boundary="------------030905020501050406080605"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030905020501050406080605
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

This patch adds a generic map. That is, a keymap that should output the 
correct keycodes for most laptops. This is simply based on the 
observation of all those keymaps already gathered, as most of the 
wistron codes are always mapped to the same keycode.

Hopefully, this way users which have a non-supported laptop will have a 
quick and dirty way to use the multimedia keys.

Eric

--------------030905020501050406080605
Content-Type: text/x-patch;
 name="wistron_btns-generic-map-2.6.21-b.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="wistron_btns-generic-map-2.6.21-b.patch"

From: Eric Piel <eric.piel@tremplin-utc.net>

wistron_btns: Generic keymap

It turns out that the mapping of the wistron code is always the same, the
main difference being some keys which may not exist and leds which might not be
present. Therefore it's possible to write a generic keymap which would allow
the use of an unknown keyboard with little drawbacks. The user can select it
specifying the parameter "keymap=generic".

Signed-off-by: Eric Piel <eric.piel@tremplin-utc.net>

--- linux-2.6.21/drivers/input/misc/wistron_btns.c	2007-03-17 10:09:11.000000000 +0100
+++ linux-2.6.21/drivers/input/misc/wistron_btns.c~full	2007-03-17 10:09:14.000000000 +0100
@@ -58,7 +58,7 @@ MODULE_PARM_DESC(force, "Load even if co
 
 static char *keymap_name; /* = NULL; */
 module_param_named(keymap, keymap_name, charp, 0);
-MODULE_PARM_DESC(keymap, "Keymap name, if it can't be autodetected");
+MODULE_PARM_DESC(keymap, "Keymap name, if it can't be autodetected [generic, 1557/MS2141]");
 
 static struct platform_device *wistron_device;
 
@@ -568,6 +568,42 @@ static struct key_entry keymap_wistron_m
 	{ KE_END, FE_UNTESTED }
 };
 
+static struct key_entry keymap_wistron_generic[] = {
+	{ KE_KEY, 0x01, {KEY_HELP} },
+	{ KE_KEY, 0x02, {KEY_CONFIG} },
+	{ KE_KEY, 0x03, {KEY_POWER} },
+	{ KE_KEY, 0x05, {KEY_SWITCHVIDEOMODE} }, /* Display selection */
+	{ KE_KEY, 0x06, {KEY_SCREEN} }, /* Display on/off */
+	{ KE_KEY, 0x08, {KEY_MUTE} },
+	{ KE_KEY, 0x11, {KEY_PROG1} },
+	{ KE_KEY, 0x12, {KEY_PROG2} },
+	{ KE_KEY, 0x13, {KEY_PROG3} },
+	{ KE_KEY, 0x14, {KEY_MAIL} },
+	{ KE_KEY, 0x15, {KEY_WWW} },
+	{ KE_KEY, 0x20, {KEY_VOLUMEUP} },
+	{ KE_KEY, 0x21, {KEY_VOLUMEDOWN} },
+	{ KE_KEY, 0x22, {KEY_REWIND} },
+	{ KE_KEY, 0x23, {KEY_FORWARD} },
+	{ KE_KEY, 0x24, {KEY_PLAYPAUSE} },
+	{ KE_KEY, 0x25, {KEY_STOPCD} },
+	{ KE_KEY, 0x31, {KEY_MAIL} },
+	{ KE_KEY, 0x36, {KEY_WWW} },
+	{ KE_KEY, 0x37, {KEY_SCREEN} }, /* Display on/off */
+	{ KE_KEY, 0x40, {KEY_WLAN} },
+	{ KE_KEY, 0x49, {KEY_CONFIG} },
+	{ KE_SW, 0x4a, {.sw = {SW_LID, 1}} }, /* lid close */
+	{ KE_SW, 0x4b, {.sw = {SW_LID, 0}} }, /* lid open */
+	{ KE_KEY, 0x6a, {KEY_CONFIG} },
+	{ KE_KEY, 0x6d, {KEY_POWER} },
+	{ KE_KEY, 0x71, {KEY_STOPCD} },
+	{ KE_KEY, 0x72, {KEY_PLAYPAUSE} },
+	{ KE_KEY, 0x74, {KEY_REWIND} },
+	{ KE_KEY, 0x78, {KEY_FORWARD} },
+	{ KE_WIFI, 0x30 },
+	{ KE_BLUETOOTH, 0x44 },
+	{ KE_END, 0 }
+};
+
 /*
  * If your machine is not here (which is currently rather likely), please send
  * a list of buttons and their key codes (reported when loading this module
@@ -886,15 +922,17 @@ static struct dmi_system_id dmi_ids[] __
 
 static int __init select_keymap(void)
 {
+	dmi_check_system(dmi_ids);
 	if (keymap_name != NULL) {
 		if (strcmp (keymap_name, "1557/MS2141") == 0)
 			keymap = keymap_wistron_ms2141;
+		else if (strcmp (keymap_name, "generic") == 0)
+			keymap = keymap_wistron_generic;
 		else {
 			printk(KERN_ERR "wistron_btns: Keymap unknown\n");
 			return -EINVAL;
 		}
 	}
-	dmi_check_system(dmi_ids);
 	if (keymap == NULL) {
 		if (!force) {
 			printk(KERN_ERR "wistron_btns: System unknown\n");

--------------030905020501050406080605--
