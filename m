Return-Path: <linux-kernel-owner+w=401wt.eu-S1757368AbXHNVYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368AbXHNVYk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 17:24:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755007AbXHNVWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 17:22:13 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:38394 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751306AbXHNVWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 17:22:09 -0400
Date: Tue, 14 Aug 2007 23:21:58 +0200
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [RFC: 2.6 patch] remove include/asm-*/ipc.h
Message-ID: <20070814212158.GU18945@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

All asm/ipc.h files do only #include <asm-generic/ipc.h>.

This patch therefore removes all include/asm-*/ipc.h files and moves the 
contents of include/asm-generic/ipc.h to include/linux/ipc.h.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/arm/kernel/sys_arm.c         |    2 -
 arch/arm/kernel/sys_oabi-compat.c |    2 -
 arch/cris/kernel/sys_cris.c       |    2 -
 arch/frv/kernel/sys_frv.c         |    2 -
 arch/h8300/kernel/sys_h8300.c     |    2 -
 arch/i386/kernel/sys_i386.c       |    2 -
 arch/m32r/kernel/sys_m32r.c       |    2 -
 arch/m68k/kernel/sys_m68k.c       |    2 -
 arch/m68knommu/kernel/sys_m68k.c  |    2 -
 arch/mips/kernel/linux32.c        |    2 -
 arch/mips/kernel/syscall.c        |    2 -
 arch/powerpc/kernel/sys_ppc32.c   |    2 -
 arch/powerpc/kernel/syscalls.c    |    1 
 arch/s390/kernel/compat_linux.c   |    2 -
 arch/s390/kernel/sys_s390.c       |    2 -
 arch/sh/kernel/sys_sh.c           |    2 -
 arch/sh64/kernel/sys_sh64.c       |    2 -
 arch/sparc/kernel/sys_sparc.c     |    2 -
 arch/sparc64/kernel/sys_sparc.c   |    1 
 arch/sparc64/kernel/sys_sparc32.c |    1 
 arch/sparc64/solaris/ipc.c        |    2 -
 arch/um/sys-i386/syscalls.c       |    2 -
 arch/v850/kernel/syscalls.c       |    1 
 arch/x86_64/ia32/ipc32.c          |    2 -
 include/asm-arm/ipc.h             |    1 
 include/asm-blackfin/ipc.h        |    1 
 include/asm-cris/ipc.h            |    1 
 include/asm-frv/ipc.h             |    1 
 include/asm-generic/Kbuild        |    1 
 include/asm-generic/ipc.h         |   31 ------------------------------
 include/asm-h8300/ipc.h           |    1 
 include/asm-i386/ipc.h            |    1 
 include/asm-m32r/ipc.h            |    1 
 include/asm-m68k/ipc.h            |    1 
 include/asm-m68knommu/ipc.h       |    1 
 include/asm-mips/ipc.h            |    1 
 include/asm-powerpc/Kbuild        |    1 
 include/asm-powerpc/ipc.h         |    1 
 include/asm-s390/ipc.h            |    1 
 include/asm-sh/ipc.h              |    1 
 include/asm-sh64/ipc.h            |    1 
 include/asm-sparc/ipc.h           |    1 
 include/asm-sparc64/Kbuild        |    1 
 include/asm-sparc64/ipc.h         |    1 
 include/asm-um/ipc.h              |    1 
 include/asm-v850/ipc.h            |    1 
 include/linux/ipc.h               |   28 +++++++++++++++++++++++++++
 47 files changed, 47 insertions(+), 77 deletions(-)

diff --git a/arch/arm/kernel/sys_arm.c b/arch/arm/kernel/sys_arm.c
index 4d25e49..9bd1870 100644
--- a/arch/arm/kernel/sys_arm.c
+++ b/arch/arm/kernel/sys_arm.c
@@ -26,9 +26,9 @@
 #include <linux/fs.h>
 #include <linux/file.h>
 #include <linux/utsname.h>
+#include <linux/ipc.h>
 
 #include <asm/uaccess.h>
-#include <asm/ipc.h>
 
 extern unsigned long do_mremap(unsigned long addr, unsigned long old_len,
 			       unsigned long new_len, unsigned long flags,
diff --git a/arch/arm/kernel/sys_oabi-compat.c b/arch/arm/kernel/sys_oabi-compat.c
index 8e2f9bc..e8b9804 100644
--- a/arch/arm/kernel/sys_oabi-compat.c
+++ b/arch/arm/kernel/sys_oabi-compat.c
@@ -80,7 +80,7 @@
 #include <linux/sem.h>
 #include <linux/socket.h>
 #include <linux/net.h>
-#include <asm/ipc.h>
+#include <linux/ipc.h>
 #include <asm/uaccess.h>
 
 struct oldabi_stat64 {
diff --git a/arch/cris/kernel/sys_cris.c b/arch/cris/kernel/sys_cris.c
index 0aa0e0e..514359b 100644
--- a/arch/cris/kernel/sys_cris.c
+++ b/arch/cris/kernel/sys_cris.c
@@ -21,9 +21,9 @@
 #include <linux/stat.h>
 #include <linux/mman.h>
 #include <linux/file.h>
+#include <linux/ipc.h>
 
 #include <asm/uaccess.h>
-#include <asm/ipc.h>
 #include <asm/segment.h>
 
 /*
diff --git a/arch/frv/kernel/sys_frv.c b/arch/frv/kernel/sys_frv.c
index 6fbe266..04c6b16 100644
--- a/arch/frv/kernel/sys_frv.c
+++ b/arch/frv/kernel/sys_frv.c
@@ -23,10 +23,10 @@
 #include <linux/file.h>
 #include <linux/utsname.h>
 #include <linux/syscalls.h>
+#include <linux/ipc.h>
 
 #include <asm/setup.h>
 #include <asm/uaccess.h>
-#include <asm/ipc.h>
 
 /*
  * sys_pipe() is the normal C calling standard for creating
diff --git a/arch/h8300/kernel/sys_h8300.c b/arch/h8300/kernel/sys_h8300.c
index de7688c..f013c97 100644
--- a/arch/h8300/kernel/sys_h8300.c
+++ b/arch/h8300/kernel/sys_h8300.c
@@ -18,12 +18,12 @@
 #include <linux/mman.h>
 #include <linux/file.h>
 #include <linux/utsname.h>
+#include <linux/ipc.h>
 
 #include <asm/setup.h>
 #include <asm/uaccess.h>
 #include <asm/cachectl.h>
 #include <asm/traps.h>
-#include <asm/ipc.h>
 #include <asm/unistd.h>
 
 /*
diff --git a/arch/i386/kernel/sys_i386.c b/arch/i386/kernel/sys_i386.c
index 4214730..4700845 100644
--- a/arch/i386/kernel/sys_i386.c
+++ b/arch/i386/kernel/sys_i386.c
@@ -19,10 +19,10 @@
 #include <linux/mman.h>
 #include <linux/file.h>
 #include <linux/utsname.h>
+#include <linux/ipc.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
-#include <asm/ipc.h>
 
 /*
  * sys_pipe() is the normal C calling standard for creating
diff --git a/arch/m32r/kernel/sys_m32r.c b/arch/m32r/kernel/sys_m32r.c
index b13dbbe..0fc2efe 100644
--- a/arch/m32r/kernel/sys_m32r.c
+++ b/arch/m32r/kernel/sys_m32r.c
@@ -20,11 +20,11 @@
 #include <linux/mman.h>
 #include <linux/file.h>
 #include <linux/utsname.h>
+#include <linux/ipc.h>
 
 #include <asm/uaccess.h>
 #include <asm/cachectl.h>
 #include <asm/cacheflush.h>
-#include <asm/ipc.h>
 #include <asm/syscall.h>
 #include <asm/unistd.h>
 
diff --git a/arch/m68k/kernel/sys_m68k.c b/arch/m68k/kernel/sys_m68k.c
index 36d78cf..e892f17 100644
--- a/arch/m68k/kernel/sys_m68k.c
+++ b/arch/m68k/kernel/sys_m68k.c
@@ -21,12 +21,12 @@
 #include <linux/mman.h>
 #include <linux/file.h>
 #include <linux/utsname.h>
+#include <linux/ipc.h>
 
 #include <asm/setup.h>
 #include <asm/uaccess.h>
 #include <asm/cachectl.h>
 #include <asm/traps.h>
-#include <asm/ipc.h>
 #include <asm/page.h>
 #include <asm/unistd.h>
 
diff --git a/arch/m68knommu/kernel/sys_m68k.c b/arch/m68knommu/kernel/sys_m68k.c
index 48e6b33..3772737 100644
--- a/arch/m68knommu/kernel/sys_m68k.c
+++ b/arch/m68knommu/kernel/sys_m68k.c
@@ -18,12 +18,12 @@
 #include <linux/mman.h>
 #include <linux/file.h>
 #include <linux/utsname.h>
+#include <linux/ipc.h>
 
 #include <asm/setup.h>
 #include <asm/uaccess.h>
 #include <asm/cachectl.h>
 #include <asm/traps.h>
-#include <asm/ipc.h>
 #include <asm/cacheflush.h>
 #include <asm/unistd.h>
 
diff --git a/arch/mips/kernel/linux32.c b/arch/mips/kernel/linux32.c
index c37568d..3b600a4 100644
--- a/arch/mips/kernel/linux32.c
+++ b/arch/mips/kernel/linux32.c
@@ -35,12 +35,12 @@
 #include <linux/security.h>
 #include <linux/compat.h>
 #include <linux/vfs.h>
+#include <linux/ipc.h>
 
 #include <net/sock.h>
 #include <net/scm.h>
 
 #include <asm/compat-signal.h>
-#include <asm/ipc.h>
 #include <asm/sim.h>
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
diff --git a/arch/mips/kernel/syscall.c b/arch/mips/kernel/syscall.c
index 541b500..9d80e42 100644
--- a/arch/mips/kernel/syscall.c
+++ b/arch/mips/kernel/syscall.c
@@ -28,11 +28,11 @@
 #include <linux/shm.h>
 #include <linux/compiler.h>
 #include <linux/module.h>
+#include <linux/ipc.h>
 
 #include <asm/branch.h>
 #include <asm/cachectl.h>
 #include <asm/cacheflush.h>
-#include <asm/ipc.h>
 #include <asm/asm-offsets.h>
 #include <asm/signal.h>
 #include <asm/sim.h>
diff --git a/arch/powerpc/kernel/sys_ppc32.c b/arch/powerpc/kernel/sys_ppc32.c
index bd85b5f..4a4f5c6 100644
--- a/arch/powerpc/kernel/sys_ppc32.c
+++ b/arch/powerpc/kernel/sys_ppc32.c
@@ -41,10 +41,10 @@
 #include <linux/compat.h>
 #include <linux/ptrace.h>
 #include <linux/elf.h>
+#include <linux/ipc.h>
 
 #include <asm/ptrace.h>
 #include <asm/types.h>
-#include <asm/ipc.h>
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
 #include <asm/semaphore.h>
diff --git a/arch/powerpc/kernel/syscalls.c b/arch/powerpc/kernel/syscalls.c
index f85f402..3b1d5dd 100644
--- a/arch/powerpc/kernel/syscalls.c
+++ b/arch/powerpc/kernel/syscalls.c
@@ -38,7 +38,6 @@
 #include <linux/personality.h>
 
 #include <asm/uaccess.h>
-#include <asm/ipc.h>
 #include <asm/semaphore.h>
 #include <asm/syscalls.h>
 #include <asm/time.h>
diff --git a/arch/s390/kernel/compat_linux.c b/arch/s390/kernel/compat_linux.c
index 5236fdb..50b85d0 100644
--- a/arch/s390/kernel/compat_linux.c
+++ b/arch/s390/kernel/compat_linux.c
@@ -58,9 +58,9 @@
 #include <linux/vfs.h>
 #include <linux/ptrace.h>
 #include <linux/fadvise.h>
+#include <linux/ipc.h>
 
 #include <asm/types.h>
-#include <asm/ipc.h>
 #include <asm/uaccess.h>
 #include <asm/semaphore.h>
 
diff --git a/arch/s390/kernel/sys_s390.c b/arch/s390/kernel/sys_s390.c
index 1eaff84..fefee99 100644
--- a/arch/s390/kernel/sys_s390.c
+++ b/arch/s390/kernel/sys_s390.c
@@ -28,9 +28,9 @@
 #include <linux/utsname.h>
 #include <linux/personality.h>
 #include <linux/unistd.h>
+#include <linux/ipc.h>
 
 #include <asm/uaccess.h>
-#include <asm/ipc.h>
 
 /*
  * sys_pipe() is the normal C calling standard for creating
diff --git a/arch/sh/kernel/sys_sh.c b/arch/sh/kernel/sys_sh.c
index 76b1bc7..611e936 100644
--- a/arch/sh/kernel/sys_sh.c
+++ b/arch/sh/kernel/sys_sh.c
@@ -21,9 +21,9 @@
 #include <linux/utsname.h>
 #include <linux/module.h>
 #include <linux/fs.h>
+#include <linux/ipc.h>
 #include <asm/cacheflush.h>
 #include <asm/uaccess.h>
-#include <asm/ipc.h>
 #include <asm/unistd.h>
 
 /*
diff --git a/arch/sh64/kernel/sys_sh64.c b/arch/sh64/kernel/sys_sh64.c
index 19126da..5319ffd 100644
--- a/arch/sh64/kernel/sys_sh64.c
+++ b/arch/sh64/kernel/sys_sh64.c
@@ -28,8 +28,8 @@
 #include <linux/file.h>
 #include <linux/utsname.h>
 #include <linux/syscalls.h>
+#include <linux/ipc.h>
 #include <asm/uaccess.h>
-#include <asm/ipc.h>
 #include <asm/ptrace.h>
 #include <asm/unistd.h>
 
diff --git a/arch/sparc/kernel/sys_sparc.c b/arch/sparc/kernel/sys_sparc.c
index a954a0c..6c0221e 100644
--- a/arch/sparc/kernel/sys_sparc.c
+++ b/arch/sparc/kernel/sys_sparc.c
@@ -21,9 +21,9 @@
 #include <linux/utsname.h>
 #include <linux/smp.h>
 #include <linux/smp_lock.h>
+#include <linux/ipc.h>
 
 #include <asm/uaccess.h>
-#include <asm/ipc.h>
 #include <asm/unistd.h>
 
 /* #define DEBUG_UNIMP_SYSCALL */
diff --git a/arch/sparc64/kernel/sys_sparc.c b/arch/sparc64/kernel/sys_sparc.c
index d108eeb..45861aa 100644
--- a/arch/sparc64/kernel/sys_sparc.c
+++ b/arch/sparc64/kernel/sys_sparc.c
@@ -26,7 +26,6 @@
 #include <linux/random.h>
 
 #include <asm/uaccess.h>
-#include <asm/ipc.h>
 #include <asm/utrap.h>
 #include <asm/perfctr.h>
 #include <asm/a.out.h>
diff --git a/arch/sparc64/kernel/sys_sparc32.c b/arch/sparc64/kernel/sys_sparc32.c
index e8dce90..78caff9 100644
--- a/arch/sparc64/kernel/sys_sparc32.c
+++ b/arch/sparc64/kernel/sys_sparc32.c
@@ -54,7 +54,6 @@
 #include <linux/highuid.h>
 
 #include <asm/types.h>
-#include <asm/ipc.h>
 #include <asm/uaccess.h>
 #include <asm/fpumacro.h>
 #include <asm/semaphore.h>
diff --git a/arch/sparc64/solaris/ipc.c b/arch/sparc64/solaris/ipc.c
index a531a2c..499135f 100644
--- a/arch/sparc64/solaris/ipc.c
+++ b/arch/sparc64/solaris/ipc.c
@@ -11,10 +11,10 @@
 #include <linux/shm.h>
 #include <linux/sem.h>
 #include <linux/msg.h>
+#include <linux/ipc.h>
 
 #include <asm/uaccess.h>
 #include <asm/string.h>
-#include <asm/ipc.h>
 
 #include "conv.h"
 
diff --git a/arch/um/sys-i386/syscalls.c b/arch/um/sys-i386/syscalls.c
index 710d5fb..e2d1426 100644
--- a/arch/um/sys-i386/syscalls.c
+++ b/arch/um/sys-i386/syscalls.c
@@ -5,7 +5,7 @@
 
 #include "linux/sched.h"
 #include "linux/shm.h"
-#include "asm/ipc.h"
+#include "linux/ipc.h"
 #include "asm/mman.h"
 #include "asm/uaccess.h"
 #include "asm/unistd.h"
diff --git a/arch/v850/kernel/syscalls.c b/arch/v850/kernel/syscalls.c
index f9f00cc..0a4df4d 100644
--- a/arch/v850/kernel/syscalls.c
+++ b/arch/v850/kernel/syscalls.c
@@ -30,7 +30,6 @@
 #include <linux/file.h>
 
 #include <asm/uaccess.h>
-#include <asm/ipc.h>
 #include <asm/semaphore.h>
 #include <asm/unistd.h>
 
diff --git a/include/asm-arm/ipc.h b/include/asm-arm/ipc.h
deleted file mode 100644
index a46e3d9..0000000
--- a/include/asm-arm/ipc.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ipc.h>
diff --git a/include/asm-blackfin/ipc.h b/include/asm-blackfin/ipc.h
deleted file mode 100644
index a46e3d9..0000000
--- a/include/asm-blackfin/ipc.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ipc.h>
diff --git a/include/asm-cris/ipc.h b/include/asm-cris/ipc.h
deleted file mode 100644
index a46e3d9..0000000
--- a/include/asm-cris/ipc.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ipc.h>
diff --git a/include/asm-frv/ipc.h b/include/asm-frv/ipc.h
deleted file mode 100644
index a46e3d9..0000000
--- a/include/asm-frv/ipc.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ipc.h>
diff --git a/include/asm-generic/Kbuild b/include/asm-generic/Kbuild
index 5bfeef7..c18110e 100644
--- a/include/asm-generic/Kbuild
+++ b/include/asm-generic/Kbuild
@@ -2,7 +2,6 @@ header-y += errno-base.h
 header-y += errno.h
 header-y += fcntl.h
 header-y += ioctl.h
-header-y += ipc.h
 header-y += mman.h
 header-y += poll.h
 header-y += signal.h
diff --git a/include/asm-generic/ipc.h b/include/asm-generic/ipc.h
deleted file mode 100644
index a40407a..0000000
--- a/include/asm-generic/ipc.h
+++ /dev/null
@@ -1,31 +0,0 @@
-#ifndef _ASM_GENERIC_IPC_H
-#define _ASM_GENERIC_IPC_H
-/*
- * These are used to wrap system calls.
- *
- * See architecture code for ugly details..
- */
-struct ipc_kludge {
-	struct msgbuf __user *msgp;
-	long msgtyp;
-};
-
-#define SEMOP		 1
-#define SEMGET		 2
-#define SEMCTL		 3
-#define SEMTIMEDOP	 4
-#define MSGSND		11
-#define MSGRCV		12
-#define MSGGET		13
-#define MSGCTL		14
-#define SHMAT		21
-#define SHMDT		22
-#define SHMGET		23
-#define SHMCTL		24
-
-/* Used by the DIPC package, try and avoid reusing it */
-#define DIPC            25
-
-#define IPCCALL(version,op)	((version)<<16 | (op))
-
-#endif	/* _ASM_GENERIC_IPC_H */
diff --git a/include/asm-h8300/ipc.h b/include/asm-h8300/ipc.h
deleted file mode 100644
index a46e3d9..0000000
--- a/include/asm-h8300/ipc.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ipc.h>
diff --git a/include/asm-i386/ipc.h b/include/asm-i386/ipc.h
deleted file mode 100644
index a46e3d9..0000000
--- a/include/asm-i386/ipc.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ipc.h>
diff --git a/include/asm-m32r/ipc.h b/include/asm-m32r/ipc.h
deleted file mode 100644
index a46e3d9..0000000
--- a/include/asm-m32r/ipc.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ipc.h>
diff --git a/include/asm-m68k/ipc.h b/include/asm-m68k/ipc.h
deleted file mode 100644
index a46e3d9..0000000
--- a/include/asm-m68k/ipc.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ipc.h>
diff --git a/include/asm-m68knommu/ipc.h b/include/asm-m68knommu/ipc.h
deleted file mode 100644
index a46e3d9..0000000
--- a/include/asm-m68knommu/ipc.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ipc.h>
diff --git a/include/asm-mips/ipc.h b/include/asm-mips/ipc.h
deleted file mode 100644
index a46e3d9..0000000
--- a/include/asm-mips/ipc.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ipc.h>
diff --git a/include/asm-powerpc/Kbuild b/include/asm-powerpc/Kbuild
index 4869513..be9eefd 100644
--- a/include/asm-powerpc/Kbuild
+++ b/include/asm-powerpc/Kbuild
@@ -13,7 +13,6 @@ header-y += shmbuf.h
 header-y += socket.h
 header-y += termbits.h
 header-y += fcntl.h
-header-y += ipc.h
 header-y += poll.h
 header-y += shmparam.h
 header-y += sockios.h
diff --git a/include/asm-powerpc/ipc.h b/include/asm-powerpc/ipc.h
deleted file mode 100644
index a46e3d9..0000000
--- a/include/asm-powerpc/ipc.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ipc.h>
diff --git a/include/asm-s390/ipc.h b/include/asm-s390/ipc.h
deleted file mode 100644
index a46e3d9..0000000
--- a/include/asm-s390/ipc.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ipc.h>
diff --git a/include/asm-sh/ipc.h b/include/asm-sh/ipc.h
deleted file mode 100644
index a46e3d9..0000000
--- a/include/asm-sh/ipc.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ipc.h>
diff --git a/include/asm-sh64/ipc.h b/include/asm-sh64/ipc.h
deleted file mode 100644
index a46e3d9..0000000
--- a/include/asm-sh64/ipc.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ipc.h>
diff --git a/include/asm-sparc/ipc.h b/include/asm-sparc/ipc.h
deleted file mode 100644
index a46e3d9..0000000
--- a/include/asm-sparc/ipc.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ipc.h>
diff --git a/include/asm-sparc64/Kbuild b/include/asm-sparc64/Kbuild
index 854fd3a..a90dc82 100644
--- a/include/asm-sparc64/Kbuild
+++ b/include/asm-sparc64/Kbuild
@@ -10,7 +10,6 @@ header-y += bbc.h
 header-y += bpp.h
 header-y += display7seg.h
 header-y += envctrl.h
-header-y += ipc.h
 header-y += openprom.h
 header-y += openpromio.h
 header-y += pconf.h
diff --git a/include/asm-sparc64/ipc.h b/include/asm-sparc64/ipc.h
deleted file mode 100644
index a46e3d9..0000000
--- a/include/asm-sparc64/ipc.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ipc.h>
diff --git a/include/asm-um/ipc.h b/include/asm-um/ipc.h
deleted file mode 100644
index a46e3d9..0000000
--- a/include/asm-um/ipc.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ipc.h>
diff --git a/include/asm-v850/ipc.h b/include/asm-v850/ipc.h
deleted file mode 100644
index a46e3d9..0000000
--- a/include/asm-v850/ipc.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ipc.h>
diff --git a/include/linux/ipc.h b/include/linux/ipc.h
index 3fd3ddd..ee11183 100644
--- a/include/linux/ipc.h
+++ b/include/linux/ipc.h
@@ -49,6 +49,34 @@ struct ipc_perm
 #define IPC_64  0x0100  /* New version (support 32-bit UIDs, bigger
 			   message sizes, etc. */
 
+/*
+ * These are used to wrap system calls.
+ *
+ * See architecture code for ugly details..
+ */
+struct ipc_kludge {
+	struct msgbuf __user *msgp;
+	long msgtyp;
+};
+
+#define SEMOP		 1
+#define SEMGET		 2
+#define SEMCTL		 3
+#define SEMTIMEDOP	 4
+#define MSGSND		11
+#define MSGRCV		12
+#define MSGGET		13
+#define MSGCTL		14
+#define SHMAT		21
+#define SHMDT		22
+#define SHMGET		23
+#define SHMCTL		24
+
+/* Used by the DIPC package, try and avoid reusing it */
+#define DIPC            25
+
+#define IPCCALL(version,op)	((version)<<16 | (op))
+
 #ifdef __KERNEL__
 
 #include <linux/kref.h>
e394a2ff7bcd6ec268eb587518740d3de30f6487 
diff --git a/arch/x86_64/ia32/ipc32.c b/arch/x86_64/ia32/ipc32.c
index 369151d..7b3342e 100644
--- a/arch/x86_64/ia32/ipc32.c
+++ b/arch/x86_64/ia32/ipc32.c
@@ -9,8 +9,6 @@
 #include <linux/ipc.h>
 #include <linux/compat.h>
 
-#include <asm-i386/ipc.h>
-
 asmlinkage long
 sys32_ipc(u32 call, int first, int second, int third,
 		compat_uptr_t ptr, u32 fifth)

