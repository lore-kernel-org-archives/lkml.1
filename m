Return-Path: <linux-kernel-owner+w=401wt.eu-S1753955AbYLGLBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbYLGLBd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 06:01:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbYLGLBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 06:01:25 -0500
Received: from ozlabs.org ([203.10.76.45]:59364 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335AbYLGLBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 06:01:24 -0500
To: Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Sun, 7 Dec 2008 21:31:17 +1030
Subject: [PATCH 1/6] cpumask: Introduce topology_core_cpumask()/topology_thread_cpumask(): x86
Cc: Mike Travis <travis@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812072131.18087.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(The actual patch will go via git with all the other x86 cpumask patches,
 this is just posted here for completeness).

The old topology_core_siblings() and topology_thread_siblings() return
a cpumask_t; these new ones return a (const) struct cpumask *.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/include/asm/topology.h |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.28.orig/arch/x86/include/asm/topology.h
+++ linux-2.6.28/arch/x86/include/asm/topology.h
@@ -181,8 +181,10 @@ extern const struct cpumask *cpu_coregro
 #ifdef ENABLE_TOPO_DEFINES
 #define topology_physical_package_id(cpu)	(cpu_data(cpu).phys_proc_id)
 #define topology_core_id(cpu)			(cpu_data(cpu).cpu_core_id)
 #define topology_core_siblings(cpu)		(per_cpu(cpu_core_map, cpu))
 #define topology_thread_siblings(cpu)		(per_cpu(cpu_sibling_map, cpu))
+#define topology_core_cpumask(cpu)		(&per_cpu(cpu_core_map, cpu))
+#define topology_thread_cpumask(cpu)		(&per_cpu(cpu_sibling_map, cpu))
 
 /* indicates that pointers to the topology cpumask_t maps are valid */
 #define arch_provides_topology_pointers		yes

