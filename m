Return-Path: <linux-kernel-owner+w=401wt.eu-S1756712AbZFRIot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712AbZFRIot (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 04:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755994AbZFRIo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 04:44:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:46678 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755013AbZFRIoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 04:44:25 -0400
Subject: [PATCH 2/5 -tip] x86: move common typedefs to asm/posix_types.h
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86 maintainers <x86@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1245314443.31204.9.camel@ht.satnam>
References: <1245314365.31204.7.camel@ht.satnam>
	 <1245314443.31204.9.camel@ht.satnam>
Content-Type: text/plain
Date: Thu, 18 Jun 2009 14:11:24 +0530
Message-Id: <1245314484.31204.10.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Move common typedefs to asm/posix_types.h for easy maintenance

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/posix_types.h    |   32 ++++++++++++++++++++++++++++++++
 arch/x86/include/asm/posix_types_32.h |   31 -------------------------------
 arch/x86/include/asm/posix_types_64.h |   32 --------------------------------
 3 files changed, 32 insertions(+), 63 deletions(-)

diff --git a/arch/x86/include/asm/posix_types.h b/arch/x86/include/asm/posix_types.h
index cb0a581..8fb98cc 100644
--- a/arch/x86/include/asm/posix_types.h
+++ b/arch/x86/include/asm/posix_types.h
@@ -1,6 +1,38 @@
 #ifndef _ASM_X86_POSIX_TYPES_H
 #define _ASM_X86_POSIX_TYPES_H
 
+/*
+ * This file is generally used by user-level software, so you need to
+ * be a little careful about namespace pollution etc.  Also, we cannot
+ * assume GCC is being used.
+ */
+
+typedef unsigned long	__kernel_ino_t;
+typedef long		__kernel_off_t;
+typedef int		__kernel_pid_t;
+typedef long		__kernel_time_t;
+typedef long		__kernel_suseconds_t;
+typedef long		__kernel_clock_t;
+typedef int		__kernel_timer_t;
+typedef int		__kernel_clockid_t;
+typedef int		__kernel_daddr_t;
+typedef char *		__kernel_caddr_t;
+typedef unsigned short	__kernel_uid16_t;
+typedef unsigned short	__kernel_gid16_t;
+typedef unsigned int	__kernel_uid32_t;
+typedef unsigned int	__kernel_gid32_t;
+
+typedef unsigned short	__kernel_old_uid_t;
+typedef unsigned short	__kernel_old_gid_t;
+
+#ifdef __GNUC__
+typedef long long	__kernel_loff_t;
+#endif
+
+typedef struct {
+	int	val[2];
+} __kernel_fsid_t;
+
 # if defined(CONFIG_X86_32) || defined(__i386__)
 #  include "posix_types_32.h"
 # else
diff --git a/arch/x86/include/asm/posix_types_32.h b/arch/x86/include/asm/posix_types_32.h
index f7d9adf..bc5958e 100644
--- a/arch/x86/include/asm/posix_types_32.h
+++ b/arch/x86/include/asm/posix_types_32.h
@@ -1,47 +1,17 @@
 #ifndef _ASM_X86_POSIX_TYPES_32_H
 #define _ASM_X86_POSIX_TYPES_32_H
 
-/*
- * This file is generally used by user-level software, so you need to
- * be a little careful about namespace pollution etc.  Also, we cannot
- * assume GCC is being used.
- */
-
-typedef unsigned long	__kernel_ino_t;
 typedef unsigned short	__kernel_mode_t;
 typedef unsigned short	__kernel_nlink_t;
-typedef long		__kernel_off_t;
-typedef int		__kernel_pid_t;
 typedef unsigned short	__kernel_ipc_pid_t;
 typedef unsigned short	__kernel_uid_t;
 typedef unsigned short	__kernel_gid_t;
 typedef unsigned int	__kernel_size_t;
 typedef int		__kernel_ssize_t;
 typedef int		__kernel_ptrdiff_t;
-typedef long		__kernel_time_t;
-typedef long		__kernel_suseconds_t;
-typedef long		__kernel_clock_t;
-typedef int		__kernel_timer_t;
-typedef int		__kernel_clockid_t;
-typedef int		__kernel_daddr_t;
-typedef char *		__kernel_caddr_t;
-typedef unsigned short	__kernel_uid16_t;
-typedef unsigned short	__kernel_gid16_t;
-typedef unsigned int	__kernel_uid32_t;
-typedef unsigned int	__kernel_gid32_t;
 
-typedef unsigned short	__kernel_old_uid_t;
-typedef unsigned short	__kernel_old_gid_t;
 typedef unsigned short	__kernel_old_dev_t;
 
-#ifdef __GNUC__
-typedef long long	__kernel_loff_t;
-#endif
-
-typedef struct {
-	int	val[2];
-} __kernel_fsid_t;
-
 #if defined(__KERNEL__)
 
 #undef	__FD_SET
@@ -81,5 +51,4 @@ do {								\
 } while (0)
 
 #endif /* defined(__KERNEL__) */
-
 #endif /* _ASM_X86_POSIX_TYPES_32_H */
diff --git a/arch/x86/include/asm/posix_types_64.h b/arch/x86/include/asm/posix_types_64.h
index eb8d2d9..3840927 100644
--- a/arch/x86/include/asm/posix_types_64.h
+++ b/arch/x86/include/asm/posix_types_64.h
@@ -1,45 +1,14 @@
 #ifndef _ASM_X86_POSIX_TYPES_64_H
 #define _ASM_X86_POSIX_TYPES_64_H
 
-/*
- * This file is generally used by user-level software, so you need to
- * be a little careful about namespace pollution etc.  Also, we cannot
- * assume GCC is being used.
- */
-
-typedef unsigned long	__kernel_ino_t;
 typedef unsigned int	__kernel_mode_t;
 typedef unsigned long	__kernel_nlink_t;
-typedef long		__kernel_off_t;
-typedef int		__kernel_pid_t;
 typedef int		__kernel_ipc_pid_t;
 typedef unsigned int	__kernel_uid_t;
 typedef unsigned int	__kernel_gid_t;
 typedef unsigned long	__kernel_size_t;
 typedef long		__kernel_ssize_t;
 typedef long		__kernel_ptrdiff_t;
-typedef long		__kernel_time_t;
-typedef long		__kernel_suseconds_t;
-typedef long		__kernel_clock_t;
-typedef int		__kernel_timer_t;
-typedef int		__kernel_clockid_t;
-typedef int		__kernel_daddr_t;
-typedef char *		__kernel_caddr_t;
-typedef unsigned short	__kernel_uid16_t;
-typedef unsigned short	__kernel_gid16_t;
-
-#ifdef __GNUC__
-typedef long long	__kernel_loff_t;
-#endif
-
-typedef struct {
-	int	val[2];
-} __kernel_fsid_t;
-
-typedef unsigned short __kernel_old_uid_t;
-typedef unsigned short __kernel_old_gid_t;
-typedef __kernel_uid_t __kernel_uid32_t;
-typedef __kernel_gid_t __kernel_gid32_t;
 
 typedef unsigned long	__kernel_old_dev_t;
 
@@ -115,5 +84,4 @@ static inline void __FD_ZERO(__kernel_fd_set *p)
 }
 
 #endif /* defined(__KERNEL__) */
-
 #endif /* _ASM_X86_POSIX_TYPES_64_H */
-- 
1.6.0.6



