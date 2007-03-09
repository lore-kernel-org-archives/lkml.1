Return-Path: <linux-kernel-owner+w=401wt.eu-S1767662AbXCIXkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767662AbXCIXkn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 18:40:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767665AbXCIXkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 18:40:42 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:44195 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767662AbXCIXke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 18:40:34 -0500
X-AuthUser: davidel@xmailserver.org
Date: Fri, 9 Mar 2007 15:40:33 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [patch 3/9] signalfd/timerfd v1 - wire up signalfd i386 arch ...
Message-ID: <Pine.LNX.4.64.0703091532390.3761@alien.or.mcafeemobile.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch wire the signalfd system call to the i386 architecture.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide



Index: linux-2.6.20.ep2/arch/i386/kernel/syscall_table.S
===================================================================
--- linux-2.6.20.ep2.orig/arch/i386/kernel/syscall_table.S	2007-03-09 10:43:20.000000000 -0800
+++ linux-2.6.20.ep2/arch/i386/kernel/syscall_table.S	2007-03-09 10:56:00.000000000 -0800
@@ -319,3 +319,4 @@
 	.long sys_move_pages
 	.long sys_getcpu
 	.long sys_epoll_pwait
+	.long sys_signalfd		/* 320 */
Index: linux-2.6.20.ep2/include/asm-i386/unistd.h
===================================================================
--- linux-2.6.20.ep2.orig/include/asm-i386/unistd.h	2007-03-09 10:43:20.000000000 -0800
+++ linux-2.6.20.ep2/include/asm-i386/unistd.h	2007-03-09 10:56:00.000000000 -0800
@@ -325,10 +325,11 @@
 #define __NR_move_pages		317
 #define __NR_getcpu		318
 #define __NR_epoll_pwait	319
+#define __NR_signalfd		320
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 320
+#define NR_syscalls 321
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
