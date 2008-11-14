Return-Path: <linux-kernel-owner+w=401wt.eu-S1752677AbYKNHKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbYKNHKe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 02:10:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750821AbYKNHKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 02:10:23 -0500
Received: from harold.telenet-ops.be ([195.130.133.65]:50413 "EHLO
	harold.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbYKNHKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 02:10:22 -0500
Date: Fri, 14 Nov 2008 08:10:19 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] m68k: Fix off-by-one in m68k_setup_user_interrupt()
Message-ID: <Pine.LNX.4.64.0811140809070.18275@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 69961c375288bdab7604e0bb1c8d22999bb8a347 ("[PATCH] m68k/Atari: Interrupt
updates") added a BUG_ON() with an incorrect upper bound comparison, which
causes an early crash on VME boards, where IRQ_USER is 8, cnt is 192 and
NR_IRQS is 200.

Reported-by: Stephen N Chivers <schivers@csc.com.au>
Tested-by: Kars de Jong <jongk@linux-m68k.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: stable@kernel.org
---
 arch/m68k/kernel/ints.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/m68k/kernel/ints.c
+++ b/arch/m68k/kernel/ints.c
@@ -133,7 +133,7 @@ void __init m68k_setup_user_interrupt(un
 {
 	int i;
 
-	BUG_ON(IRQ_USER + cnt >= NR_IRQS);
+	BUG_ON(IRQ_USER + cnt > NR_IRQS);
 	m68k_first_user_vec = vec;
 	for (i = 0; i < cnt; i++)
 		irq_controller[IRQ_USER + i] = &user_irq_controller;

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
