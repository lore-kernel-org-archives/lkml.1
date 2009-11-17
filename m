Return-Path: <linux-kernel-owner+w=401wt.eu-S1756699AbZKQWwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699AbZKQWwF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 17:52:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756668AbZKQWwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 17:52:01 -0500
Received: from www.tglx.de ([62.245.132.106]:41622 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756644AbZKQWv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 17:51:58 -0500
Message-Id: <20091117224916.491090342@linutronix.de>
User-Agent: quilt/0.47-1
Date: Tue, 17 Nov 2009 22:50:40 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "David S. Miller" <davem@davemloft.net>,
       sparclinux@vger.kernel.org
Subject: [patch 04/13] sparc: Fixup last users of irq_chip->typename 
References: <20091117224852.846805939@linutronix.de>
Content-Disposition: inline; filename=sparc-replace-obsolete-typename.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The typename member of struct irq_chip was kept for migration purposes
and is obsolete since more than 2 years. Fix up the leftovers.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org
---
 arch/sparc/kernel/irq_64.c  |    8 ++++----
 arch/sparc/kernel/pci_msi.c |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6/arch/sparc/kernel/irq_64.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/irq_64.c
+++ linux-2.6/arch/sparc/kernel/irq_64.c
@@ -187,7 +187,7 @@ int show_interrupts(struct seq_file *p, 
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
 #endif
-		seq_printf(p, " %9s", irq_desc[i].chip->typename);
+		seq_printf(p, " %9s", irq_desc[i].chip->name);
 		seq_printf(p, "  %s", action->name);
 
 		for (action=action->next; action; action = action->next)
@@ -484,7 +484,7 @@ static void sun4v_virq_eoi(unsigned int 
 }
 
 static struct irq_chip sun4u_irq = {
-	.typename	= "sun4u",
+	.name		= "sun4u",
 	.enable		= sun4u_irq_enable,
 	.disable	= sun4u_irq_disable,
 	.eoi		= sun4u_irq_eoi,
@@ -492,7 +492,7 @@ static struct irq_chip sun4u_irq = {
 };
 
 static struct irq_chip sun4v_irq = {
-	.typename	= "sun4v",
+	.name		= "sun4v",
 	.enable		= sun4v_irq_enable,
 	.disable	= sun4v_irq_disable,
 	.eoi		= sun4v_irq_eoi,
@@ -500,7 +500,7 @@ static struct irq_chip sun4v_irq = {
 };
 
 static struct irq_chip sun4v_virq = {
-	.typename	= "vsun4v",
+	.name		= "vsun4v",
 	.enable		= sun4v_virq_enable,
 	.disable	= sun4v_virq_disable,
 	.eoi		= sun4v_virq_eoi,
Index: linux-2.6/arch/sparc/kernel/pci_msi.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/pci_msi.c
+++ linux-2.6/arch/sparc/kernel/pci_msi.c
@@ -112,7 +112,7 @@ static void free_msi(struct pci_pbm_info
 }
 
 static struct irq_chip msi_irq = {
-	.typename	= "PCI-MSI",
+	.name		= "PCI-MSI",
 	.mask		= mask_msi_irq,
 	.unmask		= unmask_msi_irq,
 	.enable		= unmask_msi_irq,


