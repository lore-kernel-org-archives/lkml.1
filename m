Return-Path: <linux-kernel-owner+w=401wt.eu-S932494AbZHUUHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932494AbZHUUHF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 16:07:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932441AbZHUUHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 16:07:03 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:56815 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932433AbZHUUHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 16:07:01 -0400
Date: Fri, 21 Aug 2009 22:07:00 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux/m68k <linux-m68k@vger.kernel.org>, Greg Ungerer <gerg@uclinux.org>
cc: uClinux list <uclinux-dev@uclinux.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] m68k,m68knommu: Wire up rt_tgsigqueueinfo and
 perf_counter_open
Message-ID: <alpine.DEB.2.00.0908212205300.15620@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Ungerer <gerg@uclinux.org>
---
 arch/m68k/include/asm/unistd.h       |    4 +++-
 arch/m68k/kernel/entry.S             |    2 ++
 arch/m68knommu/kernel/syscalltable.S |    2 ++
 3 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/m68k/include/asm/unistd.h b/arch/m68k/include/asm/unistd.h
index aa29a86..946d869 100644
--- a/arch/m68k/include/asm/unistd.h
+++ b/arch/m68k/include/asm/unistd.h
@@ -334,10 +334,12 @@
 #define __NR_inotify_init1	328
 #define __NR_preadv		329
 #define __NR_pwritev		330
+#define __NR_rt_tgsigqueueinfo	331
+#define __NR_perf_counter_open	332
 
 #ifdef __KERNEL__
 
-#define NR_syscalls		331
+#define NR_syscalls		333
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/m68k/kernel/entry.S b/arch/m68k/kernel/entry.S
index 8744f60..c3735cd 100644
--- a/arch/m68k/kernel/entry.S
+++ b/arch/m68k/kernel/entry.S
@@ -755,4 +755,6 @@ sys_call_table:
 	.long sys_inotify_init1
 	.long sys_preadv
 	.long sys_pwritev		/* 330 */
+	.long sys_rt_tgsigqueueinfo
+	.long sys_perf_counter_open
 
diff --git a/arch/m68knommu/kernel/syscalltable.S b/arch/m68knommu/kernel/syscalltable.S
index c0b8782..0ae123e 100644
--- a/arch/m68knommu/kernel/syscalltable.S
+++ b/arch/m68knommu/kernel/syscalltable.S
@@ -349,6 +349,8 @@ ENTRY(sys_call_table)
 	.long sys_inotify_init1
 	.long sys_preadv
 	.long sys_pwritev		/* 330 */
+	.long sys_rt_tgsigqueueinfo
+	.long sys_perf_counter_open
 
 	.rept NR_syscalls-(.-sys_call_table)/4
 		.long sys_ni_syscall
-- 
1.6.0.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
