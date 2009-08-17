Return-Path: <linux-kernel-owner+w=401wt.eu-S932605AbZHQJc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605AbZHQJc3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 05:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932557AbZHQJcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 05:32:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:44552 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932565AbZHQJcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 05:32:18 -0400
Date: Mon, 17 Aug 2009 09:31:34 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, lizf@cn.fujitsu.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A891AAB.8090701@cn.fujitsu.com>
References: <4A891AAB.8090701@cn.fujitsu.com>
Subject: [tip:tracing/core] ftrace: Simplify seqfile code
Message-ID: <tip-3be04b471b95b870bd129a138463756629e86f3f@git.kernel.org>
Git-Commit-ID: 3be04b471b95b870bd129a138463756629e86f3f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 17 Aug 2009 09:31:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3be04b471b95b870bd129a138463756629e86f3f
Gitweb:     http://git.kernel.org/tip/3be04b471b95b870bd129a138463756629e86f3f
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Mon, 17 Aug 2009 16:54:03 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 17 Aug 2009 11:25:10 +0200

ftrace: Simplify seqfile code

Use seq_release_private().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4A891AAB.8090701@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/ftrace.c |   15 ++-------------
 1 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 0948634..1993b71 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1556,17 +1556,6 @@ ftrace_avail_open(struct inode *inode, struct file *file)
 	return ret;
 }
 
-int ftrace_avail_release(struct inode *inode, struct file *file)
-{
-	struct seq_file *m = (struct seq_file *)file->private_data;
-	struct ftrace_iterator *iter = m->private;
-
-	seq_release(inode, file);
-	kfree(iter);
-
-	return 0;
-}
-
 static int
 ftrace_failures_open(struct inode *inode, struct file *file)
 {
@@ -2427,14 +2416,14 @@ static const struct file_operations ftrace_avail_fops = {
 	.open = ftrace_avail_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
-	.release = ftrace_avail_release,
+	.release = seq_release_private,
 };
 
 static const struct file_operations ftrace_failures_fops = {
 	.open = ftrace_failures_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
-	.release = ftrace_avail_release,
+	.release = seq_release_private,
 };
 
 static const struct file_operations ftrace_filter_fops = {
