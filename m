Return-Path: <linux-kernel-owner+w=401wt.eu-S966033AbXDBWrL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966033AbXDBWrL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 18:47:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966052AbXDBWrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 18:47:10 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:50577 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966047AbXDBWqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 18:46:48 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Suparna Bhattacharya <suparna@in.ibm.com>,
       Zach Brown <zach.brown@oracle.com>, Benjamin LaHaise <bcrl@kvack.org>
Date: Mon, 02 Apr 2007 15:46:31 -0700
Subject: [patch 12/13] signal/timer/event fds v10 - eventfd wire up x86_64 arch ...
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.10599.1175553997.12>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch wire the eventfd system call to the x86_64 architecture.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide



Index: linux-2.6.21-rc5.fds/arch/x86_64/ia32/ia32entry.S
===================================================================
--- linux-2.6.21-rc5.fds.orig/arch/x86_64/ia32/ia32entry.S	2007-04-02 15:06:40.000000000 -0700
+++ linux-2.6.21-rc5.fds/arch/x86_64/ia32/ia32entry.S	2007-04-02 15:06:46.000000000 -0700
@@ -721,4 +721,5 @@
 	.quad sys_epoll_pwait
 	.quad sys_signalfd		/* 320 */
 	.quad sys_timerfd
+	.quad sys_eventfd
 ia32_syscall_end:		
Index: linux-2.6.21-rc5.fds/include/asm-x86_64/unistd.h
===================================================================
--- linux-2.6.21-rc5.fds.orig/include/asm-x86_64/unistd.h	2007-04-02 15:06:40.000000000 -0700
+++ linux-2.6.21-rc5.fds/include/asm-x86_64/unistd.h	2007-04-02 15:06:46.000000000 -0700
@@ -623,8 +623,10 @@
 __SYSCALL(__NR_signalfd, sys_signalfd)
 #define __NR_timerfd		281
 __SYSCALL(__NR_timerfd, sys_timerfd)
+#define __NR_eventfd		282
+__SYSCALL(__NR_eventfd, sys_eventfd)
 
-#define __NR_syscall_max __NR_timerfd
+#define __NR_syscall_max __NR_eventfd
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR

