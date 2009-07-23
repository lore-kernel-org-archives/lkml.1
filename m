Return-Path: <linux-kernel-owner+w=401wt.eu-S1751275AbZGWOFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751275AbZGWOFS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 10:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751736AbZGWOFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 10:05:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:61793 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbZGWOFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 10:05:16 -0400
Message-Id: <20090723140514.198935904@goodmis.org>
References: <20090723140259.100790900@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 23 Jul 2009 10:03:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/3] trace_stack: Fix seqfile memory leak
Content-Disposition: inline; filename=0001-trace_stack-Fix-seqfile-memory-leak.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

Every time we cat stack_trace, we leak memory allocated by seq_open().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4A67D8E8.3020500@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_stack.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index e644af9..6a2a9d4 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -301,17 +301,14 @@ static const struct seq_operations stack_trace_seq_ops = {
 
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
 	.open		= stack_trace_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
+	.release	= seq_release,
 };
 
 int
-- 
1.6.3.3

-- 
