Return-Path: <linux-kernel-owner+w=401wt.eu-S1759094AbYEBGls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759094AbYEBGls (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 02:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754737AbYEBGlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 02:41:37 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:15879 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030AbYEBGlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 02:41:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:x-x-sender:to:cc:subject:message-id:user-agent:mime-version:content-type:from;
        b=DV4KiN5QthztnRsJHwk80XH+tfginUcSzogWRNfNoqQdXX+OTq+Lfrta3UueAOX940CglMxQnP7KDcdWhAUDIQhAGL3D9VD766JrXiA1j8XdJ9+f3SCrW2uR3DIvNd36RLcahuezTPcmouTyGfkpFM7kNBF/aISIGQbVGL0wOEI=
Date: Fri, 2 May 2008 14:45:39 +0800 (CST)
X-X-Sender: wangcong@localhost.localdomain
To: linux-kernel@vger.kernel.org
cc: akpm@osdl.org, jdike@addtoit.com,
       user-mode-linux-devel@lists.sourceforge.net
Subject: [Patch] (Resend) UML: make several more things static
Message-ID: <alpine.LFD.1.10.0805021443050.3349@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
From: WANG Cong <xiyou.wangcong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Make some variables and functions static, since they don't need
to be global.

Remove an unused function - arch/um/kernel/time.c::sched_clock().

Clean the style a bit as complained by checkpatch.pl.

Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: WANG Cong <wangcong@zeuux.org>


---
  arch/um/include/skas/skas.h     |    1 -
  arch/um/include/um_uaccess.h    |    1 -
  arch/um/kernel/physmem.c        |    2 +-
  arch/um/kernel/ptrace.c         |    2 +-
  arch/um/kernel/time.c           |    8 --------
  arch/um/kernel/uaccess.c        |    2 +-
  arch/um/os-Linux/sigio.c        |    2 +-
  arch/um/os-Linux/signal.c       |    2 +-
  arch/um/os-Linux/skas/process.c |    2 +-
  arch/um/os-Linux/umid.c         |    2 +-
  arch/um/sys-i386/bugs.c         |    2 +-
  arch/um/sys-i386/checksum.S     |    5 ++---
  arch/um/sys-i386/ldt.c          |    4 ++--
  include/asm-um/ptrace-generic.h |    3 ---
  14 files changed, 12 insertions(+), 26 deletions(-)

diff --git a/arch/um/include/skas/skas.h b/arch/um/include/skas/skas.h
index b073f8a..64d2c74 100644
--- a/arch/um/include/skas/skas.h
+++ b/arch/um/include/skas/skas.h
@@ -16,7 +16,6 @@ extern int user_thread(unsigned long stack, int flags);
  extern void new_thread_handler(void);
  extern void handle_syscall(struct uml_pt_regs *regs);
  extern int new_mm(unsigned long stack);
-extern void get_skas_faultinfo(int pid, struct faultinfo * fi);
  extern long execute_syscall_skas(void *r);
  extern unsigned long current_stub_stack(void);

diff --git a/arch/um/include/um_uaccess.h b/arch/um/include/um_uaccess.h
index 2b6fc8e..45c0499 100644
--- a/arch/um/include/um_uaccess.h
+++ b/arch/um/include/um_uaccess.h
@@ -34,7 +34,6 @@ extern int copy_to_user(void __user *to, const void *from, int n);

  extern int __do_copy_to_user(void *to, const void *from, int n,
  			     void **fault_addr, jmp_buf **fault_catcher);
-extern void __do_copy(void *to, const void *from, int n);

  /*
   * strncpy_from_user: - Copy a NUL terminated string from userspace.
diff --git a/arch/um/kernel/physmem.c b/arch/um/kernel/physmem.c
index 9757085..a1a9090 100644
--- a/arch/um/kernel/physmem.c
+++ b/arch/um/kernel/physmem.c
@@ -185,7 +185,7 @@ unsigned long find_iomem(char *driver, unsigned long *len_out)
  	return 0;
  }

-int setup_iomem(void)
+static int setup_iomem(void)
  {
  	struct iomem_region *region = iomem_regions;
  	unsigned long iomem_start = high_physmem + PAGE_SIZE;
diff --git a/arch/um/kernel/ptrace.c b/arch/um/kernel/ptrace.c
index 47b57b4..15e8b7c 100644
--- a/arch/um/kernel/ptrace.c
+++ b/arch/um/kernel/ptrace.c
@@ -225,7 +225,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
  	return ret;
  }

-void send_sigtrap(struct task_struct *tsk, struct uml_pt_regs *regs,
+static void send_sigtrap(struct task_struct *tsk, struct uml_pt_regs *regs,
  		  int error_code)
  {
  	struct siginfo info;
diff --git a/arch/um/kernel/time.c b/arch/um/kernel/time.c
index e066e84..353c174 100644
--- a/arch/um/kernel/time.c
+++ b/arch/um/kernel/time.c
@@ -12,14 +12,6 @@
  #include "kern_util.h"
  #include "os.h"

-/*
- * Scheduler clock - returns current time in nanosec units.
- */
-unsigned long long sched_clock(void)
-{
-	return (unsigned long long)jiffies_64 * (NSEC_PER_SEC / HZ);
-}
-
  void timer_handler(int sig, struct uml_pt_regs *regs)
  {
  	unsigned long flags;
diff --git a/arch/um/kernel/uaccess.c b/arch/um/kernel/uaccess.c
index f0f4b04..dd33f04 100644
--- a/arch/um/kernel/uaccess.c
+++ b/arch/um/kernel/uaccess.c
@@ -12,7 +12,7 @@
  #include <linux/string.h>
  #include "os.h"

-void __do_copy(void *to, const void *from, int n)
+static void __do_copy(void *to, const void *from, int n)
  {
  	memcpy(to, from, n);
  }
diff --git a/arch/um/os-Linux/sigio.c b/arch/um/os-Linux/sigio.c
index abf47a7..07705c1 100644
--- a/arch/um/os-Linux/sigio.c
+++ b/arch/um/os-Linux/sigio.c
@@ -523,7 +523,7 @@ static void tty_close(int master, int slave)
  		printk(UM_KERN_CONT "No, enabling workaround\n");
  }

-void __init check_sigio(void)
+static void __init check_sigio(void)
  {
  	if ((access("/dev/ptmx", R_OK) < 0) &&
  	    (access("/dev/ptyp0", R_OK) < 0)) {
diff --git a/arch/um/os-Linux/signal.c b/arch/um/os-Linux/signal.c
index 3f1694b..1a3d233 100644
--- a/arch/um/os-Linux/signal.c
+++ b/arch/um/os-Linux/signal.c
@@ -125,7 +125,7 @@ void set_sigstack(void *sig_stack, int size)
  		panic("enabling signal stack failed, errno = %d\n", errno);
  }

-void (*handlers[_NSIG])(int sig, struct sigcontext *sc);
+static void (*handlers[_NSIG])(int sig, struct sigcontext *sc);

  void handle_signal(int sig, struct sigcontext *sc)
  {
diff --git a/arch/um/os-Linux/skas/process.c b/arch/um/os-Linux/skas/process.c
index 1e8cba6..87d05fb 100644
--- a/arch/um/os-Linux/skas/process.c
+++ b/arch/um/os-Linux/skas/process.c
@@ -96,7 +96,7 @@ bad_wait:

  extern unsigned long current_stub_stack(void);

-void get_skas_faultinfo(int pid, struct faultinfo * fi)
+static void get_skas_faultinfo(int pid, struct faultinfo *fi)
  {
  	int err;

diff --git a/arch/um/os-Linux/umid.c b/arch/um/os-Linux/umid.c
index 106fa86..a27defb 100644
--- a/arch/um/os-Linux/umid.c
+++ b/arch/um/os-Linux/umid.c
@@ -245,7 +245,7 @@ int __init set_umid(char *name)
  /* Changed in make_umid, which is called during early boot */
  static int umid_setup = 0;

-int __init make_umid(void)
+static int __init make_umid(void)
  {
  	int fd, err;
  	char tmp[256];
diff --git a/arch/um/sys-i386/bugs.c b/arch/um/sys-i386/bugs.c
index a74442d..2c6d0d7 100644
--- a/arch/um/sys-i386/bugs.c
+++ b/arch/um/sys-i386/bugs.c
@@ -12,7 +12,7 @@
  #include "sysdep/ptrace.h"

  /* Set during early boot */
-int host_has_cmov = 1;
+static int host_has_cmov = 1;
  static jmp_buf cmov_test_return;

  static void cmov_sigill_test_handler(int sig)
diff --git a/arch/um/sys-i386/checksum.S b/arch/um/sys-i386/checksum.S
index 62c7e56..f058d2f 100644
--- a/arch/um/sys-i386/checksum.S
+++ b/arch/um/sys-i386/checksum.S
@@ -243,13 +243,12 @@ unsigned int csum_partial_copy_generic (const char *src, char *dst,
  	.previous

  .align 4
-.globl csum_partial_copy_generic_i386
- 
+
  #ifndef CONFIG_X86_USE_PPRO_CHECKSUM

  #define ARGBASE 16
  #define FP		12
- 
+
  csum_partial_copy_generic_i386:
  	subl  $4,%esp
  	pushl %edi
diff --git a/arch/um/sys-i386/ldt.c b/arch/um/sys-i386/ldt.c
index a34263e..a4846a8 100644
--- a/arch/um/sys-i386/ldt.c
+++ b/arch/um/sys-i386/ldt.c
@@ -14,8 +14,8 @@

  extern int modify_ldt(int func, void *ptr, unsigned long bytecount);

-long write_ldt_entry(struct mm_id * mm_idp, int func, struct user_desc * desc,
-		     void **addr, int done)
+static long write_ldt_entry(struct mm_id *mm_idp, int func,
+		     struct user_desc *desc, void **addr, int done)
  {
  	long res;

diff --git a/include/asm-um/ptrace-generic.h b/include/asm-um/ptrace-generic.h
index 6aefcd3..3157497 100644
--- a/include/asm-um/ptrace-generic.h
+++ b/include/asm-um/ptrace-generic.h
@@ -47,9 +47,6 @@ extern int set_fpregs(struct user_i387_struct __user *buf,

  extern void show_regs(struct pt_regs *regs);

-extern void send_sigtrap(struct task_struct *tsk, struct uml_pt_regs *regs,
-			 int error_code);
-
  extern int arch_copy_tls(struct task_struct *new);
  extern void clear_flushed_tls(struct task_struct *task);

-- 
1.5.2.4
