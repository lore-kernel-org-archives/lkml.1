Return-Path: <linux-kernel-owner+w=401wt.eu-S1759730AbXKERT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759730AbXKERT6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 12:19:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756833AbXKERIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 12:08:44 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:59564 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757879AbXKERIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 12:08:43 -0500
Date: Mon, 5 Nov 2007 18:08:19 +0100
From: Adrian Bunk <bunk@kernel.org>
To: geert@linux-m68k.org, zippel@linux-m68k.org
Cc: linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org
Subject: [2.6 patch] export atari_keyb_init
Message-ID: <20071105170819.GE12045@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following build error:

<--  snip  -->

...
  MODPOST 25 modules
ERROR: "atari_keyb_init" [drivers/input/mouse/atarimouse.ko] undefined!
ERROR: "atari_keyb_init" [drivers/input/keyboard/atakbd.ko] undefined!
make[2]: *** [__modpost] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/m68k/atari/atakeyb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

5b25e716d9b676d27ebb3d61852e0d96589d974c 
diff --git a/arch/m68k/atari/atakeyb.c b/arch/m68k/atari/atakeyb.c
index 880add1..8a2a53b 100644
--- a/arch/m68k/atari/atakeyb.c
+++ b/arch/m68k/atari/atakeyb.c
@@ -565,7 +565,7 @@ void atari_kbd_leds(unsigned int leds)
 
 static int atari_keyb_done = 0;
 
-int __init atari_keyb_init(void)
+int atari_keyb_init(void)
 {
 	if (atari_keyb_done)
 		return 0;
@@ -631,6 +631,7 @@ int __init atari_keyb_init(void)
 	atari_keyb_done = 1;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(atari_keyb_init);
 
 int atari_kbd_translate(unsigned char keycode, unsigned char *keycodep, char raw_mode)
 {

