Return-Path: <linux-kernel-owner+w=401wt.eu-S1754381AbZDPWM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381AbZDPWM5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 18:12:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753603AbZDPWMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 18:12:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:43803 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074AbZDPWMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 18:12:48 -0400
Subject: [PATCH -tip] trace: ftrace.c ftrace_profile_debugfs should use
 __init
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 17 Apr 2009 03:42:14 +0530
Message-Id: <1239919934.10567.27.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix section mismatch warning
 WARNING: kernel/built-in.o(.text+0xabe09): Section mismatch in reference from the function ftrace_profile_debugfs() to the variable .init.data:function_stats
 The function ftrace_profile_debugfs() references
 the variable __initdata function_stats.
 This is often because ftrace_profile_debugfs lacks a __initdata
 annotation or the annotation of function_stats is wrong.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 kernel/trace/ftrace.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 5b606f4..96333f1 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -761,7 +761,7 @@ static struct tracer_stat function_stats __initdata = {
 	.stat_show	= function_stat_show
 };
 
-static void ftrace_profile_debugfs(struct dentry *d_tracer)
+static void __init ftrace_profile_debugfs(struct dentry *d_tracer)
 {
 	struct ftrace_profile_stat *stat;
 	struct dentry *entry;
@@ -806,7 +806,7 @@ static void ftrace_profile_debugfs(struct dentry *d_tracer)
 }
 
 #else /* CONFIG_FUNCTION_PROFILER */
-static void ftrace_profile_debugfs(struct dentry *d_tracer)
+static void __init ftrace_profile_debugfs(struct dentry *d_tracer)
 {
 }
 #endif /* CONFIG_FUNCTION_PROFILER */
@@ -3007,7 +3007,7 @@ static const struct file_operations ftrace_pid_fops = {
 	.write = ftrace_pid_write,
 };
 
-static __init int ftrace_init_debugfs(void)
+static int __init ftrace_init_debugfs(void)
 {
 	struct dentry *d_tracer;
 
-- 
1.6.0.6



