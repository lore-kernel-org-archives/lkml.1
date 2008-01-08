Return-Path: <linux-kernel-owner+w=401wt.eu-S1756504AbYAHTcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504AbYAHTcn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 14:32:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755934AbYAHTcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 14:32:25 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:50843 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755890AbYAHTcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 14:32:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=q7PlD8DeXk3I8MhZvfn3FBc3eR6uaL1Q20C+tcoV//o58qZfDzJMs1ard7oXOLAhO90fgQ/kllMs+TQvqQOP3iYOOjzPk/3/zGkLC2NbcEDgTQ9m4Rl0i731dM+MSffAei1A3JiyWSlh3mH3jkY0Lwm+8vSAwJ8ucOMHlIogrRk=
Date: Tue, 8 Jan 2008 20:32:33 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, trivial@kernel.org
Subject: [PATCH 3/5] x86: coding style fixes in arch/x86/ia32/ia32_aout.c
Message-ID: <20080108203233.01bb5c7f@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix plenty of coding style errors

Checkpatch now reports:
total: 2 errors, 18 warnings, 526 lines checked

Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/ia32/ia32_aout.c |  100 ++++++++++++++++++++++-----------------------
 1 files changed, 49 insertions(+), 51 deletions(-)

diff --git a/arch/x86/ia32/ia32_aout.c b/arch/x86/ia32/ia32_aout.c
index f82e1a9..65dc50a 100644
--- a/arch/x86/ia32/ia32_aout.c
+++ b/arch/x86/ia32/ia32_aout.c
@@ -36,8 +36,8 @@
 #undef WARN_OLD
 #undef CORE_DUMP /* probably broken */
 
-static int load_aout_binary(struct linux_binprm *, struct pt_regs * regs);
-static int load_aout_library(struct file*);
+static int load_aout_binary(struct linux_binprm *, struct pt_regs *regs);
+static int load_aout_library(struct file *);
 
 #ifdef CORE_DUMP
 static int aout_core_dump(long signr, struct pt_regs *regs, struct file *file, unsigned long limit);
@@ -45,9 +45,9 @@ static int aout_core_dump(long signr, struct pt_regs *regs, struct file *file, u
 /*
  * fill in the user structure for a core dump..
  */
-static void dump_thread32(struct pt_regs * regs, struct user32 * dump)
+static void dump_thread32(struct pt_regs *regs, struct user32 *dump)
 {
-	u32 fs,gs;
+	u32 fs, gs;
 
 /* changed the size calculations - should hopefully work better. lbt */
 	dump->magic = CMAGIC;
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
@@ -90,7 +90,7 @@ static void dump_thread32(struct pt_regs * regs, struct user32 * dump)
 #if 1 /* FIXME */
 	dump->u_fpvalid = 0;
 #else
-	dump->u_fpvalid = dump_fpu (regs, &dump->i387);
+	dump->u_fpvalid = dump_fpu(regs, &dump->i387);
 #endif
 }
 
@@ -134,8 +134,8 @@ static int dump_write(struct file *file, const void *addr, int nr)
 
 #define DUMP_SEEK(offset) \
 if (file->f_op->llseek) { \
-	if (file->f_op->llseek(file,(offset),0) != (offset)) \
- 		goto end_coredump; \
+	if (file->f_op->llseek(file, (offset), 0) != (offset)) \
+		goto end_coredump; \
 } else file->f_pos = (offset)
 
 /*
@@ -161,7 +161,7 @@ static int aout_core_dump(long signr, struct pt_regs *regs, struct file *file, u
 	set_fs(KERNEL_DS);
 	has_dumped = 1;
 	current->flags |= PF_DUMPCORE;
-       	strncpy(dump.u_comm, current->comm, sizeof(current->comm));
+	strncpy(dump.u_comm, current->comm, sizeof(current->comm));
 	dump.u_ar0 = (u32)(((unsigned long)(&dump.regs)) - ((unsigned long)(&dump)));
 	dump.signal = signr;
 	dump_thread32(regs, &dump);
@@ -184,7 +184,7 @@ static int aout_core_dump(long signr, struct pt_regs *regs, struct file *file, u
 
 	set_fs(KERNEL_DS);
 /* struct user */
-	DUMP_WRITE(&dump,sizeof(dump));
+	DUMP_WRITE(&dump, sizeof(dump));
 /* Now dump all of the user data.  Include malloced stuff as well */
 	DUMP_SEEK(PAGE_SIZE);
 /* now we start writing out the user space info */
@@ -193,17 +193,17 @@ static int aout_core_dump(long signr, struct pt_regs *regs, struct file *file, u
 	if (dump.u_dsize != 0) {
 		dump_start = START_DATA(dump);
 		dump_size = dump.u_dsize << PAGE_SHIFT;
-		DUMP_WRITE(dump_start,dump_size);
+		DUMP_WRITE(dump_start, dump_size);
 	}
 /* Now prepare to dump the stack area */
 	if (dump.u_ssize != 0) {
 		dump_start = START_STACK(dump);
 		dump_size = dump.u_ssize << PAGE_SHIFT;
-		DUMP_WRITE(dump_start,dump_size);
+		DUMP_WRITE(dump_start, dump_size);
 	}
 /* Finally dump the task struct.  Not be used by gdb, but could be useful */
 	set_fs(KERNEL_DS);
-	DUMP_WRITE(current,sizeof(*current));
+	DUMP_WRITE(current, sizeof(*current));
 end_coredump:
 	set_fs(fs);
 	return has_dumped;
@@ -228,24 +228,24 @@ static u32 __user *create_aout_tables(char __user *p, struct linux_binprm *bprm)
 	envp = sp;
 	sp -= argc+1;
 	argv = sp;
-	put_user((unsigned long) envp,--sp);
-	put_user((unsigned long) argv,--sp);
-	put_user(argc,--sp);
+	put_user((unsigned long) envp, --sp);
+	put_user((unsigned long) argv, --sp);
+	put_user(argc, --sp);
 	current->mm->arg_start = (unsigned long) p;
-	while (argc-->0) {
+	while (argc-- > 0) {
 		char c;
-		put_user((u32)(unsigned long)p,argv++);
+		put_user((u32)(unsigned long)p, argv++);
 		do {
-			get_user(c,p++);
+			get_user(c, p++);
 		} while (c);
 	}
 	put_user(0, argv);
 	current->mm->arg_end = current->mm->env_start = (unsigned long) p;
-	while (envc-->0) {
+	while (envc-- > 0) {
 		char c;
-		put_user((u32)(unsigned long)p,envp++);
+		put_user((u32)(unsigned long)p, envp++);
 		do {
-			get_user(c,p++);
+			get_user(c, p++);
 		} while (c);
 	}
 	put_user(0, envp);
@@ -258,7 +258,7 @@ static u32 __user *create_aout_tables(char __user *p, struct linux_binprm *bprm)
  * libraries.  There is no binary dependent code anywhere else.
  */
 
-static int load_aout_binary(struct linux_binprm * bprm, struct pt_regs * regs)
+static int load_aout_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 {
 	struct exec ex;
 	unsigned long error;
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
@@ -311,7 +311,7 @@ static int load_aout_binary(struct linux_binprm * bprm, struct pt_regs * regs)
 
 	current->mm->mmap = NULL;
 	compute_creds(bprm);
- 	current->flags &= ~PF_FORKNOEXEC;
+	current->flags &= ~PF_FORKNOEXEC;
 
 	if (N_MAGIC(ex) == OMAGIC) {
 		unsigned long text_addr, map_size;
@@ -338,29 +338,27 @@ static int load_aout_binary(struct linux_binprm * bprm, struct pt_regs * regs)
 			send_sig(SIGKILL, current, 0);
 			return error;
 		}
-			 
+
 		flush_icache_range(text_addr, text_addr+ex.a_text+ex.a_data);
 	} else {
 #ifdef WARN_OLD
 		static unsigned long error_time, error_time2;
 		if ((ex.a_text & 0xfff || ex.a_data & 0xfff) &&
-		    (N_MAGIC(ex) != NMAGIC) && (jiffies-error_time2) > 5*HZ)
-		{
+		    (N_MAGIC(ex) != NMAGIC) && (jiffies-error_time2) > 5*HZ) {
 			printk(KERN_NOTICE "executable not page aligned\n");
 			error_time2 = jiffies;
 		}
 
 		if ((fd_offset & ~PAGE_MASK) != 0 &&
-		    (jiffies-error_time) > 5*HZ)
-		{
-			printk(KERN_WARNING 
+		    (jiffies-error_time) > 5*HZ) {
+			printk(KERN_WARNING
 			       "fd_offset is not page aligned. Please convert program: %s\n",
 			       bprm->file->f_path.dentry->d_name.name);
 			error_time = jiffies;
 		}
 #endif
 
-		if (!bprm->file->f_op->mmap||((fd_offset & ~PAGE_MASK) != 0)) {
+		if (!bprm->file->f_op->mmap || ((fd_offset & ~PAGE_MASK) != 0)) {
 			loff_t pos = fd_offset;
 			down_write(&current->mm->mmap_sem);
 			do_brk(N_TXTADDR(ex), ex.a_text+ex.a_data);
@@ -387,7 +385,7 @@ static int load_aout_binary(struct linux_binprm * bprm, struct pt_regs * regs)
 		}
 
 		down_write(&current->mm->mmap_sem);
- 		error = do_mmap(bprm->file, N_DATADDR(ex), ex.a_data,
+		error = do_mmap(bprm->file, N_DATADDR(ex), ex.a_data,
 				PROT_READ | PROT_WRITE | PROT_EXEC,
 				MAP_FIXED | MAP_PRIVATE | MAP_DENYWRITE | MAP_EXECUTABLE | MAP_32BIT,
 				fd_offset + ex.a_text);
@@ -403,9 +401,9 @@ beyond_if:
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
 
@@ -414,7 +412,7 @@ beyond_if:
 	/* start thread */
 	asm volatile("movl %0,%%fs" :: "r" (0)); \
 	asm volatile("movl %0,%%es; movl %0,%%ds": :"r" (__USER32_DS));
-	load_gs_index(0); 
+	load_gs_index(0);
 	(regs)->rip = ex.a_entry;
 	(regs)->rsp = current->mm->start_stack;
 	(regs)->eflags = 0x200;
@@ -434,7 +432,7 @@ beyond_if:
 
 static int load_aout_library(struct file *file)
 {
-	struct inode * inode;
+	struct inode *inode;
 	unsigned long bss, start_addr, len;
 	unsigned long error;
 	int retval;
@@ -467,9 +465,9 @@ static int load_aout_library(struct file *file)
 
 #ifdef WARN_OLD
 		static unsigned long error_time;
-		if ((jiffies-error_time) > 5*HZ)
-		{
-			printk(KERN_WARNING 
+		if ((jiffies-error_time) > 5*HZ) {
+
+			printk(KERN_WARNING
 			       "N_TXTOFF is not page aligned. Please convert library: %s\n",
 			       file->f_path.dentry->d_name.name);
 			error_time = jiffies;
@@ -478,7 +476,7 @@ static int load_aout_library(struct file *file)
 		down_write(&current->mm->mmap_sem);
 		do_brk(start_addr, ex.a_text + ex.a_data + ex.a_bss);
 		up_write(&current->mm->mmap_sem);
-		
+
 		file->f_op->read(file, (char __user *)start_addr,
 			ex.a_text + ex.a_data, &pos);
 		flush_icache_range((unsigned long) start_addr,
-- 
1.5.4.rc2.17.g257f

