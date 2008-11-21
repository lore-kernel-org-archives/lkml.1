Return-Path: <linux-kernel-owner+w=401wt.eu-S1756786AbYKUI5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786AbYKUI5R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 03:57:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752970AbYKUIxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 03:53:06 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49667 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752870AbYKUIxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 03:53:04 -0500
Message-ID: <49267633.8040607@cn.fujitsu.com>
Date: Fri, 21 Nov 2008 16:49:55 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: [PATCH] cgroups: use task_lock() for access tsk->cgroups safe in
 cgroup_clone()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


use task_lock() protect tsk->cgroups and get_css_set(tsk->cgroups)


Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 358e775..ddc10ac 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2933,6 +2943,7 @@ int cgroup_clone(struct task_struct *tsk, struct cgroup_subsys *subsys,
 		mutex_unlock(&cgroup_mutex);
 		return 0;
 	}
+	task_lock(tsk);
 	cg = tsk->cgroups;
 	parent = task_cgroup(tsk, subsys->subsys_id);
 
@@ -2941,6 +2952,7 @@ int cgroup_clone(struct task_struct *tsk, struct cgroup_subsys *subsys,
 
 	/* Keep the cgroup alive */
 	get_css_set(cg);
+	task_unlock(tsk);
 	mutex_unlock(&cgroup_mutex);
 
 	/* Now do the VFS work to create a cgroup */

