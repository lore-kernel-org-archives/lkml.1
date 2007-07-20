Return-Path: <linux-kernel-owner+w=401wt.eu-S936578AbXGTPfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936578AbXGTPfM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 11:35:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935710AbXGTPc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 11:32:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54392 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935692AbXGTPc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 11:32:58 -0400
From: Andi Kleen <ak@suse.de>
References: <20070720532.949522000@suse.de>
In-Reply-To: <20070720532.949522000@suse.de>
To: kaos@ocs.com.au, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [7/11] i386: Do not include other cpus' interrupt 0 in nmi_watchdog
Message-Id: <20070720153251.B288814E7B@wotan.suse.de>
Date: Fri, 20 Jul 2007 17:32:51 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Keith Owens <kaos@ocs.com.au>
kstat_irqs(0) includes the count of interrupt 0 from all cpus, not just
the current cpu.  The updated interrupt 0 on other cpus can stop the
nmi_watchdog from tripping, so only include the current cpu's int 0.

Signed-off-by: Keith Owens <kaos@ocs.com.au>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/nmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/i386/kernel/nmi.c
===================================================================
--- linux.orig/arch/i386/kernel/nmi.c
+++ linux/arch/i386/kernel/nmi.c
@@ -353,7 +353,7 @@ __kprobes int nmi_watchdog_tick(struct p
 	 * Take the local apic timer and PIT/HPET into account. We don't
 	 * know which one is active, when we have highres/dyntick on
 	 */
-	sum = per_cpu(irq_stat, cpu).apic_timer_irqs + kstat_irqs(0);
+	sum = per_cpu(irq_stat, cpu).apic_timer_irqs + kstat_cpu(cpu).irqs[0];
 
 	/* if the none of the timers isn't firing, this cpu isn't doing much */
 	if (!touched && last_irq_sums[cpu] == sum) {
