Return-Path: <linux-kernel-owner+w=401wt.eu-S1946652AbXBIQjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946652AbXBIQjR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 11:39:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946633AbXBIQjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 11:39:09 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51675 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946639AbXBIQig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 11:38:36 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH] kvm: __user annotations
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1HFYlf-0006mV-Ld@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Fri, 09 Feb 2007 16:38:35 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/kvm/kvm_main.c |   35 ++++++++++++++++++-----------------
 1 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index b10972e..a553540 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -1778,6 +1778,7 @@ static long kvm_dev_ioctl(struct file *filp,
 			  unsigned int ioctl, unsigned long arg)
 {
 	struct kvm *kvm = filp->private_data;
+	void __user *argp = (void __user *)arg;
 	int r = -EINVAL;
 
 	switch (ioctl) {
@@ -1794,12 +1795,12 @@ static long kvm_dev_ioctl(struct file *filp,
 		struct kvm_run kvm_run;
 
 		r = -EFAULT;
-		if (copy_from_user(&kvm_run, (void *)arg, sizeof kvm_run))
+		if (copy_from_user(&kvm_run, argp, sizeof kvm_run))
 			goto out;
 		r = kvm_dev_ioctl_run(kvm, &kvm_run);
 		if (r < 0 &&  r != -EINTR)
 			goto out;
-		if (copy_to_user((void *)arg, &kvm_run, sizeof kvm_run)) {
+		if (copy_to_user(argp, &kvm_run, sizeof kvm_run)) {
 			r = -EFAULT;
 			goto out;
 		}
@@ -1809,13 +1810,13 @@ static long kvm_dev_ioctl(struct file *filp,
 		struct kvm_regs kvm_regs;
 
 		r = -EFAULT;
-		if (copy_from_user(&kvm_regs, (void *)arg, sizeof kvm_regs))
+		if (copy_from_user(&kvm_regs, argp, sizeof kvm_regs))
 			goto out;
 		r = kvm_dev_ioctl_get_regs(kvm, &kvm_regs);
 		if (r)
 			goto out;
 		r = -EFAULT;
-		if (copy_to_user((void *)arg, &kvm_regs, sizeof kvm_regs))
+		if (copy_to_user(argp, &kvm_regs, sizeof kvm_regs))
 			goto out;
 		r = 0;
 		break;
@@ -1824,7 +1825,7 @@ static long kvm_dev_ioctl(struct file *filp,
 		struct kvm_regs kvm_regs;
 
 		r = -EFAULT;
-		if (copy_from_user(&kvm_regs, (void *)arg, sizeof kvm_regs))
+		if (copy_from_user(&kvm_regs, argp, sizeof kvm_regs))
 			goto out;
 		r = kvm_dev_ioctl_set_regs(kvm, &kvm_regs);
 		if (r)
@@ -1836,13 +1837,13 @@ static long kvm_dev_ioctl(struct file *filp,
 		struct kvm_sregs kvm_sregs;
 
 		r = -EFAULT;
-		if (copy_from_user(&kvm_sregs, (void *)arg, sizeof kvm_sregs))
+		if (copy_from_user(&kvm_sregs, argp, sizeof kvm_sregs))
 			goto out;
 		r = kvm_dev_ioctl_get_sregs(kvm, &kvm_sregs);
 		if (r)
 			goto out;
 		r = -EFAULT;
-		if (copy_to_user((void *)arg, &kvm_sregs, sizeof kvm_sregs))
+		if (copy_to_user(argp, &kvm_sregs, sizeof kvm_sregs))
 			goto out;
 		r = 0;
 		break;
@@ -1851,7 +1852,7 @@ static long kvm_dev_ioctl(struct file *filp,
 		struct kvm_sregs kvm_sregs;
 
 		r = -EFAULT;
-		if (copy_from_user(&kvm_sregs, (void *)arg, sizeof kvm_sregs))
+		if (copy_from_user(&kvm_sregs, argp, sizeof kvm_sregs))
 			goto out;
 		r = kvm_dev_ioctl_set_sregs(kvm, &kvm_sregs);
 		if (r)
@@ -1863,13 +1864,13 @@ static long kvm_dev_ioctl(struct file *filp,
 		struct kvm_translation tr;
 
 		r = -EFAULT;
-		if (copy_from_user(&tr, (void *)arg, sizeof tr))
+		if (copy_from_user(&tr, argp, sizeof tr))
 			goto out;
 		r = kvm_dev_ioctl_translate(kvm, &tr);
 		if (r)
 			goto out;
 		r = -EFAULT;
-		if (copy_to_user((void *)arg, &tr, sizeof tr))
+		if (copy_to_user(argp, &tr, sizeof tr))
 			goto out;
 		r = 0;
 		break;
@@ -1878,7 +1879,7 @@ static long kvm_dev_ioctl(struct file *filp,
 		struct kvm_interrupt irq;
 
 		r = -EFAULT;
-		if (copy_from_user(&irq, (void *)arg, sizeof irq))
+		if (copy_from_user(&irq, argp, sizeof irq))
 			goto out;
 		r = kvm_dev_ioctl_interrupt(kvm, &irq);
 		if (r)
@@ -1890,7 +1891,7 @@ static long kvm_dev_ioctl(struct file *filp,
 		struct kvm_debug_guest dbg;
 
 		r = -EFAULT;
-		if (copy_from_user(&dbg, (void *)arg, sizeof dbg))
+		if (copy_from_user(&dbg, argp, sizeof dbg))
 			goto out;
 		r = kvm_dev_ioctl_debug_guest(kvm, &dbg);
 		if (r)
@@ -1902,7 +1903,7 @@ static long kvm_dev_ioctl(struct file *filp,
 		struct kvm_memory_region kvm_mem;
 
 		r = -EFAULT;
-		if (copy_from_user(&kvm_mem, (void *)arg, sizeof kvm_mem))
+		if (copy_from_user(&kvm_mem, argp, sizeof kvm_mem))
 			goto out;
 		r = kvm_dev_ioctl_set_memory_region(kvm, &kvm_mem);
 		if (r)
@@ -1913,7 +1914,7 @@ static long kvm_dev_ioctl(struct file *filp,
 		struct kvm_dirty_log log;
 
 		r = -EFAULT;
-		if (copy_from_user(&log, (void *)arg, sizeof log))
+		if (copy_from_user(&log, argp, sizeof log))
 			goto out;
 		r = kvm_dev_ioctl_get_dirty_log(kvm, &log);
 		if (r)
@@ -1921,13 +1922,13 @@ static long kvm_dev_ioctl(struct file *filp,
 		break;
 	}
 	case KVM_GET_MSRS:
-		r = msr_io(kvm, (void __user *)arg, get_msr, 1);
+		r = msr_io(kvm, argp, get_msr, 1);
 		break;
 	case KVM_SET_MSRS:
-		r = msr_io(kvm, (void __user *)arg, do_set_msr, 0);
+		r = msr_io(kvm, argp, do_set_msr, 0);
 		break;
 	case KVM_GET_MSR_INDEX_LIST: {
-		struct kvm_msr_list __user *user_msr_list = (void __user *)arg;
+		struct kvm_msr_list __user *user_msr_list = argp;
 		struct kvm_msr_list msr_list;
 		unsigned n;
 
-- 
1.5.0-rc2.GIT


