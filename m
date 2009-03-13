Return-Path: <linux-kernel-owner+w=401wt.eu-S1758723AbZCMNqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758723AbZCMNqf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 09:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757728AbZCMNqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 09:46:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:42749 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756657AbZCMNqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 09:46:13 -0400
Date: Fri, 13 Mar 2009 13:45:36 GMT
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       travis@sgi.com, rusty@rustcorp.com.au, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, travis@sgi.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <200903132343.37661.rusty@rustcorp.com.au>
References: <200903132343.37661.rusty@rustcorp.com.au>
Subject: [tip:cpus4096] numa, cpumask: move numa_node_id default implementation to topology.h
Message-ID: <tip-082edb7bf443eb8eda15b482d16ad9dd8137ad24@git.kernel.org>
Git-Commit-ID: 082edb7bf443eb8eda15b482d16ad9dd8137ad24
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 13:45:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  082edb7bf443eb8eda15b482d16ad9dd8137ad24
Gitweb:     http://git.kernel.org/tip/082edb7bf443eb8eda15b482d16ad9dd8137ad24
Author:     Rusty Russell <rusty@rustcorp.com.au>
AuthorDate: Fri, 13 Mar 2009 23:43:37 +1030
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 13 Mar 2009 14:35:31 +0100

numa, cpumask: move numa_node_id default implementation to topology.h

Impact: cleanup, potential bugfix

Not sure what changed to expose this, but clearly that numa_node_id()
doesn't belong in mmzone.h (the inline in gfp.h is probably overkill, too).

In file included from include/linux/topology.h:34,
                 from arch/x86/mm/numa.c:2:
/home/rusty/patches-cpumask/linux-2.6/arch/x86/include/asm/topology.h:64:1: warning: "numa_node_id" redefined
In file included from include/linux/topology.h:32,
                 from arch/x86/mm/numa.c:2:
include/linux/mmzone.h:770:1: warning: this is the location of the previous definition

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>
LKML-Reference: <200903132343.37661.rusty@rustcorp.com.au>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/gfp.h      |    1 +
 include/linux/mmzone.h   |    6 ------
 include/linux/topology.h |    5 +++++
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index dd20cd7..0bbc15f 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -4,6 +4,7 @@
 #include <linux/mmzone.h>
 #include <linux/stddef.h>
 #include <linux/linkage.h>
+#include <linux/topology.h>
 
 struct vm_area_struct;
 
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 1aca6ce..e6aacf7 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -764,12 +764,6 @@ extern int numa_zonelist_order_handler(struct ctl_table *, int,
 extern char numa_zonelist_order[];
 #define NUMA_ZONELIST_ORDER_LEN 16	/* string buffer size */
 
-#include <linux/topology.h>
-/* Returns the number of the current Node. */
-#ifndef numa_node_id
-#define numa_node_id()		(cpu_to_node(raw_smp_processor_id()))
-#endif
-
 #ifndef CONFIG_NEED_MULTIPLE_NODES
 
 extern struct pglist_data contig_page_data;
diff --git a/include/linux/topology.h b/include/linux/topology.h
index 16b7d68..7402c1a 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -196,4 +196,9 @@ int arch_update_cpu_topology(void);
 #define topology_core_cpumask(cpu)		cpumask_of(cpu)
 #endif
 
+/* Returns the number of the current Node. */
+#ifndef numa_node_id
+#define numa_node_id()		(cpu_to_node(raw_smp_processor_id()))
+#endif
+
 #endif /* _LINUX_TOPOLOGY_H */
