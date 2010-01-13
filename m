Return-Path: <linux-kernel-owner+w=401wt.eu-S932088Ab0AMKgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088Ab0AMKgK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:36:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932113Ab0AMKgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:36:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:34642 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932099Ab0AMKgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:36:00 -0500
Date: Wed, 13 Jan 2010 10:34:13 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: acme@redhat.com, mingo@redhat.com, fweisbec@gmail.com,
       dle-develop@lists.sourceforge.net, rostedt@goodmis.org, oleg@redhat.com,
       tglx@linutronix.de, mhiramat@redhat.com, systemtap@sources.redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org, mahesh@linux.vnet.ibm.com,
       roland@redhat.com, benh@kernel.crashing.org, mikey@neuling.org,
       mingo@elte.hu
Reply-To: mingo@redhat.com, acme@redhat.com, fweisbec@gmail.com,
       dle-develop@lists.sourceforge.net, rostedt@goodmis.org, oleg@redhat.com,
       tglx@linutronix.de, mhiramat@redhat.com, systemtap@sources.redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org, mahesh@linux.vnet.ibm.com,
       roland@redhat.com, benh@kernel.crashing.org, mikey@neuling.org,
       mingo@elte.hu
In-Reply-To: <20100105224656.19431.92588.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20100105224656.19431.92588.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86/ptrace: Remove unused regs_get_argument_nth API
Message-ID: <tip-aa5add93e92019018e905146f8c3d3f8e3c08300@git.kernel.org>
Git-Commit-ID: aa5add93e92019018e905146f8c3d3f8e3c08300
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Jan 2010 10:34:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  aa5add93e92019018e905146f8c3d3f8e3c08300
Gitweb:     http://git.kernel.org/tip/aa5add93e92019018e905146f8c3d3f8e3c08300
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Tue, 5 Jan 2010 17:46:56 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 13 Jan 2010 10:09:12 +0100

x86/ptrace: Remove unused regs_get_argument_nth API

Because of dropping function argument syntax from kprobe-tracer,
we don't need this API anymore.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Neuling <mikey@neuling.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: linuxppc-dev@ozlabs.org
LKML-Reference: <20100105224656.19431.92588.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/ptrace.h |    4 ----
 arch/x86/kernel/ptrace.c      |   24 ------------------------
 2 files changed, 0 insertions(+), 28 deletions(-)

diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index 9d369f6..2010280 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -274,10 +274,6 @@ static inline unsigned long regs_get_kernel_stack_nth(struct pt_regs *regs,
 		return 0;
 }
 
-/* Get Nth argument at function call */
-extern unsigned long regs_get_argument_nth(struct pt_regs *regs,
-					   unsigned int n);
-
 /*
  * These are defined as per linux/ptrace.h, which see.
  */
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 017d937..73554a3 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -140,30 +140,6 @@ static const int arg_offs_table[] = {
 #endif
 };
 
-/**
- * regs_get_argument_nth() - get Nth argument at function call
- * @regs:	pt_regs which contains registers at function entry.
- * @n:		argument number.
- *
- * regs_get_argument_nth() returns @n th argument of a function call.
- * Since usually the kernel stack will be changed right after function entry,
- * you must use this at function entry. If the @n th entry is NOT in the
- * kernel stack or pt_regs, this returns 0.
- */
-unsigned long regs_get_argument_nth(struct pt_regs *regs, unsigned int n)
-{
-	if (n < ARRAY_SIZE(arg_offs_table))
-		return *(unsigned long *)((char *)regs + arg_offs_table[n]);
-	else {
-		/*
-		 * The typical case: arg n is on the stack.
-		 * (Note: stack[0] = return address, so skip it)
-		 */
-		n -= ARRAY_SIZE(arg_offs_table);
-		return regs_get_kernel_stack_nth(regs, 1 + n);
-	}
-}
-
 /*
  * does not yet catch signals sent when the child dies.
  * in exit.c or in signal.c.
