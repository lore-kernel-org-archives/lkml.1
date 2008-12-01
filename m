Return-Path: <linux-kernel-owner+w=401wt.eu-S1751830AbYLAGQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830AbYLAGQv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 01:16:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750833AbYLAGQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 01:16:42 -0500
Received: from ozlabs.org ([203.10.76.45]:42883 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbYLAGQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 01:16:41 -0500
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Mike Travis <travis@sgi.com>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Mon, 1 Dec 2008 16:46:34 +1030
Subject: [PATCH 1/4] cpumask: cpu_coregroup_mask(): x86
Cc: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812011646.35018.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like cpu_coregroup_map, but returns a (const) pointer.

(This will go to Ingo separately as part of the x86 series, just
airing it here for thoroughness).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@redhat.com>
---
 arch/x86/include/asm/topology.h |    1 +
 arch/x86/kernel/smpboot.c       |   11 ++++++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff -r 11a884ebd99b arch/x86/include/asm/topology.h
--- a/arch/x86/include/asm/topology.h	Thu Nov 20 13:54:24 2008 +1030
+++ b/arch/x86/include/asm/topology.h	Thu Nov 20 13:55:44 2008 +1030
@@ -231,6 +231,7 @@
 #endif
 
 extern cpumask_t cpu_coregroup_map(int cpu);
+extern const struct cpumask *cpu_coregroup_mask(int cpu);
 
 #ifdef ENABLE_TOPO_DEFINES
 #define topology_physical_package_id(cpu)	(cpu_data(cpu).phys_proc_id)
diff -r 11a884ebd99b arch/x86/kernel/smpboot.c
--- a/arch/x86/kernel/smpboot.c	Thu Nov 20 13:54:24 2008 +1030
+++ b/arch/x86/kernel/smpboot.c	Thu Nov 20 13:55:44 2008 +1030
@@ -497,7 +497,7 @@
 }
 
 /* maps the cpu to the sched domain representing multi-core */
-cpumask_t cpu_coregroup_map(int cpu)
+const struct cpumask *cpu_coregroup_mask(int cpu)
 {
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 	/*
@@ -505,9 +505,14 @@
 	 * And for power savings, we return cpu_core_map
 	 */
 	if (sched_mc_power_savings || sched_smt_power_savings)
-		return per_cpu(cpu_core_map, cpu);
+		return &per_cpu(cpu_core_map, cpu);
 	else
-		return c->llc_shared_map;
+		return &c->llc_shared_map;
+}
+
+cpumask_t cpu_coregroup_map(int cpu)
+{
+	return *cpu_coregroup_mask(cpu);
 }
 
 static void impress_friends(void)


