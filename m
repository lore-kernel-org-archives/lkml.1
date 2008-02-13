Return-Path: <linux-kernel-owner+w=401wt.eu-S934343AbYBMVm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934343AbYBMVm7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 16:42:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763792AbYBMVat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:30:49 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:50824 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762565AbYBMVar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:30:47 -0500
Date: Wed, 13 Feb 2008 23:30:31 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Cliff Wickman <cpw@sgi.com>, pj@sgi.com, simon.derr@bull.net
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] kernel/cpuset.c: make 3 functions static
Message-ID: <20080213213031.GG3383@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the following needlessly global functions static:
- cpuset_test_cpumask()
- cpuset_change_cpumask()
- cpuset_do_move_task()

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 kernel/cpuset.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

581c9289db3ce36232a9102505f476681c7ecf4c diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 3e296ed..5c21ae9 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -710,7 +710,8 @@ static inline int started_after(void *p1, void *p2)
  * Return nonzero if this tasks's cpus_allowed mask should be changed (in other
  * words, if its mask is not equal to its cpuset's mask).
  */
-int cpuset_test_cpumask(struct task_struct *tsk, struct cgroup_scanner *scan)
+static int cpuset_test_cpumask(struct task_struct *tsk,
+			       struct cgroup_scanner *scan)
 {
 	return !cpus_equal(tsk->cpus_allowed,
 			(cgroup_cs(scan->cg))->cpus_allowed);
@@ -727,7 +728,8 @@ int cpuset_test_cpumask(struct task_struct *tsk, struct cgroup_scanner *scan)
  * We don't need to re-check for the cgroup/cpuset membership, since we're
  * holding cgroup_lock() at this point.
  */
-void cpuset_change_cpumask(struct task_struct *tsk, struct cgroup_scanner *scan)
+static void cpuset_change_cpumask(struct task_struct *tsk,
+				  struct cgroup_scanner *scan)
 {
 	set_cpus_allowed(tsk, (cgroup_cs(scan->cg))->cpus_allowed);
 }
@@ -1648,7 +1650,8 @@ int __init cpuset_init(void)
  * Called by cgroup_scan_tasks() for each task in a cgroup.
  * Return nonzero to stop the walk through the tasks.
  */
-void cpuset_do_move_task(struct task_struct *tsk, struct cgroup_scanner *scan)
+static void cpuset_do_move_task(struct task_struct *tsk,
+				struct cgroup_scanner *scan)
 {
 	struct cpuset_hotplug_scanner *chsp;
 

