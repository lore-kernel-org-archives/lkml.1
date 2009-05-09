Return-Path: <linux-kernel-owner+w=401wt.eu-S932349AbZEIArI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932349AbZEIArI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 20:47:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764609AbZEIAqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 20:46:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55690 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764483AbZEIAqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 20:46:09 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip v5 5/7] x86: fix kernel_trap_sp()
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Jan Blunck <jblunck@suse.de>
Date: Fri, 08 May 2009 20:49:04 -0400
Message-ID: <20090509004904.5505.59034.stgit@localhost.localdomain>
In-Reply-To: <20090509004829.5505.38720.stgit@localhost.localdomain>
References: <20090509004829.5505.38720.stgit@localhost.localdomain>
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


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
