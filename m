Return-Path: <linux-kernel-owner+w=401wt.eu-S1755469Ab0AEWmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab0AEWmy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 17:42:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755453Ab0AEWmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 17:42:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23661 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755440Ab0AEWmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 17:42:44 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 3/8] x86/ptrace: Remove unused regs_get_argument_nth API
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Michael Neuling <mikey@neuling.org>,
       Steven Rostedt <rostedt@goodmis.org>, linuxppc-dev@ozlabs.org
Date: Tue, 05 Jan 2010 17:46:56 -0500
Message-ID: <20100105224656.19431.92588.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20100105224634.19431.3259.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20100105224634.19431.3259.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because of dropping function argument syntax from kprobe-tracer,
we don't need this API anymore.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Neuling <mikey@neuling.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: linuxppc-dev@ozlabs.org
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


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
