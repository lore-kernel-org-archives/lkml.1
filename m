Return-Path: <linux-kernel-owner+w=401wt.eu-S1754579AbZKVInu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbZKVInu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 03:43:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbZKVInn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 03:43:43 -0500
Received: from hera.kernel.org ([140.211.167.34]:44508 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666AbZKVInl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 03:43:41 -0500
Date: Sun, 22 Nov 2009 08:43:06 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       jbaron@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, jbaron@redhat.com,
       mingo@elte.hu
In-Reply-To: <1258863695-10464-2-git-send-email-fweisbec@gmail.com>
References: <1258863695-10464-2-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Forget about the NMI buffer for syscall events
Message-ID: <tip-28889bf9e2db29747d58cd47a92d727f927c3aee@git.kernel.org>
Git-Commit-ID: 28889bf9e2db29747d58cd47a92d727f927c3aee
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  28889bf9e2db29747d58cd47a92d727f927c3aee
Gitweb:     http://git.kernel.org/tip/28889bf9e2db29747d58cd47a92d727f927c3aee
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Sun, 22 Nov 2009 05:21:33 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 22 Nov 2009 09:03:42 +0100

tracing: Forget about the NMI buffer for syscall events

We are never in an NMI context when we commit a syscall trace to
perf. So just forget about the nmi buffer there.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jason Baron <jbaron@redhat.com>
LKML-Reference: <1258863695-10464-2-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/trace_syscalls.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 0bb9348..41b6dd9 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -511,10 +511,7 @@ static void prof_syscall_enter(struct pt_regs *regs, long id)
 
 	cpu = smp_processor_id();
 
-	if (in_nmi())
-		trace_buf = rcu_dereference(perf_trace_buf_nmi);
-	else
-		trace_buf = rcu_dereference(perf_trace_buf);
+	trace_buf = rcu_dereference(perf_trace_buf);
 
 	if (!trace_buf)
 		goto end;
@@ -617,10 +614,7 @@ static void prof_syscall_exit(struct pt_regs *regs, long ret)
 
 	cpu = smp_processor_id();
 
-	if (in_nmi())
-		trace_buf = rcu_dereference(perf_trace_buf_nmi);
-	else
-		trace_buf = rcu_dereference(perf_trace_buf);
+	trace_buf = rcu_dereference(perf_trace_buf);
 
 	if (!trace_buf)
 		goto end;
