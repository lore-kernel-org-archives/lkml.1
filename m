Return-Path: <linux-kernel-owner+w=401wt.eu-S932534AbZHGM7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932534AbZHGM7n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 08:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932510AbZHGM7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 08:59:41 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:53347 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932508AbZHGM7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 08:59:37 -0400
X-SpamScore: 3
X-BigFish: VPS3(z34a4jzzz1202hzzz32i6bh203h65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0KO0C2T-02-3VK-02
X-M-MSG: 
Date: Fri, 7 Aug 2009 14:59:18 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, Borislav Petkov <borislav.petkov@amd.com>,
       Brice Goglin <Brice.Goglin@inria.fr>
Subject: [PATCH 4/8] x86, topology: Swap semantic of core_siblings and
	cpu_node_siblings
Message-ID: <20090807125918.GW6520@alberich.amd.com>
References: <20090807125609.GH7198@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090807125609.GH7198@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 07 Aug 2009 12:59:18.0813 (UTC) FILETIME=[E02164D0:01CA175E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brice Goglin suggested to use the following semantic for
CPU topology information

  Level        | Set of CPUs
 --------------|---------------
  phys_package | cpu_node_siblings
  cpu_node     | core_siblings
  core         | thread_siblings
  thread       | one CPU

Done that.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/include/asm/topology.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 9eddb69..d53ef91 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -188,10 +188,10 @@ extern const struct cpumask *cpu_coregroup_mask(int cpu);
 #ifdef ENABLE_TOPO_DEFINES
 #define topology_physical_package_id(cpu)	(cpu_data(cpu).phys_proc_id)
 #define topology_core_id(cpu)			(cpu_data(cpu).cpu_core_id)
-#define topology_core_cpumask(cpu)		(per_cpu(cpu_core_map, cpu))
+#define topology_core_cpumask(cpu)		(per_cpu(cpu_node_map, cpu))
 #define topology_thread_cpumask(cpu)		(per_cpu(cpu_sibling_map, cpu))
 #define topology_cpu_node_id(cpu)		(cpu_data(cpu).cpu_node_id)
-#define topology_cpu_node_cpumask(cpu)		(per_cpu(cpu_node_map, cpu))
+#define topology_cpu_node_cpumask(cpu)		(per_cpu(cpu_core_map, cpu))
 
 /* indicates that pointers to the topology cpumask_t maps are valid */
 #define arch_provides_topology_pointers		yes
-- 
1.6.3.3



