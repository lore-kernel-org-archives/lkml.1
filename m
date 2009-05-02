Return-Path: <linux-kernel-owner+w=401wt.eu-S1759862AbZEBUCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759862AbZEBUCe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 16:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758145AbZEBUBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 16:01:35 -0400
Received: from www.tglx.de ([62.245.132.106]:55705 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758588AbZEBUBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 16:01:33 -0400
Message-Id: <20090502195925.351428365@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sat, 02 May 2009 20:00:48 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Tony Luck <tony.luck@intel.com>
Subject: [patch 03/11] ia64: remove obsolete irq_desc_t typedef
References: <20090502195607.539955644@linutronix.de>
Content-Disposition: inline;
	filename=ia64-remove-obsolete-irq-desc-t-typedef.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Convert the last remaining users and remove the typedef.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
CC: Tony Luck <tony.luck@intel.com>

---
 arch/ia64/hp/sim/hpsim_irq.c   |    2 +-
 arch/ia64/include/asm/hw_irq.h |    2 +-
 arch/ia64/kernel/iosapic.c     |    6 +++---
 arch/ia64/kernel/irq.c         |    2 +-
 arch/ia64/kernel/irq_ia64.c    |    2 +-
 arch/ia64/kernel/mca.c         |    2 +-
 arch/ia64/kernel/smpboot.c     |    2 +-
 arch/ia64/sn/kernel/irq.c      |    4 ++--
 arch/ia64/xen/irq_xen.c        |    2 +-
 9 files changed, 12 insertions(+), 12 deletions(-)

Index: linux-2.6/arch/ia64/hp/sim/hpsim_irq.c
===================================================================
--- linux-2.6.orig/arch/ia64/hp/sim/hpsim_irq.c
+++ linux-2.6/arch/ia64/hp/sim/hpsim_irq.c
@@ -40,7 +40,7 @@ static struct hw_interrupt_type irq_type
 void __init
 hpsim_irq_init (void)
 {
-	irq_desc_t *idesc;
+	struct irq_desc *idesc;
 	int i;
 
 	for (i = 0; i < NR_IRQS; ++i) {
Index: linux-2.6/arch/ia64/include/asm/hw_irq.h
===================================================================
--- linux-2.6.orig/arch/ia64/include/asm/hw_irq.h
+++ linux-2.6/arch/ia64/include/asm/hw_irq.h
@@ -146,7 +146,7 @@ static inline void ia64_native_resend_ir
  * Default implementations for the irq-descriptor API:
  */
 
-extern irq_desc_t irq_desc[NR_IRQS];
+extern struct irq_desc irq_desc[NR_IRQS];
 
 #ifndef CONFIG_IA64_GENERIC
 static inline ia64_vector __ia64_irq_to_vector(int irq)
Index: linux-2.6/arch/ia64/kernel/iosapic.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/iosapic.c
+++ linux-2.6/arch/ia64/kernel/iosapic.c
@@ -449,7 +449,7 @@ iosapic_startup_edge_irq (unsigned int i
 static void
 iosapic_ack_edge_irq (unsigned int irq)
 {
-	irq_desc_t *idesc = irq_desc + irq;
+	struct irq_desc *idesc = irq_desc + irq;
 
 	irq_complete_move(irq);
 	move_native_irq(irq);
@@ -598,7 +598,7 @@ static int
 register_intr (unsigned int gsi, int irq, unsigned char delivery,
 	       unsigned long polarity, unsigned long trigger)
 {
-	irq_desc_t *idesc;
+	struct irq_desc *idesc;
 	struct hw_interrupt_type *irq_type;
 	int index;
 	struct iosapic_rte_info *rte;
@@ -826,7 +826,7 @@ iosapic_unregister_intr (unsigned int gs
 {
 	unsigned long flags;
 	int irq, index;
-	irq_desc_t *idesc;
+	struct irq_desc *idesc;
 	u32 low32;
 	unsigned long trigger, polarity;
 	unsigned int dest;
Index: linux-2.6/arch/ia64/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/irq.c
+++ linux-2.6/arch/ia64/kernel/irq.c
@@ -130,7 +130,7 @@ unsigned int vectors_in_migration[NR_IRQ
  */
 static void migrate_irqs(void)
 {
-	irq_desc_t *desc;
+	struct irq_desc *desc;
 	int 		irq, new_cpu;
 
 	for (irq=0; irq < NR_IRQS; irq++) {
Index: linux-2.6/arch/ia64/kernel/irq_ia64.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/irq_ia64.c
+++ linux-2.6/arch/ia64/kernel/irq_ia64.c
@@ -627,7 +627,7 @@ static struct irqaction tlb_irqaction = 
 void
 ia64_native_register_percpu_irq (ia64_vector vec, struct irqaction *action)
 {
-	irq_desc_t *desc;
+	struct irq_desc *desc;
 	unsigned int irq;
 
 	irq = vec;
Index: linux-2.6/arch/ia64/kernel/mca.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/mca.c
+++ linux-2.6/arch/ia64/kernel/mca.c
@@ -2093,7 +2093,7 @@ ia64_mca_late_init(void)
 	cpe_poll_timer.function = ia64_mca_cpe_poll;
 
 	{
-		irq_desc_t *desc;
+		struct irq_desc *desc;
 		unsigned int irq;
 
 		if (cpe_vector >= 0) {
Index: linux-2.6/arch/ia64/kernel/smpboot.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/smpboot.c
+++ linux-2.6/arch/ia64/kernel/smpboot.c
@@ -678,7 +678,7 @@ extern void fixup_irqs(void);
 int migrate_platform_irqs(unsigned int cpu)
 {
 	int new_cpei_cpu;
-	irq_desc_t *desc = NULL;
+	struct irq_desc *desc = NULL;
 	const struct cpumask *mask;
 	int 		retval = 0;
 
Index: linux-2.6/arch/ia64/sn/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/ia64/sn/kernel/irq.c
+++ linux-2.6/arch/ia64/sn/kernel/irq.c
@@ -293,7 +293,7 @@ unsigned int sn_local_vector_to_irq(u8 v
 void sn_irq_init(void)
 {
 	int i;
-	irq_desc_t *base_desc = irq_desc;
+	struct irq_desc *base_desc = irq_desc;
 
 	ia64_first_device_vector = IA64_SN2_FIRST_DEVICE_VECTOR;
 	ia64_last_device_vector = IA64_SN2_LAST_DEVICE_VECTOR;
@@ -375,7 +375,7 @@ void sn_irq_fixup(struct pci_dev *pci_de
 	int cpu = nasid_slice_to_cpuid(nasid, slice);
 #ifdef CONFIG_SMP
 	int cpuphys;
-	irq_desc_t *desc;
+	struct irq_desc *desc;
 #endif
 
 	pci_dev_get(pci_dev);
Index: linux-2.6/arch/ia64/xen/irq_xen.c
===================================================================
--- linux-2.6.orig/arch/ia64/xen/irq_xen.c
+++ linux-2.6/arch/ia64/xen/irq_xen.c
@@ -138,7 +138,7 @@ static void
 __xen_register_percpu_irq(unsigned int cpu, unsigned int vec,
 			struct irqaction *action, int save)
 {
-	irq_desc_t *desc;
+	struct irq_desc *desc;
 	int irq = 0;
 
 	if (xen_slab_ready) {


