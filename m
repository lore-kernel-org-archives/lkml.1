Return-Path: <linux-kernel-owner+w=401wt.eu-S1756614AbZKQWu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614AbZKQWu4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 17:50:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756566AbZKQWu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 17:50:56 -0500
Received: from www.tglx.de ([62.245.132.106]:41516 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756312AbZKQWuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 17:50:55 -0500
Message-Id: <20091117224916.453495043@linutronix.de>
User-Agent: quilt/0.47-1
Date: Tue, 17 Nov 2009 22:50:34 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jeff Dike <jdike@addtoit.com>
Subject: [patch 03/13] um: Fixup last users of irq_chip->typename 
References: <20091117224852.846805939@linutronix.de>
Content-Disposition: inline; filename=um-replace-obsolete-typename.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The typename member of struct irq_chip was kept for migration purposes
and is obsolete since more than 2 years. Fix up the leftovers.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Jeff Dike <jdike@addtoit.com>
---
 arch/um/kernel/irq.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/um/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/um/kernel/irq.c
+++ linux-2.6/arch/um/kernel/irq.c
@@ -45,7 +45,7 @@ int show_interrupts(struct seq_file *p, 
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
 #endif
-		seq_printf(p, " %14s", irq_desc[i].chip->typename);
+		seq_printf(p, " %14s", irq_desc[i].chip->name);
 		seq_printf(p, "  %s", action->name);
 
 		for (action=action->next; action; action = action->next)
@@ -368,7 +368,7 @@ static void dummy(unsigned int irq)
 
 /* This is used for everything else than the timer. */
 static struct irq_chip normal_irq_type = {
-	.typename = "SIGIO",
+	.name = "SIGIO",
 	.release = free_irq_by_irq_and_dev,
 	.disable = dummy,
 	.enable = dummy,
@@ -377,7 +377,7 @@ static struct irq_chip normal_irq_type =
 };
 
 static struct irq_chip SIGVTALRM_irq_type = {
-	.typename = "SIGVTALRM",
+	.name = "SIGVTALRM",
 	.release = free_irq_by_irq_and_dev,
 	.shutdown = dummy, /* never called */
 	.disable = dummy,


