Return-Path: <linux-kernel-owner+w=401wt.eu-S1754888AbYCLRdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbYCLRdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 13:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752035AbYCLRc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 13:32:26 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:21480 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbYCLRcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 13:32:22 -0400
Message-Id: <20080312173217.078548501@de.ibm.com>
References: <20080312173155.703966894@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Wed, 12 Mar 2008 18:31:59 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 04/10] sched: Add arch_update_cpu_topology hook.
Content-Disposition: inline; filename=104-nodes-hook.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Will be called each time the scheduling domains are rebuild.
Needed for architectures that don't have a static cpu topology.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 include/linux/topology.h |    2 ++
 kernel/sched.c           |    5 +++++
 2 files changed, 7 insertions(+)

Index: quilt-2.6/include/linux/topology.h
===================================================================
--- quilt-2.6.orig/include/linux/topology.h
+++ quilt-2.6/include/linux/topology.h
@@ -50,6 +50,8 @@
 	for_each_online_node(node)						\
 		if (nr_cpus_node(node))
 
+void arch_update_cpu_topology(void);
+
 /* Conform to ACPI 2.0 SLIT distance definitions */
 #define LOCAL_DISTANCE		10
 #define REMOTE_DISTANCE		20
Index: quilt-2.6/kernel/sched.c
===================================================================
--- quilt-2.6.orig/kernel/sched.c
+++ quilt-2.6/kernel/sched.c
@@ -6804,6 +6804,10 @@ static int ndoms_cur;		/* number of sche
  */
 static cpumask_t fallback_doms;
 
+void __attribute__((weak)) arch_update_cpu_topology(void)
+{
+}
+
 /*
  * Set up scheduler domains and groups. Callers must hold the hotplug lock.
  * For now this just excludes isolated cpus, but could be used to
@@ -6813,6 +6817,7 @@ static int arch_init_sched_domains(const
 {
 	int err;
 
+	arch_update_cpu_topology();
 	ndoms_cur = 1;
 	doms_cur = kmalloc(sizeof(cpumask_t), GFP_KERNEL);
 	if (!doms_cur)

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

