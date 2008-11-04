Return-Path: <linux-kernel-owner+w=401wt.eu-S1754840AbYKDIUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840AbYKDIUF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 03:20:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753481AbYKDITy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 03:19:54 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63417 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753427AbYKDITx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 03:19:53 -0500
Message-ID: <49100501.8050002@cn.fujitsu.com>
Date: Tue, 04 Nov 2008 16:17:05 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH] sched debug: remove NULL checking in print_cfs/rt_rq()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cfs->tg is initialized in init_tg_cfs_entry() with tg != NULL, and
will never be invalidated to NULL. And the underlying cgroup of a
valid task_group is always valid.

Same for rt->tg.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/sched_debug.c |   14 ++------------
 1 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 5ae1776..d25cefe 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -121,14 +121,9 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 
 #if defined(CONFIG_CGROUP_SCHED) && defined(CONFIG_FAIR_GROUP_SCHED)
 	char path[128] = "";
-	struct cgroup *cgroup = NULL;
 	struct task_group *tg = cfs_rq->tg;
 
-	if (tg)
-		cgroup = tg->css.cgroup;
-
-	if (cgroup)
-		cgroup_path(cgroup, path, sizeof(path));
+	cgroup_path(tg->css.cgroup, path, sizeof(path));
 
 	SEQ_printf(m, "\ncfs_rq[%d]:%s\n", cpu, path);
 #else
@@ -193,14 +188,9 @@ void print_rt_rq(struct seq_file *m, int cpu, struct rt_rq *rt_rq)
 {
 #if defined(CONFIG_CGROUP_SCHED) && defined(CONFIG_RT_GROUP_SCHED)
 	char path[128] = "";
-	struct cgroup *cgroup = NULL;
 	struct task_group *tg = rt_rq->tg;
 
-	if (tg)
-		cgroup = tg->css.cgroup;
-
-	if (cgroup)
-		cgroup_path(cgroup, path, sizeof(path));
+	cgroup_path(tg->css.cgroup, path, sizeof(path));
 
 	SEQ_printf(m, "\nrt_rq[%d]:%s\n", cpu, path);
 #else
-- 
1.5.4.rc3
