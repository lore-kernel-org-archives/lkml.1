Return-Path: <linux-kernel-owner+w=401wt.eu-S1763716AbXIUWek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763716AbXIUWek (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763311AbXIUWcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:32:10 -0400
Received: from mail.suse.de ([195.135.220.2]:57038 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762375AbXIUWcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:32:07 -0400
From: Andi Kleen <ak@suse.de>
References: <200709221231.836138000@suse.de>
In-Reply-To: <200709221231.836138000@suse.de>
To: travis@sgi.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [8/50] x86_64: remove x86_cpu_to_log_apicid
Message-Id: <20070921223206.6211714DD5@wotan.suse.de>
Date: Sat, 22 Sep 2007 00:32:06 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Mike Travis <travis@sgi.com>

Remove the x86_cpu_to_log_apicid array.  It is set in
arch/x86_64/kernel/genapic_flat.c:flat_init_apic_ldr() and
arch/x86_64/kernel/smpboot.c:do_boot_cpu() but it is never
referenced.

Signed-off-by: Mike Travis <travis@sgi.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/x86_64/kernel/genapic.c      |    2 --
 arch/x86_64/kernel/genapic_flat.c |    1 -
 arch/x86_64/kernel/smpboot.c      |    1 -
 include/asm-x86_64/smp.h          |    1 -
 4 files changed, 5 deletions(-)

Index: linux/arch/x86_64/kernel/genapic.c
===================================================================
--- linux.orig/arch/x86_64/kernel/genapic.c
+++ linux/arch/x86_64/kernel/genapic.c
@@ -29,8 +29,6 @@ u8 x86_cpu_to_apicid[NR_CPUS] __read_mos
 					= { [0 ... NR_CPUS-1] = BAD_APICID };
 EXPORT_SYMBOL(x86_cpu_to_apicid);
 
-u8 x86_cpu_to_log_apicid[NR_CPUS]	= { [0 ... NR_CPUS-1] = BAD_APICID };
-
 struct genapic __read_mostly *genapic = &apic_flat;
 
 /*
Index: linux/arch/x86_64/kernel/genapic_flat.c
===================================================================
--- linux.orig/arch/x86_64/kernel/genapic_flat.c
+++ linux/arch/x86_64/kernel/genapic_flat.c
@@ -52,7 +52,6 @@ static void flat_init_apic_ldr(void)
 
 	num = smp_processor_id();
 	id = 1UL << num;
-	x86_cpu_to_log_apicid[num] = id;
 	apic_write(APIC_DFR, APIC_DFR_FLAT);
 	val = apic_read(APIC_LDR) & ~APIC_LDR_MASK;
 	val |= SET_APIC_LOGICAL_ID(id);
Index: linux/arch/x86_64/kernel/smpboot.c
===================================================================
--- linux.orig/arch/x86_64/kernel/smpboot.c
+++ linux/arch/x86_64/kernel/smpboot.c
@@ -702,7 +702,6 @@ do_rest:
 		cpu_clear(cpu, cpu_present_map);
 		cpu_clear(cpu, cpu_possible_map);
 		x86_cpu_to_apicid[cpu] = BAD_APICID;
-		x86_cpu_to_log_apicid[cpu] = BAD_APICID;
 		return -EIO;
 	}
 
Index: linux/include/asm-x86_64/smp.h
===================================================================
--- linux.orig/include/asm-x86_64/smp.h
+++ linux/include/asm-x86_64/smp.h
@@ -78,7 +78,6 @@ static inline int hard_smp_processor_id(
  * the real APIC ID <-> CPU # mapping.
  */
 extern u8 x86_cpu_to_apicid[NR_CPUS];	/* physical ID */
-extern u8 x86_cpu_to_log_apicid[NR_CPUS];
 extern u8 bios_cpu_apicid[];
 
 static inline int cpu_present_to_apicid(int mps_cpu)
