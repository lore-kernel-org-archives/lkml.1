Return-Path: <linux-kernel-owner+w=401wt.eu-S1754062AbZBZNhD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062AbZBZNhD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 08:37:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753904AbZBZNgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 08:36:38 -0500
Received: from www.tglx.de ([62.245.132.106]:55713 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776AbZBZNgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 08:36:37 -0500
Message-Id: <20090226133430.949987377@linutronix.de>
User-Agent: quilt/0.47-1
Date: Thu, 26 Feb 2009 13:35:41 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 3/3] x86: hookup sys_rt_tgsigqueueinfo
References: <20090226133339.875832967@linutronix.de>
Content-Disposition: inline; filename=x86-hookup-rt-tgsigqueueinfo.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the new sys_rt_tgsigqueueinfo available for x86.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/ia32/ia32entry.S          |    1 +
 arch/x86/include/asm/unistd_32.h   |    1 +
 arch/x86/include/asm/unistd_64.h   |    2 ++
 arch/x86/kernel/syscall_table_32.S |    1 +
 4 files changed, 5 insertions(+)

Index: linux-2.6-tip/arch/x86/ia32/ia32entry.S
===================================================================
--- linux-2.6-tip.orig/arch/x86/ia32/ia32entry.S
+++ linux-2.6-tip/arch/x86/ia32/ia32entry.S
@@ -828,4 +828,5 @@ ia32_sys_call_table:
 	.quad sys_dup3			/* 330 */
 	.quad sys_pipe2
 	.quad sys_inotify_init1
+	.quad compat_sys_rt_tgsigqueueinfo
 ia32_syscall_end:
Index: linux-2.6-tip/arch/x86/include/asm/unistd_32.h
===================================================================
--- linux-2.6-tip.orig/arch/x86/include/asm/unistd_32.h
+++ linux-2.6-tip/arch/x86/include/asm/unistd_32.h
@@ -338,6 +338,7 @@
 #define __NR_dup3		330
 #define __NR_pipe2		331
 #define __NR_inotify_init1	332
+#define __NR_rt_tgsigqueueinfo	333
 
 #ifdef __KERNEL__
 
Index: linux-2.6-tip/arch/x86/include/asm/unistd_64.h
===================================================================
--- linux-2.6-tip.orig/arch/x86/include/asm/unistd_64.h
+++ linux-2.6-tip/arch/x86/include/asm/unistd_64.h
@@ -653,6 +653,8 @@ __SYSCALL(__NR_dup3, sys_dup3)
 __SYSCALL(__NR_pipe2, sys_pipe2)
 #define __NR_inotify_init1			294
 __SYSCALL(__NR_inotify_init1, sys_inotify_init1)
+#define __NR_rt_tgsigqueueinfo			295
+__SYSCALL(__NR_rt_tgsigqueueinfo, sys_rt_tgsigqueueinfo)
 
 
 #ifndef __NO_STUBS
Index: linux-2.6-tip/arch/x86/kernel/syscall_table_32.S
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/syscall_table_32.S
+++ linux-2.6-tip/arch/x86/kernel/syscall_table_32.S
@@ -332,3 +332,4 @@ ENTRY(sys_call_table)
 	.long sys_dup3			/* 330 */
 	.long sys_pipe2
 	.long sys_inotify_init1
+	.long sys_rt_tgsigqueueinfo


