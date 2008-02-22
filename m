Return-Path: <linux-kernel-owner+w=401wt.eu-S1760755AbYBVUAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760755AbYBVUAV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 15:00:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765511AbYBVT7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 14:59:07 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:52685 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765468AbYBVT7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 14:59:05 -0500
Date: Fri, 22 Feb 2008 21:58:16 +0200
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] proper __do_softirq() prototype
Message-ID: <20080222195816.GD1409@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a proper prototype for __do_softirq() in 
include/linux/interrupt.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/s390/kernel/irq.c    |    2 --
 arch/sh/kernel/irq.c      |    2 --
 arch/x86/kernel/irq_32.c  |    2 --
 include/asm-powerpc/irq.h |    2 --
 include/linux/interrupt.h |    1 +
 5 files changed, 1 insertion(+), 8 deletions(-)

746ab96445cd401fa4cfed6704628ea6efe75d63 diff --git a/arch/s390/kernel/irq.c b/arch/s390/kernel/irq.c
index c36d812..c59a86d 100644
--- a/arch/s390/kernel/irq.c
+++ b/arch/s390/kernel/irq.c
@@ -60,8 +60,6 @@ init_IRQ(void)
 /*
  * Switch to the asynchronous interrupt stack for softirq execution.
  */
-extern void __do_softirq(void);
-
 asmlinkage void do_softirq(void)
 {
 	unsigned long flags, old, new;
diff --git a/arch/sh/kernel/irq.c b/arch/sh/kernel/irq.c
index 9bf19b0..a2a99e4 100644
--- a/arch/sh/kernel/irq.c
+++ b/arch/sh/kernel/irq.c
@@ -200,8 +200,6 @@ void irq_ctx_exit(int cpu)
 	hardirq_ctx[cpu] = NULL;
 }
 
-extern asmlinkage void __do_softirq(void);
-
 asmlinkage void do_softirq(void)
 {
 	unsigned long flags;
diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index cef054b..2af12b3 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -190,8 +190,6 @@ void irq_ctx_exit(int cpu)
 	hardirq_ctx[cpu] = NULL;
 }
 
-extern asmlinkage void __do_softirq(void);
-
 asmlinkage void do_softirq(void)
 {
 	unsigned long flags;
diff --git a/include/asm-powerpc/irq.h b/include/asm-powerpc/irq.h
index b5c0312..5089deb 100644
--- a/include/asm-powerpc/irq.h
+++ b/include/asm-powerpc/irq.h
@@ -619,8 +619,6 @@ struct pt_regs;
 
 #define __ARCH_HAS_DO_SOFTIRQ
 
-extern void __do_softirq(void);
-
 #ifdef CONFIG_IRQSTACKS
 /*
  * Per-cpu stacks for handling hard and soft interrupts.
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index f8ab4ce..8ccc912 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -270,6 +270,7 @@ struct softirq_action
 };
 
 asmlinkage void do_softirq(void);
+asmlinkage void __do_softirq(void);
 extern void open_softirq(int nr, void (*action)(struct softirq_action*), void *data);
 extern void softirq_init(void);
 #define __raise_softirq_irqoff(nr) do { or_softirq_pending(1UL << (nr)); } while (0)

