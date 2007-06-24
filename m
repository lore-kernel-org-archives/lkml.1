Return-Path: <linux-kernel-owner+w=401wt.eu-S1756743AbXFXTZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743AbXFXTZj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 15:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753027AbXFXTZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 15:25:30 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:52073 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbXFXTZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 15:25:29 -0400
X-Originating-Ip: 74.102.207.204
Date: Sun, 24 Jun 2007 15:21:37 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>, Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH] Update the alignment for 4K stacks.
Message-ID: <Pine.LNX.4.64.0706241518590.24337@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Just following the advice in the comments, update the alignment when
4K stacks are selected, since gcc 3.0 shouldn't be an issue anymore.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

 arch/i386/kernel/irq.c |    8 ++------
 arch/sh/kernel/irq.c   |    8 ++------
 2 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/arch/i386/kernel/irq.c b/arch/i386/kernel/irq.c
index d2daf67..504f134 100644
--- a/arch/i386/kernel/irq.c
+++ b/arch/i386/kernel/irq.c
@@ -149,15 +149,11 @@ fastcall unsigned int do_IRQ(struct pt_regs *regs)

 #ifdef CONFIG_4KSTACKS

-/*
- * These should really be __section__(".bss.page_aligned") as well, but
- * gcc's 3.0 and earlier don't handle that correctly.
- */
 static char softirq_stack[NR_CPUS * THREAD_SIZE]
-		__attribute__((__aligned__(THREAD_SIZE)));
+		__attribute__((__section__(".bss.page_aligned")));

 static char hardirq_stack[NR_CPUS * THREAD_SIZE]
-		__attribute__((__aligned__(THREAD_SIZE)));
+		__attribute__((__section__(".bss.page_aligned")));

 /*
  * allocate per-cpu stacks for hardirq and for softirq processing
diff --git a/arch/sh/kernel/irq.c b/arch/sh/kernel/irq.c
index 27b923c..2789779 100644
--- a/arch/sh/kernel/irq.c
+++ b/arch/sh/kernel/irq.c
@@ -158,15 +158,11 @@ asmlinkage int do_IRQ(unsigned int irq, struct pt_regs *regs)
 }

 #ifdef CONFIG_4KSTACKS
-/*
- * These should really be __section__(".bss.page_aligned") as well, but
- * gcc's 3.0 and earlier don't handle that correctly.
- */
 static char softirq_stack[NR_CPUS * THREAD_SIZE]
-		__attribute__((__aligned__(THREAD_SIZE)));
+		__attribute__((__section__(".bss.page_aligned")));

 static char hardirq_stack[NR_CPUS * THREAD_SIZE]
-		__attribute__((__aligned__(THREAD_SIZE)));
+		__attribute__((__section__(".bss.page_aligned")));

 /*
  * allocate per-cpu stacks for hardirq and for softirq processing
diff --git a/include/asm-blackfin/macros.h b/include/asm-blackfin/macros.h
deleted file mode 100644
index e69de29..0000000
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
