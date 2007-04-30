Return-Path: <linux-kernel-owner+w=401wt.eu-S1423487AbXD3Pvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423487AbXD3Pvs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 11:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423432AbXD3PuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 11:50:14 -0400
Received: from ns1.suse.de ([195.135.220.2]:45075 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423482AbXD3PuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 11:50:06 -0400
From: Andi Kleen <ak@suse.de>
References: <20070430549.617098000@suse.de>
In-Reply-To: <20070430549.617098000@suse.de>
To: akpm@linux-foundation.org, ak@suse.de, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [32/34] x86_64: unexport cpu_llc_id
Message-Id: <20070430155005.BFF61151CA@wotan.suse.de>
Date: Mon, 30 Apr 2007 17:50:05 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Andrew Morton <akpm@linux-foundation.org>

WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data:cpu_llc_id from __ksymtab between '__ksymtab_cpu_llc_id' (at offset 0x4a0) and '__ksymtab_smp_num_siblings'

It is strange to export a __cpuinitdata symbols to modules, and no module
appears to use it anyway.

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/x86_64/kernel/smpboot.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux/arch/x86_64/kernel/smpboot.c
===================================================================
--- linux.orig/arch/x86_64/kernel/smpboot.c
+++ linux/arch/x86_64/kernel/smpboot.c
@@ -67,7 +67,6 @@ EXPORT_SYMBOL(smp_num_siblings);
 
 /* Last level cache ID of each logical CPU */
 u8 cpu_llc_id[NR_CPUS] __cpuinitdata  = {[0 ... NR_CPUS-1] = BAD_APICID};
-EXPORT_SYMBOL(cpu_llc_id);
 
 /* Bitmask of currently online CPUs */
 cpumask_t cpu_online_map __read_mostly;
