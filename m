Return-Path: <linux-kernel-owner+w=401wt.eu-S1765837AbXF1Sua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765837AbXF1Sua (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 14:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765147AbXF1Stc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 14:49:32 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:4285 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764975AbXF1Sta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 14:49:30 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Rik van Riel <riel@redhat.com>, Andy Isaacson <adi@hexapodia.org>
Date: Thu, 28 Jun 2007 11:49:24 -0700
Subject: [patch 3/4] MAP_NOZERO v2 - wire sys_brk2() to the x86 family
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.5792.1183056569.3>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Wires up sys_brk2() to the x86 family.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


---
 arch/i386/kernel/syscall_table.S |    1 +
 arch/x86_64/ia32/ia32entry.S     |    1 +
 include/asm-i386/unistd.h        |    3 ++-
 include/asm-x86_64/unistd.h      |    2 ++
 4 files changed, 6 insertions(+), 1 deletion(-)

Index: linux-2.6.mod/arch/i386/kernel/syscall_table.S
===================================================================
--- linux-2.6.mod.orig/arch/i386/kernel/syscall_table.S	2007-06-27 22:41:31.000000000 -0700
+++ linux-2.6.mod/arch/i386/kernel/syscall_table.S	2007-06-28 11:08:52.000000000 -0700
@@ -323,3 +323,4 @@
 	.long sys_signalfd
 	.long sys_timerfd
 	.long sys_eventfd
+	.long sys_brk2
Index: linux-2.6.mod/arch/x86_64/ia32/ia32entry.S
===================================================================
--- linux-2.6.mod.orig/arch/x86_64/ia32/ia32entry.S	2007-06-27 22:41:31.000000000 -0700
+++ linux-2.6.mod/arch/x86_64/ia32/ia32entry.S	2007-06-28 11:08:52.000000000 -0700
@@ -719,4 +719,5 @@
 	.quad compat_sys_signalfd
 	.quad compat_sys_timerfd
 	.quad sys_eventfd
+	.quad sys_brk2
 ia32_syscall_end:
Index: linux-2.6.mod/include/asm-i386/unistd.h
===================================================================
--- linux-2.6.mod.orig/include/asm-i386/unistd.h	2007-06-27 22:41:31.000000000 -0700
+++ linux-2.6.mod/include/asm-i386/unistd.h	2007-06-28 11:08:52.000000000 -0700
@@ -329,10 +329,11 @@
 #define __NR_signalfd		321
 #define __NR_timerfd		322
 #define __NR_eventfd		323
+#define __NR_brk2		324
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 324
+#define NR_syscalls 325
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
Index: linux-2.6.mod/include/asm-x86_64/unistd.h
===================================================================
--- linux-2.6.mod.orig/include/asm-x86_64/unistd.h	2007-06-27 22:41:31.000000000 -0700
+++ linux-2.6.mod/include/asm-x86_64/unistd.h	2007-06-28 11:08:52.000000000 -0700
@@ -630,6 +630,8 @@
 __SYSCALL(__NR_timerfd, sys_timerfd)
 #define __NR_eventfd		284
 __SYSCALL(__NR_eventfd, sys_eventfd)
+#define __NR_brk2		285
+__SYSCALL(__NR_brk2, sys_brk2)
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR

