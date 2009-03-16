Return-Path: <linux-kernel-owner+w=401wt.eu-S1757949AbZCPITl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757949AbZCPITl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 04:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbZCPITb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 04:19:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:46924 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272AbZCPITb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 04:19:31 -0400
Date: Mon, 16 Mar 2009 08:18:50 GMT
From: Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1237151439-6755-2-git-send-email-fweisbec@gmail.com>
References: <1237151439-6755-2-git-send-email-fweisbec@gmail.com>
Subject: [tip:tracing/syscalls] tracing/syscalls: various cleanups
Message-ID: <tip-6404434525bb9f8f2239998f30fd7c93f2efa5b3@git.kernel.org>
Git-Commit-ID: 6404434525bb9f8f2239998f30fd7c93f2efa5b3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 16 Mar 2009 08:18:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6404434525bb9f8f2239998f30fd7c93f2efa5b3
Gitweb:     http://git.kernel.org/tip/6404434525bb9f8f2239998f30fd7c93f2efa5b3
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Sun, 15 Mar 2009 22:10:36 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 16 Mar 2009 09:13:16 +0100

tracing/syscalls: various cleanups

Impact: cleanup

- Drop unused cpu variable
- Fix some errors on comments

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1237151439-6755-2-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace_syscalls.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index c5fc1d8..26f9a86 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -7,7 +7,7 @@
 
 static atomic_t refcount;
 
-/* Our two options */
+/* Option to display the parameters types */
 enum {
 	TRACE_SYSCALLS_OPT_TYPES = 0x1,
 };
@@ -18,7 +18,7 @@ static struct tracer_opt syscalls_opts[] = {
 };
 
 static struct tracer_flags syscalls_flags = {
-	.val = 0, /* By default: no args types */
+	.val = 0, /* By default: no parameters types */
 	.opts = syscalls_opts
 };
 
@@ -135,12 +135,9 @@ void ftrace_syscall_enter(struct pt_regs *regs)
 	struct ring_buffer_event *event;
 	int size;
 	int syscall_nr;
-	int cpu;
 
 	syscall_nr = syscall_get_nr(current, regs);
 
-	cpu = raw_smp_processor_id();
-
 	sys_data = syscall_nr_to_meta(syscall_nr);
 	if (!sys_data)
 		return;
@@ -166,12 +163,9 @@ void ftrace_syscall_exit(struct pt_regs *regs)
 	struct syscall_metadata *sys_data;
 	struct ring_buffer_event *event;
 	int syscall_nr;
-	int cpu;
 
 	syscall_nr = syscall_get_nr(current, regs);
 
-	cpu = raw_smp_processor_id();
-
 	sys_data = syscall_nr_to_meta(syscall_nr);
 	if (!sys_data)
 		return;
