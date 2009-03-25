Return-Path: <linux-kernel-owner+w=401wt.eu-S1753577AbZCYFVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577AbZCYFVa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 01:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641AbZCYFU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 01:20:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59696 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbZCYFU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 01:20:26 -0400
Message-Id: <20090325052022.747507467@goodmis.org>
References: <20090325051920.406564281@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 25 Mar 2009 01:19:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/5] ptrace: remove incorrect unlikelys
Content-Disposition: inline; filename=0001-ptrace-remove-incorrect-unlikelys.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

Impact: clean up

Accounding to the annotated branch profiler, the unlikelys used by
ptrace is incorrect every time.

 correct incorrect  %        Function                  File              Line
 ------- ---------  -        --------                  ----              ----

       0    24176 100 syscall_trace_leave            ptrace.c             1444
       0    21478 100 syscall_trace_enter            ptrace.c             1424

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/kernel/ptrace.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 06ca07f..74a16db 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1421,7 +1421,7 @@ asmregparm long syscall_trace_enter(struct pt_regs *regs)
 	    tracehook_report_syscall_entry(regs))
 		ret = -1L;
 
-	if (unlikely(current->audit_context)) {
+	if (current->audit_context) {
 		if (IS_IA32)
 			audit_syscall_entry(AUDIT_ARCH_I386,
 					    regs->orig_ax,
@@ -1441,7 +1441,7 @@ asmregparm long syscall_trace_enter(struct pt_regs *regs)
 
 asmregparm void syscall_trace_leave(struct pt_regs *regs)
 {
-	if (unlikely(current->audit_context))
+	if (current->audit_context)
 		audit_syscall_exit(AUDITSC_RESULT(regs->ax), regs->ax);
 
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
-- 
1.6.2

-- 
