Return-Path: <linux-kernel-owner+w=401wt.eu-S1753472AbXCPA1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbXCPA1A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 20:27:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477AbXCPA0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 20:26:35 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:47056 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470AbXCPA0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 20:26:30 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
Date: Thu, 15 Mar 2007 17:22:15 -0700
Subject: [patch 3/13] signal/timer/event fds v6 - signalfd wire up i386 arch ...
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.9367.1174004536.3>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch wire the signalfd system call to the i386 architecture.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide



Index: linux-2.6.21-rc3.quilt/arch/i386/kernel/syscall_table.S
===================================================================
--- linux-2.6.21-rc3.quilt.orig/arch/i386/kernel/syscall_table.S	2007-02-04 10:44:54.000000000 -0800
+++ linux-2.6.21-rc3.quilt/arch/i386/kernel/syscall_table.S	2007-03-15 15:34:12.000000000 -0700
@@ -319,3 +319,4 @@
 	.long sys_move_pages
 	.long sys_getcpu
 	.long sys_epoll_pwait
+	.long sys_signalfd		/* 320 */
Index: linux-2.6.21-rc3.quilt/include/asm-i386/unistd.h
===================================================================
--- linux-2.6.21-rc3.quilt.orig/include/asm-i386/unistd.h	2007-02-04 10:44:54.000000000 -0800
+++ linux-2.6.21-rc3.quilt/include/asm-i386/unistd.h	2007-03-15 15:34:12.000000000 -0700
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

