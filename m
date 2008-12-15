Return-Path: <linux-kernel-owner+w=401wt.eu-S1756150AbYLOQ6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150AbYLOQ6R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 11:58:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754060AbYLOQ6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 11:58:03 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54064 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187AbYLOQ6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 11:58:01 -0500
Subject: [PATCH] x86: ldt.c declare sys_modify_ldt before they get used
From: Jaswinder Singh <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain
Date: Mon, 15 Dec 2008 22:26:30 +0530
Message-Id: <1229360190.15326.7.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>

In asm/syscalls.h moved out sys_modify_ldt from CONFIG_X86_32 as it is common for both 32 and 64 bit.
---
 arch/x86/include/asm/syscalls.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/syscalls.h b/arch/x86/include/asm/syscalls.h
index 3a5252c..57dd724 100644
--- a/arch/x86/include/asm/syscalls.h
+++ b/arch/x86/include/asm/syscalls.h
@@ -19,6 +19,9 @@
 /* kernel/ioport.c */
 asmlinkage long sys_ioperm(unsigned long, unsigned long, int);
 
+/* kernel/ldt.c */
+asmlinkage int sys_modify_ldt(int, void __user *, unsigned long);
+
 /* X86_32 only */
 #ifdef CONFIG_X86_32
 /* kernel/process_32.c */
@@ -38,9 +41,6 @@ asmlinkage int sys_rt_sigreturn(struct pt_regs);
 /* kernel/ioport.c */
 asmlinkage long sys_iopl(unsigned long);
 
-/* kernel/ldt.c */
-asmlinkage int sys_modify_ldt(int, void __user *, unsigned long);
-
 /* kernel/sys_i386_32.c */
 asmlinkage long sys_mmap2(unsigned long, unsigned long, unsigned long,
 			  unsigned long, unsigned long, unsigned long);
-- 
1.5.5.1



