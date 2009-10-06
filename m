Return-Path: <linux-kernel-owner+w=401wt.eu-S932382AbZJFMSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382AbZJFMSW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 08:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932289AbZJFMSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 08:18:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:34779 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932328AbZJFMSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 08:18:18 -0400
Date: Tue, 6 Oct 2009 12:17:12 GMT
From: tip-bot for Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, tzanussi@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1254808849-7829-4-git-send-email-tzanussi@gmail.com>
References: <1254808849-7829-4-git-send-email-tzanussi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tracing/syscalls: Use long for syscall ret format and field definitions
Message-ID: <tip-ee949a86b3aef15845ea677aa60231008de62672@git.kernel.org>
Git-Commit-ID: ee949a86b3aef15845ea677aa60231008de62672
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 06 Oct 2009 12:17:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ee949a86b3aef15845ea677aa60231008de62672
Gitweb:     http://git.kernel.org/tip/ee949a86b3aef15845ea677aa60231008de62672
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Tue, 6 Oct 2009 01:00:49 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Oct 2009 12:02:34 +0200

tracing/syscalls: Use long for syscall ret format and field definitions

The syscall event definitions use long for the syscall exit ret
value, but unsigned long for the same thing in the format and field
definitions.  Change them all to long.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: rostedt@goodmis.org
Cc: lizf@cn.fujitsu.com
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <1254808849-7829-4-git-send-email-tzanussi@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/trace_syscalls.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 9fbce6c..527e17e 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -166,7 +166,7 @@ int syscall_exit_format(struct ftrace_event_call *call, struct trace_seq *s)
 			       "\tfield:%s %s;\toffset:%zu;\tsize:%zu;\n"
 			       "\tfield:%s %s;\toffset:%zu;\tsize:%zu;\n",
 			       SYSCALL_FIELD(int, nr),
-			       SYSCALL_FIELD(unsigned long, ret));
+			       SYSCALL_FIELD(long, ret));
 	if (!ret)
 		return 0;
 
@@ -212,7 +212,7 @@ int syscall_exit_define_fields(struct ftrace_event_call *call)
 	if (ret)
 		return ret;
 
-	ret = trace_define_field(call, SYSCALL_FIELD(unsigned long, ret), 0,
+	ret = trace_define_field(call, SYSCALL_FIELD(long, ret), 0,
 				 FILTER_OTHER);
 
 	return ret;
