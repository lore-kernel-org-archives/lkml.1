Return-Path: <linux-kernel-owner+w=401wt.eu-S1753971AbZK0FuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971AbZK0FuQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 00:50:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753610AbZK0FuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 00:50:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:57903 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753768AbZK0FuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 00:50:06 -0500
Date: Fri, 27 Nov 2009 05:49:32 GMT
From: tip-bot for Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       jbaron@redhat.com, laijs@cn.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, jbaron@redhat.com,
       tglx@linutronix.de, laijs@cn.fujitsu.com, mingo@elte.hu
In-Reply-To: <4B0E330D.1070206@cn.fujitsu.com>
References: <4B0E330D.1070206@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] trace_syscalls: Add syscall nr field
Message-ID: <tip-0f1ef51d244809f417bdf45cdb00109fb6005672@git.kernel.org>
Git-Commit-ID: 0f1ef51d244809f417bdf45cdb00109fb6005672
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0f1ef51d244809f417bdf45cdb00109fb6005672
Gitweb:     http://git.kernel.org/tip/0f1ef51d244809f417bdf45cdb00109fb6005672
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Thu, 26 Nov 2009 15:49:33 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 27 Nov 2009 06:24:19 +0100

trace_syscalls: Add syscall nr field

Field syscall number is missed in syscall_enter_define_fields()/
syscall_exit_define_fields().

Syscall number is also needed for event filter or other users.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <4B0E330D.1070206@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/trace_syscalls.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 9189cbe..63aa807 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -261,6 +261,10 @@ int syscall_enter_define_fields(struct ftrace_event_call *call)
 	if (ret)
 		return ret;
 
+	ret = trace_define_field(call, SYSCALL_FIELD(int, nr), FILTER_OTHER);
+	if (ret)
+		return ret;
+
 	for (i = 0; i < meta->nb_args; i++) {
 		ret = trace_define_field(call, meta->types[i],
 					 meta->args[i], offset,
@@ -281,6 +285,10 @@ int syscall_exit_define_fields(struct ftrace_event_call *call)
 	if (ret)
 		return ret;
 
+	ret = trace_define_field(call, SYSCALL_FIELD(int, nr), FILTER_OTHER);
+	if (ret)
+		return ret;
+
 	ret = trace_define_field(call, SYSCALL_FIELD(long, ret),
 				 FILTER_OTHER);
 
