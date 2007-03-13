Return-Path: <linux-kernel-owner+w=401wt.eu-S1752157AbXCMXIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbXCMXIh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 19:08:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbXCMXIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 19:08:37 -0400
Received: from postfix2-g20.free.fr ([212.27.60.43]:38037 "EHLO
	postfix2-g20.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbXCMXIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 19:08:36 -0400
Message-ID: <45F72EA7.1030900@tremplin-utc.net>
Date: Wed, 14 Mar 2007 00:07:19 +0100
From: Eric Piel <Eric.Piel@tremplin-utc.net>
User-Agent: Thunderbird 2.0b2 (X11/20070307)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: mitr@volny.cz, otauber@web.de, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] wistron_btns: Generic keymap
References: <45ECA23A.5010503@tremplin-utc.net> <d120d5000703060536k7743ece9hb20fa4d1f7ad7ad7@mail.gmail.com> <45ED8809.70309@tremplin-utc.net>
In-Reply-To: <45ED8809.70309@tremplin-utc.net>
Content-Type: multipart/mixed;
 boundary="------------050107000306080404050603"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050107000306080404050603
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

This patch adds a generic map. That is, a keymap that should output the 
correct keycodes for most laptops. This is simply based on the 
observation of all those keymaps already gathered, as most of the 
wistron codes are always mapped to the same keycode.

Hopefully, this way users which have a non-supported laptop will have a 
quick and dirty way to use the multimedia keys.

Eric

--------------050107000306080404050603
Content-Type: text/x-patch;
 name="wistron_btns-generic-map-2.6.21.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="wistron_btns-generic-map-2.6.21.patch"

From: Eric Piel <eric.piel@tremplin-utc.net>

wistron_btns: Generic keymap

It turns out that the mapping of the wistron code is always the same, the main
difference being some keys which may not exist and leds which might not be
present. Therefore it's possible to write a generic keymap which would allow
the use of unknown keyboard. The user can select it specifying the parameter
"keymap=generic".

Signed-off-by: Eric Piel <eric.piel@tremplin-utc.net>

--- linux-2.6.21/drivers/input/misc/wistron_btns.c	2007-03-12 00:53:51.000000000 +0100
+++ linux-2.6.21/drivers/input/misc/wistron_btns.c~full	2007-03-12 00:39:26.000000000 +0100
@@ -58,7 +58,7 @@ MODULE_PARM_DESC(force, "Load even if co
 
 static char *keymap_name; /* = NULL; */
 module_param_named(keymap, keymap_name, charp, 0);
-MODULE_PARM_DESC(keymap, "Keymap name, if it can't be autodetected");
+MODULE_PARM_DESC(keymap, "Keymap name, if it can't be autodetected [generic, 1557/MS2141]");
 
 static struct platform_device *wistron_device;
 
@@ -562,6 +562,42 @@ static struct key_entry keymap_wistron_m
 	{ KE_END, FE_UNTESTED }
 };
 
+static struct key_entry keymap_wistron_generic[] = {
+	{ KE_KEY, 0x01, KEY_HELP },
+	{ KE_KEY, 0x02, KEY_CONFIG },
+	{ KE_KEY, 0x03, KEY_POWER },
+	{ KE_KEY, 0x05, KEY_MEDIA }, /* Display switch */
+	{ KE_KEY, 0x06, KEY_SCREEN }, /* Display on/off */
+	{ KE_KEY, 0x08, KEY_MUTE },
+	{ KE_KEY, 0x11, KEY_PROG1 },
+	{ KE_KEY, 0x12, KEY_PROG2 },
+	{ KE_KEY, 0x13, KEY_PROG3 },
+	{ KE_KEY, 0x14, KEY_MAIL },
+	{ KE_KEY, 0x15, KEY_WWW },
+	{ KE_KEY, 0x20, KEY_VOLUMEUP },
+	{ KE_KEY, 0x21, KEY_VOLUMEDOWN },
+	{ KE_KEY, 0x22, KEY_REWIND },
+	{ KE_KEY, 0x23, KEY_FORWARD },
+	{ KE_KEY, 0x24, KEY_PLAYPAUSE },
+	{ KE_KEY, 0x25, KEY_STOPCD },
+	{ KE_KEY, 0x31, KEY_MAIL },
+	{ KE_KEY, 0x36, KEY_WWW },
+	{ KE_KEY, 0x37, KEY_SCREEN }, /* Display on/off */
+	{ KE_KEY, 0x40, KEY_WLAN },
+	{ KE_KEY, 0x49, KEY_CONFIG },
+	{ KE_KEY, 0x4a, KEY_CLOSE }, /* lid close */
+	{ KE_KEY, 0x4b, KEY_OPEN }, /* lid open */
+	{ KE_KEY, 0x6a, KEY_CONFIG },
+	{ KE_KEY, 0x6d, KEY_POWER },
+	{ KE_KEY, 0x71, KEY_STOPCD },
+	{ KE_KEY, 0x72, KEY_PLAYPAUSE },
+	{ KE_KEY, 0x74, KEY_REWIND },
+	{ KE_KEY, 0x78, KEY_FORWARD },
+	{ KE_WIFI, 0x30, 0 },
+	{ KE_BLUETOOTH, 0x44, 0 },
+	{ KE_END, 0 }
+};
+
 /*
  * If your machine is not here (which is currently rather likely), please send
  * a list of buttons and their key codes (reported when loading this module
@@ -880,15 +916,17 @@ static struct dmi_system_id dmi_ids[] __
 
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

--------------050107000306080404050603--
