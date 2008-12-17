Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1751477AbYLQRuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751477AbYLQRuh (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 12:50:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750742AbYLQRu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 12:50:27 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53849 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbYLQRu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 12:50:26 -0500
Subject: [PATCH] x86: tls.c declare sys_set_thread_area and
	sys_get_thread_area before they get used
From: Jaswinder Singh <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 17 Dec 2008 23:18:52 +0530
Message-Id: <1229536132.23068.4.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

In asm/syscalls.h moved out sys_set_thread_area and sys_get_thread_area as it is common for both 32 and 64 bit.

Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
---
 arch/x86/include/asm/syscalls.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/syscalls.h b/arch/x86/include/asm/syscalls.h
index 57dd724..9c6797c 100644
--- a/arch/x86/include/asm/syscalls.h
+++ b/arch/x86/include/asm/syscalls.h
@@ -22,6 +22,10 @@ asmlinkage long sys_ioperm(unsigned long, unsigned long, int);
 /* kernel/ldt.c */
 asmlinkage int sys_modify_ldt(int, void __user *, unsigned long);
 
+/* kernel/tls.c */
+asmlinkage int sys_set_thread_area(struct user_desc __user *);
+asmlinkage int sys_get_thread_area(struct user_desc __user *);
+
 /* X86_32 only */
 #ifdef CONFIG_X86_32
 /* kernel/process_32.c */
@@ -54,10 +58,6 @@ asmlinkage int sys_uname(struct old_utsname __user *);
 struct oldold_utsname;
 asmlinkage int sys_olduname(struct oldold_utsname __user *);
 
-/* kernel/tls.c */
-asmlinkage int sys_set_thread_area(struct user_desc __user *);
-asmlinkage int sys_get_thread_area(struct user_desc __user *);
-
 /* kernel/vm86_32.c */
 asmlinkage int sys_vm86old(struct pt_regs);
 asmlinkage int sys_vm86(struct pt_regs);
-- 
1.5.5.1



