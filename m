Return-Path: <linux-kernel-owner+w=401wt.eu-S2992785AbXEBFj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992785AbXEBFj5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 01:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030591AbXEBFiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 01:38:19 -0400
Received: from haxent.com ([65.99.219.155]:2182 "EHLO haxent.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030572AbXEBFet (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 01:34:49 -0400
Message-Id: <20070502053425.732750000@haxent.com.br>
References: <20070502052235.914764000@haxent.com.br>
User-Agent: quilt/0.45-1
Date: Wed, 02 May 2007 02:22:43 -0300
From: Davi Arnaut <davi@haxent.com.br>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [patch 08/22] pollfs: x86_64, wire up the plsignal system call
Content-Disposition: inline; filename=pollfs-signal-x86_64-syscall.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make the plsignal syscall available to user-space on x86_64.

Signed-off-by: Davi E. M. Arnaut <davi@haxent.com.br>

---
 arch/x86_64/ia32/ia32entry.S |    3 ++-
 include/asm-x86_64/unistd.h  |    4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

Index: linux-2.6/include/asm-x86_64/unistd.h
===================================================================
--- linux-2.6.orig/include/asm-x86_64/unistd.h
+++ linux-2.6/include/asm-x86_64/unistd.h
@@ -619,8 +619,10 @@ __SYSCALL(__NR_sync_file_range, sys_sync
 __SYSCALL(__NR_vmsplice, sys_vmsplice)
 #define __NR_move_pages		279
 __SYSCALL(__NR_move_pages, sys_move_pages)
+#define __NR_plsignal		280
+__SYSCALL(__NR_plsignal, sys_plsignal)
 
-#define __NR_syscall_max __NR_move_pages
+#define __NR_syscall_max __NR_plsignal
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
Index: linux-2.6/arch/x86_64/ia32/ia32entry.S
===================================================================
--- linux-2.6.orig/arch/x86_64/ia32/ia32entry.S
+++ linux-2.6/arch/x86_64/ia32/ia32entry.S
@@ -714,9 +714,10 @@ ia32_sys_call_table:
 	.quad compat_sys_get_robust_list
 	.quad sys_splice
 	.quad sys_sync_file_range
-	.quad sys_tee
+	.quad sys_tee			/* 315 */
 	.quad compat_sys_vmsplice
 	.quad compat_sys_move_pages
 	.quad sys_getcpu
 	.quad sys_epoll_pwait
+	.quad sys_plsignal		/* 320 */
 ia32_syscall_end:		

--
