Return-Path: <linux-kernel-owner+w=401wt.eu-S1754310AbZISFjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310AbZISFjb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 01:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbZISFj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 01:39:29 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:53950 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585AbZISFjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 01:39:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=c5gInV4He4uHfcRiqL8imQulgesHmgJAwdHX+9ONcUlQTnmA+M6Ppr9YWIBbAzeqsP
         cL17LoMUWLzEXENziZnXlV0j6Y3F+vVk2JUKJTom1OdC7HBDMbHRhitXePCwp1gON35H
         MBlfeSEoD0vptrBox9Tb4cQXBWgDJkSjhkG/0=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 2/2] tracing: Document HAVE_FTRACE_SYSCALLS needs
Date: Sat, 19 Sep 2009 07:39:17 +0200
Message-Id: <1253338757-5918-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1253338757-5918-1-git-send-email-fweisbec@gmail.com>
References: <1253338757-5918-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the arch needed requirements to get the support for syscalls
tracing.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 Documentation/trace/ftrace-design.txt |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/Documentation/trace/ftrace-design.txt b/Documentation/trace/ftrace-design.txt
index 7003e10..04ab61c 100644
--- a/Documentation/trace/ftrace-design.txt
+++ b/Documentation/trace/ftrace-design.txt
@@ -216,7 +216,16 @@ If you can't trace NMI functions, then skip this option.
 HAVE_FTRACE_SYSCALLS
 ---------------------
 
-<details to be filled>
+You need very few things to get the syscalls tracing in an arch.
+
+- Have a NR_syscalls variable in <asm/unistd.h> that provides the number
+  of syscalls supported by the arch.
+- Implement arch_syscall_addr() that resolves a syscall address from a
+  syscall number.
+- Support the TIF_SYSCALL_TRACEPOINT thread flags
+- Put the trace_sys_enter() and trace_sys_exit() tracepoints calls from ptrace
+  in the ptrace syscalls tracing path.
+- Tag this arch as HAVE_FTRACE_SYSCALLS.
 
 
 HAVE_FTRACE_MCOUNT_RECORD
-- 
1.6.2.3

