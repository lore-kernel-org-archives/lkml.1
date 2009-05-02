Return-Path: <linux-kernel-owner+w=401wt.eu-S1760753AbZEBUDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760753AbZEBUDt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 16:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759475AbZEBUCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 16:02:04 -0400
Received: from www.tglx.de ([62.245.132.106]:55717 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759581AbZEBUCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 16:02:01 -0400
Message-Id: <20090502195925.809536254@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sat, 02 May 2009 20:01:06 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Tony Luck <tony.luck@intel.com>
Subject: [patch 07/11] ia64: remove obsolete hw_interrupt_type
References: <20090502195607.539955644@linutronix.de>
Content-Disposition: inline;
	filename=ia64-remove-obsolete-hw-interrupt-type.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Convert the last remaining users to struct irq_chip and remove the
define.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
CC: Tony Luck <tony.luck@intel.com>

---
 arch/ia64/hp/sim/hpsim_irq.c   |    2 +-
 arch/ia64/include/asm/hw_irq.h |    2 +-
 arch/ia64/kernel/iosapic.c     |    2 +-
 arch/ia64/kernel/irq_lsapic.c  |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6/arch/ia64/hp/sim/hpsim_irq.c
===================================================================
--- linux-2.6.orig/arch/ia64/hp/sim/hpsim_irq.c
+++ linux-2.6/arch/ia64/hp/sim/hpsim_irq.c
@@ -26,7 +26,7 @@ hpsim_set_affinity_noop(unsigned int a, 
 {
 }
 
-static struct hw_interrupt_type irq_type_hp_sim = {
+static struct irq_chip irq_type_hp_sim = {
 	.name =		"hpsim",
 	.startup =	hpsim_irq_startup,
 	.shutdown =	hpsim_irq_noop,
Index: linux-2.6/arch/ia64/include/asm/hw_irq.h
===================================================================
--- linux-2.6.orig/arch/ia64/include/asm/hw_irq.h
+++ linux-2.6/arch/ia64/include/asm/hw_irq.h
@@ -106,7 +106,7 @@ extern struct irq_cfg irq_cfg[NR_IRQS];
 #define irq_to_domain(x)	irq_cfg[(x)].domain
 DECLARE_PER_CPU(int[IA64_NUM_VECTORS], vector_irq);
 
-extern struct hw_interrupt_type irq_type_ia64_lsapic;	/* CPU-internal interrupt controller */
+extern struct irq_chip irq_type_ia64_lsapic;	/* CPU-internal interrupt controller */
 
 #ifdef CONFIG_PARAVIRT_GUEST
 #include <asm/paravirt.h>
Index: linux-2.6/arch/ia64/kernel/iosapic.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/iosapic.c
+++ linux-2.6/arch/ia64/kernel/iosapic.c
@@ -599,7 +599,7 @@ register_intr (unsigned int gsi, int irq
 	       unsigned long polarity, unsigned long trigger)
 {
 	struct irq_desc *idesc;
-	struct hw_interrupt_type *irq_type;
+	struct irq_chip *irq_type;
 	int index;
 	struct iosapic_rte_info *rte;
 
Index: linux-2.6/arch/ia64/kernel/irq_lsapic.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/irq_lsapic.c
+++ linux-2.6/arch/ia64/kernel/irq_lsapic.c
@@ -33,7 +33,7 @@ static int lsapic_retrigger(unsigned int
 	return 1;
 }
 
-struct hw_interrupt_type irq_type_ia64_lsapic = {
+struct irq_chip irq_type_ia64_lsapic = {
 	.name =		"LSAPIC",
 	.startup =	lsapic_noop_startup,
 	.shutdown =	lsapic_noop,


