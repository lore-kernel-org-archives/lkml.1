Return-Path: <linux-kernel-owner+w=401wt.eu-S1756180AbZGMPUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180AbZGMPUp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 11:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756077AbZGMPUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 11:20:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33417 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488AbZGMPUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 11:20:43 -0400
Date: Mon, 13 Jul 2009 17:20:39 +0200
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, akpm@osdl.org, benh@kernel.crashing.org,
       davem@davemloft.net
Subject: [PATCH] Remove topology_thread_siblings
Message-ID: <20090713152039.GA7627@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove topology_thread_siblings

It's unused and x86 only provides a fallback that gives incorrect
results (no siblings). So if anyone would start using it they 
would get wrong results on x86.

It's equivalent topology_thread_cpumask anyways. So just remove it 
everywhere, including ia64, sparc, power.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/ia64/include/asm/topology.h     |    1 -
 arch/powerpc/include/asm/topology.h  |    1 -
 arch/sparc/include/asm/topology_64.h |    1 -
 include/linux/topology.h             |    3 ---
 4 files changed, 6 deletions(-)

Index: linux-2.6.31-rc2-ak/arch/ia64/include/asm/topology.h
===================================================================
--- linux-2.6.31-rc2-ak.orig/arch/ia64/include/asm/topology.h
+++ linux-2.6.31-rc2-ak/arch/ia64/include/asm/topology.h
@@ -104,7 +104,6 @@ void build_cpu_to_node_map(void);
 #define topology_physical_package_id(cpu)	(cpu_data(cpu)->socket_id)
 #define topology_core_id(cpu)			(cpu_data(cpu)->core_id)
 #define topology_core_siblings(cpu)		(cpu_core_map[cpu])
-#define topology_thread_siblings(cpu)		(per_cpu(cpu_sibling_map, cpu))
 #define topology_core_cpumask(cpu)		(&cpu_core_map[cpu])
 #define topology_thread_cpumask(cpu)		(&per_cpu(cpu_sibling_map, cpu))
 #define smt_capable() 				(smp_num_siblings > 1)
Index: linux-2.6.31-rc2-ak/arch/powerpc/include/asm/topology.h
===================================================================
--- linux-2.6.31-rc2-ak.orig/arch/powerpc/include/asm/topology.h
+++ linux-2.6.31-rc2-ak/arch/powerpc/include/asm/topology.h
@@ -105,7 +105,6 @@ static inline void sysfs_remove_device_f
 #ifdef CONFIG_PPC64
 #include <asm/smp.h>
 
-#define topology_thread_siblings(cpu)	(per_cpu(cpu_sibling_map, cpu))
 #define topology_core_siblings(cpu)	(per_cpu(cpu_core_map, cpu))
 #define topology_thread_cpumask(cpu)	(&per_cpu(cpu_sibling_map, cpu))
 #define topology_core_cpumask(cpu)	(&per_cpu(cpu_core_map, cpu))
Index: linux-2.6.31-rc2-ak/arch/sparc/include/asm/topology_64.h
===================================================================
--- linux-2.6.31-rc2-ak.orig/arch/sparc/include/asm/topology_64.h
+++ linux-2.6.31-rc2-ak/arch/sparc/include/asm/topology_64.h
@@ -73,7 +73,6 @@ static inline int pcibus_to_node(struct
 #define topology_physical_package_id(cpu)	(cpu_data(cpu).proc_id)
 #define topology_core_id(cpu)			(cpu_data(cpu).core_id)
 #define topology_core_siblings(cpu)		(cpu_core_map[cpu])
-#define topology_thread_siblings(cpu)		(per_cpu(cpu_sibling_map, cpu))
 #define topology_core_cpumask(cpu)		(&cpu_core_map[cpu])
 #define topology_thread_cpumask(cpu)		(&per_cpu(cpu_sibling_map, cpu))
 #define mc_capable()				(sparc64_multi_core)
Index: linux-2.6.31-rc2-ak/include/linux/topology.h
===================================================================
--- linux-2.6.31-rc2-ak.orig/include/linux/topology.h
+++ linux-2.6.31-rc2-ak/include/linux/topology.h
@@ -183,9 +183,6 @@ int arch_update_cpu_topology(void);
 #ifndef topology_core_id
 #define topology_core_id(cpu)			((void)(cpu), 0)
 #endif
-#ifndef topology_thread_siblings
-#define topology_thread_siblings(cpu)		cpumask_of_cpu(cpu)
-#endif
 #ifndef topology_core_siblings
 #define topology_core_siblings(cpu)		cpumask_of_cpu(cpu)
 #endif
