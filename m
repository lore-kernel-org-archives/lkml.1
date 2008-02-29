Return-Path: <linux-kernel-owner+w=401wt.eu-S1754569AbYB2Eix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569AbYB2Eix (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 23:38:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754636AbYB2Eib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 23:38:31 -0500
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:48822 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344AbYB2Eia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 23:38:30 -0500
Message-Id: <20080229043751.492446073@linux.vnet.ibm.com>
References: <20080229043242.110741439@linux.vnet.ibm.com>
User-Agent: quilt/0.45-1
Date: Fri, 29 Feb 2008 10:02:43 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: vatsa@linux.vnet.ibm.com, menage@google.com, balbir@linux.vnet.ibm.com,
       mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, skumar@linux.vnet.ibm.com
Subject: [patch 1/2] sched: cleanup cpuacct variable names
Content-Disposition: inline; filename=cleanup-cpuacct.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the variable names to the common convention for the cpuacct
subsystem.

Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>

---
 kernel/sched.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c	2008-02-27 16:21:15.000000000 +0530
+++ linux-2.6/kernel/sched.c	2008-02-28 20:05:27.000000000 +0530
@@ -8180,9 +8180,9 @@ struct cpuacct {
 struct cgroup_subsys cpuacct_subsys;
 
 /* return cpu accounting group corresponding to this container */
-static inline struct cpuacct *cgroup_ca(struct cgroup *cont)
+static inline struct cpuacct *cgroup_ca(struct cgroup *cgrp)
 {
-	return container_of(cgroup_subsys_state(cont, cpuacct_subsys_id),
+	return container_of(cgroup_subsys_state(cgrp, cpuacct_subsys_id),
 			    struct cpuacct, css);
 }
 
@@ -8195,7 +8195,7 @@ static inline struct cpuacct *task_ca(st
 
 /* create a new cpu accounting group */
 static struct cgroup_subsys_state *cpuacct_create(
-	struct cgroup_subsys *ss, struct cgroup *cont)
+	struct cgroup_subsys *ss, struct cgroup *cgrp)
 {
 	struct cpuacct *ca = kzalloc(sizeof(*ca), GFP_KERNEL);
 
@@ -8213,18 +8213,18 @@ static struct cgroup_subsys_state *cpuac
 
 /* destroy an existing cpu accounting group */
 static void
-cpuacct_destroy(struct cgroup_subsys *ss, struct cgroup *cont)
+cpuacct_destroy(struct cgroup_subsys *ss, struct cgroup *cgrp)
 {
-	struct cpuacct *ca = cgroup_ca(cont);
+	struct cpuacct *ca = cgroup_ca(cgrp);
 
 	free_percpu(ca->cpuusage);
 	kfree(ca);
 }
 
 /* return total cpu usage (in nanoseconds) of a group */
-static u64 cpuusage_read(struct cgroup *cont, struct cftype *cft)
+static u64 cpuusage_read(struct cgroup *cgrp, struct cftype *cft)
 {
-	struct cpuacct *ca = cgroup_ca(cont);
+	struct cpuacct *ca = cgroup_ca(cgrp);
 	u64 totalcpuusage = 0;
 	int i;
 
@@ -8250,9 +8250,9 @@ static struct cftype files[] = {
 	},
 };
 
-static int cpuacct_populate(struct cgroup_subsys *ss, struct cgroup *cont)
+static int cpuacct_populate(struct cgroup_subsys *ss, struct cgroup *cgrp)
 {
-	return cgroup_add_files(cont, ss, files, ARRAY_SIZE(files));
+	return cgroup_add_files(cgrp, ss, files, ARRAY_SIZE(files));
 }
 
 /*

--
regards,
Dhaval

