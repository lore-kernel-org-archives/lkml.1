Return-Path: <linux-kernel-owner+w=401wt.eu-S1759255AbZEKVBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759255AbZEKVBm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 17:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753063AbZEKVBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 17:01:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54317 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838AbZEKVBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 17:01:32 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -rc] [BUGFIX] x86: fix kernel_trap_sp()
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, systemtap@sources.redhat.com,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Jan Blunck <jblunck@suse.de>, Christoph Hellwig <hch@infradead.org>
Date: Mon, 11 May 2009 17:03:00 -0400
Message-ID: <20090511210300.17332.67549.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use &regs->sp instead of regs for getting the top of stack in kernel mode.
(on x86-64, regs->sp always points the top of stack)

[ impact: Oprofile decodes only stack for backtracing on i386 ]

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jan Blunck <jblunck@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>
---

 arch/x86/include/asm/ptrace.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index 5cdd19f..90b76b3 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -187,14 +187,14 @@ static inline int v8086_mode(struct pt_regs *regs)
 
 /*
  * X86_32 CPUs don't save ss and esp if the CPU is already in kernel mode
- * when it traps.  So regs will be the current sp.
+ * when it traps.  So &regs->sp will be the current sp.
  *
  * This is valid only for kernel mode traps.
  */
 static inline unsigned long kernel_trap_sp(struct pt_regs *regs)
 {
 #ifdef CONFIG_X86_32
-	return (unsigned long)regs;
+	return (unsigned long)&regs->sp;
 #else
 	return regs->sp;
 #endif

