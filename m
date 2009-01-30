Return-Path: <linux-kernel-owner+w=401wt.eu-S1755431AbZA3UH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431AbZA3UH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 15:07:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753977AbZA3UHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 15:07:17 -0500
Received: from relay2.sgi.com ([192.48.179.30]:53983 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753949AbZA3UHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 15:07:16 -0500
Message-ID: <49835DF0.8080407@sgi.com>
Date: Fri, 30 Jan 2009 12:07:12 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [Fwd: [PATCH] voyager: remove duplicate cpu_callin/out_map symbols]
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks James for both of these!

Ingo - should I push these via may cpus4096/for-ingo branch or do you want to 
take them directly?  (I'll forward the second patch following this one.)

I believe they should be pushed up to Linus' tree.

Thanks,
Mike

-------- Original Message --------
Subject: [PATCH] voyager: remove duplicate cpu_callin/out_map symbols
Date: Fri, 30 Jan 2009 18:34:01 +0000
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Mike Travis <travis@sgi.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>

commit c2d1cec1c77f7714672c1efeae075424c929e0d5
Author: Mike Travis <travis@sgi.com>
Date:   Sun Jan 4 05:18:03 2009 -0800

    x86: cleanup remaining cpumask_t ops in smpboot code

Moved the cpu_callin_map and cpu_callout_map symbols from smp boot
local code to cpu/common.c.  However, it forgot to move them for
voyager leading to duplicate symbols in the voyager build.  Fix this by
making voyager use the common symbols.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 arch/x86/mach-voyager/voyager_smp.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
index dcc07d5..b1b1bd3 100644
--- a/arch/x86/mach-voyager/voyager_smp.c
+++ b/arch/x86/mach-voyager/voyager_smp.c
@@ -211,8 +211,6 @@ static __u32 cpu_booted_map;
 static cpumask_t smp_commenced_mask = CPU_MASK_NONE;
 
 /* This is for the new dynamic CPU boot code */
-cpumask_t cpu_callin_map = CPU_MASK_NONE;
-cpumask_t cpu_callout_map = CPU_MASK_NONE;
 
 /* The per processor IRQ masks (these are usually kept in sync) */
 static __u16 vic_irq_mask[NR_CPUS] __cacheline_aligned;
@@ -1750,10 +1748,11 @@ static void __cpuinit voyager_smp_prepare_boot_cpu(void)
 	init_gdt(smp_processor_id());
 	switch_to_new_gdt();
 
-	cpu_set(smp_processor_id(), cpu_online_map);
-	cpu_set(smp_processor_id(), cpu_callout_map);
-	cpu_set(smp_processor_id(), cpu_possible_map);
-	cpu_set(smp_processor_id(), cpu_present_map);
+	cpu_online_map = cpumask_of_cpu(smp_processor_id());
+	cpu_callout_map = cpumask_of_cpu(smp_processor_id());
+	cpu_callin_map = CPU_MASK_NONE;
+	cpu_present_map = cpumask_of_cpu(smp_processor_id());
+
 }
 
 static int __cpuinit voyager_cpu_up(unsigned int cpu)
-- 
1.5.6.6


