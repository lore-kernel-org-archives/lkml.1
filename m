Return-Path: <linux-kernel-owner+w=401wt.eu-S1945956AbXEAUph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945956AbXEAUph (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 16:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945960AbXEAUm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 16:42:26 -0400
Received: from assei1bl6.telenet-ops.be ([195.130.133.68]:33407 "EHLO
	assei1bl6.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423606AbXEAUe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 16:34:56 -0400
Message-Id: <20070501203331.650510641@mail.of.borg>
References: <20070501203234.252205858@mail.of.borg>
User-Agent: quilt/0.45-1
Date: Tue, 01 May 2007 22:32:42 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [patch 08/33] lockdep: Add missing disable/enable irq variant
Content-Disposition: inline; filename=irq_lockdep.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roman Zippel <zippel@linux-m68k.org>

Add missing disable/enable irq variant

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 include/linux/interrupt.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- linux-m68k-2.6.21.orig/include/linux/interrupt.h
+++ linux-m68k-2.6.21/include/linux/interrupt.h
@@ -185,10 +185,14 @@ static inline int disable_irq_wake(unsig
  * validator need to define the methods below in their asm/irq.h
  * files, under an #ifdef CONFIG_LOCKDEP section.
  */
-# ifndef CONFIG_LOCKDEP
+#ifndef CONFIG_LOCKDEP
 #  define disable_irq_nosync_lockdep(irq)	disable_irq_nosync(irq)
+#  define disable_irq_nosync_lockdep_irqsave(irq, flags) \
+						disable_irq_nosync(irq)
 #  define disable_irq_lockdep(irq)		disable_irq(irq)
 #  define enable_irq_lockdep(irq)		enable_irq(irq)
+#  define enable_irq_lockdep_irqrestore(irq, flags) \
+						enable_irq(irq)
 # endif
 
 #endif /* CONFIG_GENERIC_HARDIRQS */

--
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

