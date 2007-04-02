Return-Path: <linux-kernel-owner+w=401wt.eu-S966049AbXDBWrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966049AbXDBWrW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 18:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966042AbXDBWrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 18:47:20 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:50543 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966041AbXDBWqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 18:46:40 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 02 Apr 2007 15:46:31 -0700
Subject: [patch 7/13] signal/timer/event fds v10 - timerfd wire up i386 arch ...
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.10599.1175553995.7>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch wire the timerfd system call to the i386 architecture.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide



Index: linux-2.6.21-rc5.fds/arch/i386/kernel/syscall_table.S
===================================================================
--- linux-2.6.21-rc5.fds.orig/arch/i386/kernel/syscall_table.S	2007-04-02 15:06:33.000000000 -0700
+++ linux-2.6.21-rc5.fds/arch/i386/kernel/syscall_table.S	2007-04-02 15:06:39.000000000 -0700
@@ -320,3 +320,4 @@
 	.long sys_getcpu
 	.long sys_epoll_pwait
 	.long sys_signalfd		/* 320 */
+	.long sys_timerfd
Index: linux-2.6.21-rc5.fds/include/asm-i386/unistd.h
===================================================================
--- linux-2.6.21-rc5.fds.orig/include/asm-i386/unistd.h	2007-04-02 15:06:33.000000000 -0700
+++ linux-2.6.21-rc5.fds/include/asm-i386/unistd.h	2007-04-02 15:06:39.000000000 -0700
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

