Return-Path: <linux-kernel-owner+w=401wt.eu-S965569AbXCTSlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965569AbXCTSlp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 14:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965679AbXCTSlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 14:41:11 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:51443 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965618AbXCTSiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 14:38:01 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 20 Mar 2007 11:37:14 -0700
Subject: [patch 7/13] signal/timer/event fds v8 - timerfd wire up i386 arch ...
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.28743.1174415837.7>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch wire the timerfd system call to the i386 architecture.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide



Index: linux-2.6.21-rc3.quilt/arch/i386/kernel/syscall_table.S
===================================================================
--- linux-2.6.21-rc3.quilt.orig/arch/i386/kernel/syscall_table.S	2007-03-19 19:01:48.000000000 -0700
+++ linux-2.6.21-rc3.quilt/arch/i386/kernel/syscall_table.S	2007-03-19 19:01:54.000000000 -0700
@@ -320,3 +320,4 @@
 	.long sys_getcpu
 	.long sys_epoll_pwait
 	.long sys_signalfd		/* 320 */
+	.long sys_timerfd
Index: linux-2.6.21-rc3.quilt/include/asm-i386/unistd.h
===================================================================
--- linux-2.6.21-rc3.quilt.orig/include/asm-i386/unistd.h	2007-03-19 19:01:48.000000000 -0700
+++ linux-2.6.21-rc3.quilt/include/asm-i386/unistd.h	2007-03-19 19:01:54.000000000 -0700
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

