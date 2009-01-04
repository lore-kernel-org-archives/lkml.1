Return-Path: <linux-kernel-owner+w=401wt.eu-S1756929AbZADKvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929AbZADKvT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 05:51:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751225AbZADKvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 05:51:10 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:39139 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbZADKvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 05:51:09 -0500
Subject: [PATCH -tip] x86: process_32.c fix style problems
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 04 Jan 2009 16:18:56 +0530
Message-Id: <1231066136.27852.5.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, fix style problems, more readable

Fixes style problems:
WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>
WARNING: Use #include <linux/io.h> instead of <asm/io.h>
WARNING: Use #include <linux/kdebug.h> instead of <asm/kdebug.h>
WARNING: Use #include <linux/smp.h> instead of <asm/smp.h>
ERROR: "foo * bar" should be "foo *bar"
ERROR: trailing whitespace
ERROR: spaces required around that ':' (ctx:WxO)
ERROR: spaces required around that ':' (ctx:OxW)

total: 7 errors, 4 warnings

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/process_32.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 3ba155d..a546f55 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -39,11 +39,12 @@
 #include <linux/prctl.h>
 #include <linux/dmi.h>
 #include <linux/ftrace.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
+#include <linux/kdebug.h>
 
-#include <asm/uaccess.h>
 #include <asm/pgtable.h>
 #include <asm/system.h>
-#include <asm/io.h>
 #include <asm/ldt.h>
 #include <asm/processor.h>
 #include <asm/i387.h>
@@ -56,10 +57,8 @@
 
 #include <asm/tlbflush.h>
 #include <asm/cpu.h>
-#include <asm/kdebug.h>
 #include <asm/idle.h>
 #include <asm/syscalls.h>
-#include <asm/smp.h>
 #include <asm/ds.h>
 
 asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
@@ -205,7 +204,7 @@ extern void kernel_thread_helper(void);
 /*
  * Create a kernel thread
  */
-int kernel_thread(int (*fn)(void *), void * arg, unsigned long flags)
+int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags)
 {
 	struct pt_regs regs;
 
@@ -266,7 +265,7 @@ void flush_thread(void)
 	tsk->thread.debugreg3 = 0;
 	tsk->thread.debugreg6 = 0;
 	tsk->thread.debugreg7 = 0;
-	memset(tsk->thread.tls_array, 0, sizeof(tsk->thread.tls_array));	
+	memset(tsk->thread.tls_array, 0, sizeof(tsk->thread.tls_array));
 	clear_tsk_thread_flag(tsk, TIF_DEBUG);
 	/*
 	 * Forget coprocessor state..
@@ -293,9 +292,9 @@ void prepare_to_copy(struct task_struct *tsk)
 
 int copy_thread(int nr, unsigned long clone_flags, unsigned long sp,
 	unsigned long unused,
-	struct task_struct * p, struct pt_regs * regs)
+	struct task_struct *p, struct pt_regs *regs)
 {
-	struct pt_regs * childregs;
+	struct pt_regs *childregs;
 	struct task_struct *tsk;
 	int err;
 
@@ -347,7 +346,7 @@ int copy_thread(int nr, unsigned long clone_flags, unsigned long sp,
 void
 start_thread(struct pt_regs *regs, unsigned long new_ip, unsigned long new_sp)
 {
-	__asm__("movl %0, %%gs" :: "r"(0));
+	__asm__("movl %0, %%gs" : : "r"(0));
 	regs->fs		= 0;
 	set_fs(USER_DS);
 	regs->ds		= __USER_DS;
@@ -638,7 +637,7 @@ asmlinkage int sys_vfork(struct pt_regs regs)
 asmlinkage int sys_execve(struct pt_regs regs)
 {
 	int error;
-	char * filename;
+	char *filename;
 
 	filename = getname((char __user *) regs.bx);
 	error = PTR_ERR(filename);
-- 
1.5.5.1



