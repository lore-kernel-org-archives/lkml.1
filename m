Return-Path: <linux-kernel-owner+w=401wt.eu-S1755906AbYICHVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbYICHVA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 03:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754316AbYICHSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 03:18:23 -0400
Received: from nelson.telenet-ops.be ([195.130.133.66]:55309 "EHLO
	nelson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbYICHSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 03:18:13 -0400
Message-Id: <20080903071742.326285837@mail.of.borg>
References: <20080903071542.615137611@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Wed, 03 Sep 2008 09:15:47 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 5/8] m68k: Remove unused atari_kbd_translate()
Content-Disposition: inline; filename=atari-kill-unused-atari_kbd_translate.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

If CONFIG_VT=n, I get:

| arch/m68k/atari/built-in.o: In function `atari_kbd_translate':
| arch/m68k/atari/atakeyb.c:640: undefined reference to `shift_state'

Just remove atari_kbd_translate(), as it's unused.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/atari/atakeyb.c |   12 ------------
 1 file changed, 12 deletions(-)

--- a/arch/m68k/atari/atakeyb.c
+++ b/arch/m68k/atari/atakeyb.c
@@ -635,15 +635,3 @@ int atari_keyb_init(void)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(atari_keyb_init);
-
-int atari_kbd_translate(unsigned char keycode, unsigned char *keycodep, char raw_mode)
-{
-#ifdef CONFIG_MAGIC_SYSRQ
-	/* ALT+HELP pressed? */
-	if ((keycode == 98) && ((shift_state & 0xff) == 8))
-		*keycodep = 0xff;
-	else
-#endif
-		*keycodep = keycode;
-	return 1;
-}

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

