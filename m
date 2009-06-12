Return-Path: <linux-kernel-owner+w=401wt.eu-S1759310AbZFLNjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759310AbZFLNjd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763989AbZFLNbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:31:07 -0400
Received: from ozlabs.org ([203.10.76.45]:55287 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764444AbZFLNbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:31:04 -0400
CC: linux-kernel@vger.kernel.org
To: Paul Mundt <lethal@linux-sh.org>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 12 Jun 2009 22:33:14 +0930
Subject: [PATCH 5/13] cpumask: Use accessors for cpu_*_mask: sh
Cc: Mike Travis <travis@sgi.com>
Message-Id: <20090612133105.E5D7ADDD0C@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use the accessors rather than frobbing bits directly (the new versions
are const).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/sh/kernel/cpu/sh4a/smp-shx3.c |    5 ++---
 arch/sh/kernel/smp.c               |    6 +++---
 2 files changed, 5 insertions(+), 6 deletions(-)

--- linux-2.6.28.orig/arch/sh/kernel/cpu/sh4a/smp-shx3.c
+++ linux-2.6.28/arch/sh/kernel/cpu/sh4a/smp-shx3.c
@@ -19,8 +19,7 @@ void __init plat_smp_setup(void)
 	unsigned int cpu = 0;
 	int i, num;
 
-	cpus_clear(cpu_possible_map);
-	cpu_set(cpu, cpu_possible_map);
+	init_cpu_possible(cpumask_of(cpu));
 
 	__cpu_number_map[0] = 0;
 	__cpu_logical_map[0] = 0;
@@ -30,7 +29,7 @@ void __init plat_smp_setup(void)
 	 * for the total number of cores.
 	 */
 	for (i = 1, num = 0; i < NR_CPUS; i++) {
-		cpu_set(i, cpu_possible_map);
+		set_cpu_possible(i, true);
 		__cpu_number_map[i] = ++num;
 		__cpu_logical_map[num] = i;
 	}
--- linux-2.6.28.orig/arch/sh/kernel/smp.c
+++ linux-2.6.28/arch/sh/kernel/smp.c
@@ -52,7 +52,7 @@ void __init smp_prepare_cpus(unsigned in
 	plat_prepare_cpus(max_cpus);
 
 #ifndef CONFIG_HOTPLUG_CPU
-	cpu_present_map = cpu_possible_map;
+	init_cpu_present(&cpu_possible_map);
 #endif
 }
 
@@ -63,8 +63,8 @@ void __devinit smp_prepare_boot_cpu(void
 	__cpu_number_map[0] = cpu;
 	__cpu_logical_map[0] = cpu;
 
-	cpu_set(cpu, cpu_online_map);
-	cpu_set(cpu, cpu_possible_map);
+	set_cpu_online(cpu, true);
+	set_cpu_possible(cpu, true);
 }
 
 asmlinkage void __cpuinit start_secondary(void)

