Return-Path: <linux-kernel-owner+w=401wt.eu-S933046AbXILB5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933046AbXILB5K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 21:57:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761568AbXILB4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 21:56:49 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:48642 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753115AbXILB4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 21:56:47 -0400
Message-Id: <20070912015645.290833956@sgi.com>
References: <20070912015644.927677070@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 11 Sep 2007 18:56:45 -0700
From: travis@sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>, Christoph Lameter <clameter@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, sparclinux@vger.kernel.org
Subject: [PATCH 01/10] x86: remove x86_cpu_to_log_apicid array (v3)
Content-Disposition: inline; filename=remove-x86_cpu_to_log_apicid
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a copy of an older patch that is in rc3-mm1.  It's needed
to allow the remaining patches to integrate correctly.

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86_64/kernel/genapic.c      |    2 --
 arch/x86_64/kernel/genapic_flat.c |    1 -
 arch/x86_64/kernel/smpboot.c      |    1 -
 include/asm-x86_64/smp.h          |    1 -
 4 files changed, 5 deletions(-)

--- a/arch/x86_64/kernel/genapic.c
+++ b/arch/x86_64/kernel/genapic.c
@@ -29,8 +29,6 @@
 					= { [0 ... NR_CPUS-1] = BAD_APICID };
 EXPORT_SYMBOL(x86_cpu_to_apicid);
 
-u8 x86_cpu_to_log_apicid[NR_CPUS]	= { [0 ... NR_CPUS-1] = BAD_APICID };
-
 struct genapic __read_mostly *genapic = &apic_flat;
 
 /*
--- a/arch/x86_64/kernel/genapic_flat.c
+++ b/arch/x86_64/kernel/genapic_flat.c
@@ -52,7 +52,6 @@
 
 	num = smp_processor_id();
 	id = 1UL << num;
-	x86_cpu_to_log_apicid[num] = id;
 	apic_write(APIC_DFR, APIC_DFR_FLAT);
 	val = apic_read(APIC_LDR) & ~APIC_LDR_MASK;
 	val |= SET_APIC_LOGICAL_ID(id);
--- a/arch/x86_64/kernel/smpboot.c
+++ b/arch/x86_64/kernel/smpboot.c
@@ -702,7 +702,6 @@
 		cpu_clear(cpu, cpu_present_map);
 		cpu_clear(cpu, cpu_possible_map);
 		x86_cpu_to_apicid[cpu] = BAD_APICID;
-		x86_cpu_to_log_apicid[cpu] = BAD_APICID;
 		return -EIO;
 	}
 
--- a/include/asm-x86_64/smp.h
+++ b/include/asm-x86_64/smp.h
@@ -78,7 +78,6 @@
  * the real APIC ID <-> CPU # mapping.
  */
 extern u8 x86_cpu_to_apicid[NR_CPUS];	/* physical ID */
-extern u8 x86_cpu_to_log_apicid[NR_CPUS];
 extern u8 bios_cpu_apicid[];
 
 static inline int cpu_present_to_apicid(int mps_cpu)

-- 
