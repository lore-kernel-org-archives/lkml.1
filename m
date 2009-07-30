Return-Path: <linux-kernel-owner+w=401wt.eu-S1753260AbZG3HsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260AbZG3HsP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 03:48:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbZG3HsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 03:48:14 -0400
Received: from tjworld.net ([67.18.187.6]:58960 "EHLO tjworld.net"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752419AbZG3HsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 03:48:14 -0400
X-Greylist: delayed 562 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Jul 2009 03:48:14 EDT
Subject: wistron_btns: support Prestigio Wifi RF kill button over suspend
From: TJ <linux@tjworld.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Bug 346586 <346586@bugs.launchpad.net>
Content-Type: text/plain
Organization: TJworld
Date: Thu, 30 Jul 2009 08:38:50 +0100
Message-Id: <1248939530.3410.10.camel@hephaestion>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've been carrying this patch in Ubuntu since March 2009. I emailed the
upstream maintainer prior to that but there was no reply or action so it
hasn't been pushed upstream as I had expected.

https://launchpad.net/bugs/346586

I wonder if the maintainer field for this module should be changed to
reflect that?

----

The Prestigio 157, an old no-name clone laptop uses input keys very
similar to the Wistron 1557/MS2141 with the addition of BIOS-controlled
wireless radio frequency kill switch.

This patch adds support for the RF kill switch control and adds manual
identification of the model.

The Prestigio does not expose any recognisable identity via dmidecode
and so requires manual selection at module init using

force=1 keymap=prestigio

Signed-off-by: TJ <ubuntu@tjworld.net>

diff --git a/drivers/input/misc/wistron_btns.c b/drivers/input/misc/wistron_btns.c
--- a/drivers/input/misc/wistron_btns.c
+++ b/drivers/input/misc/wistron_btns.c
@@ -611,6 +611,20 @@ static struct key_entry keymap_wistron_generic[] __initdata = {
 	{ KE_END, 0 }
 };
 
+static struct key_entry keymap_prestigio[] __initdata = {
+	{ KE_KEY,  0x11, {KEY_PROG1} },
+	{ KE_KEY,  0x12, {KEY_PROG2} },
+	{ KE_WIFI,  0x30 },
+	{ KE_KEY,  0x22, {KEY_REWIND} },
+	{ KE_KEY,  0x23, {KEY_FORWARD} },
+	{ KE_KEY,  0x24, {KEY_PLAYPAUSE} },
+	{ KE_KEY,  0x25, {KEY_STOPCD} },
+	{ KE_KEY,  0x31, {KEY_MAIL} },
+	{ KE_KEY,  0x36, {KEY_WWW} },
+	{ KE_END,  0 }
+};
+
+
 /*
  * If your machine is not here (which is currently rather likely), please send
  * a list of buttons and their key codes (reported when loading this module
@@ -964,6 +978,10 @@ static int __init select_keymap(void)
 			keymap = keymap_wistron_ms2141;
 		else if (strcmp (keymap_name, "generic") == 0)
 			keymap = keymap_wistron_generic;
+		else if (strcmp (keymap_name, "prestigio") == 0) {
+			keymap = keymap_prestigio;
+			have_wifi = 1;
+		}
 		else {
 			printk(KERN_ERR "wistron_btns: Keymap unknown\n");
 			return -EINVAL;

