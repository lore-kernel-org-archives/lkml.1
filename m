Return-Path: <linux-kernel-owner+w=401wt.eu-S1758335AbZELHMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758335AbZELHMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 03:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756760AbZELHML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 03:12:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38458 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752635AbZELHMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 03:12:09 -0400
Date: Tue, 12 May 2009 03:11:00 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>, akpm@linux-foundation.org,
       Amerigo Wang <amwang@redhat.com>
Message-Id: <20090512071148.5664.91161.sendpatchset@localhost.localdomain>
Subject: [PATCH] trace: clean up some code
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


64 bytes are big enough to hold "%ld" of any unsigned long, thus no need to
use snprintf.

Plus, kill an unnecessary local variable.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>

---
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index a884c09..c31cc05 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2641,10 +2641,8 @@ tracing_max_lat_read(struct file *filp, char __user *ubuf,
 	char buf[64];
 	int r;
 
-	r = snprintf(buf, sizeof(buf), "%ld\n",
+	r = sprintf(buf, "%ld\n",
 		     *ptr == (unsigned long)-1 ? -1 : nsecs_to_usecs(*ptr));
-	if (r > sizeof(buf))
-		r = sizeof(buf);
 	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
 }
 
diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index c750f65..007e435 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -143,9 +143,7 @@ stack_max_size_read(struct file *filp, char __user *ubuf,
 	char buf[64];
 	int r;
 
-	r = snprintf(buf, sizeof(buf), "%ld\n", *ptr);
-	if (r > sizeof(buf))
-		r = sizeof(buf);
+	r = sprintf(buf, "%ld\n", *ptr);
 	return simple_read_from_buffer(ubuf, count, ppos, buf, r);
 }
 
@@ -301,11 +299,7 @@ static const struct seq_operations stack_trace_seq_ops = {
 
 static int stack_trace_open(struct inode *inode, struct file *file)
 {
-	int ret;
-
-	ret = seq_open(file, &stack_trace_seq_ops);
-
-	return ret;
+	return seq_open(file, &stack_trace_seq_ops);
 }
 
 static const struct file_operations stack_trace_fops = {
