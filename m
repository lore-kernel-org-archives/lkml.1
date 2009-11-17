Return-Path: <linux-kernel-owner+w=401wt.eu-S1756661AbZKQWva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661AbZKQWva (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 17:51:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756647AbZKQWv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 17:51:27 -0500
Received: from www.tglx.de ([62.245.132.106]:41571 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756608AbZKQWvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 17:51:25 -0500
Message-Id: <20091117224916.725429771@linutronix.de>
User-Agent: quilt/0.47-1
Date: Tue, 17 Nov 2009 22:51:20 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Mikael Starvik <starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com
Subject: [patch 10/13] cris: Fixup last users of irq_chip->typename 
References: <20091117224852.846805939@linutronix.de>
Content-Disposition: inline; filename=crisr-replace-obsolete-typename.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The typename member of struct irq_chip was kept for migration purposes
and is obsolete since more than 2 years. Fix up the leftovers.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: linux-cris-kernel@axis.com
---
 arch/cris/arch-v10/kernel/irq.c |    2 +-
 arch/cris/arch-v32/kernel/irq.c |    2 +-
 arch/cris/kernel/irq.c          |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/cris/arch-v10/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/cris/arch-v10/kernel/irq.c
+++ linux-2.6/arch/cris/arch-v10/kernel/irq.c
@@ -133,7 +133,7 @@ static void end_crisv10_irq(unsigned int
 }
 
 static struct irq_chip crisv10_irq_type = {
-	.typename =    "CRISv10",
+	.name =        "CRISv10",
 	.startup =     startup_crisv10_irq,
 	.shutdown =    shutdown_crisv10_irq,
 	.enable =      enable_crisv10_irq,
Index: linux-2.6/arch/cris/arch-v32/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/cris/arch-v32/kernel/irq.c
+++ linux-2.6/arch/cris/arch-v32/kernel/irq.c
@@ -336,7 +336,7 @@ int set_affinity_crisv32_irq(unsigned in
 }
 
 static struct irq_chip crisv32_irq_type = {
-	.typename =    "CRISv32",
+	.name =        "CRISv32",
 	.startup =     startup_crisv32_irq,
 	.shutdown =    shutdown_crisv32_irq,
 	.enable =      enable_crisv32_irq,
Index: linux-2.6/arch/cris/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/cris/kernel/irq.c
+++ linux-2.6/arch/cris/kernel/irq.c
@@ -63,7 +63,7 @@ int show_interrupts(struct seq_file *p, 
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
 #endif
-		seq_printf(p, " %14s", irq_desc[i].chip->typename);
+		seq_printf(p, " %14s", irq_desc[i].chip->name);
 		seq_printf(p, "  %s", action->name);
 
 		for (action=action->next; action; action = action->next)


