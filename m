Return-Path: <linux-kernel-owner+w=401wt.eu-S1752418AbXCLTT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418AbXCLTT6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 15:19:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752403AbXCLTTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 15:19:34 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:33761 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404AbXCLTTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 15:19:30 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
Date: Mon, 12 Mar 2007 12:19:27 -0700
Subject: [patch 4/9] signalfd/timerfd v4 - signalfd wire up x86_64 arch ...
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.5142.1173727169.4>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch wire the signalfd system call to the x86_64 architecture.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide



Index: linux-2.6.20.ep2/include/asm-x86_64/unistd.h
===================================================================
--- linux-2.6.20.ep2.orig/include/asm-x86_64/unistd.h	2007-03-11 14:28:28.000000000 -0700
+++ linux-2.6.20.ep2/include/asm-x86_64/unistd.h	2007-03-11 14:28:46.000000000 -0700
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
--- linux-2.6.20.ep2.orig/arch/x86_64/ia32/ia32entry.S	2007-03-11 14:28:28.000000000 -0700
+++ linux-2.6.20.ep2/arch/x86_64/ia32/ia32entry.S	2007-03-11 14:28:46.000000000 -0700
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

