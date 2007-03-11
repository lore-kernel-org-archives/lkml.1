Return-Path: <linux-kernel-owner+w=401wt.eu-S932702AbXCKLcK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932702AbXCKLcK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 07:32:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932865AbXCKLcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 07:32:10 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:57704 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932702AbXCKLcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 07:32:06 -0400
Date: Sun, 11 Mar 2007 13:32:04 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: akpm@linux-foundation.org
cc: linux-kernel@vger.kernel.org, hch@infradead.org, alan@lxorguk.ukuu.org.uk
Subject: [PATCH 5/5] revoke: wire up i386 system calls
Message-ID: <Pine.LNX.4.64.0703111331440.765@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

Make revokeat and frevoke system calls available to user-space on i386.

Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 arch/i386/kernel/syscall_table.S |    3 +++
 include/asm-i386/unistd.h        |    4 +++-
 2 files changed, 6 insertions(+), 1 deletion(-)

Index: uml-2.6/arch/i386/kernel/syscall_table.S
===================================================================
--- uml-2.6.orig/arch/i386/kernel/syscall_table.S	2007-03-11 13:05:32.000000000 +0200
+++ uml-2.6/arch/i386/kernel/syscall_table.S	2007-03-11 13:09:23.000000000 +0200
@@ -319,3 +319,6 @@ 	.long sys_unshare		/* 310 */
 	.long sys_move_pages
 	.long sys_getcpu
 	.long sys_epoll_pwait
+ 	.long sys_revokeat		/* 320 */
+ 	.long sys_frevoke
+
Index: uml-2.6/include/asm-i386/unistd.h
===================================================================
--- uml-2.6.orig/include/asm-i386/unistd.h	2007-03-11 13:05:33.000000000 +0200
+++ uml-2.6/include/asm-i386/unistd.h	2007-03-11 13:09:23.000000000 +0200
@@ -325,10 +325,12 @@ #define __NR_unshare		310
 #define __NR_move_pages		317
 #define __NR_getcpu		318
 #define __NR_epoll_pwait	319
+#define __NR_revokeat		320
+#define __NR_frevoke		321
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 320
+#define NR_syscalls 322
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
