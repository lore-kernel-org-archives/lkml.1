Return-Path: <linux-kernel-owner+w=401wt.eu-S1030572AbXEBFjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030572AbXEBFjA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 01:39:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030283AbXEBFi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 01:38:26 -0400
Received: from haxent.com ([65.99.219.155]:2178 "EHLO haxent.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754754AbXEBFep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 01:34:45 -0400
Message-Id: <20070502053428.736717000@haxent.com.br>
References: <20070502052235.914764000@haxent.com.br>
User-Agent: quilt/0.45-1
Date: Wed, 02 May 2007 02:22:56 -0300
From: Davi Arnaut <davi@haxent.com.br>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [patch 21/22] pollfs: x86, wire up the plaio system call
Content-Disposition: inline; filename=pollfs-aio-i386-syscall.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make the plaio syscall available to user-space on x86.

Signed-off-by: Davi E. M. Arnaut <davi@haxent.com.br>

---
 arch/i386/kernel/syscall_table.S |    1 +
 include/asm-i386/unistd.h        |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6/include/asm-i386/unistd.h
===================================================================
--- linux-2.6.orig/include/asm-i386/unistd.h
+++ linux-2.6/include/asm-i386/unistd.h
@@ -328,10 +328,11 @@
 #define __NR_plsignal		320
 #define __NR_pltimer		321
 #define __NR_plfutex		322
+#define __NR_plaio		323
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 323
+#define NR_syscalls 324
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
Index: linux-2.6/arch/i386/kernel/syscall_table.S
===================================================================
--- linux-2.6.orig/arch/i386/kernel/syscall_table.S
+++ linux-2.6/arch/i386/kernel/syscall_table.S
@@ -322,3 +322,4 @@ ENTRY(sys_call_table)
 	.long sys_plsignal		/* 320 */
 	.long sys_pltimer
 	.long sys_plfutex
+	.long sys_plaio

--
