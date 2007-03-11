Return-Path: <linux-kernel-owner+w=401wt.eu-S932750AbXCKCX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932750AbXCKCX3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 21:23:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932722AbXCKCXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 21:23:19 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:46910 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932688AbXCKCWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 21:22:47 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sat, 10 Mar 2007 18:22:45 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [patch 7/9] signalfd/timerfd - timerfd wire up i386 arch ...
Message-ID: <Pine.LNX.4.64.0703101822420.3613@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch wire the timerfd system call to the i386 architecture.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide



Index: linux-2.6.20.ep2/arch/i386/kernel/syscall_table.S
===================================================================
--- linux-2.6.20.ep2.orig/arch/i386/kernel/syscall_table.S	2007-03-10 15:57:58.000000000 -0800
+++ linux-2.6.20.ep2/arch/i386/kernel/syscall_table.S	2007-03-10 15:58:08.000000000 -0800
@@ -320,3 +320,4 @@
 	.long sys_getcpu
 	.long sys_epoll_pwait
 	.long sys_signalfd		/* 320 */
+	.long sys_timerfd
Index: linux-2.6.20.ep2/include/asm-i386/unistd.h
===================================================================
--- linux-2.6.20.ep2.orig/include/asm-i386/unistd.h	2007-03-10 15:57:58.000000000 -0800
+++ linux-2.6.20.ep2/include/asm-i386/unistd.h	2007-03-10 15:58:08.000000000 -0800
@@ -326,10 +326,11 @@
 #define __NR_getcpu		318
 #define __NR_epoll_pwait	319
 #define __NR_signalfd		320
+#define __NR_timerfd		321
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 321
+#define NR_syscalls 322
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
