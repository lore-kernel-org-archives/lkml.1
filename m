Return-Path: <linux-kernel-owner+w=401wt.eu-S1752193AbZGLK63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbZGLK63 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 06:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751656AbZGLK6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 06:58:21 -0400
Received: from ey-out-1920.google.com ([74.125.78.144]:52320 "EHLO
	ey-out-1920.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbZGLK6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 06:58:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=j9KS9bWR74Ow6hn+Ejg7XKI+fB6pFuoeWZYIqT0FilYGIaWoEzrvrsxkuYGlElc7d2
         np9rVKm71hs+uBUSfopFC4jfmR/RywuWgn5X2Xs4q/MNrf63XKKiKU8wFE+hO2snXDqo
         sjAxjIGTUgl1SAYHHQ3yGj1HwJvGwc59BR0qU=
MIME-Version: 1.0
Date: Sun, 12 Jul 2009 16:58:18 +0600
Message-ID: <b9df5fa10907120358t7101511cle30e025c3adcbe54@mail.gmail.com>
Subject: [PATCH] ftrace: Add missing __init in ftrace_profile_debugfs()
From: Rakib Mullick <rakib.mullick@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Impact: Fix section mismatch.

The function ftrace_profile_debugfs() references a variable placed in
.init.data section. Thus causes a section mismatch warning. Since
ftrace_profile_debugfs() has been called from only
ftrace_init_debugfs, so we can safely mark ftrace_profile_debugfs as
init. Also it contains a trivial style fix, __init should be placed
between function type and function name (ftrace_init_debugfs).

We were warned by the following warning:

 LD      kernel/trace/libftrace.o
WARNING: kernel/trace/libftrace.o(.text+0xff0): Section mismatch in
reference from the function ftrace_profile_debugfs() to the variable
.init.data:function_stats
The function ftrace_profile_debugfs() references
the variable __initdata function_stats.
This is often because ftrace_profile_debugfs lacks a __initdata
annotation or the annotation of function_stats is wrong.


---
Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

--- linus/kernel/trace/ftrace.c	2009-07-11 20:54:13.000000000 +0600
+++ rakib/kernel/trace/ftrace.c	2009-07-12 12:21:54.000000000 +0600
@@ -768,7 +768,7 @@ static struct tracer_stat function_stats
 	.stat_show	= function_stat_show
 };

-static void ftrace_profile_debugfs(struct dentry *d_tracer)
+static void __init ftrace_profile_debugfs(struct dentry *d_tracer)
 {
 	struct ftrace_profile_stat *stat;
 	struct dentry *entry;
@@ -813,7 +813,7 @@ static void ftrace_profile_debugfs(struc
 }

 #else /* CONFIG_FUNCTION_PROFILER */
-static void ftrace_profile_debugfs(struct dentry *d_tracer)
+static void __init ftrace_profile_debugfs(struct dentry *d_tracer)
 {
 }
 #endif /* CONFIG_FUNCTION_PROFILER */
@@ -3068,7 +3068,7 @@ static const struct file_operations ftra
 	.write = ftrace_pid_write,
 };

-static __init int ftrace_init_debugfs(void)
+static int __init ftrace_init_debugfs(void)
 {
 	struct dentry *d_tracer;
