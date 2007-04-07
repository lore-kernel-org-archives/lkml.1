Return-Path: <linux-kernel-owner+w=401wt.eu-S933552AbXDGAMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933552AbXDGAMw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 20:12:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933572AbXDGAMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 20:12:52 -0400
Received: from mga03.intel.com ([143.182.124.21]:17699 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933552AbXDGAMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 20:12:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,383,1170662400"; 
   d="scan'208"; a="209504639:sNHT23831668"
Date: Fri, 6 Apr 2007 17:11:41 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: akpm@osdl.org
Subject: [PATCH] Cleanup flush_tlb_others fn
Message-ID: <20070407001140.GB3545@linux-os.sc.intel.com>
Reply-To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Cleanup flush_tlb_others(), no functional change.

Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>

---
 arch/i386/kernel/smp.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

Index: work/arch/i386/kernel/smp.c
===================================================================
--- work.orig/arch/i386/kernel/smp.c
+++ work/arch/i386/kernel/smp.c
@@ -379,17 +379,7 @@ static void flush_tlb_others(cpumask_t c
 	
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
