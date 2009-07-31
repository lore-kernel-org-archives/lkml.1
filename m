Return-Path: <linux-kernel-owner+w=401wt.eu-S1753106AbZGaVEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106AbZGaVEq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 17:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753035AbZGaVEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 17:04:46 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:54893 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752993AbZGaVEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 17:04:45 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Anders Kaseorg <andersk@ksplice.com>,
       Nelson Elhage <nelhage@ksplice.com>, Tim Abbott <tabbott@ksplice.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Paul Mundt <lethal@linux-sh.org>,
       Chris Zankel <chris@zankel.net>
Subject: [PATCH 2/4] Use macros for .bss.page_aligned section.
Date: Fri, 31 Jul 2009 16:54:22 -0400
Message-Id: <1249073664-29550-3-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249073664-29550-1-git-send-email-tabbott@ksplice.com>
References: <1249073664-29550-1-git-send-email-tabbott@ksplice.com>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the remaining direct references to
.bss.page_aligned in C and assembly code to use the macros in
include/linux/linkage.h.

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Chris Zankel <chris@zankel.net>
Cc: Sam Ravnborg <sam@ravnborg.org>
---
 arch/sh/kernel/irq.c      |    6 ++----
 arch/x86/kernel/head_32.S |    2 +-
 arch/x86/kernel/head_64.S |    2 +-
 arch/xtensa/kernel/head.S |    2 +-
 4 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/sh/kernel/irq.c b/arch/sh/kernel/irq.c
index 3d09062..e8f31a5 100644
--- a/arch/sh/kernel/irq.c
+++ b/arch/sh/kernel/irq.c
@@ -182,11 +182,9 @@ asmlinkage int do_IRQ(unsigned int irq, struct pt_regs *regs)
 }
 
 #ifdef CONFIG_IRQSTACKS
-static char softirq_stack[NR_CPUS * THREAD_SIZE]
-		__attribute__((__section__(".bss.page_aligned")));
+static char softirq_stack[NR_CPUS * THREAD_SIZE] __page_aligned_bss;
 
-static char hardirq_stack[NR_CPUS * THREAD_SIZE]
-		__attribute__((__section__(".bss.page_aligned")));
+static char hardirq_stack[NR_CPUS * THREAD_SIZE] __page_aligned_bss;
 
 /*
  * allocate per-cpu stacks for hardirq and for softirq processing
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 8663afb..6368497 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -610,7 +610,7 @@ ENTRY(initial_code)
 /*
  * BSS section
  */
-.section ".bss.page_aligned","wa"
+__PAGE_ALIGNED_BSS
 	.align PAGE_SIZE_asm
 #ifdef CONFIG_X86_PAE
 swapper_pg_pmd:
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index fa54f78..d0bc0a1 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -418,7 +418,7 @@ ENTRY(phys_base)
 ENTRY(idt_table)
 	.skip IDT_ENTRIES * 16
 
-	.section .bss.page_aligned, "aw", @nobits
+	__PAGE_ALIGNED_BSS
 	.align PAGE_SIZE
 ENTRY(empty_zero_page)
 	.skip PAGE_SIZE
diff --git a/arch/xtensa/kernel/head.S b/arch/xtensa/kernel/head.S
index d9ddc1b..d215adc 100644
--- a/arch/xtensa/kernel/head.S
+++ b/arch/xtensa/kernel/head.S
@@ -235,7 +235,7 @@ should_never_return:
  * BSS section
  */
 	
-.section ".bss.page_aligned", "w"
+__PAGE_ALIGNED_BSS
 #ifdef CONFIG_MMU
 ENTRY(swapper_pg_dir)
 	.fill	PAGE_SIZE, 1, 0
-- 
1.6.3.3

