Return-Path: <linux-kernel-owner+w=401wt.eu-S1755083AbZLBAyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083AbZLBAyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 19:54:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755068AbZLBAyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 19:54:43 -0500
Received: from mga03.intel.com ([143.182.124.21]:36667 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754997AbZLBAyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 19:54:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="217704787"
Message-Id: <20091201233335.232177348@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Tue, 01 Dec 2009 15:31:18 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>, hpa@zytor.com, mingo@elte.hu,
       tglx@linutronix.de, ebiederm@xmission.com, garyhade@us.ibm.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 4/4] x86: remove unnecessary mdelay() from cpu_disable_common()
References: <20091201233334.975416130@sbs-t61.sc.intel.com>
Content-Disposition: inline; filename=fix_cpu_disable_mdelay.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixup_irqs() already has a mdelay(). Remove the extra and unnecessary mdelay()
from cpu_disable_common()

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/kernel/smpboot.c |    9 ---------
 1 file changed, 9 deletions(-)

Index: tip/arch/x86/kernel/smpboot.c
===================================================================
--- tip.orig/arch/x86/kernel/smpboot.c
+++ tip/arch/x86/kernel/smpboot.c
@@ -1250,16 +1250,7 @@ static void __ref remove_cpu_from_maps(i
 void cpu_disable_common(void)
 {
 	int cpu = smp_processor_id();
-	/*
-	 * HACK:
-	 * Allow any queued timer interrupts to get serviced
-	 * This is only a temporary solution until we cleanup
-	 * fixup_irqs as we do for IA64.
-	 */
-	local_irq_enable();
-	mdelay(1);
 
-	local_irq_disable();
 	remove_siblinginfo(cpu);
 
 	/* It's now safe to remove this processor from the online map */


