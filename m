Return-Path: <linux-kernel-owner+w=401wt.eu-S1757545AbZFRTs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545AbZFRTs7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 15:48:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757350AbZFRTs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 15:48:28 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:53695 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585AbZFRTs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 15:48:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86 maintainers <x86@kernel.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/5] x86: convert trivial headers to asm-generic version
Date: Thu, 18 Jun 2009 21:48:17 +0200
Message-Id: <5c25ae8d5cd991cc4bc4639abc8745d95194d450.1245354003.git.arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <cover.1245354003.git.arnd@arndb.de>
References: <cover.1245354003.git.arnd@arndb.de>
In-Reply-To: <cover.1245354003.git.arnd@arndb.de>
References: <cover.1245354003.git.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19ppf4/Jdd2Om98ioCDmBggRplo0lyktzF0pNW
 OyDg71zTowjPKxqwCTAnpBV1ZjRnM/ufHfBsgQskfQ5M3085Xc
 BQiv29fhl/SXBNR3KmNgQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For these nine header files, the asm-generic version should
be semantically identical to what is in x86. Change the
contents to be binary identical, for better review.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/x86/include/asm/ioctls.h   |   40 +++++++++++++++++++++++++++-----------
 arch/x86/include/asm/ipcbuf.h   |   15 +++++++++----
 arch/x86/include/asm/msgbuf.h   |   30 ++++++++++++++++++----------
 arch/x86/include/asm/param.h    |    8 ++++--
 arch/x86/include/asm/shmbuf.h   |   28 +++++++++++++++++---------
 arch/x86/include/asm/socket.h   |   10 ++++----
 arch/x86/include/asm/sockios.h  |    6 ++--
 arch/x86/include/asm/termbits.h |    8 +++---
 8 files changed, 92 insertions(+), 53 deletions(-)

diff --git a/arch/x86/include/asm/ioctls.h b/arch/x86/include/asm/ioctls.h
index 0d5b23b..a799e20 100644
--- a/arch/x86/include/asm/ioctls.h
+++ b/arch/x86/include/asm/ioctls.h
@@ -1,12 +1,23 @@
-#ifndef _ASM_X86_IOCTLS_H
-#define _ASM_X86_IOCTLS_H
+#ifndef __ASM_GENERIC_IOCTLS_H
+#define __ASM_GENERIC_IOCTLS_H
 
-#include <asm/ioctl.h>
+#include <linux/ioctl.h>
+
+/*
+ * These are the most common definitions for tty ioctl numbers.
+ * Most of them do not use the recommended _IOC(), but there is
+ * probably some source code out there hardcoding the number,
+ * so we might as well use them for all new platforms.
+ *
+ * The architectures that use different values here typically
+ * try to be compatible with some Unix variants for the same
+ * architecture.
+ */
 
 /* 0x54 is just a magic number to make these relatively unique ('T') */
 
 #define TCGETS		0x5401
-#define TCSETS		0x5402 /* Clashes with SNDCTL_TMR_START sound ioctl */
+#define TCSETS		0x5402
 #define TCSETSW		0x5403
 #define TCSETSF		0x5404
 #define TCGETA		0x5405
@@ -43,7 +54,6 @@
 #define TIOCSETD	0x5423
 #define TIOCGETD	0x5424
 #define TCSBRKP		0x5425	/* Needed for POSIX tcsendbreak() */
-/* #define TIOCTTYGSTRUCT 0x5426 - Former debugging-only ioctl */
 #define TIOCSBRK	0x5427  /* BSD compatibility */
 #define TIOCCBRK	0x5428  /* BSD compatibility */
 #define TIOCGSID	0x5429  /* Return the session ID of FD */
@@ -53,8 +63,7 @@
 #define TCSETSF2	_IOW('T', 0x2D, struct termios2)
 #define TIOCGRS485	0x542E
 #define TIOCSRS485	0x542F
-#define TIOCGPTN	_IOR('T', 0x30, unsigned int)
-				/* Get Pty Number (of pty-mux device) */
+#define TIOCGPTN	_IOR('T', 0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
 #define TIOCSPTLCK	_IOW('T', 0x31, int)  /* Lock/unlock Pty */
 #define TCGETX		0x5432 /* SYS5 TCGETX compatibility */
 #define TCSETX		0x5433
@@ -76,9 +85,16 @@
 
 #define TIOCMIWAIT	0x545C	/* wait for a change on serial input line(s) */
 #define TIOCGICOUNT	0x545D	/* read serial port inline interrupt counts */
-#define TIOCGHAYESESP   0x545E  /* Get Hayes ESP configuration */
-#define TIOCSHAYESESP   0x545F  /* Set Hayes ESP configuration */
-#define FIOQSIZE	0x5460
+
+/*
+ * some architectures define FIOQSIZE as 0x545E, which is used for
+ * TIOCGHAYESESP on others
+ */
+#ifndef FIOQSIZE
+# define TIOCGHAYESESP	0x545E  /* Get Hayes ESP configuration */
+# define TIOCSHAYESESP	0x545F  /* Set Hayes ESP configuration */
+# define FIOQSIZE	0x5460
+#endif
 
 /* Used for packet mode */
 #define TIOCPKT_DATA		 0
@@ -89,6 +105,6 @@
 #define TIOCPKT_NOSTOP		16
 #define TIOCPKT_DOSTOP		32
 
-#define TIOCSER_TEMT    0x01	/* Transmitter physically empty */
+#define TIOCSER_TEMT	0x01	/* Transmitter physically empty */
 
-#endif /* _ASM_X86_IOCTLS_H */
+#endif /* __ASM_GENERIC_IOCTLS_H */
diff --git a/arch/x86/include/asm/ipcbuf.h b/arch/x86/include/asm/ipcbuf.h
index ee678fd..888ca1c 100644
--- a/arch/x86/include/asm/ipcbuf.h
+++ b/arch/x86/include/asm/ipcbuf.h
@@ -1,13 +1,18 @@
-#ifndef _ASM_X86_IPCBUF_H
-#define _ASM_X86_IPCBUF_H
+#ifndef __ASM_GENERIC_IPCBUF_H
+#define __ASM_GENERIC_IPCBUF_H
 
 /*
- * The ipc64_perm structure for x86 architecture.
+ * The generic ipc64_perm structure:
  * Note extra padding because this structure is passed back and forth
  * between kernel and user space.
  *
+ * ipc64_perm was originally meant to be architecture specific, but
+ * everyone just ended up making identical copies without specific
+ * optimizations, so we may just as well all use the same one.
+ *
  * Pad space is left for:
- * - 32-bit mode_t and seq
+ * - 32-bit mode_t on architectures that only had 16 bit
+ * - 32-bit seq
  * - 2 miscellaneous 32-bit values
  */
 
@@ -25,4 +30,4 @@ struct ipc64_perm {
 	unsigned long		__unused2;
 };
 
-#endif /* _ASM_X86_IPCBUF_H */
+#endif /* __ASM_GENERIC_IPCBUF_H */
diff --git a/arch/x86/include/asm/msgbuf.h b/arch/x86/include/asm/msgbuf.h
index 7e4e948..aec850d 100644
--- a/arch/x86/include/asm/msgbuf.h
+++ b/arch/x86/include/asm/msgbuf.h
@@ -1,30 +1,38 @@
-#ifndef _ASM_X86_MSGBUF_H
-#define _ASM_X86_MSGBUF_H
+#ifndef __ASM_GENERIC_MSGBUF_H
+#define __ASM_GENERIC_MSGBUF_H
 
+#include <asm/bitsperlong.h>
 /*
- * The msqid64_ds structure for i386 architecture.
+ * generic msqid64_ds structure.
+ *
  * Note extra padding because this structure is passed back and forth
  * between kernel and user space.
  *
- * Pad space on i386 is left for:
+ * msqid64_ds was originally meant to be architecture specific, but
+ * everyone just ended up making identical copies without specific
+ * optimizations, so we may just as well all use the same one.
+ *
+ * 64 bit architectures typically define a 64 bit __kernel_time_t,
+ * so they do not need the first three padding words.
+ * On big-endian systems, the padding is in the wrong place.
+ *
+ * Pad space is left for:
  * - 64-bit time_t to solve y2038 problem
  * - 2 miscellaneous 32-bit values
- *
- * Pad space on x8664 is left for:
- * - 2 miscellaneous 64-bit values
  */
+
 struct msqid64_ds {
 	struct ipc64_perm msg_perm;
 	__kernel_time_t msg_stime;	/* last msgsnd time */
-#ifdef __i386__
+#if __BITS_PER_LONG != 64
 	unsigned long	__unused1;
 #endif
 	__kernel_time_t msg_rtime;	/* last msgrcv time */
-#ifdef __i386__
+#if __BITS_PER_LONG != 64
 	unsigned long	__unused2;
 #endif
 	__kernel_time_t msg_ctime;	/* last change time */
-#ifdef __i386__
+#if __BITS_PER_LONG != 64
 	unsigned long	__unused3;
 #endif
 	unsigned long  msg_cbytes;	/* current number of bytes on queue */
@@ -36,4 +44,4 @@ struct msqid64_ds {
 	unsigned long  __unused5;
 };
 
-#endif /* _ASM_X86_MSGBUF_H */
+#endif /* __ASM_GENERIC_MSGBUF_H */
diff --git a/arch/x86/include/asm/param.h b/arch/x86/include/asm/param.h
index 6f0d042..cdf8251 100644
--- a/arch/x86/include/asm/param.h
+++ b/arch/x86/include/asm/param.h
@@ -1,5 +1,5 @@
-#ifndef _ASM_X86_PARAM_H
-#define _ASM_X86_PARAM_H
+#ifndef __ASM_GENERIC_PARAM_H
+#define __ASM_GENERIC_PARAM_H
 
 #ifdef __KERNEL__
 # define HZ		CONFIG_HZ	/* Internal kernel timer frequency */
@@ -11,7 +11,9 @@
 #define HZ 100
 #endif
 
+#ifndef EXEC_PAGESIZE
 #define EXEC_PAGESIZE	4096
+#endif
 
 #ifndef NOGROUP
 #define NOGROUP		(-1)
@@ -19,4 +21,4 @@
 
 #define MAXHOSTNAMELEN	64	/* max length of hostname */
 
-#endif /* _ASM_X86_PARAM_H */
+#endif /* __ASM_GENERIC_PARAM_H */
diff --git a/arch/x86/include/asm/shmbuf.h b/arch/x86/include/asm/shmbuf.h
index b51413b..5768fa6 100644
--- a/arch/x86/include/asm/shmbuf.h
+++ b/arch/x86/include/asm/shmbuf.h
@@ -1,32 +1,40 @@
-#ifndef _ASM_X86_SHMBUF_H
-#define _ASM_X86_SHMBUF_H
+#ifndef __ASM_GENERIC_SHMBUF_H
+#define __ASM_GENERIC_SHMBUF_H
+
+#include <asm/bitsperlong.h>
 
 /*
  * The shmid64_ds structure for x86 architecture.
  * Note extra padding because this structure is passed back and forth
  * between kernel and user space.
  *
- * Pad space on 32 bit is left for:
+ * shmid64_ds was originally meant to be architecture specific, but
+ * everyone just ended up making identical copies without specific
+ * optimizations, so we may just as well all use the same one.
+ *
+ * 64 bit architectures typically define a 64 bit __kernel_time_t,
+ * so they do not need the first two padding words.
+ * On big-endian systems, the padding is in the wrong place.
+ *
+ *
+ * Pad space is left for:
  * - 64-bit time_t to solve y2038 problem
  * - 2 miscellaneous 32-bit values
- *
- * Pad space on 64 bit is left for:
- * - 2 miscellaneous 64-bit values
  */
 
 struct shmid64_ds {
 	struct ipc64_perm	shm_perm;	/* operation perms */
 	size_t			shm_segsz;	/* size of segment (bytes) */
 	__kernel_time_t		shm_atime;	/* last attach time */
-#ifdef __i386__
+#if __BITS_PER_LONG != 64
 	unsigned long		__unused1;
 #endif
 	__kernel_time_t		shm_dtime;	/* last detach time */
-#ifdef __i386__
+#if __BITS_PER_LONG != 64
 	unsigned long		__unused2;
 #endif
 	__kernel_time_t		shm_ctime;	/* last change time */
-#ifdef __i386__
+#if __BITS_PER_LONG != 64
 	unsigned long		__unused3;
 #endif
 	__kernel_pid_t		shm_cpid;	/* pid of creator */
@@ -48,4 +56,4 @@ struct shminfo64 {
 	unsigned long	__unused4;
 };
 
-#endif /* _ASM_X86_SHMBUF_H */
+#endif /* __ASM_GENERIC_SHMBUF_H */
diff --git a/arch/x86/include/asm/socket.h b/arch/x86/include/asm/socket.h
index ca8bf2c..d4ae42a 100644
--- a/arch/x86/include/asm/socket.h
+++ b/arch/x86/include/asm/socket.h
@@ -1,5 +1,5 @@
-#ifndef _ASM_X86_SOCKET_H
-#define _ASM_X86_SOCKET_H
+#ifndef __ASM_GENERIC_SOCKET_H
+#define __ASM_GENERIC_SOCKET_H
 
 #include <asm/sockios.h>
 
@@ -38,8 +38,8 @@
 #define SO_BINDTODEVICE	25
 
 /* Socket filtering */
-#define SO_ATTACH_FILTER        26
-#define SO_DETACH_FILTER        27
+#define SO_ATTACH_FILTER	26
+#define SO_DETACH_FILTER	27
 
 #define SO_PEERNAME		28
 #define SO_TIMESTAMP		29
@@ -57,4 +57,4 @@
 #define SO_TIMESTAMPING		37
 #define SCM_TIMESTAMPING	SO_TIMESTAMPING
 
-#endif /* _ASM_X86_SOCKET_H */
+#endif /* __ASM_GENERIC_SOCKET_H */
diff --git a/arch/x86/include/asm/sockios.h b/arch/x86/include/asm/sockios.h
index 49cc72b..9a61a36 100644
--- a/arch/x86/include/asm/sockios.h
+++ b/arch/x86/include/asm/sockios.h
@@ -1,5 +1,5 @@
-#ifndef _ASM_X86_SOCKIOS_H
-#define _ASM_X86_SOCKIOS_H
+#ifndef __ASM_GENERIC_SOCKIOS_H
+#define __ASM_GENERIC_SOCKIOS_H
 
 /* Socket-level I/O control calls. */
 #define FIOSETOWN	0x8901
@@ -10,4 +10,4 @@
 #define SIOCGSTAMP	0x8906		/* Get stamp (timeval) */
 #define SIOCGSTAMPNS	0x8907		/* Get stamp (timespec) */
 
-#endif /* _ASM_X86_SOCKIOS_H */
+#endif /* __ASM_GENERIC_SOCKIOS_H */
diff --git a/arch/x86/include/asm/termbits.h b/arch/x86/include/asm/termbits.h
index af1b70e..1c9773d 100644
--- a/arch/x86/include/asm/termbits.h
+++ b/arch/x86/include/asm/termbits.h
@@ -1,5 +1,5 @@
-#ifndef _ASM_X86_TERMBITS_H
-#define _ASM_X86_TERMBITS_H
+#ifndef __ASM_GENERIC_TERMBITS_H
+#define __ASM_GENERIC_TERMBITS_H
 
 #include <linux/posix_types.h>
 
@@ -140,7 +140,7 @@ struct ktermios {
 #define HUPCL	0002000
 #define CLOCAL	0004000
 #define CBAUDEX 0010000
-#define	   BOTHER 0010000		/* non standard rate */
+#define    BOTHER 0010000
 #define    B57600 0010001
 #define   B115200 0010002
 #define   B230400 0010003
@@ -195,4 +195,4 @@ struct ktermios {
 #define	TCSADRAIN	1
 #define	TCSAFLUSH	2
 
-#endif /* _ASM_X86_TERMBITS_H */
+#endif /* __ASM_GENERIC_TERMBITS_H */
-- 
1.6.3.1

