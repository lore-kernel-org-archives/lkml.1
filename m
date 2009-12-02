Return-Path: <linux-kernel-owner+w=401wt.eu-S1753105AbZLBGXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105AbZLBGXG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 01:23:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbZLBGXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 01:23:05 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:46831 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbZLBGXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 01:23:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=scEFu1Wrr9PCd+7rd101AD1YJB0jhCl7q8HLrJCwC3qcFbaBRJJU35fz1ANdIl57pB
         ikTX6Cu0NTV/9XTGG/72JPwobM+YD2Ij4q8Lhvh2s1URap48GmfZuKw0VtVNEQRx43Nw
         NZsikvVBVQJcu4JaDYqKSPt3vDnE1sHp00sXE=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH] tracing/syscalls: Make syscall events print callbacks static
Date: Wed,  2 Dec 2009 07:23:10 +0100
Message-Id: <1259734990-9034-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

enter_syscall_print_##sname and exit_syscall_print_##sname don't need
to have a global scope. Make them static.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
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
-- 
1.6.2.3

