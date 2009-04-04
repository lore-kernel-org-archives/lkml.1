Return-Path: <linux-kernel-owner+w=401wt.eu-S1757397AbZDDVDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397AbZDDVDn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 17:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756320AbZDDVDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 17:03:04 -0400
Received: from www.tglx.de ([62.245.132.106]:54167 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756707AbZDDVDB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 17:03:01 -0400
Message-Id: <20090404201649.675388707@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sat, 04 Apr 2009 21:01:10 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@osdl.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Roland McGrath <roland@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Ingo Molnar <mingo@elte.hu>,
       Michael Kerrisk <mtk.manpages@googlemail.com>
Subject: [patch 3/3] x86: hookup sys_rt_tgsigqueueinfo
References: <20090404201641.328118982@linutronix.de>
Content-Disposition: inline; filename=x86-hookup-sys-rt-tgsigqueueinfo.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/ia32/ia32entry.S          |    1 +
 arch/x86/include/asm/unistd_32.h   |    1 +
 arch/x86/include/asm/unistd_64.h   |    2 ++
 arch/x86/kernel/syscall_table_32.S |    1 +
 4 files changed, 5 insertions(+)

Index: linux-2.6/arch/x86/ia32/ia32entry.S
===================================================================
--- linux-2.6.orig/arch/x86/ia32/ia32entry.S
+++ linux-2.6/arch/x86/ia32/ia32entry.S
@@ -830,4 +830,5 @@ ia32_sys_call_table:
 	.quad sys_inotify_init1
 	.quad compat_sys_preadv
 	.quad compat_sys_pwritev
+ 	.quad compat_sys_rt_tgsigqueueinfo	/* 335 */
 ia32_syscall_end:
Index: linux-2.6/arch/x86/include/asm/unistd_32.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/unistd_32.h
+++ linux-2.6/arch/x86/include/asm/unistd_32.h
@@ -340,6 +340,7 @@
 #define __NR_inotify_init1	332
 #define __NR_preadv		333
 #define __NR_pwritev		334
+#define __NR_rt_tgsigqueueinfo	335
 
 #ifdef __KERNEL__
 
Index: linux-2.6/arch/x86/include/asm/unistd_64.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/unistd_64.h
+++ linux-2.6/arch/x86/include/asm/unistd_64.h
@@ -657,6 +657,8 @@ __SYSCALL(__NR_inotify_init1, sys_inotif
 __SYSCALL(__NR_preadv, sys_preadv)
 #define __NR_pwritev				296
 __SYSCALL(__NR_pwritev, sys_pwritev)
+#define __NR_rt_tgsigqueueinfo			297
+__SYSCALL(__NR_rt_tgsigqueueinfo, sys_rt_tgsigqueueinfo)
 
 
 #ifndef __NO_STUBS
Index: linux-2.6/arch/x86/kernel/syscall_table_32.S
===================================================================
--- linux-2.6.orig/arch/x86/kernel/syscall_table_32.S
+++ linux-2.6/arch/x86/kernel/syscall_table_32.S
@@ -334,3 +334,4 @@ ENTRY(sys_call_table)
 	.long sys_inotify_init1
 	.long sys_preadv
 	.long sys_pwritev
+ 	.long sys_rt_tgsigqueueinfo	/* 335 */


