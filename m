Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab0CEVX5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 16:23:57 -0500
Received: from casper.infradead.org ([85.118.1.10]:57759 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab0CEVX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 16:23:56 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/1] trace: Update the comm field in the right variable in update_max_tr
Date: Fri,  5 Mar 2010 18:23:50 -0300
Message-Id: <1267824230-23861-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

The right one to update the is the max_data variable, i.e. max_tr.data[cpu].

Before this patch the max_tr.data[cpu]->comm was zeroed and the /debug/trace
ended up showing just the '-' sign followed by the pid.

Also remove a needless initialization of max_data.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 kernel/trace/trace.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 4af5b21..8ed1e35 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -520,7 +520,7 @@ static void
 __update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 {
 	struct trace_array_cpu *data = tr->data[cpu];
-	struct trace_array_cpu *max_data = tr->data[cpu];
+	struct trace_array_cpu *max_data;
 
 	max_tr.cpu = cpu;
 	max_tr.time_start = data->preempt_timestamp;
@@ -530,7 +530,7 @@ __update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 	max_data->critical_start = data->critical_start;
 	max_data->critical_end = data->critical_end;
 
-	memcpy(data->comm, tsk->comm, TASK_COMM_LEN);
+	memcpy(max_data->comm, tsk->comm, TASK_COMM_LEN);
 	max_data->pid = tsk->pid;
 	max_data->uid = task_uid(tsk);
 	max_data->nice = tsk->static_prio - 20 - MAX_RT_PRIO;
-- 
1.5.5.1

