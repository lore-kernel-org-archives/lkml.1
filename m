Return-Path: <linux-kernel-owner+w=401wt.eu-S1758767AbZFSH0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758767AbZFSH0f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 03:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754759AbZFSH0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 03:26:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37438 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753304AbZFSH0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 03:26:25 -0400
Date: Fri, 19 Jun 2009 03:26:13 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
       Amerigo Wang <amwang@redhat.com>, mingo@elte.hu
Message-Id: <20090619072828.6575.84295.sendpatchset@localhost.localdomain>
Subject: [Resend Patch] RCU trace: use scnprintf instead of snprintf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


snprintf can return more than the size of buffer, this case
is not expected here, obviously. Use scnprintf instead.

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>

---
diff --git a/kernel/rcupreempt_trace.c b/kernel/rcupreempt_trace.c
index 7c2665c..4ea4300 100644
--- a/kernel/rcupreempt_trace.c
+++ b/kernel/rcupreempt_trace.c
@@ -234,11 +234,11 @@ static ssize_t rcuctrs_read(struct file *filp, char __user *buffer,
 
 	mutex_lock(&rcupreempt_trace_mutex);
 
-	cnt += snprintf(&rcupreempt_trace_buf[cnt], RCUPREEMPT_TRACE_BUF_SIZE,
+	cnt += scnprintf(&rcupreempt_trace_buf[cnt], RCUPREEMPT_TRACE_BUF_SIZE,
 				"CPU last cur F M\n");
 	for_each_online_cpu(cpu) {
 		long *flipctr = rcupreempt_flipctr(cpu);
-		cnt += snprintf(&rcupreempt_trace_buf[cnt],
+		cnt += scnprintf(&rcupreempt_trace_buf[cnt],
 				RCUPREEMPT_TRACE_BUF_SIZE - cnt,
 					"%3d %4ld %3ld %d %d\n",
 			       cpu,
@@ -247,12 +247,12 @@ static ssize_t rcuctrs_read(struct file *filp, char __user *buffer,
 			       rcupreempt_flip_flag(cpu),
 			       rcupreempt_mb_flag(cpu));
 	}
-	cnt += snprintf(&rcupreempt_trace_buf[cnt],
+	cnt += scnprintf(&rcupreempt_trace_buf[cnt],
 			RCUPREEMPT_TRACE_BUF_SIZE - cnt,
 			"ggp = %ld, state = %s\n",
 			rcu_batches_completed(),
 			rcupreempt_try_flip_state_name());
-	cnt += snprintf(&rcupreempt_trace_buf[cnt],
+	cnt += scnprintf(&rcupreempt_trace_buf[cnt],
 			RCUPREEMPT_TRACE_BUF_SIZE - cnt,
 			"\n");
 	bcount = simple_read_from_buffer(buffer, count, ppos,
