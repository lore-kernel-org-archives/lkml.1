Return-Path: <linux-kernel-owner+w=401wt.eu-S1759911AbZFNMDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759911AbZFNMDI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 08:03:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758773AbZFNMBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 08:01:34 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:52663 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758685AbZFNMBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 08:01:32 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 06/17] Blackfin: convert shm/sysv/ipc to asm-generic
Date: Sun, 14 Jun 2009 08:01:07 -0400
Message-Id: <1244980878-2124-7-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244980878-2124-1-git-send-email-vapier@gentoo.org>
References: <1244980878-2124-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/ipcbuf.h   |   31 +-----------------------
 arch/blackfin/include/asm/msgbuf.h   |   32 +------------------------
 arch/blackfin/include/asm/sembuf.h   |   26 +-------------------
 arch/blackfin/include/asm/shmbuf.h   |   43 +---------------------------------
 arch/blackfin/include/asm/shmparam.h |    7 +----
 5 files changed, 5 insertions(+), 134 deletions(-)

diff --git a/arch/blackfin/include/asm/ipcbuf.h b/arch/blackfin/include/asm/ipcbuf.h
index 8f0899c..84c7e51 100644
--- a/arch/blackfin/include/asm/ipcbuf.h
+++ b/arch/blackfin/include/asm/ipcbuf.h
@@ -1,30 +1 @@
-/* Changes origined from m68k version.    Lineo Inc.  May 2001   */
-
-#ifndef __BFIN_IPCBUF_H__
-#define __BFIN_IPCBUF_H__
-
-/*
- * The user_ipc_perm structure for m68k architecture.
- * Note extra padding because this structure is passed back and forth
- * between kernel and user space.
- *
- * Pad space is left for:
- * - 32-bit mode_t and seq
- * - 2 miscellaneous 32-bit values
- */
-
-struct ipc64_perm {
-	__kernel_key_t key;
-	__kernel_uid32_t uid;
-	__kernel_gid32_t gid;
-	__kernel_uid32_t cuid;
-	__kernel_gid32_t cgid;
-	__kernel_mode_t mode;
-	unsigned short __pad1;
-	unsigned short seq;
-	unsigned short __pad2;
-	unsigned long __unused1;
-	unsigned long __unused2;
-};
-
-#endif				/* __BFIN_IPCBUF_H__ */
+#include <asm-generic/ipcbuf.h>
diff --git a/arch/blackfin/include/asm/msgbuf.h b/arch/blackfin/include/asm/msgbuf.h
index 6fcbe8c..809134c 100644
--- a/arch/blackfin/include/asm/msgbuf.h
+++ b/arch/blackfin/include/asm/msgbuf.h
@@ -1,31 +1 @@
-#ifndef _BFIN_MSGBUF_H
-#define _BFIN_MSGBUF_H
-
-/*
- * The msqid64_ds structure for bfin architecture.
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
-	__kernel_time_t msg_stime;	/* last msgsnd time */
-	unsigned long __unused1;
-	__kernel_time_t msg_rtime;	/* last msgrcv time */
-	unsigned long __unused2;
-	__kernel_time_t msg_ctime;	/* last change time */
-	unsigned long __unused3;
-	unsigned long msg_cbytes;	/* current number of bytes on queue */
-	unsigned long msg_qnum;	/* number of messages in queue */
-	unsigned long msg_qbytes;	/* max number of bytes on queue */
-	__kernel_pid_t msg_lspid;	/* pid of last msgsnd */
-	__kernel_pid_t msg_lrpid;	/* last receive pid */
-	unsigned long __unused4;
-	unsigned long __unused5;
-};
-
-#endif				/* _BFIN_MSGBUF_H */
+#include <asm-generic/msgbuf.h>
diff --git a/arch/blackfin/include/asm/sembuf.h b/arch/blackfin/include/asm/sembuf.h
index 18deb5c..7673b83 100644
--- a/arch/blackfin/include/asm/sembuf.h
+++ b/arch/blackfin/include/asm/sembuf.h
@@ -1,25 +1 @@
-#ifndef _BFIN_SEMBUF_H
-#define _BFIN_SEMBUF_H
-
-/*
- * The semid64_ds structure for bfin architecture.
- * Note extra padding because this structure is passed back and forth
- * between kernel and user space.
- *
- * Pad space is left for:
- * - 64-bit time_t to solve y2038 problem
- * - 2 miscellaneous 32-bit values
- */
-
-struct semid64_ds {
-	struct ipc64_perm sem_perm;	/* permissions .. see ipc.h */
-	__kernel_time_t sem_otime;	/* last semop time */
-	unsigned long __unused1;
-	__kernel_time_t sem_ctime;	/* last change time */
-	unsigned long __unused2;
-	unsigned long sem_nsems;	/* no. of semaphores in array */
-	unsigned long __unused3;
-	unsigned long __unused4;
-};
-
-#endif				/* _BFIN_SEMBUF_H */
+#include <asm-generic/sembuf.h>
diff --git a/arch/blackfin/include/asm/shmbuf.h b/arch/blackfin/include/asm/shmbuf.h
index 6124363..83c05fc 100644
--- a/arch/blackfin/include/asm/shmbuf.h
+++ b/arch/blackfin/include/asm/shmbuf.h
@@ -1,42 +1 @@
-#ifndef _BFIN_SHMBUF_H
-#define _BFIN_SHMBUF_H
-
-/*
- * The shmid64_ds structure for bfin architecture.
- * Note extra padding because this structure is passed back and forth
- * between kernel and user space.
- *
- * Pad space is left for:
- * - 64-bit time_t to solve y2038 problem
- * - 2 miscellaneous 32-bit values
- */
-
-struct shmid64_ds {
-	struct ipc64_perm shm_perm;	/* operation perms */
-	size_t shm_segsz;	/* size of segment (bytes) */
-	__kernel_time_t shm_atime;	/* last attach time */
-	unsigned long __unused1;
-	__kernel_time_t shm_dtime;	/* last detach time */
-	unsigned long __unused2;
-	__kernel_time_t shm_ctime;	/* last change time */
-	unsigned long __unused3;
-	__kernel_pid_t shm_cpid;	/* pid of creator */
-	__kernel_pid_t shm_lpid;	/* pid of last operator */
-	unsigned long shm_nattch;	/* no. of current attaches */
-	unsigned long __unused4;
-	unsigned long __unused5;
-};
-
-struct shminfo64 {
-	unsigned long shmmax;
-	unsigned long shmmin;
-	unsigned long shmmni;
-	unsigned long shmseg;
-	unsigned long shmall;
-	unsigned long __unused1;
-	unsigned long __unused2;
-	unsigned long __unused3;
-	unsigned long __unused4;
-};
-
-#endif				/* _BFIN_SHMBUF_H */
+#include <asm-generic/shmbuf.h>
diff --git a/arch/blackfin/include/asm/shmparam.h b/arch/blackfin/include/asm/shmparam.h
index 3c03906..93f30de 100644
--- a/arch/blackfin/include/asm/shmparam.h
+++ b/arch/blackfin/include/asm/shmparam.h
@@ -1,6 +1 @@
-#ifndef _BFIN_SHMPARAM_H
-#define _BFIN_SHMPARAM_H
-
-#define	SHMLBA PAGE_SIZE	/* attach addr a multiple of this */
-
-#endif				/* _BFIN_SHMPARAM_H */
+#include <asm-generic/shmparam.h>
-- 
1.6.3.1

