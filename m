Return-Path: <linux-kernel-owner+w=401wt.eu-S1423448AbXD3Pzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423448AbXD3Pzw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 11:55:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423495AbXD3Pzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 11:55:49 -0400
Received: from ns.suse.de ([195.135.220.2]:45022 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423463AbXD3Pt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 11:49:56 -0400
From: Andi Kleen <ak@suse.de>
References: <20070430549.617098000@suse.de>
In-Reply-To: <20070430549.617098000@suse.de>
To: anil.s.keshavamurthy@intel.com, ak@suse.de, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [22/34] i386: clean up flush_tlb_others fn
Message-Id: <20070430154955.20914151CA@wotan.suse.de>
Date: Mon, 30 Apr 2007 17:49:55 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>

Cleanup flush_tlb_others(), no functional change.

Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/smp.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

Index: linux/arch/i386/kernel/smp.c
===================================================================
--- linux.orig/arch/i386/kernel/smp.c
+++ linux/arch/i386/kernel/smp.c
@@ -375,17 +375,7 @@ void native_flush_tlb_others(const cpuma
 	
 	flush_mm = mm;
 	flush_va = va;
-#if NR_CPUS <= BITS_PER_LONG
-	atomic_set_mask(cpumask, &flush_cpumask);
-#else
-	{
-		int k;
-		unsigned long *flush_mask = (unsigned long *)&flush_cpumask;
-		unsigned long *cpu_mask = (unsigned long *)&cpumask;
-		for (k = 0; k < BITS_TO_LONGS(NR_CPUS); ++k)
-			atomic_set_mask(cpu_mask[k], &flush_mask[k]);
-	}
-#endif
+	cpus_or(flush_cpumask, cpumask, flush_cpumask);
 	/*
 	 * We have to send the IPI only to
 	 * CPUs affected.
