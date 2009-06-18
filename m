Return-Path: <linux-kernel-owner+w=401wt.eu-S1754697AbZFRIoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697AbZFRIoQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 04:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752302AbZFRIoC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 04:44:02 -0400
Received: from hera.kernel.org ([140.211.167.34]:46664 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454AbZFRIoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 04:44:00 -0400
Subject: [GIT-PULL -tip][PATCH 0/5 -tip] x86: headers fixes
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 18 Jun 2009 14:09:25 +0530
Message-Id: <1245314365.31204.7.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull these header fixes :

The following changes since commit 528c2552eda807e829e84d6ca1b849ae7ca47b0d:
  Ingo Molnar (1):
        Merge branch 'out-of-tree'

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-top.git master

Jaswinder Singh Rajput (5):
      x86: asm/posix_types.h common for kernel and user space
      x86: move common typedefs to asm/posix_types.h
      x86: asm/unistd.h common for kernel and user space
      x86: asm/termios.h remove irrelevant comment for userspace
      x86: asm/types.h remove irrelevant comment for userspace

 arch/x86/include/asm/posix_types.h    |   47 ++++++++++++++++++++++++++------
 arch/x86/include/asm/posix_types_32.h |   31 ---------------------
 arch/x86/include/asm/posix_types_64.h |   32 ----------------------
 arch/x86/include/asm/termios.h        |   25 ++++++++---------
 arch/x86/include/asm/types.h          |    3 +-
 arch/x86/include/asm/unistd.h         |   15 ++++------
 6 files changed, 57 insertions(+), 96 deletions(-)

Complete diff :

diff --git a/arch/x86/include/asm/posix_types.h b/arch/x86/include/asm/posix_types.h
index bb7133d..8fb98cc 100644
--- a/arch/x86/include/asm/posix_types.h
+++ b/arch/x86/include/asm/posix_types.h
@@ -1,13 +1,42 @@
-#ifdef __KERNEL__
-# ifdef CONFIG_X86_32
-#  include "posix_types_32.h"
-# else
-#  include "posix_types_64.h"
-# endif
-#else
-# ifdef __i386__
+#ifndef _ASM_X86_POSIX_TYPES_H
+#define _ASM_X86_POSIX_TYPES_H
+
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
+# if defined(CONFIG_X86_32) || defined(__i386__)
 #  include "posix_types_32.h"
 # else
 #  include "posix_types_64.h"
 # endif
-#endif
+
+#endif /* _ASM_X86_POSIX_TYPES_H */
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
diff --git a/arch/x86/include/asm/termios.h b/arch/x86/include/asm/termios.h
index c4ee805..ee6f0c8 100644
--- a/arch/x86/include/asm/termios.h
+++ b/arch/x86/include/asm/termios.h
@@ -5,20 +5,20 @@
 #include <asm/ioctls.h>
 
 struct winsize {
-	unsigned short ws_row;
-	unsigned short ws_col;
-	unsigned short ws_xpixel;
-	unsigned short ws_ypixel;
+	unsigned short	ws_row;
+	unsigned short	ws_col;
+	unsigned short	ws_xpixel;
+	unsigned short	ws_ypixel;
 };
 
 #define NCC 8
 struct termio {
-	unsigned short c_iflag;		/* input mode flags */
-	unsigned short c_oflag;		/* output mode flags */
-	unsigned short c_cflag;		/* control mode flags */
-	unsigned short c_lflag;		/* local mode flags */
-	unsigned char c_line;		/* line discipline */
-	unsigned char c_cc[NCC];	/* control characters */
+	unsigned short	c_iflag;	/* input mode flags	*/
+	unsigned short	c_oflag;	/* output mode flags	*/
+	unsigned short	c_cflag;	/* control mode flags	*/
+	unsigned short	c_lflag;	/* local mode flags	*/
+	unsigned char	c_line;		/* line discipline	*/
+	unsigned char	c_cc[NCC];	/* control characters	*/
 };
 
 /* modem lines */
@@ -37,10 +37,10 @@ struct termio {
 #define TIOCM_OUT2	0x4000
 #define TIOCM_LOOP	0x8000
 
-/* ioctl (fd, TIOCSERGETLSR, &result) where result may be as below */
-
 #ifdef __KERNEL__
 
+/* ioctl (fd, TIOCSERGETLSR, &result) where result may be as below */
+
 #include <asm/uaccess.h>
 
 /*	intr=^C		quit=^\		erase=del	kill=^U
@@ -110,5 +110,4 @@ static inline int kernel_termios_to_user_termios_1(struct termios __user *u,
 }
 
 #endif	/* __KERNEL__ */
-
 #endif /* _ASM_X86_TERMIOS_H */
diff --git a/arch/x86/include/asm/types.h b/arch/x86/include/asm/types.h
index 09b9774..bebc9f3 100644
--- a/arch/x86/include/asm/types.h
+++ b/arch/x86/include/asm/types.h
@@ -9,10 +9,10 @@ typedef unsigned short umode_t;
 
 #endif /* __ASSEMBLY__ */
 
+#ifdef __KERNEL__
 /*
  * These aren't exported outside the kernel to avoid name space clashes
  */
-#ifdef __KERNEL__
 
 #ifndef __ASSEMBLY__
 
@@ -26,5 +26,4 @@ typedef u32 dma_addr_t;
 
 #endif /* __ASSEMBLY__ */
 #endif /* __KERNEL__ */
-
 #endif /* _ASM_X86_TYPES_H */
diff --git a/arch/x86/include/asm/unistd.h b/arch/x86/include/asm/unistd.h
index 2a58ed3..0de8cb3 100644
--- a/arch/x86/include/asm/unistd.h
+++ b/arch/x86/include/asm/unistd.h
@@ -1,13 +1,10 @@
-#ifdef __KERNEL__
-# ifdef CONFIG_X86_32
+#ifndef _ASM_X86_UNISTD_H
+#define _ASM_X86_UNISTD_H
+
+# if defined(CONFIG_X86_32) || defined(__i386__)
 #  include "unistd_32.h"
 # else
 #  include "unistd_64.h"
 # endif
-#else
-# ifdef __i386__
-#  include "unistd_32.h"
-# else
-#  include "unistd_64.h"
-# endif
-#endif
+
+#endif /* _ASM_X86_UNISTD_H */


