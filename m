Return-Path: <linux-kernel-owner+w=401wt.eu-S1758894AbXF2Vv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758894AbXF2Vv3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 17:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756811AbXF2Vtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 17:49:55 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:2554 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755600AbXF2Vty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 17:49:54 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@gmail.com>, Ingo Molnar <mingo@elte.hu>
Date: Fri, 29 Jun 2007 14:48:52 -0700
Subject: [patch 5/6] sys_indirect RFC - wire x86 sys_indirect
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.28360.1183153738.5>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Wires sys_indirect() to the x86 family arch.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


---
 arch/i386/kernel/syscall_table.S |    1 +
 arch/x86_64/ia32/ia32entry.S     |    1 +
 include/asm-i386/unistd.h        |    4 +++-
 include/asm-x86_64/unistd.h      |    3 +++
 4 files changed, 8 insertions(+), 1 deletion(-)

Index: linux-2.6.mod/include/asm-i386/unistd.h
===================================================================
--- linux-2.6.mod.orig/include/asm-i386/unistd.h	2007-06-29 12:12:48.000000000 -0700
+++ linux-2.6.mod/include/asm-i386/unistd.h	2007-06-29 12:14:01.000000000 -0700
@@ -329,10 +329,11 @@
 #define __NR_signalfd		321
 #define __NR_timerfd		322
 #define __NR_eventfd		323
+#define __NR_indirect		324
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 324
+#define NR_syscalls 325
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
@@ -379,6 +380,7 @@
 	case __NR_rt_sigsuspend:
 	case __NR_sigaltstack:
 	case __NR_iopl:
+	case __NR_indirect:
 		return 0;
 	}
 	return 1;
Index: linux-2.6.mod/arch/i386/kernel/syscall_table.S
===================================================================
--- linux-2.6.mod.orig/arch/i386/kernel/syscall_table.S	2007-06-29 12:12:41.000000000 -0700
+++ linux-2.6.mod/arch/i386/kernel/syscall_table.S	2007-06-29 12:14:01.000000000 -0700
@@ -323,3 +323,4 @@
 	.long sys_signalfd
 	.long sys_timerfd
 	.long sys_eventfd
+	.long sys_indirect
Index: linux-2.6.mod/include/asm-x86_64/unistd.h
===================================================================
--- linux-2.6.mod.orig/include/asm-x86_64/unistd.h	2007-06-29 12:13:34.000000000 -0700
+++ linux-2.6.mod/include/asm-x86_64/unistd.h	2007-06-29 12:14:01.000000000 -0700
@@ -630,6 +630,8 @@
 __SYSCALL(__NR_timerfd, sys_timerfd)
 #define __NR_eventfd		284
 __SYSCALL(__NR_eventfd, sys_eventfd)
+#define __NR_indirect		284
+__SYSCALL(__NR_indirect, sys_indirect)
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
@@ -681,6 +683,7 @@
 	case __NR_rt_sigsuspend:
 	case __NR_sigaltstack:
 	case __NR_iopl:
+	case __NR_indirect:
 		return 0;
 	}
 	return 1;
Index: linux-2.6.mod/arch/x86_64/ia32/ia32entry.S
===================================================================
--- linux-2.6.mod.orig/arch/x86_64/ia32/ia32entry.S	2007-06-29 12:13:34.000000000 -0700
+++ linux-2.6.mod/arch/x86_64/ia32/ia32entry.S	2007-06-29 12:14:01.000000000 -0700
@@ -737,4 +737,5 @@
 	.quad compat_sys_signalfd
 	.quad compat_sys_timerfd
 	.quad sys_eventfd
+	.quad compat_sys_indirect
 ia32_syscall_end:

