Return-Path: <linux-kernel-owner+w=401wt.eu-S1754866AbXEBFgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866AbXEBFgE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 01:36:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030624AbXEBFff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 01:35:35 -0400
Received: from haxent.com ([65.99.219.155]:2188 "EHLO haxent.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030621AbXEBFew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 01:34:52 -0400
Message-Id: <20070502053426.428183000@haxent.com.br>
References: <20070502052235.914764000@haxent.com.br>
User-Agent: quilt/0.45-1
Date: Wed, 02 May 2007 02:22:46 -0300
From: Davi Arnaut <davi@haxent.com.br>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [patch 11/22] pollfs: x86, wire up the pltimer system call
Content-Disposition: inline; filename=pollfs-timer-i386-syscall.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make the pltimer syscall available to user-space on x86.

Signed-off-by: Davi E. M. Arnaut <davi@haxent.com.br>

---
 arch/i386/kernel/syscall_table.S |    1 +
 include/asm-i386/unistd.h        |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6/include/asm-i386/unistd.h
===================================================================
--- linux-2.6.orig/include/asm-i386/unistd.h
+++ linux-2.6/include/asm-i386/unistd.h
@@ -326,10 +326,11 @@
 #define __NR_getcpu		318
 #define __NR_epoll_pwait	319
 #define __NR_plsignal		320
+#define __NR_pltimer		321
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 321
+#define NR_syscalls 322
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
Index: linux-2.6/arch/i386/kernel/syscall_table.S
===================================================================
--- linux-2.6.orig/arch/i386/kernel/syscall_table.S
+++ linux-2.6/arch/i386/kernel/syscall_table.S
@@ -320,3 +320,4 @@ ENTRY(sys_call_table)
 	.long sys_getcpu
 	.long sys_epoll_pwait
 	.long sys_plsignal		/* 320 */
+	.long sys_pltimer

--
