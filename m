Return-Path: <linux-kernel-owner+w=401wt.eu-S1757375AbZLFR7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375AbZLFR7w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 12:59:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757131AbZLFR7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 12:59:51 -0500
Received: from www.tglx.de ([62.245.132.106]:32882 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757102AbZLFR7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 12:59:51 -0500
Date: Sun, 6 Dec 2009 18:59:38 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT pull] bkl removal in arch/* for 2.6.33
Message-ID: <alpine.LFD.2.00.0912061858350.3089@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest bkl-arch-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git bkl-arch-for-linus

Thanks,

	tglx

------------------>
John Kacur (6):
      blackfin: Remove the BKL from sys_execve
      frv: Remove the BKL from sys_execve
      h83000: Remove BKL from sys_execve
      m68k: Remove the BKL from sys_execve
      m68knommu: Remove the BKL from sys_execve
      mn10300: Remove the BKL from sys_execve

Thomas Gleixner (3):
      s390: Remove BKL from prng
      um: Remove BKL from random
      um: Remove BKL from mmapper


 arch/blackfin/kernel/process.c  |    6 +-----
 arch/frv/kernel/process.c       |    5 +----
 arch/h8300/kernel/process.c     |    5 +----
 arch/m68k/kernel/process.c      |    5 +----
 arch/m68knommu/kernel/process.c |    5 +----
 arch/mn10300/kernel/process.c   |   12 ++++--------
 arch/s390/crypto/prng.c         |    2 --
 arch/um/drivers/mmapper_kern.c  |   11 ++++-------
 arch/um/drivers/random.c        |    3 ---
 9 files changed, 13 insertions(+), 41 deletions(-)

diff --git a/arch/blackfin/kernel/process.c b/arch/blackfin/kernel/process.c
index 430ae39..7d9c975 100644
--- a/arch/blackfin/kernel/process.c
+++ b/arch/blackfin/kernel/process.c
@@ -215,22 +215,18 @@ copy_thread(unsigned long clone_flags,
 /*
  * sys_execve() executes a new program.
  */
-
 asmlinkage int sys_execve(char __user *name, char __user * __user *argv, char __user * __user *envp)
 {
 	int error;
 	char *filename;
 	struct pt_regs *regs = (struct pt_regs *)((&name) + 6);
 
-	lock_kernel();
 	filename = getname(name);
 	error = PTR_ERR(filename);
 	if (IS_ERR(filename))
-		goto out;
+		return error;
 	error = do_execve(filename, argv, envp, regs);
 	putname(filename);
- out:
-	unlock_kernel();
 	return error;
 }
 
diff --git a/arch/frv/kernel/process.c b/arch/frv/kernel/process.c
index 9042559..21d0fd1 100644
--- a/arch/frv/kernel/process.c
+++ b/arch/frv/kernel/process.c
@@ -255,15 +255,12 @@ asmlinkage int sys_execve(char __user *name, char __user * __user *argv, char __
 	int error;
 	char * filename;
 
-	lock_kernel();
 	filename = getname(name);
 	error = PTR_ERR(filename);
 	if (IS_ERR(filename))
-		goto out;
+		return error;
 	error = do_execve(filename, argv, envp, __frame);
 	putname(filename);
- out:
-	unlock_kernel();
 	return error;
 }
 
diff --git a/arch/h8300/kernel/process.c b/arch/h8300/kernel/process.c
index e2f33d0..bd883fa 100644
--- a/arch/h8300/kernel/process.c
+++ b/arch/h8300/kernel/process.c
@@ -218,15 +218,12 @@ asmlinkage int sys_execve(char *name, char **argv, char **envp,int dummy,...)
 	char * filename;
 	struct pt_regs *regs = (struct pt_regs *) ((unsigned char *)&dummy-4);
 
-	lock_kernel();
 	filename = getname(name);
 	error = PTR_ERR(filename);
 	if (IS_ERR(filename))
-		goto out;
+		return error;
 	error = do_execve(filename, argv, envp, regs);
 	putname(filename);
-out:
-	unlock_kernel();
 	return error;
 }
 
diff --git a/arch/m68k/kernel/process.c b/arch/m68k/kernel/process.c
index 41230c5..0529659 100644
--- a/arch/m68k/kernel/process.c
+++ b/arch/m68k/kernel/process.c
@@ -317,15 +317,12 @@ asmlinkage int sys_execve(char __user *name, char __user * __user *argv, char __
 	char * filename;
 	struct pt_regs *regs = (struct pt_regs *) &name;
 
-	lock_kernel();
 	filename = getname(name);
 	error = PTR_ERR(filename);
 	if (IS_ERR(filename))
-		goto out;
+		return error;
 	error = do_execve(filename, argv, envp, regs);
 	putname(filename);
-out:
-	unlock_kernel();
 	return error;
 }
 
diff --git a/arch/m68knommu/kernel/process.c b/arch/m68knommu/kernel/process.c
index 8f8f4ab..5c9ecd4 100644
--- a/arch/m68knommu/kernel/process.c
+++ b/arch/m68knommu/kernel/process.c
@@ -352,15 +352,12 @@ asmlinkage int sys_execve(char *name, char **argv, char **envp)
 	char * filename;
 	struct pt_regs *regs = (struct pt_regs *) &name;
 
-	lock_kernel();
 	filename = getname(name);
 	error = PTR_ERR(filename);
 	if (IS_ERR(filename))
-		goto out;
+		return error;
 	error = do_execve(filename, argv, envp, regs);
 	putname(filename);
-out:
-	unlock_kernel();
 	return error;
 }
 
diff --git a/arch/mn10300/kernel/process.c b/arch/mn10300/kernel/process.c
index 892cce8..ec8a21d 100644
--- a/arch/mn10300/kernel/process.c
+++ b/arch/mn10300/kernel/process.c
@@ -275,16 +275,12 @@ asmlinkage long sys_execve(char __user *name,
 	char *filename;
 	int error;
 
-	lock_kernel();
-
 	filename = getname(name);
 	error = PTR_ERR(filename);
-	if (!IS_ERR(filename)) {
-		error = do_execve(filename, argv, envp, __frame);
-		putname(filename);
-	}
-
-	unlock_kernel();
+	if (IS_ERR(filename))
+		return error;
+	error = do_execve(filename, argv, envp, __frame);
+	putname(filename);
 	return error;
 }
 
diff --git a/arch/s390/crypto/prng.c b/arch/s390/crypto/prng.c
index b49c00c..a320990 100644
--- a/arch/s390/crypto/prng.c
+++ b/arch/s390/crypto/prng.c
@@ -6,7 +6,6 @@
 #include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
-#include <linux/smp_lock.h>
 #include <linux/miscdevice.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
@@ -49,7 +48,6 @@ static unsigned char parm_block[32] = {
 
 static int prng_open(struct inode *inode, struct file *file)
 {
-	cycle_kernel_lock();
 	return nonseekable_open(inode, file);
 }
 
diff --git a/arch/um/drivers/mmapper_kern.c b/arch/um/drivers/mmapper_kern.c
index eb24032..d22f9e5 100644
--- a/arch/um/drivers/mmapper_kern.c
+++ b/arch/um/drivers/mmapper_kern.c
@@ -16,7 +16,7 @@
 #include <linux/miscdevice.h>
 #include <linux/module.h>
 #include <linux/mm.h>
-#include <linux/smp_lock.h>
+
 #include <asm/uaccess.h>
 #include "mem_user.h"
 
@@ -78,7 +78,6 @@ out:
 
 static int mmapper_open(struct inode *inode, struct file *file)
 {
-	cycle_kernel_lock();
 	return 0;
 }
 
@@ -115,18 +114,16 @@ static int __init mmapper_init(void)
 	v_buf = (char *) find_iomem("mmapper", &mmapper_size);
 	if (mmapper_size == 0) {
 		printk(KERN_ERR "mmapper_init - find_iomem failed\n");
-		goto out;
+		return -ENODEV;
 	}
+	p_buf = __pa(v_buf);
 
 	err = misc_register(&mmapper_dev);
 	if (err) {
 		printk(KERN_ERR "mmapper - misc_register failed, err = %d\n",
 		       err);
-		goto out;
+		return err;;
 	}
-
-	p_buf = __pa(v_buf);
-out:
 	return 0;
 }
 
diff --git a/arch/um/drivers/random.c b/arch/um/drivers/random.c
index 6eabb70..4949044 100644
--- a/arch/um/drivers/random.c
+++ b/arch/um/drivers/random.c
@@ -7,7 +7,6 @@
  * of the GNU General Public License, incorporated herein by reference.
  */
 #include <linux/sched.h>
-#include <linux/smp_lock.h>
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/interrupt.h>
@@ -34,8 +33,6 @@ static DECLARE_WAIT_QUEUE_HEAD(host_read_wait);
 
 static int rng_dev_open (struct inode *inode, struct file *filp)
 {
-	cycle_kernel_lock();
-
 	/* enforce read-only access to this chrdev */
 	if ((filp->f_mode & FMODE_READ) == 0)
 		return -EINVAL;
