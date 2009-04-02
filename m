Return-Path: <linux-kernel-owner+w=401wt.eu-S1763136AbZDBRZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763136AbZDBRZo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 13:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934150AbZDBRYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 13:24:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43041 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934040AbZDBRY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 13:24:27 -0400
Message-ID: <49D4F4DA.5070207@redhat.com>
Date: Thu, 02 Apr 2009 13:24:42 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Jan Blunck <jblunck@suse.de>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Jim Keniston <jkenisto@us.ibm.com>,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Subject: [PATCH -tip 1/6 V4] x86: fix kernel_trap_sp()
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use &regs->sp instead of regs for getting the top of stack in kernel mode.
(on x86-64, regs->sp always points the top of stack)

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jan Blunck <jblunck@suse.de>
---

 arch/x86/include/asm/ptrace.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index e304b66..aed0894 100644
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

