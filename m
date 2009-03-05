Return-Path: <linux-kernel-owner+w=401wt.eu-S1756240AbZCETeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240AbZCETeo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 14:34:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754734AbZCETef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 14:34:35 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:46417 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700AbZCETee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 14:34:34 -0500
Subject: Re: [PATCH] perfcounters: IRQ and NMI support on AMD CPUs
From: Peter Zijlstra <peterz@infradead.org>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1236279393.3316.13.camel@localhost.localdomain>
References: <1236273633.5187.286.camel@laptop>
	 <1236277959.3316.3.camel@localhost.localdomain>
	 <1236278730.5187.378.camel@laptop>
	 <1236279393.3316.13.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 05 Mar 2009 20:34:21 +0100
Message-Id: <1236281661.5187.432.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-06 at 00:26 +0530, Jaswinder Singh Rajput wrote:

> But kerneltop is still not working and I am not getting any NMI Interrupts.

Does the below work for you?

The BKGD suggests its 48 for all existing machines (it certainly is for
mine).

Index: linux-2.6/arch/x86/kernel/cpu/perf_counter.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_counter.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_counter.c
@@ -959,20 +959,8 @@ static struct pmc_x86_ops *pmc_amd_init(
 
 	nr_counters_generic = 4;
 	nr_counters_fixed = 0;
-	counter_value_mask = ~0ULL;
-
-	rdmsrl(MSR_K7_PERFCTR0, old);
-	wrmsrl(MSR_K7_PERFCTR0, counter_value_mask);
-	/*
-	 * read the truncated mask
-	 */
-	rdmsrl(MSR_K7_PERFCTR0, counter_value_mask);
-	wrmsrl(MSR_K7_PERFCTR0, old);
-
-	bits = 32 + fls(counter_value_mask >> 32);
-	if (bits == 32)
-		bits = fls((u32)counter_value_mask);
-	counter_value_bits = bits;
+	counter_value_mask = 0x0000FFFFFFFFFFFFULL;
+	counter_value_bits = 48;
 
 	pr_info("AMD Performance Monitoring support detected.\n");
 


