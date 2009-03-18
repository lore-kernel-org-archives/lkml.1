Return-Path: <linux-kernel-owner+w=401wt.eu-S1759175AbZCRVxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759175AbZCRVxk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 17:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757374AbZCRVnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 17:43:42 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:54475 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758193AbZCRVnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 17:43:40 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 27/57] microblaze_v7: IPC support
Date: Wed, 18 Mar 2009 21:30:54 +0100
Message-Id: <5c66d0329884feb553ae745584f6db589a892eb1.1237407249.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <f8494212852d4cec890ae5e152353c91153c7c0d.1237407249.git.monstr@monstr.eu>
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu>
 <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
 <c1bdfabf85ce10babc3aa38d3bb7558a093bc49e.1237407249.git.monstr@monstr.eu>
 <4b5aee01d11fc790c7842838ea63a82ee3273003.1237407249.git.monstr@monstr.eu>
 <af309ba8e95f503b7990461384d9f8453f45dbbd.1237407249.git.monstr@monstr.eu>
 <5f8b2a60496983f572ef6d3b4e2f986c167a8336.1237407249.git.monstr@monstr.eu>
 <fbef554ff1d05fa50312d91e61a0d63d3207076c.1237407249.git.monstr@monstr.eu>
 <dad2353f129217470f0595eeed98412b4c84ed6b.1237407249.git.monstr@monstr.eu>
 <20fd42a1e8837c7352d35d157aa3393e88152c32.1237407249.git.monstr@monstr.eu>
 <f7c1685bd3f387be8633db5fb3dd4cb5e7c2d792.1237407249.git.monstr@monstr.eu>
 <2f48efc353c11dfdfc7b052bdfe052b71c09ab23.1237407249.git.monstr@monstr.eu>
 <f7f2d17e21a3df9931c75976c37a003d11190cc9.1237407249.git.monstr@monstr.eu>
 <58cf06c85e07477170677b72ce3437af10476bec.1237407249.git.monstr@monstr.eu>
 <eaa0169a360a328883ab0eabd2a189c21bad4c30.1237407249.git.monstr@monstr.eu>
 <20227d6f2615060d6560785090513e251cbe2654.1237407249.git.monstr@monstr.eu>
 <69ef4f976d86c870a97fbe4974c242c74acc477d.1237407249.git.monstr@monstr.eu>
 <eb4ccc67cf39abc816c8d7653fdc7561d14c1da2.1237407249.git.monstr@monstr.eu>
 <1477ec41e7ba0ec847a064e1f8e422dc2a5dcc9f.1237407249.git.monstr@monstr.eu>
 <75127eae09c978220d452d92f95763dde24f1d52.1237407249.git.monstr@monstr.eu>
 <b726b7b271cf303c36af54c4e155140541a6769b.1237407249.git.monstr@monstr.eu>
 <644f08d7f8cd338e606ed703e221914f75588fb5.1237407249.git.monstr@monstr.eu>
 <6d19f608a4ba3e7718aa55794c2845f19b5ed5e2.1237407249.git.monstr@monstr.eu>
 <039bc2fea33d23a3e7d2d85ac6fb275b8d21b5ed.1237407249.git.monstr@monstr.eu>
 <513d4067a84be1ecb47577e1edf131d2b3572808.1237407249.git.monstr@monstr.eu>
 <c6a6fbe7b56db27d9b74ee593cf068963f86ee58.1237407249.git.monstr@monstr.eu>
 <e9d4d452140c50451741dd6024ab89efd24ac8e6.1237407249.git.monstr@monstr.eu>
 <f8494212852d4cec890ae5e152353c91153c7c0d.1237407249.git.monstr@monstr.eu>
In-Reply-To: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
References: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/ipc.h       |    1 +
 arch/microblaze/include/asm/ipcbuf.h    |   36 +++++
 arch/microblaze/kernel/sys_microblaze.c |  226 +++++++++++++++++++++++++++++++
 3 files changed, 263 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/include/asm/ipc.h
 create mode 100644 arch/microblaze/include/asm/ipcbuf.h
 create mode 100644 arch/microblaze/kernel/sys_microblaze.c

diff --git a/arch/microblaze/include/asm/ipc.h b/arch/microblaze/include/asm/ipc.h
new file mode 100644
index 0000000..a46e3d9
--- /dev/null
+++ b/arch/microblaze/include/asm/ipc.h
@@ -0,0 +1 @@
+#include <asm-generic/ipc.h>
diff --git a/arch/microblaze/include/asm/ipcbuf.h b/arch/microblaze/include/asm/ipcbuf.h
new file mode 100644
index 0000000..b056fa4
--- /dev/null
+++ b/arch/microblaze/include/asm/ipcbuf.h
@@ -0,0 +1,36 @@
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_IPCBUF_H
+#define _ASM_MICROBLAZE_IPCBUF_H
+
+/*
+ * The user_ipc_perm structure for microblaze architecture.
+ * Note extra padding because this structure is passed back and forth
+ * between kernel and user space.
+ *
+ * Pad space is left for:
+ * - 32-bit mode_t and seq
+ * - 2 miscellaneous 32-bit values
+ */
+
+struct ipc64_perm {
+	__kernel_key_t		key;
+	__kernel_uid32_t	uid;
+	__kernel_gid32_t	gid;
+	__kernel_uid32_t	cuid;
+	__kernel_gid32_t	cgid;
+	__kernel_mode_t		mode;
+	unsigned short		__pad1;
+	unsigned short		seq;
+	unsigned short		__pad2;
+	unsigned long		__unused1;
+	unsigned long		__unused2;
+};
+
+#endif /* _ASM_MICROBLAZE_IPCBUF_H */
diff --git a/arch/microblaze/kernel/sys_microblaze.c b/arch/microblaze/kernel/sys_microblaze.c
new file mode 100644
index 0000000..831fc31
--- /dev/null
+++ b/arch/microblaze/kernel/sys_microblaze.c
@@ -0,0 +1,226 @@
+/*
+ * Copyright (C) 2007 PetaLogix
+ *	John Williams <john.williams@petalogix.com>
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *	Yasushi SHOJI <yashi@atmark-techno.com>
+ *	Tetsuya OHKAWA <tetsuya@atmark-techno.com>
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/errno.h>
+#include <linux/mm.h>
+#include <linux/smp.h>
+#include <linux/smp_lock.h>
+#include <linux/syscalls.h>
+#include <linux/sem.h>
+#include <linux/msg.h>
+#include <linux/shm.h>
+#include <linux/stat.h>
+#include <linux/mman.h>
+#include <linux/sys.h>
+#include <linux/ipc.h>
+#include <linux/utsname.h>
+#include <linux/file.h>
+#include <linux/module.h>
+#include <linux/err.h>
+#include <linux/fs.h>
+#include <linux/ipc.h>
+#include <linux/semaphore.h>
+#include <linux/syscalls.h>
+#include <linux/uaccess.h>
+#include <linux/unistd.h>
+
+#include <asm/syscalls.h>
+/*
+ * sys_ipc() is the de-multiplexer for the SysV IPC calls..
+ *
+ * This is really horribly ugly. This will be remove with new toolchain.
+ */
+asmlinkage int
+sys_ipc(uint call, int first, int second, int third, void *ptr, long fifth)
+{
+	int version, ret;
+
+	version = call >> 16; /* hack for backward compatibility */
+	call &= 0xffff;
+
+	ret = -EINVAL;
+	switch (call) {
+	case SEMOP:
+		ret = sys_semop(first, (struct sembuf *)ptr, second);
+		break;
+	case SEMGET:
+		ret = sys_semget(first, second, third);
+		break;
+	case SEMCTL:
+	{
+		union semun fourth;
+
+		if (!ptr)
+			break;
+		if ((ret = access_ok(VERIFY_READ, ptr,
+					sizeof(long)) ? 0 : -EFAULT)
+			|| (ret = get_user(fourth.__pad, (void **)ptr)))
+			break;
+		ret = sys_semctl(first, second, third, fourth);
+		break;
+	}
+	case MSGSND:
+		ret = sys_msgsnd(first, (struct msgbuf *) ptr, second, third);
+		break;
+	case MSGRCV:
+		switch (version) {
+		case 0: {
+			struct ipc_kludge tmp;
+
+			if (!ptr)
+				break;
+			if ((ret = access_ok(VERIFY_READ, ptr,
+					sizeof(tmp)) ? 0 : -EFAULT)
+				|| (ret = copy_from_user(&tmp,
+						(struct ipc_kludge *) ptr,
+						sizeof(tmp))))
+				break;
+			ret = sys_msgrcv(first, tmp.msgp, second, tmp.msgtyp,
+					third);
+			break;
+			}
+		default:
+			ret = sys_msgrcv(first, (struct msgbuf *) ptr,
+					second, fifth, third);
+			break;
+		}
+		break;
+	case MSGGET:
+		ret = sys_msgget((key_t) first, second);
+		break;
+	case MSGCTL:
+		ret = sys_msgctl(first, second, (struct msqid_ds *) ptr);
+		break;
+	case SHMAT:
+		switch (version) {
+		default: {
+			ulong raddr;
+
+			if ((ret = access_ok(VERIFY_WRITE, (ulong *) third,
+					sizeof(ulong)) ? 0 : -EFAULT))
+				break;
+			ret = do_shmat(first, (char *) ptr, second, &raddr);
+			if (ret)
+				break;
+			ret = put_user(raddr, (ulong *) third);
+			break;
+			}
+		case 1:	/* iBCS2 emulator entry point */
+			if (!segment_eq(get_fs(), get_ds()))
+				break;
+			ret = do_shmat(first, (char *) ptr, second,
+					(ulong *) third);
+			break;
+		}
+		break;
+	case SHMDT:
+		ret = sys_shmdt((char *)ptr);
+		break;
+	case SHMGET:
+		ret = sys_shmget(first, second, third);
+		break;
+	case SHMCTL:
+		ret = sys_shmctl(first, second, (struct shmid_ds *) ptr);
+		break;
+	}
+	return -EINVAL;
+}
+
+asmlinkage int sys_vfork(struct pt_regs *regs)
+{
+	return do_fork(CLONE_VFORK | CLONE_VM | SIGCHLD, regs->r1,
+						regs, 0, NULL, NULL);
+}
+
+asmlinkage int sys_clone(int flags, unsigned long stack, struct pt_regs *regs)
+{
+	if (!stack)
+		stack = regs->r1;
+	return do_fork(flags, stack, regs, 0, NULL, NULL);
+}
+
+asmlinkage int sys_execve(char __user *filenamei, char __user *__user *argv,
+			char __user *__user *envp, struct pt_regs *regs)
+{
+	int error;
+	char *filename;
+
+	filename = getname(filenamei);
+	error = PTR_ERR(filename);
+	if (IS_ERR(filename))
+		goto out;
+	error = do_execve(filename, argv, envp, regs);
+	putname(filename);
+out:
+	return error;
+}
+
+asmlinkage unsigned long
+sys_mmap2(unsigned long addr, size_t len,
+	unsigned long prot, unsigned long flags,
+	unsigned long fd, unsigned long pgoff)
+{
+	struct file *file = NULL;
+	int ret = -EBADF;
+
+	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
+	if (!(flags & MAP_ANONYMOUS)) {
+		file = fget(fd);
+		if (!file) {
+			printk(KERN_INFO "no fd in mmap\r\n");
+			goto out;
+		}
+	}
+
+	down_write(&current->mm->mmap_sem);
+	ret = do_mmap_pgoff(file, addr, len, prot, flags, pgoff);
+	up_write(&current->mm->mmap_sem);
+	if (file)
+		fput(file);
+out:
+	return ret;
+}
+
+asmlinkage unsigned long sys_mmap(unsigned long addr, size_t len,
+			unsigned long prot, unsigned long flags,
+			unsigned long fd, off_t offset)
+{
+	int err = -EINVAL;
+
+	if (offset & ~PAGE_MASK) {
+		printk(KERN_INFO "no pagemask in mmap\r\n");
+		goto out;
+	}
+
+	err = sys_mmap2(addr, len, prot, flags, fd, offset >> PAGE_SHIFT);
+out:
+	return err;
+}
+
+/*
+ * Do a system call from kernel instead of calling sys_execve so we
+ * end up with proper pt_regs.
+ */
+int kernel_execve(const char *filename, char *const argv[], char *const envp[])
+{
+	register const char *__a __asm__("r5") = filename;
+	register const void *__b __asm__("r6") = argv;
+	register const void *__c __asm__("r7") = envp;
+	register unsigned long __syscall __asm__("r12") = __NR_execve;
+	register unsigned long __ret __asm__("r3");
+	__asm__ __volatile__ ("brki r14, 0x8"
+			: "=r" (__ret), "=r" (__syscall)
+			: "1" (__syscall), "r" (__a), "r" (__b), "r" (__c)
+			: "r4", "r8", "r9",
+			"r10", "r11", "r14", "cc", "memory");
+	return __ret;
+}
-- 
1.5.5.1

