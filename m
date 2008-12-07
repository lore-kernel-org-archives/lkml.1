Return-Path: <linux-kernel-owner+w=401wt.eu-S1754379AbYLGLBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379AbYLGLBs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 06:01:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754028AbYLGLBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 06:01:36 -0500
Received: from ozlabs.org ([203.10.76.45]:59366 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754004AbYLGLBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 06:01:34 -0500
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Sun, 7 Dec 2008 21:31:23 +1030
Subject: [PATCH 2/6] cpumask: Introduce topology_core_cpumask()/topology_thread_cpumask(): sparc
Cc: Mike Travis <travis@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812072131.23854.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The old topology_core_siblings() and topology_thread_siblings() return
a cpumask_t; these new ones return a (const) struct cpumask *.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/sparc/include/asm/topology_64.h |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.28.orig/arch/sparc/include/asm/topology_64.h
+++ linux-2.6.28/arch/sparc/include/asm/topology_64.h
@@ -66,8 +66,10 @@ static inline int pcibus_to_node(struct 
 #ifdef CONFIG_SMP
 #define topology_physical_package_id(cpu)	(cpu_data(cpu).proc_id)
 #define topology_core_id(cpu)			(cpu_data(cpu).core_id)
 #define topology_core_siblings(cpu)		(cpu_core_map[cpu])
 #define topology_thread_siblings(cpu)		(per_cpu(cpu_sibling_map, cpu))
+#define topology_core_cpumask(cpu)		(&cpu_core_map[cpu])
+#define topology_thread_cpumask(cpu)		(&per_cpu(cpu_sibling_map, cpu))
 #define mc_capable()				(sparc64_multi_core)
 #define smt_capable()				(sparc64_multi_core)
 #endif /* CONFIG_SMP */

