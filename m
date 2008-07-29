Return-Path: <linux-kernel-owner+w=401wt.eu-S1756787AbYG2Ftl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787AbYG2Ftl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 01:49:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754830AbYG2Fs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 01:48:57 -0400
Received: from argonath.las.ic.unicamp.br ([143.106.60.116]:55505 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633AbYG2Fs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 01:48:56 -0400
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu
Subject: [PATCH 2/6] x86: add KERN_INFO to printks on process_64.c
Date: Tue, 29 Jul 2008 02:48:52 -0300
Message-Id: <1217310536-7181-3-git-send-email-gustavo@las.ic.unicamp.br>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1217310536-7181-2-git-send-email-gustavo@las.ic.unicamp.br>
References: <gustavo@las.ic.unicamp.br>
 <1217310536-7181-1-git-send-email-gustavo@las.ic.unicamp.br>
 <1217310536-7181-2-git-send-email-gustavo@las.ic.unicamp.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix many coding style warnings.

Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>
---
 arch/x86/kernel/process_64.c |   32 +++++++++++++++++---------------
 1 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 4da8514..3560d7f 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -161,24 +161,24 @@ void __show_regs(struct pt_regs *regs)
 
 	printk("\n");
 	print_modules();
-	printk("Pid: %d, comm: %.20s %s %s %.*s\n",
+	printk(KERN_INFO "Pid: %d, comm: %.20s %s %s %.*s\n",
 		current->pid, current->comm, print_tainted(),
 		init_utsname()->release,
 		(int)strcspn(init_utsname()->version, " "),
 		init_utsname()->version);
-	printk("RIP: %04lx:[<%016lx>] ", regs->cs & 0xffff, regs->ip);
+	printk(KERN_INFO "RIP: %04lx:[<%016lx>] ", regs->cs & 0xffff, regs->ip);
 	printk_address(regs->ip, 1);
-	printk("RSP: %04lx:%016lx  EFLAGS: %08lx\n", regs->ss, regs->sp,
-		regs->flags);
-	printk("RAX: %016lx RBX: %016lx RCX: %016lx\n",
+	printk(KERN_INFO "RSP: %04lx:%016lx  EFLAGS: %08lx\n", regs->ss,
+			regs->sp, regs->flags);
+	printk(KERN_INFO "RAX: %016lx RBX: %016lx RCX: %016lx\n",
 	       regs->ax, regs->bx, regs->cx);
-	printk("RDX: %016lx RSI: %016lx RDI: %016lx\n",
+	printk(KERN_INFO "RDX: %016lx RSI: %016lx RDI: %016lx\n",
 	       regs->dx, regs->si, regs->di);
-	printk("RBP: %016lx R08: %016lx R09: %016lx\n",
+	printk(KERN_INFO "RBP: %016lx R08: %016lx R09: %016lx\n",
 	       regs->bp, regs->r8, regs->r9);
-	printk("R10: %016lx R11: %016lx R12: %016lx\n",
+	printk(KERN_INFO "R10: %016lx R11: %016lx R12: %016lx\n",
 	       regs->r10, regs->r11, regs->r12);
-	printk("R13: %016lx R14: %016lx R15: %016lx\n",
+	printk(KERN_INFO "R13: %016lx R14: %016lx R15: %016lx\n",
 	       regs->r13, regs->r14, regs->r15);
 
 	asm("movl %%ds,%0" : "=r" (ds));
@@ -196,24 +196,26 @@ void __show_regs(struct pt_regs *regs)
 	cr3 = read_cr3();
 	cr4 = read_cr4();
 
-	printk("FS:  %016lx(%04x) GS:%016lx(%04x) knlGS:%016lx\n",
+	printk(KERN_INFO "FS:  %016lx(%04x) GS:%016lx(%04x) knlGS:%016lx\n",
 	       fs, fsindex, gs, gsindex, shadowgs);
-	printk("CS:  %04x DS: %04x ES: %04x CR0: %016lx\n", cs, ds, es, cr0);
-	printk("CR2: %016lx CR3: %016lx CR4: %016lx\n", cr2, cr3, cr4);
+	printk(KERN_INFO "CS:  %04x DS: %04x ES: %04x CR0: %016lx\n", cs, ds,
+			es, cr0);
+	printk(KERN_INFO "CR2: %016lx CR3: %016lx CR4: %016lx\n", cr2, cr3,
+			cr4);
 
 	get_debugreg(d0, 0);
 	get_debugreg(d1, 1);
 	get_debugreg(d2, 2);
-	printk("DR0: %016lx DR1: %016lx DR2: %016lx\n", d0, d1, d2);
+	printk(KERN_INFO "DR0: %016lx DR1: %016lx DR2: %016lx\n", d0, d1, d2);
 	get_debugreg(d3, 3);
 	get_debugreg(d6, 6);
 	get_debugreg(d7, 7);
-	printk("DR3: %016lx DR6: %016lx DR7: %016lx\n", d3, d6, d7);
+	printk(KERN_INFO "DR3: %016lx DR6: %016lx DR7: %016lx\n", d3, d6, d7);
 }
 
 void show_regs(struct pt_regs *regs)
 {
-	printk("CPU %d:", smp_processor_id());
+	printk(KERN_INFO "CPU %d:", smp_processor_id());
 	__show_regs(regs);
 	show_trace(NULL, regs, (void *)(regs + 1), regs->bp);
 }
-- 
1.5.4.5

