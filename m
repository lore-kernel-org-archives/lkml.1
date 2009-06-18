Return-Path: <linux-kernel-owner+w=401wt.eu-S1756906AbZFRR4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906AbZFRR4W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 13:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754712AbZFRRz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 13:55:56 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:53852 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbZFRRzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 13:55:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Michal Simek <monstr@monstr.eu>
Cc: microblaze-uclinux@itee.uq.edu.au, LKML <linux-kernel@vger.kernel.org>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 03/11] microblaze: fall back on generic header files for the ABI
Date: Thu, 18 Jun 2009 19:55:27 +0200
Message-Id: <7a92dd639b7887bc972118d16a5fda6093200b96.1245347640.git.arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <cover.1245345894.git.arnd@arndb.de>
References: <cover.1245345894.git.arnd@arndb.de>
In-Reply-To: <24d10c58e2739bacec05d641ab2a2c95ce6d69a9.1245347640.git.arnd@arndb.de>
References: <24d10c58e2739bacec05d641ab2a2c95ce6d69a9.1245347640.git.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18/pKpLG1fEwULZM4lmFEelzQedWOtL6k2FgLF
 CH1nFvPfLib9wQj4m6uxpRVp2dL/NXbiEYweKUqC6rzVGRNseo
 AkMoChq428sFOApsLbkTw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Almost all of the ABI relevant header files now have generic
versions, so use those now in order to reduce the amount
of architecture specific code.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/microblaze/include/asm/ioctls.h      |   92 +-------------
 arch/microblaze/include/asm/ipcbuf.h      |   37 +-----
 arch/microblaze/include/asm/mman.h        |   26 +----
 arch/microblaze/include/asm/msgbuf.h      |   32 +-----
 arch/microblaze/include/asm/param.h       |   31 +-----
 arch/microblaze/include/asm/posix_types.h |   94 +++----------
 arch/microblaze/include/asm/sembuf.h      |   35 +-----
 arch/microblaze/include/asm/shmbuf.h      |   43 +------
 arch/microblaze/include/asm/siginfo.h     |   14 --
 arch/microblaze/include/asm/socket.h      |   70 +----------
 arch/microblaze/include/asm/sockios.h     |   24 +----
 arch/microblaze/include/asm/stat.h        |   69 +----------
 arch/microblaze/include/asm/swab.h        |    9 +-
 arch/microblaze/include/asm/termbits.h    |  204 +----------------------------
 arch/microblaze/include/asm/termios.h     |   89 +-------------
 arch/microblaze/include/asm/types.h       |   39 +------
 arch/microblaze/include/asm/ucontext.h    |   23 +---
 17 files changed, 36 insertions(+), 895 deletions(-)
 rewrite arch/microblaze/include/asm/ioctls.h (100%)
 rewrite arch/microblaze/include/asm/ipcbuf.h (100%)
 rewrite arch/microblaze/include/asm/mman.h (96%)
 rewrite arch/microblaze/include/asm/msgbuf.h (100%)
 rewrite arch/microblaze/include/asm/param.h (100%)
 rewrite arch/microblaze/include/asm/posix_types.h (96%)
 rewrite arch/microblaze/include/asm/sembuf.h (100%)
 rewrite arch/microblaze/include/asm/shmbuf.h (100%)
 rewrite arch/microblaze/include/asm/socket.h (100%)
 rewrite arch/microblaze/include/asm/sockios.h (100%)
 rewrite arch/microblaze/include/asm/stat.h (100%)
 rewrite arch/microblaze/include/asm/termbits.h (100%)
 rewrite arch/microblaze/include/asm/termios.h (100%)
 rewrite arch/microblaze/include/asm/types.h (100%)
 rewrite arch/microblaze/include/asm/ucontext.h (100%)

diff --git a/arch/microblaze/include/asm/ioctls.h b/arch/microblaze/include/asm/ioctls.h
dissimilarity index 100%
index 03582b2..ec34c76 100644
--- a/arch/microblaze/include/asm/ioctls.h
+++ b/arch/microblaze/include/asm/ioctls.h
@@ -1,91 +1 @@
-/*
- * Copyright (C) 2006 Atmark Techno, Inc.
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License. See the file "COPYING" in the main directory of this archive
- * for more details.
- */
-
-#ifndef _ASM_MICROBLAZE_IOCTLS_H
-#define _ASM_MICROBLAZE_IOCTLS_H
-
-#include <linux/ioctl.h>
-
-/* 0x54 is just a magic number to make these relatively unique ('T') */
-
-#define TCGETS		0x5401
-#define TCSETS		0x5402
-#define TCSETSW		0x5403
-#define TCSETSF		0x5404
-#define TCGETA		0x5405
-#define TCSETA		0x5406
-#define TCSETAW		0x5407
-#define TCSETAF		0x5408
-#define TCSBRK		0x5409
-#define TCXONC		0x540A
-#define TCFLSH		0x540B
-#define TIOCEXCL	0x540C
-#define TIOCNXCL	0x540D
-#define TIOCSCTTY	0x540E
-#define TIOCGPGRP	0x540F
-#define TIOCSPGRP	0x5410
-#define TIOCOUTQ	0x5411
-#define TIOCSTI		0x5412
-#define TIOCGWINSZ	0x5413
-#define TIOCSWINSZ	0x5414
-#define TIOCMGET	0x5415
-#define TIOCMBIS	0x5416
-#define TIOCMBIC	0x5417
-#define TIOCMSET	0x5418
-#define TIOCGSOFTCAR	0x5419
-#define TIOCSSOFTCAR	0x541A
-#define FIONREAD	0x541B
-#define TIOCINQ		FIONREAD
-#define TIOCLINUX	0x541C
-#define TIOCCONS	0x541D
-#define TIOCGSERIAL	0x541E
-#define TIOCSSERIAL	0x541F
-#define TIOCPKT		0x5420
-#define FIONBIO		0x5421
-#define TIOCNOTTY	0x5422
-#define TIOCSETD	0x5423
-#define TIOCGETD	0x5424
-#define TCSBRKP		0x5425 /* Needed for POSIX tcsendbreak() */
-#define TIOCTTYGSTRUCT	0x5426 /* For debugging only */
-#define TIOCSBRK	0x5427 /* BSD compatibility */
-#define TIOCCBRK	0x5428 /* BSD compatibility */
-#define TIOCGSID	0x5429 /* Return the session ID of FD */
-/* Get Pty Number (of pty-mux device) */
-#define TIOCGPTN	_IOR('T', 0x30, unsigned int)
-#define TIOCSPTLCK	_IOW('T', 0x31, int) /* Lock/unlock Pty */
-
-#define FIONCLEX	0x5450 /* these numbers need to be adjusted. */
-#define FIOCLEX		0x5451
-#define FIOASYNC	0x5452
-#define TIOCSERCONFIG	0x5453
-#define TIOCSERGWILD	0x5454
-#define TIOCSERSWILD	0x5455
-#define TIOCGLCKTRMIOS	0x5456
-#define TIOCSLCKTRMIOS	0x5457
-#define TIOCSERGSTRUCT	0x5458 /* For debugging only */
-#define TIOCSERGETLSR	0x5459 /* Get line status register */
-#define TIOCSERGETMULTI 0x545A /* Get multiport config */
-#define TIOCSERSETMULTI 0x545B /* Set multiport config */
-
-#define TIOCMIWAIT	0x545C /* wait for a change on serial input line(s) */
-#define TIOCGICOUNT	0x545D /* read serial port inline interrupt counts */
-
-#define	FIOQSIZE	0x545E
-
-/* Used for packet mode */
-#define TIOCPKT_DATA		0
-#define TIOCPKT_FLUSHREAD	1
-#define TIOCPKT_FLUSHWRITE	2
-#define TIOCPKT_STOP		4
-#define TIOCPKT_START		8
-#define TIOCPKT_NOSTOP		16
-#define TIOCPKT_DOSTOP		32
-
-#define TIOCSER_TEMT	0x01 /* Transmitter physically empty */
-
-#endif /* _ASM_MICROBLAZE_IOCTLS_H */
+#include <asm-generic/ioctls.h>
diff --git a/arch/microblaze/include/asm/ipcbuf.h b/arch/microblaze/include/asm/ipcbuf.h
dissimilarity index 100%
index b056fa4..84c7e51 100644
--- a/arch/microblaze/include/asm/ipcbuf.h
+++ b/arch/microblaze/include/asm/ipcbuf.h
@@ -1,36 +1 @@
-/*
- * Copyright (C) 2006 Atmark Techno, Inc.
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License. See the file "COPYING" in the main directory of this archive
- * for more details.
- */
-
-#ifndef _ASM_MICROBLAZE_IPCBUF_H
-#define _ASM_MICROBLAZE_IPCBUF_H
-
-/*
- * The user_ipc_perm structure for microblaze architecture.
- * Note extra padding because this structure is passed back and forth
- * between kernel and user space.
- *
- * Pad space is left for:
- * - 32-bit mode_t and seq
- * - 2 miscellaneous 32-bit values
- */
-
-struct ipc64_perm {
-	__kernel_key_t		key;
-	__kernel_uid32_t	uid;
-	__kernel_gid32_t	gid;
-	__kernel_uid32_t	cuid;
-	__kernel_gid32_t	cgid;
-	__kernel_mode_t		mode;
-	unsigned short		__pad1;
-	unsigned short		seq;
-	unsigned short		__pad2;
-	unsigned long		__unused1;
-	unsigned long		__unused2;
-};
-
-#endif /* _ASM_MICROBLAZE_IPCBUF_H */
+#include <asm-generic/ipcbuf.h>
diff --git a/arch/microblaze/include/asm/mman.h b/arch/microblaze/include/asm/mman.h
dissimilarity index 96%
index 4914b13..8eebf89 100644
--- a/arch/microblaze/include/asm/mman.h
+++ b/arch/microblaze/include/asm/mman.h
@@ -1,25 +1 @@
-/*
- * Copyright (C) 2006 Atmark Techno, Inc.
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License. See the file "COPYING" in the main directory of this archive
- * for more details.
- */
-
-#ifndef _ASM_MICROBLAZE_MMAN_H
-#define _ASM_MICROBLAZE_MMAN_H
-
-#include <asm-generic/mman.h>
-
-#define MAP_GROWSDOWN	0x0100 /* stack-like segment */
-#define MAP_DENYWRITE	0x0800 /* ETXTBSY */
-#define MAP_EXECUTABLE	0x1000 /* mark it as an executable */
-#define MAP_LOCKED	0x2000 /* pages are locked */
-#define MAP_NORESERVE	0x4000 /* don't check for reservations */
-#define MAP_POPULATE	0x8000 /* populate (prefault) pagetables */
-#define MAP_NONBLOCK	0x10000 /* do not block on IO */
-
-#define MCL_CURRENT	1 /* lock all current mappings */
-#define MCL_FUTURE	2 /* lock all future mappings */
-
-#endif /* _ASM_MICROBLAZE_MMAN_H */
+#include <asm-generic/mman.h>
diff --git a/arch/microblaze/include/asm/msgbuf.h b/arch/microblaze/include/asm/msgbuf.h
dissimilarity index 100%
index 09dd970..809134c 100644
--- a/arch/microblaze/include/asm/msgbuf.h
+++ b/arch/microblaze/include/asm/msgbuf.h
@@ -1,31 +1 @@
-#ifndef _ASM_MICROBLAZE_MSGBUF_H
-#define _ASM_MICROBLAZE_MSGBUF_H
-
-/*
- * The msqid64_ds structure for microblaze architecture.
- * Note extra padding because this structure is passed back and forth
- * between kernel and user space.
- *
- * Pad space is left for:
- * - 64-bit time_t to solve y2038 problem
- * - 2 miscellaneous 32-bit values
- */
-
-struct msqid64_ds {
-	struct ipc64_perm msg_perm;
-	__kernel_time_t msg_stime; /* last msgsnd time */
-	unsigned long __unused1;
-	__kernel_time_t msg_rtime; /* last msgrcv time */
-	unsigned long __unused2;
-	__kernel_time_t msg_ctime; /* last change time */
-	unsigned long __unused3;
-	unsigned long msg_cbytes; /* current number of bytes on queue */
-	unsigned long msg_qnum; /* number of messages in queue */
-	unsigned long msg_qbytes; /* max number of bytes on queue */
-	__kernel_pid_t msg_lspid; /* pid of last msgsnd */
-	__kernel_pid_t msg_lrpid; /* last receive pid */
-	unsigned long __unused4;
-	unsigned long __unused5;
-};
-
-#endif /* _ASM_MICROBLAZE_MSGBUF_H */
+#include <asm-generic/msgbuf.h>
diff --git a/arch/microblaze/include/asm/param.h b/arch/microblaze/include/asm/param.h
dissimilarity index 100%
index 8c538a4..965d454 100644
--- a/arch/microblaze/include/asm/param.h
+++ b/arch/microblaze/include/asm/param.h
@@ -1,30 +1 @@
-/*
- * Copyright (C) 2006 Atmark Techno, Inc.
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License. See the file "COPYING" in the main directory of this archive
- * for more details.
- */
-
-#ifndef _ASM_MICROBLAZE_PARAM_H
-#define _ASM_MICROBLAZE_PARAM_H
-
-#ifdef __KERNEL__
-#define HZ		CONFIG_HZ	/* internal kernel timer frequency */
-#define USER_HZ		100		/* for user interfaces in "ticks" */
-#define CLOCKS_PER_SEC	(USER_HZ)	/* frequency at which times() counts */
-#endif /* __KERNEL__ */
-
-#ifndef HZ
-#define HZ 100
-#endif
-
-#define EXEC_PAGESIZE	4096
-
-#ifndef NOGROUP
-#define NOGROUP		(-1)
-#endif
-
-#define MAXHOSTNAMELEN	64	/* max length of hostname */
-
-#endif /* _ASM_MICROBLAZE_PARAM_H */
+#include <asm-generic/param.h>
diff --git a/arch/microblaze/include/asm/posix_types.h b/arch/microblaze/include/asm/posix_types.h
dissimilarity index 96%
index 8c758b2..e890d6c 100644
--- a/arch/microblaze/include/asm/posix_types.h
+++ b/arch/microblaze/include/asm/posix_types.h
@@ -1,73 +1,21 @@
-/*
- * Copyright (C) 2006 Atmark Techno, Inc.
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License. See the file "COPYING" in the main directory of this archive
- * for more details.
- */
-
-#ifndef _ASM_MICROBLAZE_POSIX_TYPES_H
-#define _ASM_MICROBLAZE_POSIX_TYPES_H
-
-/*
- * This file is generally used by user-level software, so you need to
- * be a little careful about namespace pollution etc. Also, we cannot
- * assume GCC is being used.
- */
-
-typedef unsigned long	__kernel_ino_t;
-typedef unsigned short	__kernel_mode_t;
-typedef unsigned int	__kernel_nlink_t;
-typedef long		__kernel_off_t;
-typedef int		__kernel_pid_t;
-typedef unsigned int	__kernel_ipc_pid_t;
-typedef unsigned int	__kernel_uid_t;
-typedef unsigned int	__kernel_gid_t;
-typedef unsigned long	__kernel_size_t;
-typedef long		__kernel_ssize_t;
-typedef int		__kernel_ptrdiff_t;
-typedef long		__kernel_time_t;
-typedef long		__kernel_suseconds_t;
-typedef long		__kernel_clock_t;
-typedef int		__kernel_timer_t;
-typedef int		__kernel_clockid_t;
-typedef int		__kernel_daddr_t;
-typedef char 		*__kernel_caddr_t;
-typedef unsigned short	__kernel_uid16_t;
-typedef unsigned short	__kernel_gid16_t;
-typedef unsigned int	__kernel_uid32_t;
-typedef unsigned int	__kernel_gid32_t;
-
-typedef unsigned int	__kernel_old_uid_t;
-typedef unsigned int	__kernel_old_gid_t;
-typedef unsigned int	__kernel_old_dev_t;
-
-#ifdef __GNUC__
-typedef long long	__kernel_loff_t;
-#endif
-
-typedef struct {
-#if defined(__KERNEL__) || defined(__USE_ALL)
-	int	val[2];
-#else /* !defined(__KERNEL__) && !defined(__USE_ALL) */
-	int	__val[2];
-#endif /* !defined(__KERNEL__) && !defined(__USE_ALL) */
-} __kernel_fsid_t;
-
-#if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)
-
-#undef	__FD_SET
-#define	__FD_SET(d, set)	((set)->fds_bits[__FDELT(d)] |= __FDMASK(d))
-
-#undef	__FD_CLR
-#define	__FD_CLR(d, set)	((set)->fds_bits[__FDELT(d)] &= ~__FDMASK(d))
-
-#undef	__FD_ISSET
-#define	__FD_ISSET(d, set)	(!!((set)->fds_bits[__FDELT(d)] & __FDMASK(d)))
-
-#undef	__FD_ZERO
-#define __FD_ZERO(fdsetp) (memset(fdsetp, 0, sizeof(*(fd_set *)fdsetp)))
-
-#endif /* defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2) */
-
-#endif /* _ASM_MICROBLAZE_POSIX_TYPES_H */
+#ifndef __ASM_MICRBLAZE_POSIX_TYPES_H
+#define __ASM_MICRBLAZE_POSIX_TYPES_H
+
+/*
+ * Our tool chain uses 'unsigned long' for size_t,
+ * so the kernel should too. If there is a chance
+ * to update the tool chain, that should probably
+ * be done so it does the same as most of the
+ * other architectures.
+ *
+ * Overriding this mostly has the effect of
+ * avoiding compiler warnings.
+ */
+typedef unsigned long	__kernel_size_t;
+typedef long		__kernel_ssize_t;
+typedef long		__kernel_ptrdiff_t;
+#define __kernel_size_t __kernel_size_t
+
+#include <asm-generic/posix_types.h>
+
+#endif /* __ASM_MICRBLAZE_POSIX_TYPES_H */
diff --git a/arch/microblaze/include/asm/sembuf.h b/arch/microblaze/include/asm/sembuf.h
dissimilarity index 100%
index b804ed7..7673b83 100644
--- a/arch/microblaze/include/asm/sembuf.h
+++ b/arch/microblaze/include/asm/sembuf.h
@@ -1,34 +1 @@
-/*
- * Copyright (C) 2006 Atmark Techno, Inc.
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License. See the file "COPYING" in the main directory of this archive
- * for more details.
- */
-
-#ifndef _ASM_MICROBLAZE_SEMBUF_H
-#define _ASM_MICROBLAZE_SEMBUF_H
-
-/*
- * The semid64_ds structure for microblaze architecture.
- * Note extra padding because this structure is passed back and forth
- * between kernel and user space.
- *
- * Pad space is left for:
- * - 64-bit time_t to solve y2038 problem
- * - 2 miscellaneous 32-bit values
- */
-
-struct semid64_ds {
-	struct ipc64_perm sem_perm; /* permissions .. see ipc.h */
-	__kernel_time_t	sem_otime; /* last semop time */
-	unsigned long	__unused1;
-	__kernel_time_t	sem_ctime; /* last change time */
-	unsigned long	__unused2;
-	unsigned long	sem_nsems; /* no. of semaphores in array */
-	unsigned long	__unused3;
-	unsigned long	__unused4;
-};
-
-
-#endif /* _ASM_MICROBLAZE_SEMBUF_H */
+#include <asm-generic/sembuf.h>
diff --git a/arch/microblaze/include/asm/shmbuf.h b/arch/microblaze/include/asm/shmbuf.h
dissimilarity index 100%
index f829c58..83c05fc 100644
--- a/arch/microblaze/include/asm/shmbuf.h
+++ b/arch/microblaze/include/asm/shmbuf.h
@@ -1,42 +1 @@
-#ifndef _ASM_MICROBLAZE_SHMBUF_H
-#define _ASM_MICROBLAZE_SHMBUF_H
-
-/*
- * The shmid64_ds structure for microblaze architecture.
- * Note extra padding because this structure is passed back and forth
- * between kernel and user space.
- *
- * Pad space is left for:
- * - 64-bit time_t to solve y2038 problem
- * - 2 miscellaneous 32-bit values
- */
-
-struct shmid64_ds {
-	struct ipc64_perm	shm_perm; /* operation perms */
-	size_t			shm_segsz; /* size of segment (bytes) */
-	__kernel_time_t		shm_atime; /* last attach time */
-	unsigned long		__unused1;
-	__kernel_time_t		shm_dtime; /* last detach time */
-	unsigned long		__unused2;
-	__kernel_time_t		shm_ctime; /* last change time */
-	unsigned long		__unused3;
-	__kernel_pid_t		shm_cpid; /* pid of creator */
-	__kernel_pid_t		shm_lpid; /* pid of last operator */
-	unsigned long		shm_nattch; /* no. of current attaches */
-	unsigned long		__unused4;
-	unsigned long		__unused5;
-};
-
-struct shminfo64 {
-	unsigned long	shmmax;
-	unsigned long	shmmin;
-	unsigned long	shmmni;
-	unsigned long	shmseg;
-	unsigned long	shmall;
-	unsigned long	__unused1;
-	unsigned long	__unused2;
-	unsigned long	__unused3;
-	unsigned long	__unused4;
-};
-
-#endif /* _ASM_MICROBLAZE_SHMBUF_H */
+#include <asm-generic/shmbuf.h>
diff --git a/arch/microblaze/include/asm/siginfo.h b/arch/microblaze/include/asm/siginfo.h
index f162911..0815d29 100644
--- a/arch/microblaze/include/asm/siginfo.h
+++ b/arch/microblaze/include/asm/siginfo.h
@@ -1,15 +1 @@
-/*
- * Copyright (C) 2006 Atmark Techno, Inc.
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License. See the file "COPYING" in the main directory of this archive
- * for more details.
- */
-
-#ifndef _ASM_MICROBLAZE_SIGINFO_H
-#define _ASM_MICROBLAZE_SIGINFO_H
-
-#include <linux/types.h>
 #include <asm-generic/siginfo.h>
-
-#endif /* _ASM_MICROBLAZE_SIGINFO_H */
diff --git a/arch/microblaze/include/asm/socket.h b/arch/microblaze/include/asm/socket.h
dissimilarity index 100%
index 8259368..6b71384 100644
--- a/arch/microblaze/include/asm/socket.h
+++ b/arch/microblaze/include/asm/socket.h
@@ -1,69 +1 @@
-/*
- * Copyright (C) 2006 Atmark Techno, Inc.
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License. See the file "COPYING" in the main directory of this archive
- * for more details.
- */
-
-#ifndef _ASM_MICROBLAZE_SOCKET_H
-#define _ASM_MICROBLAZE_SOCKET_H
-
-#include <asm/sockios.h>
-
-/* For setsockoptions(2) */
-#define SOL_SOCKET	1
-
-#define SO_DEBUG	1
-#define SO_REUSEADDR	2
-#define SO_TYPE		3
-#define SO_ERROR	4
-#define SO_DONTROUTE	5
-#define SO_BROADCAST	6
-#define SO_SNDBUF	7
-#define SO_RCVBUF	8
-#define SO_SNDBUFFORCE	32
-#define SO_RCVBUFFORCE	33
-#define SO_KEEPALIVE	9
-#define SO_OOBINLINE	10
-#define SO_NO_CHECK	11
-#define SO_PRIORITY	12
-#define SO_LINGER	13
-#define SO_BSDCOMPAT	14
-/* To add :#define SO_REUSEPORT 15 */
-#define SO_PASSCRED	16
-#define SO_PEERCRED	17
-#define SO_RCVLOWAT	18
-#define SO_SNDLOWAT	19
-#define SO_RCVTIMEO	20
-#define SO_SNDTIMEO	21
-
-/* Security levels - as per NRL IPv6 - don't actually do anything */
-#define SO_SECURITY_AUTHENTICATION		22
-#define SO_SECURITY_ENCRYPTION_TRANSPORT	23
-#define SO_SECURITY_ENCRYPTION_NETWORK		24
-
-#define SO_BINDTODEVICE	25
-
-/* Socket filtering */
-#define SO_ATTACH_FILTER	26
-#define SO_DETACH_FILTER	27
-
-#define SO_PEERNAME		28
-#define SO_TIMESTAMP		29
-#define SCM_TIMESTAMP		SO_TIMESTAMP
-
-#define SO_ACCEPTCONN		30
-
-#define SO_PEERSEC		31
-#define SO_PASSSEC		34
-
-#define SO_TIMESTAMPNS		35
-#define SCM_TIMESTAMPNS		SO_TIMESTAMPNS
-
-#define SO_MARK			36
-
-#define SO_TIMESTAMPING		37
-#define SCM_TIMESTAMPING	SO_TIMESTAMPING
-
-#endif /* _ASM_MICROBLAZE_SOCKET_H */
+#include <asm-generic/socket.h>
diff --git a/arch/microblaze/include/asm/sockios.h b/arch/microblaze/include/asm/sockios.h
dissimilarity index 100%
index 9fff57a..def6d47 100644
--- a/arch/microblaze/include/asm/sockios.h
+++ b/arch/microblaze/include/asm/sockios.h
@@ -1,23 +1 @@
-/*
- * Copyright (C) 2006 Atmark Techno, Inc.
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License. See the file "COPYING" in the main directory of this archive
- * for more details.
- */
-
-#ifndef _ASM_MICROBLAZE_SOCKIOS_H
-#define _ASM_MICROBLAZE_SOCKIOS_H
-
-#include <linux/ioctl.h>
-
-/* Socket-level I/O control calls. */
-#define FIOSETOWN	0x8901
-#define SIOCSPGRP	0x8902
-#define FIOGETOWN	0x8903
-#define SIOCGPGRP	0x8904
-#define SIOCATMARK	0x8905
-#define SIOCGSTAMP	0x8906		/* Get stamp (timeval) */
-#define SIOCGSTAMPNS	0x8907		/* Get stamp (timespec) */
-
-#endif /* _ASM_MICROBLAZE_SOCKIOS_H */
+#include <asm-generic/sockios.h>
diff --git a/arch/microblaze/include/asm/stat.h b/arch/microblaze/include/asm/stat.h
dissimilarity index 100%
index a15f775..3dc90fa 100644
--- a/arch/microblaze/include/asm/stat.h
+++ b/arch/microblaze/include/asm/stat.h
@@ -1,68 +1 @@
-/*
- * Microblaze stat structure
- *
- * Copyright (C) 2001,02,03 NEC Electronics Corporation
- * Copyright (C) 2001,02,03 Miles Bader <miles@gnu.org>
- *
- * This file is subject to the terms and conditions of the GNU General
- * Public License. See the file COPYING in the main directory of this
- * archive for more details.
- *
- * Written by Miles Bader <miles@gnu.org>
- */
-
-#ifndef _ASM_MICROBLAZE_STAT_H
-#define _ASM_MICROBLAZE_STAT_H
-
-#include <linux/posix_types.h>
-
-#define STAT_HAVE_NSEC 1
-
-struct stat {
-	unsigned long	st_dev;
-	unsigned long	st_ino;
-	unsigned int	st_mode;
-	unsigned int	st_nlink;
-	unsigned int	st_uid;
-	unsigned int	st_gid;
-	unsigned long	st_rdev;
-	unsigned long	__pad1;
-	long		st_size;
-	int		st_blksize;
-	int		__pad2;
-	long		st_blocks;
-	int		st_atime;
-	unsigned int	st_atime_nsec;
-	int		st_mtime;
-	unsigned int	st_mtime_nsec;
-	int		st_ctime;
-	unsigned int	st_ctime_nsec;
-	unsigned long	__unused4;
-	unsigned long	__unused5;
-};
-
-struct stat64 {
-	unsigned long long	st_dev;		/* Device.  */
-	unsigned long long	st_ino;		/* File serial number.  */
-	unsigned int		st_mode;	/* File mode.  */
-	unsigned int		st_nlink;	/* Link count.  */
-	unsigned int		st_uid;		/* User ID of the file's owner.  */
-	unsigned int		st_gid;		/* Group ID of the file's group. */
-	unsigned long long	st_rdev;	/* Device number, if device.  */
-	unsigned long long	__pad1;
-	long long		st_size;	/* Size of file, in bytes.  */
-	int			st_blksize;	/* Optimal block size for I/O.  */
-	int			__pad2;
-	long long		st_blocks;	/* Number 512-byte blocks allocated. */
-	int			st_atime;	/* Time of last access.  */
-	unsigned int		st_atime_nsec;
-	int			st_mtime;	/* Time of last modification.  */
-	unsigned int		st_mtime_nsec;
-	int			st_ctime;	/* Time of last status change.  */
-	unsigned int		st_ctime_nsec;
-	unsigned int		__unused4;
-	unsigned int		__unused5;
-};
-
-#endif /* _ASM_MICROBLAZE_STAT_H */
-
+#include <asm-generic/stat.h>
diff --git a/arch/microblaze/include/asm/swab.h b/arch/microblaze/include/asm/swab.h
index b375d7b..7847e56 100644
--- a/arch/microblaze/include/asm/swab.h
+++ b/arch/microblaze/include/asm/swab.h
@@ -1,8 +1 @@
-#ifndef _ASM_MICROBLAZE_SWAB_H
-#define _ASM_MICROBLAZE_SWAB_H
-
-#if defined(__GNUC__) && !defined(__STRICT_ANSI__) || defined(__KERNEL__)
-#define __SWAB_64_THRU_32__
-#endif
-
-#endif /* _ASM_MICROBLAZE_SWAB_H */
+#include <asm-generic/swab.h>
diff --git a/arch/microblaze/include/asm/termbits.h b/arch/microblaze/include/asm/termbits.h
dissimilarity index 100%
index a1b64bc..3935b10 100644
--- a/arch/microblaze/include/asm/termbits.h
+++ b/arch/microblaze/include/asm/termbits.h
@@ -1,203 +1 @@
-/*
- * Copyright (C) 2006 Atmark Techno, Inc.
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License. See the file "COPYING" in the main directory of this archive
- * for more details.
- */
-
-#ifndef _ASM_MICROBLAZE_TERMBITS_H
-#define _ASM_MICROBLAZE_TERMBITS_H
-
-#include <linux/posix_types.h>
-
-typedef unsigned char	cc_t;
-typedef unsigned int	speed_t;
-typedef unsigned int	tcflag_t;
-
-#define NCCS 19
-struct termios {
-	tcflag_t c_iflag; /* input mode flags */
-	tcflag_t c_oflag; /* output mode flags */
-	tcflag_t c_cflag; /* control mode flags */
-	tcflag_t c_lflag; /* local mode flags */
-	cc_t c_line; /* line discipline */
-	cc_t c_cc[NCCS]; /* control characters */
-};
-
-struct ktermios {
-	tcflag_t c_iflag; /* input mode flags */
-	tcflag_t c_oflag; /* output mode flags */
-	tcflag_t c_cflag; /* control mode flags */
-	tcflag_t c_lflag; /* local mode flags */
-	cc_t c_line; /* line discipline */
-	cc_t c_cc[NCCS]; /* control characters */
-	speed_t c_ispeed; /* input speed */
-	speed_t c_ospeed; /* output speed */
-};
-
-/* c_cc characters */
-
-#define VINTR 0
-#define VQUIT 1
-#define VERASE 2
-#define VKILL 3
-#define VEOF 4
-#define VTIME 5
-#define VMIN 6
-#define VSWTC 7
-#define VSTART 8
-#define VSTOP 9
-#define VSUSP 10
-#define VEOL 11
-#define VREPRINT 12
-#define VDISCARD 13
-#define VWERASE 14
-#define VLNEXT 15
-#define VEOL2 16
-
-/* c_iflag bits */
-
-#define IGNBRK	0000001
-#define BRKINT	0000002
-#define IGNPAR	0000004
-#define PARMRK	0000010
-#define INPCK	0000020
-#define ISTRIP	0000040
-#define INLCR	0000100
-#define IGNCR	0000200
-#define ICRNL	0000400
-#define IUCLC	0001000
-#define IXON	0002000
-#define IXANY	0004000
-#define IXOFF	0010000
-#define IMAXBEL	0020000
-#define IUTF8	0040000
-
-/* c_oflag bits */
-
-#define OPOST	0000001
-#define OLCUC	0000002
-#define ONLCR	0000004
-#define OCRNL	0000010
-#define ONOCR	0000020
-#define ONLRET	0000040
-#define OFILL	0000100
-#define OFDEL	0000200
-#define NLDLY	0000400
-#define NL0	0000000
-#define NL1	0000400
-#define CRDLY	0003000
-#define CR0	0000000
-#define CR1	0001000
-#define CR2	0002000
-#define CR3	0003000
-#define TABDLY	0014000
-#define TAB0	0000000
-#define TAB1	0004000
-#define TAB2	0010000
-#define TAB3	0014000
-#define XTABS	0014000
-#define BSDLY	0020000
-#define BS0	0000000
-#define BS1	0020000
-#define VTDLY	0040000
-#define VT0	0000000
-#define VT1	0040000
-#define FFDLY	0100000
-#define FF0	0000000
-#define FF1	0100000
-
-/* c_cflag bit meaning */
-
-#define CBAUD	0010017
-#define B0	0000000 /* hang up */
-#define B50	0000001
-#define B75	0000002
-#define B110	0000003
-#define B134	0000004
-#define B150	0000005
-#define B200	0000006
-#define B300	0000007
-#define B600	0000010
-#define B1200	0000011
-#define B1800	0000012
-#define B2400	0000013
-#define B4800	0000014
-#define B9600	0000015
-#define B19200	0000016
-#define B38400	0000017
-#define EXTA B19200
-#define EXTB B38400
-#define CSIZE	0000060
-#define CS5	0000000
-#define CS6	0000020
-#define CS7	0000040
-#define CS8	0000060
-#define CSTOPB	0000100
-#define CREAD	0000200
-#define PARENB	0000400
-#define PARODD	0001000
-#define HUPCL	0002000
-#define CLOCAL	0004000
-#define CBAUDEX	0010000
-#define B57600	0010001
-#define B115200	0010002
-#define B230400	0010003
-#define B460800	0010004
-#define B500000	0010005
-#define B576000	0010006
-#define B921600	0010007
-#define BOTHER		0010000
-#define B1000000	0010010
-#define B1152000	0010011
-#define B1500000	0010012
-#define B2000000	0010013
-#define B2500000	0010014
-#define B3000000	0010015
-#define B3500000	0010016
-#define B4000000	0010017
-#define CIBAUD		002003600000 /* input baud rate (not used) */
-#define CMSPAR		010000000000 /* mark or space (stick) parity */
-#define CRTSCTS		020000000000 /* flow control */
-
-#define IBSHIFT	16		/* Shift from CBAUD to CIBAUD */
-
-/* c_lflag bits */
-
-#define ISIG	0000001
-#define ICANON	0000002
-#define XCASE	0000004
-#define ECHO	0000010
-#define ECHOE	0000020
-#define ECHOK	0000040
-#define ECHONL	0000100
-#define NOFLSH	0000200
-#define TOSTOP	0000400
-#define ECHOCTL	0001000
-#define ECHOPRT	0002000
-#define ECHOKE	0004000
-#define FLUSHO	0010000
-#define PENDIN	0040000
-#define IEXTEN	0100000
-
-/* tcflow() and TCXONC use these */
-
-#define	TCOOFF		0
-#define	TCOON		1
-#define	TCIOFF		2
-#define	TCION		3
-
-/* tcflush() and TCFLSH use these */
-
-#define	TCIFLUSH	0
-#define	TCOFLUSH	1
-#define	TCIOFLUSH	2
-
-/* tcsetattr uses these */
-
-#define	TCSANOW		0
-#define	TCSADRAIN	1
-#define	TCSAFLUSH	2
-
-#endif /* _ASM_MICROBLAZE_TERMBITS_H */
+#include <asm-generic/termbits.h>
diff --git a/arch/microblaze/include/asm/termios.h b/arch/microblaze/include/asm/termios.h
dissimilarity index 100%
index 47a46d1..280d78a 100644
--- a/arch/microblaze/include/asm/termios.h
+++ b/arch/microblaze/include/asm/termios.h
@@ -1,88 +1 @@
-/*
- * Copyright (C) 2006 Atmark Techno, Inc.
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License. See the file "COPYING" in the main directory of this archive
- * for more details.
- */
-
-#ifndef _ASM_MICROBLAZE_TERMIOS_H
-#define _ASM_MICROBLAZE_TERMIOS_H
-
-#include <linux/string.h>
-#include <asm/termbits.h>
-#include <asm/ioctls.h>
-
-struct winsize {
-	unsigned short ws_row;
-	unsigned short ws_col;
-	unsigned short ws_xpixel;
-	unsigned short ws_ypixel;
-};
-
-#define NCC 8
-struct termio {
-	unsigned short c_iflag; /* input mode flags */
-	unsigned short c_oflag; /* output mode flags */
-	unsigned short c_cflag; /* control mode flags */
-	unsigned short c_lflag; /* local mode flags */
-	unsigned char c_line; /* line discipline */
-	unsigned char c_cc[NCC]; /* control characters */
-};
-
-#ifdef __KERNEL__
-/*	intr=^C		quit=^|		erase=del	kill=^U
-	eof=^D		vtime=\0	vmin=\1		sxtc=\0
-	start=^Q	stop=^S		susp=^Z		eol=\0
-	reprint=^R	discard=^U	werase=^W	lnext=^V
-	eol2=\0
-*/
-#define INIT_C_CC "\003\034\177\025\004\0\1\0\021\023\032\0\022\017\027\026\0"
-#endif
-
-/* Modem lines */
-
-#define TIOCM_LE	0x001
-#define TIOCM_DTR	0x002
-#define TIOCM_RTS	0x004
-#define TIOCM_ST	0x008
-#define TIOCM_SR	0x010
-#define TIOCM_CTS	0x020
-#define TIOCM_CAR	0x040
-#define TIOCM_RNG	0x080
-#define TIOCM_DSR	0x100
-#define TIOCM_CD	TIOCM_CAR
-#define TIOCM_RI	TIOCM_RNG
-#define TIOCM_OUT1	0x2000
-#define TIOCM_OUT2	0x4000
-#define TIOCM_LOOP	0x8000
-
-/* ioctl (fd, TIOCSERGETLSR, &result) where result may be as below */
-
-/* Line disciplines */
-
-#define N_TTY		0
-#define N_SLIP		1
-#define N_MOUSE		2
-#define N_PPP		3
-#define N_STRIP		4
-#define N_AX25		5
-#define N_X25		6 /* X.25 async */
-#define N_6PACK		7
-#define N_MASC		8 /* Reserved for Mobitex module <kaz@cafe.net> */
-#define N_R3964		9 /* Reserved for Simatic R3964 module */
-#define N_PROFIBUS_FDL	10 /* Reserved for Profibus <Dave@mvhi.com> */
-#define N_IRDA		11 /* Linux IR - http://irda.sourceforge.net/ */
-#define N_SMSBLOCK	12 /* SMS block mode - for talking to GSM data cards
-				about SMS messages */
-#define N_HDLC		13 /* synchronous HDLC */
-#define N_SYNC_PPP	14
-#define N_HCI		15 /* Bluetooth HCI UART */
-
-#ifdef __KERNEL__
-
-#include <asm-generic/termios-base.h>
-
-#endif	/* __KERNEL__ */
-
-#endif /* _ASM_MICROBLAZE_TERMIOS_H */
+#include <asm-generic/termios.h>
diff --git a/arch/microblaze/include/asm/types.h b/arch/microblaze/include/asm/types.h
dissimilarity index 100%
index bebc018..b9e79bc 100644
--- a/arch/microblaze/include/asm/types.h
+++ b/arch/microblaze/include/asm/types.h
@@ -1,38 +1 @@
-/*
- * Copyright (C) Atmark Techno, Inc.
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License. See the file "COPYING" in the main directory of this archive
- * for more details.
- */
-
-#ifndef _ASM_MICROBLAZE_TYPES_H
-#define _ASM_MICROBLAZE_TYPES_H
-
-/*
- * This file is never included by application software unless
- * explicitly requested (e.g., via linux/types.h) in which case the
- * application is Linux specific so (user-) name space pollution is
- * not a major issue.  However, for interoperability, libraries still
- * need to be careful to avoid a name clashes.
- */
-
-#include <asm-generic/int-ll64.h>
-
-# ifndef __ASSEMBLY__
-
-typedef unsigned short umode_t;
-
-/*
- * These aren't exported outside the kernel to avoid name space clashes
- */
-#  ifdef __KERNEL__
-#  define BITS_PER_LONG 32
-
-/* Dma addresses are 32-bits wide. */
-
-typedef u32 dma_addr_t;
-
-#  endif/* __KERNEL__ */
-# endif /* __ASSEMBLY__ */
-#endif /* _ASM_MICROBLAZE_TYPES_H */
+#include <asm-generic/types.h>
diff --git a/arch/microblaze/include/asm/ucontext.h b/arch/microblaze/include/asm/ucontext.h
dissimilarity index 100%
index 11f6bb3..9bc07b9 100644
--- a/arch/microblaze/include/asm/ucontext.h
+++ b/arch/microblaze/include/asm/ucontext.h
@@ -1,22 +1 @@
-/*
- * Copyright (C) 2006 Atmark Techno, Inc.
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License. See the file "COPYING" in the main directory of this archive
- * for more details.
- */
-
-#ifndef _ASM_MICROBLAZE_UCONTEXT_H
-#define _ASM_MICROBLAZE_UCONTEXT_H
-
-#include <asm/sigcontext.h>
-
-struct ucontext {
-	unsigned long		uc_flags;
-	struct ucontext		*uc_link;
-	stack_t			uc_stack;
-	struct sigcontext	uc_mcontext;
-	sigset_t		uc_sigmask; /* mask last for extensibility */
-};
-
-#endif /* _ASM_MICROBLAZE_UCONTEXT_H */
+#include <asm-generic/ucontext.h>
-- 
1.6.3.1

