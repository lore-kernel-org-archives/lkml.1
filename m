Return-Path: <linux-kernel-owner+w=401wt.eu-S1758072AbZCMJtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072AbZCMJtR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 05:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752331AbZCMJs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 05:48:59 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50425 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751920AbZCMJs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 05:48:59 -0400
Message-ID: <49BA2BAB.6010608@cn.fujitsu.com>
Date: Fri, 13 Mar 2009 17:47:23 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] ftrace: use seq_read
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: cleanup

VFS layer has tested the file mode, we do not need test it.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index d33d306..f8f0a75 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1118,16 +1118,6 @@ ftrace_notrace_open(struct inode *inode, struct file *file)
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
@@ -1880,7 +1870,7 @@ static const struct file_operations ftrace_failures_fops = {
 
 static const struct file_operations ftrace_filter_fops = {
 	.open = ftrace_filter_open,
-	.read = ftrace_regex_read,
+	.read = seq_read,
 	.write = ftrace_filter_write,
 	.llseek = ftrace_regex_lseek,
 	.release = ftrace_filter_release,
@@ -1888,7 +1878,7 @@ static const struct file_operations ftrace_filter_fops = {
 
 static const struct file_operations ftrace_notrace_fops = {
 	.open = ftrace_notrace_open,
-	.read = ftrace_regex_read,
+	.read = seq_read,
 	.write = ftrace_notrace_write,
 	.llseek = ftrace_regex_lseek,
 	.release = ftrace_notrace_release,
@@ -1990,16 +1980,6 @@ ftrace_graph_open(struct inode *inode, struct file *file)
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
@@ -2130,7 +2110,7 @@ ftrace_graph_write(struct file *file, const char __user *ubuf,
 
 static const struct file_operations ftrace_graph_fops = {
 	.open = ftrace_graph_open,
-	.read = ftrace_graph_read,
+	.read = seq_read,
 	.write = ftrace_graph_write,
 };
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */


