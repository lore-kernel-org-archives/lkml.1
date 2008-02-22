Return-Path: <linux-kernel-owner+w=401wt.eu-S936375AbYBVWQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936375AbYBVWQt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 17:16:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763294AbYBVWKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 17:10:50 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:28753 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935451AbYBVWKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 17:10:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=s9Wledq7Mj6SDSUnAhdWK1szvE2kFu3cvCXdTs6lOyL1WNVGE5fkOuP5b49VIqYdGjZ9gLUcH800CFbQz2gqofG8dL+JjqM4puE7KgUKRbQFLPGLidfQE2sX+gcy2PBO6jpdZR7YPqyvB58lH6/xDgTP6hEzusVMK+0DVKiSel4=
Date: Fri, 22 Feb 2008 23:10:40 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: hpa <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       tglx <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 11/20] x86: Coding Style fixes to arch/x86/kernel/vm86_32.c
Message-ID: <20080222231040.23e3ca9a@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix plenty of errors and warnings.
Compile tested.


Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/kernel/vm86_32.c |  174 +++++++++++++++++++++++----------------------
 1 files changed, 89 insertions(+), 85 deletions(-)

diff --git a/arch/x86/kernel/vm86_32.c b/arch/x86/kernel/vm86_32.c
index 738c210..f5ce9c9 100644
--- a/arch/x86/kernel/vm86_32.c
+++ b/arch/x86/kernel/vm86_32.c
@@ -64,7 +64,7 @@
 
 
 #define KVM86	((struct kernel_vm86_struct *)regs)
-#define VMPI 	KVM86->vm86plus
+#define VMPI	KVM86->vm86plus
 
 
 /*
@@ -81,7 +81,7 @@
 #define VFLAGS	(*(unsigned short *)&(current->thread.v86flags))
 #define VEFLAGS	(current->thread.v86flags)
 
-#define set_flags(X,new,mask) \
+#define set_flags(X, new, mask) \
 ((X) = ((X) & ~(mask)) | ((new) & (mask)))
 
 #define SAFE_MASK	(0xDD5)
@@ -93,8 +93,10 @@ static int copy_vm86_regs_to_user(struct vm86_regs __user *user,
 {
 	int ret = 0;
 
-	/* kernel_vm86_regs is missing gs, so copy everything up to
-	   (but not including) orig_eax, and then rest including orig_eax. */
+	/*
+	 * kernel_vm86_regs is missing gs, so copy everything up to
+	 * (but not including) orig_eax, and then rest including orig_eax.
+	 */
 	ret += copy_to_user(user, regs, offsetof(struct kernel_vm86_regs, pt.orig_ax));
 	ret += copy_to_user(&user->orig_eax, &regs->pt.orig_ax,
 			    sizeof(struct kernel_vm86_regs) -
@@ -120,7 +122,7 @@ static int copy_vm86_regs_from_user(struct kernel_vm86_regs *regs,
 	return ret;
 }
 
-struct pt_regs * save_v86_state(struct kernel_vm86_regs * regs)
+struct pt_regs *save_v86_state(struct kernel_vm86_regs *regs)
 {
 	struct tss_struct *tss;
 	struct pt_regs *ret;
@@ -138,8 +140,8 @@ struct pt_regs * save_v86_state(struct kernel_vm86_regs * regs)
 		do_exit(SIGSEGV);
 	}
 	set_flags(regs->pt.flags, VEFLAGS, VIF_MASK | current->thread.v86mask);
-	tmp = copy_vm86_regs_to_user(&current->thread.vm86_info->regs,regs);
-	tmp += put_user(current->thread.screen_bitmap,&current->thread.vm86_info->screen_bitmap);
+	tmp = copy_vm86_regs_to_user(&current->thread.vm86_info->regs, regs);
+	tmp += put_user(current->thread.screen_bitmap, &current->thread.vm86_info->screen_bitmap);
 	if (tmp) {
 		printk("vm86: could not access userspace vm86_info\n");
 		do_exit(SIGSEGV);
@@ -237,20 +239,21 @@ asmlinkage int sys_vm86(struct pt_regs regs)
 
 	tsk = current;
 	switch (regs.bx) {
-		case VM86_REQUEST_IRQ:
-		case VM86_FREE_IRQ:
-		case VM86_GET_IRQ_BITS:
-		case VM86_GET_AND_RESET_IRQ:
-			ret = do_vm86_irq_handling(regs.bx, (int)regs.cx);
-			goto out;
-		case VM86_PLUS_INSTALL_CHECK:
-			/* NOTE: on old vm86 stuff this will return the error
-			   from access_ok(), because the subfunction is
-			   interpreted as (invalid) address to vm86_struct.
-			   So the installation check works.
-			 */
-			ret = 0;
-			goto out;
+	case VM86_REQUEST_IRQ:
+	case VM86_FREE_IRQ:
+	case VM86_GET_IRQ_BITS:
+	case VM86_GET_AND_RESET_IRQ:
+		ret = do_vm86_irq_handling(regs.bx, (int)regs.cx);
+		goto out;
+	case VM86_PLUS_INSTALL_CHECK:
+		/*
+		 * NOTE: on old vm86 stuff this will return the error
+		 *  from access_ok(), because the subfunction is
+		 *  interpreted as (invalid) address to vm86_struct.
+		 *  So the installation check works.
+		 */
+		ret = 0;
+		goto out;
 	}
 
 	/* we come here only for functions VM86_ENTER, VM86_ENTER_NO_BYPASS */
@@ -299,18 +302,18 @@ static void do_sys_vm86(struct kernel_vm86_struct *info, struct task_struct *tsk
 	info->regs.pt.flags |= VM_MASK;
 
 	switch (info->cpu_type) {
-		case CPU_286:
-			tsk->thread.v86mask = 0;
-			break;
-		case CPU_386:
-			tsk->thread.v86mask = NT_MASK | IOPL_MASK;
-			break;
-		case CPU_486:
-			tsk->thread.v86mask = AC_MASK | NT_MASK | IOPL_MASK;
-			break;
-		default:
-			tsk->thread.v86mask = ID_MASK | AC_MASK | NT_MASK | IOPL_MASK;
-			break;
+	case CPU_286:
+		tsk->thread.v86mask = 0;
+		break;
+	case CPU_386:
+		tsk->thread.v86mask = NT_MASK | IOPL_MASK;
+		break;
+	case CPU_486:
+		tsk->thread.v86mask = AC_MASK | NT_MASK | IOPL_MASK;
+		break;
+	default:
+		tsk->thread.v86mask = ID_MASK | AC_MASK | NT_MASK | IOPL_MASK;
+		break;
 	}
 
 /*
@@ -346,9 +349,9 @@ static void do_sys_vm86(struct kernel_vm86_struct *info, struct task_struct *tsk
 	/* we never return here */
 }
 
-static inline void return_to_32bit(struct kernel_vm86_regs * regs16, int retval)
+static inline void return_to_32bit(struct kernel_vm86_regs *regs16, int retval)
 {
-	struct pt_regs * regs32;
+	struct pt_regs *regs32;
 
 	regs32 = save_v86_state(regs16);
 	regs32->ax = retval;
@@ -358,29 +361,30 @@ static inline void return_to_32bit(struct kernel_vm86_regs * regs16, int retval)
 		: : "r" (regs32), "r" (current_thread_info()));
 }
 
-static inline void set_IF(struct kernel_vm86_regs * regs)
+static inline void set_IF(struct kernel_vm86_regs *regs)
 {
 	VEFLAGS |= VIF_MASK;
 	if (VEFLAGS & VIP_MASK)
 		return_to_32bit(regs, VM86_STI);
 }
 
-static inline void clear_IF(struct kernel_vm86_regs * regs)
+static inline void clear_IF(struct kernel_vm86_regs *regs)
 {
 	VEFLAGS &= ~VIF_MASK;
 }
 
-static inline void clear_TF(struct kernel_vm86_regs * regs)
+static inline void clear_TF(struct kernel_vm86_regs *regs)
 {
 	regs->pt.flags &= ~TF_MASK;
 }
 
-static inline void clear_AC(struct kernel_vm86_regs * regs)
+static inline void clear_AC(struct kernel_vm86_regs *regs)
 {
 	regs->pt.flags &= ~AC_MASK;
 }
 
-/* It is correct to call set_IF(regs) from the set_vflags_*
+/*
+ * It is correct to call set_IF(regs) from the set_vflags_*
  * functions. However someone forgot to call clear_IF(regs)
  * in the opposite case.
  * After the command sequence CLI PUSHF STI POPF you should
@@ -391,7 +395,7 @@ static inline void clear_AC(struct kernel_vm86_regs * regs)
  * [KD]
  */
 
-static inline void set_vflags_long(unsigned long flags, struct kernel_vm86_regs * regs)
+static inline void set_vflags_long(unsigned long flags, struct kernel_vm86_regs *regs)
 {
 	set_flags(VEFLAGS, flags, current->thread.v86mask);
 	set_flags(regs->pt.flags, flags, SAFE_MASK);
@@ -401,7 +405,7 @@ static inline void set_vflags_long(unsigned long flags, struct kernel_vm86_regs
 		clear_IF(regs);
 }
 
-static inline void set_vflags_short(unsigned short flags, struct kernel_vm86_regs * regs)
+static inline void set_vflags_short(unsigned short flags, struct kernel_vm86_regs *regs)
 {
 	set_flags(VFLAGS, flags, current->thread.v86mask);
 	set_flags(regs->pt.flags, flags, SAFE_MASK);
@@ -411,7 +415,7 @@ static inline void set_vflags_short(unsigned short flags, struct kernel_vm86_reg
 		clear_IF(regs);
 }
 
-static inline unsigned long get_vflags(struct kernel_vm86_regs * regs)
+static inline unsigned long get_vflags(struct kernel_vm86_regs *regs)
 {
 	unsigned long flags = regs->pt.flags & RETURN_MASK;
 
@@ -421,11 +425,11 @@ static inline unsigned long get_vflags(struct kernel_vm86_regs * regs)
 	return flags | (VEFLAGS & current->thread.v86mask);
 }
 
-static inline int is_revectored(int nr, struct revectored_struct * bitmap)
+static inline int is_revectored(int nr, struct revectored_struct *bitmap)
 {
 	__asm__ __volatile__("btl %2,%1\n\tsbbl %0,%0"
 		:"=r" (nr)
-		:"m" (*bitmap),"r" (nr));
+		:"m" (*bitmap), "r" (nr));
 	return nr;
 }
 
@@ -437,7 +441,7 @@ static inline int is_revectored(int nr, struct revectored_struct * bitmap)
 		ptr--; \
 		if (put_user(__val, base + ptr) < 0) \
 			goto err_label; \
-	} while(0)
+	} while (0)
 
 #define pushw(base, ptr, val, err_label) \
 	do { \
@@ -448,7 +452,7 @@ static inline int is_revectored(int nr, struct revectored_struct * bitmap)
 		ptr--; \
 		if (put_user(val_byte(__val, 0), base + ptr) < 0) \
 			goto err_label; \
-	} while(0)
+	} while (0)
 
 #define pushl(base, ptr, val, err_label) \
 	do { \
@@ -465,7 +469,7 @@ static inline int is_revectored(int nr, struct revectored_struct * bitmap)
 		ptr--; \
 		if (put_user(val_byte(__val, 0), base + ptr) < 0) \
 			goto err_label; \
-	} while(0)
+	} while (0)
 
 #define popb(base, ptr, err_label) \
 	({ \
@@ -512,7 +516,7 @@ static inline int is_revectored(int nr, struct revectored_struct * bitmap)
  * in userspace is always better than an Oops anyway.) [KD]
  */
 static void do_int(struct kernel_vm86_regs *regs, int i,
-    unsigned char __user * ssp, unsigned short sp)
+    unsigned char __user *ssp, unsigned short sp)
 {
 	unsigned long __user *intr_ptr;
 	unsigned long segoffs;
@@ -521,7 +525,7 @@ static void do_int(struct kernel_vm86_regs *regs, int i,
 		goto cannot_handle;
 	if (is_revectored(i, &KVM86->int_revectored))
 		goto cannot_handle;
-	if (i==0x21 && is_revectored(AH(regs),&KVM86->int21_revectored))
+	if (i == 0x21 && is_revectored(AH(regs), &KVM86->int21_revectored))
 		goto cannot_handle;
 	intr_ptr = (unsigned long __user *) (i << 2);
 	if (get_user(segoffs, intr_ptr))
@@ -543,15 +547,15 @@ cannot_handle:
 	return_to_32bit(regs, VM86_INTx + (i << 8));
 }
 
-int handle_vm86_trap(struct kernel_vm86_regs * regs, long error_code, int trapno)
+int handle_vm86_trap(struct kernel_vm86_regs *regs, long error_code, int trapno)
 {
 	if (VMPI.is_vm86pus) {
-		if ( (trapno==3) || (trapno==1) )
+		if ((trapno == 3) || (trapno == 1))
 			return_to_32bit(regs, VM86_TRAP + (trapno << 8));
 		do_int(regs, trapno, (unsigned char __user *) (regs->pt.ss << 4), SP(regs));
 		return 0;
 	}
-	if (trapno !=1)
+	if (trapno != 1)
 		return 1; /* we let this handle by the calling routine */
 	if (current->ptrace & PT_PTRACED) {
 		unsigned long flags;
@@ -566,7 +570,7 @@ int handle_vm86_trap(struct kernel_vm86_regs * regs, long error_code, int trapno
 	return 0;
 }
 
-void handle_vm86_fault(struct kernel_vm86_regs * regs, long error_code)
+void handle_vm86_fault(struct kernel_vm86_regs *regs, long error_code)
 {
 	unsigned char opcode;
 	unsigned char __user *csp;
@@ -595,17 +599,17 @@ void handle_vm86_fault(struct kernel_vm86_regs * regs, long error_code)
 	pref_done = 0;
 	do {
 		switch (opcode = popb(csp, ip, simulate_sigsegv)) {
-			case 0x66:      /* 32-bit data */     data32=1; break;
-			case 0x67:      /* 32-bit address */  break;
-			case 0x2e:      /* CS */              break;
-			case 0x3e:      /* DS */              break;
-			case 0x26:      /* ES */              break;
-			case 0x36:      /* SS */              break;
-			case 0x65:      /* GS */              break;
-			case 0x64:      /* FS */              break;
-			case 0xf2:      /* repnz */       break;
-			case 0xf3:      /* rep */             break;
-			default: pref_done = 1;
+		case 0x66:      /* 32-bit data */     data32 = 1; break;
+		case 0x67:      /* 32-bit address */  break;
+		case 0x2e:      /* CS */              break;
+		case 0x3e:      /* DS */              break;
+		case 0x26:      /* ES */              break;
+		case 0x36:      /* SS */              break;
+		case 0x65:      /* GS */              break;
+		case 0x64:      /* FS */              break;
+		case 0xf2:      /* repnz */       break;
+		case 0xf3:      /* rep */             break;
+		default: pref_done = 1;
 		}
 	} while (!pref_done);
 
@@ -628,7 +632,7 @@ void handle_vm86_fault(struct kernel_vm86_regs * regs, long error_code)
 		{
 		unsigned long newflags;
 		if (data32) {
-			newflags=popl(ssp, sp, simulate_sigsegv);
+			newflags = popl(ssp, sp, simulate_sigsegv);
 			SP(regs) += 4;
 		} else {
 			newflags = popw(ssp, sp, simulate_sigsegv);
@@ -636,20 +640,20 @@ void handle_vm86_fault(struct kernel_vm86_regs * regs, long error_code)
 		}
 		IP(regs) = ip;
 		CHECK_IF_IN_TRAP;
-		if (data32) {
+		if (data32)
 			set_vflags_long(newflags, regs);
-		} else {
+		else
 			set_vflags_short(newflags, regs);
-		}
+
 		VM86_FAULT_RETURN;
 		}
 
 	/* int xx */
 	case 0xcd: {
-		int intno=popb(csp, ip, simulate_sigsegv);
+		int intno = popb(csp, ip, simulate_sigsegv);
 		IP(regs) = ip;
 		if (VMPI.vm86dbg_active) {
-			if ( (1 << (intno &7)) & VMPI.vm86dbg_intxxtab[intno >> 3] )
+			if ((1 << (intno &7)) & VMPI.vm86dbg_intxxtab[intno >> 3])
 				return_to_32bit(regs, VM86_INTx + (intno << 8));
 		}
 		do_int(regs, intno, ssp, sp);
@@ -663,9 +667,9 @@ void handle_vm86_fault(struct kernel_vm86_regs * regs, long error_code)
 		unsigned long newcs;
 		unsigned long newflags;
 		if (data32) {
-			newip=popl(ssp, sp, simulate_sigsegv);
-			newcs=popl(ssp, sp, simulate_sigsegv);
-			newflags=popl(ssp, sp, simulate_sigsegv);
+			newip = popl(ssp, sp, simulate_sigsegv);
+			newcs = popl(ssp, sp, simulate_sigsegv);
+			newflags = popl(ssp, sp, simulate_sigsegv);
 			SP(regs) += 12;
 		} else {
 			newip = popw(ssp, sp, simulate_sigsegv);
@@ -734,18 +738,18 @@ static struct vm86_irqs {
 static DEFINE_SPINLOCK(irqbits_lock);
 static int irqbits;
 
-#define ALLOWED_SIGS ( 1 /* 0 = don't send a signal */ \
+#define ALLOWED_SIGS (1 /* 0 = don't send a signal */ \
 	| (1 << SIGUSR1) | (1 << SIGUSR2) | (1 << SIGIO)  | (1 << SIGURG) \
-	| (1 << SIGUNUSED) )
-	
+	| (1 << SIGUNUSED))
+
 static irqreturn_t irq_handler(int intno, void *dev_id)
 {
 	int irq_bit;
 	unsigned long flags;
 
-	spin_lock_irqsave(&irqbits_lock, flags);	
+	spin_lock_irqsave(&irqbits_lock, flags);
 	irq_bit = 1 << intno;
-	if ((irqbits & irq_bit) || ! vm86_irqs[intno].tsk)
+	if ((irqbits & irq_bit) || !vm86_irqs[intno].tsk)
 		goto out;
 	irqbits |= irq_bit;
 	if (vm86_irqs[intno].sig)
@@ -759,7 +763,7 @@ static irqreturn_t irq_handler(int intno, void *dev_id)
 	return IRQ_HANDLED;
 
 out:
-	spin_unlock_irqrestore(&irqbits_lock, flags);	
+	spin_unlock_irqrestore(&irqbits_lock, flags);
 	return IRQ_NONE;
 }
 
@@ -770,9 +774,9 @@ static inline void free_vm86_irq(int irqnumber)
 	free_irq(irqnumber, NULL);
 	vm86_irqs[irqnumber].tsk = NULL;
 
-	spin_lock_irqsave(&irqbits_lock, flags);	
+	spin_lock_irqsave(&irqbits_lock, flags);
 	irqbits &= ~(1 << irqnumber);
-	spin_unlock_irqrestore(&irqbits_lock, flags);	
+	spin_unlock_irqrestore(&irqbits_lock, flags);
 }
 
 void release_vm86_irqs(struct task_struct *task)
@@ -788,10 +792,10 @@ static inline int get_and_reset_irq(int irqnumber)
 	int bit;
 	unsigned long flags;
 	int ret = 0;
-	
+
 	if (invalid_vm86_irq(irqnumber)) return 0;
 	if (vm86_irqs[irqnumber].tsk != current) return 0;
-	spin_lock_irqsave(&irqbits_lock, flags);	
+	spin_lock_irqsave(&irqbits_lock, flags);
 	bit = irqbits & (1 << irqnumber);
 	irqbits &= ~bit;
 	if (bit) {
@@ -799,7 +803,7 @@ static inline int get_and_reset_irq(int irqnumber)
 		ret = 1;
 	}
 
-	spin_unlock_irqrestore(&irqbits_lock, flags);	
+	spin_unlock_irqrestore(&irqbits_lock, flags);
 	return ret;
 }
 
-- 
1.5.4.GIT

