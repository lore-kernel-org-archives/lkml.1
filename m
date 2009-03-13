Return-Path: <linux-kernel-owner+w=401wt.eu-S1756758AbZCMKka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758AbZCMKka (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 06:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753062AbZCMKkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 06:40:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:39681 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353AbZCMKkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 06:40:16 -0400
Date: Fri, 13 Mar 2009 10:39:28 GMT
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       srostedt@redhat.com, tglx@linutronix.de, laijs@cn.fujitsu.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       srostedt@redhat.com, tglx@linutronix.de, laijs@cn.fujitsu.com,
       mingo@elte.hu
In-Reply-To: <49BA2BAB.6010608@cn.fujitsu.com>
References: <49BA2BAB.6010608@cn.fujitsu.com>
Subject: [tip:tracing/ftrace] ftrace: use seq_read
Message-ID: <tip-850a80cfaa5aec3e626eb3736eff890a80e4fa77@git.kernel.org>
Git-Commit-ID: 850a80cfaa5aec3e626eb3736eff890a80e4fa77
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 10:39:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  850a80cfaa5aec3e626eb3736eff890a80e4fa77
Gitweb:     http://git.kernel.org/tip/850a80cfaa5aec3e626eb3736eff890a80e4fa77
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Fri, 13 Mar 2009 17:47:23 +0800
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 13 Mar 2009 11:35:31 +0100

ftrace: use seq_read

Impact: cleanup

VFS layer has tested the file mode, we do not need test it.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <srostedt@redhat.com>
LKML-Reference: <49BA2BAB.6010608@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/ftrace.c |   26 +++-----------------------
 1 files changed, 3 insertions(+), 23 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 08f4a62..bf78a4c 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1120,16 +1120,6 @@ ftrace_notrace_open(struct inode *inode, struct file *file)
 	return ftrace_regex_open(inode, file, 0);
 }
 
-static ssize_t
-ftrace_regex_read(struct file *file, char __user *ubuf,
-		       size_t cnt, loff_t *ppos)
-{
-	if (file->f_mode & FMODE_READ)
-		return seq_read(file, ubuf, cnt, ppos);
-	else
-		return -EPERM;
-}
-
 static loff_t
 ftrace_regex_lseek(struct file *file, loff_t offset, int origin)
 {
@@ -1882,7 +1872,7 @@ static const struct file_operations ftrace_failures_fops = {
 
 static const struct file_operations ftrace_filter_fops = {
 	.open = ftrace_filter_open,
-	.read = ftrace_regex_read,
+	.read = seq_read,
 	.write = ftrace_filter_write,
 	.llseek = ftrace_regex_lseek,
 	.release = ftrace_filter_release,
@@ -1890,7 +1880,7 @@ static const struct file_operations ftrace_filter_fops = {
 
 static const struct file_operations ftrace_notrace_fops = {
 	.open = ftrace_notrace_open,
-	.read = ftrace_regex_read,
+	.read = seq_read,
 	.write = ftrace_notrace_write,
 	.llseek = ftrace_regex_lseek,
 	.release = ftrace_notrace_release,
@@ -1992,16 +1982,6 @@ ftrace_graph_open(struct inode *inode, struct file *file)
 	return ret;
 }
 
-static ssize_t
-ftrace_graph_read(struct file *file, char __user *ubuf,
-		       size_t cnt, loff_t *ppos)
-{
-	if (file->f_mode & FMODE_READ)
-		return seq_read(file, ubuf, cnt, ppos);
-	else
-		return -EPERM;
-}
-
 static int
 ftrace_set_func(unsigned long *array, int *idx, char *buffer)
 {
@@ -2132,7 +2112,7 @@ ftrace_graph_write(struct file *file, const char __user *ubuf,
 
 static const struct file_operations ftrace_graph_fops = {
 	.open = ftrace_graph_open,
-	.read = ftrace_graph_read,
+	.read = seq_read,
 	.write = ftrace_graph_write,
 };
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
