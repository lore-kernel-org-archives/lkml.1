Return-Path: <linux-kernel-owner+w=401wt.eu-S1756415AbZHFRam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415AbZHFRam (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 13:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756391AbZHFRal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 13:30:41 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:36308
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751552AbZHFRal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 13:30:41 -0400
X-SpamScore: 5
X-BigFish: VPS5(z34a4jzzz1202hzzz32i6bh203h43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0KNYTYR-02-MPM-02
X-M-MSG: 
Date: Thu, 6 Aug 2009 19:29:55 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org, Borislav Petkov <borislav.petkov@amd.com>,
       Brice Goglin <Brice.Goglin@inria.fr>
Subject: [PATCH] x86, topology: Swap semantic of core_siblings and
	cpu_node_siblings
Message-ID: <20090806172955.GF7198@alberich.amd.com>
References: <20090805154402.GA6520@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090805154402.GA6520@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 06 Aug 2009 17:29:55.0995 (UTC) FILETIME=[83D4FEB0:01CA16BB]
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

CC: Brice Goglin <Brice.Goglin@inria.fr>
Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/include/asm/topology.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

Patch is on top of the 5 previous patches.
Documentation update will follow.

Regards,
Andreas


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



