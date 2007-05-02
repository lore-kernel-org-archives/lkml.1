Return-Path: <linux-kernel-owner+w=401wt.eu-S1030765AbXEBFfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030765AbXEBFfS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 01:35:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030837AbXEBFfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 01:35:17 -0400
Received: from haxent.com ([65.99.219.155]:2216 "EHLO haxent.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030765AbXEBFfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 01:35:03 -0400
Message-Id: <20070502053428.967703000@haxent.com.br>
References: <20070502052235.914764000@haxent.com.br>
User-Agent: quilt/0.45-1
Date: Wed, 02 May 2007 02:22:57 -0300
From: Davi Arnaut <davi@haxent.com.br>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [patch 22/22] pollfs: x86_64, wire up the plaio system call
Content-Disposition: inline; filename=pollfs-aio-x86_64-syscall.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make the plaio syscall available to user-space on x86_64.

Signed-off-by: Davi E. M. Arnaut <davi@haxent.com.br>

---
 arch/x86_64/ia32/ia32entry.S |    1 +
 include/asm-x86_64/unistd.h  |    4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86_64/ia32/ia32entry.S
===================================================================
--- linux-2.6.orig/arch/x86_64/ia32/ia32entry.S
+++ linux-2.6/arch/x86_64/ia32/ia32entry.S
@@ -722,4 +722,5 @@ ia32_sys_call_table:
 	.quad sys_plsignal		/* 320 */
 	.quad sys_pltimer
 	.quad sys_plfutex
+	.quad sys_plaio
 ia32_syscall_end:		
Index: linux-2.6/include/asm-x86_64/unistd.h
===================================================================
--- linux-2.6.orig/include/asm-x86_64/unistd.h
+++ linux-2.6/include/asm-x86_64/unistd.h
@@ -625,8 +625,10 @@ __SYSCALL(__NR_plsignal, sys_plsignal)
 __SYSCALL(__NR_pltimer, sys_pltimer)
 #define __NR_plfutex		282
 __SYSCALL(__NR_plfutex, sys_plfutex)
+#define __NR_plaio		283
+__SYSCALL(__NR_plaio, sys_plaio)
 
-#define __NR_syscall_max __NR_plfutex
+#define __NR_syscall_max __NR_plaio
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR

--
