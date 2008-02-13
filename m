Return-Path: <linux-kernel-owner+w=401wt.eu-S935274AbYBMVyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935274AbYBMVyp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 16:54:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764802AbYBMVcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:32:00 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:55790 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764614AbYBMVbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:31:47 -0500
Date: Wed, 13 Feb 2008 23:31:31 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] x86: make dump_pagetable() static
Message-ID: <20080213213131.GA3383@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dump_pagetable() can now become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/x86/mm/fault.c      |    2 +-
 include/asm-x86/kdebug.h |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

fe111b005768f97b9f83af7ad4014a77e7adc249 diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 621afb6..fdc6674 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -186,7 +186,7 @@ static int bad_address(void *p)
 }
 #endif
 
-void dump_pagetable(unsigned long address)
+static void dump_pagetable(unsigned long address)
 {
 #ifdef CONFIG_X86_32
 	__typeof__(pte_val(__pte(0))) page;
diff --git a/include/asm-x86/kdebug.h b/include/asm-x86/kdebug.h
index dd442a1..99dcbaf 100644
--- a/include/asm-x86/kdebug.h
+++ b/include/asm-x86/kdebug.h
@@ -31,7 +31,6 @@ extern void show_trace(struct task_struct *t, struct pt_regs *regs,
 			unsigned long *sp, unsigned long bp);
 extern void __show_regs(struct pt_regs *regs);
 extern void show_regs(struct pt_regs *regs);
-extern void dump_pagetable(unsigned long);
 extern unsigned long oops_begin(void);
 extern void oops_end(unsigned long, struct pt_regs *, int signr);
 

