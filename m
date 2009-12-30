Return-Path: <linux-kernel-owner+w=401wt.eu-S1752614AbZL3JcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbZL3JcB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 04:32:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbZL3Jb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 04:31:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:57467 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752429AbZL3Jb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 04:31:57 -0500
Date: Wed, 30 Dec 2009 09:31:10 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       lizf@cn.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu, prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu, prasad@linux.vnet.ibm.com
In-Reply-To: <4B3AF1D7.5040400@cn.fujitsu.com>
References: <4B3AF1D7.5040400@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] ksym_tracer: Fix to allow writing newline to ksym_trace_filter
Message-ID: <tip-3d13ec2efdb5843ad91e57b60d50b44d922cf063@git.kernel.org>
Git-Commit-ID: 3d13ec2efdb5843ad91e57b60d50b44d922cf063
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3d13ec2efdb5843ad91e57b60d50b44d922cf063
Gitweb:     http://git.kernel.org/tip/3d13ec2efdb5843ad91e57b60d50b44d922cf063
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Wed, 30 Dec 2009 14:23:19 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 30 Dec 2009 07:50:49 +0100

ksym_tracer: Fix to allow writing newline to ksym_trace_filter

It used to work, but now doesn't:

 # echo > ksym_filter
 bash: echo: write error: Invalid argument

It's caused by d954fbf0ff6b5fdfb32350e85a2f15d3db976506
("tracing: Fix wrong usage of strstrip in trace_ksyms").

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4B3AF1D7.5040400@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/trace_ksym.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_ksym.c b/kernel/trace/trace_ksym.c
index 340b6ff..160a8d8 100644
--- a/kernel/trace/trace_ksym.c
+++ b/kernel/trace/trace_ksym.c
@@ -299,8 +299,8 @@ static ssize_t ksym_trace_filter_write(struct file *file,
 	 * 2: echo 0 > ksym_trace_filter
 	 * 3: echo "*:---" > ksym_trace_filter
 	 */
-	if (!buf[0] || !strcmp(buf, "0") ||
-	    !strcmp(buf, "*:---")) {
+	if (!input_string[0] || !strcmp(input_string, "0") ||
+	    !strcmp(input_string, "*:---")) {
 		__ksym_trace_reset();
 		ret = 0;
 		goto out;
