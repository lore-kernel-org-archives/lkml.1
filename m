Return-Path: <linux-kernel-owner+w=401wt.eu-S1757474AbYDUN0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474AbYDUN0V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 09:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759997AbYDUNTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 09:19:17 -0400
Received: from el-out-1112.google.com ([209.85.162.183]:25531 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757885AbYDUNTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 09:19:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:in-reply-to:references:date:subject:cc:from;
        b=M07wkEizY5Q5dNDB243Lt1+nUXo5Omjkr3AiCBkWRgHKDSeGs4qeAhHujbWggnAy8ywTPa+DdTM1dbRs2HJDx7G7Va+dzy3MebzGS8p2Nrfk1TsEse2jPXEBXtY2rtBqJNydespViGHP1yuI0OBFKiKhJldYf+2NymK91l1JokY=
Message-Id: <7f5974f26d90fc2dc57b8bab18cf60732e3c0b3d.1208783694.git.dmitry.torokhov@gmail.com>
In-Reply-To: <cover.1208783694.git.dmitry.torokhov@gmail.com>
References: <cover.1208783694.git.dmitry.torokhov@gmail.com>
Date: Fri, 18 Apr 2008 00:24:42 -0400
Subject: [PATCH 34/37] Input: add MODULE_ALIAS() to hotpluggable platform modules
Cc: linux-kernel@vger.kernel.org, jkosina@suse.cz, akpm@linux-foundation.org
From: Kay Sievers <dmitry.torokhov@gmail.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 43cc71eed1250755986da4c0f9898f9a635cb3bf, the platform modalias
is prefixed with "platform:". Add MODULE_ALIAS() to the hotpluggable
"input" platform drivers, to re-enable auto loading.

[dbrownell@users.sourceforge.net: more drivers, registration fixes]
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/input/keyboard/aaed2000_kbd.c     |    4 ++++
 drivers/input/keyboard/bf54x-keys.c       |    2 ++
 drivers/input/keyboard/corgikbd.c         |    2 ++
 drivers/input/keyboard/gpio_keys.c        |    2 ++
 drivers/input/keyboard/jornada680_kbd.c   |    2 ++
 drivers/input/keyboard/jornada720_kbd.c   |    4 ++++
 drivers/input/keyboard/omap-keypad.c      |    2 ++
 drivers/input/keyboard/pxa27x_keypad.c    |    4 ++++
 drivers/input/keyboard/spitzkbd.c         |    1 +
 drivers/input/keyboard/tosakbd.c          |    2 ++
 drivers/input/misc/cobalt_btns.c          |    3 +++
 drivers/input/mouse/gpio_mouse.c          |    4 ++++
 drivers/input/serio/rpckbd.c              |    2 ++
 drivers/input/touchscreen/corgi_ts.c      |    2 ++
 drivers/input/touchscreen/jornada720_ts.c |    4 ++++
 15 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/drivers/input/keyboard/aaed2000_kbd.c b/drivers/input/keyboard/aaed2000_kbd.c
index 72abc19..a293e8b 100644
--- a/drivers/input/keyboard/aaed2000_kbd.c
+++ b/drivers/input/keyboard/aaed2000_kbd.c
@@ -156,11 +156,15 @@ static int __devexit aaedkbd_remove(struct platform_device *pdev)
 	return 0;
 }
 
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:aaed2000-keyboard");
+
 static struct platform_driver aaedkbd_driver = {
 	.probe		= aaedkbd_probe,
 	.remove		= __devexit_p(aaedkbd_remove),
 	.driver		= {
 		.name	= "aaed2000-keyboard",
+		.owner	= THIS_MODULE,
 	},
 };
 
diff --git a/drivers/input/keyboard/bf54x-keys.c b/drivers/input/keyboard/bf54x-keys.c
index 05e3494..d87ac33 100644
--- a/drivers/input/keyboard/bf54x-keys.c
+++ b/drivers/input/keyboard/bf54x-keys.c
@@ -359,6 +359,7 @@ struct platform_driver bfin_kpad_device_driver = {
 	.remove		= __devexit_p(bfin_kpad_remove),
 	.driver		= {
 		.name	= DRV_NAME,
+		.owner	= THIS_MODULE,
 	}
 };
 
@@ -378,3 +379,4 @@ module_exit(bfin_kpad_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
 MODULE_DESCRIPTION("Keypad driver for BF54x Processors");
+MODULE_ALIAS("platform:bf54x-keys");
diff --git a/drivers/input/keyboard/corgikbd.c b/drivers/input/keyboard/corgikbd.c
index 790fed3..5187c0c 100644
--- a/drivers/input/keyboard/corgikbd.c
+++ b/drivers/input/keyboard/corgikbd.c
@@ -392,6 +392,7 @@ static struct platform_driver corgikbd_driver = {
 	.resume		= corgikbd_resume,
 	.driver		= {
 		.name	= "corgi-keyboard",
+		.owner	= THIS_MODULE,
 	},
 };
 
@@ -411,3 +412,4 @@ module_exit(corgikbd_exit);
 MODULE_AUTHOR("Richard Purdie <rpurdie@rpsys.net>");
 MODULE_DESCRIPTION("Corgi Keyboard Driver");
 MODULE_LICENSE("GPLv2");
+MODULE_ALIAS("platform:corgi-keyboard");
diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gpio_keys.c
index a54dc15..bbd00c3 100644
--- a/drivers/input/keyboard/gpio_keys.c
+++ b/drivers/input/keyboard/gpio_keys.c
@@ -214,6 +214,7 @@ struct platform_driver gpio_keys_device_driver = {
 	.resume		= gpio_keys_resume,
 	.driver		= {
 		.name	= "gpio-keys",
+		.owner	= THIS_MODULE,
 	}
 };
 
@@ -233,3 +234,4 @@ module_exit(gpio_keys_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Phil Blundell <pb@handhelds.org>");
 MODULE_DESCRIPTION("Keyboard driver for CPU GPIOs");
+MODULE_ALIAS("platform:gpio-keys");
diff --git a/drivers/input/keyboard/jornada680_kbd.c b/drivers/input/keyboard/jornada680_kbd.c
index a23633a..9387da3 100644
--- a/drivers/input/keyboard/jornada680_kbd.c
+++ b/drivers/input/keyboard/jornada680_kbd.c
@@ -254,6 +254,7 @@ static int __devexit jornada680kbd_remove(struct platform_device *pdev)
 static struct platform_driver jornada680kbd_driver = {
 	.driver	= {
 		.name	= "jornada680_kbd",
+		.owner	= THIS_MODULE,
 	},
 	.probe	= jornada680kbd_probe,
 	.remove	= __devexit_p(jornada680kbd_remove),
@@ -275,3 +276,4 @@ module_exit(jornada680kbd_exit);
 MODULE_AUTHOR("Kristoffer Ericson <kristoffer.ericson@gmail.com>");
 MODULE_DESCRIPTION("HP Jornada 620/660/680/690 Keyboard Driver");
 MODULE_LICENSE("GPLv2");
+MODULE_ALIAS("platform:jornada680_kbd");
diff --git a/drivers/input/keyboard/jornada720_kbd.c b/drivers/input/keyboard/jornada720_kbd.c
index 986f93c..a1164a0 100644
--- a/drivers/input/keyboard/jornada720_kbd.c
+++ b/drivers/input/keyboard/jornada720_kbd.c
@@ -162,9 +162,13 @@ static int __devexit jornada720_kbd_remove(struct platform_device *pdev)
 	return 0;
 }
 
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:jornada720_kbd");
+
 static struct platform_driver jornada720_kbd_driver = {
 	.driver  = {
 		.name    = "jornada720_kbd",
+		.owner	= THIS_MODULE,
 	 },
 	.probe   = jornada720_kbd_probe,
 	.remove  = __devexit_p(jornada720_kbd_remove),
diff --git a/drivers/input/keyboard/omap-keypad.c b/drivers/input/keyboard/omap-keypad.c
index eec3281..10afd20 100644
--- a/drivers/input/keyboard/omap-keypad.c
+++ b/drivers/input/keyboard/omap-keypad.c
@@ -467,6 +467,7 @@ static struct platform_driver omap_kp_driver = {
 	.resume		= omap_kp_resume,
 	.driver		= {
 		.name	= "omap-keypad",
+		.owner	= THIS_MODULE,
 	},
 };
 
@@ -487,3 +488,4 @@ module_exit(omap_kp_exit);
 MODULE_AUTHOR("Timo Teräs");
 MODULE_DESCRIPTION("OMAP Keypad Driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:omap-keypad");
diff --git a/drivers/input/keyboard/pxa27x_keypad.c b/drivers/input/keyboard/pxa27x_keypad.c
index 4e651c1..3dea0c5 100644
--- a/drivers/input/keyboard/pxa27x_keypad.c
+++ b/drivers/input/keyboard/pxa27x_keypad.c
@@ -545,6 +545,9 @@ static int __devexit pxa27x_keypad_remove(struct platform_device *pdev)
 	return 0;
 }
 
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:pxa27x-keypad");
+
 static struct platform_driver pxa27x_keypad_driver = {
 	.probe		= pxa27x_keypad_probe,
 	.remove		= __devexit_p(pxa27x_keypad_remove),
@@ -552,6 +555,7 @@ static struct platform_driver pxa27x_keypad_driver = {
 	.resume		= pxa27x_keypad_resume,
 	.driver		= {
 		.name	= "pxa27x-keypad",
+		.owner	= THIS_MODULE,
 	},
 };
 
diff --git a/drivers/input/keyboard/spitzkbd.c b/drivers/input/keyboard/spitzkbd.c
index 1d59a2d..92102f9 100644
--- a/drivers/input/keyboard/spitzkbd.c
+++ b/drivers/input/keyboard/spitzkbd.c
@@ -494,3 +494,4 @@ module_exit(spitzkbd_exit);
 MODULE_AUTHOR("Richard Purdie <rpurdie@rpsys.net>");
 MODULE_DESCRIPTION("Spitz Keyboard Driver");
 MODULE_LICENSE("GPLv2");
+MODULE_ALIAS("platform:spitz-keyboard");
diff --git a/drivers/input/keyboard/tosakbd.c b/drivers/input/keyboard/tosakbd.c
index a247006..94e444b 100644
--- a/drivers/input/keyboard/tosakbd.c
+++ b/drivers/input/keyboard/tosakbd.c
@@ -409,6 +409,7 @@ static struct platform_driver tosakbd_driver = {
 	.resume		= tosakbd_resume,
 	.driver		= {
 		.name	= "tosa-keyboard",
+		.owner	= THIS_MODULE,
 	},
 };
 
@@ -428,3 +429,4 @@ module_exit(tosakbd_exit);
 MODULE_AUTHOR("Dirk Opfer <Dirk@Opfer-Online.de>");
 MODULE_DESCRIPTION("Tosa Keyboard Driver");
 MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:tosa-keyboard");
diff --git a/drivers/input/misc/cobalt_btns.c b/drivers/input/misc/cobalt_btns.c
index 5511ef0..6a1f48b 100644
--- a/drivers/input/misc/cobalt_btns.c
+++ b/drivers/input/misc/cobalt_btns.c
@@ -148,6 +148,9 @@ static int __devexit cobalt_buttons_remove(struct platform_device *pdev)
 	return 0;
 }
 
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:Cobalt buttons");
+
 static struct platform_driver cobalt_buttons_driver = {
 	.probe	= cobalt_buttons_probe,
 	.remove	= __devexit_p(cobalt_buttons_remove),
diff --git a/drivers/input/mouse/gpio_mouse.c b/drivers/input/mouse/gpio_mouse.c
index 0936d6b..3392901 100644
--- a/drivers/input/mouse/gpio_mouse.c
+++ b/drivers/input/mouse/gpio_mouse.c
@@ -171,10 +171,14 @@ static int __devexit gpio_mouse_remove(struct platform_device *pdev)
 	return 0;
 }
 
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:gpio_mouse");
+
 struct platform_driver gpio_mouse_device_driver = {
 	.remove		= __devexit_p(gpio_mouse_remove),
 	.driver		= {
 		.name	= "gpio_mouse",
+		.owner	= THIS_MODULE,
 	}
 };
 
diff --git a/drivers/input/serio/rpckbd.c b/drivers/input/serio/rpckbd.c
index 49f8431..34c59d9 100644
--- a/drivers/input/serio/rpckbd.c
+++ b/drivers/input/serio/rpckbd.c
@@ -45,6 +45,7 @@
 MODULE_AUTHOR("Vojtech Pavlik, Russell King");
 MODULE_DESCRIPTION("Acorn RiscPC PS/2 keyboard controller driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:kart");
 
 static int rpckbd_write(struct serio *port, unsigned char val)
 {
@@ -140,6 +141,7 @@ static struct platform_driver rpckbd_driver = {
 	.remove		= __devexit_p(rpckbd_remove),
 	.driver		= {
 		.name	= "kart",
+		.owner	= THIS_MODULE,
 	},
 };
 
diff --git a/drivers/input/touchscreen/corgi_ts.c b/drivers/input/touchscreen/corgi_ts.c
index 99d92f5..765e964 100644
--- a/drivers/input/touchscreen/corgi_ts.c
+++ b/drivers/input/touchscreen/corgi_ts.c
@@ -361,6 +361,7 @@ static struct platform_driver corgits_driver = {
 	.resume		= corgits_resume,
 	.driver		= {
 		.name	= "corgi-ts",
+		.owner	= THIS_MODULE,
 	},
 };
 
@@ -380,3 +381,4 @@ module_exit(corgits_exit);
 MODULE_AUTHOR("Richard Purdie <rpurdie@rpsys.net>");
 MODULE_DESCRIPTION("Corgi TouchScreen Driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:corgi-ts");
diff --git a/drivers/input/touchscreen/jornada720_ts.c b/drivers/input/touchscreen/jornada720_ts.c
index 42a1c9a..7422421 100644
--- a/drivers/input/touchscreen/jornada720_ts.c
+++ b/drivers/input/touchscreen/jornada720_ts.c
@@ -160,11 +160,15 @@ static int __devexit jornada720_ts_remove(struct platform_device *pdev)
 	return 0;
 }
 
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:jornada_ts");
+
 static struct platform_driver jornada720_ts_driver = {
 	.probe		= jornada720_ts_probe,
 	.remove		= __devexit_p(jornada720_ts_remove),
 	.driver		= {
 		.name	= "jornada_ts",
+		.owner	= THIS_MODULE,
 	},
 };
 
-- 
1.5.5.rc2.6.gf58d


