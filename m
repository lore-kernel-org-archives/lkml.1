Return-Path: <linux-kernel-owner+w=401wt.eu-S1757319AbYJMUIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319AbYJMUIb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 16:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754525AbYJMUFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 16:05:49 -0400
Received: from harold.telenet-ops.be ([195.130.133.65]:45029 "EHLO
	harold.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015AbYJMUFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 16:05:40 -0400
Message-Id: <20081013195916.841528410@mail.of.borg>
References: <20081013195846.674654386@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Mon, 13 Oct 2008 21:58:54 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Michael Schmitz <schmitz@debian.org>
Subject: [patch 08/18] m68k: Remove unused atari_kbd_translate()
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
Acked-by: Michael Schmitz <schmitz@debian.org>
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

