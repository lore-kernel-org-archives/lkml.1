Return-Path: <linux-kernel-owner+w=401wt.eu-S1753266AbYKPO2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbYKPO2R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 09:28:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751991AbYKPO2C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 09:28:02 -0500
Received: from m-relay2.rz.uni-saarland.de ([134.96.7.8]:7340 "EHLO
	eris.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbYKPO17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 09:27:59 -0500
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH] trivial, entry_64: remove whitespace at end of lines
Date: Sun, 16 Nov 2008 15:29:00 +0100
Message-Id: <1226845741-12470-1-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (eris.rz.uni-saarland.de [134.96.7.8]); Sun, 16 Nov 2008 15:27:47 +0100 (CET)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.9.0.31; VDF: 7.1.0.88; host: AntiVir2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All blame goes to: color white,red "[^[:graph:]]+$"
in .nanorc ;).

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/entry_64.S |  200 ++++++++++++++++++++++----------------------
 1 files changed, 100 insertions(+), 100 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 983d85a..a3a7fb2 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -11,15 +11,15 @@
  *
  * NOTE: This code handles signal-recognition, which happens every time
  * after an interrupt and after each system call.
- * 
- * Normal syscalls and interrupts don't save a full stack frame, this is 
+ *
+ * Normal syscalls and interrupts don't save a full stack frame, this is
  * only done for syscall tracing, signals or fork/exec et.al.
- * 
- * A note on terminology:	 
- * - top of stack: Architecture defined interrupt frame from SS to RIP 
- * at the top of the kernel process stack.	
+ *
+ * A note on terminology:
+ * - top of stack: Architecture defined interrupt frame from SS to RIP
+ * at the top of the kernel process stack.
  * - partial stack frame: partially saved registers upto R11.
- * - full stack frame: Like partial stack frame, but all register saved. 
+ * - full stack frame: Like partial stack frame, but all register saved.
  *
  * Some macro usage:
  * - CFI macros are used to generate dwarf2 unwind information for better
@@ -147,7 +147,7 @@ END(mcount)
 
 #ifndef CONFIG_PREEMPT
 #define retint_kernel retint_restore_args
-#endif	
+#endif
 
 #ifdef CONFIG_PARAVIRT
 ENTRY(native_usergs_sysret64)
@@ -166,14 +166,14 @@ ENTRY(native_usergs_sysret64)
 .endm
 
 /*
- * C code is not supposed to know about undefined top of stack. Every time 
- * a C function with an pt_regs argument is called from the SYSCALL based 
+ * C code is not supposed to know about undefined top of stack. Every time
+ * a C function with an pt_regs argument is called from the SYSCALL based
  * fast path FIXUP_TOP_OF_STACK is needed.
  * RESTORE_TOP_OF_STACK syncs the syscall state after any possible ptregs
  * manipulation.
- */        	
-		
-	/* %rsp:at FRAMEEND */ 
+ */
+
+	/* %rsp:at FRAMEEND */
 	.macro FIXUP_TOP_OF_STACK tmp
 	movq	%gs:pda_oldrsp,\tmp
 	movq  	\tmp,RSP(%rsp)
@@ -249,8 +249,8 @@ ENTRY(native_usergs_sysret64)
 	.endm
 /*
  * A newly forked process directly context switches into this.
- */ 	
-/* rdi:	prev */	
+ */
+/* rdi:	prev */
 ENTRY(ret_from_fork)
 	CFI_DEFAULT_STACK
 	push kernel_eflags(%rip)
@@ -262,7 +262,7 @@ ENTRY(ret_from_fork)
 	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT),TI_flags(%rcx)
 	CFI_REMEMBER_STATE
 	jnz rff_trace
-rff_action:	
+rff_action:
 	RESTORE_REST
 	testl $3,CS-ARGOFFSET(%rsp)	# from kernel_thread?
 	je   int_ret_from_sys_call
@@ -274,7 +274,7 @@ rff_action:
 rff_trace:
 	movq %rsp,%rdi
 	call syscall_trace_leave
-	GET_THREAD_INFO(%rcx)	
+	GET_THREAD_INFO(%rcx)
 	jmp rff_action
 	CFI_ENDPROC
 END(ret_from_fork)
@@ -285,20 +285,20 @@ END(ret_from_fork)
  * SYSCALL does not save anything on the stack and does not change the
  * stack pointer.
  */
-		
+
 /*
- * Register setup:	
+ * Register setup:
  * rax  system call number
  * rdi  arg0
- * rcx  return address for syscall/sysret, C arg3 
+ * rcx  return address for syscall/sysret, C arg3
  * rsi  arg1
- * rdx  arg2	
+ * rdx  arg2
  * r10  arg3 	(--> moved to rcx for C)
  * r8   arg4
  * r9   arg5
  * r11  eflags for syscall/sysret, temporary for C
- * r12-r15,rbp,rbx saved by C code, not touched. 		
- * 
+ * r12-r15,rbp,rbx saved by C code, not touched.
+ *
  * Interrupts are off on entry.
  * Only called from user space.
  *
@@ -308,7 +308,7 @@ END(ret_from_fork)
  * When user can change the frames always force IRET. That is because
  * it deals with uncanonical addresses better. SYSRET has trouble
  * with them due to bugs in both AMD and Intel CPUs.
- */ 			 		
+ */
 
 ENTRY(system_call)
 	CFI_STARTPROC	simple
@@ -324,7 +324,7 @@ ENTRY(system_call)
 	 */
 ENTRY(system_call_after_swapgs)
 
-	movq	%rsp,%gs:pda_oldrsp 
+	movq	%rsp,%gs:pda_oldrsp
 	movq	%gs:pda_kernelstack,%rsp
 	/*
 	 * No need to follow this irqs off/on section - it's straight
@@ -332,7 +332,7 @@ ENTRY(system_call_after_swapgs)
 	 */
 	ENABLE_INTERRUPTS(CLBR_NONE)
 	SAVE_ARGS 8,1
-	movq  %rax,ORIG_RAX-ARGOFFSET(%rsp) 
+	movq  %rax,ORIG_RAX-ARGOFFSET(%rsp)
 	movq  %rcx,RIP-ARGOFFSET(%rsp)
 	CFI_REL_OFFSET rip,RIP-ARGOFFSET
 	GET_THREAD_INFO(%rcx)
@@ -346,19 +346,19 @@ system_call_fastpath:
 	movq %rax,RAX-ARGOFFSET(%rsp)
 /*
  * Syscall return path ending with SYSRET (fast path)
- * Has incomplete stack frame and undefined top of stack. 
- */		
+ * Has incomplete stack frame and undefined top of stack.
+ */
 ret_from_sys_call:
 	movl $_TIF_ALLWORK_MASK,%edi
 	/* edi:	flagmask */
-sysret_check:		
+sysret_check:
 	LOCKDEP_SYS_EXIT
 	GET_THREAD_INFO(%rcx)
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
 	movl TI_flags(%rcx),%edx
 	andl %edi,%edx
-	jnz  sysret_careful 
+	jnz  sysret_careful
 	CFI_REMEMBER_STATE
 	/*
 	 * sysretq will re-enable interrupts:
@@ -373,7 +373,7 @@ sysret_check:
 
 	CFI_RESTORE_STATE
 	/* Handle reschedules */
-	/* edx:	work, edi: workmask */	
+	/* edx:	work, edi: workmask */
 sysret_careful:
 	bt $TIF_NEED_RESCHED,%edx
 	jnc sysret_signal
@@ -386,7 +386,7 @@ sysret_careful:
 	CFI_ADJUST_CFA_OFFSET -8
 	jmp sysret_check
 
-	/* Handle a signal */ 
+	/* Handle a signal */
 sysret_signal:
 	TRACE_IRQS_ON
 	ENABLE_INTERRUPTS(CLBR_NONE)
@@ -405,7 +405,7 @@ sysret_signal:
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
 	jmp int_with_check
-	
+
 badsys:
 	movq $-ENOSYS,RAX-ARGOFFSET(%rsp)
 	jmp ret_from_sys_call
@@ -444,7 +444,7 @@ sysret_audit:
 #endif	/* CONFIG_AUDITSYSCALL */
 
 	/* Do syscall tracing */
-tracesys:			 
+tracesys:
 #ifdef CONFIG_AUDITSYSCALL
 	testl $(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags(%rcx)
 	jz auditsys
@@ -467,8 +467,8 @@ tracesys:
 	call *sys_call_table(,%rax,8)
 	movq %rax,RAX-ARGOFFSET(%rsp)
 	/* Use IRET because user could have changed frame */
-		
-/* 
+
+/*
  * Syscall return path ending with IRET.
  * Has correct top of stack, but partial stack frame.
  */
@@ -512,18 +512,18 @@ int_very_careful:
 	TRACE_IRQS_ON
 	ENABLE_INTERRUPTS(CLBR_NONE)
 	SAVE_REST
-	/* Check for syscall exit trace */	
+	/* Check for syscall exit trace */
 	testl $_TIF_WORK_SYSCALL_EXIT,%edx
 	jz int_signal
 	pushq %rdi
 	CFI_ADJUST_CFA_OFFSET 8
-	leaq 8(%rsp),%rdi	# &ptregs -> arg1	
+	leaq 8(%rsp),%rdi	# &ptregs -> arg1
 	call syscall_trace_leave
 	popq %rdi
 	CFI_ADJUST_CFA_OFFSET -8
 	andl $~(_TIF_WORK_SYSCALL_EXIT|_TIF_SYSCALL_EMU),%edi
 	jmp int_restore_rest
-	
+
 int_signal:
 	testl $_TIF_DO_NOTIFY_MASK,%edx
 	jz 1f
@@ -538,11 +538,11 @@ int_restore_rest:
 	jmp int_with_check
 	CFI_ENDPROC
 END(system_call)
-		
-/* 
+
+/*
  * Certain special system calls that need to save a complete full stack frame.
- */ 								
-	
+ */
+
 	.macro PTREGSCALL label,func,arg
 	.globl \label
 \label:
@@ -579,7 +579,7 @@ ENTRY(ptregscall_common)
 	ret
 	CFI_ENDPROC
 END(ptregscall_common)
-	
+
 ENTRY(stub_execve)
 	CFI_STARTPROC
 	popq %r11
@@ -595,11 +595,11 @@ ENTRY(stub_execve)
 	jmp int_ret_from_sys_call
 	CFI_ENDPROC
 END(stub_execve)
-	
+
 /*
  * sigreturn is special because it needs to restore all registers on return.
  * This cannot be done with SYSRET, so use the IRET return path instead.
- */                
+ */
 ENTRY(stub_rt_sigreturn)
 	CFI_STARTPROC
 	addq $8, %rsp
@@ -634,15 +634,15 @@ END(stub_rt_sigreturn)
    vector already pushed) */
 #define XCPT_FRAME _frame ORIG_RAX
 
-/* 
+/*
  * Interrupt entry/exit.
  *
  * Interrupt entry points save only callee clobbered registers in fast path.
- *	
- * Entry runs with interrupts off.	
- */ 
+ *
+ * Entry runs with interrupts off.
+ */
 
-/* 0(%rsp): interrupt number */ 
+/* 0(%rsp): interrupt number */
 	.macro interrupt func
 	cld
 	SAVE_ARGS
@@ -692,12 +692,12 @@ exit_intr:
 	GET_THREAD_INFO(%rcx)
 	testl $3,CS-ARGOFFSET(%rsp)
 	je retint_kernel
-	
+
 	/* Interrupt came from user space */
 	/*
 	 * Has a correct top of stack, but a partial stack frame
 	 * %rcx: thread info. Interrupts off.
-	 */		
+	 */
 retint_with_reschedule:
 	movl $_TIF_WORK_MASK,%edi
 retint_check:
@@ -770,20 +770,20 @@ retint_careful:
 	pushq %rdi
 	CFI_ADJUST_CFA_OFFSET	8
 	call  schedule
-	popq %rdi		
+	popq %rdi
 	CFI_ADJUST_CFA_OFFSET	-8
 	GET_THREAD_INFO(%rcx)
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
 	jmp retint_check
-	
+
 retint_signal:
 	testl $_TIF_DO_NOTIFY_MASK,%edx
 	jz    retint_swapgs
 	TRACE_IRQS_ON
 	ENABLE_INTERRUPTS(CLBR_NONE)
 	SAVE_REST
-	movq $-1,ORIG_RAX(%rsp) 			
+	movq $-1,ORIG_RAX(%rsp)
 	xorl %esi,%esi		# oldset
 	movq %rsp,%rdi		# &pt_regs
 	call do_notify_resume
@@ -805,14 +805,14 @@ ENTRY(retint_kernel)
 	jnc  retint_restore_args
 	call preempt_schedule_irq
 	jmp exit_intr
-#endif	
+#endif
 
 	CFI_ENDPROC
 END(common_interrupt)
-	
+
 /*
  * APIC interrupts.
- */		
+ */
 	.macro apicinterrupt num,func
 	INTR_FRAME
 	pushq $~(\num)
@@ -830,14 +830,14 @@ ENTRY(threshold_interrupt)
 	apicinterrupt THRESHOLD_APIC_VECTOR,mce_threshold_interrupt
 END(threshold_interrupt)
 
-#ifdef CONFIG_SMP	
+#ifdef CONFIG_SMP
 ENTRY(reschedule_interrupt)
 	apicinterrupt RESCHEDULE_VECTOR,smp_reschedule_interrupt
 END(reschedule_interrupt)
 
 	.macro INVALIDATE_ENTRY num
 ENTRY(invalidate_interrupt\num)
-	apicinterrupt INVALIDATE_TLB_VECTOR_START+\num,smp_invalidate_interrupt	
+	apicinterrupt INVALIDATE_TLB_VECTOR_START+\num,smp_invalidate_interrupt
 END(invalidate_interrupt\num)
 	.endm
 
@@ -876,22 +876,22 @@ END(error_interrupt)
 ENTRY(spurious_interrupt)
 	apicinterrupt SPURIOUS_APIC_VECTOR,smp_spurious_interrupt
 END(spurious_interrupt)
-				
+
 /*
  * Exception entry points.
- */ 		
+ */
 	.macro zeroentry sym
 	INTR_FRAME
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
-	pushq $0	/* push error code/oldrax */ 
+	pushq $0	/* push error code/oldrax */
 	CFI_ADJUST_CFA_OFFSET 8
-	pushq %rax	/* push real oldrax to the rdi slot */ 
+	pushq %rax	/* push real oldrax to the rdi slot */
 	CFI_ADJUST_CFA_OFFSET 8
 	CFI_REL_OFFSET rax,0
 	leaq  \sym(%rip),%rax
 	jmp error_entry
 	CFI_ENDPROC
-	.endm	
+	.endm
 
 	.macro errorentry sym
 	XCPT_FRAME
@@ -1005,13 +1005,13 @@ paranoid_schedule\trace:
 
 /*
  * Exception entry point. This expects an error code/orig_rax on the stack
- * and the exception handler in %rax.	
- */ 		  				
+ * and the exception handler in %rax.
+ */
 KPROBE_ENTRY(error_entry)
 	_frame RDI
 	CFI_REL_OFFSET rax,0
 	/* rdi slot contains rax, oldrax contains error code */
-	cld	
+	cld
 	subq  $14*8,%rsp
 	CFI_ADJUST_CFA_OFFSET	(14*8)
 	movq %rsi,13*8(%rsp)
@@ -1022,7 +1022,7 @@ KPROBE_ENTRY(error_entry)
 	CFI_REL_OFFSET	rdx,RDX
 	movq %rcx,11*8(%rsp)
 	CFI_REL_OFFSET	rcx,RCX
-	movq %rsi,10*8(%rsp)	/* store rax */ 
+	movq %rsi,10*8(%rsp)	/* store rax */
 	CFI_REL_OFFSET	rax,RAX
 	movq %r8, 9*8(%rsp)
 	CFI_REL_OFFSET	r8,R8
@@ -1032,29 +1032,29 @@ KPROBE_ENTRY(error_entry)
 	CFI_REL_OFFSET	r10,R10
 	movq %r11,6*8(%rsp)
 	CFI_REL_OFFSET	r11,R11
-	movq %rbx,5*8(%rsp) 
+	movq %rbx,5*8(%rsp)
 	CFI_REL_OFFSET	rbx,RBX
-	movq %rbp,4*8(%rsp) 
+	movq %rbp,4*8(%rsp)
 	CFI_REL_OFFSET	rbp,RBP
-	movq %r12,3*8(%rsp) 
+	movq %r12,3*8(%rsp)
 	CFI_REL_OFFSET	r12,R12
-	movq %r13,2*8(%rsp) 
+	movq %r13,2*8(%rsp)
 	CFI_REL_OFFSET	r13,R13
-	movq %r14,1*8(%rsp) 
+	movq %r14,1*8(%rsp)
 	CFI_REL_OFFSET	r14,R14
-	movq %r15,(%rsp) 
+	movq %r15,(%rsp)
 	CFI_REL_OFFSET	r15,R15
-	xorl %ebx,%ebx	
+	xorl %ebx,%ebx
 	testl $3,CS(%rsp)
 	je  error_kernelspace
-error_swapgs:	
+error_swapgs:
 	SWAPGS
 error_sti:
 	TRACE_IRQS_OFF
-	movq %rdi,RDI(%rsp) 	
+	movq %rdi,RDI(%rsp)
 	CFI_REL_OFFSET	rdi,RDI
 	movq %rsp,%rdi
-	movq ORIG_RAX(%rsp),%rsi	/* get error code */ 
+	movq ORIG_RAX(%rsp),%rsi	/* get error code */
 	movq $-1,ORIG_RAX(%rsp)
 	call *%rax
 	/* ebx:	no swapgs flag (1: don't need swapgs, 0: need it) */
@@ -1063,7 +1063,7 @@ error_exit:
 	RESTORE_REST
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
-	GET_THREAD_INFO(%rcx)	
+	GET_THREAD_INFO(%rcx)
 	testl %eax,%eax
 	jne  retint_kernel
 	LOCKDEP_SYS_EXIT_IRQ
@@ -1079,7 +1079,7 @@ error_kernelspace:
        /* There are two places in the kernel that can potentially fault with
           usergs. Handle them here. The exception handlers after
 	   iret run with kernel gs again, so don't set the user space flag.
-	   B stepping K8s sometimes report an truncated RIP for IRET 
+	   B stepping K8s sometimes report an truncated RIP for IRET
 	   exceptions returning to compat mode. Check for these here too. */
 	leaq irq_return(%rip),%rcx
 	cmpq %rcx,RIP(%rsp)
@@ -1091,17 +1091,17 @@ error_kernelspace:
         je   error_swapgs
 	jmp  error_sti
 KPROBE_END(error_entry)
-	
+
        /* Reload gs selector with exception handling */
-       /* edi:  new selector */ 
+       /* edi:  new selector */
 ENTRY(native_load_gs_index)
 	CFI_STARTPROC
 	pushf
 	CFI_ADJUST_CFA_OFFSET 8
 	DISABLE_INTERRUPTS(CLBR_ANY | ~(CLBR_RDI))
         SWAPGS
-gs_change:     
-        movl %edi,%gs   
+gs_change:
+        movl %edi,%gs
 2:	mfence		/* workaround */
 	SWAPGS
         popf
@@ -1109,20 +1109,20 @@ gs_change:
         ret
 	CFI_ENDPROC
 ENDPROC(native_load_gs_index)
-       
+
         .section __ex_table,"a"
         .align 8
         .quad gs_change,bad_gs
         .previous
         .section .fixup,"ax"
 	/* running with kernelgs */
-bad_gs: 
+bad_gs:
 	SWAPGS			/* switch back to user gs */
 	xorl %eax,%eax
         movl %eax,%gs
         jmp  2b
-        .previous       
-	
+        .previous
+
 /*
  * Create a kernel thread.
  *
@@ -1145,7 +1145,7 @@ ENTRY(kernel_thread)
 
 	xorl %r8d,%r8d
 	xorl %r9d,%r9d
-	
+
 	# clone now
 	call do_fork
 	movq %rax,RAX(%rsp)
@@ -1156,14 +1156,14 @@ ENTRY(kernel_thread)
 	 * so internally to the x86_64 port you can rely on kernel_thread()
 	 * not to reschedule the child before returning, this avoids the need
 	 * of hacks for example to fork off the per-CPU idle tasks.
-         * [Hopefully no generic code relies on the reschedule -AK]	
+         * [Hopefully no generic code relies on the reschedule -AK]
 	 */
 	RESTORE_ALL
 	UNFAKE_STACK_FRAME
 	ret
 	CFI_ENDPROC
 ENDPROC(kernel_thread)
-	
+
 child_rip:
 	pushq $0		# fake return address
 	CFI_STARTPROC
@@ -1198,10 +1198,10 @@ ENDPROC(child_rip)
 ENTRY(kernel_execve)
 	CFI_STARTPROC
 	FAKE_STACK_FRAME $0
-	SAVE_ALL	
+	SAVE_ALL
 	movq %rsp,%rcx
 	call sys_execve
-	movq %rax, RAX(%rsp)	
+	movq %rax, RAX(%rsp)
 	RESTORE_REST
 	testq %rax,%rax
 	je int_ret_from_sys_call
@@ -1220,7 +1220,7 @@ ENTRY(coprocessor_error)
 END(coprocessor_error)
 
 ENTRY(simd_coprocessor_error)
-	zeroentry do_simd_coprocessor_error	
+	zeroentry do_simd_coprocessor_error
 END(simd_coprocessor_error)
 
 ENTRY(device_not_available)
@@ -1232,12 +1232,12 @@ KPROBE_ENTRY(debug)
  	INTR_FRAME
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
 	pushq $0
-	CFI_ADJUST_CFA_OFFSET 8		
+	CFI_ADJUST_CFA_OFFSET 8
 	paranoidentry do_debug, DEBUG_STACK
 	paranoidexit
 KPROBE_END(debug)
 
-	/* runs on exception stack */	
+	/* runs on exception stack */
 KPROBE_ENTRY(nmi)
 	INTR_FRAME
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
@@ -1271,7 +1271,7 @@ ENTRY(bounds)
 END(bounds)
 
 ENTRY(invalid_op)
-	zeroentry do_invalid_op	
+	zeroentry do_invalid_op
 END(invalid_op)
 
 ENTRY(coprocessor_segment_overrun)
@@ -1326,7 +1326,7 @@ ENTRY(machine_check)
 	INTR_FRAME
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
 	pushq $0
-	CFI_ADJUST_CFA_OFFSET 8	
+	CFI_ADJUST_CFA_OFFSET 8
 	paranoidentry do_machine_check
 	jmp paranoid_exit1
 	CFI_ENDPROC
-- 
1.5.4.3

