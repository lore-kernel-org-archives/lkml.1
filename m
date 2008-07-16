Return-Path: <linux-kernel-owner+w=401wt.eu-S1759545AbYGPDos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759545AbYGPDos (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 23:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755386AbYGPDoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 23:44:13 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62866 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751226AbYGPDoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 23:44:12 -0400
Message-ID: <487D6E51.1000907@cn.fujitsu.com>
Date: Wed, 16 Jul 2008 11:43:13 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Jackson <pj@sgi.com>, Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] cpuset: two minor code-cleanups
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in function cpuset_update_task_memory_state()
local variable
struct task_struct *tsk = current;

and local variable tsk is used 14 times and
statement task_cs(tsk) is used twice in this function.
So using task_cs(tsk) instead of task_cs(current) is
better for readability.

And "(struct cgroup_scanner *)&scan" is not good for
readability also. (and "container_of" is used in cpuset_do_move_task(),
not "(cpuset_hotplug_scanner *)scan")

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 798b3ab..4513deb 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -369,7 +369,7 @@ void cpuset_update_task_memory_state(void)
 		my_cpusets_mem_gen = top_cpuset.mems_generation;
 	} else {
 		rcu_read_lock();
-		my_cpusets_mem_gen = task_cs(current)->mems_generation;
+		my_cpusets_mem_gen = task_cs(tsk)->mems_generation;
 		rcu_read_unlock();
 	}
 
@@ -1778,7 +1778,7 @@ static void move_member_tasks_to_cpuset(struct cpuset *from, struct cpuset *to)
 	scan.scan.heap = NULL;
 	scan.to = to->css.cgroup;
 
-	if (cgroup_scan_tasks((struct cgroup_scanner *)&scan))
+	if (cgroup_scan_tasks(&scan.scan))
 		printk(KERN_ERR "move_member_tasks_to_cpuset: "
 				"cgroup_scan_tasks failed\n");
 }





