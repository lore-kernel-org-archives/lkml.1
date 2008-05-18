Return-Path: <linux-kernel-owner+w=401wt.eu-S1763632AbYERTDB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763632AbYERTDB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 15:03:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760841AbYERSyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:54:17 -0400
Received: from wilson.telenet-ops.be ([195.130.132.42]:55421 "EHLO
	wilson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761942AbYERSyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:54:05 -0400
Message-Id: <20080518185153.632525339@mail.of.borg>
References: <20080518184706.631023070@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Sun, 18 May 2008 20:47:22 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 16/18] m68k: Correctly handle multi-ISA at runtime
Content-Disposition: inline; filename=m68k-dynamic-isa.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

m68k: Correctly handle multi-ISA at runtime in multi-platform kernels

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/kernel/setup.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/m68k/kernel/setup.c
+++ b/arch/m68k/kernel/setup.c
@@ -346,17 +346,17 @@ void __init setup_arch(char **cmdline_p)
 
 /* set ISA defs early as possible */
 #if defined(CONFIG_ISA) && defined(MULTI_ISA)
-#if defined(CONFIG_Q40)
 	if (MACH_IS_Q40) {
 		isa_type = ISA_TYPE_Q40;
 		isa_sex = 0;
 	}
-#elif defined(CONFIG_GG2)
+#ifdef CONFIG_GG2
 	if (MACH_IS_AMIGA && AMIGAHW_PRESENT(GG2_ISA)) {
 		isa_type = ISA_TYPE_GG2;
 		isa_sex = 0;
 	}
-#elif defined(CONFIG_AMIGA_PCMCIA)
+#endif
+#ifdef CONFIG_AMIGA_PCMCIA
 	if (MACH_IS_AMIGA && AMIGAHW_PRESENT(PCMCIA)) {
 		isa_type = ISA_TYPE_AG;
 		isa_sex = 1;

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

