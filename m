Return-Path: <linux-kernel-owner+w=401wt.eu-S1758987AbZDWTk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758987AbZDWTk3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 15:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755473AbZDWTjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 15:39:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46687 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753159AbZDWTjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 15:39:35 -0400
Date: Thu, 23 Apr 2009 21:32:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
Cc: Chris Zankel <chris@zankel.net>, David Howells <dhowells@redhat.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Greg Ungerer <gerg@uclinux.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Helge Deller <deller@gmx.de>, Hirokazu Takata <takata@linux-m32r.org>,
       Jeff Dike <jdike@addtoit.com>, Kyle McMartin <kyle@mcmartin.ca>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Mike Frysinger <vapier.adi@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] ptrace: remove PT_DTRACE from avr32, mn10300, parisc,
	s390, sh, xtensa
Message-ID: <20090423193206.GA14885@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

avr32, mn10300, parisc, s390, sh, xtensa:

they never set PT_DTRACE, but clear it after do_execve().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

 arch/avr32/kernel/process.c       |    2 --
 arch/mn10300/kernel/process.c     |    3 ---
 arch/parisc/hpux/fs.c             |    5 -----
 arch/parisc/kernel/process.c      |    5 -----
 arch/parisc/kernel/sys_parisc32.c |    5 -----
 arch/s390/kernel/compat_linux.c   |    3 ---
 arch/s390/kernel/process.c        |    3 ---
 arch/sh/kernel/process_32.c       |    5 -----
 arch/sh/kernel/process_64.c       |    5 -----
 arch/xtensa/kernel/process.c      |    5 -----
 10 files changed, 41 deletions(-)

--- PTRACE/arch/avr32/kernel/process.c~DT_2_CLEAR	2009-04-06 00:03:35.000000000 +0200
+++ PTRACE/arch/avr32/kernel/process.c	2009-04-22 21:35:25.000000000 +0200
@@ -394,8 +394,6 @@ asmlinkage int sys_execve(char __user *u
 		goto out;
 
 	error = do_execve(filename, uargv, uenvp, regs);
-	if (error == 0)
-		current->ptrace &= ~PT_DTRACE;
 	putname(filename);
 
 out:
--- PTRACE/arch/mn10300/kernel/process.c~DT_2_CLEAR	2009-04-06 00:03:35.000000000 +0200
+++ PTRACE/arch/mn10300/kernel/process.c	2009-04-22 21:38:00.000000000 +0200
@@ -281,9 +281,6 @@ asmlinkage long sys_execve(char __user *
 	error = PTR_ERR(filename);
 	if (!IS_ERR(filename)) {
 		error = do_execve(filename, argv, envp, __frame);
-		if (error == 0)
-			current->ptrace &= ~PT_DTRACE;
-
 		putname(filename);
 	}
 
--- PTRACE/arch/parisc/hpux/fs.c~DT_2_CLEAR	2009-04-06 00:03:35.000000000 +0200
+++ PTRACE/arch/parisc/hpux/fs.c	2009-04-22 21:39:00.000000000 +0200
@@ -44,11 +44,6 @@ int hpux_execve(struct pt_regs *regs)
 	error = do_execve(filename, (char __user * __user *) regs->gr[25],
 		(char __user * __user *) regs->gr[24], regs);
 
-	if (error == 0) {
-		task_lock(current);
-		current->ptrace &= ~PT_DTRACE;
-		task_unlock(current);
-	}
 	putname(filename);
 
 out:
--- PTRACE/arch/parisc/kernel/process.c~DT_2_CLEAR	2009-04-06 00:03:35.000000000 +0200
+++ PTRACE/arch/parisc/kernel/process.c	2009-04-22 21:41:57.000000000 +0200
@@ -349,11 +349,6 @@ asmlinkage int sys_execve(struct pt_regs
 		goto out;
 	error = do_execve(filename, (char __user * __user *) regs->gr[25],
 		(char __user * __user *) regs->gr[24], regs);
-	if (error == 0) {
-		task_lock(current);
-		current->ptrace &= ~PT_DTRACE;
-		task_unlock(current);
-	}
 	putname(filename);
 out:
 
--- PTRACE/arch/parisc/kernel/sys_parisc32.c~DT_2_CLEAR	2009-04-06 00:03:35.000000000 +0200
+++ PTRACE/arch/parisc/kernel/sys_parisc32.c	2009-04-22 21:42:19.000000000 +0200
@@ -77,11 +77,6 @@ asmlinkage int sys32_execve(struct pt_re
 		goto out;
 	error = compat_do_execve(filename, compat_ptr(regs->gr[25]),
 				 compat_ptr(regs->gr[24]), regs);
-	if (error == 0) {
-		task_lock(current);
-		current->ptrace &= ~PT_DTRACE;
-		task_unlock(current);
-	}
 	putname(filename);
 out:
 
--- PTRACE/arch/s390/kernel/compat_linux.c~DT_2_CLEAR	2009-04-22 20:49:07.000000000 +0200
+++ PTRACE/arch/s390/kernel/compat_linux.c	2009-04-22 21:45:01.000000000 +0200
@@ -461,9 +461,6 @@ asmlinkage long sys32_execve(void)
 		result = rc;
 		goto out_putname;
 	}
-	task_lock(current);
-	current->ptrace &= ~PT_DTRACE;
-	task_unlock(current);
 	current->thread.fp_regs.fpc=0;
 	asm volatile("sfpc %0,0" : : "d" (0));
 	result = regs->gprs[2];
--- PTRACE/arch/s390/kernel/process.c~DT_2_CLEAR	2009-04-06 00:03:36.000000000 +0200
+++ PTRACE/arch/s390/kernel/process.c	2009-04-22 21:45:27.000000000 +0200
@@ -265,9 +265,6 @@ SYSCALL_DEFINE0(vfork)
 
 asmlinkage void execve_tail(void)
 {
-	task_lock(current);
-	current->ptrace &= ~PT_DTRACE;
-	task_unlock(current);
 	current->thread.fp_regs.fpc = 0;
 	if (MACHINE_HAS_IEEE)
 		asm volatile("sfpc %0,%0" : : "d" (0));
--- PTRACE/arch/sh/kernel/process_32.c~DT_2_CLEAR	2009-04-06 00:03:36.000000000 +0200
+++ PTRACE/arch/sh/kernel/process_32.c	2009-04-22 21:46:30.000000000 +0200
@@ -366,11 +366,6 @@ asmlinkage int sys_execve(char __user *u
 		goto out;
 
 	error = do_execve(filename, uargv, uenvp, regs);
-	if (error == 0) {
-		task_lock(current);
-		current->ptrace &= ~PT_DTRACE;
-		task_unlock(current);
-	}
 	putname(filename);
 out:
 	return error;
--- PTRACE/arch/sh/kernel/process_64.c~DT_2_CLEAR	2009-04-06 00:03:36.000000000 +0200
+++ PTRACE/arch/sh/kernel/process_64.c	2009-04-22 21:46:52.000000000 +0200
@@ -529,11 +529,6 @@ asmlinkage int sys_execve(char *ufilenam
 			  (char __user * __user *)uargv,
 			  (char __user * __user *)uenvp,
 			  pregs);
-	if (error == 0) {
-		task_lock(current);
-		current->ptrace &= ~PT_DTRACE;
-		task_unlock(current);
-	}
 	putname(filename);
 out:
 	return error;
--- PTRACE/arch/xtensa/kernel/process.c~DT_2_CLEAR	2009-04-06 00:03:37.000000000 +0200
+++ PTRACE/arch/xtensa/kernel/process.c	2009-04-22 21:48:13.000000000 +0200
@@ -331,11 +331,6 @@ long xtensa_execve(char __user *name, ch
 	if (IS_ERR(filename))
 		goto out;
 	error = do_execve(filename, argv, envp, regs);
-	if (error == 0) {
-		task_lock(current);
-		current->ptrace &= ~PT_DTRACE;
-		task_unlock(current);
-	}
 	putname(filename);
 out:
 	return error;

