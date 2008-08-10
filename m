Return-Path: <linux-kernel-owner+w=401wt.eu-S1755110AbYHJMPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110AbYHJMPT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 08:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbYHJMPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 08:15:05 -0400
Received: from harold.telenet-ops.be ([195.130.133.65]:53802 "EHLO
	harold.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075AbYHJMPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 08:15:03 -0400
Date: Sun, 10 Aug 2008 14:15:01 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Ungerer <gerg@uclinux.org>
cc: Linux/m68k <linux-m68k@vger.kernel.org>,
       uClinux list <uclinux-dev@uclinux.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] m68k{,nommu}: Wire up new system calls
Message-ID: <Pine.LNX.4.64.0808101413390.10672@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wire up for m68k{,nommu} the system calls that were added in the last merge
window:

commit 4006553b06306b34054529477b06b68a1c66249b (flag parameters: inotify_init)
commit ed8cae8ba01348bfd83333f4648dd807b04d7f08 (flag parameters: pipe)
commit 336dd1f70ff62d7dd8655228caed4c5bfc818c56 (flag parameters: dup2)
commit a0998b50c3f0b8fdd265c63e0032f86ebe377dbf (flag parameters: epoll_create)
commit 9fe5ad9c8cef9ad5873d8ee55d1cf00d9b607df0 (flag parameters add-on: remove
						 epoll_create size param)
commit b087498eb5605673b0f260a7620d91818cd72304 (flag parameters: eventfd)
commit 9deb27baedb79759c3ab9435a7d8b841842d56e9 (flag parameters: signalfd)

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
Greg, please ack or forward to Linus. Thx!

 arch/m68k/kernel/entry.S             |    6 ++++++
 arch/m68knommu/include/asm/unistd.h  |    8 +++++++-
 arch/m68knommu/kernel/syscalltable.S |    6 ++++++
 include/asm-m68k/unistd.h            |    8 +++++++-
 4 files changed, 26 insertions(+), 2 deletions(-)

--- a/arch/m68k/kernel/entry.S
+++ b/arch/m68k/kernel/entry.S
@@ -747,4 +747,10 @@ sys_call_table:
 	.long sys_fallocate		/* 320 */
 	.long sys_timerfd_settime
 	.long sys_timerfd_gettime
+	.long sys_signalfd4
+	.long sys_eventfd2
+	.long sys_epoll_create1		/* 325 */
+	.long sys_dup3
+	.long sys_pipe2
+	.long sys_inotify_init1
 
--- a/arch/m68knommu/include/asm/unistd.h
+++ b/arch/m68knommu/include/asm/unistd.h
@@ -326,10 +326,16 @@
 #define __NR_fallocate		320
 #define __NR_timerfd_settime	321
 #define __NR_timerfd_gettime	322
+#define __NR_signalfd4		323
+#define __NR_eventfd2		324
+#define __NR_epoll_create1	325
+#define __NR_dup3		326
+#define __NR_pipe2		327
+#define __NR_inotify_init1	328
 
 #ifdef __KERNEL__
 
-#define NR_syscalls		323
+#define NR_syscalls		329
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
--- a/arch/m68knommu/kernel/syscalltable.S
+++ b/arch/m68knommu/kernel/syscalltable.S
@@ -341,6 +341,12 @@ ENTRY(sys_call_table)
 	.long sys_fallocate		/* 320 */
 	.long sys_timerfd_settime
 	.long sys_timerfd_gettime
+	.long sys_signalfd4
+	.long sys_eventfd2
+	.long sys_epoll_create1		/* 325 */
+	.long sys_dup3
+	.long sys_pipe2
+	.long sys_inotify_init1
 
 	.rept NR_syscalls-(.-sys_call_table)/4
 		.long sys_ni_syscall
--- a/include/asm-m68k/unistd.h
+++ b/include/asm-m68k/unistd.h
@@ -325,10 +325,16 @@
 #define __NR_fallocate		320
 #define __NR_timerfd_settime	321
 #define __NR_timerfd_gettime	322
+#define __NR_signalfd4		323
+#define __NR_eventfd2		324
+#define __NR_epoll_create1	325
+#define __NR_dup3		326
+#define __NR_pipe2		327
+#define __NR_inotify_init1	328
 
 #ifdef __KERNEL__
 
-#define NR_syscalls		323
+#define NR_syscalls		329
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
