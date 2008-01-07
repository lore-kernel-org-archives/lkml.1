Return-Path: <linux-kernel-owner+w=401wt.eu-S1757304AbYAGLkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304AbYAGLkZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 06:40:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754786AbYAGLkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 06:40:15 -0500
Received: from ro-out-1112.google.com ([72.14.202.178]:43836 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754573AbYAGLkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 06:40:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=jQ4aQ/+dsWX3h/i8usUGyBV81AAtqtqnVUG7E0G1jfLkDafmdzIFU0o8MZRHZ/rUOYzkX4fhbTHoMvJ2Zk7xqCnj3Nz6RgcsBC4z2V56P3NmJDo4S0e3MkI2UBIxheF058WAnQoZempxHvSzOCXgzu5+jLlraCL1M8D1dR1WCTQ=
Message-ID: <4d8e3fd30801070340l57892cbar3df6539f132bcc41@mail.gmail.com>
Date: Mon, 7 Jan 2008 12:40:07 +0100
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: [PATCH 5/5] Codying style fixes in ./arch/x86/ia32
Cc: "Ingo Molnar" <mingo@elte.hu>, trivial@kernel.org,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix plenty of codying style errors

Checkpatch now reports:
total: 3 errors, 9 warnings, 617 lines checked

Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/ia32/ia32_signal.c |  192 +++++++++++++++++++++---------------------
 1 files changed, 96 insertions(+), 96 deletions(-)

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index 6ea19c2..dac4edb 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -43,7 +43,7 @@ void signal_fault(struct pt_regs *regs, void __user
*frame, char *where);
 int copy_siginfo_to_user32(compat_siginfo_t __user *to, siginfo_t *from)
 {
        int err;
-       if (!access_ok (VERIFY_WRITE, to, sizeof(compat_siginfo_t)))
+       if (!access_ok(VERIFY_WRITE, to, sizeof(compat_siginfo_t)))
                return -EFAULT;

        /* If you change siginfo_t structure, please make sure that
@@ -53,15 +53,15 @@ int copy_siginfo_to_user32(compat_siginfo_t __user
*to, siginfo_t *from)
           3 ints plus the relevant union member.  */
        err = __put_user(from->si_signo, &to->si_signo);
        err |= __put_user(from->si_errno, &to->si_errno);
-       err |= __put_user((short)from->si_code, &to->si_code);
+       err |= __put_user((short)from->si_code, &to->si_code);

        if (from->si_code < 0) {
                err |= __put_user(from->si_pid, &to->si_pid);
-               err |= __put_user(from->si_uid, &to->si_uid);
-               err |= __put_user(ptr_to_compat(from->si_ptr), &to->si_ptr);
+               err |= __put_user(from->si_uid, &to->si_uid);
+               err |= __put_user(ptr_to_compat(from->si_ptr), &to->si_ptr);
        } else {
-               /* First 32bits of unions are always present:
-                * si_pid === si_band === si_tid === si_addr(LS half) */
+               /* First 32bits of unions are always present:
+               * si_pid === si_band === si_tid === si_addr(LS half) */
                err |= __put_user(from->_sifields._pad[0],
&to->_sifields._pad[0]);
                switch (from->si_code >> 16) {
                case __SI_FAULT >> 16:
@@ -76,10 +76,10 @@ int copy_siginfo_to_user32(compat_siginfo_t __user
*to, siginfo_t *from)
                        err |= __put_user(from->si_uid, &to->si_uid);
                        break;
                case __SI_POLL >> 16:
-                       err |= __put_user(from->si_fd, &to->si_fd);
+                       err |= __put_user(from->si_fd, &to->si_fd);
                        break;
                case __SI_TIMER >> 16:
-                       err |= __put_user(from->si_overrun, &to->si_overrun);
+                       err |= __put_user(from->si_overrun, &to->si_overrun);
                        err |= __put_user(ptr_to_compat(from->si_ptr),
                                        &to->si_ptr);
                        break;
@@ -97,7 +97,7 @@ int copy_siginfo_from_user32(siginfo_t *to,
compat_siginfo_t __user *from)
 {
        int err;
        u32 ptr32;
-       if (!access_ok (VERIFY_READ, from, sizeof(compat_siginfo_t)))
+       if (!access_ok(VERIFY_READ, from, sizeof(compat_siginfo_t)))
                return -EFAULT;

        err = __get_user(to->si_signo, &from->si_signo);
@@ -130,34 +130,34 @@ sys32_sigsuspend(int history0, int history1,
old_sigset_t mask)

 asmlinkage long
 sys32_sigaltstack(const stack_ia32_t __user *uss_ptr,
-                 stack_ia32_t __user *uoss_ptr,
+                 stack_ia32_t __user *uoss_ptr,
                  struct pt_regs *regs)
 {
-       stack_t uss,uoss;
+       stack_t uss, uoss;
        int ret;
-       mm_segment_t seg;
-       if (uss_ptr) {
+       mm_segment_t seg;
+       if (uss_ptr) {
                u32 ptr;
-               memset(&uss,0,sizeof(stack_t));
-               if (!access_ok(VERIFY_READ,uss_ptr,sizeof(stack_ia32_t)) ||
+               memset(&uss, 0, sizeof(stack_t));
+               if (!access_ok(VERIFY_READ, uss_ptr, sizeof(stack_ia32_t)) ||
                            __get_user(ptr, &uss_ptr->ss_sp) ||
                            __get_user(uss.ss_flags, &uss_ptr->ss_flags) ||
                            __get_user(uss.ss_size, &uss_ptr->ss_size))
                        return -EFAULT;
                uss.ss_sp = compat_ptr(ptr);
        }
-       seg = get_fs();
-       set_fs(KERNEL_DS);
+       seg = get_fs();
+       set_fs(KERNEL_DS);
        ret = do_sigaltstack(uss_ptr ? &uss : NULL, &uoss, regs->rsp);
-       set_fs(seg);
+       set_fs(seg);
        if (ret >= 0 && uoss_ptr)  {
-               if (!access_ok(VERIFY_WRITE,uoss_ptr,sizeof(stack_ia32_t)) ||
+               if (!access_ok(VERIFY_WRITE, uoss_ptr, sizeof(stack_ia32_t)) ||
                    __put_user(ptr_to_compat(uoss.ss_sp), &uoss_ptr->ss_sp) ||
                    __put_user(uoss.ss_flags, &uoss_ptr->ss_flags) ||
                    __put_user(uoss.ss_size, &uoss_ptr->ss_size))
                        ret = -EFAULT;
-       }
-       return ret;
+       }
+       return ret;
 }

 /*
@@ -190,7 +190,7 @@ static int
 ia32_restore_sigcontext(struct pt_regs *regs, struct sigcontext_ia32
__user *sc, unsigned int *peax)
 {
        unsigned int err = 0;
-
+
        /* Always make any pending restarted system calls return -EINTR */
        current_thread_info()->restart_block.fn = do_no_restart_syscall;

@@ -206,36 +206,36 @@ ia32_restore_sigcontext(struct pt_regs *regs,
struct sigcontext_ia32 __user *sc,

 #define RELOAD_SEG(seg,mask)                                           \
        { unsigned int cur;                                             \
-         unsigned short pre;                                           \
-         err |= __get_user(pre, &sc->seg);                             \
-         asm volatile("movl %%" #seg ",%0" : "=r" (cur));              \
-         pre |= mask;                                                  \
-         if (pre != cur) loadsegment(seg,pre); }
+       unsigned short pre;                                             \
+       err |= __get_user(pre, &sc->seg);                               \
+       asm volatile("movl %%" #seg ",%0" : "=r" (cur));                \
+         pre |= mask;
+         if (pre != cur) loadsegment(seg, pre); }

        /* Reload fs and gs if they have changed in the signal handler.
-          This does not handle long fs/gs base changes in the handler, but
-          does not clobber them at least in the normal case. */
-
+          This does not handle long fs/gs base changes in the handler, but
+          does not clobber them at least in the normal case. */
+
        {
-               unsigned gs, oldgs;
+               unsigned gs, oldgs;
                err |= __get_user(gs, &sc->gs);
-               gs |= 3;
+               gs |= 3;
                asm("movl %%gs,%0" : "=r" (oldgs));
                if (gs != oldgs)
-               load_gs_index(gs);
-       }
-       RELOAD_SEG(fs,3);
-       RELOAD_SEG(ds,3);
-       RELOAD_SEG(es,3);
+               load_gs_index(gs);
+       }
+       RELOAD_SEG(fs, 3);
+       RELOAD_SEG(ds, 3);
+       RELOAD_SEG(es, 3);

        COPY(di); COPY(si); COPY(bp); COPY(sp); COPY(bx);
        COPY(dx); COPY(cx); COPY(ip);
-       /* Don't touch extended registers */
-
-       err |= __get_user(regs->cs, &sc->cs);
-       regs->cs |= 3;
-       err |= __get_user(regs->ss, &sc->ss);
-       regs->ss |= 3;
+       /* Don't touch extended registers */
+
+       err |= __get_user(regs->cs, &sc->cs);
+       regs->cs |= 3;
+       err |= __get_user(regs->ss, &sc->ss);
+       regs->ss |= 3;

        {
                unsigned int tmpflags;
@@ -246,7 +246,7 @@ ia32_restore_sigcontext(struct pt_regs *regs,
struct sigcontext_ia32 __user *sc,

        {
                u32 tmp;
-               struct _fpstate_ia32 __user * buf;
+               struct _fpstate_ia32 __user *buf;
                err |= __get_user(tmp, &sc->fpstate);
                buf = compat_ptr(tmp);
                if (buf) {
@@ -262,7 +262,7 @@ ia32_restore_sigcontext(struct pt_regs *regs,
struct sigcontext_ia32 __user *sc,
                }
        }

-       {
+       {
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

@@ -332,9 +332,9 @@ asmlinkage long sys32_rt_sigreturn(struct pt_regs *regs)
        return eax;

 badframe:
-       signal_fault(regs,frame,"32bit rt sigreturn");
+       signal_fault(regs, frame, "32bit rt sigreturn");
        return 0;
-}
+}

 /*
  * Set up a signal frame.
@@ -375,7 +375,7 @@ ia32_setup_sigcontext(struct sigcontext_ia32
__user *sc, struct _fpstate_ia32 __
        tmp = save_i387_ia32(current, fpstate, regs, 0);
        if (tmp < 0)
                err = -EFAULT;
-       else {
+       else {
                clear_used_math();
                stts();
                err |= __put_user(ptr_to_compat(tmp ? fpstate : NULL),
@@ -393,7 +393,7 @@ ia32_setup_sigcontext(struct sigcontext_ia32
__user *sc, struct _fpstate_ia32 __
  * Determine which stack to use..
  */
 static void __user *
-get_sigframe(struct k_sigaction *ka, struct pt_regs * regs, size_t frame_size)
+get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size)
 {
        unsigned long rsp;

@@ -421,7 +421,7 @@ get_sigframe(struct k_sigaction *ka, struct
pt_regs * regs, size_t frame_size)
 }

 int ia32_setup_frame(int sig, struct k_sigaction *ka,
-                    compat_sigset_t *set, struct pt_regs * regs)
+                    compat_sigset_t *set, struct pt_regs *regs)
 {
        struct sigframe __user *frame;
        int err = 0;
@@ -448,32 +448,32 @@ int ia32_setup_frame(int sig, struct k_sigaction *ka,
                goto give_sigsegv;

        /* Return stub is in 32bit vsyscall page */
-       {
+       {
                void __user *restorer;
                if (current->binfmt->hasvdso)
                        restorer = VSYSCALL32_SIGRETURN;
                else
                        restorer = (void *)&frame->retcode;
                if (ka->sa.sa_flags & SA_RESTORER)
-                       restorer = ka->sa.sa_restorer;
+                       restorer = ka->sa.sa_restorer;
                err |= __put_user(ptr_to_compat(restorer), &frame->pretcode);
        }
-       /* These are actually not used anymore, but left because some
+       /* These are actually not used anymore, but left because some
           gdb versions depend on them as a marker. */
-       {
+       {
                /* copy_to_user optimizes that into a single 8 byte store */
-               static const struct {
+               static const struct {
                        u16 poplmovl;
                        u32 val;
-                       u16 int80;
-                       u16 pad;
-               } __attribute__((packed)) code = {
+                       u16 int80;
+                       u16 pad;
+               } __attribute__((packed)) code = {
                        0xb858,          /* popl %eax ; movl $...,%eax */
-                       __NR_ia32_sigreturn,
+                       __NR_ia32_sigreturn,
                        0x80cd,         /* int $0x80 */
                        0,
-               };
-               err |= __copy_to_user(frame->retcode, &code, 8);
+               };
+               err |= __copy_to_user(frame->retcode, &code, 8);
        }
        if (err)
                goto give_sigsegv;
@@ -487,11 +487,11 @@ int ia32_setup_frame(int sig, struct k_sigaction *ka,
        regs->rdx = 0;
        regs->rcx = 0;

-       asm volatile("movl %0,%%ds" :: "r" (__USER32_DS));
-       asm volatile("movl %0,%%es" :: "r" (__USER32_DS));
+       asm volatile("movl %0,%%ds" :: "r" (__USER32_DS));
+       asm volatile("movl %0,%%es" :: "r" (__USER32_DS));

-       regs->cs = __USER32_CS;
-       regs->ss = __USER32_DS;
+       regs->cs = __USER32_CS;
+       regs->ss = __USER32_DS;

        set_fs(USER_DS);
        regs->eflags &= ~TF_MASK;
@@ -510,8 +510,8 @@ give_sigsegv:
        return -EFAULT;
 }

-int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
-                       compat_sigset_t *set, struct pt_regs * regs)
+nt ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
+                       compat_sigset_t *set, struct pt_regs *regs)
 {
        struct rt_sigframe __user *frame;
        int err = 0;
@@ -524,11 +524,11 @@ int ia32_setup_rt_frame(int sig, struct
k_sigaction *ka, siginfo_t *info,
        {
                struct exec_domain *ed = current_thread_info()->exec_domain;
                err |= __put_user((ed
-                          && ed->signal_invmap
-                          && sig < 32
-                          ? ed->signal_invmap[sig]
-                          : sig),
-                         &frame->sig);
+                       && ed->signal_invmap
+                       && sig < 32
+                       ? ed->signal_invmap[sig]
+                       : sig),
+                       &frame->sig);
        }
        err |= __put_user(ptr_to_compat(&frame->info), &frame->pinfo);
        err |= __put_user(ptr_to_compat(&frame->uc), &frame->puc);
@@ -544,38 +544,38 @@ int ia32_setup_rt_frame(int sig, struct
k_sigaction *ka, siginfo_t *info,
                          &frame->uc.uc_stack.ss_flags);
        err |= __put_user(current->sas_ss_size, &frame->uc.uc_stack.ss_size);
        err |= ia32_setup_sigcontext(&frame->uc.uc_mcontext, &frame->fpstate,
-                               regs, set->sig[0]);
+                       regs, set->sig[0]);
        err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
        if (err)
                goto give_sigsegv;

-
-       {
-               void __user *restorer = VSYSCALL32_RTSIGRETURN;
+
+       {
+               void __user *restorer = VSYSCALL32_RTSIGRETURN;
                if (ka->sa.sa_flags & SA_RESTORER)
-                       restorer = ka->sa.sa_restorer;
+                       restorer = ka->sa.sa_restorer;
                err |= __put_user(ptr_to_compat(restorer), &frame->pretcode);
        }

        /* This is movl $,%eax ; int $0x80 */
        /* Not actually used anymore, but left because some gdb versions
-          need it. */
-       {
+          need it. */
+       {
                /* __copy_to_user optimizes that into a single 8 byte store */
-               static const struct {
-                       u8 movl;
-                       u32 val;
-                       u16 int80;
+               static const struct {
+                       u8 movl;
+                       u32 val;
+                       u16 int80;
                        u16 pad;
-                       u8  pad2;
-               } __attribute__((packed)) code = {
+                       u8  pad2;
+               } __attribute__((packed)) code = {
                        0xb8,
                        __NR_ia32_rt_sigreturn,
                        0x80cd,
                        0,
-               };
-               err |= __copy_to_user(frame->retcode, &code, 8);
-       }
+               };
+               err |= __copy_to_user(frame->retcode, &code, 8);
+       }
        if (err)
                goto give_sigsegv;

@@ -593,11 +593,11 @@ int ia32_setup_rt_frame(int sig, struct
k_sigaction *ka, siginfo_t *info,
        regs->rdx = (unsigned long) &frame->info;
        regs->rcx = (unsigned long) &frame->uc;

-       asm volatile("movl %0,%%ds" :: "r" (__USER32_DS));
-       asm volatile("movl %0,%%es" :: "r" (__USER32_DS));
-
-       regs->cs = __USER32_CS;
-       regs->ss = __USER32_DS;
+       asm volatile("movl %0,%%ds" :: "r" (__USER32_DS));
+       asm volatile("movl %0,%%es" :: "r" (__USER32_DS));
+
+       regs->cs = __USER32_CS;
+       regs->ss = __USER32_DS;

        set_fs(USER_DS);
        regs->eflags &= ~TF_MASK;
--
1.5.4.rc2.17.g257f




-- 
Paolo
http://paolo.ciarrocchi.googlepages.com/
