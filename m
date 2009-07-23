Return-Path: <linux-kernel-owner+w=401wt.eu-S1753214AbZGWDaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbZGWDaM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 23:30:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752689AbZGWDaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 23:30:11 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64726 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753181AbZGWDaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 23:30:10 -0400
Message-ID: <4A67D8E8.3020500@cn.fujitsu.com>
Date: Thu, 23 Jul 2009 11:28:40 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] trace_stack: Fix seqfile memory leak
References: <4A67D8CB.4040909@cn.fujitsu.com>
In-Reply-To: <4A67D8CB.4040909@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every time we cat stack_trace, we leak memory allocated by seq_open().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace_stack.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index a4dc8d9..0da1cff 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -294,17 +294,14 @@ static const struct seq_operations stack_trace_seq_ops = {
 
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
1.6.3

