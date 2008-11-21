Return-Path: <linux-kernel-owner+w=401wt.eu-S1755965AbYKUKp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965AbYKUKp6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 05:45:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753913AbYKUKot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 05:44:49 -0500
Received: from ozlabs.org ([203.10.76.45]:45221 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753603AbYKUKor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 05:44:47 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 21 Nov 2008 21:12:13 +1030
Subject: [PATCH 4/8] cpumask: Mips: Introduce cpumask_of_{node,pcibus} to replace {node,pcibus}_to_cpumask
Cc: Ralf Baechle <ralf@linux-mips.org>
Message-Id: <20081121104445.5775EDDEE7@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: New APIs

The old node_to_cpumask/node_to_pcibus returned a cpumask_t: these
return a pointer to a struct cpumask.  Part of removing cpumasks from
the stack.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ralf Baechle <ralf@linux-mips.org>
---
 arch/mips/include/asm/mach-ip27/topology.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/mips/include/asm/mach-ip27/topology.h b/arch/mips/include/asm/mach-ip27/topology.h
--- a/arch/mips/include/asm/mach-ip27/topology.h
+++ b/arch/mips/include/asm/mach-ip27/topology.h
@@ -25,11 +25,13 @@ extern struct cpuinfo_ip27 sn_cpu_info[N
 #define cpu_to_node(cpu)	(sn_cpu_info[(cpu)].p_nodeid)
 #define parent_node(node)	(node)
 #define node_to_cpumask(node)	(hub_data(node)->h_cpus)
-#define node_to_first_cpu(node)	(first_cpu(node_to_cpumask(node)))
+#define cpumask_of_node(node)	(&hub_data(node)->h_cpus)
+#define node_to_first_cpu(node)	(cpumask_first(cpumask_of_node(node)))
 struct pci_bus;
 extern int pcibus_to_node(struct pci_bus *);
 
 #define pcibus_to_cpumask(bus)	(cpu_online_map)
+#define cpumask_of_pcibus(bus)	(cpu_online_mask)
 
 extern unsigned char __node_distances[MAX_COMPACT_NODES][MAX_COMPACT_NODES];
 

