Return-Path: <linux-kernel-owner+w=401wt.eu-S1753421AbZLAIX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbZLAIX4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 03:23:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753328AbZLAIXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 03:23:55 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57164 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753221AbZLAIXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 03:23:55 -0500
Message-ID: <4B14D278.4090209@cn.fujitsu.com>
Date: Tue, 01 Dec 2009 16:23:20 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Jason Baron <jbaron@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/7] trace_syscalls: remove unused event_syscall_enter and
 event_syscall_exit
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix event_enter_##sname->event
fix event_exit_##sname->event

remove unused event_syscall_enter and event_syscall_exit

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index b50974a..2f7c539 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -178,7 +178,7 @@ static void prof_sysexit_disable_##sname(struct ftrace_event_call *unused)     \
 	  event_enter_##sname = {					\
 		.name                   = "sys_enter"#sname,		\
 		.system                 = "syscalls",			\
-		.event                  = &event_syscall_enter,		\
+		.event                  = &enter_syscall_print_##sname,	\
 		.raw_init		= init_enter_##sname,		\
 		.show_format		= syscall_enter_format,		\
 		.define_fields		= syscall_enter_define_fields,	\
@@ -214,7 +214,7 @@ static void prof_sysexit_disable_##sname(struct ftrace_event_call *unused)     \
 	  event_exit_##sname = {					\
 		.name                   = "sys_exit"#sname,		\
 		.system                 = "syscalls",			\
-		.event                  = &event_syscall_exit,		\
+		.event                  = &exit_syscall_print_##sname,	\
 		.raw_init		= init_exit_##sname,		\
 		.show_format		= syscall_exit_format,		\
 		.define_fields		= syscall_exit_define_fields,	\
diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index 51ee17d..5f8827c 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -37,8 +37,6 @@ extern unsigned long arch_syscall_addr(int nr);
 extern int syscall_name_to_nr(char *name);
 void set_syscall_enter_id(int num, int id);
 void set_syscall_exit_id(int num, int id);
-extern struct trace_event event_syscall_enter;
-extern struct trace_event event_syscall_exit;
 
 extern int syscall_enter_format(struct ftrace_event_call *call,
 				struct trace_seq *s);
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 63aa807..00d6e17 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -444,14 +444,6 @@ void unreg_event_syscall_exit(struct ftrace_event_call *call)
 	mutex_unlock(&syscall_trace_lock);
 }
 
-struct trace_event event_syscall_enter = {
-	.trace			= print_syscall_enter,
-};
-
-struct trace_event event_syscall_exit = {
-	.trace			= print_syscall_exit,
-};
-
 int __init init_ftrace_syscalls(void)
 {
 	struct syscall_metadata *meta;


