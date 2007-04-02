Return-Path: <linux-kernel-owner+w=401wt.eu-S966019AbXDBWrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966019AbXDBWrp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 18:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966036AbXDBWrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 18:47:32 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:50524 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966019AbXDBWqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 18:46:34 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
Date: Mon, 02 Apr 2007 15:46:31 -0700
Subject: [patch 4/13] signal/timer/event fds v10 - signalfd wire up x86_64 arch ...
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.10599.1175553993.4>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch wire the signalfd system call to the x86_64 architecture.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide



Index: linux-2.6.21-rc5.fds/include/asm-x86_64/unistd.h
===================================================================
--- linux-2.6.21-rc5.fds.orig/include/asm-x86_64/unistd.h	2007-04-02 15:06:12.000000000 -0700
+++ linux-2.6.21-rc5.fds/include/asm-x86_64/unistd.h	2007-04-02 15:06:34.000000000 -0700
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
Index: linux-2.6.21-rc5.fds/arch/x86_64/ia32/ia32entry.S
===================================================================
--- linux-2.6.21-rc5.fds.orig/arch/x86_64/ia32/ia32entry.S	2007-04-02 15:06:12.000000000 -0700
+++ linux-2.6.21-rc5.fds/arch/x86_64/ia32/ia32entry.S	2007-04-02 15:06:34.000000000 -0700
@@ -714,9 +714,10 @@
 	.quad compat_sys_get_robust_list
 	.quad sys_splice
 	.quad sys_sync_file_range
-	.quad sys_tee
+	.quad sys_tee			/* 315 */
 	.quad compat_sys_vmsplice
 	.quad compat_sys_move_pages
 	.quad sys_getcpu
 	.quad sys_epoll_pwait
+	.quad sys_signalfd		/* 320 */
 ia32_syscall_end:		

