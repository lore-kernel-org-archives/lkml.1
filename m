Return-Path: <linux-kernel-owner+w=401wt.eu-S1757560AbYAGLmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560AbYAGLmt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 06:42:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754593AbYAGLmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 06:42:42 -0500
Received: from po-out-1718.google.com ([72.14.252.152]:39351 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151AbYAGLml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 06:42:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Z+pPvsVFFjdxqTqHC+0dwso5BQ6Zviky9ML6jNLkhBQMYWIzW3EM7CLyqc4TPVHNUlY08HYbIZotd8fQ0POwyIhhpuIPp1PQwwWLLQ+37AHaAgE9jPyzb/9/N0v0Az35DDwFKAag6r+/IUw0iLgdcEfYhiSSUzXYNCV7sX+cR4E=
Message-ID: <4d8e3fd30801070342k7c3c4ab9qce338996db3c6cea@mail.gmail.com>
Date: Mon, 7 Jan 2008 12:42:39 +0100
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: mingo@redhat.com, hpa@zytor.com, trivial@kernel.org
Subject: [PATCH] Simple coding style fixes, take 2
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <20080107000921.59e07a29@paolo-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080106123913.4564b24c@paolo-desktop>
	 <20080107000921.59e07a29@paolo-desktop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Second version, including fixes according to comments
got from Adrian Bunk.

Trivial changes to fix some coding style errors.

Checkpatch now reports:
total: 0 errors, 7 warnings, 409 lines checked

Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/ia32/ptrace32.c |  155 ++++++++++++++++++++++++----------------------
 1 files changed, 80 insertions(+), 75 deletions(-)

diff --git a/arch/x86/ia32/ptrace32.c b/arch/x86/ia32/ptrace32.c
index 4a233ad..d55cd78 100644
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
- * This allows to access 64bit processes too; but there is no way to
see the extended
- * register contents.
- */
+ *
+ * This allows to access 64bit processes too; but there is no way to see
+ * the extended register contents.
+ */

 #include <linux/kernel.h>
 #include <linux/stddef.h>
@@ -45,30 +45,35 @@ static int putreg32(struct task_struct *child,
unsigned regno, u32 val)

        switch (regno) {
        case offsetof(struct user32, regs.fs):
-               if (val && (val & 3) != 3) return -EIO;
+               if (val && (val & 3) != 3)
+                       return -EIO;
                child->thread.fsindex = val & 0xffff;
                break;
        case offsetof(struct user32, regs.gs):
-               if (val && (val & 3) != 3) return -EIO;
+               if (val && (val & 3) != 3)
+                       return -EIO;
                child->thread.gsindex = val & 0xffff;
                break;
        case offsetof(struct user32, regs.ds):
-               if (val && (val & 3) != 3) return -EIO;
+               if (val && (val & 3) != 3)
+                       return -EIO;
                child->thread.ds = val & 0xffff;
                break;
        case offsetof(struct user32, regs.es):
                child->thread.es = val & 0xffff;
                break;
-       case offsetof(struct user32, regs.ss):
-               if ((val & 3) != 3) return -EIO;
-               stack[offsetof(struct pt_regs, ss)/8] = val & 0xffff;
+       case offsetof(struct user32, regs.ss):
+               if ((val & 3) != 3)
+                       return -EIO;
+               stack[offsetof(struct pt_regs, ss)/8] = val & 0xffff;
                break;
-       case offsetof(struct user32, regs.cs):
-               if ((val & 3) != 3) return -EIO;
+       case offsetof(struct user32, regs.cs):
+               if ((val & 3) != 3)
+                       return -EIO;
                stack[offsetof(struct pt_regs, cs)/8] = val & 0xffff;
                break;

-       R32(ebx, rbx);
+       R32(ebx, rbx);
        R32(ecx, rcx);
        R32(edx, rdx);
        R32(edi, rdi);
@@ -86,7 +91,7 @@ static int putreg32(struct task_struct *child,
unsigned regno, u32 val)
                break;
        }

-       case offsetof(struct user32, u_debugreg[4]):
+       case offsetof(struct user32, u_debugreg[4]):
        case offsetof(struct user32, u_debugreg[5]):
                return -EIO;

@@ -108,28 +113,28 @@ static int putreg32(struct task_struct *child,
unsigned regno, u32 val)

        case offsetof(struct user32, u_debugreg[6]):
                child->thread.debugreg6 = val;
-               break;
+               break;

        case offsetof(struct user32, u_debugreg[7]):
                val &= ~DR_CONTROL_RESERVED;
                /* See arch/i386/kernel/ptrace.c for an explanation of
                 * this awkward check.*/
-               for(i=0; i<4; i++)
+               for (i = 0; i < 4; i++)
                        if ((0x5454 >> ((val >> (16 + 4*i)) & 0xf)) & 1)
                               return -EIO;
-               child->thread.debugreg7 = val;
+               child->thread.debugreg7 = val;
                if (val)
                        set_tsk_thread_flag(child, TIF_DEBUG);
                else
                        clear_tsk_thread_flag(child, TIF_DEBUG);
-               break;
-
+               break;
+
        default:
                if (regno > sizeof(struct user32) || (regno & 3))
                        return -EIO;
-
-               /* Other dummy fields in the virtual user structure
are ignored */
-               break;
+
+               /* Other dummy fields in the virtual user structure
are ignored */
+               break;
        }
        return 0;
 }
@@ -145,7 +150,7 @@ static int getreg32(struct task_struct *child,
unsigned regno, u32 *val)

        switch (regno) {
        case offsetof(struct user32, regs.fs):
-               *val = child->thread.fsindex;
+               *val = child->thread.fsindex;
                break;
        case offsetof(struct user32, regs.gs):
                *val = child->thread.gsindex;
@@ -159,7 +164,7 @@ static int getreg32(struct task_struct *child,
unsigned regno, u32 *val)

        R32(cs, cs);
        R32(ss, ss);
-       R32(ebx, rbx);
+       R32(ebx, rbx);
        R32(ecx, rcx);
        R32(edx, rdx);
        R32(edi, rdi);
@@ -171,32 +176,32 @@ static int getreg32(struct task_struct *child,
unsigned regno, u32 *val)
        R32(eflags, eflags);
        R32(esp, rsp);

-       case offsetof(struct user32, u_debugreg[0]):
-               *val = child->thread.debugreg0;
-               break;
-       case offsetof(struct user32, u_debugreg[1]):
-               *val = child->thread.debugreg1;
-               break;
-       case offsetof(struct user32, u_debugreg[2]):
-               *val = child->thread.debugreg2;
-               break;
-       case offsetof(struct user32, u_debugreg[3]):
-               *val = child->thread.debugreg3;
-               break;
-       case offsetof(struct user32, u_debugreg[6]):
-               *val = child->thread.debugreg6;
-               break;
-       case offsetof(struct user32, u_debugreg[7]):
-               *val = child->thread.debugreg7;
-               break;
-
+       case offsetof(struct user32, u_debugreg[0]):
+               *val = child->thread.debugreg0;
+               break;
+       case offsetof(struct user32, u_debugreg[1]):
+               *val = child->thread.debugreg1;
+               break;
+       case offsetof(struct user32, u_debugreg[2]):
+               *val = child->thread.debugreg2;
+               break;
+       case offsetof(struct user32, u_debugreg[3]):
+               *val = child->thread.debugreg3;
+               break;
+       case offsetof(struct user32, u_debugreg[6]):
+               *val = child->thread.debugreg6;
+               break;
+       case offsetof(struct user32, u_debugreg[7]):
+               *val = child->thread.debugreg7;
+               break;
+
        default:
                if (regno > sizeof(struct user32) || (regno & 3))
                        return -EIO;

-               /* Other dummy fields in the virtual user structure
are ignored */
+               /* Other dummy fields in the virtual user structure
are ignored */
                *val = 0;
-               break;
+               break;
        }
        return 0;
 }
@@ -207,7 +212,7 @@ static long ptrace32_siginfo(unsigned request, u32
pid, u32 addr, u32 data)
 {
        int ret;
        compat_siginfo_t __user *si32 = compat_ptr(data);
-       siginfo_t ssi;
+       siginfo_t ssi;
        siginfo_t __user *si = compat_alloc_user_space(sizeof(siginfo_t));
        if (request == PTRACE_SETSIGINFO) {
                memset(&ssi, 0, sizeof(siginfo_t));
@@ -231,12 +236,12 @@ static long ptrace32_siginfo(unsigned request,
u32 pid, u32 addr, u32 data)
 asmlinkage long sys32_ptrace(long request, u32 pid, u32 addr, u32 data)
 {
        struct task_struct *child;
-       struct pt_regs *childregs;
+       struct pt_regs *childregs;
        void __user *datap = compat_ptr(data);
        int ret;
        __u32 val;

-       switch (request) {
+       switch (request) {
        case PTRACE_TRACEME:
        case PTRACE_ATTACH:
        case PTRACE_KILL:
@@ -248,7 +253,7 @@ asmlinkage long sys32_ptrace(long request, u32
pid, u32 addr, u32 data)
        case PTRACE_SETOPTIONS:
        case PTRACE_SET_THREAD_AREA:
        case PTRACE_GET_THREAD_AREA:
-               return sys_ptrace(request, pid, addr, data);
+               return sys_ptrace(request, pid, addr, data);

        default:
                return -EINVAL;
@@ -257,7 +262,7 @@ asmlinkage long sys32_ptrace(long request, u32
pid, u32 addr, u32 data)
        case PTRACE_PEEKDATA:
        case PTRACE_POKEDATA:
        case PTRACE_POKETEXT:
-       case PTRACE_POKEUSR:
+       case PTRACE_POKEUSR:
        case PTRACE_PEEKUSR:
        case PTRACE_GETREGS:
        case PTRACE_SETREGS:
@@ -287,17 +292,17 @@ asmlinkage long sys32_ptrace(long request, u32
pid, u32 addr, u32 data)
        case PTRACE_PEEKDATA:
        case PTRACE_PEEKTEXT:
                ret = 0;
-               if (access_process_vm(child, addr, &val, sizeof(u32),
0)!=sizeof(u32))
+               if (access_process_vm(child, addr, &val, sizeof(u32),
0) != sizeof(u32))
                        ret = -EIO;
                else
-                       ret = put_user(val, (unsigned int __user *)datap);
-               break;
+                       ret = put_user(val, (unsigned int __user *)datap);
+               break;

        case PTRACE_POKEDATA:
        case PTRACE_POKETEXT:
                ret = 0;
-               if (access_process_vm(child, addr, &data, sizeof(u32),
1)!=sizeof(u32))
-                       ret = -EIO;
+               if (access_process_vm(child, addr, &data, sizeof(u32),
1) != sizeof(u32))
+                       ret = -EIO;
                break;

        case PTRACE_PEEKUSR:
@@ -312,14 +317,14 @@ asmlinkage long sys32_ptrace(long request, u32
pid, u32 addr, u32 data)

        case PTRACE_GETREGS: { /* Get all gp regs from the child. */
                int i;
-               if (!access_ok(VERIFY_WRITE, datap, 16*4)) {
+               if (!access_ok(VERIFY_WRITE, datap, 16*4)) {
                        ret = -EIO;
                        break;
                }
                ret = 0;
-               for ( i = 0; i <= 16*4 ; i += sizeof(__u32) ) {
+               for (i = 0; i <= 16*4 ; i += sizeof(__u32)) {
                        getreg32(child, i, &val);
-                       ret |= __put_user(val,(u32 __user *)datap);
+                       ret |= __put_user(val, (u32 __user *)datap);
                        datap += sizeof(u32);
                }
                break;
@@ -328,12 +333,12 @@ asmlinkage long sys32_ptrace(long request, u32
pid, u32 addr, u32 data)
        case PTRACE_SETREGS: { /* Set all gp regs in the child. */
                unsigned long tmp;
                int i;
-               if (!access_ok(VERIFY_READ, datap, 16*4)) {
+               if (!access_ok(VERIFY_READ, datap, 16*4)) {
                        ret = -EIO;
                        break;
                }
-               ret = 0;
-               for ( i = 0; i <= 16*4; i += sizeof(u32) ) {
+               ret = 0;
+               for (i = 0; i <= 16*4; i += sizeof(u32)) {
                        ret |= __get_user(tmp, (u32 __user *)datap);
                        putreg32(child, i, tmp);
                        datap += sizeof(u32);
@@ -342,17 +347,17 @@ asmlinkage long sys32_ptrace(long request, u32
pid, u32 addr, u32 data)
        }

        case PTRACE_GETFPREGS:
-               ret = -EIO;
-               if (!access_ok(VERIFY_READ, compat_ptr(data),
+               ret = -EIO;
+               if (!access_ok(VERIFY_READ, compat_ptr(data),
                               sizeof(struct user_i387_struct)))
                        break;
                save_i387_ia32(child, datap, childregs, 1);
-               ret = 0;
+               ret = 0;
                        break;

        case PTRACE_SETFPREGS:
                ret = -EIO;
-               if (!access_ok(VERIFY_WRITE, datap,
+               if (!access_ok(VERIFY_WRITE, datap,
                               sizeof(struct user_i387_struct)))
                        break;
                ret = 0;
@@ -360,9 +365,9 @@ asmlinkage long sys32_ptrace(long request, u32
pid, u32 addr, u32 data)
                restore_i387_ia32(child, datap, 1);
                break;

-       case PTRACE_GETFPXREGS: {
+       case PTRACE_GETFPXREGS: {
                struct user32_fxsr_struct __user *u = datap;
-               init_fpu(child);
+               init_fpu(child);
                ret = -EIO;
                if (!access_ok(VERIFY_WRITE, u, sizeof(*u)))
                        break;
@@ -370,10 +375,10 @@ asmlinkage long sys32_ptrace(long request, u32
pid, u32 addr, u32 data)
                if (__copy_to_user(u, &child->thread.i387.fxsave, sizeof(*u)))
                        break;
                ret = __put_user(childregs->cs, &u->fcs);
-               ret |= __put_user(child->thread.ds, &u->fos);
-               break;
-       }
-       case PTRACE_SETFPXREGS: {
+               ret |= __put_user(child->thread.ds, &u->fos);
+               break;
+       }
+       case PTRACE_SETFPXREGS: {
                struct user32_fxsr_struct __user *u = datap;
                unlazy_fpu(child);
                ret = -EIO;
@@ -385,12 +390,12 @@ asmlinkage long sys32_ptrace(long request, u32
pid, u32 addr, u32 data)
                        ;
                set_stopped_child_used_math(child);
                child->thread.i387.fxsave.mxcsr &= mxcsr_feature_mask;
-               ret = 0;
+               ret = 0;
                break;
        }

        case PTRACE_GETEVENTMSG:
-               ret = put_user(child->ptrace_message,(unsigned int
__user *)compat_ptr(data));
+               ret = put_user(child->ptrace_message, (unsigned int
__user *)compat_ptr(data));
                break;

        default:
--
1.5.4.rc2.17.g257f




-- 
Paolo
http://paolo.ciarrocchi.googlepages.com/
