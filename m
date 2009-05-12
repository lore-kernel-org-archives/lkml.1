Return-Path: <linux-kernel-owner+w=401wt.eu-S1759992AbZELKFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759992AbZELKFu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 06:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754028AbZELKFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 06:05:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59851 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013AbZELKFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 06:05:36 -0400
Date: Tue, 12 May 2009 06:04:15 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Amerigo Wang <amwang@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Message-Id: <20090512100504.6008.52782.sendpatchset@localhost.localdomain>
Subject: [Patch] RCU trace: use scnprintf instead of snprintf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


snprintf can return more than the size of buffer, this case
is not expected here, obviously. Use scnprintf instead.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

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
