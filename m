Return-Path: <linux-kernel-owner+w=401wt.eu-S1762691AbYAKWYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762691AbYAKWYX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 17:24:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761400AbYAKWYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 17:24:15 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:61565 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759067AbYAKWYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 17:24:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=kmnDyyUFZfXPJd84HlFLlc7RQtDDfAUm2Hs0Vt0q6pa+I1thAJZXY7VXBuwvSjXU28eUFHjx/GEewBJncSY/Q16cC2Opi1ZuJiTLcymJ4jUHpCeFmnCD9BrRD0St65fBHJPxKYDkKNULGf7hKJdr6UaBp1ofmKvn6ih0/ls/h5Q=
Subject: [PATCH] x86: common x86_32|64 naming
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Fri, 11 Jan 2008 14:24:17 -0800
Message-Id: <1200090257.19760.55.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename convert_rip_to_linear to convert_ip_to_linear for shared
X86_32|64 use.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/step.c   |    4 ++--
 arch/x86/mm/fault_32.c   |    2 +-
 arch/x86/mm/fault_64.c   |    2 +-
 include/asm-x86/ptrace.h |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/step.c b/arch/x86/kernel/step.c
index 5884dd4..923aee6 100644
--- a/arch/x86/kernel/step.c
+++ b/arch/x86/kernel/step.c
@@ -89,7 +89,7 @@ unsigned long get_segment_eip(struct pt_regs *regs,
 #ifdef CONFIG_X86_32
 static
 #endif
-unsigned long convert_rip_to_linear(struct task_struct *child, struct pt_regs *regs)
+unsigned long convert_ip_to_linear(struct task_struct *child, struct pt_regs *regs)
 {
 	unsigned long addr, seg;
 
@@ -136,7 +136,7 @@ static int is_setting_trap_flag(struct task_struct *child, struct pt_regs *regs)
 {
 	int i, copied;
 	unsigned char opcode[15];
-	unsigned long addr = convert_rip_to_linear(child, regs);
+	unsigned long addr = convert_ip_to_linear(child, regs);
 
 	copied = access_process_vm(child, addr, opcode, sizeof(opcode), 0);
 	for (i = 0; i < copied; i++) {
diff --git a/arch/x86/mm/fault_32.c b/arch/x86/mm/fault_32.c
index f8fc240..f0bbcab 100644
--- a/arch/x86/mm/fault_32.c
+++ b/arch/x86/mm/fault_32.c
@@ -95,7 +95,7 @@ static int is_prefetch(struct pt_regs *regs, unsigned long addr,
 	/* If it was a exec fault ignore */
 	if (error_code & PF_INSTR)
 		return 0;
-	instr = (unsigned char __user *)convert_rip_to_linear(current, regs);
+	instr = (unsigned char __user *)convert_ip_to_linear(current, regs);
 #endif
 
 	max_instr = instr + 15;
diff --git a/arch/x86/mm/fault_64.c b/arch/x86/mm/fault_64.c
index 11e9398..7dedb6b 100644
--- a/arch/x86/mm/fault_64.c
+++ b/arch/x86/mm/fault_64.c
@@ -98,7 +98,7 @@ static int is_prefetch(struct pt_regs *regs, unsigned long addr,
 	/* If it was a exec fault ignore */
 	if (error_code & PF_INSTR)
 		return 0;
-	instr = (unsigned char __user *)convert_rip_to_linear(current, regs);
+	instr = (unsigned char __user *)convert_ip_to_linear(current, regs);
 #endif
 
 	max_instr = instr + 15;
diff --git a/include/asm-x86/ptrace.h b/include/asm-x86/ptrace.h
index cc44566..35c1037 100644
--- a/include/asm-x86/ptrace.h
+++ b/include/asm-x86/ptrace.h
@@ -177,7 +177,7 @@ void signal_fault(struct pt_regs *regs, void __user *frame, char *where);
 struct task_struct;
 
 extern unsigned long
-convert_rip_to_linear(struct task_struct *child, struct pt_regs *regs);
+convert_ip_to_linear(struct task_struct *child, struct pt_regs *regs);
 
 #endif /* __KERNEL__ */
 #endif /* !__i386__ */
-- 
1.5.4.rc2.1164.g6451


