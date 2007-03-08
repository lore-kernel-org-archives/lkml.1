Return-Path: <linux-kernel-owner+w=401wt.eu-S2992822AbXCHBWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992822AbXCHBWV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 20:22:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992821AbXCHBWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 20:22:20 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:42811 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992818AbXCHBWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 20:22:13 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 7 Mar 2007 17:22:12 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [patch 4/5] signalfd v2 - wire x86_64 syscall ...
Message-ID: <Pine.LNX.4.64.0703071715090.3672@alien.or.mcafeemobile.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch wire the signalfd system calls to the x86_64 architecture.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide



Index: linux-2.6.20.ep2/include/asm-x86_64/unistd.h
===================================================================
--- linux-2.6.20.ep2.orig/include/asm-x86_64/unistd.h	2007-03-07 13:28:41.000000000 -0800
+++ linux-2.6.20.ep2/include/asm-x86_64/unistd.h	2007-03-07 13:42:12.000000000 -0800
@@ -619,8 +619,12 @@
 __SYSCALL(__NR_vmsplice, sys_vmsplice)
 #define __NR_move_pages		279
 __SYSCALL(__NR_move_pages, sys_move_pages)
+#define __NR_signalfd		280
+__SYSCALL(__NR_signalfd, sys_signalfd)
+#define __NR_signalfd_dequeue	281
+__SYSCALL(__NR_signalfd_dequeue, sys_signalfd_dequeue)
 
-#define __NR_syscall_max __NR_move_pages
+#define __NR_syscall_max __NR_signalfd_dequeue
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
Index: linux-2.6.20.ep2/arch/x86_64/ia32/ia32entry.S
===================================================================
--- linux-2.6.20.ep2.orig/arch/x86_64/ia32/ia32entry.S	2007-03-07 13:28:41.000000000 -0800
+++ linux-2.6.20.ep2/arch/x86_64/ia32/ia32entry.S	2007-03-07 13:42:12.000000000 -0800
@@ -714,8 +714,11 @@
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
+	.quad sys_signalfd_dequeue
+ia32_syscall_end:
