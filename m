Return-Path: <linux-kernel-owner+w=401wt.eu-S1760283AbZBMEiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760283AbZBMEiq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 23:38:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbZBMEig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 23:38:36 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:46688 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbZBMEif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 23:38:35 -0500
From: Wenji Huang <wenji.huang@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: rostedt@goodmis.org, fweisbec@gmail.com, mingo@elte.hu,
       Wenji Huang <wenji.huang@oracle.com>
Subject: [PATCH 1/2] tracing: use the more proper parameter.
Date: Thu, 12 Feb 2009 20:39:52 -0500
Message-Id: <1234489192-18594-1-git-send-email-wenji.huang@oracle.com>
X-Mailer: git-send-email 1.5.6
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020B.4994F93D.01AB:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: clean up.

Rename tsk to next as Ingo suggested and pass it to
tracing_record_cmdline.

Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
---
 kernel/trace/trace.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 95f99a7..648df63 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -318,7 +318,7 @@ static raw_spinlock_t ftrace_max_lock =
  * for later retrieval via /debugfs/tracing/latency_trace)
  */
 static void
-__update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
+__update_max_tr(struct trace_array *tr, struct task_struct *next, int cpu)
 {
 	struct trace_array_cpu *data = tr->data[cpu];
 
@@ -328,15 +328,15 @@ __update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 	data = max_tr.data[cpu];
 	data->saved_latency = tracing_max_latency;
 
-	memcpy(data->comm, tsk->comm, TASK_COMM_LEN);
-	data->pid = tsk->pid;
-	data->uid = task_uid(tsk);
-	data->nice = tsk->static_prio - 20 - MAX_RT_PRIO;
-	data->policy = tsk->policy;
-	data->rt_priority = tsk->rt_priority;
+	memcpy(data->comm, next->comm, TASK_COMM_LEN);
+	data->pid = next->pid;
+	data->uid = task_uid(next);
+	data->nice = next->static_prio - 20 - MAX_RT_PRIO;
+	data->policy = next->policy;
+	data->rt_priority = next->rt_priority;
 
-	/* record this tasks comm */
-	tracing_record_cmdline(current);
+	/* record this task comm */
+	tracing_record_cmdline(next);
 }
 
 static void
-- 
1.5.6

