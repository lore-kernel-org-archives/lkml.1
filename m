Return-Path: <linux-kernel-owner+w=401wt.eu-S1753415AbZLBKng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbZLBKng (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 05:43:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbZLBKnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 05:43:35 -0500
Received: from hera.kernel.org ([140.211.167.34]:44861 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751055AbZLBKne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 05:43:34 -0500
Date: Wed, 2 Dec 2009 10:43:03 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       jbaron@redhat.com, laijs@cn.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, jbaron@redhat.com,
       tglx@linutronix.de, laijs@cn.fujitsu.com, mingo@elte.hu
In-Reply-To: <1259734990-9034-1-git-send-regression-fweisbec@gmail.com>
References: <1259734990-9034-1-git-send-regression-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing/syscalls: Make syscall events print callbacks static
Message-ID: <tip-6b62fe019e39edfd1dbe3f224ecd0a87d9365223@git.kernel.org>
Git-Commit-ID: 6b62fe019e39edfd1dbe3f224ecd0a87d9365223
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6b62fe019e39edfd1dbe3f224ecd0a87d9365223
Gitweb:     http://git.kernel.org/tip/6b62fe019e39edfd1dbe3f224ecd0a87d9365223
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Wed, 2 Dec 2009 07:23:10 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 2 Dec 2009 09:59:02 +0100

tracing/syscalls: Make syscall events print callbacks static

enter_syscall_print_##sname and exit_syscall_print_##sname don't
need to have a global scope. Make them static.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
LKML-Reference: <1259734990-9034-1-git-send-regression-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/syscalls.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index c2df3a5..e79e2f3 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -134,7 +134,7 @@ struct perf_event_attr;
 #define SYSCALL_TRACE_ENTER_EVENT(sname)				\
 	static const struct syscall_metadata __syscall_meta_##sname;	\
 	static struct ftrace_event_call event_enter_##sname;		\
-	struct trace_event enter_syscall_print_##sname = {		\
+	static struct trace_event enter_syscall_print_##sname = {	\
 		.trace                  = print_syscall_enter,		\
 	};								\
 	static struct ftrace_event_call __used				\
@@ -156,7 +156,7 @@ struct perf_event_attr;
 #define SYSCALL_TRACE_EXIT_EVENT(sname)					\
 	static const struct syscall_metadata __syscall_meta_##sname;	\
 	static struct ftrace_event_call event_exit_##sname;		\
-	struct trace_event exit_syscall_print_##sname = {		\
+	static struct trace_event exit_syscall_print_##sname = {	\
 		.trace                  = print_syscall_exit,		\
 	};								\
 	static struct ftrace_event_call __used				\
