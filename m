Return-Path: <linux-kernel-owner+w=401wt.eu-S932562AbXCKCWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562AbXCKCWo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 21:22:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932699AbXCKCWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 21:22:43 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:46896 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932562AbXCKCWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 21:22:23 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sat, 10 Mar 2007 18:22:21 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: [patch 4/9] signalfd/timerfd - signalfd wire up x86_64 arch ...
Message-ID: <Pine.LNX.4.64.0703101822180.3613@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch wire the signalfd system call to the x86_64 architecture.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide



Index: linux-2.6.20.ep2/include/asm-x86_64/unistd.h
===================================================================
--- linux-2.6.20.ep2.orig/include/asm-x86_64/unistd.h	2007-03-10 15:57:00.000000000 -0800
+++ linux-2.6.20.ep2/include/asm-x86_64/unistd.h	2007-03-10 15:58:00.000000000 -0800
@@ -619,8 +619,10 @@
 __SYSCALL(__NR_vmsplice, sys_vmsplice)
 #define __NR_move_pages		279
 __SYSCALL(__NR_move_pages, sys_move_pages)
+#define __NR_signalfd		280
+__SYSCALL(__NR_signalfd, sys_signalfd)
 
-#define __NR_syscall_max __NR_move_pages
+#define __NR_syscall_max __NR_signalfd
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
Index: linux-2.6.20.ep2/arch/x86_64/ia32/ia32entry.S
===================================================================
--- linux-2.6.20.ep2.orig/arch/x86_64/ia32/ia32entry.S	2007-03-10 15:57:00.000000000 -0800
+++ linux-2.6.20.ep2/arch/x86_64/ia32/ia32entry.S	2007-03-10 15:58:00.000000000 -0800
@@ -714,8 +714,10 @@
 	.quad compat_sys_get_robust_list
 	.quad sys_splice
 	.quad sys_sync_file_range
-	.quad sys_tee
+	.quad sys_tee			/* 315 */
 	.quad compat_sys_vmsplice
 	.quad compat_sys_move_pages
 	.quad sys_getcpu
-ia32_syscall_end:		
+	.quad sys_epoll_pwait
+	.quad sys_signalfd		/* 320 */
+ia32_syscall_end:
