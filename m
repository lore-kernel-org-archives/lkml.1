Return-Path: <linux-kernel-owner+w=401wt.eu-S1754599AbYLGLCJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599AbYLGLCJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 06:02:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754060AbYLGLBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 06:01:37 -0500
Received: from ozlabs.org ([203.10.76.45]:59371 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754023AbYLGLBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 06:01:35 -0500
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Sun, 7 Dec 2008 21:31:27 +1030
Subject: [PATCH 3/6] cpumask: Introduce topology_core_cpumask()/topology_thread_cpumask(): s390
Cc: Mike Travis <travis@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812072131.27454.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The old topology_core_siblings() and topology_thread_siblings() return
a cpumask_t; these new ones return a (const) struct cpumask *.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/s390/include/asm/topology.h |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.28.orig/arch/s390/include/asm/topology.h
+++ linux-2.6.28/arch/s390/include/asm/topology.h
@@ -9,7 +9,8 @@ const struct cpumask *cpu_coregroup_map(
 
 extern cpumask_t cpu_core_map[NR_CPUS];
 
 #define topology_core_siblings(cpu)	(cpu_core_map[cpu])
+#define topology_core_cpumask(cpu)	(&cpu_core_map[cpu])
 
 int topology_set_cpu_management(int fc);
 void topology_schedule_update(void);

