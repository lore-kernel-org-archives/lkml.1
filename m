Return-Path: <linux-kernel-owner+w=401wt.eu-S1756148AbZCKAt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148AbZCKAt2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 20:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754827AbZCKArL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 20:47:11 -0400
Received: from www.tglx.de ([62.245.132.106]:40071 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754561AbZCKArK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 20:47:10 -0400
Message-Id: <20090311003236.263019667@linutronix.de>
User-Agent: quilt/0.47-1
Date: Wed, 11 Mar 2009 00:45:54 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org
Subject: [patch 08/18] powerpc: convert obsolete irq_desc_t to struct irq_desc
References: <20090311003204.592133594@linutronix.de>
Content-Disposition: inline;
	filename=powerpc-convert-obsolete-irq-desc-t-typedef.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Convert the last remaining users.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: linuxppc-dev@ozlabs.org
---
 arch/powerpc/kernel/irq.c            |    4 ++--
 arch/powerpc/platforms/iseries/irq.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/powerpc/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/irq.c
+++ linux-2.6/arch/powerpc/kernel/irq.c
@@ -171,7 +171,7 @@ int show_interrupts(struct seq_file *p, 
 {
 	int i = *(loff_t *)v, j;
 	struct irqaction *action;
-	irq_desc_t *desc;
+	struct irq_desc *desc;
 	unsigned long flags;
 
 	if (i == 0) {
@@ -1038,7 +1038,7 @@ arch_initcall(irq_late_init);
 static int virq_debug_show(struct seq_file *m, void *private)
 {
 	unsigned long flags;
-	irq_desc_t *desc;
+	struct irq_desc *desc;
 	const char *p;
 	char none[] = "none";
 	int i;
Index: linux-2.6/arch/powerpc/platforms/iseries/irq.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/iseries/irq.c
+++ linux-2.6/arch/powerpc/platforms/iseries/irq.c
@@ -214,7 +214,7 @@ void __init iSeries_activate_IRQs()
 	unsigned long flags;
 
 	for_each_irq (irq) {
-		irq_desc_t *desc = get_irq_desc(irq);
+		struct irq_desc *desc = get_irq_desc(irq);
 
 		if (desc && desc->chip && desc->chip->startup) {
 			spin_lock_irqsave(&desc->lock, flags);


