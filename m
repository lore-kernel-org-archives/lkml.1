Return-Path: <linux-kernel-owner+w=401wt.eu-S1756649AbZKQWvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649AbZKQWvS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 17:51:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756631AbZKQWvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 17:51:16 -0500
Received: from www.tglx.de ([62.245.132.106]:41546 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756623AbZKQWvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 17:51:13 -0500
Message-Id: <20091117224916.604120310@linutronix.de>
User-Agent: quilt/0.47-1
Date: Tue, 17 Nov 2009 22:50:59 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Kyle McMartin <kyle@mcmartin.ca>,
       linux-parisc@vger.kernel.org
Subject: [patch 07/13] parisc: Fixup last users of irq_chip->typename 
References: <20091117224852.846805939@linutronix.de>
Content-Disposition: inline; filename=parisc-replace-obsolete-typename.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The typename member of struct irq_chip was kept for migration purposes
and is obsolete since more than 2 years. Fix up the leftovers.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: linux-parisc@vger.kernel.org
---
 arch/parisc/kernel/irq.c |    4 ++--
 drivers/parisc/dino.c    |    2 +-
 drivers/parisc/eisa.c    |    2 +-
 drivers/parisc/gsc.c     |    2 +-
 drivers/parisc/iosapic.c |    2 +-
 drivers/parisc/superio.c |    2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)

Index: linux-2.6/arch/parisc/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/parisc/kernel/irq.c
+++ linux-2.6/arch/parisc/kernel/irq.c
@@ -145,7 +145,7 @@ static int cpu_set_affinity_irq(unsigned
 #endif
 
 static struct irq_chip cpu_interrupt_type = {
-	.typename	= "CPU",
+	.name		= "CPU",
 	.startup	= cpu_startup_irq,
 	.shutdown	= cpu_disable_irq,
 	.enable		= cpu_enable_irq,
@@ -192,7 +192,7 @@ int show_interrupts(struct seq_file *p, 
 		seq_printf(p, "%10u ", kstat_irqs(i));
 #endif
 
-		seq_printf(p, " %14s", irq_desc[i].chip->typename);
+		seq_printf(p, " %14s", irq_desc[i].chip->name);
 #ifndef PARISC_IRQ_CR16_COUNTS
 		seq_printf(p, "  %s", action->name);
 
Index: linux-2.6/drivers/parisc/dino.c
===================================================================
--- linux-2.6.orig/drivers/parisc/dino.c
+++ linux-2.6/drivers/parisc/dino.c
@@ -354,7 +354,7 @@ static unsigned int dino_startup_irq(uns
 }
 
 static struct irq_chip dino_interrupt_type = {
-	.typename	= "GSC-PCI",
+	.name		= "GSC-PCI",
 	.startup	= dino_startup_irq,
 	.shutdown	= dino_disable_irq,
 	.enable		= dino_enable_irq, 
Index: linux-2.6/drivers/parisc/eisa.c
===================================================================
--- linux-2.6.orig/drivers/parisc/eisa.c
+++ linux-2.6/drivers/parisc/eisa.c
@@ -189,7 +189,7 @@ static unsigned int eisa_startup_irq(uns
 }
 
 static struct irq_chip eisa_interrupt_type = {
-	.typename =	"EISA",
+	.name	 =	"EISA",
 	.startup =	eisa_startup_irq,
 	.shutdown =	eisa_disable_irq,
 	.enable =	eisa_enable_irq,
Index: linux-2.6/drivers/parisc/gsc.c
===================================================================
--- linux-2.6.orig/drivers/parisc/gsc.c
+++ linux-2.6/drivers/parisc/gsc.c
@@ -149,7 +149,7 @@ static unsigned int gsc_asic_startup_irq
 }
 
 static struct irq_chip gsc_asic_interrupt_type = {
-	.typename =	"GSC-ASIC",
+	.name	 =	"GSC-ASIC",
 	.startup =	gsc_asic_startup_irq,
 	.shutdown =	gsc_asic_disable_irq,
 	.enable =	gsc_asic_enable_irq,
Index: linux-2.6/drivers/parisc/iosapic.c
===================================================================
--- linux-2.6.orig/drivers/parisc/iosapic.c
+++ linux-2.6/drivers/parisc/iosapic.c
@@ -730,7 +730,7 @@ static int iosapic_set_affinity_irq(unsi
 #endif
 
 static struct irq_chip iosapic_interrupt_type = {
-	.typename =	"IO-SAPIC-level",
+	.name	 =	"IO-SAPIC-level",
 	.startup =	iosapic_startup_irq,
 	.shutdown =	iosapic_disable_irq,
 	.enable =	iosapic_enable_irq,
Index: linux-2.6/drivers/parisc/superio.c
===================================================================
--- linux-2.6.orig/drivers/parisc/superio.c
+++ linux-2.6/drivers/parisc/superio.c
@@ -326,7 +326,7 @@ static unsigned int superio_startup_irq(
 }
 
 static struct irq_chip superio_interrupt_type = {
-	.typename =	SUPERIO,
+	.name	 =	SUPERIO,
 	.startup =	superio_startup_irq,
 	.shutdown =	superio_disable_irq,
 	.enable =	superio_enable_irq,


