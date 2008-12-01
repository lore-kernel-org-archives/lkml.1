Return-Path: <linux-kernel-owner+w=401wt.eu-S1753336AbYLAGRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336AbYLAGRf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 01:17:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750833AbYLAGRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 01:17:24 -0500
Received: from ozlabs.org ([203.10.76.45]:42901 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbYLAGRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 01:17:23 -0500
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Mon, 1 Dec 2008 16:47:20 +1030
Subject: [PATCH 3/4] cpumask: cpu_coregroup_mask(): s390
Cc: Mike Travis <travis@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812011647.20296.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like cpu_coregroup_map, but returns a (const) pointer.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/s390/include/asm/topology.h |    1 +
 arch/s390/kernel/topology.c      |    5 +++++
 2 files changed, 6 insertions(+)

diff -r 2d272f7b3a9b arch/s390/include/asm/topology.h
--- a/arch/s390/include/asm/topology.h	Thu Nov 20 13:55:47 2008 +1030
+++ b/arch/s390/include/asm/topology.h	Thu Nov 20 13:57:21 2008 +1030
@@ -6,6 +6,7 @@
 #define mc_capable()	(1)
 
 cpumask_t cpu_coregroup_map(unsigned int cpu);
+const struct cpumask *cpu_coregroup_mask(unsigned int cpu);
 
 extern cpumask_t cpu_core_map[NR_CPUS];
 
diff -r 2d272f7b3a9b arch/s390/kernel/topology.c
--- a/arch/s390/kernel/topology.c	Thu Nov 20 13:55:47 2008 +1030
+++ b/arch/s390/kernel/topology.c	Thu Nov 20 13:57:21 2008 +1030
@@ -91,6 +91,11 @@
 	if (cpus_empty(mask))
 		mask = cpumask_of_cpu(cpu);
 	return mask;
+}
+
+const struct cpumask *cpu_coregroup_mask(unsigned int cpu)
+{
+	return &cpu_core_map[cpu];
 }
 
 static void add_cpus_to_core(struct tl_cpu *tl_cpu, struct core_info *core)


