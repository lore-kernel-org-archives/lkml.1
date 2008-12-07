Return-Path: <linux-kernel-owner+w=401wt.eu-S1755053AbYLGLCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053AbYLGLCo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 06:02:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754066AbYLGLBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 06:01:38 -0500
Received: from ozlabs.org ([203.10.76.45]:59376 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754057AbYLGLBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 06:01:37 -0500
To: Tony Luck <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Sun, 7 Dec 2008 21:31:32 +1030
Subject: [PATCH 5/6] cpumask: Introduce topology_core_cpumask()/topology_thread_cpumask(): ia64
Cc: Mike Travis <travis@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812072131.32751.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The old topology_core_siblings() and topology_thread_siblings() return
a cpumask_t; these new ones return a (const) struct cpumask *.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/ia64/include/asm/topology.h |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.28.orig/arch/ia64/include/asm/topology.h
+++ linux-2.6.28/arch/ia64/include/asm/topology.h
@@ -109,8 +109,10 @@ void build_cpu_to_node_map(void);
 #ifdef CONFIG_SMP
 #define topology_physical_package_id(cpu)	(cpu_data(cpu)->socket_id)
 #define topology_core_id(cpu)			(cpu_data(cpu)->core_id)
 #define topology_core_siblings(cpu)		(cpu_core_map[cpu])
 #define topology_thread_siblings(cpu)		(per_cpu(cpu_sibling_map, cpu))
+#define topology_core_cpumask(cpu)		(&cpu_core_map[cpu])
+#define topology_thread_cpumask(cpu)		(&per_cpu(cpu_sibling_map, cpu))
 #define smt_capable() 				(smp_num_siblings > 1)
 #endif
 

