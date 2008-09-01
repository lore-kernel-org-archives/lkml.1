Return-Path: <linux-kernel-owner+w=401wt.eu-S1756680AbYIAS1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680AbYIAS1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 14:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751294AbYIAS1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 14:27:08 -0400
Received: from monty.telenet-ops.be ([195.130.132.56]:38968 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbYIAS1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 14:27:06 -0400
Date: Mon, 1 Sep 2008 20:27:02 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] m68k: atari_keyb_init operator precedence fix
Message-ID: <Pine.LNX.4.64.0809012025580.14251@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>

Fix operator precedence bug in atari_keyb_init, which caused a failure on CT60

Signed-off-by: Michael Schmitz <schmitz@debian.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
Please apply for 2.6.27.

 arch/m68k/atari/atakeyb.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/arch/m68k/atari/atakeyb.c
+++ b/arch/m68k/atari/atakeyb.c
@@ -580,13 +580,15 @@ int atari_keyb_init(void)
 	do {
 		/* reset IKBD ACIA */
 		acia.key_ctrl = ACIA_RESET |
-				(atari_switches & ATARI_SWITCH_IKBD) ? ACIA_RHTID : 0;
+				((atari_switches & ATARI_SWITCH_IKBD) ?
+				 ACIA_RHTID : 0);
 		(void)acia.key_ctrl;
 		(void)acia.key_data;
 
 		/* reset MIDI ACIA */
 		acia.mid_ctrl = ACIA_RESET |
-				(atari_switches & ATARI_SWITCH_MIDI) ? ACIA_RHTID : 0;
+				((atari_switches & ATARI_SWITCH_MIDI) ?
+				 ACIA_RHTID : 0);
 		(void)acia.mid_ctrl;
 		(void)acia.mid_data;
 
@@ -599,7 +601,8 @@ int atari_keyb_init(void)
 				 ACIA_RHTID : ACIA_RLTID);
 
 		acia.mid_ctrl = ACIA_DIV16 | ACIA_D8N1S |
-				(atari_switches & ATARI_SWITCH_MIDI) ? ACIA_RHTID : 0;
+				((atari_switches & ATARI_SWITCH_MIDI) ?
+				 ACIA_RHTID : 0);
 
 	/* make sure the interrupt line is up */
 	} while ((mfp.par_dt_reg & 0x10) == 0);

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
