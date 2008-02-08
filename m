Return-Path: <linux-kernel-owner+w=401wt.eu-S934946AbYBHULU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934946AbYBHULU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 15:11:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932290AbYBHULM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 15:11:12 -0500
Received: from py-out-1112.google.com ([64.233.166.183]:28919 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932981AbYBHULJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 15:11:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=X+RjYbTocywylhxsP4vzQUaE4kISEE7kA1vTdWFq3/fge946Fwb0u3XDP8/0h9TxJyDUKq8Vp6QW4uZbKn1edlQoxYdvStFKC4FkmfH3j+HmDEioOA8HRAgrOq7zoIGjYNOKlilK8xPu7y1AazF80EYL6shiLmF4N2f9RIR6tGg=
Subject: [PATCH 1/9] x86: change most X86_32 pt_regs members to unsigned
	long
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 08 Feb 2008 12:09:56 -0800
Message-Id: <1202501396.12966.20.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All but ax and orig_ax can move with no changes.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/process_32.c |    5 ++---
 arch/x86/kernel/signal_32.c  |    4 ++--
 include/asm-x86/ptrace.h     |   28 ++++++++++++++--------------
 3 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index dabdbef..32247ad 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -358,7 +358,7 @@ void __show_registers(struct pt_regs *regs, int all)
 			init_utsname()->version);
 
 	printk("EIP: %04x:[<%08lx>] EFLAGS: %08lx CPU: %d\n",
-			0xffff & regs->cs, regs->ip, regs->flags,
+			(u16)regs->cs, regs->ip, regs->flags,
 			smp_processor_id());
 	print_symbol("EIP is at %s\n", regs->ip);
 
@@ -367,8 +367,7 @@ void __show_registers(struct pt_regs *regs, int all)
 	printk("ESI: %08lx EDI: %08lx EBP: %08lx ESP: %08lx\n",
 		regs->si, regs->di, regs->bp, sp);
 	printk(" DS: %04x ES: %04x FS: %04x GS: %04x SS: %04x\n",
-	       regs->ds & 0xffff, regs->es & 0xffff,
-	       regs->fs & 0xffff, gs, ss);
+	       (u16)regs->ds, (u16)regs->es, (u16)regs->fs, gs, ss);
 
 	if (!all)
 		return;
diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index caee1f0..7718395 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -393,8 +393,8 @@ static int setup_frame(int sig, struct k_sigaction *ka,
 	regs->sp = (unsigned long) frame;
 	regs->ip = (unsigned long) ka->sa.sa_handler;
 	regs->ax = (unsigned long) sig;
-	regs->dx = (unsigned long) 0;
-	regs->cx = (unsigned long) 0;
+	regs->dx = 0;
+	regs->cx = 0;
 
 	regs->ds = __USER_DS;
 	regs->es = __USER_DS;
diff --git a/include/asm-x86/ptrace.h b/include/asm-x86/ptrace.h
index d9e04b4..708337a 100644
--- a/include/asm-x86/ptrace.h
+++ b/include/asm-x86/ptrace.h
@@ -36,23 +36,23 @@ struct pt_regs {
 #else /* __KERNEL__ */
 
 struct pt_regs {
-	long bx;
-	long cx;
-	long dx;
-	long si;
-	long di;
-	long bp;
+	unsigned long bx;
+	unsigned long cx;
+	unsigned long dx;
+	unsigned long si;
+	unsigned long di;
+	unsigned long bp;
 	long ax;
-	int  ds;
-	int  es;
-	int  fs;
+	unsigned long ds;
+	unsigned long es;
+	unsigned long fs;
 	/* int  gs; */
 	long orig_ax;
-	long ip;
-	int  cs;
-	long flags;
-	long sp;
-	int  ss;
+	unsigned long ip;
+	unsigned long cs;
+	unsigned long flags;
+	unsigned long sp;
+	unsigned long ss;
 };
 
 #include <asm/vm86.h>
-- 
1.5.4.1219.g65b9


