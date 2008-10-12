Return-Path: <linux-kernel-owner+w=401wt.eu-S1756744AbYJLJcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744AbYJLJcg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 05:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbYJLJbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 05:31:47 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64294 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751533AbYJLJbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 05:31:45 -0400
Message-ID: <48F1C378.6020202@cn.fujitsu.com>
Date: Sun, 12 Oct 2008 17:29:28 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, Paul Menage <menage@google.com>,
       Paul Jackson <pj@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] cpuset: use seq_*mask_* to print masks
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1) seq_file excepts that m->count == m->size when it's buf is full,
   so current code will causes bugs when buf is overflow.

2) There is not too good that cpuset accesses struct seq_file's
   fields directly.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index eab7bd6..684d21b 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2437,19 +2437,15 @@ const struct file_operations proc_cpuset_operations = {
 void cpuset_task_status_allowed(struct seq_file *m, struct task_struct *task)
 {
 	seq_printf(m, "Cpus_allowed:\t");
-	m->count += cpumask_scnprintf(m->buf + m->count, m->size - m->count,
-					task->cpus_allowed);
+	seq_cpumask(m, &task->cpus_allowed);
 	seq_printf(m, "\n");
 	seq_printf(m, "Cpus_allowed_list:\t");
-	m->count += cpulist_scnprintf(m->buf + m->count, m->size - m->count,
-					task->cpus_allowed);
+	seq_cpumask_list(m, &task->cpus_allowed);
 	seq_printf(m, "\n");
 	seq_printf(m, "Mems_allowed:\t");
-	m->count += nodemask_scnprintf(m->buf + m->count, m->size - m->count,
-					task->mems_allowed);
+	seq_nodemask(m, &task->mems_allowed);
 	seq_printf(m, "\n");
 	seq_printf(m, "Mems_allowed_list:\t");
-	m->count += nodelist_scnprintf(m->buf + m->count, m->size - m->count,
-					task->mems_allowed);
+	seq_nodemask_list(m, &task->mems_allowed);
 	seq_printf(m, "\n");
 }




