Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267Ab0BXESZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 23:18:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:49653 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754732Ab0BXESY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 23:18:24 -0500
Message-ID: <4B84A846.1000805@kernel.org>
Date: Tue, 23 Feb 2010 20:17:10 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, alek.du@intel.com, jacob.jun.pan@intel.com,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH] x86: remove left over nr_legacy_irqs
References: <43F901BD926A4E43B106BF17856F07559FB80D01@orsmsx508.amr.corp.intel.com> <tip-d39f6495f66616b637260405d0b5dc2656bc490e@git.kernel.org> <4B8493A0.6080501@kernel.org>
In-Reply-To: <4B8493A0.6080501@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



already in legacy_pic

Singed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/irq.h |    1 -
 arch/x86/kernel/irqinit.c  |    7 ++-----
 2 files changed, 2 insertions(+), 6 deletions(-)

Index: linux-2.6/arch/x86/include/asm/irq.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/irq.h
+++ linux-2.6/arch/x86/include/asm/irq.h
@@ -48,6 +48,5 @@ extern DECLARE_BITMAP(used_vectors, NR_V
 extern int vector_used_by_percpu_irq(unsigned int vector);
 
 extern void init_ISA_irqs(void);
-extern int nr_legacy_irqs;
 
 #endif /* _ASM_X86_IRQ_H */
Index: linux-2.6/arch/x86/kernel/irqinit.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/irqinit.c
+++ linux-2.6/arch/x86/kernel/irqinit.c
@@ -99,9 +99,6 @@ int vector_used_by_percpu_irq(unsigned i
 	return 0;
 }
 
-/* Number of legacy interrupts */
-int nr_legacy_irqs __read_mostly = NR_IRQS_LEGACY;
-
 void __init init_ISA_irqs(void)
 {
 	int i;
@@ -114,7 +111,7 @@ void __init init_ISA_irqs(void)
 	/*
 	 * 16 old-style INTA-cycle interrupts:
 	 */
-	for (i = 0; i < NR_IRQS_LEGACY; i++) {
+	for (i = 0; i < legacy_pic->nr_legacy_irqs; i++) {
 		struct irq_desc *desc = irq_to_desc(i);
 
 		desc->status = IRQ_DISABLED;
@@ -138,7 +135,7 @@ void __init init_IRQ(void)
 	 * then this vector space can be freed and re-used dynamically as the
 	 * irq's migrate etc.
 	 */
-	for (i = 0; i < nr_legacy_irqs; i++)
+	for (i = 0; i < legacy_pic->nr_legacy_irqs; i++)
 		per_cpu(vector_irq, 0)[IRQ0_VECTOR + i] = i;
 
 	x86_init.irqs.intr_init();
