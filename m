Return-Path: <linux-kernel-owner+w=401wt.eu-S1756043AbYLOLjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043AbYLOLjn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 06:39:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754658AbYLOLip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 06:38:45 -0500
Received: from mx2.redhat.com ([66.187.237.31]:35815 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754544AbYLOLin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 06:38:43 -0500
From: Gerd Hoffmann <kraxel@redhat.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       linux-api@vger.kernel.org
Cc: Ralf Baechle <ralf@linux-mips.org>, Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH v3 3/3] MIPS: Add preadv(2) and pwritev(2) syscalls.
Date: Mon, 15 Dec 2008 12:36:17 +0100
Message-Id: <1229340977-24345-4-git-send-email-kraxel@redhat.com>
In-Reply-To: <1229340977-24345-1-git-send-email-kraxel@redhat.com>
References: <1229340977-24345-1-git-send-email-kraxel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ralf Baechle <ralf@linux-mips.org>

From: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 arch/mips/include/asm/unistd.h |   18 ++++++++++++------
 arch/mips/kernel/scall32-o32.S |    2 ++
 arch/mips/kernel/scall64-64.S  |    2 ++
 arch/mips/kernel/scall64-n32.S |    2 ++
 arch/mips/kernel/scall64-o32.S |    2 ++
 5 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/arch/mips/include/asm/unistd.h b/arch/mips/include/asm/unistd.h
index a73e153..4000501 100644
--- a/arch/mips/include/asm/unistd.h
+++ b/arch/mips/include/asm/unistd.h
@@ -350,16 +350,18 @@
 #define __NR_dup3			(__NR_Linux + 327)
 #define __NR_pipe2			(__NR_Linux + 328)
 #define __NR_inotify_init1		(__NR_Linux + 329)
+#define __NR_preadv			(__NR_Linux + 330)
+#define __NR_pwritev			(__NR_Linux + 331)
 
 /*
  * Offset of the last Linux o32 flavoured syscall
  */
-#define __NR_Linux_syscalls		329
+#define __NR_Linux_syscalls		331
 
 #endif /* _MIPS_SIM == _MIPS_SIM_ABI32 */
 
 #define __NR_O32_Linux			4000
-#define __NR_O32_Linux_syscalls		329
+#define __NR_O32_Linux_syscalls		331
 
 #if _MIPS_SIM == _MIPS_SIM_ABI64
 
@@ -656,16 +658,18 @@
 #define __NR_dup3			(__NR_Linux + 286)
 #define __NR_pipe2			(__NR_Linux + 287)
 #define __NR_inotify_init1		(__NR_Linux + 288)
+#define __NR_preadv			(__NR_Linux + 289)
+#define __NR_pwritev			(__NR_Linux + 290)
 
 /*
  * Offset of the last Linux 64-bit flavoured syscall
  */
-#define __NR_Linux_syscalls		288
+#define __NR_Linux_syscalls		290
 
 #endif /* _MIPS_SIM == _MIPS_SIM_ABI64 */
 
 #define __NR_64_Linux			5000
-#define __NR_64_Linux_syscalls		288
+#define __NR_64_Linux_syscalls		290
 
 #if _MIPS_SIM == _MIPS_SIM_NABI32
 
@@ -966,16 +970,18 @@
 #define __NR_dup3			(__NR_Linux + 290)
 #define __NR_pipe2			(__NR_Linux + 291)
 #define __NR_inotify_init1		(__NR_Linux + 292)
+#define __NR_preadv			(__NR_Linux + 293)
+#define __NR_pwritev			(__NR_Linux + 294)
 
 /*
  * Offset of the last N32 flavoured syscall
  */
-#define __NR_Linux_syscalls		292
+#define __NR_Linux_syscalls		294
 
 #endif /* _MIPS_SIM == _MIPS_SIM_NABI32 */
 
 #define __NR_N32_Linux			6000
-#define __NR_N32_Linux_syscalls		292
+#define __NR_N32_Linux_syscalls		294
 
 #ifdef __KERNEL__
 
diff --git a/arch/mips/kernel/scall32-o32.S b/arch/mips/kernel/scall32-o32.S
index d0916a5..4a8b3e8 100644
--- a/arch/mips/kernel/scall32-o32.S
+++ b/arch/mips/kernel/scall32-o32.S
@@ -650,6 +650,8 @@ einval:	li	v0, -ENOSYS
 	sys	sys_dup3		3
 	sys	sys_pipe2		2
 	sys	sys_inotify_init1	1
+	sys	sys_preadv		6	/* 4330 */
+	sys	sys_pwritev		6
 	.endm
 
 	/* We pre-compute the number of _instruction_ bytes needed to
diff --git a/arch/mips/kernel/scall64-64.S b/arch/mips/kernel/scall64-64.S
index a9e1716..217e3ce 100644
--- a/arch/mips/kernel/scall64-64.S
+++ b/arch/mips/kernel/scall64-64.S
@@ -487,4 +487,6 @@ sys_call_table:
 	PTR	sys_dup3
 	PTR	sys_pipe2
 	PTR	sys_inotify_init1
+	PTR	sys_preadv
+	PTR	sys_pwritev			/* 5390 */
 	.size	sys_call_table,.-sys_call_table
diff --git a/arch/mips/kernel/scall64-n32.S b/arch/mips/kernel/scall64-n32.S
index 30f3b63..f340963 100644
--- a/arch/mips/kernel/scall64-n32.S
+++ b/arch/mips/kernel/scall64-n32.S
@@ -413,4 +413,6 @@ EXPORT(sysn32_call_table)
 	PTR	sys_dup3			/* 5290 */
 	PTR	sys_pipe2
 	PTR	sys_inotify_init1
+	PTR	sys_preadv
+	PTR	sys_pwritev
 	.size	sysn32_call_table,.-sysn32_call_table
diff --git a/arch/mips/kernel/scall64-o32.S b/arch/mips/kernel/scall64-o32.S
index fefef4a..b1d281a 100644
--- a/arch/mips/kernel/scall64-o32.S
+++ b/arch/mips/kernel/scall64-o32.S
@@ -533,4 +533,6 @@ sys_call_table:
 	PTR	sys_dup3
 	PTR	sys_pipe2
 	PTR	sys_inotify_init1
+	PTR	compat_sys_preadv		/* 4330 */
+	PTR	compat_sys_pwritev
 	.size	sys_call_table,.-sys_call_table
-- 
1.5.6.5

