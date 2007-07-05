Return-Path: <linux-kernel-owner+w=401wt.eu-S1763252AbXGEXYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763252AbXGEXYY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 19:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762979AbXGEXWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 19:22:43 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:52140 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762975AbXGEXWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 19:22:41 -0400
Date: Fri, 6 Jul 2007 01:23:11 +0200
From: Adrian Bunk <bunk@stusta.de>
To: pj@sgi.com, simon.derr@bull.net
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] kernel/cpuset.c: cleanups
Message-ID: <20070705232311.GZ3492@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the following cleanups:
- make the following needlessly global functions static:
  - cpuset_can_attach()
  - cpuset_attach()
  - cpuset_populate()
  - cpuset_post_clone()
  - cpuset_create()
  - cpuset_destroy()
- remove the unused EXPORT_SYMBOL_GPL(cpuset_mem_spread_node)

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 kernel/cpuset.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

--- linux-2.6.22-rc6-mm1/kernel/cpuset.c.old	2007-07-03 15:40:33.000000000 +0200
+++ linux-2.6.22-rc6-mm1/kernel/cpuset.c	2007-07-04 23:32:06.000000000 +0200
@@ -873,8 +873,8 @@
 	return val;
 }
 
-int cpuset_can_attach(struct container_subsys *ss,
-		      struct container *cont, struct task_struct *tsk)
+static int cpuset_can_attach(struct container_subsys *ss,
+			     struct container *cont, struct task_struct *tsk)
 {
 	struct cpuset *cs = container_cs(cont);
 
@@ -884,9 +884,9 @@
 	return security_task_setscheduler(tsk, 0, NULL);
 }
 
-void cpuset_attach(struct container_subsys *ss,
-		   struct container *cont, struct container *oldcont,
-		   struct task_struct *tsk)
+static void cpuset_attach(struct container_subsys *ss,
+			  struct container *cont, struct container *oldcont,
+			  struct task_struct *tsk)
 {
 	cpumask_t cpus;
 	nodemask_t from, to;
@@ -1163,7 +1163,7 @@
 	.private = FILE_SPREAD_SLAB,
 };
 
-int cpuset_populate(struct container_subsys *ss, struct container *cont)
+static int cpuset_populate(struct container_subsys *ss, struct container *cont)
 {
 	int err;
 
@@ -1205,8 +1205,8 @@
  * changed to grant parent->cpus_allowed-sibling_cpus_exclusive
  * (and likewise for mems) to the new container.
  */
-void cpuset_post_clone(struct container_subsys *ss,
-		struct container *container)
+static void cpuset_post_clone(struct container_subsys *ss,
+			      struct container *container)
 {
 	struct container *parent, *child;
 	struct cpuset *cs, *parent_cs;
@@ -1234,7 +1234,7 @@
  *	Must be called with the mutex on the parent inode held
  */
 
-int cpuset_create(struct container_subsys *ss, struct container *cont)
+static int cpuset_create(struct container_subsys *ss, struct container *cont)
 {
 	struct cpuset *cs;
 	struct cpuset *parent;
@@ -1269,7 +1269,7 @@
 	return 0;
 }
 
-void cpuset_destroy(struct container_subsys *ss, struct container *cont)
+static void cpuset_destroy(struct container_subsys *ss, struct container *cont)
 {
 	struct cpuset *cs = container_cs(cont);
 
@@ -1726,7 +1726,6 @@
 	current->cpuset_mem_spread_rotor = node;
 	return node;
 }
-EXPORT_SYMBOL_GPL(cpuset_mem_spread_node);
 
 /**
  * cpuset_excl_nodes_overlap - Do we overlap @p's mem_exclusive ancestors?

