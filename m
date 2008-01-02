Return-Path: <linux-kernel-owner+w=401wt.eu-S1759126AbYABPFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759126AbYABPFp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 10:05:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753450AbYABPFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 10:05:37 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:46664 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753380AbYABPFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 10:05:36 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [patch] asm-*/posix_types.h: scrub __GLIBC__
Date: Wed, 2 Jan 2008 10:05:33 -0500
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801021005.33587.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some arches (like alpha and ia64) already have a clean posix_types.h header.
This brings all the others in line by removing all references to __GLIBC__
(and some undocumented __USE_ALL).

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 asm-arm/posix_types.h      |    6 +-----
 asm-avr32/posix_types.h    |    4 ----
 asm-blackfin/posix_types.h |    8 ++------
 asm-cris/posix_types.h     |    4 ----
 asm-frv/posix_types.h      |    8 ++------
 asm-h8300/posix_types.h    |    8 ++------
 asm-m32r/posix_types.h     |    8 ++------
 asm-m68k/posix_types.h     |    8 ++------
 asm-mips/posix_types.h     |    4 ++--
 asm-parisc/posix_types.h   |    8 ++------
 asm-powerpc/posix_types.h  |    5 ++---
 asm-sh/posix_types.h       |    8 ++------
 asm-sh64/posix_types.h     |    8 ++------
 asm-sparc/posix_types.h    |    8 ++------
 asm-sparc64/posix_types.h  |    8 ++------
 asm-v850/posix_types.h     |    8 ++------
 asm-x86/posix_types_32.h   |    8 ++------
 asm-xtensa/posix_types.h   |    5 ++---
 18 files changed, 31 insertions(+), 93 deletions(-)

diff --git a/include/asm-arm/posix_types.h b/include/asm-arm/posix_types.h
index e142a2a..c37379d 100644
--- a/include/asm-arm/posix_types.h
+++ b/include/asm-arm/posix_types.h
@@ -51,14 +51,10 @@ typedef long long		__kernel_loff_t;
 #endif
 
 typedef struct {
-#if defined(__KERNEL__) || defined(__USE_ALL)
 	int	val[2];
-#else /* !defined(__KERNEL__) && !defined(__USE_ALL) */
-	int	__val[2];
-#endif /* !defined(__KERNEL__) && !defined(__USE_ALL) */
 } __kernel_fsid_t;
 
-#if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)
+#if defined(__KERNEL__)
 
 #undef	__FD_SET
 #define __FD_SET(fd, fdsetp) \
diff --git a/include/asm-avr32/posix_types.h b/include/asm-avr32/posix_types.h
index 9e255b9..fe0c0c0 100644
--- a/include/asm-avr32/posix_types.h
+++ b/include/asm-avr32/posix_types.h
@@ -46,11 +46,7 @@ typedef long long       __kernel_loff_t;
 #endif
 
 typedef struct {
-#if defined(__KERNEL__) || defined(__USE_ALL)
     int     val[2];
-#else /* !defined(__KERNEL__) && !defined(__USE_ALL) */
-    int     __val[2];
-#endif /* !defined(__KERNEL__) && !defined(__USE_ALL) */
 } __kernel_fsid_t;
 
 #if defined(__KERNEL__)
diff --git a/include/asm-blackfin/posix_types.h b/include/asm-blackfin/posix_types.h
index c3fa50f..23aa1f8 100644
--- a/include/asm-blackfin/posix_types.h
+++ b/include/asm-blackfin/posix_types.h
@@ -39,14 +39,10 @@ typedef long long __kernel_loff_t;
 #endif
 
 typedef struct {
-#if defined(__KERNEL__) || defined(__USE_ALL)
 	int val[2];
-#else				/* !defined(__KERNEL__) && !defined(__USE_ALL) */
-	int __val[2];
-#endif				/* !defined(__KERNEL__) && !defined(__USE_ALL) */
 } __kernel_fsid_t;
 
-#if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)
+#if defined(__KERNEL__)
 
 #undef	__FD_SET
 #define	__FD_SET(d, set)	((set)->fds_bits[__FDELT(d)] |= __FDMASK(d))
@@ -60,6 +56,6 @@ typedef struct {
 #undef	__FD_ZERO
 #define __FD_ZERO(fdsetp) (memset (fdsetp, 0, sizeof(*(fd_set *)fdsetp)))
 
-#endif				/* defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2) */
+#endif				/* defined(__KERNEL__) */
 
 #endif
diff --git a/include/asm-cris/posix_types.h b/include/asm-cris/posix_types.h
index 3a5e4c4..ce3fb25 100644
--- a/include/asm-cris/posix_types.h
+++ b/include/asm-cris/posix_types.h
@@ -44,11 +44,7 @@ typedef long long	__kernel_loff_t;
 #endif
 
 typedef struct {
-#if defined(__KERNEL__) || defined(__USE_ALL)
 	int	val[2];
-#else /* !defined(__KERNEL__) && !defined(__USE_ALL) */
-	int	__val[2];
-#endif /* !defined(__KERNEL__) && !defined(__USE_ALL) */
 } __kernel_fsid_t;
 
 #ifdef __KERNEL__
diff --git a/include/asm-frv/posix_types.h b/include/asm-frv/posix_types.h
index 73c2ba8..a9f1f5b 100644
--- a/include/asm-frv/posix_types.h
+++ b/include/asm-frv/posix_types.h
@@ -39,14 +39,10 @@ typedef long long	__kernel_loff_t;
 #endif
 
 typedef struct {
-#if defined(__KERNEL__) || defined(__USE_ALL)
 	int	val[2];
-#else /* !defined(__KERNEL__) && !defined(__USE_ALL) */
-	int	__val[2];
-#endif /* !defined(__KERNEL__) && !defined(__USE_ALL) */
 } __kernel_fsid_t;
 
-#if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)
+#if defined(__KERNEL__)
 
 #undef	__FD_SET
 #define	__FD_SET(d, set)	((set)->fds_bits[__FDELT(d)] |= __FDMASK(d))
@@ -60,7 +56,7 @@ typedef struct {
 #undef	__FD_ZERO
 #define __FD_ZERO(fdsetp) (memset (fdsetp, 0, sizeof(*(fd_set *)fdsetp)))
 
-#endif /* defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2) */
+#endif /* defined(__KERNEL__) */
 
 #endif
 
diff --git a/include/asm-h8300/posix_types.h b/include/asm-h8300/posix_types.h
index 7de94b1..5c55392 100644
--- a/include/asm-h8300/posix_types.h
+++ b/include/asm-h8300/posix_types.h
@@ -38,14 +38,10 @@ typedef long long	__kernel_loff_t;
 #endif
 
 typedef struct {
-#if defined(__KERNEL__) || defined(__USE_ALL)
 	int	val[2];
-#else /* !defined(__KERNEL__) && !defined(__USE_ALL) */
-	int	__val[2];
-#endif /* !defined(__KERNEL__) && !defined(__USE_ALL) */
 } __kernel_fsid_t;
 
-#if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)
+#if defined(__KERNEL__)
 
 #undef	__FD_SET
 #define	__FD_SET(d, set)	((set)->fds_bits[__FDELT(d)] |= __FDMASK(d))
@@ -59,6 +55,6 @@ typedef struct {
 #undef	__FD_ZERO
 #define __FD_ZERO(fdsetp) (memset (fdsetp, 0, sizeof(*(fd_set *)fdsetp)))
 
-#endif /* defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2) */
+#endif /* defined(__KERNEL__) */
 
 #endif
diff --git a/include/asm-m32r/posix_types.h b/include/asm-m32r/posix_types.h
index 1caac65..b309c58 100644
--- a/include/asm-m32r/posix_types.h
+++ b/include/asm-m32r/posix_types.h
@@ -39,14 +39,10 @@ typedef long long	__kernel_loff_t;
 #endif
 
 typedef struct {
-#if defined(__KERNEL__) || defined(__USE_ALL)
 	int	val[2];
-#else /* !defined(__KERNEL__) && !defined(__USE_ALL) */
-	int	__val[2];
-#endif /* !defined(__KERNEL__) && !defined(__USE_ALL) */
 } __kernel_fsid_t;
 
-#if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)
+#if defined(__KERNEL__)
 
 #undef	__FD_SET
 static __inline__ void __FD_SET(unsigned long __fd, __kernel_fd_set *__fdsetp)
@@ -117,6 +113,6 @@ static __inline__ void __FD_ZERO(__kernel_fd_set *__p)
 	}
 }
 
-#endif /* defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2) */
+#endif /* defined(__KERNEL__) */
 
 #endif  /* _ASM_M32R_POSIX_TYPES_H */
diff --git a/include/asm-m68k/posix_types.h b/include/asm-m68k/posix_types.h
index fa166ee..63cdcc1 100644
--- a/include/asm-m68k/posix_types.h
+++ b/include/asm-m68k/posix_types.h
@@ -39,14 +39,10 @@ typedef long long	__kernel_loff_t;
 #endif
 
 typedef struct {
-#if defined(__KERNEL__) || defined(__USE_ALL)
 	int	val[2];
-#else /* !defined(__KERNEL__) && !defined(__USE_ALL) */
-	int	__val[2];
-#endif /* !defined(__KERNEL__) && !defined(__USE_ALL) */
 } __kernel_fsid_t;
 
-#if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)
+#if defined(__KERNEL__)
 
 #undef	__FD_SET
 #define	__FD_SET(d, set)	((set)->fds_bits[__FDELT(d)] |= __FDMASK(d))
@@ -60,6 +56,6 @@ typedef struct {
 #undef	__FD_ZERO
 #define __FD_ZERO(fdsetp) (memset (fdsetp, 0, sizeof(*(fd_set *)fdsetp)))
 
-#endif /* defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2) */
+#endif /* defined(__KERNEL__) */
 
 #endif
diff --git a/include/asm-mips/posix_types.h b/include/asm-mips/posix_types.h
index c2e8a00..c200102 100644
--- a/include/asm-mips/posix_types.h
+++ b/include/asm-mips/posix_types.h
@@ -69,7 +69,7 @@ typedef struct {
 #endif
 } __kernel_fsid_t;
 
-#if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)
+#if defined(__KERNEL__)
 
 #undef __FD_SET
 static __inline__ void __FD_SET(unsigned long __fd, __kernel_fd_set *__fdsetp)
@@ -139,6 +139,6 @@ static __inline__ void __FD_ZERO(__kernel_fd_set *__p)
 	}
 }
 
-#endif /* defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2) */
+#endif /* defined(__KERNEL__) */
 
 #endif /* _ASM_POSIX_TYPES_H */
diff --git a/include/asm-parisc/posix_types.h b/include/asm-parisc/posix_types.h
index b634e3c..bb725a6 100644
--- a/include/asm-parisc/posix_types.h
+++ b/include/asm-parisc/posix_types.h
@@ -47,18 +47,14 @@ typedef unsigned long long	__kernel_ino64_t;
 typedef unsigned int		__kernel_old_dev_t;
 
 typedef struct {
-#if defined(__KERNEL__) || defined(__USE_ALL)
 	int	val[2];
-#else /* !defined(__KERNEL__) && !defined(__USE_ALL) */
-	int	__val[2];
-#endif /* !defined(__KERNEL__) && !defined(__USE_ALL) */
 } __kernel_fsid_t;
 
 /* compatibility stuff */
 typedef __kernel_uid_t __kernel_old_uid_t;
 typedef __kernel_gid_t __kernel_old_gid_t;
 
-#if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)
+#if defined(__KERNEL__)
 
 #undef __FD_SET
 static __inline__ void __FD_SET(unsigned long __fd, __kernel_fd_set *__fdsetp)
@@ -128,6 +124,6 @@ static __inline__ void __FD_ZERO(__kernel_fd_set *__p)
 	}
 }
 
-#endif /* defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2) */
+#endif /* defined(__KERNEL__) */
 
 #endif
diff --git a/include/asm-powerpc/posix_types.h b/include/asm-powerpc/posix_types.h
index 2f2288f..c4e396b 100644
--- a/include/asm-powerpc/posix_types.h
+++ b/include/asm-powerpc/posix_types.h
@@ -64,8 +64,7 @@ typedef struct {
 
 #else /* __GNUC__ */
 
-#if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2) \
-    || (__GLIBC__ == 2 && __GLIBC_MINOR__ == 0)
+#if defined(__KERNEL__)
 /* With GNU C, use inline functions instead so args are evaluated only once: */
 
 #undef __FD_SET
@@ -124,6 +123,6 @@ static __inline__ void __FD_ZERO(__kernel_fd_set *p)
 	}
 }
 
-#endif /* defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2) */
+#endif /* defined(__KERNEL__) */
 #endif /* __GNUC__ */
 #endif /* _ASM_POWERPC_POSIX_TYPES_H */
diff --git a/include/asm-sh/posix_types.h b/include/asm-sh/posix_types.h
index 0a3d2f5..2172732 100644
--- a/include/asm-sh/posix_types.h
+++ b/include/asm-sh/posix_types.h
@@ -39,14 +39,10 @@ typedef long long	__kernel_loff_t;
 #endif
 
 typedef struct {
-#if defined(__KERNEL__) || defined(__USE_ALL)
 	int	val[2];
-#else /* !defined(__KERNEL__) && !defined(__USE_ALL) */
-	int	__val[2];
-#endif /* !defined(__KERNEL__) && !defined(__USE_ALL) */
 } __kernel_fsid_t;
 
-#if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)
+#if defined(__KERNEL__)
 
 #undef	__FD_SET
 static __inline__ void __FD_SET(unsigned long __fd, __kernel_fd_set *__fdsetp)
@@ -117,6 +113,6 @@ static __inline__ void __FD_ZERO(__kernel_fd_set *__p)
 	}
 }
 
-#endif /* defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2) */
+#endif /* defined(__KERNEL__) */
 
 #endif /* __ASM_SH_POSIX_TYPES_H */
diff --git a/include/asm-sh64/posix_types.h b/include/asm-sh64/posix_types.h
index 0620317..f83e9bd 100644
--- a/include/asm-sh64/posix_types.h
+++ b/include/asm-sh64/posix_types.h
@@ -48,14 +48,10 @@ typedef long long	__kernel_loff_t;
 #endif
 
 typedef struct {
-#if defined(__KERNEL__) || defined(__USE_ALL)
 	int	val[2];
-#else /* !defined(__KERNEL__) && !defined(__USE_ALL) */
-	int	__val[2];
-#endif /* !defined(__KERNEL__) && !defined(__USE_ALL) */
 } __kernel_fsid_t;
 
-#if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)
+#if defined(__KERNEL__)
 
 #undef	__FD_SET
 static __inline__ void __FD_SET(unsigned long __fd, __kernel_fd_set *__fdsetp)
@@ -126,6 +122,6 @@ static __inline__ void __FD_ZERO(__kernel_fd_set *__p)
 	}
 }
 
-#endif /* defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2) */
+#endif /* defined(__KERNEL__) */
 
 #endif /* __ASM_SH64_POSIX_TYPES_H */
diff --git a/include/asm-sparc/posix_types.h b/include/asm-sparc/posix_types.h
index 62c8fa7..dcc07eb 100644
--- a/include/asm-sparc/posix_types.h
+++ b/include/asm-sparc/posix_types.h
@@ -39,14 +39,10 @@ typedef long long	__kernel_loff_t;
 #endif
 
 typedef struct {
-#if defined(__KERNEL__) || defined(__USE_ALL)
 	int	val[2];
-#else /* !defined(__KERNEL__) && !defined(__USE_ALL) */
-	int     __val[2];
-#endif /* !defined(__KERNEL__) && !defined(__USE_ALL) */
 } __kernel_fsid_t;
 
-#if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)
+#if defined(__KERNEL__)
 
 #undef __FD_SET
 static inline void __FD_SET(unsigned long fd, __kernel_fd_set *fdsetp)
@@ -117,6 +113,6 @@ static inline void __FD_ZERO(__kernel_fd_set *p)
 	}
 }
 
-#endif /* defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2) */
+#endif /* defined(__KERNEL__) */
 
 #endif /* !(__ARCH_SPARC_POSIX_TYPES_H) */
diff --git a/include/asm-sparc64/posix_types.h b/include/asm-sparc64/posix_types.h
index 3426a65..4eaaa01 100644
--- a/include/asm-sparc64/posix_types.h
+++ b/include/asm-sparc64/posix_types.h
@@ -43,14 +43,10 @@ typedef long long              __kernel_loff_t;
 #endif
 
 typedef struct {
-#if defined(__KERNEL__) || defined(__USE_ALL)
 	int	val[2];
-#else /* !defined(__KERNEL__) && !defined(__USE_ALL) */
-	int     __val[2];
-#endif /* !defined(__KERNEL__) && !defined(__USE_ALL) */
 } __kernel_fsid_t;
 
-#if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)
+#if defined(__KERNEL__)
 
 #undef __FD_SET
 static inline void __FD_SET(unsigned long fd, __kernel_fd_set *fdsetp)
@@ -121,6 +117,6 @@ static inline void __FD_ZERO(__kernel_fd_set *p)
 	}
 }
 
-#endif /* defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2) */
+#endif /* defined(__KERNEL__) */
 
 #endif /* !(__ARCH_SPARC64_POSIX_TYPES_H) */
diff --git a/include/asm-v850/posix_types.h b/include/asm-v850/posix_types.h
index ccb7297..7f403b7 100644
--- a/include/asm-v850/posix_types.h
+++ b/include/asm-v850/posix_types.h
@@ -44,15 +44,11 @@ typedef __kernel_uid_t __kernel_old_uid_t;
 typedef unsigned int	__kernel_old_dev_t;
 
 typedef struct {
-#if defined(__KERNEL__) || defined(__USE_ALL)
 	int	val[2];
-#else /* !defined(__KERNEL__) && !defined(__USE_ALL) */
-	int	__val[2];
-#endif /* !defined(__KERNEL__) && !defined(__USE_ALL) */
 } __kernel_fsid_t;
 
 
-#if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)
+#if defined(__KERNEL__)
 
 /* We used to include <asm/bitops.h> here, which seems the right thing, but
    it caused nasty include-file definition order problems.  Removing the
@@ -71,6 +67,6 @@ typedef struct {
 #define __FD_ZERO(fd_set) \
   memset (fd_set, 0, sizeof (*(fd_set *)fd_set))
 
-#endif /* defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2) */
+#endif /* defined(__KERNEL__) */
 
 #endif /* __V850_POSIX_TYPES_H__ */
diff --git a/include/asm-x86/posix_types_32.h b/include/asm-x86/posix_types_32.h
index 133e31e..015e539 100644
--- a/include/asm-x86/posix_types_32.h
+++ b/include/asm-x86/posix_types_32.h
@@ -39,14 +39,10 @@ typedef long long	__kernel_loff_t;
 #endif
 
 typedef struct {
-#if defined(__KERNEL__) || defined(__USE_ALL)
 	int	val[2];
-#else /* !defined(__KERNEL__) && !defined(__USE_ALL) */
-	int	__val[2];
-#endif /* !defined(__KERNEL__) && !defined(__USE_ALL) */
 } __kernel_fsid_t;
 
-#if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)
+#if defined(__KERNEL__)
 
 #undef	__FD_SET
 #define __FD_SET(fd,fdsetp) \
@@ -77,6 +73,6 @@ do { \
 			"2" ((__kernel_fd_set *) (fdsetp)) : "memory"); \
 } while (0)
 
-#endif /* defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2) */
+#endif /* defined(__KERNEL__) */
 
 #endif
diff --git a/include/asm-xtensa/posix_types.h b/include/asm-xtensa/posix_types.h
index 4ad77dd..43f9dd1 100644
--- a/include/asm-xtensa/posix_types.h
+++ b/include/asm-xtensa/posix_types.h
@@ -64,8 +64,7 @@ typedef struct {
 
 #else /* __GNUC__ */
 
-#if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2) \
-    || (__GLIBC__ == 2 && __GLIBC_MINOR__ == 0)
+#if defined(__KERNEL__)
 /* With GNU C, use inline functions instead so args are evaluated only once: */
 
 #undef __FD_SET
@@ -118,6 +117,6 @@ static __inline__ void __FD_ZERO(__kernel_fd_set *p)
 	}
 }
 
-#endif /* defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2) */
+#endif /* defined(__KERNEL__) */
 #endif /* __GNUC__ */
 #endif /* _XTENSA_POSIX_TYPES_H */
