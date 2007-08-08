Return-Path: <linux-kernel-owner+w=401wt.eu-S964868AbXHHVB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964868AbXHHVB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 17:01:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761305AbXHHVBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 17:01:44 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:44550 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760752AbXHHVBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 17:01:43 -0400
Date: Wed, 8 Aug 2007 14:01:43 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: ak@suse.de
cc: linux-kernel@vger.kernel.org, travis@sgi.com
Subject: [PATCH] Remove x86_cpu_to_log_apicid
Message-ID: <Pine.LNX.4.64.0708081400430.15668@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Travis <travis@sgi.com>

Remove the x86_cpu_to_log_apicid array.  It is set in 
arch/x86_64/kernel/genapic_flat.c:flat_init_apic_ldr() and
arch/x86_64/kernel/smpboot.c:do_boot_cpu() but it is never
referenced.

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
@@ -84,7 +84,6 @@
  * the real APIC ID <-> CPU # mapping.
  */
 extern u8 x86_cpu_to_apicid[NR_CPUS];	/* physical ID */
-extern u8 x86_cpu_to_log_apicid[NR_CPUS];
 extern u8 bios_cpu_apicid[];
 
 static inline int cpu_present_to_apicid(int mps_cpu)
