Return-Path: <linux-kernel-owner+w=401wt.eu-S1754980AbXKRKNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980AbXKRKNS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 05:13:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751996AbXKRKMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 05:12:47 -0500
Received: from astra.telenet-ops.be ([195.130.132.58]:49746 "EHLO
	astra.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbXKRKMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 05:12:44 -0500
Message-Id: <20071118101155.611569042@mail.of.borg>
References: <20071118101002.730422886@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Sun, 18 Nov 2007 11:10:03 +0100
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>
Subject: [patch 1/3] m68k: export atari_keyb_init
Content-Disposition: inline; filename=atari-export-atari_keyb_init.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>

m68k: export atari_keyb_init

This patch fixes the following build error:

<--  snip  -->

..
  MODPOST 25 modules
ERROR: "atari_keyb_init" [drivers/input/mouse/atarimouse.ko] undefined!
ERROR: "atari_keyb_init" [drivers/input/keyboard/atakbd.ko] undefined!
make[2]: *** [__modpost] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/atari/atakeyb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

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

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

