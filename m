Return-Path: <linux-kernel-owner+w=401wt.eu-S1756965AbYDUIwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756965AbYDUIwZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 04:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758479AbYDUIvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 04:51:16 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:41163 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757215AbYDUIvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 04:51:15 -0400
Date: Mon, 21 Apr 2008 11:50:46 +0300
From: Adrian Bunk <bunk@kernel.org>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, James.Bottomley@HansenPartnership.com
Subject: [2.6 patch] x86: make smp_intr_init() static
Message-ID: <20080421085046.GY26897@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global smp_intr_init() static.

To avoid problems, it also renames the voyager one to 
voyager_smp_intr_init().

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/x86/kernel/apic_32.c           |    2 +-
 arch/x86/mach-voyager/setup.c       |    2 +-
 arch/x86/mach-voyager/voyager_smp.c |    2 +-
 include/asm-x86/arch_hooks.h        |    1 -
 4 files changed, 3 insertions(+), 4 deletions(-)

1d594cbfd44430bb4d22ba2a318f493316ca64e5 diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index 8317401..4ddec7f 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -1338,7 +1338,7 @@ void smp_error_interrupt(struct pt_regs *regs)
 }
 
 #ifdef CONFIG_SMP
-void __init smp_intr_init(void)
+static void __init smp_intr_init(void)
 {
 	/*
 	 * IRQ0 must be given a fixed assignment and initialized,
diff --git a/arch/x86/mach-voyager/setup.c b/arch/x86/mach-voyager/setup.c
index 5ae5466..b2dc6e1 100644
--- a/arch/x86/mach-voyager/setup.c
+++ b/arch/x86/mach-voyager/setup.c
@@ -27,7 +27,7 @@ static struct irqaction irq2 = {
 void __init intr_init_hook(void)
 {
 #ifdef CONFIG_SMP
-	smp_intr_init();
+	voyager_smp_intr_init();
 #endif
 
 	setup_irq(2, &irq2);
diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
index be7235b..b145290 100644
--- a/arch/x86/mach-voyager/voyager_smp.c
+++ b/arch/x86/mach-voyager/voyager_smp.c
@@ -1341,7 +1341,7 @@ static void handle_vic_irq(unsigned int irq, struct irq_desc *desc)
 #define QIC_SET_GATE(cpi, vector) \
 	set_intr_gate((cpi) + QIC_DEFAULT_CPI_BASE, (vector))
 
-void __init smp_intr_init(void)
+void __init voyager_smp_intr_init(void)
 {
 	int i;
 
diff --git a/include/asm-x86/arch_hooks.h b/include/asm-x86/arch_hooks.h
index 768aee8..6fe8f61 100644
--- a/include/asm-x86/arch_hooks.h
+++ b/include/asm-x86/arch_hooks.h
@@ -13,7 +13,6 @@
  * that can be used by the hooks */
 extern void init_ISA_irqs(void);
 extern void apic_intr_init(void);
-extern void smp_intr_init(void);
 extern irqreturn_t timer_interrupt(int irq, void *dev_id);
 
 /* these are the defined hooks */

