Return-Path: <linux-kernel-owner+w=401wt.eu-S1756130AbZFRVo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130AbZFRVo2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 17:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756655AbZFRVoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 17:44:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:34680 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756654AbZFRVoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 17:44:07 -0400
Date: Thu, 18 Jun 2009 21:43:41 GMT
From: tip-bot for Arnd Bergmann <arnd@arndb.de>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <cover.1245354003.git.arnd@arndb.de>
References: <cover.1245354003.git.arnd@arndb.de>
Subject: [tip:x86/asm-generic] x86: remove all now-duplicate header files
Message-ID: <tip-73a2d096fdf23aa841f7595d114a11ec85a85e4d@git.kernel.org>
Git-Commit-ID: 73a2d096fdf23aa841f7595d114a11ec85a85e4d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 18 Jun 2009 21:43:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  73a2d096fdf23aa841f7595d114a11ec85a85e4d
Gitweb:     http://git.kernel.org/tip/73a2d096fdf23aa841f7595d114a11ec85a85e4d
Author:     Arnd Bergmann <arnd@arndb.de>
AuthorDate: Thu, 18 Jun 2009 21:48:20 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 18 Jun 2009 14:40:03 -0700

x86: remove all now-duplicate header files

All files that have been made identical to the asm-generic
version in the previous patches can now be removed,
guaranteeing that this does not introduce semantic changes.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
LKML-Reference: <cover.1245354003.git.arnd@arndb.de>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>


---
 arch/x86/include/asm/generic-mman.h        |   18 ---
 arch/x86/include/asm/generic-module.h      |   22 ---
 arch/x86/include/asm/generic-scatterlist.h |   43 ------
 arch/x86/include/asm/generic-types.h       |   42 ------
 arch/x86/include/asm/generic-ucontext.h    |   12 --
 arch/x86/include/asm/ioctls.h              |  111 +---------------
 arch/x86/include/asm/ipcbuf.h              |   34 +-----
 arch/x86/include/asm/mman.h                |    2 +-
 arch/x86/include/asm/module.h              |    2 +-
 arch/x86/include/asm/msgbuf.h              |   48 +-------
 arch/x86/include/asm/param.h               |   25 +----
 arch/x86/include/asm/scatterlist.h         |    2 +-
 arch/x86/include/asm/shmbuf.h              |   60 +--------
 arch/x86/include/asm/socket.h              |   61 +---------
 arch/x86/include/asm/sockios.h             |   14 +--
 arch/x86/include/asm/termbits.h            |  199 +---------------------------
 arch/x86/include/asm/termios.h             |  155 +---------------------
 arch/x86/include/asm/types.h               |    2 +-
 arch/x86/include/asm/ucontext.h            |    2 +-
 19 files changed, 14 insertions(+), 840 deletions(-)

diff --git a/arch/x86/include/asm/generic-mman.h b/arch/x86/include/asm/generic-mman.h
deleted file mode 100644
index 7cab4de..0000000
--- a/arch/x86/include/asm/generic-mman.h
+++ /dev/null
@@ -1,18 +0,0 @@
-#ifndef __ASM_GENERIC_MMAN_H
-#define __ASM_GENERIC_MMAN_H
-
-#include <asm-generic/mman-common.h>
-
-#define MAP_GROWSDOWN	0x0100		/* stack-like segment */
-#define MAP_DENYWRITE	0x0800		/* ETXTBSY */
-#define MAP_EXECUTABLE	0x1000		/* mark it as an executable */
-#define MAP_LOCKED	0x2000		/* pages are locked */
-#define MAP_NORESERVE	0x4000		/* don't check for reservations */
-#define MAP_POPULATE	0x8000		/* populate (prefault) pagetables */
-#define MAP_NONBLOCK	0x10000		/* do not block on IO */
-#define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
-
-#define MCL_CURRENT	1		/* lock all current mappings */
-#define MCL_FUTURE	2		/* lock all future mappings */
-
-#endif /* __ASM_GENERIC_MMAN_H */
diff --git a/arch/x86/include/asm/generic-module.h b/arch/x86/include/asm/generic-module.h
deleted file mode 100644
index ed5b44d..0000000
--- a/arch/x86/include/asm/generic-module.h
+++ /dev/null
@@ -1,22 +0,0 @@
-#ifndef __ASM_GENERIC_MODULE_H
-#define __ASM_GENERIC_MODULE_H
-
-/*
- * Many architectures just need a simple module
- * loader without arch specific data.
- */
-struct mod_arch_specific
-{
-};
-
-#ifdef CONFIG_64BIT
-#define Elf_Shdr Elf64_Shdr
-#define Elf_Sym Elf64_Sym
-#define Elf_Ehdr Elf64_Ehdr
-#else
-#define Elf_Shdr Elf32_Shdr
-#define Elf_Sym Elf32_Sym
-#define Elf_Ehdr Elf32_Ehdr
-#endif
-
-#endif /* __ASM_GENERIC_MODULE_H */
diff --git a/arch/x86/include/asm/generic-scatterlist.h b/arch/x86/include/asm/generic-scatterlist.h
deleted file mode 100644
index 8b94544..0000000
--- a/arch/x86/include/asm/generic-scatterlist.h
+++ /dev/null
@@ -1,43 +0,0 @@
-#ifndef __ASM_GENERIC_SCATTERLIST_H
-#define __ASM_GENERIC_SCATTERLIST_H
-
-#include <linux/types.h>
-
-struct scatterlist {
-#ifdef CONFIG_DEBUG_SG
-	unsigned long	sg_magic;
-#endif
-	unsigned long	page_link;
-	unsigned int	offset;
-	unsigned int	length;
-	dma_addr_t	dma_address;
-	unsigned int	dma_length;
-};
-
-/*
- * These macros should be used after a dma_map_sg call has been done
- * to get bus addresses of each of the SG entries and their lengths.
- * You should only work with the number of sg entries pci_map_sg
- * returns, or alternatively stop on the first sg_dma_len(sg) which
- * is 0.
- */
-#define sg_dma_address(sg)	((sg)->dma_address)
-#ifndef sg_dma_len
-/*
- * Normally, you have an iommu on 64 bit machines, but not on 32 bit
- * machines. Architectures that are differnt should override this.
- */
-#if __BITS_PER_LONG == 64
-#define sg_dma_len(sg)		((sg)->dma_length)
-#else
-#define sg_dma_len(sg)		((sg)->length)
-#endif /* 64 bit */
-#endif /* sg_dma_len */
-
-#ifndef ISA_DMA_THRESHOLD
-#define ISA_DMA_THRESHOLD	(~0UL)
-#endif
-
-#define ARCH_HAS_SG_CHAIN
-
-#endif /* __ASM_GENERIC_SCATTERLIST_H */
diff --git a/arch/x86/include/asm/generic-types.h b/arch/x86/include/asm/generic-types.h
deleted file mode 100644
index fba7d33..0000000
--- a/arch/x86/include/asm/generic-types.h
+++ /dev/null
@@ -1,42 +0,0 @@
-#ifndef _ASM_GENERIC_TYPES_H
-#define _ASM_GENERIC_TYPES_H
-/*
- * int-ll64 is used practically everywhere now,
- * so use it as a reasonable default.
- */
-#include <asm-generic/int-ll64.h>
-
-#ifndef __ASSEMBLY__
-
-typedef unsigned short umode_t;
-
-#endif /* __ASSEMBLY__ */
-
-/*
- * These aren't exported outside the kernel to avoid name space clashes
- */
-#ifdef __KERNEL__
-#ifndef __ASSEMBLY__
-/*
- * DMA addresses may be very different from physical addresses
- * and pointers. i386 and powerpc may have 64 bit DMA on 32 bit
- * systems, while sparc64 uses 32 bit DMA addresses for 64 bit
- * physical addresses.
- * This default defines dma_addr_t to have the same size as
- * phys_addr_t, which is the most common way.
- * Do not define the dma64_addr_t type, which never really
- * worked.
- */
-#ifndef dma_addr_t
-#ifdef CONFIG_PHYS_ADDR_T_64BIT
-typedef u64 dma_addr_t;
-#else
-typedef u32 dma_addr_t;
-#endif /* CONFIG_PHYS_ADDR_T_64BIT */
-#endif /* dma_addr_t */
-
-#endif /* __ASSEMBLY__ */
-
-#endif /* __KERNEL__ */
-
-#endif /* _ASM_GENERIC_TYPES_H */
diff --git a/arch/x86/include/asm/generic-ucontext.h b/arch/x86/include/asm/generic-ucontext.h
deleted file mode 100644
index ad77343..0000000
--- a/arch/x86/include/asm/generic-ucontext.h
+++ /dev/null
@@ -1,12 +0,0 @@
-#ifndef __ASM_GENERIC_UCONTEXT_H
-#define __ASM_GENERIC_UCONTEXT_H
-
-struct ucontext {
-	unsigned long	  uc_flags;
-	struct ucontext  *uc_link;
-	stack_t		  uc_stack;
-	struct sigcontext uc_mcontext;
-	sigset_t	  uc_sigmask;	/* mask last for extensibility */
-};
-
-#endif /* __ASM_GENERIC_UCONTEXT_H */
diff --git a/arch/x86/include/asm/ioctls.h b/arch/x86/include/asm/ioctls.h
index a799e20..ec34c76 100644
--- a/arch/x86/include/asm/ioctls.h
+++ b/arch/x86/include/asm/ioctls.h
@@ -1,110 +1 @@
-#ifndef __ASM_GENERIC_IOCTLS_H
-#define __ASM_GENERIC_IOCTLS_H
-
-#include <linux/ioctl.h>
-
-/*
- * These are the most common definitions for tty ioctl numbers.
- * Most of them do not use the recommended _IOC(), but there is
- * probably some source code out there hardcoding the number,
- * so we might as well use them for all new platforms.
- *
- * The architectures that use different values here typically
- * try to be compatible with some Unix variants for the same
- * architecture.
- */
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
-#define TCSBRKP		0x5425	/* Needed for POSIX tcsendbreak() */
-#define TIOCSBRK	0x5427  /* BSD compatibility */
-#define TIOCCBRK	0x5428  /* BSD compatibility */
-#define TIOCGSID	0x5429  /* Return the session ID of FD */
-#define TCGETS2		_IOR('T', 0x2A, struct termios2)
-#define TCSETS2		_IOW('T', 0x2B, struct termios2)
-#define TCSETSW2	_IOW('T', 0x2C, struct termios2)
-#define TCSETSF2	_IOW('T', 0x2D, struct termios2)
-#define TIOCGRS485	0x542E
-#define TIOCSRS485	0x542F
-#define TIOCGPTN	_IOR('T', 0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
-#define TIOCSPTLCK	_IOW('T', 0x31, int)  /* Lock/unlock Pty */
-#define TCGETX		0x5432 /* SYS5 TCGETX compatibility */
-#define TCSETX		0x5433
-#define TCSETXF		0x5434
-#define TCSETXW		0x5435
-
-#define FIONCLEX	0x5450
-#define FIOCLEX		0x5451
-#define FIOASYNC	0x5452
-#define TIOCSERCONFIG	0x5453
-#define TIOCSERGWILD	0x5454
-#define TIOCSERSWILD	0x5455
-#define TIOCGLCKTRMIOS	0x5456
-#define TIOCSLCKTRMIOS	0x5457
-#define TIOCSERGSTRUCT	0x5458 /* For debugging only */
-#define TIOCSERGETLSR   0x5459 /* Get line status register */
-#define TIOCSERGETMULTI 0x545A /* Get multiport config  */
-#define TIOCSERSETMULTI 0x545B /* Set multiport config */
-
-#define TIOCMIWAIT	0x545C	/* wait for a change on serial input line(s) */
-#define TIOCGICOUNT	0x545D	/* read serial port inline interrupt counts */
-
-/*
- * some architectures define FIOQSIZE as 0x545E, which is used for
- * TIOCGHAYESESP on others
- */
-#ifndef FIOQSIZE
-# define TIOCGHAYESESP	0x545E  /* Get Hayes ESP configuration */
-# define TIOCSHAYESESP	0x545F  /* Set Hayes ESP configuration */
-# define FIOQSIZE	0x5460
-#endif
-
-/* Used for packet mode */
-#define TIOCPKT_DATA		 0
-#define TIOCPKT_FLUSHREAD	 1
-#define TIOCPKT_FLUSHWRITE	 2
-#define TIOCPKT_STOP		 4
-#define TIOCPKT_START		 8
-#define TIOCPKT_NOSTOP		16
-#define TIOCPKT_DOSTOP		32
-
-#define TIOCSER_TEMT	0x01	/* Transmitter physically empty */
-
-#endif /* __ASM_GENERIC_IOCTLS_H */
+#include <asm-generic/ioctls.h>
diff --git a/arch/x86/include/asm/ipcbuf.h b/arch/x86/include/asm/ipcbuf.h
index 888ca1c..84c7e51 100644
--- a/arch/x86/include/asm/ipcbuf.h
+++ b/arch/x86/include/asm/ipcbuf.h
@@ -1,33 +1 @@
-#ifndef __ASM_GENERIC_IPCBUF_H
-#define __ASM_GENERIC_IPCBUF_H
-
-/*
- * The generic ipc64_perm structure:
- * Note extra padding because this structure is passed back and forth
- * between kernel and user space.
- *
- * ipc64_perm was originally meant to be architecture specific, but
- * everyone just ended up making identical copies without specific
- * optimizations, so we may just as well all use the same one.
- *
- * Pad space is left for:
- * - 32-bit mode_t on architectures that only had 16 bit
- * - 32-bit seq
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
-#endif /* __ASM_GENERIC_IPCBUF_H */
+#include <asm-generic/ipcbuf.h>
diff --git a/arch/x86/include/asm/mman.h b/arch/x86/include/asm/mman.h
index 063d8c9..593e51d 100644
--- a/arch/x86/include/asm/mman.h
+++ b/arch/x86/include/asm/mman.h
@@ -3,6 +3,6 @@
 
 #define MAP_32BIT	0x40		/* only give out 32bit addresses */
 
-#include <asm/generic-mman.h>
+#include <asm-generic/mman.h>
 
 #endif /* _ASM_X86_MMAN_H */
diff --git a/arch/x86/include/asm/module.h b/arch/x86/include/asm/module.h
index 4a7a192..555bc12 100644
--- a/arch/x86/include/asm/module.h
+++ b/arch/x86/include/asm/module.h
@@ -1,7 +1,7 @@
 #ifndef _ASM_X86_MODULE_H
 #define _ASM_X86_MODULE_H
 
-#include <asm/generic-module.h>
+#include <asm-generic/module.h>
 
 #ifdef CONFIG_X86_64
 /* X86_64 does not define MODULE_PROC_FAMILY */
diff --git a/arch/x86/include/asm/msgbuf.h b/arch/x86/include/asm/msgbuf.h
index aec850d..809134c 100644
--- a/arch/x86/include/asm/msgbuf.h
+++ b/arch/x86/include/asm/msgbuf.h
@@ -1,47 +1 @@
-#ifndef __ASM_GENERIC_MSGBUF_H
-#define __ASM_GENERIC_MSGBUF_H
-
-#include <asm/bitsperlong.h>
-/*
- * generic msqid64_ds structure.
- *
- * Note extra padding because this structure is passed back and forth
- * between kernel and user space.
- *
- * msqid64_ds was originally meant to be architecture specific, but
- * everyone just ended up making identical copies without specific
- * optimizations, so we may just as well all use the same one.
- *
- * 64 bit architectures typically define a 64 bit __kernel_time_t,
- * so they do not need the first three padding words.
- * On big-endian systems, the padding is in the wrong place.
- *
- * Pad space is left for:
- * - 64-bit time_t to solve y2038 problem
- * - 2 miscellaneous 32-bit values
- */
-
-struct msqid64_ds {
-	struct ipc64_perm msg_perm;
-	__kernel_time_t msg_stime;	/* last msgsnd time */
-#if __BITS_PER_LONG != 64
-	unsigned long	__unused1;
-#endif
-	__kernel_time_t msg_rtime;	/* last msgrcv time */
-#if __BITS_PER_LONG != 64
-	unsigned long	__unused2;
-#endif
-	__kernel_time_t msg_ctime;	/* last change time */
-#if __BITS_PER_LONG != 64
-	unsigned long	__unused3;
-#endif
-	unsigned long  msg_cbytes;	/* current number of bytes on queue */
-	unsigned long  msg_qnum;	/* number of messages in queue */
-	unsigned long  msg_qbytes;	/* max number of bytes on queue */
-	__kernel_pid_t msg_lspid;	/* pid of last msgsnd */
-	__kernel_pid_t msg_lrpid;	/* last receive pid */
-	unsigned long  __unused4;
-	unsigned long  __unused5;
-};
-
-#endif /* __ASM_GENERIC_MSGBUF_H */
+#include <asm-generic/msgbuf.h>
diff --git a/arch/x86/include/asm/param.h b/arch/x86/include/asm/param.h
index cdf8251..965d454 100644
--- a/arch/x86/include/asm/param.h
+++ b/arch/x86/include/asm/param.h
@@ -1,24 +1 @@
-#ifndef __ASM_GENERIC_PARAM_H
-#define __ASM_GENERIC_PARAM_H
-
-#ifdef __KERNEL__
-# define HZ		CONFIG_HZ	/* Internal kernel timer frequency */
-# define USER_HZ	100		/* some user interfaces are */
-# define CLOCKS_PER_SEC	(USER_HZ)       /* in "ticks" like times() */
-#endif
-
-#ifndef HZ
-#define HZ 100
-#endif
-
-#ifndef EXEC_PAGESIZE
-#define EXEC_PAGESIZE	4096
-#endif
-
-#ifndef NOGROUP
-#define NOGROUP		(-1)
-#endif
-
-#define MAXHOSTNAMELEN	64	/* max length of hostname */
-
-#endif /* __ASM_GENERIC_PARAM_H */
+#include <asm-generic/param.h>
diff --git a/arch/x86/include/asm/scatterlist.h b/arch/x86/include/asm/scatterlist.h
index 2097d68..75af592 100644
--- a/arch/x86/include/asm/scatterlist.h
+++ b/arch/x86/include/asm/scatterlist.h
@@ -3,6 +3,6 @@
 
 #define ISA_DMA_THRESHOLD (0x00ffffff)
 
-#include <asm/generic-scatterlist.h>
+#include <asm-generic/scatterlist.h>
 
 #endif /* _ASM_X86_SCATTERLIST_H */
diff --git a/arch/x86/include/asm/shmbuf.h b/arch/x86/include/asm/shmbuf.h
index 5768fa6..83c05fc 100644
--- a/arch/x86/include/asm/shmbuf.h
+++ b/arch/x86/include/asm/shmbuf.h
@@ -1,59 +1 @@
-#ifndef __ASM_GENERIC_SHMBUF_H
-#define __ASM_GENERIC_SHMBUF_H
-
-#include <asm/bitsperlong.h>
-
-/*
- * The shmid64_ds structure for x86 architecture.
- * Note extra padding because this structure is passed back and forth
- * between kernel and user space.
- *
- * shmid64_ds was originally meant to be architecture specific, but
- * everyone just ended up making identical copies without specific
- * optimizations, so we may just as well all use the same one.
- *
- * 64 bit architectures typically define a 64 bit __kernel_time_t,
- * so they do not need the first two padding words.
- * On big-endian systems, the padding is in the wrong place.
- *
- *
- * Pad space is left for:
- * - 64-bit time_t to solve y2038 problem
- * - 2 miscellaneous 32-bit values
- */
-
-struct shmid64_ds {
-	struct ipc64_perm	shm_perm;	/* operation perms */
-	size_t			shm_segsz;	/* size of segment (bytes) */
-	__kernel_time_t		shm_atime;	/* last attach time */
-#if __BITS_PER_LONG != 64
-	unsigned long		__unused1;
-#endif
-	__kernel_time_t		shm_dtime;	/* last detach time */
-#if __BITS_PER_LONG != 64
-	unsigned long		__unused2;
-#endif
-	__kernel_time_t		shm_ctime;	/* last change time */
-#if __BITS_PER_LONG != 64
-	unsigned long		__unused3;
-#endif
-	__kernel_pid_t		shm_cpid;	/* pid of creator */
-	__kernel_pid_t		shm_lpid;	/* pid of last operator */
-	unsigned long		shm_nattch;	/* no. of current attaches */
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
-#endif /* __ASM_GENERIC_SHMBUF_H */
+#include <asm-generic/shmbuf.h>
diff --git a/arch/x86/include/asm/socket.h b/arch/x86/include/asm/socket.h
index d4ae42a..6b71384 100644
--- a/arch/x86/include/asm/socket.h
+++ b/arch/x86/include/asm/socket.h
@@ -1,60 +1 @@
-#ifndef __ASM_GENERIC_SOCKET_H
-#define __ASM_GENERIC_SOCKET_H
-
-#include <asm/sockios.h>
-
-/* For setsockopt(2) */
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
-#define SO_TIMESTAMPNS		35
-#define SCM_TIMESTAMPNS		SO_TIMESTAMPNS
-
-#define SO_MARK			36
-
-#define SO_TIMESTAMPING		37
-#define SCM_TIMESTAMPING	SO_TIMESTAMPING
-
-#endif /* __ASM_GENERIC_SOCKET_H */
+#include <asm-generic/socket.h>
diff --git a/arch/x86/include/asm/sockios.h b/arch/x86/include/asm/sockios.h
index 9a61a36..def6d47 100644
--- a/arch/x86/include/asm/sockios.h
+++ b/arch/x86/include/asm/sockios.h
@@ -1,13 +1 @@
-#ifndef __ASM_GENERIC_SOCKIOS_H
-#define __ASM_GENERIC_SOCKIOS_H
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
-#endif /* __ASM_GENERIC_SOCKIOS_H */
+#include <asm-generic/sockios.h>
diff --git a/arch/x86/include/asm/termbits.h b/arch/x86/include/asm/termbits.h
index 1c9773d..3935b10 100644
--- a/arch/x86/include/asm/termbits.h
+++ b/arch/x86/include/asm/termbits.h
@@ -1,198 +1 @@
-#ifndef __ASM_GENERIC_TERMBITS_H
-#define __ASM_GENERIC_TERMBITS_H
-
-#include <linux/posix_types.h>
-
-typedef unsigned char	cc_t;
-typedef unsigned int	speed_t;
-typedef unsigned int	tcflag_t;
-
-#define NCCS 19
-struct termios {
-	tcflag_t c_iflag;		/* input mode flags */
-	tcflag_t c_oflag;		/* output mode flags */
-	tcflag_t c_cflag;		/* control mode flags */
-	tcflag_t c_lflag;		/* local mode flags */
-	cc_t c_line;			/* line discipline */
-	cc_t c_cc[NCCS];		/* control characters */
-};
-
-struct termios2 {
-	tcflag_t c_iflag;		/* input mode flags */
-	tcflag_t c_oflag;		/* output mode flags */
-	tcflag_t c_cflag;		/* control mode flags */
-	tcflag_t c_lflag;		/* local mode flags */
-	cc_t c_line;			/* line discipline */
-	cc_t c_cc[NCCS];		/* control characters */
-	speed_t c_ispeed;		/* input speed */
-	speed_t c_ospeed;		/* output speed */
-};
-
-struct ktermios {
-	tcflag_t c_iflag;		/* input mode flags */
-	tcflag_t c_oflag;		/* output mode flags */
-	tcflag_t c_cflag;		/* control mode flags */
-	tcflag_t c_lflag;		/* local mode flags */
-	cc_t c_line;			/* line discipline */
-	cc_t c_cc[NCCS];		/* control characters */
-	speed_t c_ispeed;		/* input speed */
-	speed_t c_ospeed;		/* output speed */
-};
-
-/* c_cc characters */
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
-#define OPOST	0000001
-#define OLCUC	0000002
-#define ONLCR	0000004
-#define OCRNL	0000010
-#define ONOCR	0000020
-#define ONLRET	0000040
-#define OFILL	0000100
-#define OFDEL	0000200
-#define NLDLY	0000400
-#define   NL0	0000000
-#define   NL1	0000400
-#define CRDLY	0003000
-#define   CR0	0000000
-#define   CR1	0001000
-#define   CR2	0002000
-#define   CR3	0003000
-#define TABDLY	0014000
-#define   TAB0	0000000
-#define   TAB1	0004000
-#define   TAB2	0010000
-#define   TAB3	0014000
-#define   XTABS	0014000
-#define BSDLY	0020000
-#define   BS0	0000000
-#define   BS1	0020000
-#define VTDLY	0040000
-#define   VT0	0000000
-#define   VT1	0040000
-#define FFDLY	0100000
-#define   FF0	0000000
-#define   FF1	0100000
-
-/* c_cflag bit meaning */
-#define CBAUD	0010017
-#define  B0	0000000		/* hang up */
-#define  B50	0000001
-#define  B75	0000002
-#define  B110	0000003
-#define  B134	0000004
-#define  B150	0000005
-#define  B200	0000006
-#define  B300	0000007
-#define  B600	0000010
-#define  B1200	0000011
-#define  B1800	0000012
-#define  B2400	0000013
-#define  B4800	0000014
-#define  B9600	0000015
-#define  B19200	0000016
-#define  B38400	0000017
-#define EXTA B19200
-#define EXTB B38400
-#define CSIZE	0000060
-#define   CS5	0000000
-#define   CS6	0000020
-#define   CS7	0000040
-#define   CS8	0000060
-#define CSTOPB	0000100
-#define CREAD	0000200
-#define PARENB	0000400
-#define PARODD	0001000
-#define HUPCL	0002000
-#define CLOCAL	0004000
-#define CBAUDEX 0010000
-#define    BOTHER 0010000
-#define    B57600 0010001
-#define   B115200 0010002
-#define   B230400 0010003
-#define   B460800 0010004
-#define   B500000 0010005
-#define   B576000 0010006
-#define   B921600 0010007
-#define  B1000000 0010010
-#define  B1152000 0010011
-#define  B1500000 0010012
-#define  B2000000 0010013
-#define  B2500000 0010014
-#define  B3000000 0010015
-#define  B3500000 0010016
-#define  B4000000 0010017
-#define CIBAUD	  002003600000	/* input baud rate */
-#define CMSPAR	  010000000000	/* mark or space (stick) parity */
-#define CRTSCTS	  020000000000	/* flow control */
-
-#define IBSHIFT	  16		/* Shift from CBAUD to CIBAUD */
-
-/* c_lflag bits */
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
-#define	TCOOFF		0
-#define	TCOON		1
-#define	TCIOFF		2
-#define	TCION		3
-
-/* tcflush() and TCFLSH use these */
-#define	TCIFLUSH	0
-#define	TCOFLUSH	1
-#define	TCIOFLUSH	2
-
-/* tcsetattr uses these */
-#define	TCSANOW		0
-#define	TCSADRAIN	1
-#define	TCSAFLUSH	2
-
-#endif /* __ASM_GENERIC_TERMBITS_H */
+#include <asm-generic/termbits.h>
diff --git a/arch/x86/include/asm/termios.h b/arch/x86/include/asm/termios.h
index d0922ad..280d78a 100644
--- a/arch/x86/include/asm/termios.h
+++ b/arch/x86/include/asm/termios.h
@@ -1,154 +1 @@
-#ifndef _ASM_GENERIC_TERMIOS_H
-#define _ASM_GENERIC_TERMIOS_H
-/*
- * Most architectures have straight copies of the x86 code, with
- * varying levels of bug fixes on top. Usually it's a good idea
- * to use this generic version instead, but be careful to avoid
- * ABI changes.
- * New architectures should not provide their own version.
- */
-
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
-	unsigned short c_iflag;		/* input mode flags */
-	unsigned short c_oflag;		/* output mode flags */
-	unsigned short c_cflag;		/* control mode flags */
-	unsigned short c_lflag;		/* local mode flags */
-	unsigned char c_line;		/* line discipline */
-	unsigned char c_cc[NCC];	/* control characters */
-};
-
-/* modem lines */
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
-#ifdef __KERNEL__
-
-#include <asm/uaccess.h>
-
-/*	intr=^C		quit=^\		erase=del	kill=^U
-	eof=^D		vtime=\0	vmin=\1		sxtc=\0
-	start=^Q	stop=^S		susp=^Z		eol=\0
-	reprint=^R	discard=^U	werase=^W	lnext=^V
-	eol2=\0
-*/
-#define INIT_C_CC "\003\034\177\025\004\0\1\0\021\023\032\0\022\017\027\026\0"
-
-/*
- * Translate a "termio" structure into a "termios". Ugh.
- */
-static inline int user_termio_to_kernel_termios(struct ktermios *termios,
-						const struct termio __user *termio)
-{
-	unsigned short tmp;
-
-	if (get_user(tmp, &termio->c_iflag) < 0)
-		goto fault;
-	termios->c_iflag = (0xffff0000 & termios->c_iflag) | tmp;
-
-	if (get_user(tmp, &termio->c_oflag) < 0)
-		goto fault;
-	termios->c_oflag = (0xffff0000 & termios->c_oflag) | tmp;
-
-	if (get_user(tmp, &termio->c_cflag) < 0)
-		goto fault;
-	termios->c_cflag = (0xffff0000 & termios->c_cflag) | tmp;
-
-	if (get_user(tmp, &termio->c_lflag) < 0)
-		goto fault;
-	termios->c_lflag = (0xffff0000 & termios->c_lflag) | tmp;
-
-	if (get_user(termios->c_line, &termio->c_line) < 0)
-		goto fault;
-
-	if (copy_from_user(termios->c_cc, termio->c_cc, NCC) != 0)
-		goto fault;
-
-	return 0;
-
- fault:
-	return -EFAULT;
-}
-
-/*
- * Translate a "termios" structure into a "termio". Ugh.
- */
-static inline int kernel_termios_to_user_termio(struct termio __user *termio,
-						struct ktermios *termios)
-{
-	if (put_user(termios->c_iflag, &termio->c_iflag) < 0 ||
-	    put_user(termios->c_oflag, &termio->c_oflag) < 0 ||
-	    put_user(termios->c_cflag, &termio->c_cflag) < 0 ||
-	    put_user(termios->c_lflag, &termio->c_lflag) < 0 ||
-	    put_user(termios->c_line,  &termio->c_line) < 0 ||
-	    copy_to_user(termio->c_cc, termios->c_cc, NCC) != 0)
-		return -EFAULT;
-
-	return 0;
-}
-
-#ifdef TCGETS2
-static inline int user_termios_to_kernel_termios(struct ktermios *k,
-						 struct termios2 __user *u)
-{
-	return copy_from_user(k, u, sizeof(struct termios2));
-}
-
-static inline int kernel_termios_to_user_termios(struct termios2 __user *u,
-						 struct ktermios *k)
-{
-	return copy_to_user(u, k, sizeof(struct termios2));
-}
-
-static inline int user_termios_to_kernel_termios_1(struct ktermios *k,
-						   struct termios __user *u)
-{
-	return copy_from_user(k, u, sizeof(struct termios));
-}
-
-static inline int kernel_termios_to_user_termios_1(struct termios __user *u,
-						   struct ktermios *k)
-{
-	return copy_to_user(u, k, sizeof(struct termios));
-}
-#else /* TCGETS2 */
-static inline int user_termios_to_kernel_termios(struct ktermios *k,
-						 struct termios __user *u)
-{
-	return copy_from_user(k, u, sizeof(struct termios));
-}
-
-static inline int kernel_termios_to_user_termios(struct termios __user *u,
-						 struct ktermios *k)
-{
-	return copy_to_user(u, k, sizeof(struct termios));
-}
-#endif /* TCGETS2 */
-
-#endif	/* __KERNEL__ */
-
-#endif /* _ASM_GENERIC_TERMIOS_H */
+#include <asm-generic/termios.h>
diff --git a/arch/x86/include/asm/types.h b/arch/x86/include/asm/types.h
index f2fe528..df1da20 100644
--- a/arch/x86/include/asm/types.h
+++ b/arch/x86/include/asm/types.h
@@ -3,7 +3,7 @@
 
 #define dma_addr_t	dma_addr_t
 
-#include <asm/generic-types.h>
+#include <asm-generic/types.h>
 
 #ifdef __KERNEL__
 #ifndef __ASSEMBLY__
diff --git a/arch/x86/include/asm/ucontext.h b/arch/x86/include/asm/ucontext.h
index 7cfc436..b7c29c8 100644
--- a/arch/x86/include/asm/ucontext.h
+++ b/arch/x86/include/asm/ucontext.h
@@ -7,6 +7,6 @@
 				 * sigcontext struct (uc_mcontext).
 				 */
 
-#include <asm/generic-ucontext.h>
+#include <asm-generic/ucontext.h>
 
 #endif /* _ASM_X86_UCONTEXT_H */
