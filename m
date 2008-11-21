Return-Path: <linux-kernel-owner+w=401wt.eu-S1757212AbYKUI4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212AbYKUI4u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 03:56:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753971AbYKUIw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 03:52:59 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64163 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754804AbYKUIw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 03:52:58 -0500
Message-ID: <4926762E.9010207@cn.fujitsu.com>
Date: Fri, 21 Nov 2008 16:49:50 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: [PATCH 2/2] cpuset: use cgroup_path() in proc_cpuset_show()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


use cgroup_path() instead of
task_subsys_state(tsk, cpuset_subsys_id)->cgroup

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 3e00526..e0e087e 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2387,7 +2386,7 @@ static int proc_cpuset_show(struct seq_file *m, void *unused_v)
 	struct pid *pid;
 	struct task_struct *tsk;
 	char *buf;
-	struct cgroup_subsys_state *css;
+	struct cgroup *cgp;
 	int retval;
 
 	retval = -ENOMEM;
@@ -2403,8 +2402,8 @@ static int proc_cpuset_show(struct seq_file *m, void *unused_v)
 
 	retval = -EINVAL;
 	cgroup_lock();
-	css = task_subsys_state(tsk, cpuset_subsys_id);
-	retval = cgroup_path(css->cgroup, buf, PAGE_SIZE);
+	cgp = task_cgroup(tsk, cpuset_subsys_id);
+	retval = cgroup_path(cgp, buf, PAGE_SIZE);
 	if (retval < 0)
 		goto out_unlock;
 	seq_puts(m, buf);


