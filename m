Return-Path: <linux-kernel-owner+w=401wt.eu-S1756774AbXKYV7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774AbXKYV7s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 16:59:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757353AbXKYV7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 16:59:24 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59972 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757265AbXKYV7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 16:59:23 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 03/27] x86: remove TRAP_FLAG
In-Reply-To: Roland McGrath's message of  Sunday, 25 November 2007 13:55:07 -0800 <20071125215507.4B89226F8C5@magilla.localdomain>
References: <20071125215507.4B89226F8C5@magilla.localdomain>
Emacs: no job too big... no job.
Message-Id: <20071125215848.EBAB126F8DE@magilla.localdomain>
Date: Sun, 25 Nov 2007 13:58:48 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This gets rid of the local constant macro TRAP_FLAG.
It's redundant with the public constant macro X86_EFLAGS_TF.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/ptrace_32.c |    9 +++------
 arch/x86/kernel/ptrace_64.c |    9 +++------
 2 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/ptrace_32.c b/arch/x86/kernel/ptrace_32.c
index 39a94a0..2b4fcb5 100644
--- a/arch/x86/kernel/ptrace_32.c
+++ b/arch/x86/kernel/ptrace_32.c
@@ -37,9 +37,6 @@
  */
 #define FLAG_MASK 0x00050dd5
 
-/* set's the trap flag. */
-#define TRAP_FLAG 0x100
-
 /*
  * Offset of eflags on child stack..
  */
@@ -235,11 +232,11 @@ static void set_singlestep(struct task_struct *child)
 	/*
 	 * If TF was already set, don't do anything else
 	 */
-	if (regs->eflags & TRAP_FLAG)
+	if (regs->eflags & X86_EFLAGS_TF)
 		return;
 
 	/* Set TF on the kernel stack.. */
-	regs->eflags |= TRAP_FLAG;
+	regs->eflags |= X86_EFLAGS_TF;
 
 	/*
 	 * ..but if TF is changed by the instruction we will trace,
@@ -260,7 +257,7 @@ static void clear_singlestep(struct task_struct *child)
 	/* But touch TF only if it was set by us.. */
 	if (child->ptrace & PT_DTRACE) {
 		struct pt_regs *regs = get_child_regs(child);
-		regs->eflags &= ~TRAP_FLAG;
+		regs->eflags &= ~X86_EFLAGS_TF;
 		child->ptrace &= ~PT_DTRACE;
 	}
 }
diff --git a/arch/x86/kernel/ptrace_64.c b/arch/x86/kernel/ptrace_64.c
index 07de75d..e907e2e 100644
--- a/arch/x86/kernel/ptrace_64.c
+++ b/arch/x86/kernel/ptrace_64.c
@@ -42,9 +42,6 @@
  */
 #define FLAG_MASK 0x54dd5UL
 
-/* set's the trap flag. */
-#define TRAP_FLAG 0x100UL
-
 /*
  * eflags and offset of eflags on child stack..
  */
@@ -187,11 +184,11 @@ static void set_singlestep(struct task_struct *child)
 	/*
 	 * If TF was already set, don't do anything else
 	 */
-	if (regs->eflags & TRAP_FLAG)
+	if (regs->eflags & X86_EFLAGS_TF)
 		return;
 
 	/* Set TF on the kernel stack.. */
-	regs->eflags |= TRAP_FLAG;
+	regs->eflags |= X86_EFLAGS_TF;
 
 	/*
 	 * ..but if TF is changed by the instruction we will trace,
@@ -212,7 +209,7 @@ static void clear_singlestep(struct task_struct *child)
 	/* But touch TF only if it was set by us.. */
 	if (child->ptrace & PT_DTRACE) {
 		struct pt_regs *regs = task_pt_regs(child);
-		regs->eflags &= ~TRAP_FLAG;
+		regs->eflags &= ~X86_EFLAGS_TF;
 		child->ptrace &= ~PT_DTRACE;
 	}
 }
