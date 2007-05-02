Return-Path: <linux-kernel-owner+w=401wt.eu-S1754863AbXEBFgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863AbXEBFgE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 01:36:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030628AbXEBFfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 01:35:32 -0400
Received: from haxent.com ([65.99.219.155]:2190 "EHLO haxent.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030622AbXEBFey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 01:34:54 -0400
Message-Id: <20070502053426.666457000@haxent.com.br>
References: <20070502052235.914764000@haxent.com.br>
User-Agent: quilt/0.45-1
Date: Wed, 02 May 2007 02:22:47 -0300
From: Davi Arnaut <davi@haxent.com.br>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [patch 12/22] pollfs: x86_64, wire up the pltimer system call
Content-Disposition: inline; filename=pollfs-timer-x86_64-syscall.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make the pltimer syscall available to user-space on x86_64.

Signed-off-by: Davi E. M. Arnaut <davi@haxent.com.br>

---
 arch/x86_64/ia32/ia32entry.S |    1 +
 include/asm-x86_64/unistd.h  |    4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86_64/ia32/ia32entry.S
===================================================================
--- linux-2.6.orig/arch/x86_64/ia32/ia32entry.S
+++ linux-2.6/arch/x86_64/ia32/ia32entry.S
@@ -720,4 +720,5 @@ ia32_sys_call_table:
 	.quad sys_getcpu
 	.quad sys_epoll_pwait
 	.quad sys_plsignal		/* 320 */
+	.quad sys_pltimer
 ia32_syscall_end:		
Index: linux-2.6/include/asm-x86_64/unistd.h
===================================================================
--- linux-2.6.orig/include/asm-x86_64/unistd.h
+++ linux-2.6/include/asm-x86_64/unistd.h
@@ -621,8 +621,10 @@ __SYSCALL(__NR_vmsplice, sys_vmsplice)
 __SYSCALL(__NR_move_pages, sys_move_pages)
 #define __NR_plsignal		280
 __SYSCALL(__NR_plsignal, sys_plsignal)
+#define __NR_pltimer		281
+__SYSCALL(__NR_pltimer, sys_pltimer)
 
-#define __NR_syscall_max __NR_plsignal
+#define __NR_syscall_max __NR_pltimer
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR

--
