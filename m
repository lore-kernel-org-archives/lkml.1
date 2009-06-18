Return-Path: <linux-kernel-owner+w=401wt.eu-S1757245AbZFRRsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245AbZFRRsL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 13:48:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753348AbZFRRr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 13:47:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:52218 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265AbZFRRr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 13:47:58 -0400
Subject: [GIT-PULL -tip V2][PATCH 0/4 -tip] x86: headers fixes
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86 maintainers <x86@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Christoph Hellwig <hch@infradead.org>
In-Reply-To: <1245314365.31204.7.camel@ht.satnam>
References: <1245314365.31204.7.camel@ht.satnam>
Content-Type: text/plain
Date: Thu, 18 Jun 2009 23:13:06 +0530
Message-Id: <1245346986.2481.10.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull X86 headers fixes patches.

The following changes since commit ce46441b95bcde36649a17d053dc7dc76272f539:
  Ingo Molnar (1):
        Merge branch 'perfcounters/core'

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-top.git master

Jaswinder Singh Rajput (4):
      x86: unification of posix_types.h
      x86: asm/unistd.h common for kernel and user space
      x86: asm/termios.h remove irrelevant comment for userspace
      x86: asm/types.h remove irrelevant comment for userspace

 arch/x86/include/asm/Kbuild           |    2 -
 arch/x86/include/asm/posix_types.h    |   96 +++++++++++++++++++++++---
 arch/x86/include/asm/posix_types_32.h |   85 -----------------------
 arch/x86/include/asm/posix_types_64.h |  119 ---------------------------------
 arch/x86/include/asm/termios.h        |   25 +++----
 arch/x86/include/asm/types.h          |    3 +-
 arch/x86/include/asm/unistd.h         |   15 ++---
 7 files changed, 104 insertions(+), 241 deletions(-)
 delete mode 100644 arch/x86/include/asm/posix_types_32.h
 delete mode 100644 arch/x86/include/asm/posix_types_64.h

Complete diff:

diff --git a/arch/x86/include/asm/Kbuild b/arch/x86/include/asm/Kbuild
index 4a8e80c..786bb67 100644
--- a/arch/x86/include/asm/Kbuild
+++ b/arch/x86/include/asm/Kbuild
@@ -16,8 +16,6 @@ unifdef-y += ist.h
 unifdef-y += mce.h
 unifdef-y += msr.h
 unifdef-y += mtrr.h
-unifdef-y += posix_types_32.h
-unifdef-y += posix_types_64.h
 unifdef-y += unistd_32.h
 unifdef-y += unistd_64.h
 unifdef-y += vm86.h
diff --git a/arch/x86/include/asm/posix_types.h b/arch/x86/include/asm/posix_types.h
index bb7133d..929fda7 100644
--- a/arch/x86/include/asm/posix_types.h
+++ b/arch/x86/include/asm/posix_types.h
@@ -1,13 +1,87 @@
-#ifdef __KERNEL__
-# ifdef CONFIG_X86_32
-#  include "posix_types_32.h"
-# else
-#  include "posix_types_64.h"
-# endif
+#ifndef _ASM_X86_POSIX_TYPES_H
+#define _ASM_X86_POSIX_TYPES_H
+
+/*
+ * These types are different from the asm-generic version
+ */
+
+#define __kernel_old_uid_t __kernel_old_uid_t
+typedef unsigned short	__kernel_old_uid_t;
+typedef unsigned short	__kernel_old_gid_t;
+
+#ifdef __x86_64__
+
+#define __kernel_old_dev_t __kernel_old_dev_t
+typedef unsigned long	__kernel_old_dev_t;
+
 #else
-# ifdef __i386__
-#  include "posix_types_32.h"
-# else
-#  include "posix_types_64.h"
-# endif
+
+#define __kernel_mode_t __kernel_mode_t
+typedef unsigned short	__kernel_mode_t;
+
+#define __kernel_nlink_t __kernel_nlink_t
+typedef unsigned short	__kernel_nlink_t;
+
+#define __kernel_ipc_pid_t __kernel_ipc_pid_t
+typedef unsigned short	__kernel_ipc_pid_t;
+
+#define __kernel_uid_t __kernel_uid_t
+typedef unsigned short	__kernel_uid_t;
+typedef unsigned short	__kernel_gid_t;
+
+#define __kernel_uid32_t __kernel_uid32_t
+typedef unsigned int	__kernel_uid32_t;
+typedef unsigned int	__kernel_gid32_t;
+
+#define __kernel_old_dev_t __kernel_old_dev_t
+typedef unsigned short	__kernel_old_dev_t;
+
 #endif
+
+/*
+ * Include asm-generic version for remaining types
+ */
+
+#include <asm-generic/posix_types.h>
+
+#if defined(__KERNEL__)
+#ifndef CONFIG_X86_32
+
+#undef	__FD_SET
+#define __FD_SET(fd, fdsetp)					\
+	asm volatile("btsl %1,%0":				\
+		     "+m" (*(__kernel_fd_set *)(fdsetp))	\
+		     : "r" ((int)(fd)))
+
+#undef	__FD_CLR
+#define __FD_CLR(fd, fdsetp)					\
+	asm volatile("btrl %1,%0":				\
+		     "+m" (*(__kernel_fd_set *)(fdsetp))	\
+		     : "r" ((int) (fd)))
+
+#undef	__FD_ISSET
+#define __FD_ISSET(fd, fdsetp)					\
+	(__extension__						\
+	 ({							\
+	 unsigned char __result;				\
+	 asm volatile("btl %1,%2 ; setb %0"			\
+		      : "=q" (__result)				\
+		      : "r" ((int)(fd)),			\
+			"m" (*(__kernel_fd_set *)(fdsetp)));	\
+	 __result;						\
+}))
+
+#undef	__FD_ZERO
+#define __FD_ZERO(fdsetp)					\
+do {								\
+	int __d0, __d1;						\
+	asm volatile("cld ; rep ; stosl"			\
+		     : "=m" (*(__kernel_fd_set *)(fdsetp)),	\
+		       "=&c" (__d0), "=&D" (__d1)		\
+		     : "a" (0), "1" (__FDSET_LONGS),		\
+		       "2" ((__kernel_fd_set *)(fdsetp))	\
+		     : "memory");				\
+} while (0)
+#endif /* CONFIG_X86_32 */
+#endif /* defined(__KERNEL__) */
+#endif /* _ASM_X86_POSIX_TYPES_H */
diff --git a/arch/x86/include/asm/posix_types_32.h b/arch/x86/include/asm/posix_types_32.h
deleted file mode 100644
index f7d9adf..0000000
--- a/arch/x86/include/asm/posix_types_32.h
+++ /dev/null
@@ -1,85 +0,0 @@
-#ifndef _ASM_X86_POSIX_TYPES_32_H
-#define _ASM_X86_POSIX_TYPES_32_H
-
-/*
- * This file is generally used by user-level software, so you need to
- * be a little careful about namespace pollution etc.  Also, we cannot
- * assume GCC is being used.
- */
-
-typedef unsigned long	__kernel_ino_t;
-typedef unsigned short	__kernel_mode_t;
-typedef unsigned short	__kernel_nlink_t;
-typedef long		__kernel_off_t;
-typedef int		__kernel_pid_t;
-typedef unsigned short	__kernel_ipc_pid_t;
-typedef unsigned short	__kernel_uid_t;
-typedef unsigned short	__kernel_gid_t;
-typedef unsigned int	__kernel_size_t;
-typedef int		__kernel_ssize_t;
-typedef int		__kernel_ptrdiff_t;
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
-
-typedef unsigned short	__kernel_old_uid_t;
-typedef unsigned short	__kernel_old_gid_t;
-typedef unsigned short	__kernel_old_dev_t;
-
-#ifdef __GNUC__
-typedef long long	__kernel_loff_t;
-#endif
-
-typedef struct {
-	int	val[2];
-} __kernel_fsid_t;
-
-#if defined(__KERNEL__)
-
-#undef	__FD_SET
-#define __FD_SET(fd,fdsetp)					\
-	asm volatile("btsl %1,%0":				\
-		     "+m" (*(__kernel_fd_set *)(fdsetp))	\
-		     : "r" ((int)(fd)))
-
-#undef	__FD_CLR
-#define __FD_CLR(fd,fdsetp)					\
-	asm volatile("btrl %1,%0":				\
-		     "+m" (*(__kernel_fd_set *)(fdsetp))	\
-		     : "r" ((int) (fd)))
-
-#undef	__FD_ISSET
-#define __FD_ISSET(fd,fdsetp)					\
-	(__extension__						\
-	 ({							\
-	 unsigned char __result;				\
-	 asm volatile("btl %1,%2 ; setb %0"			\
-		      : "=q" (__result)				\
-		      : "r" ((int)(fd)),			\
-			"m" (*(__kernel_fd_set *)(fdsetp)));	\
-	 __result;						\
-}))
-
-#undef	__FD_ZERO
-#define __FD_ZERO(fdsetp)					\
-do {								\
-	int __d0, __d1;						\
-	asm volatile("cld ; rep ; stosl"			\
-		     : "=m" (*(__kernel_fd_set *)(fdsetp)),	\
-		       "=&c" (__d0), "=&D" (__d1)		\
-		     : "a" (0), "1" (__FDSET_LONGS),		\
-		       "2" ((__kernel_fd_set *)(fdsetp))	\
-		     : "memory");				\
-} while (0)
-
-#endif /* defined(__KERNEL__) */
-
-#endif /* _ASM_X86_POSIX_TYPES_32_H */
diff --git a/arch/x86/include/asm/posix_types_64.h b/arch/x86/include/asm/posix_types_64.h
deleted file mode 100644
index eb8d2d9..0000000
--- a/arch/x86/include/asm/posix_types_64.h
+++ /dev/null
@@ -1,119 +0,0 @@
-#ifndef _ASM_X86_POSIX_TYPES_64_H
-#define _ASM_X86_POSIX_TYPES_64_H
-
-/*
- * This file is generally used by user-level software, so you need to
- * be a little careful about namespace pollution etc.  Also, we cannot
- * assume GCC is being used.
- */
-
-typedef unsigned long	__kernel_ino_t;
-typedef unsigned int	__kernel_mode_t;
-typedef unsigned long	__kernel_nlink_t;
-typedef long		__kernel_off_t;
-typedef int		__kernel_pid_t;
-typedef int		__kernel_ipc_pid_t;
-typedef unsigned int	__kernel_uid_t;
-typedef unsigned int	__kernel_gid_t;
-typedef unsigned long	__kernel_size_t;
-typedef long		__kernel_ssize_t;
-typedef long		__kernel_ptrdiff_t;
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
-
-typedef unsigned long	__kernel_old_dev_t;
-
-#ifdef __KERNEL__
-
-#undef __FD_SET
-static inline void __FD_SET(unsigned long fd, __kernel_fd_set *fdsetp)
-{
-	unsigned long _tmp = fd / __NFDBITS;
-	unsigned long _rem = fd % __NFDBITS;
-	fdsetp->fds_bits[_tmp] |= (1UL<<_rem);
-}
-
-#undef __FD_CLR
-static inline void __FD_CLR(unsigned long fd, __kernel_fd_set *fdsetp)
-{
-	unsigned long _tmp = fd / __NFDBITS;
-	unsigned long _rem = fd % __NFDBITS;
-	fdsetp->fds_bits[_tmp] &= ~(1UL<<_rem);
-}
-
-#undef __FD_ISSET
-static inline int __FD_ISSET(unsigned long fd, __const__ __kernel_fd_set *p)
-{
-	unsigned long _tmp = fd / __NFDBITS;
-	unsigned long _rem = fd % __NFDBITS;
-	return (p->fds_bits[_tmp] & (1UL<<_rem)) != 0;
-}
-
-/*
- * This will unroll the loop for the normal constant cases (8 or 32 longs,
- * for 256 and 1024-bit fd_sets respectively)
- */
-#undef __FD_ZERO
-static inline void __FD_ZERO(__kernel_fd_set *p)
-{
-	unsigned long *tmp = p->fds_bits;
-	int i;
-
-	if (__builtin_constant_p(__FDSET_LONGS)) {
-		switch (__FDSET_LONGS) {
-		case 32:
-			tmp[ 0] = 0; tmp[ 1] = 0; tmp[ 2] = 0; tmp[ 3] = 0;
-			tmp[ 4] = 0; tmp[ 5] = 0; tmp[ 6] = 0; tmp[ 7] = 0;
-			tmp[ 8] = 0; tmp[ 9] = 0; tmp[10] = 0; tmp[11] = 0;
-			tmp[12] = 0; tmp[13] = 0; tmp[14] = 0; tmp[15] = 0;
-			tmp[16] = 0; tmp[17] = 0; tmp[18] = 0; tmp[19] = 0;
-			tmp[20] = 0; tmp[21] = 0; tmp[22] = 0; tmp[23] = 0;
-			tmp[24] = 0; tmp[25] = 0; tmp[26] = 0; tmp[27] = 0;
-			tmp[28] = 0; tmp[29] = 0; tmp[30] = 0; tmp[31] = 0;
-			return;
-		case 16:
-			tmp[ 0] = 0; tmp[ 1] = 0; tmp[ 2] = 0; tmp[ 3] = 0;
-			tmp[ 4] = 0; tmp[ 5] = 0; tmp[ 6] = 0; tmp[ 7] = 0;
-			tmp[ 8] = 0; tmp[ 9] = 0; tmp[10] = 0; tmp[11] = 0;
-			tmp[12] = 0; tmp[13] = 0; tmp[14] = 0; tmp[15] = 0;
-			return;
-		case 8:
-			tmp[ 0] = 0; tmp[ 1] = 0; tmp[ 2] = 0; tmp[ 3] = 0;
-			tmp[ 4] = 0; tmp[ 5] = 0; tmp[ 6] = 0; tmp[ 7] = 0;
-			return;
-		case 4:
-			tmp[ 0] = 0; tmp[ 1] = 0; tmp[ 2] = 0; tmp[ 3] = 0;
-			return;
-		}
-	}
-	i = __FDSET_LONGS;
-	while (i) {
-		i--;
-		*tmp = 0;
-		tmp++;
-	}
-}
-
-#endif /* defined(__KERNEL__) */
-
-#endif /* _ASM_X86_POSIX_TYPES_64_H */
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


