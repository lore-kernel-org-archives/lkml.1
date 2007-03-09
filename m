Return-Path: <linux-kernel-owner+w=401wt.eu-S1767664AbXCIXlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767664AbXCIXlJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 18:41:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767669AbXCIXlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 18:41:05 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:44198 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767664AbXCIXkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 18:40:46 -0500
X-AuthUser: davidel@xmailserver.org
Date: Fri, 9 Mar 2007 15:40:45 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [patch 4/9] signalfd/timerfd v1 - wire up signalfd x86_64 arch ...
Message-ID: <Pine.LNX.4.64.0703091533450.3761@alien.or.mcafeemobile.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch wire the signalfd system call to the x86_64 architecture.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide



Index: linux-2.6.20.ep2/include/asm-x86_64/unistd.h
===================================================================
--- linux-2.6.20.ep2.orig/include/asm-x86_64/unistd.h	2007-03-09 10:43:19.000000000 -0800
+++ linux-2.6.20.ep2/include/asm-x86_64/unistd.h	2007-03-09 10:56:02.000000000 -0800
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
--- linux-2.6.20.ep2.orig/arch/x86_64/ia32/ia32entry.S	2007-03-09 10:43:19.000000000 -0800
+++ linux-2.6.20.ep2/arch/x86_64/ia32/ia32entry.S	2007-03-09 10:56:02.000000000 -0800
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
