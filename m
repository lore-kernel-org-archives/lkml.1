Return-Path: <linux-kernel-owner+w=401wt.eu-S1761531AbZCSVLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761531AbZCSVLa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 17:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760750AbZCSVJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 17:09:50 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33466 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755046AbZCSVJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 17:09:49 -0400
Message-ID: <49C2B4C6.7030802@redhat.com>
Date: Thu, 19 Mar 2009 17:10:30 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Martin Schwidefsky <schwidefsky@de.ibm.com>, Ingo Molnar <mingo@elte.hu>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [RFC][PATCH -tip 5/9] s390: add kernel_trap_sp()
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add kernel_trap_sp() on s390 (and cleanup a bit), based on systemtap's
runtime/regs.h.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 arch/s390/include/asm/ptrace.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/s390/include/asm/ptrace.h b/arch/s390/include/asm/ptrace.h
index 8920025..304b413 100644
--- a/arch/s390/include/asm/ptrace.h
+++ b/arch/s390/include/asm/ptrace.h
@@ -491,8 +491,9 @@ extern void user_disable_single_step(struct task_struct *);

 #define user_mode(regs) (((regs)->psw.mask & PSW_MASK_PSTATE) != 0)
 #define instruction_pointer(regs) ((regs)->psw.addr & PSW_ADDR_INSN)
-#define user_stack_pointer(regs)((regs)->gprs[15])
-#define regs_return_value(regs)((regs)->gprs[2])
+#define user_stack_pointer(regs) ((regs)->gprs[15])
+#define kernel_trap_sp(regs) (user_stack_pointer(regs))
+#define regs_return_value(regs) ((regs)->gprs[2])
 #define profile_pc(regs) instruction_pointer(regs)
 extern void show_regs(struct pt_regs * regs);
 #endif /* __KERNEL__ */
-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com


