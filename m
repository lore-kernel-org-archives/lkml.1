Return-Path: <linux-kernel-owner+w=401wt.eu-S1765092AbXLNPSK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765092AbXLNPSK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 10:18:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762523AbXLNPRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 10:17:43 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:59122 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762230AbXLNPRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 10:17:41 -0500
Date: Fri, 14 Dec 2007 17:17:41 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: alan@redhat.com, viro@zeniv.linux.org.uk, hch@infradead.org,
       peterz@infradead.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: [RFC/PATCH 6/8] revoke: wire up i386 system call V7
Message-ID: <Pine.LNX.4.64.0712141717260.28689@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

Make revokeat system call available to user-space on i386.

[akpm@linux-foundation.org: fix 32-bit userspace]
Cc: Alan Cox <alan@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 arch/x86/ia32/ia32entry.S          |    1 +
 arch/x86/kernel/syscall_table_32.S |    1 +
 include/asm-x86/unistd_32.h        |    3 ++-
 3 files changed, 4 insertions(+), 1 deletion(-)

Index: 2.6/arch/x86/ia32/ia32entry.S
===================================================================
--- 2.6.orig/arch/x86/ia32/ia32entry.S	2007-11-23 09:58:11.000000000 +0200
+++ 2.6/arch/x86/ia32/ia32entry.S	2007-12-14 16:40:59.000000000 +0200
@@ -726,4 +726,5 @@ 	.quad compat_sys_utimensat	/* 320 */
 	.quad compat_sys_timerfd
 	.quad sys_eventfd
 	.quad sys32_fallocate
+	.quad sys_revokeat		/* 325 */
 ia32_syscall_end:
Index: 2.6/arch/x86/kernel/syscall_table_32.S
===================================================================
--- 2.6.orig/arch/x86/kernel/syscall_table_32.S	2007-11-23 09:58:11.000000000 +0200
+++ 2.6/arch/x86/kernel/syscall_table_32.S	2007-12-14 16:40:59.000000000 +0200
@@ -324,3 +324,4 @@ 	.long sys_utimensat		/* 320 */
 	.long sys_timerfd
 	.long sys_eventfd
 	.long sys_fallocate
+	.long sys_revokeat		/* 325 */
Index: 2.6/include/asm-x86/unistd_32.h
===================================================================
--- 2.6.orig/include/asm-x86/unistd_32.h	2007-11-23 09:58:11.000000000 +0200
+++ 2.6/include/asm-x86/unistd_32.h	2007-12-14 16:40:59.000000000 +0200
@@ -330,10 +330,11 @@ #define __NR_utimensat		320
 #define __NR_timerfd		322
 #define __NR_eventfd		323
 #define __NR_fallocate		324
+#define __NR_revokeat		325
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 325
+#define NR_syscalls 326
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
