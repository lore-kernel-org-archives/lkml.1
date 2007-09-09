Return-Path: <linux-kernel-owner+w=401wt.eu-S1756822AbXIIJeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822AbXIIJeV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 05:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755986AbXIIJeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 05:34:11 -0400
Received: from hoboe2bl1.telenet-ops.be ([195.130.137.73]:43178 "EHLO
	hoboe2bl1.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755960AbXIIJeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 05:34:09 -0400
Date: Sun, 9 Sep 2007 11:33:57 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Ungerer <gerg@snapgear.com>, Linux/m68k <linux-m68k@vger.kernel.org>,
       uClinux list <uclinux-dev@uclinux.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] m68k(nommu): Add missing syscalls
Message-ID: <Pine.LNX.4.64.0709091130050.6425@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

m68k(nommu): Add missing syscalls

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/kernel/entry.S             |   10 ++++++++++
 arch/m68knommu/kernel/syscalltable.S |   10 ++++++++++
 include/asm-m68k/unistd.h            |   12 +++++++++++-
 include/asm-m68knommu/unistd.h       |   12 +++++++++++-
 4 files changed, 42 insertions(+), 2 deletions(-)

--- a/arch/m68k/kernel/entry.S
+++ b/arch/m68k/kernel/entry.S
@@ -735,4 +735,14 @@ sys_call_table:
 	.long sys_tee
 	.long sys_vmsplice
 	.long sys_move_pages		/* 310 */
+	.long sys_sched_setaffinity
+	.long sys_sched_getaffinity
+	.long sys_kexec_load
+	.long sys_getcpu
+	.long sys_epoll_pwait		/* 315 */
+	.long sys_utimensat
+	.long sys_signalfd
+	.long sys_timerfd
+	.long sys_eventfd
+	.long sys_fallocate		/* 320 */
 
--- a/arch/m68knommu/kernel/syscalltable.S
+++ b/arch/m68knommu/kernel/syscalltable.S
@@ -329,6 +329,16 @@ ENTRY(sys_call_table)
 	.long sys_tee
 	.long sys_vmsplice
 	.long sys_move_pages		/* 310 */
+	.long sys_sched_setaffinity
+	.long sys_sched_getaffinity
+	.long sys_kexec_load
+	.long sys_getcpu
+	.long sys_epoll_pwait		/* 315 */
+	.long sys_utimensat
+	.long sys_signalfd
+	.long sys_timerfd
+	.long sys_eventfd
+	.long sys_fallocate		/* 320 */
 
 	.rept NR_syscalls-(.-sys_call_table)/4
 		.long sys_ni_syscall
--- a/include/asm-m68k/unistd.h
+++ b/include/asm-m68k/unistd.h
@@ -313,10 +313,20 @@
 #define __NR_tee		308
 #define __NR_vmsplice		309
 #define __NR_move_pages		310
+#define __NR_sched_setaffinity	311
+#define __NR_sched_getaffinity	312
+#define __NR_kexec_load		313
+#define __NR_getcpu		314
+#define __NR_epoll_pwait	315
+#define __NR_utimensat		316
+#define __NR_signalfd		317
+#define __NR_timerfd		318
+#define __NR_eventfd		319
+#define __NR_fallocate		320
 
 #ifdef __KERNEL__
 
-#define NR_syscalls		311
+#define NR_syscalls		321
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
--- a/include/asm-m68knommu/unistd.h
+++ b/include/asm-m68knommu/unistd.h
@@ -314,10 +314,20 @@
 #define __NR_tee		308
 #define __NR_vmsplice		309
 #define __NR_move_pages		310
+#define __NR_sched_setaffinity	311
+#define __NR_sched_getaffinity	312
+#define __NR_kexec_load		313
+#define __NR_getcpu		314
+#define __NR_epoll_pwait	315
+#define __NR_utimensat		316
+#define __NR_signalfd		317
+#define __NR_timerfd		318
+#define __NR_eventfd		319
+#define __NR_fallocate		320
 
 #ifdef __KERNEL__
 
-#define NR_syscalls		311
+#define NR_syscalls		321
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
