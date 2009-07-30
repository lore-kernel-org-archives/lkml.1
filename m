Return-Path: <linux-kernel-owner+w=401wt.eu-S1752518AbZG3Tzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518AbZG3Tzh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 15:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752420AbZG3Tzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 15:55:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:32880 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541AbZG3Tz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 15:55:28 -0400
Date: Thu, 30 Jul 2009 19:54:59 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, lizf@cn.fujitsu.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <4A67D8E8.3020500@cn.fujitsu.com>
References: <4A67D8E8.3020500@cn.fujitsu.com>
Subject: [tip:tracing/urgent] trace_stack: Fix seqfile memory leak
Message-ID: <tip-d8cc1ab793993c886c62abf77c93287df33ffd8b@git.kernel.org>
Git-Commit-ID: d8cc1ab793993c886c62abf77c93287df33ffd8b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 30 Jul 2009 19:55:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d8cc1ab793993c886c62abf77c93287df33ffd8b
Gitweb:     http://git.kernel.org/tip/d8cc1ab793993c886c62abf77c93287df33ffd8b
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Thu, 23 Jul 2009 11:28:40 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 23 Jul 2009 09:52:09 -0400

trace_stack: Fix seqfile memory leak

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
