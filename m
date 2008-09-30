Return-Path: <linux-kernel-owner+w=401wt.eu-S1754657AbYI3TuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbYI3TuT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 15:50:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754023AbYI3Tta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 15:49:30 -0400
Received: from www.tglx.de ([62.245.132.106]:58424 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753960AbYI3Tt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 15:49:29 -0400
Message-Id: <20080930194516.995453826@linutronix.de>
User-Agent: quilt/0.47-1
Date: Tue, 30 Sep 2008 19:49:04 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Ulrich Drepper <drepper@redhat.com>,
       Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Michael Kerrisk <mtk.manpages@googlemail.com>
Subject: [RFC patch 3/3] x86: hookup sys_rt_tgsigqueueinfo
References: <20080930194445.978351700@linutronix.de>
Content-Disposition: inline; filename=x86-hookup-rt-tgsigqueueinfo.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the new sys_rt_tgsigqueueinfo available for x86.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/syscall_table_32.S |    1 +
 include/asm-x86/unistd_32.h        |    1 +
 include/asm-x86/unistd_64.h        |    2 ++
 3 files changed, 4 insertions(+)

Index: linux-2.6-tip/arch/x86/kernel/syscall_table_32.S
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/syscall_table_32.S
+++ linux-2.6-tip/arch/x86/kernel/syscall_table_32.S
@@ -332,3 +332,4 @@ ENTRY(sys_call_table)
 	.long sys_dup3			/* 330 */
 	.long sys_pipe2
 	.long sys_inotify_init1
+	.long sys_rt_tgsigqueueinfo
Index: linux-2.6-tip/include/asm-x86/unistd_32.h
===================================================================
--- linux-2.6-tip.orig/include/asm-x86/unistd_32.h
+++ linux-2.6-tip/include/asm-x86/unistd_32.h
@@ -338,6 +338,7 @@
 #define __NR_dup3		330
 #define __NR_pipe2		331
 #define __NR_inotify_init1	332
+#define __NR_rt_tgsigqueueinfo	333
 
 #ifdef __KERNEL__
 
Index: linux-2.6-tip/include/asm-x86/unistd_64.h
===================================================================
--- linux-2.6-tip.orig/include/asm-x86/unistd_64.h
+++ linux-2.6-tip/include/asm-x86/unistd_64.h
@@ -653,6 +653,8 @@ __SYSCALL(__NR_dup3, sys_dup3)
 __SYSCALL(__NR_pipe2, sys_pipe2)
 #define __NR_inotify_init1			294
 __SYSCALL(__NR_inotify_init1, sys_inotify_init1)
+#define __NR_rt_tgsigqueueinfo			295
+__SYSCALL(__NR_rt_tgsigqueueinfo, sys_rt_tgsigqueueinfo)
 
 
 #ifndef __NO_STUBS


