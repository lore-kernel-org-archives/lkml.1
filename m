Return-Path: <linux-kernel-owner+w=401wt.eu-S1762380AbZDHHsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762380AbZDHHsk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 03:48:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750966AbZDHHs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 03:48:26 -0400
Received: from 60-248-182-106.HINET-IP.hinet.net ([60.248.182.106]:35636 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbZDHHsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 03:48:23 -0400
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, Arnd Bergmann <arnd@arndb.de>,
       Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Kyle McMartin <kyle@mcmartin.ca>
MIME-Version: 1.0
Subject: [PATCH 8/14] score - New architecure port to SunplusCT S+CORE
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OF7DD2F383.8DD9B756-ON48257592.0028DCD0-48257592.00292077@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Wed, 8 Apr 2009 15:27:06 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/04/08 ?? 03:27:05,
	Serialize complete at 2009/04/08 ?? 03:27:05
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chen Liqin <liqin.chen@sunplusct.com>

kernel/asm-offsets.c, kernel/entry.S, kernel/head.S,
kernel/init_task.c and kernel/irq.c for the score architecture.

Signed off by: Chen Liqin <liqin.chen@sunplusct.com>
Signed off by: Lennox Wu <lennox.wu@sunplusct.com>
--

diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/kernel/asm-offsets.c 
linux-2.6-git.new/arch/score/kernel/asm-offsets.c
--- linux-2.6-git.ori/arch/score/kernel/asm-offsets.c   1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/kernel/asm-offsets.c   2009-04-07 
21:05:33.000000000 +0800
@@ -0,0 +1,218 @@
+/*
+ * arch/score/kernel/asm-offsets.c
+ *
+ * Score Processor version.
+ *
+ * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
+ *  Chen Liqin <liqin.chen@sunplusct.com>
+ *  Lennox Wu <lennox.wu@sunplusct.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/interrupt.h>
+#include <linux/kbuild.h>
+
+void output_ptreg_defines(void)
+{
+       COMMENT("SCORE pt_regs offsets.");
+       OFFSET(PT_R0, pt_regs, regs[0]);
+       OFFSET(PT_R1, pt_regs, regs[1]);
+       OFFSET(PT_R2, pt_regs, regs[2]);
+       OFFSET(PT_R3, pt_regs, regs[3]);
+       OFFSET(PT_R4, pt_regs, regs[4]);
+       OFFSET(PT_R5, pt_regs, regs[5]);
+       OFFSET(PT_R6, pt_regs, regs[6]);
+       OFFSET(PT_R7, pt_regs, regs[7]);
+       OFFSET(PT_R8, pt_regs, regs[8]);
+       OFFSET(PT_R9, pt_regs, regs[9]);
+       OFFSET(PT_R10, pt_regs, regs[10]);
+       OFFSET(PT_R11, pt_regs, regs[11]);
+       OFFSET(PT_R12, pt_regs, regs[12]);
+       OFFSET(PT_R13, pt_regs, regs[13]);
+       OFFSET(PT_R14, pt_regs, regs[14]);
+       OFFSET(PT_R15, pt_regs, regs[15]);
+       OFFSET(PT_R16, pt_regs, regs[16]);
+       OFFSET(PT_R17, pt_regs, regs[17]);
+       OFFSET(PT_R18, pt_regs, regs[18]);
+       OFFSET(PT_R19, pt_regs, regs[19]);
+       OFFSET(PT_R20, pt_regs, regs[20]);
+       OFFSET(PT_R21, pt_regs, regs[21]);
+       OFFSET(PT_R22, pt_regs, regs[22]);
+       OFFSET(PT_R23, pt_regs, regs[23]);
+       OFFSET(PT_R24, pt_regs, regs[24]);
+       OFFSET(PT_R25, pt_regs, regs[25]);
+       OFFSET(PT_R26, pt_regs, regs[26]);
+       OFFSET(PT_R27, pt_regs, regs[27]);
+       OFFSET(PT_R28, pt_regs, regs[28]);
+       OFFSET(PT_R29, pt_regs, regs[29]);
+       OFFSET(PT_R30, pt_regs, regs[30]);
+       OFFSET(PT_R31, pt_regs, regs[31]);
+
+       OFFSET(PT_ORIG_R4, pt_regs, orig_r4);
+       OFFSET(PT_ORIG_R7, pt_regs, orig_r7);
+       OFFSET(PT_CEL, pt_regs, cel);
+       OFFSET(PT_CEH, pt_regs, ceh);
+       OFFSET(PT_SR0, pt_regs, sr0);
+       OFFSET(PT_SR1, pt_regs, sr1);
+       OFFSET(PT_SR2, pt_regs, sr2);
+       OFFSET(PT_EPC, pt_regs, cp0_epc);
+       OFFSET(PT_EMA, pt_regs, cp0_ema);
+       OFFSET(PT_PSR, pt_regs, cp0_psr);
+       OFFSET(PT_ECR, pt_regs, cp0_ecr);
+       OFFSET(PT_CONDITION, pt_regs, cp0_condition);
+       OFFSET(PT_IS_SYSCALL, pt_regs, is_syscall);
+
+       DEFINE(PT_SIZE, sizeof(struct pt_regs));
+       BLANK();
+}
+
+void output_task_defines(void)
+{
+       COMMENT("SCORE task_struct offsets.");
+       OFFSET(TASK_STATE, task_struct, state);
+       OFFSET(TASK_THREAD_INFO, task_struct, stack);
+       OFFSET(TASK_FLAGS, task_struct, flags);
+       OFFSET(TASK_MM, task_struct, mm);
+       OFFSET(TASK_PID, task_struct, pid);
+       DEFINE(TASK_STRUCT_SIZE, sizeof(struct task_struct));
+       BLANK();
+}
+
+void output_thread_info_defines(void)
+{
+       COMMENT("SCORE thread_info offsets.");
+       OFFSET(TI_TASK, thread_info, task);
+       OFFSET(TI_EXEC_DOMAIN, thread_info, exec_domain);
+       OFFSET(TI_FLAGS, thread_info, flags);
+       OFFSET(TI_TP_VALUE, thread_info, tp_value);
+       OFFSET(TI_CPU, thread_info, cpu);
+       OFFSET(TI_PRE_COUNT, thread_info, preempt_count);
+       OFFSET(TI_ADDR_LIMIT, thread_info, addr_limit);
+       OFFSET(TI_RESTART_BLOCK, thread_info, restart_block);
+       OFFSET(TI_REGS, thread_info, regs);
+       DEFINE(KERNEL_STACK_SIZE, THREAD_SIZE);
+       DEFINE(KERNEL_STACK_MASK, THREAD_MASK);
+       BLANK();
+}
+
+void output_thread_defines(void)
+{
+       COMMENT("SCORE specific thread_struct offsets.");
+       OFFSET(THREAD_REG0, task_struct, thread.reg0);
+       OFFSET(THREAD_REG2, task_struct, thread.reg2);
+       OFFSET(THREAD_REG3, task_struct, thread.reg3);
+       OFFSET(THREAD_REG12, task_struct, thread.reg12);
+       OFFSET(THREAD_REG13, task_struct, thread.reg13);
+       OFFSET(THREAD_REG14, task_struct, thread.reg14);
+       OFFSET(THREAD_REG15, task_struct, thread.reg15);
+       OFFSET(THREAD_REG16, task_struct, thread.reg16);
+       OFFSET(THREAD_REG17, task_struct, thread.reg17);
+       OFFSET(THREAD_REG18, task_struct, thread.reg18);
+       OFFSET(THREAD_REG19, task_struct, thread.reg19);
+       OFFSET(THREAD_REG20, task_struct, thread.reg20);
+       OFFSET(THREAD_REG21, task_struct, thread.reg21);
+       OFFSET(THREAD_REG29, task_struct, thread.reg29);
+
+       OFFSET(THREAD_PSR, task_struct, thread.cp0_psr);
+       OFFSET(THREAD_EMA, task_struct, thread.cp0_ema);
+       OFFSET(THREAD_BADUADDR, task_struct, thread.cp0_baduaddr);
+       OFFSET(THREAD_ECODE, task_struct, thread.error_code);
+       OFFSET(THREAD_TRAPNO, task_struct, thread.trap_no);
+       BLANK();
+}
+
+void output_mm_defines(void)
+{
+       COMMENT("Size of struct page");
+       DEFINE(STRUCT_PAGE_SIZE, sizeof(struct page));
+       BLANK();
+       COMMENT("Linux mm_struct offsets.");
+       OFFSET(MM_USERS, mm_struct, mm_users);
+       OFFSET(MM_PGD, mm_struct, pgd);
+       OFFSET(MM_CONTEXT, mm_struct, context);
+       BLANK();
+       DEFINE(_PAGE_SIZE, PAGE_SIZE);
+       DEFINE(_PAGE_SHIFT, PAGE_SHIFT);
+       BLANK();
+       DEFINE(_PGD_T_SIZE, sizeof(pgd_t));
+       DEFINE(_PMD_T_SIZE, sizeof(pmd_t));
+       DEFINE(_PTE_T_SIZE, sizeof(pte_t));
+       BLANK();
+       DEFINE(_PGD_ORDER, PGD_ORDER);
+       DEFINE(_PTE_ORDER, PTE_ORDER);
+       BLANK();
+       DEFINE(_PMD_SHIFT, PMD_SHIFT);
+       DEFINE(_PGDIR_SHIFT, PGDIR_SHIFT);
+       BLANK();
+       DEFINE(_PTRS_PER_PGD, PTRS_PER_PGD);
+       DEFINE(_PTRS_PER_PMD, PTRS_PER_PMD);
+       DEFINE(_PTRS_PER_PTE, PTRS_PER_PTE);
+       BLANK();
+}
+
+void output_sc_defines(void)
+{
+       COMMENT("Linux sigcontext offsets.");
+       OFFSET(SC_REGS, sigcontext, sc_regs);
+       OFFSET(SC_MDCEH, sigcontext, sc_mdceh);
+       OFFSET(SC_MDCEL, sigcontext, sc_mdcel);
+       OFFSET(SC_PC, sigcontext, sc_pc);
+       OFFSET(SC_PSR, sigcontext, sc_psr);
+       OFFSET(SC_ECR, sigcontext, sc_ecr);
+       OFFSET(SC_EMA, sigcontext, sc_ema);
+       BLANK();
+}
+
+void output_signal_defined(void)
+{
+       COMMENT("Linux signal numbers.");
+       DEFINE(_SIGHUP, SIGHUP);
+       DEFINE(_SIGINT, SIGINT);
+       DEFINE(_SIGQUIT, SIGQUIT);
+       DEFINE(_SIGILL, SIGILL);
+       DEFINE(_SIGTRAP, SIGTRAP);
+       DEFINE(_SIGIOT, SIGIOT);
+       DEFINE(_SIGABRT, SIGABRT);
+       DEFINE(_SIGEMT, SIGEMT);
+       DEFINE(_SIGFPE, SIGFPE);
+       DEFINE(_SIGKILL, SIGKILL);
+       DEFINE(_SIGBUS, SIGBUS);
+       DEFINE(_SIGSEGV, SIGSEGV);
+       DEFINE(_SIGSYS, SIGSYS);
+       DEFINE(_SIGPIPE, SIGPIPE);
+       DEFINE(_SIGALRM, SIGALRM);
+       DEFINE(_SIGTERM, SIGTERM);
+       DEFINE(_SIGUSR1, SIGUSR1);
+       DEFINE(_SIGUSR2, SIGUSR2);
+       DEFINE(_SIGCHLD, SIGCHLD);
+       DEFINE(_SIGPWR, SIGPWR);
+       DEFINE(_SIGWINCH, SIGWINCH);
+       DEFINE(_SIGURG, SIGURG);
+       DEFINE(_SIGIO, SIGIO);
+       DEFINE(_SIGSTOP, SIGSTOP);
+       DEFINE(_SIGTSTP, SIGTSTP);
+       DEFINE(_SIGCONT, SIGCONT);
+       DEFINE(_SIGTTIN, SIGTTIN);
+       DEFINE(_SIGTTOU, SIGTTOU);
+       DEFINE(_SIGVTALRM, SIGVTALRM);
+       DEFINE(_SIGPROF, SIGPROF);
+       DEFINE(_SIGXCPU, SIGXCPU);
+       DEFINE(_SIGXFSZ, SIGXFSZ);
+       BLANK();
+}
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/kernel/entry.S 
linux-2.6-git.new/arch/score/kernel/entry.S
--- linux-2.6-git.ori/arch/score/kernel/entry.S 1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/kernel/entry.S 2009-04-07 
21:06:26.000000000 +0800
@@ -0,0 +1,590 @@
+/*
+ * arch/score/kernel/entry.S
+ *
+ * Score Processor version.
+ *
+ * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
+ *  Chen Liqin <liqin.chen@sunplusct.com>
+ *  Lennox Wu <lennox.wu@sunplusct.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/errno.h>
+
+#include <asm/asm.h>
+#include <asm/unistd.h>
+#include <asm/thread_info.h>
+
+/*
+ * disable interrupts.
+ */
+.macro disable_irq
+       mfcr    r8, cr0
+       srli    r8, r8, 1
+       slli    r8, r8, 1
+       mtcr    r8, cr0
+       nop
+       nop
+       nop
+       nop
+       nop
+.endm
+
+/*
+ * enable interrupts.
+ */
+.macro enable_irq
+       mfcr    r8, cr0
+       ori     r8, 1
+       mtcr    r8, cr0
+       nop
+       nop
+       nop
+       nop
+       nop
+.endm
+
+       .section ".text.init", "ax"
+       .align  2;
+       .globl  debug_exception_vector;         # should move to addr 
0x1fc
+debug_exception_vector:
+       nop!
+       nop!
+       nop!
+       nop!
+       nop!
+       nop!
+       nop!
+       nop!
+
+       .globl  general_exception_vector;       # should move to addr 
0x200
+general_exception_vector:
+       j       general_exception
+       nop!
+       nop!
+       nop!
+       nop!
+       nop!
+       nop!
+
+       .globl  interrupt_exception_vector;     # should move to addr 
0x210
+interrupt_exception_vector:
+       j       interrupt_exception
+       nop!
+       nop!
+       nop!
+       nop!
+       nop!
+       nop!
+
+       .section ".text", "ax"
+       .align  2;
+general_exception:
+       mfcr    r31, cr2
+       nop
+       la      r30, exception_handlers
+       andi    r31, 0x1f                       # get ecr.exc_code
+       slli    r31, r31, 2
+       add     r30, r30, r31
+       lw      r30, [r30]
+       br      r30
+
+interrupt_exception:
+       SAVE_ALL
+       mfcr    r4, cr2
+       nop
+       lw      r16, [r28, TI_REGS]
+       sw      r0, [r28, TI_REGS]
+       la      r3, ret_from_irq
+       srli    r4, r4, 18                      # get ecr.ip[7:2], 
interrupt No.
+       mv      r5, r0
+       j       do_IRQ
+
+       .globl  handle_nmi;                     # NMI #1
+handle_nmi:
+       SAVE_ALL
+       mv      r4, r0
+       la      r8, nmi_exception_handler
+       brl     r8
+       j       restore_all
+
+       .globl  handle_adelinsn;        # AdEL-instruction #2
+handle_adelinsn:
+       SAVE_ALL
+       mfcr    r8, cr6
+       nop
+       nop
+       sw      r8, [r0, PT_EMA]
+       mv      r4, r0
+       la      r8, do_adelinsn
+       brl     r8
+       mv      r4, r0
+       j       ret_from_exception
+       nop
+
+       .globl  handle_ibe;             # BusEL-instruction #5
+handle_ibe:
+       SAVE_ALL
+       mv      r4, r0
+       la      r8, do_be
+       brl     r8
+       mv      r4, r0
+       j       ret_from_exception
+       nop
+
+       .globl  handle_pel;             # P-EL #6
+handle_pel:
+       SAVE_ALL
+       mv      r4, r0
+       la      r8, do_pel
+       brl     r8
+       mv      r4, r0
+       j       ret_from_exception
+       nop
+
+       .globl  handle_ccu;             # CCU #8
+handle_ccu:
+       SAVE_ALL
+       mv      r4, r0
+       la      r8, do_ccu
+       brl     r8
+       mv      r4, r0
+       j       ret_from_exception
+       nop
+
+       .globl  handle_ri;              # RI #9
+handle_ri:
+       SAVE_ALL
+       mv      r4, r0
+       la      r8, do_ri
+       brl     r8
+       mv      r4, r0
+       j       ret_from_exception
+       nop
+
+       .globl  handle_tr;              # Trap #10
+handle_tr:
+       SAVE_ALL
+       mv      r4, r0
+       la      r8, do_tr
+       brl     r8
+       mv      r4, r0
+       j       ret_from_exception
+       nop
+
+       .globl  handle_adedata;         # AdES-instruction #12
+handle_adedata:
+       SAVE_ALL
+       mfcr    r8, cr6
+       nop
+       nop
+       sw      r8, [r0, PT_EMA]
+       mv      r4, r0
+       la      r8, do_adedata
+       brl     r8
+       mv      r4, r0
+       j       ret_from_exception
+       nop
+
+       .globl  handle_cee;             # CeE #16
+handle_cee:
+       SAVE_ALL
+       mv      r4, r0
+       la      r8, do_cee
+       brl     r8
+       mv      r4, r0
+       j       ret_from_exception
+       nop
+
+       .globl  handle_cpe;             # CpE #17
+handle_cpe:
+       SAVE_ALL
+       mv      r4, r0
+       la      r8, do_cpe
+       brl     r8
+       mv      r4, r0
+       j       ret_from_exception
+       nop
+
+       .globl  handle_dbe;             # BusEL-data #18
+handle_dbe:
+       SAVE_ALL
+       mv      r4, r0
+       la      r8, do_be
+       brl     r8
+       mv      r4, r0
+       j       ret_from_exception
+       nop
+
+       .globl  handle_reserved;        # others
+handle_reserved:
+       SAVE_ALL
+       mv      r4, r0
+       la      r8, do_reserved
+       brl     r8
+       mv      r4, r0
+       j       ret_from_exception
+       nop
+
+#ifndef CONFIG_PREEMPT
+#define resume_kernel  restore_all
+#else
+#define __ret_from_irq ret_from_exception
+#endif
+
+       .align  2
+#ifndef CONFIG_PREEMPT
+       .globl  ret_from_exception
+       .type   ret_from_exception, @function
+ret_from_exception:
+       disable_irq                     # preempt stop
+       nop
+       j       __ret_from_irq
+       nop
+#endif
+
+       .globl  ret_from_irq
+       .type   ret_from_irq, @function
+ret_from_irq:
+       sw      r16, [r28, TI_REGS]
+
+       .globl  __ret_from_irq
+       .type   __ret_from_irq, @function
+__ret_from_irq:
+       lw      r8, [r0, PT_PSR]        # returning to kernel mode?
+       andri.c r8, r8, KU_USER
+       beq     resume_kernel
+
+resume_userspace:
+       disable_irq
+       lw      r6, [r28, TI_FLAGS]     # current->work
+       li      r8, _TIF_WORK_MASK
+       and.c   r8, r8, r6              # ignoring syscall_trace
+       bne     work_pending
+       nop
+       j       restore_all
+       nop
+
+#ifdef CONFIG_PREEMPT
+resume_kernel:
+       disable_irq
+       lw      r8, [r28, TI_PRE_COUNT]
+       cmpz.c  r8
+       bne     r8, restore_all
+need_resched:
+       lw      r8, [r28, TI_FLAGS]
+       andri.c r9, r8, _TIF_NEED_RESCHED
+       beq     restore_all
+       lw      r8, [r28, PT_PSR]               # Interrupts off?
+       andri.c r8, r8, 1
+       beq     restore_all
+       bl      preempt_schedule_irq
+       nop
+       j       need_resched
+       nop
+#endif
+
+       .globl  ret_from_fork
+       .type   ret_from_fork, @function
+ret_from_fork:
+       bl      schedule_tail                   # r4=struct task_struct 
*prev
+
+       .globl  syscall_exit
+       .type   syscall_exit, @function
+syscall_exit:
+       nop
+       disable_irq
+       lw      r6, [r28, TI_FLAGS]             # current->work
+       li      r8, _TIF_WORK_MASK
+       and.c   r8, r6, r8
+       bne     syscall_exit_work
+
+       .globl  restore_all
+       .type   restore_all, @function
+restore_all:                                   # restore full frame
+       RESTORE_ALL_AND_RET
+
+work_pending:
+       andri.c r8, r6, _TIF_NEED_RESCHED # r6 is preloaded with TI_FLAGS
+       beq     work_notifysig
+work_resched:
+       bl      schedule
+       nop
+       disable_irq
+       lw      r6, [r28, TI_FLAGS]
+       li      r8, _TIF_WORK_MASK
+       and.c   r8, r6, r8      # is there any work to be done
+                               # other than syscall tracing?
+       beq     restore_all
+       andri.c r8, r6, _TIF_NEED_RESCHED
+       bne     work_resched
+
+work_notifysig:
+       mv      r4, r0
+       li      r5, 0
+       bl      do_notify_resume        # r6 already loaded
+       nop
+       j       resume_userspace
+       nop
+
+       .globl  syscall_exit_work
+       .type   syscall_exit_work, @function
+syscall_exit_work:
+       li      r8, _TIF_SYSCALL_TRACE
+       and.c   r8, r8, r6              # r6 is preloaded with TI_FLAGS
+       beq     work_pending            # trace bit set?
+       nop
+       enable_irq
+       mv      r4, r0
+       li      r5, 1
+       bl      do_syscall_trace
+       nop
+       b       resume_userspace
+       nop
+
+.macro save_context    reg
+       sw      r12, [\reg, THREAD_REG12];
+       sw      r13, [\reg, THREAD_REG13];
+       sw      r14, [\reg, THREAD_REG14];
+       sw      r15, [\reg, THREAD_REG15];
+       sw      r16, [\reg, THREAD_REG16];
+       sw      r17, [\reg, THREAD_REG17];
+       sw      r18, [\reg, THREAD_REG18];
+       sw      r19, [\reg, THREAD_REG19];
+       sw      r20, [\reg, THREAD_REG20];
+       sw      r21, [\reg, THREAD_REG21];
+       sw      r29, [\reg, THREAD_REG29];
+       sw      r2, [\reg, THREAD_REG2];
+       sw      r0, [\reg, THREAD_REG0]
+.endm
+
+.macro restore_context reg
+       lw      r12, [\reg, THREAD_REG12];
+       lw      r13, [\reg, THREAD_REG13];
+       lw      r14, [\reg, THREAD_REG14];
+       lw      r15, [\reg, THREAD_REG15];
+       lw      r16, [\reg, THREAD_REG16];
+       lw      r17, [\reg, THREAD_REG17];
+       lw      r18, [\reg, THREAD_REG18];
+       lw      r19, [\reg, THREAD_REG19];
+       lw      r20, [\reg, THREAD_REG20];
+       lw      r21, [\reg, THREAD_REG21];
+       lw      r29, [\reg, THREAD_REG29];
+       lw      r0, [\reg, THREAD_REG0];
+       lw      r2, [\reg, THREAD_REG2];
+       lw      r3, [\reg, THREAD_REG3]
+.endm
+
+/*
+ * task_struct *resume(task_struct *prev, task_struct *next,
+ *                     struct thread_info *next_ti)
+ */
+       .globl  resume;
+       .type   resume, @function
+resume:
+       mfcr    r9, cr0
+       nop
+       nop
+       sw      r9, [r4, THREAD_PSR]
+       save_context    r4
+       sw      r3, [r4, THREAD_REG3]
+
+       mv      r28, r6
+       restore_context r5
+       mv      r8, r6
+       addi    r8, KERNEL_STACK_SIZE
+       subi    r8, 32
+       la      r9, kernelsp;
+       sw      r8, [r9];
+
+       mfcr    r9, cr0
+       ldis    r7, 0x00ff
+       nop
+       and     r9, r9, r7
+       lw      r6, [r5, THREAD_PSR]
+       not     r7, r7
+       and     r6, r6, r7
+       or      r6, r6, r9
+       mtcr    r6, cr0
+       nop; nop; nop; nop; nop
+       br      r3
+
+       .globl  handle_sys
+       .type   handle_sys, @function
+handle_sys:
+       SAVE_ALL
+       enable_irq
+
+       sw      r4, [r0, PT_ORIG_R4]    #for restart syscall
+       sw      r7, [r0, PT_ORIG_R7]    #for restart syscall
+       sw      r27, [r0, PT_IS_SYSCALL] # it from syscall
+
+       lw      r9, [r0, PT_EPC]        # skip syscall on return
+       addi    r9, 4
+       sw      r9, [r0, PT_EPC]
+
+       cmpi.c  r27, __NR_Linux_syscalls # check syscall number
+       bgtu    illegal_syscall
+
+       slli    r8, r27, 3              # get syscall routine
+       la      r11, sys_call_table
+       add     r11, r11, r8
+       lw      r10, [r11]              # get syscall entry
+       lw      r11, [r11, 4]           # get number of args
+
+       cmpz.c  r10
+       beq     illegal_syscall
+
+       cmpi.c  r11, 4                  # more than 4 arguments?
+       bgtu    stackargs
+
+stack_done:
+       lw      r8, [r28, TI_FLAGS]
+       li      r9, _TIF_SYSCALL_TRACE
+       and.c   r8, r8, r9
+       bne     syscall_trace_entry
+
+       brl     r10                     # Do The Real system call
+
+       cmpi.c  r4, 0
+       blt     1f
+       ldi     r8, 0
+       sw      r8, [r0, PT_R7]
+       b 2f
+1:
+       cmpi.c  r4, -EMAXERRNO-1        # -EMAXERRNO - 1=-1134
+       ble     2f
+       ldi     r8, 0x1;
+       sw      r8, [r0, PT_R7]
+       neg     r4, r4
+2:
+       sw      r4, [r0, PT_R4]         # save result
+
+syscall_return:
+       disable_irq
+       lw      r6, [r28, TI_FLAGS]     # current->work
+       li      r8, _TIF_WORK_MASK
+       and.c   r8, r6, r8
+       bne     syscall_return_work
+       j       restore_all
+
+syscall_return_work:
+       j       syscall_exit_work
+
+syscall_trace_entry:
+       mv      r16, r10
+       mv      r4, r0
+       li      r5, 0
+       bl      do_syscall_trace
+
+       mv      r8, r16
+       lw      r4, [r0, PT_R4]         # Restore argument registers
+       lw      r5, [r0, PT_R5]
+       lw      r6, [r0, PT_R6]
+       lw      r7, [r0, PT_R7]
+       brl     r8
+
+       li      r8, -EMAXERRNO - 1      # error?
+       sw      r8, [r0, PT_R7]         # set error flag
+
+       neg     r4, r4                  # error
+       sw      r4, [r0, PT_R0]         # set flag for syscall
+                                       # restarting
+1:     sw      r4, [r0, PT_R2]         # result
+       j       syscall_exit
+
+stackargs:
+       lw      r8, [r0, PT_R0]
+       andri.c r9, r8, 3               # test whether user sp is align a 
word
+       bne     bad_stack
+       subi    r11, 5
+       slli    r9, r11, 2
+       add.c   r9, r9, r8
+
+       bmi     bad_stack
+       la      r9, 3f                  # calculate branch address
+       slli    r11, r11, 3
+       sub     r9, r9, r11
+       br      r9
+
+2:     lw      r9, [r8, 20]            # argument 6 from usp
+       sw      r9, [r0, 20]
+
+3:     lw      r9, [r8, 16]            # argument 5 from usp
+       sw      r9, [r0, 16]
+       j       stack_done
+
+       .section __ex_table,"a"
+       .word   2b, bad_stack
+       .word   3b, bad_stack
+       .previous
+
+       /*
+        * The stackpointer for a call with more than 4 arguments is bad.
+        * We probably should handle this case a bit more drastic.
+        */
+bad_stack:
+       neg     r27, r27                # error
+       sw      r27, [r0, PT_ORIG_R4]
+       sw      r27, [r0, PT_R4]
+       ldi     r8, 1                   # set error flag
+       sw      r8, [r0, PT_R7]
+       j       syscall_return
+
+illegal_syscall:
+       ldi     r4, -ENOSYS             # error
+       sw      r4, [r0, PT_ORIG_R4]
+       sw      r4, [r0, PT_R4]
+       ldi     r9, 1                   # set error flag
+       sw      r9, [r0, PT_R7]
+       j       syscall_return
+
+       .globl  sys_fork_wrapper
+sys_fork_wrapper:
+       mv      r4, r0
+       la      r8, sys_fork
+       br      r8
+
+       .globl  sys_execve_wrapper
+sys_execve_wrapper:
+       mv      r4, r0
+       la      r8, sys_execve
+       br      r8
+
+       .globl  sys_clone_wrapper
+sys_clone_wrapper:
+       mv      r4, r0
+       la      r8, sys_clone
+       br      r8
+
+       .globl  sys_rt_sigsuspend_wrapper
+sys_rt_sigsuspend_wrapper:
+       mv      r4, r0
+       la      r8, sys_rt_sigsuspend
+       br      r8
+
+       .globl  sys_rt_sigreturn_wrapper
+sys_rt_sigreturn_wrapper:
+       mv      r4, r0
+       la      r8, sys_rt_sigreturn
+       br      r8
+
+       .globl  sys_sigaltstack_wrapper
+sys_sigaltstack_wrapper:
+       mv      r4, r0
+       la      r8, sys_sigaltstack
+       br      r8
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/kernel/head.S 
linux-2.6-git.new/arch/score/kernel/head.S
--- linux-2.6-git.ori/arch/score/kernel/head.S  1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/kernel/head.S  2009-04-07 
21:06:56.000000000 +0800
@@ -0,0 +1,71 @@
+/*
+ * arch/score/kernel/head.S
+ *
+ * Score Processor version.
+ *
+ * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
+ *  Chen Liqin <liqin.chen@sunplusct.com>
+ *  Lennox Wu <lennox.wu@sunplusct.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/init.h>
+#include <asm/asm-offsets.h>
+
+       .extern start_kernel
+       .global init_thread_union
+       .global kernelsp
+
+       .section .init.text, "ax"
+       .align  2;
+       .globl  _stext;
+_stext:
+       la      r30, __bss_start        /* initialize BSS segment. */
+       la      r31, _end
+       xor     r8, r8, r8
+
+1:     cmp.c   r31, r30
+       beq     2f
+
+       sw      r8, [r30]               /* clean memory. */
+       addi    r30, 4
+       b       1b
+
+2:     la      r28, init_thread_union  /* set kernel stack. */
+       mv      r0, r28
+       addi    r0, KERNEL_STACK_SIZE - 32
+       la      r30, kernelsp
+       sw      r0, [r30]
+       subi    r0, 4*4
+       xor     r30, r30, r30
+       ori     r30, 0x02               /* enable MMU. */
+       mtcr    r30, cr4
+       nop
+       nop
+       nop
+       nop
+       nop
+       nop
+       nop
+
+       /* there is no parameter */
+       xor     r4, r4, r4
+       xor     r5, r5, r5
+       xor     r6, r6, r6
+       xor     r7, r7, r7
+       la      r30, start_kernel       /* jump to init_arch */
+       br      r30
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/kernel/init_task.c 
linux-2.6-git.new/arch/score/kernel/init_task.c
--- linux-2.6-git.ori/arch/score/kernel/init_task.c     1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/kernel/init_task.c     2009-03-26 
14:52:19.000000000 +0800
@@ -0,0 +1,54 @@
+/*
+ * arch/score/kernel/init_task.c
+ *
+ * Score Processor version.
+ *
+ * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/mm.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/init_task.h>
+#include <linux/module.h>
+#include <linux/mqueue.h>
+#include <asm/uaccess.h>
+
+static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
+static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
+struct mm_struct init_mm = INIT_MM(init_mm);
+EXPORT_SYMBOL(init_mm);
+
+/*
+ * Initial thread structure.
+ *
+ * We need to make sure that this is THREAD_SIZE aligned due to the
+ * way process stacks are handled. This is done by having a special
+ * "init_task" linker map entry..
+ */
+union thread_union init_thread_union
+       __attribute__((__section__(".data.init_task"), 
__aligned__(THREAD_SIZE))) =
+               { INIT_THREAD_INFO(init_task) };
+
+/*
+ * Initial task structure.
+ *
+ * All other task structs will be allocated on slabs in fork.c
+ */
+struct task_struct init_task = INIT_TASK(init_task);
+EXPORT_SYMBOL(init_task);
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/kernel/irq.c 
linux-2.6-git.new/arch/score/kernel/irq.c
--- linux-2.6-git.ori/arch/score/kernel/irq.c   1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/kernel/irq.c   2009-04-08 
10:23:51.000000000 +0800
@@ -0,0 +1,139 @@
+/*
+ * arch/score/kernel/irq.c
+ *
+ * Score Processor version.
+ *
+ * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
+ *  Chen Liqin <liqin.chen@sunplusct.com>
+ *  Lennox Wu <lennox.wu@sunplusct.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/kernel_stat.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+
+/*
+ * handles all normal device IRQs
+ */
+asmlinkage void do_IRQ(int irq)
+{
+       irq_enter();
+       generic_handle_irq(irq);
+       irq_exit();
+}
+
+/*
+ * on-CPU PIC operations
+ */
+void ack_bad_irq(unsigned int irq)
+{
+       printk("unexpected IRQ # %d\n", irq);
+}
+
+static void score_mask(unsigned int irq_nr)
+{
+       unsigned int irq_source = 63 - irq_nr;
+
+       if (irq_source < 32)
+               __raw_writel((__raw_readl(P_INT_MASKL) | (1 << 
irq_source)), P_INT_MASKL);
+       else
+               __raw_writel((__raw_readl(P_INT_MASKH) | (1 << (irq_source 
- 32))), P_INT_MASKH);
+}
+
+static void score_unmask(unsigned int irq_nr)
+{
+       unsigned int irq_source = 63 - irq_nr;
+
+       if (irq_source < 32)
+               __raw_writel((__raw_readl(P_INT_MASKL) & ~(1 << 
irq_source)), P_INT_MASKL);
+       else
+               __raw_writel((__raw_readl(P_INT_MASKH) & ~(1 << 
(irq_source - 32))), P_INT_MASKH);
+}
+
+struct irq_chip score_irq_chip = {
+       .name           = "Score7-level",
+       .mask           = score_mask,
+       .mask_ack       = score_mask,
+       .unmask         = score_unmask,
+};
+
+/*
+ * initialise the interrupt system
+ */
+void __init init_IRQ(void)
+{
+       int index;
+       unsigned long target_addr;
+
+       for (index = 0; index < NR_IRQS; ++index)
+               set_irq_chip_and_handler(index, &score_irq_chip,
+                                        handle_level_irq);
+
+       for (target_addr = IRQ_VECTOR_BASE_ADDR;
+               target_addr <= IRQ_VECTOR_END_ADDR;
+               target_addr += IRQ_VECTOR_SIZE)
+               memcpy((void *)target_addr, interrupt_exception_vector, 
IRQ_VECTOR_SIZE);
+
+       __raw_writel(0xffffffff, P_INT_MASKL);
+       __raw_writel(0xffffffff, P_INT_MASKH);
+
+       __asm__ __volatile__(
+               "mtcr   %0, cr3\n\t"
+               : : "r" (EXCEPTION_VECTOR_BASE_ADDR | 
VECTOR_ADDRESS_OFFSET_MODE16));
+}
+
+/*
+ * Generic, controller-independent functions:
+ */
+int show_interrupts(struct seq_file *p, void *v)
+{
+       int i = *(loff_t *)v, cpu;
+       struct irqaction *action;
+       unsigned long flags;
+
+       if (i == 0) {
+               seq_puts(p, "           ");
+               for_each_online_cpu(cpu)
+                       seq_printf(p, "CPU%d       ", cpu);
+               seq_putc(p, '\n');
+       }
+
+       if (i < NR_IRQS) {
+               spin_lock_irqsave(&irq_desc[i].lock, flags);
+               action = irq_desc[i].action;
+               if (!action)
+                       goto unlock;
+
+               seq_printf(p, "%3d: ", i);
+               for_each_online_cpu(cpu)
+                       seq_printf(p, "%10u ", kstat_cpu(cpu).irqs[i]);
+               seq_printf(p, " %8s", irq_desc[i].chip->name ? : "-");
+               seq_printf(p, "  %s", action->name);
+               for (action = action->next; action; action = action->next)
+                       seq_printf(p, ", %s", action->name);
+
+               seq_putc(p, '\n');
+unlock:
+               spin_unlock_irqrestore(&irq_desc[i].lock, flags);
+       }
+
+       return 0;
+}
