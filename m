Return-Path: <linux-kernel-owner+w=401wt.eu-S1758361AbZEBUEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758361AbZEBUEv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 16:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759585AbZEBUCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 16:02:20 -0400
Received: from www.tglx.de ([62.245.132.106]:58479 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759100AbZEBUCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 16:02:18 -0400
Message-Id: <20090502195926.002769487@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sat, 02 May 2009 20:01:16 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Kyle McMartin <kyle@mcmartin.ca>
Subject: [patch 09/11] parisc: remove obsolete hw_interrupt_type
References: <20090502195607.539955644@linutronix.de>
Content-Disposition: inline;
	filename=parisc-remove-obsolete-hw-interrupt-type.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Convert the last remaining users to struct irq_chip and remove the
define.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
CC: Kyle McMartin <kyle@mcmartin.ca>

---
 arch/parisc/kernel/irq.c |    2 +-
 drivers/parisc/dino.c    |    2 +-
 drivers/parisc/eisa.c    |    2 +-
 drivers/parisc/gsc.c     |    4 ++--
 drivers/parisc/gsc.h     |    2 +-
 drivers/parisc/iosapic.c |    2 +-
 drivers/parisc/superio.c |    2 +-
 7 files changed, 8 insertions(+), 8 deletions(-)

Index: linux-2.6/arch/parisc/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/parisc/kernel/irq.c
+++ linux-2.6/arch/parisc/kernel/irq.c
@@ -140,7 +140,7 @@ static void cpu_set_affinity_irq(unsigne
 }
 #endif
 
-static struct hw_interrupt_type cpu_interrupt_type = {
+static struct irq_chip cpu_interrupt_type = {
 	.typename	= "CPU",
 	.startup	= cpu_startup_irq,
 	.shutdown	= cpu_disable_irq,
Index: linux-2.6/drivers/parisc/dino.c
===================================================================
--- linux-2.6.orig/drivers/parisc/dino.c
+++ linux-2.6/drivers/parisc/dino.c
@@ -353,7 +353,7 @@ static unsigned int dino_startup_irq(uns
 	return 0;
 }
 
-static struct hw_interrupt_type dino_interrupt_type = {
+static struct irq_chip dino_interrupt_type = {
 	.typename	= "GSC-PCI",
 	.startup	= dino_startup_irq,
 	.shutdown	= dino_disable_irq,
Index: linux-2.6/drivers/parisc/eisa.c
===================================================================
--- linux-2.6.orig/drivers/parisc/eisa.c
+++ linux-2.6/drivers/parisc/eisa.c
@@ -188,7 +188,7 @@ static unsigned int eisa_startup_irq(uns
 	return 0;
 }
 
-static struct hw_interrupt_type eisa_interrupt_type = {
+static struct irq_chip eisa_interrupt_type = {
 	.typename =	"EISA",
 	.startup =	eisa_startup_irq,
 	.shutdown =	eisa_disable_irq,
Index: linux-2.6/drivers/parisc/gsc.c
===================================================================
--- linux-2.6.orig/drivers/parisc/gsc.c
+++ linux-2.6/drivers/parisc/gsc.c
@@ -148,7 +148,7 @@ static unsigned int gsc_asic_startup_irq
 	return 0;
 }
 
-static struct hw_interrupt_type gsc_asic_interrupt_type = {
+static struct irq_chip gsc_asic_interrupt_type = {
 	.typename =	"GSC-ASIC",
 	.startup =	gsc_asic_startup_irq,
 	.shutdown =	gsc_asic_disable_irq,
@@ -158,7 +158,7 @@ static struct hw_interrupt_type gsc_asic
 	.end =		no_end_irq,
 };
 
-int gsc_assign_irq(struct hw_interrupt_type *type, void *data)
+int gsc_assign_irq(struct irq_chip *type, void *data)
 {
 	static int irq = GSC_IRQ_BASE;
 	struct irq_desc *desc;
Index: linux-2.6/drivers/parisc/gsc.h
===================================================================
--- linux-2.6.orig/drivers/parisc/gsc.h
+++ linux-2.6/drivers/parisc/gsc.h
@@ -38,7 +38,7 @@ struct gsc_asic {
 int gsc_common_setup(struct parisc_device *parent, struct gsc_asic *gsc_asic);
 int gsc_alloc_irq(struct gsc_irq *dev);			/* dev needs an irq */
 int gsc_claim_irq(struct gsc_irq *dev, int irq);	/* dev needs this irq */
-int gsc_assign_irq(struct hw_interrupt_type *type, void *data);
+int gsc_assign_irq(struct irq_chip *type, void *data);
 int gsc_find_local_irq(unsigned int irq, int *global_irq, int limit);
 void gsc_fixup_irqs(struct parisc_device *parent, void *ctrl,
 		void (*choose)(struct parisc_device *child, void *ctrl));
Index: linux-2.6/drivers/parisc/iosapic.c
===================================================================
--- linux-2.6.orig/drivers/parisc/iosapic.c
+++ linux-2.6/drivers/parisc/iosapic.c
@@ -725,7 +725,7 @@ static void iosapic_set_affinity_irq(uns
 }
 #endif
 
-static struct hw_interrupt_type iosapic_interrupt_type = {
+static struct irq_chip iosapic_interrupt_type = {
 	.typename =	"IO-SAPIC-level",
 	.startup =	iosapic_startup_irq,
 	.shutdown =	iosapic_disable_irq,
Index: linux-2.6/drivers/parisc/superio.c
===================================================================
--- linux-2.6.orig/drivers/parisc/superio.c
+++ linux-2.6/drivers/parisc/superio.c
@@ -325,7 +325,7 @@ static unsigned int superio_startup_irq(
 	return 0;
 }
 
-static struct hw_interrupt_type superio_interrupt_type = {
+static struct irq_chip superio_interrupt_type = {
 	.typename =	SUPERIO,
 	.startup =	superio_startup_irq,
 	.shutdown =	superio_disable_irq,


