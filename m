Return-Path: <linux-kernel-owner+w=401wt.eu-S1751877AbZLMI66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbZLMI66 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 03:58:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751816AbZLMI65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 03:58:57 -0500
Received: from mail.perches.com ([173.55.12.10]:1147 "HELO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751803AbZLMI65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 03:58:57 -0500
Subject: [PATCH] trace_syscalls.c: Use pr_fmt and pr_<level>
From: Joe Perches <joe@perches.com>
To: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 13 Dec 2009 00:58:55 -0800
Message-ID: <1260694735.8189.38.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I can't tell if the pr_info formats should be newline
terminated or not, so I left them as is.

Add #define pr_fmt(fmt) "event trace: " fmt
Remove prefixes from pr_info
Coalesce pr_<level> format strings
Add spaces between "activate" and "syscalls"
Fix pr_info entry/exit copy/paste typo

Signed-off-by: Joe Perches <joe@perches.com>
---
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 57501d9..35ca3e8 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -1,3 +1,5 @@
+#define pr_fmt(fmt) "event trace: " fmt
+
 #include <trace/syscall.h>
 #include <trace/events/syscalls.h>
 #include <linux/kernel.h>
@@ -334,8 +336,7 @@ int reg_event_syscall_enter(struct ftrace_event_call *call)
 	if (!sys_refcount_enter)
 		ret = register_trace_sys_enter(ftrace_syscall_enter);
 	if (ret) {
-		pr_info("event trace: Could not activate"
-				"syscall entry trace point");
+		pr_info("Could not activate syscall entry trace point");
 	} else {
 		set_bit(num, enabled_enter_syscalls);
 		sys_refcount_enter++;
@@ -371,8 +372,7 @@ int reg_event_syscall_exit(struct ftrace_event_call *call)
 	if (!sys_refcount_exit)
 		ret = register_trace_sys_exit(ftrace_syscall_exit);
 	if (ret) {
-		pr_info("event trace: Could not activate"
-				"syscall exit trace point");
+		pr_info("Could not activate syscall exit trace point");
 	} else {
 		set_bit(num, enabled_exit_syscalls);
 		sys_refcount_exit++;
@@ -515,8 +515,7 @@ int prof_sysenter_enable(struct ftrace_event_call *call)
 	if (!sys_prof_refcount_enter)
 		ret = register_trace_sys_enter(prof_syscall_enter);
 	if (ret) {
-		pr_info("event trace: Could not activate"
-				"syscall entry trace point");
+		pr_info("Could not activate syscall entry trace point");
 	} else {
 		set_bit(num, enabled_prof_enter_syscalls);
 		sys_prof_refcount_enter++;
@@ -616,8 +615,7 @@ int prof_sysexit_enable(struct ftrace_event_call *call)
 	if (!sys_prof_refcount_exit)
 		ret = register_trace_sys_exit(prof_syscall_exit);
 	if (ret) {
-		pr_info("event trace: Could not activate"
-				"syscall entry trace point");
+		pr_info("Could not activate syscall exit trace point");
 	} else {
 		set_bit(num, enabled_prof_exit_syscalls);
 		sys_prof_refcount_exit++;


