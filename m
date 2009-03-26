Return-Path: <linux-kernel-owner+w=401wt.eu-S1755287AbZCZIyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbZCZIyx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 04:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbZCZIyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 04:54:43 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:60686 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbZCZIym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 04:54:42 -0400
Date: Thu, 26 Mar 2009 09:54:37 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org
Subject: [PATCH] m68k: irq_node.handler() should return irqreturn_t
Message-ID: <Pine.LNX.4.64.0903260953180.21047@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit b5dc7840b3ebe9c7967dd8ba73db957767009ff9 ("m68k: introduce irq
controller") reverted the return type of struct irq_node.handler() from
irqreturn_t to int. Change it back to irqreturn_t, else it will give a
compiler warning when irqreturn_t is turned into an enum in the near future:

| arch/m68k/kernel/ints.c:231: warning: assignment from incompatible pointer type

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
We already hit the warning in linux-next, which has commit
bedd30d986a05e32dc3eab874e4b9ed8a38058bb ("genirq: make irqreturn_t an enum")

 arch/m68k/include/asm/irq_mm.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/m68k/include/asm/irq_mm.h b/arch/m68k/include/asm/irq_mm.h
index 226bfc0..0cab42c 100644
--- a/arch/m68k/include/asm/irq_mm.h
+++ b/arch/m68k/include/asm/irq_mm.h
@@ -3,6 +3,7 @@
 
 #include <linux/linkage.h>
 #include <linux/hardirq.h>
+#include <linux/irqreturn.h>
 #include <linux/spinlock_types.h>
 
 /*
@@ -80,7 +81,7 @@ struct pt_regs;
  * interrupt source (if it supports chaining).
  */
 typedef struct irq_node {
-	int		(*handler)(int, void *);
+	irqreturn_t	(*handler)(int, void *);
 	void		*dev_id;
 	struct irq_node *next;
 	unsigned long	flags;
-- 
1.6.2


Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
