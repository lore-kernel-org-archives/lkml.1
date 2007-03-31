Return-Path: <linux-kernel-owner+w=401wt.eu-S1751224AbXCaUJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751224AbXCaUJd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 16:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbXCaUJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 16:09:33 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:48174 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbXCaUJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 16:09:31 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
Date: Sat, 31 Mar 2007 13:09:29 -0700
Subject: [patch 3/13] signal/timer/event fds v9 - signalfd wire up i386 arch ...
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.16816.1175371770.3>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch wire the signalfd system call to the i386 architecture.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide



Index: linux-2.6.21-rc5.fds/arch/i386/kernel/syscall_table.S
===================================================================
--- linux-2.6.21-rc5.fds.orig/arch/i386/kernel/syscall_table.S	2007-03-31 12:25:43.000000000 -0700
+++ linux-2.6.21-rc5.fds/arch/i386/kernel/syscall_table.S	2007-03-31 12:30:07.000000000 -0700
@@ -319,3 +319,4 @@
 	.long sys_move_pages
 	.long sys_getcpu
 	.long sys_epoll_pwait
+	.long sys_signalfd		/* 320 */
Index: linux-2.6.21-rc5.fds/include/asm-i386/unistd.h
===================================================================
--- linux-2.6.21-rc5.fds.orig/include/asm-i386/unistd.h	2007-03-31 12:25:43.000000000 -0700
+++ linux-2.6.21-rc5.fds/include/asm-i386/unistd.h	2007-03-31 12:30:07.000000000 -0700
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

