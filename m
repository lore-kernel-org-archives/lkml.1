Return-Path: <linux-kernel-owner+w=401wt.eu-S1754438AbZFHRja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438AbZFHRja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 13:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750815AbZFHRjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 13:39:23 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:50209 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794AbZFHRjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 13:39:22 -0400
Date: Mon, 8 Jun 2009 10:39:17 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: mingo@elte.hu, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@zytor.com,
       x86@kernel.org, ebiederm@xmission.com, yinghai@kernel.org,
       suresh.b.siddha@intel.com, lcm@us.ibm.com, garyhade@us.ibm.com
Subject: [PATCH] x86/x86_64: warn of -EBUSY returns from
	__assign_irq_vector()
Message-ID: <20090608173917.GA8264@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: helps expose unexpected issues

Since we have seen one case where an unexpected -EBUSY
return from __assign_irq_vector() was included in the
series of events that caused a serious problem
  re: http://lkml.org/lkml/2009/6/2/377
we should warn to help expose similar unexpected issues
in the future.

Signed-off-by: Gary Hade <garyhade@us.ibm.com>

---
 arch/x86/kernel/apic/io_apic.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6.30-rc8/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.30-rc8.orig/arch/x86/kernel/apic/io_apic.c	2009-06-08 09:56:15.000000000 -0700
+++ linux-2.6.30-rc8/arch/x86/kernel/apic/io_apic.c	2009-06-08 09:56:27.000000000 -0700
@@ -1330,8 +1330,10 @@ __assign_irq_vector(int irq, struct irq_
 	int cpu, err;
 	cpumask_var_t tmp_mask;
 
-	if ((cfg->move_in_progress) || cfg->move_cleanup_count)
+	if ((cfg->move_in_progress) || cfg->move_cleanup_count) {
+		WARN_ON_ONCE(1);
 		return -EBUSY;
+	}
 
 	if (!alloc_cpumask_var(&tmp_mask, GFP_ATOMIC))
 		return -ENOMEM;
