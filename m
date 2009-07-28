Return-Path: <linux-kernel-owner+w=401wt.eu-S1754416AbZG1PLF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416AbZG1PLF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 11:11:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753660AbZG1PGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 11:06:40 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:25964
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753368AbZG1PGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 11:06:38 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i203h62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KNHZAO-02-6P7-02
X-M-MSG: 
From: Borislav Petkov <borislav.petkov@amd.com>
To: <mingo@elte.hu>, <hpa@zytor.com>, <tglx@linutronix.de>, <norsk5@yahoo.com>,
       <aris@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: [PATCH 01/20] topology: introduce cpu_node information for multi-node processors
Date: Tue, 28 Jul 2009 17:06:01 +0200
Message-ID: <1248793580-29899-2-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248793580-29899-1-git-send-email-borislav.petkov@amd.com>
References: <1248793580-29899-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 28 Jul 2009 15:06:22.0597 (UTC) FILETIME=[F8210350:01CA0F94]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Herrmann <andreas.herrmann3@amd.com>

New topology attributes are
- cpu_node_id (id of the internal node)
- cpu_node_siblings and cpu_node_siblings_list
  (siblings on the same internal node)

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 drivers/base/topology.c  |   10 ++++++++++
 include/linux/topology.h |    9 +++++++++
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/base/topology.c b/drivers/base/topology.c
index bf6b132..1e35a43 100644
--- a/drivers/base/topology.c
+++ b/drivers/base/topology.c
@@ -103,6 +103,9 @@ static ssize_t show_##name##_list(struct sys_device *dev,		\
 define_id_show_func(physical_package_id);
 define_one_ro(physical_package_id);
 
+define_id_show_func(cpu_node_id);
+define_one_ro(cpu_node_id);
+
 define_id_show_func(core_id);
 define_one_ro(core_id);
 
@@ -110,6 +113,10 @@ define_siblings_show_func(thread_cpumask);
 define_one_ro_named(thread_siblings, show_thread_cpumask);
 define_one_ro_named(thread_siblings_list, show_thread_cpumask_list);
 
+define_siblings_show_func(cpu_node_cpumask);
+define_one_ro_named(cpu_node_siblings, show_cpu_node_cpumask);
+define_one_ro_named(cpu_node_siblings_list, show_cpu_node_cpumask_list);
+
 define_siblings_show_func(core_cpumask);
 define_one_ro_named(core_siblings, show_core_cpumask);
 define_one_ro_named(core_siblings_list, show_core_cpumask_list);
@@ -119,6 +126,9 @@ static struct attribute *default_attrs[] = {
 	&attr_core_id.attr,
 	&attr_thread_siblings.attr,
 	&attr_thread_siblings_list.attr,
+	&attr_cpu_node_id.attr,
+	&attr_cpu_node_siblings.attr,
+	&attr_cpu_node_siblings_list.attr,
 	&attr_core_siblings.attr,
 	&attr_core_siblings_list.attr,
 	NULL
diff --git a/include/linux/topology.h b/include/linux/topology.h
index 7402c1a..976a130 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -180,6 +180,9 @@ int arch_update_cpu_topology(void);
 #ifndef topology_physical_package_id
 #define topology_physical_package_id(cpu)	((void)(cpu), -1)
 #endif
+#ifndef topology_cpu_node_id
+#define topology_cpu_node_id(cpu)		((void)(cpu), 0)
+#endif
 #ifndef topology_core_id
 #define topology_core_id(cpu)			((void)(cpu), 0)
 #endif
@@ -189,12 +192,18 @@ int arch_update_cpu_topology(void);
 #ifndef topology_core_siblings
 #define topology_core_siblings(cpu)		cpumask_of_cpu(cpu)
 #endif
+#ifndef topology_cpu_node_siblings
+#define topology_cpu_node_siblings(cpu)		topology_core_siblings(cpu)
+#endif
 #ifndef topology_thread_cpumask
 #define topology_thread_cpumask(cpu)		cpumask_of(cpu)
 #endif
 #ifndef topology_core_cpumask
 #define topology_core_cpumask(cpu)		cpumask_of(cpu)
 #endif
+#ifndef topology_cpu_node_cpumask
+#define topology_cpu_node_cpumask(cpu)		topology_core_cpumask(cpu)
+#endif
 
 /* Returns the number of the current Node. */
 #ifndef numa_node_id
-- 
1.6.3.3


