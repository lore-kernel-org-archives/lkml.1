Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063Ab0CKSnn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 13:43:43 -0500
Received: from relay3.sgi.com ([192.48.152.1]:60759 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757688Ab0CKSnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 13:43:32 -0500
Date: Thu, 11 Mar 2010 12:43:29 -0600
From: Jack Steiner <steiner@sgi.com>
To: mingo@elte.hu, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86, UV: Fix target_cpus() in x2apic_uv_x.c
Message-ID: <20100311184328.GA21433@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

target_cpu() should initially target all cpus, not just cpu 0.
Otherwise systems with lots of disks can exhaust the interrupt
vectors on cpu 0 if a large number of disks are discovered before
the irq balancer is running.

Note: UV code only...


Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 arch/x86/kernel/apic/x2apic_uv_x.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: linux/arch/x86/kernel/apic/x2apic_uv_x.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c	2010-03-11 01:59:36.000000000 -0600
+++ linux/arch/x86/kernel/apic/x2apic_uv_x.c	2010-03-11 12:16:28.000000000 -0600
@@ -120,11 +120,9 @@ EXPORT_SYMBOL_GPL(uv_possible_blades);
 unsigned long sn_rtc_cycles_per_second;
 EXPORT_SYMBOL(sn_rtc_cycles_per_second);
 
-/* Start with all IRQs pointing to boot CPU.  IRQ balancing will shift them. */
-
 static const struct cpumask *uv_target_cpus(void)
 {
-	return cpumask_of(0);
+	return cpu_online_mask;
 }
 
 static void uv_vector_allocation_domain(int cpu, struct cpumask *retmask)
