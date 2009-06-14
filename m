Return-Path: <linux-kernel-owner+w=401wt.eu-S1761833AbZFNMF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761833AbZFNMF2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 08:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758843AbZFNMBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 08:01:43 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:52688 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758593AbZFNMBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 08:01:41 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 15/17] Blackfin: convert types to asm-generic
Date: Sun, 14 Jun 2009 08:01:16 -0400
Message-Id: <1244980878-2124-16-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244980878-2124-1-git-send-email-vapier@gentoo.org>
References: <1244980878-2124-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/posix_types.h |   56 ++++++-------------------------
 arch/blackfin/include/asm/types.h       |   37 +--------------------
 2 files changed, 12 insertions(+), 81 deletions(-)

diff --git a/arch/blackfin/include/asm/posix_types.h b/arch/blackfin/include/asm/posix_types.h
index 23aa1f8..80c9d64 100644
--- a/arch/blackfin/include/asm/posix_types.h
+++ b/arch/blackfin/include/asm/posix_types.h
@@ -1,61 +1,27 @@
 #ifndef __ARCH_BFIN_POSIX_TYPES_H
 #define __ARCH_BFIN_POSIX_TYPES_H
 
-/*
- * This file is generally used by user-level software, so you need to
- * be a little careful about namespace pollution etc.  Also, we cannot
- * assume GCC is being used.
- */
-
-typedef unsigned long __kernel_ino_t;
 typedef unsigned short __kernel_mode_t;
+#define __kernel_mode_t __kernel_mode_t
+
 typedef unsigned short __kernel_nlink_t;
-typedef long __kernel_off_t;
-typedef int __kernel_pid_t;
+#define __kernel_nlink_t __kernel_nlink_t
+
 typedef unsigned int __kernel_ipc_pid_t;
-typedef unsigned int __kernel_uid_t;
-typedef unsigned int __kernel_gid_t;
+#define __kernel_ipc_pid_t __kernel_ipc_pid_t
+
 typedef unsigned long __kernel_size_t;
 typedef long __kernel_ssize_t;
 typedef int __kernel_ptrdiff_t;
-typedef long __kernel_time_t;
-typedef long __kernel_suseconds_t;
-typedef long __kernel_clock_t;
-typedef int __kernel_timer_t;
-typedef int __kernel_clockid_t;
-typedef int __kernel_daddr_t;
-typedef char *__kernel_caddr_t;
-typedef unsigned short __kernel_uid16_t;
-typedef unsigned short __kernel_gid16_t;
-typedef unsigned int __kernel_uid32_t;
-typedef unsigned int __kernel_gid32_t;
+#define __kernel_size_t __kernel_size_t
 
 typedef unsigned short __kernel_old_uid_t;
 typedef unsigned short __kernel_old_gid_t;
-typedef unsigned short __kernel_old_dev_t;
-
-#ifdef __GNUC__
-typedef long long __kernel_loff_t;
-#endif
+#define __kernel_old_uid_t __kernel_old_uid_t
 
-typedef struct {
-	int val[2];
-} __kernel_fsid_t;
-
-#if defined(__KERNEL__)
-
-#undef	__FD_SET
-#define	__FD_SET(d, set)	((set)->fds_bits[__FDELT(d)] |= __FDMASK(d))
-
-#undef	__FD_CLR
-#define	__FD_CLR(d, set)	((set)->fds_bits[__FDELT(d)] &= ~__FDMASK(d))
-
-#undef	__FD_ISSET
-#define	__FD_ISSET(d, set)	((set)->fds_bits[__FDELT(d)] & __FDMASK(d))
-
-#undef	__FD_ZERO
-#define __FD_ZERO(fdsetp) (memset (fdsetp, 0, sizeof(*(fd_set *)fdsetp)))
+typedef unsigned short __kernel_old_dev_t;
+#define __kernel_old_dev_t __kernel_old_dev_t
 
-#endif				/* defined(__KERNEL__) */
+#include <asm-generic/posix_types.h>
 
 #endif
diff --git a/arch/blackfin/include/asm/types.h b/arch/blackfin/include/asm/types.h
index 8441cbc..b9e79bc 100644
--- a/arch/blackfin/include/asm/types.h
+++ b/arch/blackfin/include/asm/types.h
@@ -1,36 +1 @@
-#ifndef _BFIN_TYPES_H
-#define _BFIN_TYPES_H
-
-/*
- * This file is never included by application software unless
- * explicitly requested (e.g., via linux/types.h) in which case the
- * application is Linux specific so (user-) name space pollution is
- * not a major issue.  However, for interoperability, libraries still
- * need to be careful to avoid a name clashes.
- */
-#include <asm-generic/int-ll64.h>
-
-#ifndef __ASSEMBLY__
-
-typedef unsigned short umode_t;
-
-#endif				/* __ASSEMBLY__ */
-/*
- * These aren't exported outside the kernel to avoid name space clashes
- */
-#ifdef __KERNEL__
-
-#define BITS_PER_LONG 32
-
-#ifndef __ASSEMBLY__
-
-/* Dma addresses are 32-bits wide.  */
-
-typedef u32 dma_addr_t;
-typedef u64 dma64_addr_t;
-
-#endif				/* __ASSEMBLY__ */
-
-#endif				/* __KERNEL__ */
-
-#endif				/* _BFIN_TYPES_H */
+#include <asm-generic/types.h>
-- 
1.6.3.1

