Return-Path: <linux-kernel-owner+w=401wt.eu-S1757057AbYGTJMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057AbYGTJMs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 05:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755541AbYGTJMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 05:12:03 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35116 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757057AbYGTJLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 05:11:54 -0400
Subject: [PATCH] Introducing asm/syscalls.h
From: Jaswinder Singh <jaswinder@infradead.org>
To: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       David Woodhouse <dwmw2@infradead.org>, rth@twiddle.net,
       rmk@arm.linux.org.uk, hskinnemoen@atmel.com, cooloney@kernel.org,
       starvik@axis.com, dhowells@redhat.com, ysato@users.sourceforge.jp,
       tony.luck@intel.com, takata@linux-m32r.org, geert@linux-m68k.org,
       ralf@linux-mips.org, dhowells@redhat.com, matthew@wil.cx,
       schwidefsky@de.ibm.com, lethal@linux-sh.org, chris@zankel.net
Content-Type: text/plain
Date: Sun, 20 Jul 2008 14:39:00 +0530
Message-Id: <1216544940.12650.13.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Declaring arch-dependent syscalls for all architectures
Beneficial for kernel and userspace

Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
---
 arch/alpha/kernel/signal.c        |    1 +
 arch/arm/kernel/signal.c          |    1 +
 arch/arm/kernel/sys_oabi-compat.c |    3 -
 arch/avr32/kernel/process.c       |    1 +
 arch/avr32/kernel/signal.c        |    1 +
 arch/avr32/kernel/sys_avr32.c     |    1 +
 arch/avr32/mm/cache.c             |    1 +
 arch/blackfin/kernel/process.c    |    1 +
 arch/frv/kernel/process.c         |    1 +
 arch/frv/kernel/signal.c          |    1 +
 arch/h8300/kernel/process.c       |    1 +
 arch/ia64/kernel/process.c        |    1 +
 arch/ia64/kernel/signal.c         |    1 +
 arch/m32r/kernel/process.c        |    1 +
 arch/m32r/kernel/signal.c         |    1 +
 arch/m68k/kernel/process.c        |    1 +
 arch/m68knommu/kernel/process.c   |    1 +
 arch/mips/kernel/linux32.c        |    1 -
 arch/mips/kernel/signal.c         |    2 +-
 arch/mips/kernel/signal32.c       |    1 -
 arch/mips/kernel/syscall.c        |    1 -
 arch/mn10300/kernel/process.c     |    1 +
 arch/mn10300/kernel/signal.c      |    1 +
 arch/parisc/kernel/process.c      |    1 +
 arch/parisc/kernel/signal.c       |    1 +
 arch/s390/kernel/entry.h          |   18 --------
 arch/s390/kernel/process.c        |    1 +
 arch/s390/kernel/signal.c         |    1 +
 arch/s390/mm/fault.c              |    1 +
 arch/sh/kernel/process_32.c       |    1 +
 arch/sh/kernel/process_64.c       |    1 +
 arch/sh/kernel/signal_32.c        |    1 +
 arch/sh/kernel/signal_64.c        |    1 +
 arch/sparc/kernel/signal.c        |    1 +
 arch/um/kernel/exec.c             |    1 +
 arch/um/kernel/signal.c           |    3 +-
 arch/um/kernel/syscall.c          |    1 +
 arch/v850/kernel/process.c        |    1 +
 arch/v850/kernel/signal.c         |    1 +
 arch/x86/kernel/ldt.c             |    1 +
 arch/x86/kernel/process_32.c      |    1 +
 arch/x86/kernel/process_64.c      |    1 +
 arch/x86/kernel/signal_32.c       |    1 +
 arch/x86/kernel/signal_64.c       |    1 +
 arch/x86/kernel/tls.c             |    1 +
 arch/x86/kernel/vm86_32.c         |    1 +
 include/asm-alpha/syscalls.h      |   21 +++++++++
 include/asm-arm/syscalls.h        |   73 ++++++++++++++++++++++++++++++
 include/asm-avr32/syscalls.h      |   36 +++++++++++++++
 include/asm-blackfin/syscalls.h   |   29 ++++++++++++
 include/asm-cris/syscalls.h       |   21 +++++++++
 include/asm-frv/syscalls.h        |   37 +++++++++++++++
 include/asm-h8300/syscalls.h      |   33 ++++++++++++++
 include/asm-ia64/syscalls.h       |   38 ++++++++++++++++
 include/asm-ia64/unistd.h         |   14 +-----
 include/asm-m32r/syscalls.h       |   49 ++++++++++++++++++++
 include/asm-m68k/syscalls.h       |   35 +++++++++++++++
 include/asm-m68knommu/syscalls.h  |   34 ++++++++++++++
 include/asm-mips/syscalls.h       |   51 +++++++++++++++++++++
 include/asm-mn10300/syscalls.h    |   41 +++++++++++++++++
 include/asm-parisc/syscalls.h     |   36 +++++++++++++++
 include/asm-s390/syscalls.h       |   38 ++++++++++++++++
 include/asm-sh/syscalls.h         |   88 +++++++++++++++++++++++++++++++++++++
 include/asm-sparc/syscalls.h      |   30 +++++++++++++
 include/asm-um/syscalls.h         |   32 +++++++++++++
 include/asm-v850/syscalls.h       |   34 ++++++++++++++
 include/asm-x86/syscalls.h        |   83 ++++++++++++++++++++++++++++++++++
 include/asm-xtensa/syscalls.h     |   17 +++++++
 include/linux/syscalls.h          |    4 ++
 69 files changed, 902 insertions(+), 40 deletions(-)
 create mode 100644 include/asm-alpha/syscalls.h
 create mode 100644 include/asm-arm/syscalls.h
 create mode 100644 include/asm-avr32/syscalls.h
 create mode 100644 include/asm-blackfin/syscalls.h
 create mode 100644 include/asm-cris/syscalls.h
 create mode 100644 include/asm-frv/syscalls.h
 create mode 100644 include/asm-h8300/syscalls.h
 create mode 100644 include/asm-ia64/syscalls.h
 create mode 100644 include/asm-m32r/syscalls.h
 create mode 100644 include/asm-m68k/syscalls.h
 create mode 100644 include/asm-m68knommu/syscalls.h
 create mode 100644 include/asm-mips/syscalls.h
 create mode 100644 include/asm-mn10300/syscalls.h
 create mode 100644 include/asm-parisc/syscalls.h
 create mode 100644 include/asm-s390/syscalls.h
 create mode 100644 include/asm-sh/syscalls.h
 create mode 100644 include/asm-sparc/syscalls.h
 create mode 100644 include/asm-um/syscalls.h
 create mode 100644 include/asm-v850/syscalls.h
 create mode 100644 include/asm-x86/syscalls.h
 create mode 100644 include/asm-xtensa/syscalls.h

diff --git a/arch/alpha/kernel/signal.c b/arch/alpha/kernel/signal.c
index 410af4f..3cf9971 100644
--- a/arch/alpha/kernel/signal.c
+++ b/arch/alpha/kernel/signal.c
@@ -19,6 +19,7 @@
 #include <linux/tty.h>
 #include <linux/binfmts.h>
 #include <linux/bitops.h>
+#include <linux/syscalls.h>
 
 #include <asm/uaccess.h>
 #include <asm/sigcontext.h>
diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
index ef2f86a..64e23ed 100644
--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -11,6 +11,7 @@
 #include <linux/signal.h>
 #include <linux/personality.h>
 #include <linux/freezer.h>
+#include <linux/syscalls.h>
 
 #include <asm/elf.h>
 #include <asm/cacheflush.h>
diff --git a/arch/arm/kernel/sys_oabi-compat.c b/arch/arm/kernel/sys_oabi-compat.c
index 96ab5f5..a1e6fa4 100644
--- a/arch/arm/kernel/sys_oabi-compat.c
+++ b/arch/arm/kernel/sys_oabi-compat.c
@@ -354,9 +354,6 @@ asmlinkage long sys_oabi_semop(int semid, struct oabi_sembuf __user *tsops,
 	return sys_oabi_semtimedop(semid, tsops, nsops, NULL);
 }
 
-extern asmlinkage int sys_ipc(uint call, int first, int second, int third,
-			      void __user *ptr, long fifth);
-
 asmlinkage int sys_oabi_ipc(uint call, int first, int second, int third,
 			    void __user *ptr, long fifth)
 {
diff --git a/arch/avr32/kernel/process.c b/arch/avr32/kernel/process.c
index 6cf9df1..ee57d4c 100644
--- a/arch/avr32/kernel/process.c
+++ b/arch/avr32/kernel/process.c
@@ -14,6 +14,7 @@
 #include <linux/tick.h>
 #include <linux/uaccess.h>
 #include <linux/unistd.h>
+#include <linux/syscalls.h>
 
 #include <asm/sysreg.h>
 #include <asm/ocd.h>
diff --git a/arch/avr32/kernel/signal.c b/arch/avr32/kernel/signal.c
index c5b11f9..90ba201 100644
--- a/arch/avr32/kernel/signal.c
+++ b/arch/avr32/kernel/signal.c
@@ -16,6 +16,7 @@
 #include <linux/ptrace.h>
 #include <linux/unistd.h>
 #include <linux/freezer.h>
+#include <linux/syscalls.h>
 
 #include <asm/uaccess.h>
 #include <asm/ucontext.h>
diff --git a/arch/avr32/kernel/sys_avr32.c b/arch/avr32/kernel/sys_avr32.c
index 8e8911e..4c0a167 100644
--- a/arch/avr32/kernel/sys_avr32.c
+++ b/arch/avr32/kernel/sys_avr32.c
@@ -10,6 +10,7 @@
 #include <linux/file.h>
 #include <linux/mm.h>
 #include <linux/unistd.h>
+#include <linux/syscalls.h>
 
 #include <asm/mman.h>
 #include <asm/uaccess.h>
diff --git a/arch/avr32/mm/cache.c b/arch/avr32/mm/cache.c
index 15a4e5e..2faf302 100644
--- a/arch/avr32/mm/cache.c
+++ b/arch/avr32/mm/cache.c
@@ -8,6 +8,7 @@
 
 #include <linux/highmem.h>
 #include <linux/unistd.h>
+#include <linux/syscalls.h>
 
 #include <asm/cacheflush.h>
 #include <asm/cachectl.h>
diff --git a/arch/blackfin/kernel/process.c b/arch/blackfin/kernel/process.c
index 53c2cd2..6ca088c 100644
--- a/arch/blackfin/kernel/process.c
+++ b/arch/blackfin/kernel/process.c
@@ -36,6 +36,7 @@
 #include <linux/tick.h>
 #include <linux/fs.h>
 #include <linux/err.h>
+#include <linux/syscalls.h>
 
 #include <asm/blackfin.h>
 #include <asm/fixed_code.h>
diff --git a/arch/frv/kernel/process.c b/arch/frv/kernel/process.c
index 9583a33..09b3c13 100644
--- a/arch/frv/kernel/process.c
+++ b/arch/frv/kernel/process.c
@@ -26,6 +26,7 @@
 #include <linux/reboot.h>
 #include <linux/interrupt.h>
 #include <linux/pagemap.h>
+#include <linux/syscalls.h>
 
 #include <asm/asm-offsets.h>
 #include <asm/uaccess.h>
diff --git a/arch/frv/kernel/signal.c b/arch/frv/kernel/signal.c
index 3bdb368..5d024fe 100644
--- a/arch/frv/kernel/signal.c
+++ b/arch/frv/kernel/signal.c
@@ -21,6 +21,7 @@
 #include <linux/unistd.h>
 #include <linux/personality.h>
 #include <linux/freezer.h>
+#include <linux/syscalls.h>
 #include <asm/ucontext.h>
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
diff --git a/arch/h8300/kernel/process.c b/arch/h8300/kernel/process.c
index dfbe7ab..3529387 100644
--- a/arch/h8300/kernel/process.c
+++ b/arch/h8300/kernel/process.c
@@ -38,6 +38,7 @@
 #include <linux/interrupt.h>
 #include <linux/reboot.h>
 #include <linux/fs.h>
+#include <linux/syscalls.h>
 
 #include <asm/uaccess.h>
 #include <asm/system.h>
diff --git a/arch/ia64/kernel/process.c b/arch/ia64/kernel/process.c
index 3ab8373..3b668a9 100644
--- a/arch/ia64/kernel/process.c
+++ b/arch/ia64/kernel/process.c
@@ -28,6 +28,7 @@
 #include <linux/delay.h>
 #include <linux/kdebug.h>
 #include <linux/utsname.h>
+#include <linux/syscalls.h>
 
 #include <asm/cpu.h>
 #include <asm/delay.h>
diff --git a/arch/ia64/kernel/signal.c b/arch/ia64/kernel/signal.c
index 19c5a78..7b249da 100644
--- a/arch/ia64/kernel/signal.c
+++ b/arch/ia64/kernel/signal.c
@@ -19,6 +19,7 @@
 #include <linux/binfmts.h>
 #include <linux/unistd.h>
 #include <linux/wait.h>
+#include <linux/syscalls.h>
 
 #include <asm/ia32.h>
 #include <asm/intrinsics.h>
diff --git a/arch/m32r/kernel/process.c b/arch/m32r/kernel/process.c
index a689e29..9f5335c 100644
--- a/arch/m32r/kernel/process.c
+++ b/arch/m32r/kernel/process.c
@@ -26,6 +26,7 @@
 #include <linux/unistd.h>
 #include <linux/slab.h>
 #include <linux/hardirq.h>
+#include <linux/syscalls.h>
 
 #include <asm/io.h>
 #include <asm/uaccess.h>
diff --git a/arch/m32r/kernel/signal.c b/arch/m32r/kernel/signal.c
index 1812454..4478893 100644
--- a/arch/m32r/kernel/signal.c
+++ b/arch/m32r/kernel/signal.c
@@ -21,6 +21,7 @@
 #include <linux/stddef.h>
 #include <linux/personality.h>
 #include <linux/freezer.h>
+#include <linux/syscalls.h>
 #include <asm/cacheflush.h>
 #include <asm/ucontext.h>
 #include <asm/uaccess.h>
diff --git a/arch/m68k/kernel/process.c b/arch/m68k/kernel/process.c
index 7888cdf..41aa0c3 100644
--- a/arch/m68k/kernel/process.c
+++ b/arch/m68k/kernel/process.c
@@ -26,6 +26,7 @@
 #include <linux/reboot.h>
 #include <linux/init_task.h>
 #include <linux/mqueue.h>
+#include <linux/syscalls.h>
 
 #include <asm/uaccess.h>
 #include <asm/system.h>
diff --git a/arch/m68knommu/kernel/process.c b/arch/m68knommu/kernel/process.c
index 47502d5..30dea18 100644
--- a/arch/m68knommu/kernel/process.c
+++ b/arch/m68knommu/kernel/process.c
@@ -29,6 +29,7 @@
 #include <linux/interrupt.h>
 #include <linux/reboot.h>
 #include <linux/fs.h>
+#include <linux/syscalls.h>
 
 #include <asm/uaccess.h>
 #include <asm/system.h>
diff --git a/arch/mips/kernel/linux32.c b/arch/mips/kernel/linux32.c
index 65af3cc..710e4dc 100644
--- a/arch/mips/kernel/linux32.c
+++ b/arch/mips/kernel/linux32.c
@@ -41,7 +41,6 @@
 #include <net/scm.h>
 
 #include <asm/compat-signal.h>
-#include <asm/sim.h>
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
 #include <asm/mman.h>
diff --git a/arch/mips/kernel/signal.c b/arch/mips/kernel/signal.c
index a4e106c..2bc1a37 100644
--- a/arch/mips/kernel/signal.c
+++ b/arch/mips/kernel/signal.c
@@ -20,13 +20,13 @@
 #include <linux/unistd.h>
 #include <linux/compiler.h>
 #include <linux/uaccess.h>
+#include <linux/syscalls.h>
 
 #include <asm/abi.h>
 #include <asm/asm.h>
 #include <linux/bitops.h>
 #include <asm/cacheflush.h>
 #include <asm/fpu.h>
-#include <asm/sim.h>
 #include <asm/ucontext.h>
 #include <asm/cpu-features.h>
 #include <asm/war.h>
diff --git a/arch/mips/kernel/signal32.c b/arch/mips/kernel/signal32.c
index 572c610..c1b32e9 100644
--- a/arch/mips/kernel/signal32.c
+++ b/arch/mips/kernel/signal32.c
@@ -27,7 +27,6 @@
 #include <asm/compat-signal.h>
 #include <linux/bitops.h>
 #include <asm/cacheflush.h>
-#include <asm/sim.h>
 #include <asm/ucontext.h>
 #include <asm/system.h>
 #include <asm/fpu.h>
diff --git a/arch/mips/kernel/syscall.c b/arch/mips/kernel/syscall.c
index af1bdc8..3505210 100644
--- a/arch/mips/kernel/syscall.c
+++ b/arch/mips/kernel/syscall.c
@@ -35,7 +35,6 @@
 #include <asm/cacheflush.h>
 #include <asm/asm-offsets.h>
 #include <asm/signal.h>
-#include <asm/sim.h>
 #include <asm/shmparam.h>
 #include <asm/sysmips.h>
 #include <asm/uaccess.h>
diff --git a/arch/mn10300/kernel/process.c b/arch/mn10300/kernel/process.c
index b28c9a6..49a05f9 100644
--- a/arch/mn10300/kernel/process.c
+++ b/arch/mn10300/kernel/process.c
@@ -26,6 +26,7 @@
 #include <linux/percpu.h>
 #include <linux/err.h>
 #include <linux/fs.h>
+#include <linux/syscalls.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 #include <asm/system.h>
diff --git a/arch/mn10300/kernel/signal.c b/arch/mn10300/kernel/signal.c
index 841ca99..bf37ccc 100644
--- a/arch/mn10300/kernel/signal.c
+++ b/arch/mn10300/kernel/signal.c
@@ -23,6 +23,7 @@
 #include <linux/tty.h>
 #include <linux/personality.h>
 #include <linux/suspend.h>
+#include <linux/syscalls.h>
 #include <asm/cacheflush.h>
 #include <asm/ucontext.h>
 #include <asm/uaccess.h>
diff --git a/arch/parisc/kernel/process.c b/arch/parisc/kernel/process.c
index b80e02a..9a73fcd 100644
--- a/arch/parisc/kernel/process.c
+++ b/arch/parisc/kernel/process.c
@@ -46,6 +46,7 @@
 #include <linux/stddef.h>
 #include <linux/unistd.h>
 #include <linux/kallsyms.h>
+#include <linux/syscalls.h>
 
 #include <asm/io.h>
 #include <asm/asm-offsets.h>
diff --git a/arch/parisc/kernel/signal.c b/arch/parisc/kernel/signal.c
index 06213d1..b10cade 100644
--- a/arch/parisc/kernel/signal.c
+++ b/arch/parisc/kernel/signal.c
@@ -25,6 +25,7 @@
 #include <linux/stddef.h>
 #include <linux/compat.h>
 #include <linux/elf.h>
+#include <linux/syscalls.h>
 #include <asm/ucontext.h>
 #include <asm/rt_sigframe.h>
 #include <asm/uaccess.h>
diff --git a/arch/s390/kernel/entry.h b/arch/s390/kernel/entry.h
index 6b18963..c8b5dfd 100644
--- a/arch/s390/kernel/entry.h
+++ b/arch/s390/kernel/entry.h
@@ -25,36 +25,18 @@ void __init startup_init(void);
 void die(const char * str, struct pt_regs * regs, long err);
 
 struct new_utsname;
-struct mmap_arg_struct;
 struct fadvise64_64_args;
-struct old_sigaction;
-struct sel_arg_struct;
 
 long sys_pipe(unsigned long __user *fildes);
-long sys_mmap2(struct mmap_arg_struct __user  *arg);
-long old_mmap(struct mmap_arg_struct __user *arg);
-long sys_ipc(uint call, int first, unsigned long second,
-	     unsigned long third, void __user *ptr);
 long s390x_newuname(struct new_utsname __user *name);
 long s390x_personality(unsigned long personality);
 long s390_fadvise64(int fd, u32 offset_high, u32 offset_low,
 		    size_t len, int advice);
 long s390_fadvise64_64(struct fadvise64_64_args __user *args);
 long s390_fallocate(int fd, int mode, loff_t offset, u32 len_high, u32 len_low);
-long sys_fork(void);
-long sys_clone(void);
-long sys_vfork(void);
 void execve_tail(void);
-long sys_execve(void);
-int sys_sigsuspend(int history0, int history1, old_sigset_t mask);
-long sys_sigaction(int sig, const struct old_sigaction __user *act,
-		   struct old_sigaction __user *oact);
-long sys_sigaltstack(const stack_t __user *uss, stack_t __user *uoss);
-long sys_sigreturn(void);
-long sys_rt_sigreturn(void);
 long sys32_sigreturn(void);
 long sys32_rt_sigreturn(void);
-long old_select(struct sel_arg_struct __user *arg);
 long sys_ptrace(long request, long pid, long addr, long data);
 
 #endif /* _ENTRY_H */
diff --git a/arch/s390/kernel/process.c b/arch/s390/kernel/process.c
index 85defd0..5f6d7a8 100644
--- a/arch/s390/kernel/process.c
+++ b/arch/s390/kernel/process.c
@@ -38,6 +38,7 @@
 #include <linux/utsname.h>
 #include <linux/tick.h>
 #include <linux/elfcore.h>
+#include <linux/syscalls.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 #include <asm/system.h>
diff --git a/arch/s390/kernel/signal.c b/arch/s390/kernel/signal.c
index b976820..c73b369 100644
--- a/arch/s390/kernel/signal.c
+++ b/arch/s390/kernel/signal.c
@@ -24,6 +24,7 @@
 #include <linux/tty.h>
 #include <linux/personality.h>
 #include <linux/binfmts.h>
+#include <linux/syscalls.h>
 #include <asm/ucontext.h>
 #include <asm/uaccess.h>
 #include <asm/lowcore.h>
diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index 4d53720..a5c5f66 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -29,6 +29,7 @@
 #include <linux/kprobes.h>
 #include <linux/uaccess.h>
 #include <linux/hugetlb.h>
+#include <linux/syscalls.h>
 #include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/s390_ext.h>
diff --git a/arch/sh/kernel/process_32.c b/arch/sh/kernel/process_32.c
index b98e37a..b6fb73e 100644
--- a/arch/sh/kernel/process_32.c
+++ b/arch/sh/kernel/process_32.c
@@ -20,6 +20,7 @@
 #include <linux/reboot.h>
 #include <linux/fs.h>
 #include <linux/preempt.h>
+#include <linux/syscalls.h>
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
 #include <asm/pgalloc.h>
diff --git a/arch/sh/kernel/process_64.c b/arch/sh/kernel/process_64.c
index 0283d81..f0b249f 100644
--- a/arch/sh/kernel/process_64.c
+++ b/arch/sh/kernel/process_64.c
@@ -25,6 +25,7 @@
 #include <linux/module.h>
 #include <linux/proc_fs.h>
 #include <linux/io.h>
+#include <linux/syscalls.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 #include <asm/mmu_context.h>
diff --git a/arch/sh/kernel/signal_32.c b/arch/sh/kernel/signal_32.c
index f311551..852c81b 100644
--- a/arch/sh/kernel/signal_32.c
+++ b/arch/sh/kernel/signal_32.c
@@ -24,6 +24,7 @@
 #include <linux/binfmts.h>
 #include <linux/freezer.h>
 #include <linux/io.h>
+#include <linux/syscalls.h>
 #include <asm/system.h>
 #include <asm/ucontext.h>
 #include <asm/uaccess.h>
diff --git a/arch/sh/kernel/signal_64.c b/arch/sh/kernel/signal_64.c
index 552eb81..b2be648 100644
--- a/arch/sh/kernel/signal_64.c
+++ b/arch/sh/kernel/signal_64.c
@@ -22,6 +22,7 @@
 #include <linux/ptrace.h>
 #include <linux/unistd.h>
 #include <linux/stddef.h>
+#include <linux/syscalls.h>
 #include <asm/ucontext.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
diff --git a/arch/sparc/kernel/signal.c b/arch/sparc/kernel/signal.c
index 3fd1df9..6fe2da5 100644
--- a/arch/sparc/kernel/signal.c
+++ b/arch/sparc/kernel/signal.c
@@ -18,6 +18,7 @@
 #include <linux/smp.h>
 #include <linux/binfmts.h>	/* do_coredum */
 #include <linux/bitops.h>
+#include <linux/syscalls.h>
 
 #include <asm/uaccess.h>
 #include <asm/ptrace.h>
diff --git a/arch/um/kernel/exec.c b/arch/um/kernel/exec.c
index f5d7f45..cd9fa46 100644
--- a/arch/um/kernel/exec.c
+++ b/arch/um/kernel/exec.c
@@ -8,6 +8,7 @@
 #include "linux/smp_lock.h"
 #include "linux/ptrace.h"
 #include "linux/sched.h"
+#include "linux/syscalls.h"
 #include "asm/current.h"
 #include "asm/processor.h"
 #include "asm/uaccess.h"
diff --git a/arch/um/kernel/signal.c b/arch/um/kernel/signal.c
index b0fce72..9a72afc 100644
--- a/arch/um/kernel/signal.c
+++ b/arch/um/kernel/signal.c
@@ -6,8 +6,7 @@
 #include <linux/module.h>
 #include <linux/ptrace.h>
 #include <linux/sched.h>
-#include <asm/siginfo.h>
-#include <asm/signal.h>
+#include <linux/syscalls.h>
 #include <asm/unistd.h>
 #include "frame_kern.h"
 #include "kern_util.h"
diff --git a/arch/um/kernel/syscall.c b/arch/um/kernel/syscall.c
index 128ee85..0c35194 100644
--- a/arch/um/kernel/syscall.c
+++ b/arch/um/kernel/syscall.c
@@ -8,6 +8,7 @@
 #include "linux/mm.h"
 #include "linux/sched.h"
 #include "linux/utsname.h"
+#include "linux/syscalls.h"
 #include "asm/current.h"
 #include "asm/mman.h"
 #include "asm/uaccess.h"
diff --git a/arch/v850/kernel/process.c b/arch/v850/kernel/process.c
index e4a4b8e..4ea0783 100644
--- a/arch/v850/kernel/process.c
+++ b/arch/v850/kernel/process.c
@@ -23,6 +23,7 @@
 #include <linux/user.h>
 #include <linux/a.out.h>
 #include <linux/reboot.h>
+#include <linux/syscalls.h>
 
 #include <asm/uaccess.h>
 #include <asm/system.h>
diff --git a/arch/v850/kernel/signal.c b/arch/v850/kernel/signal.c
index bf166e7..603c13e 100644
--- a/arch/v850/kernel/signal.c
+++ b/arch/v850/kernel/signal.c
@@ -26,6 +26,7 @@
 #include <linux/stddef.h>
 #include <linux/personality.h>
 #include <linux/tty.h>
+#include <linux/syscalls.h>
 
 #include <asm/ucontext.h>
 #include <asm/uaccess.h>
diff --git a/arch/x86/kernel/ldt.c b/arch/x86/kernel/ldt.c
index a844957..047a021 100644
--- a/arch/x86/kernel/ldt.c
+++ b/arch/x86/kernel/ldt.c
@@ -12,6 +12,7 @@
 #include <linux/mm.h>
 #include <linux/smp.h>
 #include <linux/vmalloc.h>
+#include <linux/syscalls.h>
 
 #include <asm/uaccess.h>
 #include <asm/system.h>
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 0c3927a..8e46d82 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -37,6 +37,7 @@
 #include <linux/tick.h>
 #include <linux/percpu.h>
 #include <linux/prctl.h>
+#include <linux/syscalls.h>
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index a8e5362..f99381b 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -37,6 +37,7 @@
 #include <linux/kdebug.h>
 #include <linux/tick.h>
 #include <linux/prctl.h>
+#include <linux/syscalls.h>
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index d923736..954a3b8 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -20,6 +20,7 @@
 #include <linux/elf.h>
 #include <linux/smp.h>
 #include <linux/mm.h>
+#include <linux/syscalls.h>
 
 #include <asm/processor.h>
 #include <asm/ucontext.h>
diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index e53b267..12c0ab5 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -19,6 +19,7 @@
 #include <linux/stddef.h>
 #include <linux/personality.h>
 #include <linux/compiler.h>
+#include <linux/syscalls.h>
 #include <asm/processor.h>
 #include <asm/ucontext.h>
 #include <asm/uaccess.h>
diff --git a/arch/x86/kernel/tls.c b/arch/x86/kernel/tls.c
index ab6bf37..90bc24c 100644
--- a/arch/x86/kernel/tls.c
+++ b/arch/x86/kernel/tls.c
@@ -3,6 +3,7 @@
 #include <linux/sched.h>
 #include <linux/user.h>
 #include <linux/regset.h>
+#include <linux/syscalls.h>
 
 #include <asm/uaccess.h>
 #include <asm/desc.h>
diff --git a/arch/x86/kernel/vm86_32.c b/arch/x86/kernel/vm86_32.c
index 38f566f..d77e312 100644
--- a/arch/x86/kernel/vm86_32.c
+++ b/arch/x86/kernel/vm86_32.c
@@ -41,6 +41,7 @@
 #include <linux/ptrace.h>
 #include <linux/audit.h>
 #include <linux/stddef.h>
+#include <linux/syscalls.h>
 
 #include <asm/uaccess.h>
 #include <asm/io.h>
diff --git a/include/asm-alpha/syscalls.h b/include/asm-alpha/syscalls.h
new file mode 100644
index 0000000..eec7dc5
--- /dev/null
+++ b/include/asm-alpha/syscalls.h
@@ -0,0 +1,21 @@
+/*
+ * syscalls.h - Linux syscall interfaces (arch-specific)
+ *
+ * Copyright (c) 2008 Jaswinder Singh
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ *
+ * Please do not call me directly, include linux/syscalls.h
+ */
+
+#ifndef _ASM_APLHA_SYSCALLS_H
+#define _ASM_APLHA_SYSCALLS_H
+
+/* kernel/signal.c */
+asmlinkage long sys_rt_sigaction(int, const struct sigaction __user *,
+				 struct sigaction __user *, size_t,
+				 void __user *restorer);
+asmlinkage int sys_sigaltstack(const stack_t __user *, stack_t __user *);
+
+#endif /* _ASM_APLHA_SYSCALLS_H */
diff --git a/include/asm-arm/syscalls.h b/include/asm-arm/syscalls.h
new file mode 100644
index 0000000..1a97a82
--- /dev/null
+++ b/include/asm-arm/syscalls.h
@@ -0,0 +1,73 @@
+/*
+ * syscalls.h - Linux syscall interfaces (arch-specific)
+ *
+ * Copyright (c) 2008 Jaswinder Singh
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ *
+ * Please do not call me directly, include linux/syscalls.h
+ */
+
+#ifndef _ASM_ARM_SYSCALLS_H
+#define _ASM_ARM_SYSCALLS_H
+
+/* kernel/signal.c */
+asmlinkage int sys_sigsuspend(int, unsigned long, old_sigset_t,
+			      struct pt_regs *);
+asmlinkage int sys_rt_sigsuspend(sigset_t __user *, size_t,
+				 struct pt_regs *);
+asmlinkage int sys_sigaction(int, const struct old_sigaction __user *,
+			     struct old_sigaction __user *);
+asmlinkage int sys_sigreturn(struct pt_regs *);
+asmlinkage int sys_rt_sigreturn(struct pt_regs *);
+
+/* kernel/sys_arm.c */
+struct mmap_arg_struct;
+asmlinkage int old_mmap(struct mmap_arg_struct __user *);
+asmlinkage unsigned long sys_arm_mremap(unsigned long, unsigned long,
+					unsigned long, unsigned long,
+					unsigned long);
+
+struct sel_arg_struct;
+asmlinkage int old_select(struct sel_arg_struct __user *);
+#if !defined(CONFIG_AEABI) || defined(CONFIG_OABI_COMPAT)
+asmlinkage int sys_ipc(uint, int, int, int, void __user *, long);
+#endif
+asmlinkage int sys_fork(struct pt_regs *);
+asmlinkage int sys_clone(unsigned long, unsigned long, int __user *,
+			 int, int __user *, struct pt_regs *);
+asmlinkage int sys_vfork(struct pt_regs *);
+asmlinkage int sys_execve(char __user *, char __user * __user *,
+			  char __user * __user *, struct pt_regs *);
+asmlinkage long sys_arm_fadvise64_64(int, int, loff_t, loff_t);
+
+#if defined(CONFIG_OABI_COMPAT)
+/* kernel/sys_oabi-compat.c */
+struct oldabi_stat64;
+asmlinkage long sys_oabi_stat64(char __user *, struct oldabi_stat64 __user *);
+asmlinkage long sys_oabi_lstat64(char __user *, struct oldabi_stat64 __user *);
+asmlinkage long sys_oabi_fstat64(unsigned long, struct oldabi_stat64 __user *);
+asmlinkage long sys_oabi_fstatat64(int, char __user *,
+				   struct oldabi_stat64  __user *, int);
+asmlinkage long sys_oabi_fcntl64(unsigned int, unsigned int, unsigned long);
+struct oabi_epoll_event;
+asmlinkage long sys_oabi_epoll_ctl(int, int, int,
+				   struct oabi_epoll_event __user *);
+asmlinkage long sys_oabi_epoll_wait(int, struct oabi_epoll_event __user *,
+				    int, int);
+struct oabi_sembuf;
+asmlinkage long sys_oabi_semtimedop(int, struct oabi_sembuf __user *,
+				    unsigned, const struct timespec __user *);
+asmlinkage long sys_oabi_semop(int, struct oabi_sembuf __user *, unsigned);
+asmlinkage int sys_oabi_ipc(uint, int, int, int, void __user *, long);
+asmlinkage long sys_oabi_bind(int, struct sockaddr __user *, int);
+asmlinkage long sys_oabi_connect(int, struct sockaddr __user *, int);
+asmlinkage long sys_oabi_sendto(int, void __user *, size_t,
+				unsigned, struct sockaddr __user *, int);
+asmlinkage long sys_oabi_sendmsg(int, struct msghdr __user *, unsigned);
+asmlinkage long sys_oabi_socketcall(int, unsigned long __user *);
+
+#endif
+
+#endif /* _ASM_ARM_SYSCALLS_H */
diff --git a/include/asm-avr32/syscalls.h b/include/asm-avr32/syscalls.h
new file mode 100644
index 0000000..727c58c
--- /dev/null
+++ b/include/asm-avr32/syscalls.h
@@ -0,0 +1,36 @@
+/*
+ * syscalls.h - Linux syscall interfaces (arch-specific)
+ *
+ * Copyright (c) 2008 Jaswinder Singh
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ *
+ * Please do not call me directly, include linux/syscalls.h
+ */
+
+#ifndef _ASM_AVR32_SYSCALLS_H
+#define _ASM_AVR32_SYSCALLS_H
+
+/* kernel/process.c */
+asmlinkage int sys_fork(struct pt_regs);
+asmlinkage int sys_clone(unsigned long, unsigned long,
+			 unsigned long, unsigned long,
+			 struct pt_regs *);
+asmlinkage int sys_vfork(struct pt_regs);
+asmlinkage int sys_execve(char __user *, char __user *__user *,
+			  char __user *__user *, struct pt_regs *);
+
+/* kernel/signal.c */
+asmlinkage int sys_sigaltstack(const stack_t __user *, stack_t __user *,
+			       struct pt_regs *);
+asmlinkage int sys_rt_sigreturn(struct pt_regs *);
+
+/* kernel/sys_avr32.c */
+asmlinkage long sys_mmap2(unsigned long, unsigned long, unsigned long,
+			  unsigned long, unsigned long, off_t);
+
+/* mm/cache.c */
+asmlinkage int sys_cacheflush(int, void __user *, size_t);
+
+#endif /* _ASM_AVR32_SYSCALLS_H */
diff --git a/include/asm-blackfin/syscalls.h b/include/asm-blackfin/syscalls.h
new file mode 100644
index 0000000..73927f5
--- /dev/null
+++ b/include/asm-blackfin/syscalls.h
@@ -0,0 +1,29 @@
+/*
+ * syscalls.h - Linux syscall interfaces (arch-specific)
+ *
+ * Copyright (c) 2008 Jaswinder Singh
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ *
+ * Please do not call me directly, include linux/syscalls.h
+ */
+
+#ifndef _ASM_BLACKFIN_SYSCALLS_H
+#define _ASM_BLACKFIN_SYSCALLS_H
+
+/* kernel/process.c */
+asmlinkage int sys_execve(char __user *, char __user * __user *,
+			  char __user * __user *);
+
+/* kernel/signal.c */
+asmlinkage int sys_sigaltstack(const stack_t __user *, stack_t __user *);
+
+/* kernel/sys_bfin.c */
+asmlinkage long sys_mmap2(unsigned long, unsigned long, unsigned long,
+			  unsigned long, unsigned long, unsigned long);
+asmlinkage void *sys_sram_alloc(size_t, unsigned long);
+asmlinkage int sys_sram_free(const void *);
+asmlinkage void *sys_dma_memcpy(void *, const void *, size_t);
+
+#endif /* _ASM_BLACKFIN_SYSCALLS_H */
diff --git a/include/asm-cris/syscalls.h b/include/asm-cris/syscalls.h
new file mode 100644
index 0000000..711adad
--- /dev/null
+++ b/include/asm-cris/syscalls.h
@@ -0,0 +1,21 @@
+/*
+ * syscalls.h - Linux syscall interfaces (arch-specific)
+ *
+ * Copyright (c) 2008 Jaswinder Singh
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ *
+ * Please do not call me directly, include linux/syscalls.h
+ */
+
+#ifndef _ASM_CRIS_SYSCALLS_H
+#define _ASM_CRIS_SYSCALLS_H
+
+/* kernel/sys_cris.c */
+asmlinkage unsigned long old_mmap(unsigned long __user *);
+asmlinkage long sys_mmap2(unsigned long, unsigned long, unsigned long,
+			  unsigned long, unsigned long, unsigned long);
+asmlinkage int sys_ipc(uint, int, int, int, void __user *, long);
+
+#endif /* _ASM_CRIS_SYSCALLS_H */
diff --git a/include/asm-frv/syscalls.h b/include/asm-frv/syscalls.h
new file mode 100644
index 0000000..e2639f2
--- /dev/null
+++ b/include/asm-frv/syscalls.h
@@ -0,0 +1,37 @@
+/*
+ * syscalls.h - Linux syscall interfaces (arch-specific)
+ *
+ * Copyright (c) 2008 Jaswinder Singh
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ *
+ * Please do not call me directly, include linux/syscalls.h
+ */
+
+#ifndef _ASM_FRV_SYSCALLS_H
+#define _ASM_FRV_SYSCALLS_H
+
+/* kernel/process.c */
+asmlinkage int sys_fork(void);
+asmlinkage int sys_vfork(void);
+asmlinkage int sys_clone(unsigned long, unsigned long, int __user *,
+			 int __user *, int __user *);
+asmlinkage int sys_execve(char __user *, char __user * __user *,
+			  char __user * __user *);
+
+/* kernel/signal.c */
+asmlinkage int sys_sigsuspend(int, int, old_sigset_t);
+asmlinkage int sys_sigaction(int, const struct old_sigaction __user *,
+			     struct old_sigaction __user *);
+asmlinkage int sys_sigaltstack(const stack_t __user *, stack_t __user *);
+asmlinkage int sys_sigreturn(void);
+asmlinkage int sys_rt_sigreturn(void);
+
+/* kernel/sys_frv.c */
+asmlinkage long sys_mmap2(unsigned long, unsigned long, unsigned long,
+			  unsigned long, unsigned long, unsigned long);
+asmlinkage long sys_ipc(unsigned long, unsigned long, unsigned long,
+			unsigned long, void __user *, unsigned long);
+
+#endif /* _ASM_FRV_SYSCALLS_H */
diff --git a/include/asm-h8300/syscalls.h b/include/asm-h8300/syscalls.h
new file mode 100644
index 0000000..d021f52
--- /dev/null
+++ b/include/asm-h8300/syscalls.h
@@ -0,0 +1,33 @@
+/*
+ * syscalls.h - Linux syscall interfaces (arch-specific)
+ *
+ * Copyright (c) 2008 Jaswinder Singh
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ *
+ * Please do not call me directly, include linux/syscalls.h
+ */
+
+#ifndef _ASM_H8300_SYSCALLS_H
+#define _ASM_H8300_SYSCALLS_H
+
+/* kernel/process.c */
+asmlinkage int sys_execve(char *, char **, char **, int, ...);
+
+/* kernel/signal.c */
+asmlinkage int sys_sigaction(int, const struct old_sigaction *,
+			     struct old_sigaction *);
+asmlinkage int sys_sigaltstack(const stack_t *, stack_t *);
+
+/* kernel/sys_h8300.c */
+asmlinkage long sys_mmap2(unsigned long, unsigned long, unsigned long,
+			  unsigned long, unsigned long, unsigned long);
+struct mmap_arg_struct;
+asmlinkage int old_mmap(struct mmap_arg_struct *);
+struct sel_arg_struct;
+asmlinkage int old_select(struct sel_arg_struct *);
+asmlinkage int sys_ipc(uint, int, int, int, void *, long);
+asmlinkage int sys_cacheflush(unsigned long, int, int, unsigned long);
+
+#endif /* _ASM_H8300_SYSCALLS_H */
diff --git a/include/asm-ia64/syscalls.h b/include/asm-ia64/syscalls.h
new file mode 100644
index 0000000..71af530
--- /dev/null
+++ b/include/asm-ia64/syscalls.h
@@ -0,0 +1,38 @@
+/*
+ * syscalls.h - Linux syscall interfaces (arch-specific)
+ *
+ * Copyright (c) 2008 Jaswinder Singh
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ *
+ * Please do not call me directly, include linux/syscalls.h
+ */
+
+#ifndef _ASM_IA64_SYSCALLS_H
+#define _ASM_IA64_SYSCALLS_H
+
+/* kernel/process.c */
+long sys_execve(char __user *, char __user * __user *,
+		 char __user * __user *, struct pt_regs *);
+
+/* kernel/signal.c */
+asmlinkage long sys_sigaltstack(const stack_t __user *, stack_t __user *,
+				long, long, long, long, long, long,
+				struct pt_regs);
+
+/* kernel/sys_ia64.c */
+asmlinkage unsigned long sys_getpagesize(void);
+asmlinkage long sys_pipe(void);
+asmlinkage unsigned long sys_mmap2(unsigned long, unsigned long,
+				   int, int, int, long);
+asmlinkage unsigned long sys_mmap(unsigned long, unsigned long,
+				  int, int, int, long);
+#ifndef CONFIG_PCI
+asmlinkage long sys_pciconfig_read(unsigned long, unsigned long,
+				   unsigned long, unsigned long, void *);
+asmlinkage long sys_pciconfig_write(unsigned long, unsigned long,
+				    unsigned long, unsigned long, void *);
+#endif /* CONFIG_PCI */
+
+#endif /* _ASM_IA64_SYSCALLS_H */
diff --git a/include/asm-ia64/unistd.h b/include/asm-ia64/unistd.h
index e603147..6b0e8c6 100644
--- a/include/asm-ia64/unistd.h
+++ b/include/asm-ia64/unistd.h
@@ -342,22 +342,10 @@
 #include <linux/types.h>
 #include <linux/linkage.h>
 #include <linux/compiler.h>
+#include <linux/syscalls.h>
 
 extern long __ia64_syscall (long a0, long a1, long a2, long a3, long a4, long nr);
 
-asmlinkage unsigned long sys_mmap(
-				unsigned long addr, unsigned long len,
-				int prot, int flags,
-				int fd, long off);
-asmlinkage unsigned long sys_mmap2(
-				unsigned long addr, unsigned long len,
-				int prot, int flags,
-				int fd, long pgoff);
-struct pt_regs;
-struct sigaction;
-long sys_execve(char __user *filename, char __user * __user *argv,
-			   char __user * __user *envp, struct pt_regs *regs);
-asmlinkage long sys_pipe(void);
 asmlinkage long sys_rt_sigaction(int sig,
 				 const struct sigaction __user *act,
 				 struct sigaction __user *oact,
diff --git a/include/asm-m32r/syscalls.h b/include/asm-m32r/syscalls.h
new file mode 100644
index 0000000..78ccedb
--- /dev/null
+++ b/include/asm-m32r/syscalls.h
@@ -0,0 +1,49 @@
+/*
+ * syscalls.h - Linux syscall interfaces (arch-specific)
+ *
+ * Copyright (c) 2008 Jaswinder Singh
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ *
+ * Please do not call me directly, include linux/syscalls.h
+ */
+
+#ifndef _ASM_M32R_SYSCALLS_H
+#define _ASM_M32R_SYSCALLS_H
+
+/* kernel/process.c */
+asmlinkage int sys_fork(unsigned long, unsigned long, unsigned long,
+			unsigned long, unsigned long, unsigned long,
+			unsigned long, struct pt_regs);
+asmlinkage int sys_clone(unsigned long, unsigned long, unsigned long,
+			 unsigned long, unsigned long, unsigned long,
+			 unsigned long, struct pt_regs);
+asmlinkage int sys_vfork(unsigned long, unsigned long, unsigned long,
+			unsigned long, unsigned long, unsigned long,
+			unsigned long, struct pt_regs);
+asmlinkage int sys_execve(char __user *, char __user * __user *,
+			  char __user * __user *, unsigned long,
+			  unsigned long, unsigned long, unsigned long,
+			  struct pt_regs);
+
+/* kernel/signal.c */
+asmlinkage int sys_rt_sigsuspend(sigset_t __user *, size_t, unsigned long,
+				 unsigned long, unsigned long, unsigned long,
+				 unsigned long, struct pt_regs *);
+asmlinkage int sys_sigaltstack(const stack_t __user *, stack_t __user *,
+			       unsigned long, unsigned long, unsigned long,
+			       unsigned long, unsigned long, struct pt_regs *);
+asmlinkage int sys_rt_sigreturn(unsigned long, unsigned long, unsigned long,
+				unsigned long, unsigned long, unsigned long,
+				unsigned long, struct pt_regs *);
+
+/* kernel/sys_m32r.c */
+asmlinkage int sys_tas(int __user *);
+asmlinkage long sys_mmap2(unsigned long, unsigned long, unsigned long,
+			  unsigned long, unsigned long, unsigned long);
+asmlinkage int sys_ipc(uint, int, int, int, void __user *, long);
+asmlinkage int sys_uname(struct old_utsname __user *);
+asmlinkage int sys_cachectl(char *, int, int);
+
+#endif /* _ASM_M32R_SYSCALLS_H */
diff --git a/include/asm-m68k/syscalls.h b/include/asm-m68k/syscalls.h
new file mode 100644
index 0000000..13ad908
--- /dev/null
+++ b/include/asm-m68k/syscalls.h
@@ -0,0 +1,35 @@
+/*
+ * syscalls.h - Linux syscall interfaces (arch-specific)
+ *
+ * Copyright (c) 2008 Jaswinder Singh
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ *
+ * Please do not call me directly, include linux/syscalls.h
+ */
+
+#ifndef _ASM_M68K_SYSCALLS_H
+#define _ASM_M68K_SYSCALLS_H
+
+/* kernel/process.c */
+asmlinkage int sys_execve(char __user *, char __user * __user *,
+			  char __user * __user *);
+
+/* kernel/signal.c */
+asmlinkage int sys_sigaction(int, const struct old_sigaction __user *,
+			     struct old_sigaction __user *);
+asmlinkage int sys_sigaltstack(const stack_t __user *, stack_t __user *);
+
+/* kernel/sys_m68k.c */
+asmlinkage long sys_mmap2(unsigned long, unsigned long, unsigned long,
+			  unsigned long, unsigned long, unsigned long);
+struct mmap_arg_struct;
+asmlinkage int old_mmap(struct mmap_arg_struct __user *);
+struct sel_arg_struct;
+asmlinkage int old_select(struct sel_arg_struct __user *);
+asmlinkage int sys_ipc(uint, int, int, int, void __user *, long);
+asmlinkage int sys_cacheflush(unsigned long, int, int, unsigned long);
+asmlinkage int sys_getpagesize(void);
+
+#endif /* _ASM_M68K_SYSCALLS_H */
diff --git a/include/asm-m68knommu/syscalls.h b/include/asm-m68knommu/syscalls.h
new file mode 100644
index 0000000..e4b5c95
--- /dev/null
+++ b/include/asm-m68knommu/syscalls.h
@@ -0,0 +1,34 @@
+/*
+ * syscalls.h - Linux syscall interfaces (arch-specific)
+ *
+ * Copyright (c) 2008 Jaswinder Singh
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ *
+ * Please do not call me directly, include linux/syscalls.h
+ */
+
+#ifndef _ASM_M68KNOMMU_SYSCALLS_H
+#define _ASM_M68KNOMMU_SYSCALLS_H
+
+/* kernel/process.c */
+asmlinkage int sys_execve(char *, char **, char **);
+
+/* kernel/signal.c */
+asmlinkage int sys_sigaction(int, const struct old_sigaction *,
+			     struct old_sigaction *);
+asmlinkage int sys_sigaltstack(const stack_t *, stack_t *);
+
+/* kernel/sys_m68k.c */
+asmlinkage long sys_mmap2(unsigned long, unsigned long, unsigned long,
+			  unsigned long, unsigned long, unsigned long);
+struct mmap_arg_struct;
+asmlinkage int old_mmap(struct mmap_arg_struct *);
+struct sel_arg_struct;
+asmlinkage int old_select(struct sel_arg_struct *);
+asmlinkage int sys_ipc(uint, int, int, int, void *, long);
+asmlinkage int sys_cacheflush(unsigned long, int, int, unsigned long);
+asmlinkage int sys_getpagesize(void);
+
+#endif /* _ASM_M68KNOMMU_SYSCALLS_H */
diff --git a/include/asm-mips/syscalls.h b/include/asm-mips/syscalls.h
new file mode 100644
index 0000000..33635fc
--- /dev/null
+++ b/include/asm-mips/syscalls.h
@@ -0,0 +1,51 @@
+/*
+ * syscalls.h - Linux syscall interfaces (arch-specific)
+ *
+ * Copyright (c) 2008 Jaswinder Singh
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ *
+ * Please do not call me directly, include linux/syscalls.h
+ */
+
+#ifndef _ASM_MIPS_SYSCALLS_H
+#define _ASM_MIPS_SYSCALLS_H
+
+#include <asm/sim.h>
+
+/* kernel/signal.c */
+#ifdef CONFIG_TRAD_SIGNALS
+asmlinkage int sys_sigsuspend(nabi_no_regargs struct pt_regs);
+asmlinkage int sys_sigaction(int, const struct sigaction __user *,
+			     struct sigaction __user *);
+asmlinkage void sys_sigreturn(nabi_no_regargs struct pt_regs);
+#endif
+
+asmlinkage int sys_rt_sigsuspend(nabi_no_regargs struct pt_regs);
+asmlinkage int sys_sigaltstack(nabi_no_regargs struct pt_regs);
+asmlinkage void sys_rt_sigreturn(nabi_no_regargs struct pt_regs);
+
+/* kernel/linux32.c */
+asmlinkage int sys_truncate64(const char __user *, unsigned int,
+			      unsigned int);
+asmlinkage int sys_ftruncate64(unsigned int, unsigned int,
+			      unsigned int);
+
+/* kernel/syscalls.c */
+asmlinkage int sys_pipe(nabi_no_regargs volatile struct pt_regs);
+asmlinkage unsigned long old_mmap(unsigned long, unsigned long,
+				  int, int, int, off_t);
+
+asmlinkage unsigned long sys_mmap2(unsigned long, unsigned long,
+				   unsigned long, unsigned long,
+				   unsigned long, unsigned long);
+asmlinkage int sys_execve(nabi_no_regargs struct pt_regs);
+asmlinkage int sys_uname(struct old_utsname __user *);
+asmlinkage int sys_olduname(struct oldold_utsname __user *);
+asmlinkage int sys_set_thread_area(unsigned long);
+asmlinkage int sys_ipc(unsigned int, int, int,
+		       unsigned long, void __user *, long);
+asmlinkage int sys_cachectl(char *, int, int);
+
+#endif /* _ASM_MIPS_SYSCALLS_H */
diff --git a/include/asm-mn10300/syscalls.h b/include/asm-mn10300/syscalls.h
new file mode 100644
index 0000000..67baaea
--- /dev/null
+++ b/include/asm-mn10300/syscalls.h
@@ -0,0 +1,41 @@
+/*
+ * syscalls.h - Linux syscall interfaces (arch-specific)
+ *
+ * Copyright (c) 2008 Jaswinder Singh
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ *
+ * Please do not call me directly, include linux/syscalls.h
+ */
+
+#ifndef _ASM_MN10300_SYSCALLS_H
+#define _ASM_MN10300_SYSCALLS_H
+
+/* kernel/process.c */
+asmlinkage long sys_clone(unsigned long, unsigned long,
+			  int __user *, int __user *, int __user *);
+asmlinkage long sys_fork(void);
+asmlinkage long sys_vfork(void);
+asmlinkage long sys_execve(char __user *, char __user * __user *,
+			   char __user * __user *);
+
+/* kernel/signal.c */
+asmlinkage long sys_sigsuspend(int, int, old_sigset_t);
+asmlinkage long sys_sigaction(int sig,
+			      const struct old_sigaction __user *,
+			      struct old_sigaction __user *);
+asmlinkage long sys_sigaltstack(const stack_t __user *, stack_t *);
+asmlinkage long sys_sigreturn(void);
+asmlinkage long sys_rt_sigreturn(void);
+
+/* kernel/sys_mn10300.c */
+asmlinkage long sys_mmap2(unsigned long, unsigned long, unsigned long,
+			  unsigned long, unsigned long, unsigned long);
+asmlinkage long old_mmap(unsigned long, unsigned long, unsigned long,
+			  unsigned long, unsigned long, unsigned long);
+struct sel_arg_struct;
+asmlinkage int old_select(struct sel_arg_struct __user *);
+asmlinkage long sys_ipc(uint, int, int, int, void __user *, long);
+
+#endif /* _ASM_MN10300_SYSCALLS_H */
diff --git a/include/asm-parisc/syscalls.h b/include/asm-parisc/syscalls.h
new file mode 100644
index 0000000..0de8837
--- /dev/null
+++ b/include/asm-parisc/syscalls.h
@@ -0,0 +1,36 @@
+/*
+ * syscalls.h - Linux syscall interfaces (arch-specific)
+ *
+ * Copyright (c) 2008 Jaswinder Singh
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ *
+ * Please do not call me directly, include linux/syscalls.h
+ */
+
+#ifndef _ASM_PARISC_SYSCALLS_H
+#define _ASM_PARISC_SYSCALLS_H
+
+/* kernel/process.c */
+int sys_clone(unsigned long, unsigned long, struct pt_regs *);
+int sys_vfork(struct pt_regs *);
+asmlinkage int sys_execve(struct pt_regs *);
+
+/* kernel/signal.c */
+void sys_rt_sigreturn(struct pt_regs *, int);
+
+/* kernel/sys_parisc.c */
+asmlinkage unsigned long sys_mmap2(unsigned long, unsigned long,
+				   unsigned long, unsigned long,
+				   unsigned long, unsigned long);
+asmlinkage unsigned long sys_mmap(unsigned long, unsigned long,
+				  unsigned long, unsigned long,
+				  unsigned long, unsigned long);
+#ifdef CONFIG_64BIT
+asmlinkage long sys_truncate64(const char __user *, unsigned long);
+asmlinkage long sys_ftruncate64(unsigned int, unsigned long);
+asmlinkage long sys_fcntl64(unsigned int, unsigned int, unsigned long);
+#endif
+
+#endif /* _ASM_PARISC_SYSCALLS_H */
diff --git a/include/asm-s390/syscalls.h b/include/asm-s390/syscalls.h
new file mode 100644
index 0000000..439d6f8
--- /dev/null
+++ b/include/asm-s390/syscalls.h
@@ -0,0 +1,38 @@
+/*
+ * syscalls.h - Linux syscall interfaces (arch-specific)
+ *
+ * Copyright (c) 2008 Jaswinder Singh
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ *
+ * Please do not call me directly, include linux/syscalls.h
+ */
+
+#ifndef _ASM_S390_SYSCALLS_H
+#define _ASM_S390_SYSCALLS_H
+
+/* kernel/process.c */
+asmlinkage long sys_fork(void);
+asmlinkage long sys_clone(void);
+asmlinkage long sys_vfork(void);
+asmlinkage long sys_execve(void);
+
+/* kernel/signal.c */
+asmlinkage int sys_sigsuspend(int, int, old_sigset_t);
+asmlinkage long sys_sigaction(int,
+			      const struct old_sigaction __user *,
+			      struct old_sigaction __user *);
+asmlinkage long sys_sigaltstack(const stack_t __user *,
+				stack_t __user *);
+asmlinkage long sys_sigreturn(void);
+asmlinkage long sys_rt_sigreturn(void);
+
+/* kernel/sys_s390.c */
+struct mmap_arg_struct;
+asmlinkage long sys_mmap2(struct mmap_arg_struct __user  *);
+asmlinkage long old_mmap(struct mmap_arg_struct __user *);
+asmlinkage long sys_ipc(uint, int, unsigned long,
+			unsigned long, void __user *);
+
+#endif /* _ASM_S390_SYSCALLS_H */
diff --git a/include/asm-sh/syscalls.h b/include/asm-sh/syscalls.h
new file mode 100644
index 0000000..8966e00
--- /dev/null
+++ b/include/asm-sh/syscalls.h
@@ -0,0 +1,88 @@
+/*
+ * syscalls.h - Linux syscall interfaces (arch-specific)
+ *
+ * Copyright (c) 2008 Jaswinder Singh
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ *
+ * Please do not call me directly, include linux/syscalls.h
+ */
+
+#ifndef _ASM_SH_SYSCALLS_H
+#define _ASM_SH_SYSCALLS_H
+
+#ifdef CONFIG_SUPERH32
+/* kernel/process_32.c */
+asmlinkage int sys_fork(unsigned long, unsigned long, unsigned long,
+			unsigned long, struct pt_regs);
+asmlinkage int sys_sigaction(int,
+			     const struct old_sigaction __user *,
+			     struct old_sigaction __user *);
+asmlinkage int sys_clone(unsigned long, unsigned long, unsigned long,
+			 unsigned long, struct pt_regs);
+asmlinkage int sys_vfork(unsigned long, unsigned long, unsigned long,
+			 unsigned long, struct pt_regs);
+asmlinkage int sys_execve(char __user *, char __user * __user *,
+			  char __user * __user *, unsigned long,
+			  struct pt_regs);
+
+/* kernel/signal_32.c */
+asmlinkage int sys_sigsuspend(old_sigset_t, unsigned long,
+			      unsigned long, unsigned long,
+			      struct pt_regs);
+asmlinkage int sys_sigaltstack(const stack_t __user *, stack_t __user *,
+			       unsigned long, unsigned long,
+			       struct pt_regs);
+asmlinkage int sys_sigreturn(unsigned long, unsigned long, unsigned long,
+			     unsigned long, struct pt_regs);
+asmlinkage int sys_rt_sigreturn(unsigned long, unsigned long,
+				unsigned long, unsigned long,
+				struct pt_regs);
+
+/* kernel/sys_sh32.c */
+asmlinkage int sys_pipe(unsigned long, unsigned long, unsigned long,
+			unsigned long, struct pt_regs);
+asmlinkage ssize_t sys_pread_wrapper(unsigned int, char *, size_t,
+				     long, loff_t);
+asmlinkage ssize_t sys_pwrite_wrapper(unsigned int, const char *,
+				      size_t, long, loff_t);
+asmlinkage int sys_fadvise64_64_wrapper(int, u32, u32, u32, u32, int);
+
+#else /* CONFIG_SUPERH32 */
+
+/* kernel/process_64.c */
+asmlinkage int sys_fork(unsigned long, unsigned long, unsigned long,
+			unsigned long, unsigned long, unsigned long,
+			struct pt_regs *);
+asmlinkage int sys_clone(unsigned long, unsigned long, unsigned long,
+			 unsigned long, unsigned long, unsigned long,
+			 struct pt_regs *);
+asmlinkage int sys_vfork(unsigned long, unsigned long, unsigned long,
+			 unsigned long, unsigned long, unsigned long,
+			 struct pt_regs *);
+asmlinkage int sys_execve(char *, char **, char **, unsigned long,
+			  unsigned long, unsigned long, struct pt_regs *);
+
+/* kernel/signal_64.c */
+asmlinkage int sys_sigsuspend(old_sigset_t, unsigned long, unsigned long,
+			      unsigned long, unsigned long, unsigned long,
+			      struct pt_regs *);
+asmlinkage int sys_rt_sigsuspend(sigset_t *, size_t, unsigned long,
+				 unsigned long, unsigned long, unsigned long,
+				 struct pt_regs *);
+asmlinkage int sys_sigaction(int,
+			     const struct old_sigaction __user *,
+			     struct old_sigaction __user *);
+asmlinkage int sys_sigaltstack(const stack_t __user *, stack_t __user *,
+			       unsigned long, unsigned long, unsigned long,
+			       unsigned long, struct pt_regs *);
+asmlinkage int sys_sigreturn(unsigned long, unsigned long, unsigned long,
+			     unsigned long, unsigned long, unsigned long,
+			     struct pt_regs *);
+asmlinkage int sys_rt_sigreturn(unsigned long, unsigned long, unsigned long,
+				unsigned long, unsigned long, unsigned long,
+				struct pt_regs *);
+
+#endif /* CONFIG_SUPERH32 */
+#endif /* _ASM_SH_SYSCALLS_H */
diff --git a/include/asm-sparc/syscalls.h b/include/asm-sparc/syscalls.h
new file mode 100644
index 0000000..65c25cd
--- /dev/null
+++ b/include/asm-sparc/syscalls.h
@@ -0,0 +1,30 @@
+/*
+ * syscalls.h - Linux syscall interfaces (arch-specific)
+ *
+ * Copyright (c) 2008 Jaswinder Singh
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ *
+ * Please do not call me directly, include linux/syscalls.h
+ */
+
+#ifndef _ASM_SPARC_SYSCALLS_H
+#define _ASM_SPARC_SYSCALLS_H
+
+/* kernel/signal.c */
+asmlinkage int sys_sigsuspend(old_sigset_t);
+
+/* kernel/sys_sparc.c */
+asmlinkage unsigned long sys_getpagesize(void);
+asmlinkage int sys_ipc(uint, int, int, int, void __user *, long);
+asmlinkage long sys_mmap2(unsigned long, unsigned long, unsigned long,
+			  unsigned long, unsigned long, unsigned long);
+asmlinkage long sys_mmap(unsigned long, unsigned long, unsigned long,
+			 unsigned long, unsigned long, unsigned long);
+asmlinkage long sys_rt_sigaction(int, const struct sigaction __user *,
+				 struct sigaction __user *,
+				 void __user *, size_t);
+asmlinkage int sys_getdomainname(char __user *, int);
+
+#endif /* _ASM_SPARC_SYSCALLS_H */
diff --git a/include/asm-um/syscalls.h b/include/asm-um/syscalls.h
new file mode 100644
index 0000000..2124282
--- /dev/null
+++ b/include/asm-um/syscalls.h
@@ -0,0 +1,32 @@
+/*
+ * syscalls.h - Linux syscall interfaces (arch-specific)
+ *
+ * Copyright (c) 2008 Jaswinder Singh
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ *
+ * Please do not call me directly, include linux/syscalls.h
+ */
+
+#ifndef _ASM_UM_SYSCALLS_H
+#define _ASM_UM_SYSCALLS_H
+
+/* kernel/exec.c */
+long sys_execve(char __user *, char __user *__user *,
+		char __user * __user *);
+
+/* kernel/signal.c */
+long sys_sigsuspend(int, int, old_sigset_t);
+long sys_sigaltstack(const stack_t __user *, stack_t __user *);
+
+/* kernel/syscall.c */
+long sys_fork(void);
+long sys_vfork(void);
+long sys_mmap2(unsigned long, unsigned long, unsigned long,
+	       unsigned long, unsigned long, unsigned long);
+long old_mmap(unsigned long, unsigned long, unsigned long,
+	      unsigned long, unsigned long, unsigned long);
+long sys_uname(struct old_utsname __user *);
+
+#endif /* _ASM_UM_SYSCALLS_H */
diff --git a/include/asm-v850/syscalls.h b/include/asm-v850/syscalls.h
new file mode 100644
index 0000000..5c7f0eb
--- /dev/null
+++ b/include/asm-v850/syscalls.h
@@ -0,0 +1,34 @@
+/*
+ * syscalls.h - Linux syscall interfaces (arch-specific)
+ *
+ * Copyright (c) 2008 Jaswinder Singh
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ *
+ * Please do not call me directly, include linux/syscalls.h
+ */
+
+#ifndef _ASM_V850_SYSCALLS_H
+#define _ASM_V850_SYSCALLS_H
+
+/* kernel/process.c */
+int sys_execve(char *, char **, char **, struct pt_regs *);
+
+/* kernel/signal.c */
+asmlinkage int sys_sigsuspend(old_sigset_t, struct pt_regs *);
+asmlinkage int sys_rt_sigsuspend(sigset_t *, size_t, struct pt_regs *);
+asmlinkage int sys_sigaction(int, const struct old_sigaction *,
+			     struct old_sigaction *);
+asmlinkage int sys_sigaltstack(const stack_t *, stack_t *, struct pt_regs *);
+asmlinkage int sys_sigreturn(struct pt_regs *);
+asmlinkage int sys_rt_sigreturn(struct pt_regs *);
+
+/* kernel/syscalls.c */
+int sys_ipc(uint, int, int, int, void *, long);
+unsigned long sys_mmap2(unsigned long, size_t, unsigned long,
+			unsigned long, unsigned long, unsigned long);
+unsigned long sys_mmap(unsigned long, size_t, unsigned long,
+		       unsigned long, unsigned long, off_t);
+
+#endif /* _ASM_V850_SYSCALLS_H */
diff --git a/include/asm-x86/syscalls.h b/include/asm-x86/syscalls.h
new file mode 100644
index 0000000..a93e6db
--- /dev/null
+++ b/include/asm-x86/syscalls.h
@@ -0,0 +1,83 @@
+/*
+ * syscalls.h - Linux syscall interfaces (arch-specific)
+ *
+ * Copyright (c) 2008 Jaswinder Singh
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ *
+ * Please do not call me directly, include linux/syscalls.h
+ */
+
+#ifndef _ASM_X86_SYSCALLS_H
+#define _ASM_X86_SYSCALLS_H
+
+/* Common in X86_32 and X86_64 */
+/* kernel/ioport.c */
+asmlinkage long sys_ioperm(unsigned long, unsigned long, int);
+
+/* X86_32 only */
+#ifdef CONFIG_X86_32
+/* kernel/process_32.c */
+asmlinkage int sys_fork(struct pt_regs);
+asmlinkage int sys_clone(struct pt_regs);
+asmlinkage int sys_vfork(struct pt_regs);
+asmlinkage int sys_execve(struct pt_regs);
+
+/* kernel/signal_32.c */
+asmlinkage int sys_sigsuspend(int, int, old_sigset_t);
+asmlinkage int sys_sigaction(int, const struct old_sigaction __user *,
+			     struct old_sigaction __user *);
+asmlinkage int sys_sigaltstack(unsigned long);
+asmlinkage unsigned long sys_sigreturn(unsigned long);
+asmlinkage int sys_rt_sigreturn(unsigned long);
+
+/* kernel/ioport.c */
+asmlinkage long sys_iopl(unsigned long);
+
+/* kernel/ldt.c */
+asmlinkage int sys_modify_ldt(int, void __user *, unsigned long);
+
+/* kernel/sys_i386_32.c */
+asmlinkage long sys_mmap2(unsigned long, unsigned long, unsigned long,
+			  unsigned long, unsigned long, unsigned long);
+struct mmap_arg_struct;
+asmlinkage int old_mmap(struct mmap_arg_struct __user *);
+struct sel_arg_struct;
+asmlinkage int old_select(struct sel_arg_struct __user *);
+asmlinkage int sys_ipc(uint, int, int, int, void __user *, long);
+asmlinkage int sys_uname(struct old_utsname __user *);
+asmlinkage int sys_olduname(struct oldold_utsname __user *);
+
+/* kernel/tls.c */
+asmlinkage int sys_set_thread_area(struct user_desc __user *);
+asmlinkage int sys_get_thread_area(struct user_desc __user *);
+
+#else /* CONFIG_X86_32 */
+
+/* X86_64 only */
+/* kernel/process_64.c */
+asmlinkage long sys_fork(struct pt_regs *);
+asmlinkage long sys_clone(unsigned long, unsigned long,
+			  void __user *, void __user *,
+			  struct pt_regs *);
+asmlinkage long sys_vfork(struct pt_regs *);
+asmlinkage long sys_execve(char __user *, char __user * __user *,
+			   char __user * __user *,
+			   struct pt_regs *);
+
+/* kernel/ioport.c */
+asmlinkage long sys_iopl(unsigned int, struct pt_regs *);
+
+/* kernel/signal_64.c */
+asmlinkage long sys_sigaltstack(const stack_t __user *, stack_t __user *,
+				struct pt_regs *);
+asmlinkage long sys_rt_sigreturn(struct pt_regs *);
+
+/* kernel/sys_x86_64.c */
+asmlinkage long sys_mmap(unsigned long, unsigned long, unsigned long,
+			 unsigned long, unsigned long, unsigned long);
+asmlinkage long sys_uname(struct new_utsname __user *);
+
+#endif /* CONFIG_X86_32 */
+#endif /* _ASM_X86_SYSCALLS_H */
diff --git a/include/asm-xtensa/syscalls.h b/include/asm-xtensa/syscalls.h
new file mode 100644
index 0000000..4aa949e
--- /dev/null
+++ b/include/asm-xtensa/syscalls.h
@@ -0,0 +1,17 @@
+/*
+ * syscalls.h - Linux syscall interfaces (arch-specific)
+ *
+ * Copyright (c) 2008 Jaswinder Singh
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ *
+ * Please do not call me directly, include linux/syscalls.h
+ */
+
+#ifndef _ASM_XTENSA_SYSCALLS_H
+#define _ASM_XTENSA_SYSCALLS_H
+
+/* define arch dependent syscalls here */
+
+#endif /* _ASM_XTENSA_SYSCALLS_H */
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 0522f36..829556e 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -54,6 +54,8 @@ struct compat_stat;
 struct compat_timeval;
 struct robust_list_head;
 struct getcpu_cache;
+struct oldold_utsname;
+struct old_utsname;
 
 #include <linux/types.h>
 #include <linux/aio_abi.h>
@@ -65,6 +67,8 @@ struct getcpu_cache;
 #include <linux/quota.h>
 #include <linux/key.h>
 
+#include <asm/syscalls.h>
+
 asmlinkage long sys_time(time_t __user *tloc);
 asmlinkage long sys_stime(time_t __user *tptr);
 asmlinkage long sys_gettimeofday(struct timeval __user *tv,
-- 
1.5.5.1



