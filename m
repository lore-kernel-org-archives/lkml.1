Return-Path: <linux-kernel-owner+w=401wt.eu-S1752933AbZH1M3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933AbZH1M3m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 08:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbZH1M3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 08:29:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:55515 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752844AbZH1M3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 08:29:37 -0400
Date: Fri, 28 Aug 2009 12:28:43 GMT
From: tip-bot for Jason Baron <jbaron@redhat.com>
Cc: brueckner@linux.vnet.ibm.com, mathieu.desnoyers@polymtl.ca,
       mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, heiko.carstens@de.ibm.com, tglx@linutronix.de,
       jbaron@redhat.com, laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       hpa@zytor.com, jiayingz@google.com, lizf@cn.fujitsu.com,
       lethal@linux-sh.org, jistone@redhat.com, mingo@elte.hu,
       mbligh@google.com
Reply-To: mingo@redhat.com, mathieu.desnoyers@polymtl.ca,
       brueckner@linux.vnet.ibm.com, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, heiko.carstens@de.ibm.com, tglx@linutronix.de,
       jbaron@redhat.com, laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       hpa@zytor.com, jiayingz@google.com, lizf@cn.fujitsu.com,
       lethal@linux-sh.org, jistone@redhat.com, mingo@elte.hu,
       mbligh@google.com
In-Reply-To: <9b4f1a84ecae57cc6599412772efa36f0d2b815b.1251146513.git.jbaron@redhat.com>
References: <9b4f1a84ecae57cc6599412772efa36f0d2b815b.1251146513.git.jbaron@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: Convert event tracing code to use NR_syscalls
Message-ID: <tip-57421dbbdc932d65f0e6a41ebb027a2bfe3d0669@git.kernel.org>
Git-Commit-ID: 57421dbbdc932d65f0e6a41ebb027a2bfe3d0669
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 28 Aug 2009 12:28:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  57421dbbdc932d65f0e6a41ebb027a2bfe3d0669
Gitweb:     http://git.kernel.org/tip/57421dbbdc932d65f0e6a41ebb027a2bfe3d0669
Author:     Jason Baron <jbaron@redhat.com>
AuthorDate: Mon, 24 Aug 2009 17:40:22 -0400
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Wed, 26 Aug 2009 21:30:02 +0200

tracing: Convert event tracing code to use NR_syscalls

Convert the syscalls event tracing code to use NR_syscalls, instead of
FTRACE_SYSCALL_MAX. NR_syscalls is standard accross most arches, and
reduces code confusion/complexity.

Signed-off-by: Jason Baron <jbaron@redhat.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jiaying Zhang <jiayingz@google.com>
Cc: Martin Bligh <mbligh@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Josh Stone <jistone@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anwin <hpa@zytor.com>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
LKML-Reference: <9b4f1a84ecae57cc6599412772efa36f0d2b815b.1251146513.git.jbaron@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>


---
 arch/x86/kernel/ftrace.c      |    8 ++++----
 kernel/trace/trace_syscalls.c |   24 ++++++++++++------------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 3cff121..9dbb527 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -494,7 +494,7 @@ static struct syscall_metadata *find_syscall_meta(unsigned long *syscall)
 
 struct syscall_metadata *syscall_nr_to_meta(int nr)
 {
-	if (!syscalls_metadata || nr >= FTRACE_SYSCALL_MAX || nr < 0)
+	if (!syscalls_metadata || nr >= NR_syscalls || nr < 0)
 		return NULL;
 
 	return syscalls_metadata[nr];
@@ -507,7 +507,7 @@ int syscall_name_to_nr(char *name)
 	if (!syscalls_metadata)
 		return -1;
 
-	for (i = 0; i < FTRACE_SYSCALL_MAX; i++) {
+	for (i = 0; i < NR_syscalls; i++) {
 		if (syscalls_metadata[i]) {
 			if (!strcmp(syscalls_metadata[i]->name, name))
 				return i;
@@ -533,13 +533,13 @@ static int __init arch_init_ftrace_syscalls(void)
 	unsigned long **psys_syscall_table = &sys_call_table;
 
 	syscalls_metadata = kzalloc(sizeof(*syscalls_metadata) *
-					FTRACE_SYSCALL_MAX, GFP_KERNEL);
+					NR_syscalls, GFP_KERNEL);
 	if (!syscalls_metadata) {
 		WARN_ON(1);
 		return -ENOMEM;
 	}
 
-	for (i = 0; i < FTRACE_SYSCALL_MAX; i++) {
+	for (i = 0; i < NR_syscalls; i++) {
 		meta = find_syscall_meta(psys_syscall_table[i]);
 		syscalls_metadata[i] = meta;
 	}
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index cb7f600..4f5fae6 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -11,8 +11,8 @@
 static DEFINE_MUTEX(syscall_trace_lock);
 static int sys_refcount_enter;
 static int sys_refcount_exit;
-static DECLARE_BITMAP(enabled_enter_syscalls, FTRACE_SYSCALL_MAX);
-static DECLARE_BITMAP(enabled_exit_syscalls, FTRACE_SYSCALL_MAX);
+static DECLARE_BITMAP(enabled_enter_syscalls, NR_syscalls);
+static DECLARE_BITMAP(enabled_exit_syscalls, NR_syscalls);
 
 enum print_line_t
 print_syscall_enter(struct trace_iterator *iter, int flags)
@@ -289,7 +289,7 @@ int reg_event_syscall_enter(void *ptr)
 
 	name = (char *)ptr;
 	num = syscall_name_to_nr(name);
-	if (num < 0 || num >= FTRACE_SYSCALL_MAX)
+	if (num < 0 || num >= NR_syscalls)
 		return -ENOSYS;
 	mutex_lock(&syscall_trace_lock);
 	if (!sys_refcount_enter)
@@ -312,7 +312,7 @@ void unreg_event_syscall_enter(void *ptr)
 
 	name = (char *)ptr;
 	num = syscall_name_to_nr(name);
-	if (num < 0 || num >= FTRACE_SYSCALL_MAX)
+	if (num < 0 || num >= NR_syscalls)
 		return;
 	mutex_lock(&syscall_trace_lock);
 	sys_refcount_enter--;
@@ -330,7 +330,7 @@ int reg_event_syscall_exit(void *ptr)
 
 	name = (char *)ptr;
 	num = syscall_name_to_nr(name);
-	if (num < 0 || num >= FTRACE_SYSCALL_MAX)
+	if (num < 0 || num >= NR_syscalls)
 		return -ENOSYS;
 	mutex_lock(&syscall_trace_lock);
 	if (!sys_refcount_exit)
@@ -353,7 +353,7 @@ void unreg_event_syscall_exit(void *ptr)
 
 	name = (char *)ptr;
 	num = syscall_name_to_nr(name);
-	if (num < 0 || num >= FTRACE_SYSCALL_MAX)
+	if (num < 0 || num >= NR_syscalls)
 		return;
 	mutex_lock(&syscall_trace_lock);
 	sys_refcount_exit--;
@@ -373,8 +373,8 @@ struct trace_event event_syscall_exit = {
 
 #ifdef CONFIG_EVENT_PROFILE
 
-static DECLARE_BITMAP(enabled_prof_enter_syscalls, FTRACE_SYSCALL_MAX);
-static DECLARE_BITMAP(enabled_prof_exit_syscalls, FTRACE_SYSCALL_MAX);
+static DECLARE_BITMAP(enabled_prof_enter_syscalls, NR_syscalls);
+static DECLARE_BITMAP(enabled_prof_exit_syscalls, NR_syscalls);
 static int sys_prof_refcount_enter;
 static int sys_prof_refcount_exit;
 
@@ -420,7 +420,7 @@ int reg_prof_syscall_enter(char *name)
 	int num;
 
 	num = syscall_name_to_nr(name);
-	if (num < 0 || num >= FTRACE_SYSCALL_MAX)
+	if (num < 0 || num >= NR_syscalls)
 		return -ENOSYS;
 
 	mutex_lock(&syscall_trace_lock);
@@ -442,7 +442,7 @@ void unreg_prof_syscall_enter(char *name)
 	int num;
 
 	num = syscall_name_to_nr(name);
-	if (num < 0 || num >= FTRACE_SYSCALL_MAX)
+	if (num < 0 || num >= NR_syscalls)
 		return;
 
 	mutex_lock(&syscall_trace_lock);
@@ -481,7 +481,7 @@ int reg_prof_syscall_exit(char *name)
 	int num;
 
 	num = syscall_name_to_nr(name);
-	if (num < 0 || num >= FTRACE_SYSCALL_MAX)
+	if (num < 0 || num >= NR_syscalls)
 		return -ENOSYS;
 
 	mutex_lock(&syscall_trace_lock);
@@ -503,7 +503,7 @@ void unreg_prof_syscall_exit(char *name)
 	int num;
 
 	num = syscall_name_to_nr(name);
-	if (num < 0 || num >= FTRACE_SYSCALL_MAX)
+	if (num < 0 || num >= NR_syscalls)
 		return;
 
 	mutex_lock(&syscall_trace_lock);
