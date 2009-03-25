Return-Path: <linux-kernel-owner+w=401wt.eu-S1763457AbZCYRfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763457AbZCYRfj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 13:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756750AbZCYRfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 13:35:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:54400 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753079AbZCYRf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 13:35:29 -0400
Date: Wed, 25 Mar 2009 17:33:44 GMT
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, srostedt@redhat.com, tglx@linutronix.de,
       laijs@cn.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, srostedt@redhat.com, tglx@linutronix.de,
       laijs@cn.fujitsu.com, mingo@elte.hu
In-Reply-To: <49C9F266.2060706@cn.fujitsu.com>
References: <49C9F266.2060706@cn.fujitsu.com>
Subject: [tip:tracing/ftrace] trace_workqueues: fix empty line's output
Message-ID: <tip-2f63b840bc8a816ac879ee773b035cf3e433fae4@git.kernel.org>
Git-Commit-ID: 2f63b840bc8a816ac879ee773b035cf3e433fae4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 25 Mar 2009 17:33:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2f63b840bc8a816ac879ee773b035cf3e433fae4
Gitweb:     http://git.kernel.org/tip/2f63b840bc8a816ac879ee773b035cf3e433fae4
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Wed, 25 Mar 2009 16:59:18 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 25 Mar 2009 18:32:35 +0100

trace_workqueues: fix empty line's output

Empty lines separate cpus stat. After previous
fix(trace_stat: keep original order) applied, the empty lines
are displayed at incorrect position.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Steven Rostedt <srostedt@redhat.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <49C9F266.2060706@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace_workqueue.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_workqueue.c b/kernel/trace/trace_workqueue.c
index 9ab035b..797201e 100644
--- a/kernel/trace/trace_workqueue.c
+++ b/kernel/trace/trace_workqueue.c
@@ -196,6 +196,11 @@ static int workqueue_stat_show(struct seq_file *s, void *p)
 	struct pid *pid;
 	struct task_struct *tsk;
 
+	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
+	if (&cws->list == workqueue_cpu_stat(cpu)->list.next)
+		seq_printf(s, "\n");
+	spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
+
 	pid = find_get_pid(cws->pid);
 	if (pid) {
 		tsk = get_pid_task(pid, PIDTYPE_PID);
@@ -208,18 +213,13 @@ static int workqueue_stat_show(struct seq_file *s, void *p)
 		put_pid(pid);
 	}
 
-	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
-	if (&cws->list == workqueue_cpu_stat(cpu)->list.next)
-		seq_printf(s, "\n");
-	spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
-
 	return 0;
 }
 
 static int workqueue_stat_headers(struct seq_file *s)
 {
 	seq_printf(s, "# CPU  INSERTED  EXECUTED   NAME\n");
-	seq_printf(s, "# |      |         |          |\n\n");
+	seq_printf(s, "# |      |         |          |\n");
 	return 0;
 }
 
