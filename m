Return-Path: <linux-kernel-owner+w=401wt.eu-S1754796AbYLGLC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796AbYLGLC1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 06:02:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754063AbYLGLBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 06:01:38 -0500
Received: from ozlabs.org ([203.10.76.45]:59373 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754004AbYLGLBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 06:01:36 -0500
To: Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Sun, 7 Dec 2008 21:31:29 +1030
Subject: [PATCH 4/6] cpumask: Introduce topology_core_cpumask()/topology_thread_cpumask(): powerpc
Cc: Mike Travis <travis@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812072131.29922.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The old topology_core_siblings() and topology_thread_siblings() return
a cpumask_t; these new ones return a (const) struct cpumask *.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/powerpc/include/asm/topology.h |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.28.orig/arch/powerpc/include/asm/topology.h
+++ linux-2.6.28/arch/powerpc/include/asm/topology.h
@@ -105,8 +105,10 @@ static inline void sysfs_remove_device_f
 #ifdef CONFIG_PPC64
 #include <asm/smp.h>
 
 #define topology_thread_siblings(cpu)	(per_cpu(cpu_sibling_map, cpu))
 #define topology_core_siblings(cpu)	(per_cpu(cpu_core_map, cpu))
+#define topology_thread_cpumask(cpu)	(&per_cpu(cpu_sibling_map, cpu))
+#define topology_core_cpumask(cpu)	(&per_cpu(cpu_core_map, cpu))
 #define topology_core_id(cpu)		(cpu_to_core_id(cpu))
 #endif
 #endif

