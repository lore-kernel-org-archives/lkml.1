Return-Path: <linux-kernel-owner+w=401wt.eu-S1758489AbYAZP6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758489AbYAZP6n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 10:58:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755554AbYAZPyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 10:54:46 -0500
Received: from 206-47-31-89.wifiinternet.cz ([89.31.47.206]:1177 "EHLO
	monstr.monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755436AbYAZPyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 10:54:44 -0500
From: monstr@monstr.eu
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au
Subject: [PATCH 32/52] [microblaze] includes SHM*, msgbuf
Date: Thu, 24 Jan 2008 16:03:07 +0100
Message-Id: <37627293f081fa40f21234944ddb878d5e711740.1201107832.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.rc4.14.g6fc74
In-Reply-To: <d67010417928d04766e6dd74820b12c249d61814.1201107832.git.monstr@monstr.eu>
References: <1201187014-3979-1-git-send-email-monstr@monstr.eu>
 <dbff6b883dbcb108db53e5093994c473946e1240.1201107832.git.monstr@monstr.eu>
 <ac0947adfe718fcb4c0dc5f6f7ab64f8155541fb.1201107832.git.monstr@monstr.eu>
 <873c2bf1f67696aa11014886470f6ba46f04e8d2.1201107832.git.monstr@monstr.eu>
 <516d173b1789ea533431e8f5ad05751c6a353c88.1201107832.git.monstr@monstr.eu>
 <068508828aac6298b4cc65b0cd7b2737a61c466c.1201107832.git.monstr@monstr.eu>
 <010fc233f82a8f7a591c9f8315ae03f9951139aa.1201107832.git.monstr@monstr.eu>
 <68faaf69ea03196d4a56a263707355e7e7eb5c6a.1201107832.git.monstr@monstr.eu>
 <4b7d90fc1b9bcb3c0b1b308c6460390f7bdf3824.1201107832.git.monstr@monstr.eu>
 <eb28582e845efb4f2f26054630895f26fa69866e.1201107832.git.monstr@monstr.eu>
 <64e6e541db30cc4f1ee5cd85da4bdea6024f75b8.1201107832.git.monstr@monstr.eu>
 <90badb264d0e4ec49fdaa76842a5e5f259681299.1201107832.git.monstr@monstr.eu>
 <a013a2b7044186c64d55cdafc8c9b29bc73a7fc5.1201107832.git.monstr@monstr.eu>
 <60642f04ebcf9f76da50a1d40191755f258edcc5.1201107832.git.monstr@monstr.eu>
 <240998be1af3774635995fd19248f8b3a9e8a702.1201107832.git.monstr@monstr.eu>
 <3bcb9581bc512fdd0a124ac8322af9e2a8adc975.1201107832.git.monstr@monstr.eu>
 <db7f441df21cfe296a44744747b28f379e75fd49.1201107832.git.monstr@monstr.eu>
 <e6309af7cc6550ef5b399fc0902f1926f9e52e58.1201107832.git.monstr@monstr.eu>
 <2d11eef3abada1f41658a532a483c6121ded8054.1201107832.git.monstr@monstr.eu>
 <48db19662b808ab6f5455dd7f2116e6544c50e95.1201107832.git.monstr@monstr.eu>
 <7b0cfa6ae11749e20c941d0a4f03577141e022f8.1201107832.git.monstr@monstr.eu>
 <2f3db7ba4fe41cb9888adabf0e4e052d4da5c37c.1201107832.git.monstr@monstr.eu>
 <d67010417928d04766e6dd74820b12c249d61814.1201107832.git.monstr@monstr.eu>
In-Reply-To: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
References: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 include/asm-microblaze/msgbuf.h   |   41 +++++++++++++++++++++++++++++
 include/asm-microblaze/shmbuf.h   |   52 +++++++++++++++++++++++++++++++++++++
 include/asm-microblaze/shmparam.h |   16 +++++++++++
 3 files changed, 109 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-microblaze/msgbuf.h
 create mode 100644 include/asm-microblaze/shmbuf.h
 create mode 100644 include/asm-microblaze/shmparam.h

diff --git a/include/asm-microblaze/msgbuf.h b/include/asm-microblaze/msgbuf.h
new file mode 100644
index 0000000..3f4d164
--- /dev/null
+++ b/include/asm-microblaze/msgbuf.h
@@ -0,0 +1,41 @@
+/*
+ * include/asm-microblaze/msgbuf.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_MSGBUF_H
+#define _ASM_MSGBUF_H
+
+/*
+ * The msqid64_ds structure for m68k architecture.
+ * Note extra padding because this structure is passed back and forth
+ * between kernel and user space.
+ *
+ * Pad space is left for:
+ * - 64-bit time_t to solve y2038 problem
+ * - 2 miscellaneous 32-bit values
+ */
+
+struct msqid64_ds {
+	struct ipc64_perm msg_perm;
+	__kernel_time_t msg_stime; /* last msgsnd time */
+	unsigned long __unused1;
+	__kernel_time_t msg_rtime; /* last msgrcv time */
+	unsigned long __unused2;
+	__kernel_time_t msg_ctime; /* last change time */
+	unsigned long __unused3;
+	unsigned long msg_cbytes; /* current number of bytes on queue */
+	unsigned long msg_qnum; /* number of messages in queue */
+	unsigned long msg_qbytes; /* max number of bytes on queue */
+	__kernel_pid_t msg_lspid; /* pid of last msgsnd */
+	__kernel_pid_t msg_lrpid; /* last receive pid */
+	unsigned long __unused4;
+	unsigned long __unused5;
+};
+
+#endif /* _ASM_MSGBUF_H */
diff --git a/include/asm-microblaze/shmbuf.h b/include/asm-microblaze/shmbuf.h
new file mode 100644
index 0000000..5571e2f
--- /dev/null
+++ b/include/asm-microblaze/shmbuf.h
@@ -0,0 +1,52 @@
+/*
+ * include/asm-microblaze/shmbuf.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_SHMBUF_H
+#define _ASM_SHMBUF_H
+
+/*
+ * The shmid64_ds structure for m68k architecture.
+ * Note extra padding because this structure is passed back and forth
+ * between kernel and user space.
+ *
+ * Pad space is left for:
+ * - 64-bit time_t to solve y2038 problem
+ * - 2 miscellaneous 32-bit values
+ */
+
+struct shmid64_ds {
+	struct ipc64_perm	shm_perm; /* operation perms */
+	size_t			shm_segsz; /* size of segment (bytes) */
+	__kernel_time_t		shm_atime; /* last attach time */
+	unsigned long		__unused1;
+	__kernel_time_t		shm_dtime; /* last detach time */
+	unsigned long		__unused2;
+	__kernel_time_t		shm_ctime; /* last change time */
+	unsigned long		__unused3;
+	__kernel_pid_t		shm_cpid; /* pid of creator */
+	__kernel_pid_t		shm_lpid; /* pid of last operator */
+	unsigned long		shm_nattch; /* no. of current attaches */
+	unsigned long		__unused4;
+	unsigned long		__unused5;
+};
+
+struct shminfo64 {
+	unsigned long	shmmax;
+	unsigned long	shmmin;
+	unsigned long	shmmni;
+	unsigned long	shmseg;
+	unsigned long	shmall;
+	unsigned long	__unused1;
+	unsigned long	__unused2;
+	unsigned long	__unused3;
+	unsigned long	__unused4;
+};
+
+#endif /* _ASM_SHMBUF_H */
diff --git a/include/asm-microblaze/shmparam.h b/include/asm-microblaze/shmparam.h
new file mode 100644
index 0000000..752498c
--- /dev/null
+++ b/include/asm-microblaze/shmparam.h
@@ -0,0 +1,16 @@
+/*
+ * include/asm-microblaze/shmparam.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_SHMPARAM_H
+#define _ASM_SHMPARAM_H
+
+#define SHMLBA	PAGE_SIZE /* attach addr a multiple of this */
+
+#endif /* _ASM_SHMPARAM_H */
-- 
1.5.4.rc4.14.g6fc74

