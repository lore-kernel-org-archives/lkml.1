Return-Path: <linux-kernel-owner+w=401wt.eu-S1756348AbYKPEhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348AbYKPEhn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 23:37:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbYKPEhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 23:37:00 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58606 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751985AbYKPEg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 23:36:58 -0500
Message-ID: <491FA290.8070601@cn.fujitsu.com>
Date: Sun, 16 Nov 2008 12:33:20 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/7] cgroups: use simple_malloc()/simple_free()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


use simple_malloc()/simple_free() for large tasks file.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 358e775..349ec9a 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2167,7 +2167,7 @@ static void release_cgroup_pid_array(struct cgroup *cgrp)
 	down_write(&cgrp->pids_mutex);
 	BUG_ON(!cgrp->pids_use_count);
 	if (!--cgrp->pids_use_count) {
-		kfree(cgrp->tasks_pids);
+		simple_free(cgrp->tasks_pids);
 		cgrp->tasks_pids = NULL;
 		cgrp->pids_length = 0;
 	}
@@ -2215,7 +2215,7 @@ static int cgroup_tasks_open(struct inode *unused, struct file *file)
 	 * show up until sometime later on.
 	 */
 	npids = cgroup_task_count(cgrp);
-	pidarray = kmalloc(npids * sizeof(pid_t), GFP_KERNEL);
+	pidarray = simple_malloc(npids * sizeof(pid_t));
 	if (!pidarray)
 		return -ENOMEM;
 	npids = pid_array_load(pidarray, npids, cgrp);



