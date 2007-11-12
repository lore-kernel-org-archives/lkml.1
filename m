Return-Path: <linux-kernel-owner+w=401wt.eu-S1754514AbXKLSSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754514AbXKLSSU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 13:18:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbXKLSSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 13:18:05 -0500
Received: from fk-out-0910.google.com ([209.85.128.187]:61888 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbXKLSSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 13:18:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=LCHNcBEQ0mFBb3fCjG7154cVfZP81cu/c+YAT2GNs+w5lYbB/WMTLxHAeWbHTjuPuFZO7fmdYtsjLZARVcKuX7rnIBN7Kusxy05qaZ4l1mV2FvlB86TKspufw1GXMpRuT7/UJiok2xLTlnZyCz9zhUtfG4GvdiU+WY5XtMTh1Pk=
Date: Mon, 12 Nov 2007 21:17:47 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] [IA32-EMU] Remove trailing spaces
Message-ID: <20071112181747.GE7296@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does remove trailing spaces from
source files.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
 arch/x86/ia32/fpu32.c              |   46 ++++++------
 arch/x86/ia32/ia32_aout.c          |   38 +++++-----
 arch/x86/ia32/ia32_binfmt.c        |    2 +-
 arch/x86/ia32/ia32_signal.c        |  132 ++++++++++++++++++------------------
 arch/x86/ia32/ia32entry.S          |  100 ++++++++++++++--------------
 arch/x86/ia32/ptrace32.c           |  122 +++++++++++++++++-----------------
 arch/x86/ia32/sys_ia32.c           |   98 +++++++++++++-------------
 arch/x86/ia32/syscall32.c          |   16 ++--
 arch/x86/ia32/tls32.c              |   18 +++---
 arch/x86/ia32/vsyscall-sigreturn.S |    4 +-
 arch/x86/ia32/vsyscall.lds         |    4 +-
 11 files changed, 290 insertions(+), 290 deletions(-)

diff --git a/arch/x86/ia32/fpu32.c b/arch/x86/ia32/fpu32.c
index 2c8209a..7ab8969 100644
--- a/arch/x86/ia32/fpu32.c
+++ b/arch/x86/ia32/fpu32.c
@@ -1,8 +1,8 @@
-/* 
+/*
  * Copyright 2002 Andi Kleen, SuSE Labs.
  * FXSAVE<->i387 conversion support. Based on code by Gareth Hughes.
  * This is used for ptrace, signals and coredumps in 32bit emulation.
- */ 
+ */
 
 #include <linux/sched.h>
 #include <asm/sigcontext32.h>
@@ -13,7 +13,7 @@
 static inline unsigned short twd_i387_to_fxsr(unsigned short twd)
 {
 	unsigned int tmp; /* to avoid 16 bit prefixes in the code */
- 
+
 	/* Transform each pair of bits into 01 (valid) or 00 (empty) */
         tmp = ~twd;
         tmp = (tmp | (tmp>>1)) & 0x5555; /* 0V0V0V0V0V0V0V0V */
@@ -91,8 +91,8 @@ static inline int convert_fxsr_from_user(struct i387_fxsave_struct *fxsave,
 	G(5, fxsave->rdp);
 	/* 6: ds ignored */
 #undef G
-	if (err) 
-		return -1; 
+	if (err)
+		return -1;
 
 	to = (struct _fpxreg *)&fxsave->st_space[0];
 	from = &buf->_st[0];
@@ -112,31 +112,31 @@ static inline int convert_fxsr_to_user(struct _fpstate_ia32 __user *buf,
 	struct _fpreg __user *to;
 	struct _fpxreg *from;
 	int i;
-	u16 cs,ds; 
-	int err = 0; 
+	u16 cs,ds;
+	int err = 0;
 
 	if (tsk == current) {
 		/* should be actually ds/cs at fpu exception time,
 		   but that information is not available in 64bit mode. */
-		asm("movw %%ds,%0 " : "=r" (ds)); 
-		asm("movw %%cs,%0 " : "=r" (cs)); 		
+		asm("movw %%ds,%0 " : "=r" (ds));
+		asm("movw %%cs,%0 " : "=r" (cs));
 	} else { /* ptrace. task has stopped. */
 		ds = tsk->thread.ds;
 		cs = regs->cs;
-	} 
+	}
 
 #define P(num,val) err |= __put_user(val, num + (u32 __user *)buf)
 	P(0, (u32)fxsave->cwd | 0xffff0000);
 	P(1, (u32)fxsave->swd | 0xffff0000);
 	P(2, twd_fxsr_to_i387(fxsave));
 	P(3, (u32)fxsave->rip);
-	P(4,  cs | ((u32)fxsave->fop) << 16); 
+	P(4,  cs | ((u32)fxsave->fop) << 16);
 	P(5, fxsave->rdp);
 	P(6, 0xffff0000 | ds);
 #undef P
 
-	if (err) 
-		return -1; 
+	if (err)
+		return -1;
 
 	to = &buf->_st[0];
 	from = (struct _fpxreg *) &fxsave->st_space[0];
@@ -147,22 +147,22 @@ static inline int convert_fxsr_to_user(struct _fpstate_ia32 __user *buf,
 	return 0;
 }
 
-int restore_i387_ia32(struct task_struct *tsk, struct _fpstate_ia32 __user *buf, int fsave) 
-{ 
+int restore_i387_ia32(struct task_struct *tsk, struct _fpstate_ia32 __user *buf, int fsave)
+{
 	clear_fpu(tsk);
-	if (!fsave) { 
-		if (__copy_from_user(&tsk->thread.i387.fxsave, 
+	if (!fsave) {
+		if (__copy_from_user(&tsk->thread.i387.fxsave,
 				     &buf->_fxsr_env[0],
 				     sizeof(struct i387_fxsave_struct)))
 			return -1;
 		tsk->thread.i387.fxsave.mxcsr &= mxcsr_feature_mask;
 		set_stopped_child_used_math(tsk);
-	} 
+	}
 	return convert_fxsr_from_user(&tsk->thread.i387.fxsave, buf);
-}  
+}
 
-int save_i387_ia32(struct task_struct *tsk, 
-		   struct _fpstate_ia32 __user *buf, 
+int save_i387_ia32(struct task_struct *tsk,
+		   struct _fpstate_ia32 __user *buf,
 		   struct pt_regs *regs,
 		   int fsave)
 {
@@ -174,8 +174,8 @@ int save_i387_ia32(struct task_struct *tsk,
 	if (fsave)
 		return 0;
 	err |= __put_user(tsk->thread.i387.fxsave.swd, &buf->status);
-	if (fsave) 
-		return err ? -1 : 1; 	
+	if (fsave)
+		return err ? -1 : 1;
 	err |= __put_user(X86_FXSR_MAGIC, &buf->magic);
 	err |= __copy_to_user(&buf->_fxsr_env[0], &tsk->thread.i387.fxsave,
 			      sizeof(struct i387_fxsave_struct));
diff --git a/arch/x86/ia32/ia32_aout.c b/arch/x86/ia32/ia32_aout.c
index f82e1a9..a7e0ac5 100644
--- a/arch/x86/ia32/ia32_aout.c
+++ b/arch/x86/ia32/ia32_aout.c
@@ -57,14 +57,14 @@ static void dump_thread32(struct pt_regs * regs, struct user32 * dump)
 	dump->u_dsize = ((unsigned long) (current->mm->brk + (PAGE_SIZE-1))) >> PAGE_SHIFT;
 	dump->u_dsize -= dump->u_tsize;
 	dump->u_ssize = 0;
-	dump->u_debugreg[0] = current->thread.debugreg0;  
-	dump->u_debugreg[1] = current->thread.debugreg1;  
-	dump->u_debugreg[2] = current->thread.debugreg2;  
-	dump->u_debugreg[3] = current->thread.debugreg3;  
-	dump->u_debugreg[4] = 0;  
-	dump->u_debugreg[5] = 0;  
-	dump->u_debugreg[6] = current->thread.debugreg6;  
-	dump->u_debugreg[7] = current->thread.debugreg7;  
+	dump->u_debugreg[0] = current->thread.debugreg0;
+	dump->u_debugreg[1] = current->thread.debugreg1;
+	dump->u_debugreg[2] = current->thread.debugreg2;
+	dump->u_debugreg[3] = current->thread.debugreg3;
+	dump->u_debugreg[4] = 0;
+	dump->u_debugreg[5] = 0;
+	dump->u_debugreg[6] = current->thread.debugreg6;
+	dump->u_debugreg[7] = current->thread.debugreg7;
 
 	if (dump->start_stack < 0xc0000000)
 		dump->u_ssize = ((unsigned long) (0xc0000000 - dump->start_stack)) >> PAGE_SHIFT;
@@ -79,7 +79,7 @@ static void dump_thread32(struct pt_regs * regs, struct user32 * dump)
 	dump->regs.ds = current->thread.ds;
 	dump->regs.es = current->thread.es;
 	asm("movl %%fs,%0" : "=r" (fs)); dump->regs.fs = fs;
-	asm("movl %%gs,%0" : "=r" (gs)); dump->regs.gs = gs; 
+	asm("movl %%gs,%0" : "=r" (gs)); dump->regs.gs = gs;
 	dump->regs.orig_eax = regs->orig_rax;
 	dump->regs.eip = regs->rip;
 	dump->regs.cs = regs->cs;
@@ -291,13 +291,13 @@ static int load_aout_binary(struct linux_binprm * bprm, struct pt_regs * regs)
 	if (retval)
 		return retval;
 
-	regs->cs = __USER32_CS; 
+	regs->cs = __USER32_CS;
 	regs->r8 = regs->r9 = regs->r10 = regs->r11 = regs->r12 =
 		regs->r13 = regs->r14 = regs->r15 = 0;
 
 	/* OK, This is the point of no return */
 	set_personality(PER_LINUX);
-	set_thread_flag(TIF_IA32); 
+	set_thread_flag(TIF_IA32);
 	clear_thread_flag(TIF_ABI_PENDING);
 
 	current->mm->end_code = ex.a_text +
@@ -338,7 +338,7 @@ static int load_aout_binary(struct linux_binprm * bprm, struct pt_regs * regs)
 			send_sig(SIGKILL, current, 0);
 			return error;
 		}
-			 
+
 		flush_icache_range(text_addr, text_addr+ex.a_text+ex.a_data);
 	} else {
 #ifdef WARN_OLD
@@ -353,7 +353,7 @@ static int load_aout_binary(struct linux_binprm * bprm, struct pt_regs * regs)
 		if ((fd_offset & ~PAGE_MASK) != 0 &&
 		    (jiffies-error_time) > 5*HZ)
 		{
-			printk(KERN_WARNING 
+			printk(KERN_WARNING
 			       "fd_offset is not page aligned. Please convert program: %s\n",
 			       bprm->file->f_path.dentry->d_name.name);
 			error_time = jiffies;
@@ -403,9 +403,9 @@ beyond_if:
 	set_brk(current->mm->start_brk, current->mm->brk);
 
 	retval = setup_arg_pages(bprm, IA32_STACK_TOP, EXSTACK_DEFAULT);
-	if (retval < 0) { 
-		/* Someone check-me: is this error path enough? */ 
-		send_sig(SIGKILL, current, 0); 
+	if (retval < 0) {
+		/* Someone check-me: is this error path enough? */
+		send_sig(SIGKILL, current, 0);
 		return retval;
 	}
 
@@ -414,7 +414,7 @@ beyond_if:
 	/* start thread */
 	asm volatile("movl %0,%%fs" :: "r" (0)); \
 	asm volatile("movl %0,%%es; movl %0,%%ds": :"r" (__USER32_DS));
-	load_gs_index(0); 
+	load_gs_index(0);
 	(regs)->rip = ex.a_entry;
 	(regs)->rsp = current->mm->start_stack;
 	(regs)->eflags = 0x200;
@@ -469,7 +469,7 @@ static int load_aout_library(struct file *file)
 		static unsigned long error_time;
 		if ((jiffies-error_time) > 5*HZ)
 		{
-			printk(KERN_WARNING 
+			printk(KERN_WARNING
 			       "N_TXTOFF is not page aligned. Please convert library: %s\n",
 			       file->f_path.dentry->d_name.name);
 			error_time = jiffies;
@@ -478,7 +478,7 @@ static int load_aout_library(struct file *file)
 		down_write(&current->mm->mmap_sem);
 		do_brk(start_addr, ex.a_text + ex.a_data + ex.a_bss);
 		up_write(&current->mm->mmap_sem);
-		
+
 		file->f_op->read(file, (char __user *)start_addr,
 			ex.a_text + ex.a_data, &pos);
 		flush_icache_range((unsigned long) start_addr,
diff --git a/arch/x86/ia32/ia32_binfmt.c b/arch/x86/ia32/ia32_binfmt.c
index 55822d2..a628aa2 100644
--- a/arch/x86/ia32/ia32_binfmt.c
+++ b/arch/x86/ia32/ia32_binfmt.c
@@ -277,7 +277,7 @@ static ctl_table abi_root_table2[] = {
 };
 
 static __init int ia32_binfmt_init(void)
-{ 
+{
 	register_sysctl_table(abi_root_table2);
 	return 0;
 }
diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index 6ea19c2..ce27379 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -76,10 +76,10 @@ int copy_siginfo_to_user32(compat_siginfo_t __user *to, siginfo_t *from)
 			err |= __put_user(from->si_uid, &to->si_uid);
 			break;
 		case __SI_POLL >> 16:
-			err |= __put_user(from->si_fd, &to->si_fd); 
+			err |= __put_user(from->si_fd, &to->si_fd);
 			break;
 		case __SI_TIMER >> 16:
-			err |= __put_user(from->si_overrun, &to->si_overrun); 
+			err |= __put_user(from->si_overrun, &to->si_overrun);
 			err |= __put_user(ptr_to_compat(from->si_ptr),
 					&to->si_ptr);
 			break;
@@ -130,13 +130,13 @@ sys32_sigsuspend(int history0, int history1, old_sigset_t mask)
 
 asmlinkage long
 sys32_sigaltstack(const stack_ia32_t __user *uss_ptr,
-		  stack_ia32_t __user *uoss_ptr, 
+		  stack_ia32_t __user *uoss_ptr,
 		  struct pt_regs *regs)
 {
-	stack_t uss,uoss; 
+	stack_t uss,uoss;
 	int ret;
-	mm_segment_t seg; 
-	if (uss_ptr) { 
+	mm_segment_t seg;
+	if (uss_ptr) {
 		u32 ptr;
 		memset(&uss,0,sizeof(stack_t));
 		if (!access_ok(VERIFY_READ,uss_ptr,sizeof(stack_ia32_t)) ||
@@ -146,18 +146,18 @@ sys32_sigaltstack(const stack_ia32_t __user *uss_ptr,
 			return -EFAULT;
 		uss.ss_sp = compat_ptr(ptr);
 	}
-	seg = get_fs(); 
-	set_fs(KERNEL_DS); 
+	seg = get_fs();
+	set_fs(KERNEL_DS);
 	ret = do_sigaltstack(uss_ptr ? &uss : NULL, &uoss, regs->rsp);
-	set_fs(seg); 
+	set_fs(seg);
 	if (ret >= 0 && uoss_ptr)  {
 		if (!access_ok(VERIFY_WRITE,uoss_ptr,sizeof(stack_ia32_t)) ||
 		    __put_user(ptr_to_compat(uoss.ss_sp), &uoss_ptr->ss_sp) ||
 		    __put_user(uoss.ss_flags, &uoss_ptr->ss_flags) ||
 		    __put_user(uoss.ss_size, &uoss_ptr->ss_size))
 			ret = -EFAULT;
-	} 	
-	return ret;	
+	}
+	return ret;
 }
 
 /*
@@ -190,7 +190,7 @@ static int
 ia32_restore_sigcontext(struct pt_regs *regs, struct sigcontext_ia32 __user *sc, unsigned int *peax)
 {
 	unsigned int err = 0;
-	
+
 	/* Always make any pending restarted system calls return -EINTR */
 	current_thread_info()->restart_block.fn = do_no_restart_syscall;
 
@@ -213,29 +213,29 @@ ia32_restore_sigcontext(struct pt_regs *regs, struct sigcontext_ia32 __user *sc,
 	  if (pre != cur) loadsegment(seg,pre); }
 
 	/* Reload fs and gs if they have changed in the signal handler.
-	   This does not handle long fs/gs base changes in the handler, but 
-	   does not clobber them at least in the normal case. */ 
-	
+	   This does not handle long fs/gs base changes in the handler, but
+	   does not clobber them at least in the normal case. */
+
 	{
-		unsigned gs, oldgs; 
+		unsigned gs, oldgs;
 		err |= __get_user(gs, &sc->gs);
-		gs |= 3; 
+		gs |= 3;
 		asm("movl %%gs,%0" : "=r" (oldgs));
 		if (gs != oldgs)
-		load_gs_index(gs); 
-	} 
+		load_gs_index(gs);
+	}
 	RELOAD_SEG(fs,3);
 	RELOAD_SEG(ds,3);
 	RELOAD_SEG(es,3);
 
 	COPY(di); COPY(si); COPY(bp); COPY(sp); COPY(bx);
 	COPY(dx); COPY(cx); COPY(ip);
-	/* Don't touch extended registers */ 
-	
-	err |= __get_user(regs->cs, &sc->cs); 
-	regs->cs |= 3;  
-	err |= __get_user(regs->ss, &sc->ss); 
-	regs->ss |= 3; 
+	/* Don't touch extended registers */
+
+	err |= __get_user(regs->cs, &sc->cs);
+	regs->cs |= 3;
+	err |= __get_user(regs->ss, &sc->ss);
+	regs->ss |= 3;
 
 	{
 		unsigned int tmpflags;
@@ -262,7 +262,7 @@ ia32_restore_sigcontext(struct pt_regs *regs, struct sigcontext_ia32 __user *sc,
 		}
 	}
 
-	{ 
+	{
 		u32 tmp;
 		err |= __get_user(tmp, &sc->eax);
 		*peax = tmp;
@@ -292,7 +292,7 @@ asmlinkage long sys32_sigreturn(struct pt_regs *regs)
 	current->blocked = set;
 	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
-	
+
 	if (ia32_restore_sigcontext(regs, &frame->sc, &eax))
 		goto badframe;
 	return eax;
@@ -300,7 +300,7 @@ asmlinkage long sys32_sigreturn(struct pt_regs *regs)
 badframe:
 	signal_fault(regs, frame, "32bit sigreturn");
 	return 0;
-}	
+}
 
 asmlinkage long sys32_rt_sigreturn(struct pt_regs *regs)
 {
@@ -321,7 +321,7 @@ asmlinkage long sys32_rt_sigreturn(struct pt_regs *regs)
 	current->blocked = set;
 	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
-	
+
 	if (ia32_restore_sigcontext(regs, &frame->uc.uc_mcontext, &eax))
 		goto badframe;
 
@@ -334,7 +334,7 @@ asmlinkage long sys32_rt_sigreturn(struct pt_regs *regs)
 badframe:
 	signal_fault(regs,frame,"32bit rt sigreturn");
 	return 0;
-}	
+}
 
 /*
  * Set up a signal frame.
@@ -375,7 +375,7 @@ ia32_setup_sigcontext(struct sigcontext_ia32 __user *sc, struct _fpstate_ia32 __
 	tmp = save_i387_ia32(current, fpstate, regs, 0);
 	if (tmp < 0)
 		err = -EFAULT;
-	else { 
+	else {
 		clear_used_math();
 		stts();
 		err |= __put_user(ptr_to_compat(tmp ? fpstate : NULL),
@@ -448,32 +448,32 @@ int ia32_setup_frame(int sig, struct k_sigaction *ka,
 		goto give_sigsegv;
 
 	/* Return stub is in 32bit vsyscall page */
-	{ 
+	{
 		void __user *restorer;
 		if (current->binfmt->hasvdso)
 			restorer = VSYSCALL32_SIGRETURN;
 		else
 			restorer = (void *)&frame->retcode;
 		if (ka->sa.sa_flags & SA_RESTORER)
-			restorer = ka->sa.sa_restorer;       
+			restorer = ka->sa.sa_restorer;
 		err |= __put_user(ptr_to_compat(restorer), &frame->pretcode);
 	}
-	/* These are actually not used anymore, but left because some 
+	/* These are actually not used anymore, but left because some
 	   gdb versions depend on them as a marker. */
-	{ 
+	{
 		/* copy_to_user optimizes that into a single 8 byte store */
-		static const struct { 
+		static const struct {
 			u16 poplmovl;
 			u32 val;
-			u16 int80;    
-			u16 pad; 
-		} __attribute__((packed)) code = { 
+			u16 int80;
+			u16 pad;
+		} __attribute__((packed)) code = {
 			0xb858,		 /* popl %eax ; movl $...,%eax */
-			__NR_ia32_sigreturn,   
+			__NR_ia32_sigreturn,
 			0x80cd,		/* int $0x80 */
 			0,
-		}; 
-		err |= __copy_to_user(frame->retcode, &code, 8); 
+		};
+		err |= __copy_to_user(frame->retcode, &code, 8);
 	}
 	if (err)
 		goto give_sigsegv;
@@ -487,11 +487,11 @@ int ia32_setup_frame(int sig, struct k_sigaction *ka,
 	regs->rdx = 0;
 	regs->rcx = 0;
 
-	asm volatile("movl %0,%%ds" :: "r" (__USER32_DS)); 
-	asm volatile("movl %0,%%es" :: "r" (__USER32_DS)); 
+	asm volatile("movl %0,%%ds" :: "r" (__USER32_DS));
+	asm volatile("movl %0,%%es" :: "r" (__USER32_DS));
 
-	regs->cs = __USER32_CS; 
-	regs->ss = __USER32_DS; 
+	regs->cs = __USER32_CS;
+	regs->ss = __USER32_DS;
 
 	set_fs(USER_DS);
 	regs->eflags &= ~TF_MASK;
@@ -549,33 +549,33 @@ int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	if (err)
 		goto give_sigsegv;
 
-	
-	{ 
-		void __user *restorer = VSYSCALL32_RTSIGRETURN; 
+
+	{
+		void __user *restorer = VSYSCALL32_RTSIGRETURN;
 		if (ka->sa.sa_flags & SA_RESTORER)
-			restorer = ka->sa.sa_restorer;       
+			restorer = ka->sa.sa_restorer;
 		err |= __put_user(ptr_to_compat(restorer), &frame->pretcode);
 	}
 
 	/* This is movl $,%eax ; int $0x80 */
 	/* Not actually used anymore, but left because some gdb versions
-	   need it. */ 
-	{ 
+	   need it. */
+	{
 		/* __copy_to_user optimizes that into a single 8 byte store */
-		static const struct { 
-			u8 movl; 
-			u32 val; 
-			u16 int80; 
+		static const struct {
+			u8 movl;
+			u32 val;
+			u16 int80;
 			u16 pad;
-			u8  pad2;				
-		} __attribute__((packed)) code = { 
+			u8  pad2;
+		} __attribute__((packed)) code = {
 			0xb8,
 			__NR_ia32_rt_sigreturn,
 			0x80cd,
 			0,
-		}; 
-		err |= __copy_to_user(frame->retcode, &code, 8); 
-	} 
+		};
+		err |= __copy_to_user(frame->retcode, &code, 8);
+	}
 	if (err)
 		goto give_sigsegv;
 
@@ -593,11 +593,11 @@ int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	regs->rdx = (unsigned long) &frame->info;
 	regs->rcx = (unsigned long) &frame->uc;
 
-	asm volatile("movl %0,%%ds" :: "r" (__USER32_DS)); 
-	asm volatile("movl %0,%%es" :: "r" (__USER32_DS)); 
-	
-	regs->cs = __USER32_CS; 
-	regs->ss = __USER32_DS; 
+	asm volatile("movl %0,%%ds" :: "r" (__USER32_DS));
+	asm volatile("movl %0,%%es" :: "r" (__USER32_DS));
+
+	regs->cs = __USER32_CS;
+	regs->ss = __USER32_DS;
 
 	set_fs(USER_DS);
 	regs->eflags &= ~TF_MASK;
diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index df588f0..2ee994b 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -1,16 +1,16 @@
 /*
- * Compatibility mode system call entry point for x86-64. 
- * 		
+ * Compatibility mode system call entry point for x86-64.
+ *
  * Copyright 2000-2002 Andi Kleen, SuSE Labs.
- */		 
+ */
 
 #include <asm/dwarf2.h>
 #include <asm/calling.h>
 #include <asm/asm-offsets.h>
 #include <asm/current.h>
 #include <asm/errno.h>
-#include <asm/ia32_unistd.h>	
-#include <asm/thread_info.h>	
+#include <asm/ia32_unistd.h>
+#include <asm/thread_info.h>
 #include <asm/segment.h>
 #include <asm/vsyscall32.h>
 #include <asm/irqflags.h>
@@ -27,9 +27,9 @@
 	xchg	%ecx,%esi
 	movl	%ebx,%edi
 	movl	%edx,%edx	/* zero extension */
-	.endm 
+	.endm
 
-	/* clobbers %eax */	
+	/* clobbers %eax */
 	.macro  CLEAR_RREGS
 	xorl 	%eax,%eax
 	movq	%rax,R11(%rsp)
@@ -49,7 +49,7 @@
 	movl \offset+64(%rsp),%edi
 	movl \offset+72(%rsp),%eax
 	.endm
-	
+
 	.macro CFI_STARTPROC32 simple
 	CFI_STARTPROC	\simple
 	CFI_UNDEFINED	r8
@@ -73,14 +73,14 @@
  * %esi Arg4
  * %edi Arg5
  * %ebp user stack
- * 0(%ebp) Arg6	
- * 	
+ * 0(%ebp) Arg6
+ *
  * Interrupts off.
- *	
+ *
  * This is purely a fast path. For anything complicated we use the int 0x80
  * path below.	Set up a complete hardware stack frame to share code
  * with the int 0x80 path.
- */ 	
+ */
 ENTRY(ia32_sysenter_target)
 	CFI_STARTPROC32	simple
 	CFI_SIGNAL_FRAME
@@ -88,12 +88,12 @@ ENTRY(ia32_sysenter_target)
 	CFI_REGISTER	rsp,rbp
 	swapgs
 	movq	%gs:pda_kernelstack, %rsp
-	addq	$(PDA_STACKOFFSET),%rsp	
+	addq	$(PDA_STACKOFFSET),%rsp
 	/*
 	 * No need to follow this irqs on/off section: the syscall
 	 * disabled irqs, here we enable it straight after entry:
 	 */
-	sti	
+	sti
  	movl	%ebp,%ebp		/* zero extension */
 	pushq	$__USER32_DS
 	CFI_ADJUST_CFA_OFFSET 8
@@ -118,17 +118,17 @@ ENTRY(ia32_sysenter_target)
 	cld
 	SAVE_ARGS 0,0,1
  	/* no need to do an access_ok check here because rbp has been
- 	   32bit zero extended */ 
+ 	   32bit zero extended */
 1:	movl	(%rbp),%r9d
  	.section __ex_table,"a"
  	.quad 1b,ia32_badarg
- 	.previous	
+ 	.previous
 	GET_THREAD_INFO(%r10)
 	orl    $TS_COMPAT,threadinfo_status(%r10)
 	testl  $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP),threadinfo_flags(%r10)
 	CFI_REMEMBER_STATE
 	jnz  sysenter_tracesys
-sysenter_do_call:	
+sysenter_do_call:
 	cmpl	$(IA32_NR_syscalls-1),%eax
 	ja	ia32_badsys
 	IA32_ARG_FIXUP 1
@@ -141,7 +141,7 @@ sysenter_do_call:
 	jnz	int_ret_from_sys_call
 	andl    $~TS_COMPAT,threadinfo_status(%r10)
 	/* clear IF, that popfq doesn't enable interrupts early */
-	andl  $~0x200,EFLAGS-R11(%rsp) 
+	andl  $~0x200,EFLAGS-R11(%rsp)
 	RESTORE_ARGS 1,24,1,1,1,1
 	popfq
 	CFI_ADJUST_CFA_OFFSET -8
@@ -179,20 +179,20 @@ ENDPROC(ia32_sysenter_target)
  * Arguments:
  * %eax	System call number.
  * %ebx Arg1
- * %ecx return EIP 
+ * %ecx return EIP
  * %edx Arg3
  * %esi Arg4
  * %edi Arg5
  * %ebp Arg2    [note: not saved in the stack frame, should not be touched]
- * %esp user stack 
+ * %esp user stack
  * 0(%esp) Arg6
- * 	
+ *
  * Interrupts off.
- *	
+ *
  * This is purely a fast path. For anything complicated we use the int 0x80
  * path below.	Set up a complete hardware stack frame to share code
- * with the int 0x80 path.	
- */ 	
+ * with the int 0x80 path.
+ */
 ENTRY(ia32_cstar_target)
 	CFI_STARTPROC32	simple
 	CFI_SIGNAL_FRAME
@@ -219,21 +219,21 @@ ENTRY(ia32_cstar_target)
 	movq	$__USER32_DS,SS-ARGOFFSET(%rsp)
 	movq	%r11,EFLAGS-ARGOFFSET(%rsp)
 	/*CFI_REL_OFFSET rflags,EFLAGS-ARGOFFSET*/
-	movq	%r8,RSP-ARGOFFSET(%rsp)	
+	movq	%r8,RSP-ARGOFFSET(%rsp)
 	CFI_REL_OFFSET rsp,RSP-ARGOFFSET
 	/* no need to do an access_ok check here because r8 has been
-	   32bit zero extended */ 
-	/* hardware stack frame is complete now */	
+	   32bit zero extended */
+	/* hardware stack frame is complete now */
 1:	movl	(%r8),%r9d
 	.section __ex_table,"a"
 	.quad 1b,ia32_badarg
-	.previous	
+	.previous
 	GET_THREAD_INFO(%r10)
 	orl   $TS_COMPAT,threadinfo_status(%r10)
 	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP),threadinfo_flags(%r10)
 	CFI_REMEMBER_STATE
 	jnz   cstar_tracesys
-cstar_do_call:	
+cstar_do_call:
 	cmpl $IA32_NR_syscalls-1,%eax
 	ja  ia32_badsys
 	IA32_ARG_FIXUP 1
@@ -248,15 +248,15 @@ cstar_do_call:
 	RESTORE_ARGS 1,-ARG_SKIP,1,1,1
 	movl RIP-ARGOFFSET(%rsp),%ecx
 	CFI_REGISTER rip,rcx
-	movl EFLAGS-ARGOFFSET(%rsp),%r11d	
+	movl EFLAGS-ARGOFFSET(%rsp),%r11d
 	/*CFI_REGISTER rflags,r11*/
 	TRACE_IRQS_ON
 	movl RSP-ARGOFFSET(%rsp),%esp
 	CFI_RESTORE rsp
 	swapgs
 	sysretl
-	
-cstar_tracesys:	
+
+cstar_tracesys:
 	CFI_RESTORE_STATE
 	xchgl %r9d,%ebp
 	SAVE_REST
@@ -271,16 +271,16 @@ cstar_tracesys:
 	movl RSP-ARGOFFSET(%rsp), %r8d
 	jmp cstar_do_call
 END(ia32_cstar_target)
-				
+
 ia32_badarg:
 	movq $-EFAULT,%rax
 	jmp ia32_sysret
 	CFI_ENDPROC
 
-/* 
- * Emulated IA32 system calls via int 0x80. 
+/*
+ * Emulated IA32 system calls via int 0x80.
  *
- * Arguments:	 
+ * Arguments:
  * %eax	System call number.
  * %ebx Arg1
  * %ecx Arg2
@@ -290,13 +290,13 @@ ia32_badarg:
  * %ebp Arg6    [note: not saved in the stack frame, should not be touched]
  *
  * Notes:
- * Uses the same stack frame as the x86-64 version.	
+ * Uses the same stack frame as the x86-64 version.
  * All registers except %eax must be saved (but ptrace may violate that)
  * Arguments are zero extended. For system calls that want sign extension and
  * take long arguments a wrapper is needed. Most calls can just be called
  * directly.
- * Assumes it is only called from user space and entered with interrupts off.	
- */ 				
+ * Assumes it is only called from user space and entered with interrupts off.
+ */
 
 ENTRY(ia32_syscall)
 	CFI_STARTPROC32	simple
@@ -324,16 +324,16 @@ ENTRY(ia32_syscall)
 	orl   $TS_COMPAT,threadinfo_status(%r10)
 	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP),threadinfo_flags(%r10)
 	jnz ia32_tracesys
-ia32_do_syscall:	
+ia32_do_syscall:
 	cmpl $(IA32_NR_syscalls-1),%eax
 	ja  ia32_badsys
 	IA32_ARG_FIXUP
 	call *ia32_sys_call_table(,%rax,8) # xxx: rip relative
 ia32_sysret:
 	movq %rax,RAX-ARGOFFSET(%rsp)
-	jmp int_ret_from_sys_call 
+	jmp int_ret_from_sys_call
 
-ia32_tracesys:			 
+ia32_tracesys:
 	SAVE_REST
 	CLEAR_RREGS
 	movq $-ENOSYS,RAX(%rsp)	/* really needed? */
@@ -353,13 +353,13 @@ quiet_ni_syscall:
 	movq $-ENOSYS,%rax
 	ret
 	CFI_ENDPROC
-	
+
 	.macro PTREGSCALL label, func, arg
 	.globl \label
 \label:
 	leaq \func(%rip),%rax
 	leaq -ARGOFFSET+8(%rsp),\arg	/* 8 for return address */
-	jmp  ia32_ptregs_common	
+	jmp  ia32_ptregs_common
 	.endm
 
 	CFI_STARTPROC32
@@ -435,7 +435,7 @@ ia32_sys_call_table:
 	.quad quiet_ni_syscall	/* old stty syscall holder */
 	.quad quiet_ni_syscall	/* old gtty syscall holder */
 	.quad sys_access
-	.quad sys_nice	
+	.quad sys_nice
 	.quad quiet_ni_syscall	/* 35 */	/* old ftime syscall holder */
 	.quad sys_sync
 	.quad sys32_kill
@@ -514,7 +514,7 @@ ia32_sys_call_table:
 	.quad stub32_iopl		/* 110 */
 	.quad sys_vhangup
 	.quad quiet_ni_syscall	/* old "idle" system call */
-	.quad sys32_vm86_warning	/* vm86old */ 
+	.quad sys32_vm86_warning	/* vm86old */
 	.quad compat_sys_wait4
 	.quad sys_swapoff		/* 115 */
 	.quad compat_sys_sysinfo
@@ -567,7 +567,7 @@ ia32_sys_call_table:
 	.quad sys_mremap
 	.quad sys_setresuid16
 	.quad sys_getresuid16	/* 165 */
-	.quad sys32_vm86_warning	/* vm86 */ 
+	.quad sys32_vm86_warning	/* vm86 */
 	.quad quiet_ni_syscall	/* query_module */
 	.quad sys_poll
 	.quad compat_sys_nfsservctl
@@ -622,10 +622,10 @@ ia32_sys_call_table:
 	.quad sys_mincore
 	.quad sys_madvise
 	.quad compat_sys_getdents64	/* 220 getdents64 */
-	.quad compat_sys_fcntl64	
+	.quad compat_sys_fcntl64
 	.quad quiet_ni_syscall		/* tux */
 	.quad quiet_ni_syscall    	/* security */
-	.quad sys_gettid	
+	.quad sys_gettid
 	.quad sys32_readahead	/* 225 */
 	.quad sys_setxattr
 	.quad sys_lsetxattr
@@ -640,7 +640,7 @@ ia32_sys_call_table:
 	.quad sys_lremovexattr
 	.quad sys_fremovexattr
 	.quad sys_tkill
-	.quad sys_sendfile64 
+	.quad sys_sendfile64
 	.quad compat_sys_futex		/* 240 */
 	.quad compat_sys_sched_setaffinity
 	.quad compat_sys_sched_getaffinity
diff --git a/arch/x86/ia32/ptrace32.c b/arch/x86/ia32/ptrace32.c
index 4a233ad..283332f 100644
--- a/arch/x86/ia32/ptrace32.c
+++ b/arch/x86/ia32/ptrace32.c
@@ -1,13 +1,13 @@
-/* 
+/*
  * 32bit ptrace for x86-64.
  *
  * Copyright 2001,2002 Andi Kleen, SuSE Labs.
- * Some parts copied from arch/i386/kernel/ptrace.c. See that file for earlier 
+ * Some parts copied from arch/i386/kernel/ptrace.c. See that file for earlier
  * copyright.
- * 
- * This allows to access 64bit processes too; but there is no way to see the extended 
+ *
+ * This allows to access 64bit processes too; but there is no way to see the extended
  * register contents.
- */ 
+ */
 
 #include <linux/kernel.h>
 #include <linux/stddef.h>
@@ -45,30 +45,30 @@ static int putreg32(struct task_struct *child, unsigned regno, u32 val)
 
 	switch (regno) {
 	case offsetof(struct user32, regs.fs):
-		if (val && (val & 3) != 3) return -EIO; 
+		if (val && (val & 3) != 3) return -EIO;
 		child->thread.fsindex = val & 0xffff;
 		break;
 	case offsetof(struct user32, regs.gs):
-		if (val && (val & 3) != 3) return -EIO; 
+		if (val && (val & 3) != 3) return -EIO;
 		child->thread.gsindex = val & 0xffff;
 		break;
 	case offsetof(struct user32, regs.ds):
-		if (val && (val & 3) != 3) return -EIO; 
+		if (val && (val & 3) != 3) return -EIO;
 		child->thread.ds = val & 0xffff;
 		break;
 	case offsetof(struct user32, regs.es):
 		child->thread.es = val & 0xffff;
 		break;
-	case offsetof(struct user32, regs.ss): 
+	case offsetof(struct user32, regs.ss):
 		if ((val & 3) != 3) return -EIO;
         	stack[offsetof(struct pt_regs, ss)/8] = val & 0xffff;
 		break;
-	case offsetof(struct user32, regs.cs): 
+	case offsetof(struct user32, regs.cs):
 		if ((val & 3) != 3) return -EIO;
 		stack[offsetof(struct pt_regs, cs)/8] = val & 0xffff;
 		break;
 
-	R32(ebx, rbx); 
+	R32(ebx, rbx);
 	R32(ecx, rcx);
 	R32(edx, rdx);
 	R32(edi, rdi);
@@ -86,7 +86,7 @@ static int putreg32(struct task_struct *child, unsigned regno, u32 val)
 		break;
 	}
 
-	case offsetof(struct user32, u_debugreg[4]): 
+	case offsetof(struct user32, u_debugreg[4]):
 	case offsetof(struct user32, u_debugreg[5]):
 		return -EIO;
 
@@ -108,7 +108,7 @@ static int putreg32(struct task_struct *child, unsigned regno, u32 val)
 
 	case offsetof(struct user32, u_debugreg[6]):
 		child->thread.debugreg6 = val;
-		break; 
+		break;
 
 	case offsetof(struct user32, u_debugreg[7]):
 		val &= ~DR_CONTROL_RESERVED;
@@ -117,19 +117,19 @@ static int putreg32(struct task_struct *child, unsigned regno, u32 val)
 		for(i=0; i<4; i++)
 			if ((0x5454 >> ((val >> (16 + 4*i)) & 0xf)) & 1)
 			       return -EIO;
-		child->thread.debugreg7 = val; 
+		child->thread.debugreg7 = val;
 		if (val)
 			set_tsk_thread_flag(child, TIF_DEBUG);
 		else
 			clear_tsk_thread_flag(child, TIF_DEBUG);
-		break; 
-		    
+		break;
+
 	default:
 		if (regno > sizeof(struct user32) || (regno & 3))
 			return -EIO;
-	       
-		/* Other dummy fields in the virtual user structure are ignored */ 
-		break; 		
+
+		/* Other dummy fields in the virtual user structure are ignored */
+		break;
 	}
 	return 0;
 }
@@ -159,7 +159,7 @@ static int getreg32(struct task_struct *child, unsigned regno, u32 *val)
 
 	R32(cs, cs);
 	R32(ss, ss);
-	R32(ebx, rbx); 
+	R32(ebx, rbx);
 	R32(ecx, rcx);
 	R32(edx, rdx);
 	R32(edi, rdi);
@@ -171,32 +171,32 @@ static int getreg32(struct task_struct *child, unsigned regno, u32 *val)
 	R32(eflags, eflags);
 	R32(esp, rsp);
 
-	case offsetof(struct user32, u_debugreg[0]): 
-		*val = child->thread.debugreg0; 
-		break; 
-	case offsetof(struct user32, u_debugreg[1]): 
-		*val = child->thread.debugreg1; 
-		break; 
-	case offsetof(struct user32, u_debugreg[2]): 
-		*val = child->thread.debugreg2; 
-		break; 
-	case offsetof(struct user32, u_debugreg[3]): 
-		*val = child->thread.debugreg3; 
-		break; 
-	case offsetof(struct user32, u_debugreg[6]): 
-		*val = child->thread.debugreg6; 
-		break; 
-	case offsetof(struct user32, u_debugreg[7]): 
-		*val = child->thread.debugreg7; 
-		break; 
-		    
+	case offsetof(struct user32, u_debugreg[0]):
+		*val = child->thread.debugreg0;
+		break;
+	case offsetof(struct user32, u_debugreg[1]):
+		*val = child->thread.debugreg1;
+		break;
+	case offsetof(struct user32, u_debugreg[2]):
+		*val = child->thread.debugreg2;
+		break;
+	case offsetof(struct user32, u_debugreg[3]):
+		*val = child->thread.debugreg3;
+		break;
+	case offsetof(struct user32, u_debugreg[6]):
+		*val = child->thread.debugreg6;
+		break;
+	case offsetof(struct user32, u_debugreg[7]):
+		*val = child->thread.debugreg7;
+		break;
+
 	default:
 		if (regno > sizeof(struct user32) || (regno & 3))
 			return -EIO;
 
-		/* Other dummy fields in the virtual user structure are ignored */ 
+		/* Other dummy fields in the virtual user structure are ignored */
 		*val = 0;
-		break; 		
+		break;
 	}
 	return 0;
 }
@@ -207,7 +207,7 @@ static long ptrace32_siginfo(unsigned request, u32 pid, u32 addr, u32 data)
 {
 	int ret;
 	compat_siginfo_t __user *si32 = compat_ptr(data);
-	siginfo_t ssi; 
+	siginfo_t ssi;
 	siginfo_t __user *si = compat_alloc_user_space(sizeof(siginfo_t));
 	if (request == PTRACE_SETSIGINFO) {
 		memset(&ssi, 0, sizeof(siginfo_t));
@@ -231,12 +231,12 @@ static long ptrace32_siginfo(unsigned request, u32 pid, u32 addr, u32 data)
 asmlinkage long sys32_ptrace(long request, u32 pid, u32 addr, u32 data)
 {
 	struct task_struct *child;
-	struct pt_regs *childregs; 
+	struct pt_regs *childregs;
 	void __user *datap = compat_ptr(data);
 	int ret;
 	__u32 val;
 
-	switch (request) { 
+	switch (request) {
 	case PTRACE_TRACEME:
 	case PTRACE_ATTACH:
 	case PTRACE_KILL:
@@ -248,7 +248,7 @@ asmlinkage long sys32_ptrace(long request, u32 pid, u32 addr, u32 data)
 	case PTRACE_SETOPTIONS:
 	case PTRACE_SET_THREAD_AREA:
 	case PTRACE_GET_THREAD_AREA:
-		return sys_ptrace(request, pid, addr, data); 
+		return sys_ptrace(request, pid, addr, data);
 
 	default:
 		return -EINVAL;
@@ -257,7 +257,7 @@ asmlinkage long sys32_ptrace(long request, u32 pid, u32 addr, u32 data)
 	case PTRACE_PEEKDATA:
 	case PTRACE_POKEDATA:
 	case PTRACE_POKETEXT:
-	case PTRACE_POKEUSR:       
+	case PTRACE_POKEUSR:
 	case PTRACE_PEEKUSR:
 	case PTRACE_GETREGS:
 	case PTRACE_SETREGS:
@@ -290,14 +290,14 @@ asmlinkage long sys32_ptrace(long request, u32 pid, u32 addr, u32 data)
 		if (access_process_vm(child, addr, &val, sizeof(u32), 0)!=sizeof(u32))
 			ret = -EIO;
 		else
-			ret = put_user(val, (unsigned int __user *)datap); 
-		break; 
+			ret = put_user(val, (unsigned int __user *)datap);
+		break;
 
 	case PTRACE_POKEDATA:
 	case PTRACE_POKETEXT:
 		ret = 0;
 		if (access_process_vm(child, addr, &data, sizeof(u32), 1)!=sizeof(u32))
-			ret = -EIO; 
+			ret = -EIO;
 		break;
 
 	case PTRACE_PEEKUSR:
@@ -332,7 +332,7 @@ asmlinkage long sys32_ptrace(long request, u32 pid, u32 addr, u32 data)
 			ret = -EIO;
 			break;
 		}
-		ret = 0; 
+		ret = 0;
 		for ( i = 0; i <= 16*4; i += sizeof(u32) ) {
 			ret |= __get_user(tmp, (u32 __user *)datap);
 			putreg32(child, i, tmp);
@@ -342,17 +342,17 @@ asmlinkage long sys32_ptrace(long request, u32 pid, u32 addr, u32 data)
 	}
 
 	case PTRACE_GETFPREGS:
-		ret = -EIO; 
-		if (!access_ok(VERIFY_READ, compat_ptr(data), 
+		ret = -EIO;
+		if (!access_ok(VERIFY_READ, compat_ptr(data),
 			       sizeof(struct user_i387_struct)))
 			break;
 		save_i387_ia32(child, datap, childregs, 1);
-		ret = 0; 
+		ret = 0;
 			break;
 
 	case PTRACE_SETFPREGS:
 		ret = -EIO;
-		if (!access_ok(VERIFY_WRITE, datap, 
+		if (!access_ok(VERIFY_WRITE, datap,
 			       sizeof(struct user_i387_struct)))
 			break;
 		ret = 0;
@@ -360,9 +360,9 @@ asmlinkage long sys32_ptrace(long request, u32 pid, u32 addr, u32 data)
 		restore_i387_ia32(child, datap, 1);
 		break;
 
-	case PTRACE_GETFPXREGS: { 
+	case PTRACE_GETFPXREGS: {
 		struct user32_fxsr_struct __user *u = datap;
-		init_fpu(child); 
+		init_fpu(child);
 		ret = -EIO;
 		if (!access_ok(VERIFY_WRITE, u, sizeof(*u)))
 			break;
@@ -370,10 +370,10 @@ asmlinkage long sys32_ptrace(long request, u32 pid, u32 addr, u32 data)
 		if (__copy_to_user(u, &child->thread.i387.fxsave, sizeof(*u)))
 			break;
 		ret = __put_user(childregs->cs, &u->fcs);
-		ret |= __put_user(child->thread.ds, &u->fos); 
-		break; 
-	} 
-	case PTRACE_SETFPXREGS: { 
+		ret |= __put_user(child->thread.ds, &u->fos);
+		break;
+	}
+	case PTRACE_SETFPXREGS: {
 		struct user32_fxsr_struct __user *u = datap;
 		unlazy_fpu(child);
 		ret = -EIO;
@@ -385,7 +385,7 @@ asmlinkage long sys32_ptrace(long request, u32 pid, u32 addr, u32 data)
 			;
 		set_stopped_child_used_math(child);
 		child->thread.i387.fxsave.mxcsr &= mxcsr_feature_mask;
-		ret = 0; 
+		ret = 0;
 		break;
 	}
 
diff --git a/arch/x86/ia32/sys_ia32.c b/arch/x86/ia32/sys_ia32.c
index bee96d6..0cee460 100644
--- a/arch/x86/ia32/sys_ia32.c
+++ b/arch/x86/ia32/sys_ia32.c
@@ -1,6 +1,6 @@
 /*
  * sys_ia32.c: Conversion between 32bit and 64bit native syscalls. Based on
- *             sys_sparc32 
+ *             sys_sparc32
  *
  * Copyright (C) 2000		VA Linux Co
  * Copyright (C) 2000		Don Dugger <n0ano@valinux.com>
@@ -9,21 +9,21 @@
  * Copyright (C) 1997 		David S. Miller (davem@caip.rutgers.edu)
  * Copyright (C) 2000		Hewlett-Packard Co.
  * Copyright (C) 2000		David Mosberger-Tang <davidm@hpl.hp.com>
- * Copyright (C) 2000,2001,2002	Andi Kleen, SuSE Labs (x86-64 port) 
+ * Copyright (C) 2000,2001,2002	Andi Kleen, SuSE Labs (x86-64 port)
  *
  * These routines maintain argument size conversion between 32bit and 64bit
- * environment. In 2.5 most of this should be moved to a generic directory. 
+ * environment. In 2.5 most of this should be moved to a generic directory.
  *
  * This file assumes that there is a hole at the end of user address space.
- * 
+ *
  * Some of the functions are LE specific currently. These are hopefully all marked.
  * This should be fixed.
  */
 
 #include <linux/kernel.h>
 #include <linux/sched.h>
-#include <linux/fs.h> 
-#include <linux/file.h> 
+#include <linux/fs.h>
+#include <linux/file.h>
 #include <linux/signal.h>
 #include <linux/syscalls.h>
 #include <linux/resource.h>
@@ -122,7 +122,7 @@ sys32_ftruncate64(unsigned int fd, unsigned long offset_low, unsigned long offse
        return sys_ftruncate(fd, ((loff_t) offset_high << 32) | offset_low);
 }
 
-/* Another set for IA32/LFS -- x86_64 struct stat is different due to 
+/* Another set for IA32/LFS -- x86_64 struct stat is different due to
    support for 64bit inode numbers. */
 
 static int
@@ -233,29 +233,29 @@ sys32_mmap(struct mmap_arg_struct __user *arg)
 		return -EFAULT;
 
 	if (a.offset & ~PAGE_MASK)
-		return -EINVAL; 
+		return -EINVAL;
 
 	if (!(a.flags & MAP_ANONYMOUS)) {
 		file = fget(a.fd);
 		if (!file)
 			return -EBADF;
 	}
-	
-	mm = current->mm; 
-	down_write(&mm->mmap_sem); 
+
+	mm = current->mm;
+	down_write(&mm->mmap_sem);
 	retval = do_mmap_pgoff(file, a.addr, a.len, a.prot, a.flags, a.offset>>PAGE_SHIFT);
 	if (file)
 		fput(file);
 
-	up_write(&mm->mmap_sem); 
+	up_write(&mm->mmap_sem);
 
 	return retval;
 }
 
-asmlinkage long 
+asmlinkage long
 sys32_mprotect(unsigned long start, size_t len, unsigned long prot)
 {
-	return sys_mprotect(start,len,prot); 
+	return sys_mprotect(start,len,prot);
 }
 
 asmlinkage long
@@ -383,7 +383,7 @@ sys32_rt_sigprocmask(int how, compat_sigset_t __user *set,
 	compat_sigset_t s32;
 	int ret;
 	mm_segment_t old_fs = get_fs();
-	
+
 	if (set) {
 		if (copy_from_user (&s32, set, sizeof(compat_sigset_t)))
 			return -EFAULT;
@@ -398,7 +398,7 @@ sys32_rt_sigprocmask(int how, compat_sigset_t __user *set,
 	ret = sys_rt_sigprocmask(how,
 				 set ? (sigset_t __user *)&s : NULL,
 				 oset ? (sigset_t __user *)&s : NULL,
-				 sigsetsize); 
+				 sigsetsize);
 	set_fs (old_fs);
 	if (ret) return ret;
 	if (oset) {
@@ -417,23 +417,23 @@ sys32_rt_sigprocmask(int how, compat_sigset_t __user *set,
 static inline long
 get_tv32(struct timeval *o, struct compat_timeval __user *i)
 {
-	int err = -EFAULT; 
-	if (access_ok(VERIFY_READ, i, sizeof(*i))) { 
+	int err = -EFAULT;
+	if (access_ok(VERIFY_READ, i, sizeof(*i))) {
 		err = __get_user(o->tv_sec, &i->tv_sec);
 		err |= __get_user(o->tv_usec, &i->tv_usec);
 	}
-	return err; 
+	return err;
 }
 
 static inline long
 put_tv32(struct compat_timeval __user *o, struct timeval *i)
 {
 	int err = -EFAULT;
-	if (access_ok(VERIFY_WRITE, o, sizeof(*o))) { 
+	if (access_ok(VERIFY_WRITE, o, sizeof(*o))) {
 		err = __put_user(i->tv_sec, &o->tv_sec);
 		err |= __put_user(i->tv_usec, &o->tv_usec);
-	} 
-	return err; 
+	}
+	return err;
 }
 
 extern unsigned int alarm_setitimer(unsigned int seconds);
@@ -529,7 +529,7 @@ sys32_sched_rr_get_interval(compat_pid_t pid, struct compat_timespec __user *int
 	struct timespec t;
 	int ret;
 	mm_segment_t old_fs = get_fs ();
-	
+
 	set_fs (KERNEL_DS);
 	ret = sys_sched_rr_get_interval(pid, (struct timespec __user *)&t);
 	set_fs (old_fs);
@@ -545,7 +545,7 @@ sys32_rt_sigpending(compat_sigset_t __user *set, compat_size_t sigsetsize)
 	compat_sigset_t s32;
 	int ret;
 	mm_segment_t old_fs = get_fs();
-		
+
 	set_fs (KERNEL_DS);
 	ret = sys_rt_sigpending((sigset_t __user *)&s, sigsetsize);
 	set_fs (old_fs);
@@ -568,7 +568,7 @@ sys32_rt_sigqueueinfo(int pid, int sig, compat_siginfo_t __user *uinfo)
 	siginfo_t info;
 	int ret;
 	mm_segment_t old_fs = get_fs();
-	
+
 	if (copy_siginfo_from_user32(&info, uinfo))
 		return -EFAULT;
 	set_fs (KERNEL_DS);
@@ -643,7 +643,7 @@ sys32_sysctl(struct sysctl_ia32 __user *args32)
 }
 #endif
 
-/* warning: next two assume little endian */ 
+/* warning: next two assume little endian */
 asmlinkage long
 sys32_pread(unsigned int fd, char __user *ubuf, u32 count, u32 poslo, u32 poshi)
 {
@@ -663,7 +663,7 @@ asmlinkage long
 sys32_personality(unsigned long personality)
 {
 	int ret;
-	if (personality(current->personality) == PER_LINUX32 && 
+	if (personality(current->personality) == PER_LINUX32 &&
 		personality == PER_LINUX)
 		personality = PER_LINUX32;
 	ret = sys_personality(personality);
@@ -678,18 +678,18 @@ sys32_sendfile(int out_fd, int in_fd, compat_off_t __user *offset, s32 count)
 	mm_segment_t old_fs = get_fs();
 	int ret;
 	off_t of;
-	
+
 	if (offset && get_user(of, offset))
 		return -EFAULT;
-		
+
 	set_fs(KERNEL_DS);
 	ret = sys_sendfile(out_fd, in_fd, offset ? (off_t __user *)&of : NULL,
 			   count);
 	set_fs(old_fs);
-	
+
 	if (offset && put_user(of, offset))
 		return -EFAULT;
-		
+
 	return ret;
 }
 
@@ -725,7 +725,7 @@ asmlinkage long sys32_olduname(struct oldold_utsname __user * name)
 		return -EFAULT;
 	if (!access_ok(VERIFY_WRITE, name, sizeof(struct oldold_utsname)))
 		return -EFAULT;
-  
+
   	down_read(&uts_sem);
 
 	err = __copy_to_user(&name->sysname,&utsname()->sysname,
@@ -744,7 +744,7 @@ asmlinkage long sys32_olduname(struct oldold_utsname __user * name)
 		char *arch = "x86_64";
 		if (personality(current->personality) == PER_LINUX32)
 			arch = "i686";
-		 
+
 		err |= __copy_to_user(&name->machine, arch, strlen(arch)+1);
 	}
 
@@ -763,7 +763,7 @@ long sys32_uname(struct old_utsname __user * name)
 	down_read(&uts_sem);
 	err = copy_to_user(name, utsname(), sizeof (*name));
 	up_read(&uts_sem);
-	if (personality(current->personality) == PER_LINUX32) 
+	if (personality(current->personality) == PER_LINUX32)
 		err |= copy_to_user(&name->machine, "i686", 5);
 	return err?-EFAULT:0;
 }
@@ -773,13 +773,13 @@ long sys32_ustat(unsigned dev, struct ustat32 __user *u32p)
 	struct ustat u;
 	mm_segment_t seg;
 	int ret;
-	
-	seg = get_fs(); 
-	set_fs(KERNEL_DS); 
+
+	seg = get_fs();
+	set_fs(KERNEL_DS);
 	ret = sys_ustat(dev, (struct ustat __user *)&u);
 	set_fs(seg);
-	if (ret >= 0) { 
-		if (!access_ok(VERIFY_WRITE,u32p,sizeof(struct ustat32)) || 
+	if (ret >= 0) {
+		if (!access_ok(VERIFY_WRITE,u32p,sizeof(struct ustat32)) ||
 		    __put_user((__u32) u.f_tfree, &u32p->f_tfree) ||
 		    __put_user((__u32) u.f_tinode, &u32p->f_tfree) ||
 		    __copy_to_user(&u32p->f_fname, u.f_fname, sizeof(u.f_fname)) ||
@@ -787,7 +787,7 @@ long sys32_ustat(unsigned dev, struct ustat32 __user *u32p)
 			ret = -EFAULT;
 	}
 	return ret;
-} 
+}
 
 asmlinkage long sys32_execve(char __user *name, compat_uptr_t __user *argv,
 			     compat_uptr_t __user *envp, struct pt_regs *regs)
@@ -821,7 +821,7 @@ asmlinkage long sys32_clone(unsigned int clone_flags, unsigned int newsp,
 
 /*
  * Some system calls that need sign extended arguments. This could be done by a generic wrapper.
- */ 
+ */
 
 long sys32_lseek (unsigned int fd, int offset, unsigned int whence)
 {
@@ -832,27 +832,27 @@ long sys32_kill(int pid, int sig)
 {
 	return sys_kill(pid, sig);
 }
- 
-long sys32_fadvise64_64(int fd, __u32 offset_low, __u32 offset_high, 
+
+long sys32_fadvise64_64(int fd, __u32 offset_low, __u32 offset_high,
 			__u32 len_low, __u32 len_high, int advice)
-{ 
+{
 	return sys_fadvise64_64(fd,
 			       (((u64)offset_high)<<32) | offset_low,
 			       (((u64)len_high)<<32) | len_low,
-			       advice); 
-} 
+			       advice);
+}
 
 long sys32_vm86_warning(void)
-{ 
+{
 	struct task_struct *me = current;
 	static char lastcomm[sizeof(me->comm)];
 	if (strncmp(lastcomm, me->comm, sizeof(lastcomm))) {
 		compat_printk(KERN_INFO "%s: vm86 mode not supported on 64 bit kernel\n",
 		       me->comm);
 		strncpy(lastcomm, me->comm, sizeof(lastcomm));
-	} 
+	}
 	return -ENOSYS;
-} 
+}
 
 long sys32_lookup_dcookie(u32 addr_low, u32 addr_high,
 			  char __user * buf, size_t len)
diff --git a/arch/x86/ia32/syscall32.c b/arch/x86/ia32/syscall32.c
index 15013ba..6df8ec7 100644
--- a/arch/x86/ia32/syscall32.c
+++ b/arch/x86/ia32/syscall32.c
@@ -1,6 +1,6 @@
 /* Copyright 2002,2003 Andi Kleen, SuSE Labs */
 
-/* vsyscall handling for 32bit processes. Map a stub page into it 
+/* vsyscall handling for 32bit processes. Map a stub page into it
    on demand because 32bit cannot reach the kernel's fixmaps */
 
 #include <linux/mm.h>
@@ -50,10 +50,10 @@ int syscall32_setup_pages(struct linux_binprm *bprm, int exstack)
 }
 
 static int __init init_syscall32(void)
-{ 
+{
 	char *syscall32_page = (void *)get_zeroed_page(GFP_KERNEL);
-	if (!syscall32_page) 
-		panic("Cannot allocate syscall32 page"); 
+	if (!syscall32_page)
+		panic("Cannot allocate syscall32 page");
 	syscall32_pages[0] = virt_to_page(syscall32_page);
  	if (use_sysenter > 0) {
  		memcpy(syscall32_page, syscall32_sysenter,
@@ -61,11 +61,11 @@ static int __init init_syscall32(void)
  	} else {
   		memcpy(syscall32_page, syscall32_syscall,
   		       syscall32_syscall_end - syscall32_syscall);
-  	}	
+  	}
 	return 0;
-} 
-	
-__initcall(init_syscall32); 
+}
+
+__initcall(init_syscall32);
 
 /* May not be __init: called during resume */
 void syscall32_cpu_init(void)
diff --git a/arch/x86/ia32/tls32.c b/arch/x86/ia32/tls32.c
index 1cc4340..54a6047 100644
--- a/arch/x86/ia32/tls32.c
+++ b/arch/x86/ia32/tls32.c
@@ -26,7 +26,7 @@ static int get_free_idx(void)
 
 /*
  * Set a given TLS descriptor:
- * When you want addresses > 32bit use arch_prctl() 
+ * When you want addresses > 32bit use arch_prctl()
  */
 int do_set_thread_area(struct thread_struct *t, struct user_desc __user *u_info)
 {
@@ -76,9 +76,9 @@ int do_set_thread_area(struct thread_struct *t, struct user_desc __user *u_info)
 }
 
 asmlinkage long sys32_set_thread_area(struct user_desc __user *u_info)
-{ 
-	return do_set_thread_area(&current->thread, u_info); 
-} 
+{
+	return do_set_thread_area(&current->thread, u_info);
+}
 
 
 /*
@@ -93,7 +93,7 @@ asmlinkage long sys32_set_thread_area(struct user_desc __user *u_info)
 #define GET_LIMIT(desc) ( \
 	((desc)->a & 0x0ffff) | \
 	 ((desc)->b & 0xf0000) )
-	
+
 #define GET_32BIT(desc)		(((desc)->b >> 22) & 1)
 #define GET_CONTENTS(desc)	(((desc)->b >> 10) & 3)
 #define GET_WRITABLE(desc)	(((desc)->b >>  9) & 1)
@@ -135,7 +135,7 @@ int do_get_thread_area(struct thread_struct *t, struct user_desc __user *u_info)
 asmlinkage long sys32_get_thread_area(struct user_desc __user *u_info)
 {
 	return do_get_thread_area(&current->thread, u_info);
-} 
+}
 
 
 int ia32_child_tls(struct task_struct *p, struct pt_regs *childregs)
@@ -144,17 +144,17 @@ int ia32_child_tls(struct task_struct *p, struct pt_regs *childregs)
 	struct user_desc info;
 	struct user_desc __user *cp;
 	int idx;
-	
+
 	cp = (void __user *)childregs->rsi;
 	if (copy_from_user(&info, cp, sizeof(info)))
 		return -EFAULT;
 	if (LDT_empty(&info))
 		return -EINVAL;
-	
+
 	idx = info.entry_number;
 	if (idx < GDT_ENTRY_TLS_MIN || idx > GDT_ENTRY_TLS_MAX)
 		return -EINVAL;
-	
+
 	desc = (struct n_desc_struct *)(p->thread.tls_array) + idx - GDT_ENTRY_TLS_MIN;
 	desc->a = LDT_entry_a(&info);
 	desc->b = LDT_entry_b(&info);
diff --git a/arch/x86/ia32/vsyscall-sigreturn.S b/arch/x86/ia32/vsyscall-sigreturn.S
index b383be0..a71a4a4 100644
--- a/arch/x86/ia32/vsyscall-sigreturn.S
+++ b/arch/x86/ia32/vsyscall-sigreturn.S
@@ -68,9 +68,9 @@ __kernel_rt_sigreturn:
 	   be the value of the stack pointer in the caller.  This means
 	   that we must define the CFA of this body of code to be the
 	   saved value of the stack pointer in the sigcontext.  Which
-	   also means that there is no fixed relation to the other 
+	   also means that there is no fixed relation to the other
 	   saved registers, which means that we must use DW_CFA_expression
-	   to compute their addresses.  It also means that when we 
+	   to compute their addresses.  It also means that when we
 	   adjust the stack with the popl, we have to do it all over again.  */
 
 #define do_cfa_expr(offset)						\
diff --git a/arch/x86/ia32/vsyscall.lds b/arch/x86/ia32/vsyscall.lds
index 1dc86ff..d9ba318 100644
--- a/arch/x86/ia32/vsyscall.lds
+++ b/arch/x86/ia32/vsyscall.lds
@@ -23,7 +23,7 @@ SECTIONS
      space for the dynamic symbol table et al.  If this amount
      is insufficient, ld -shared will barf.  Just increase it here.  */
   . = VSYSCALL_BASE + 0x400;
-  
+
   .text.vsyscall   : { *(.text.vsyscall) } 	:text =0x90909090
 
   /* This is an 32bit object and we cannot easily get the offsets
@@ -36,7 +36,7 @@ SECTIONS
   . = VSYSCALL_BASE + 0x600;
 
   .text.rtsigreturn : { *(.text.rtsigreturn) }   :text =0x90909090
-	
+
   .note		  : { *(.note.*) }		:text :note
   .eh_frame_hdr   : { *(.eh_frame_hdr) }	:text :eh_frame_hdr
   .eh_frame       : { KEEP (*(.eh_frame)) }	:text

