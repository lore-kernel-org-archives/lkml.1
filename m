Return-Path: <linux-kernel-owner+w=401wt.eu-S1422755AbXBUSPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422755AbXBUSPi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 13:15:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422753AbXBUSPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 13:15:38 -0500
Received: from il.qumranet.com ([82.166.9.18]:47668 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422755AbXBUSPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 13:15:37 -0500
Subject: [PATCH 3/6] KVM: Rename some kvm_dev_ioctl_*() functions to
	kvm_vm_ioctl_*()
From: Avi Kivity <avi@qumranet.com>
Date: Wed, 21 Feb 2007 18:15:35 -0000
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, mingo@elte.hu
References: <45DC8B6E.5050205@qumranet.com>
In-Reply-To: <45DC8B6E.5050205@qumranet.com>
Content-Type: text/plain; charset=UTF-8
Message-Id: <20070221181535.A395025016D@il.qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This reflects the changed scope, from device-wide to single vm (previously
every device open created a virtual machine).

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |   48 ++++++++++++++++++++++++------------------------
 1 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index aa07d9c..981f5d3 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -601,7 +601,7 @@ EXPORT_SYMBOL_GPL(fx_init);
 /*
  * Creates some virtual cpus.  Good luck creating more than one.
  */
-static int kvm_dev_ioctl_create_vcpu(struct kvm *kvm, int n)
+static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, int n)
 {
 	int r;
 	struct kvm_vcpu *vcpu;
@@ -655,8 +655,8 @@ out:
  *
  * Discontiguous memory is allowed, mostly for framebuffers.
  */
-static int kvm_dev_ioctl_set_memory_region(struct kvm *kvm,
-					   struct kvm_memory_region *mem)
+static int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
+					  struct kvm_memory_region *mem)
 {
 	int r;
 	gfn_t base_gfn;
@@ -804,8 +804,8 @@ static void do_remove_write_access(struct kvm_vcpu *vcpu, int slot)
 /*
  * Get (and clear) the dirty memory log for a memory slot.
  */
-static int kvm_dev_ioctl_get_dirty_log(struct kvm *kvm,
-				       struct kvm_dirty_log *log)
+static int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
+				      struct kvm_dirty_log *log)
 {
 	struct kvm_memory_slot *memslot;
 	int r, i;
@@ -1535,7 +1535,7 @@ void save_msrs(struct vmx_msr_entry *e, int n)
 }
 EXPORT_SYMBOL_GPL(save_msrs);
 
-static int kvm_dev_ioctl_run(struct kvm *kvm, struct kvm_run *kvm_run)
+static int kvm_vm_ioctl_run(struct kvm *kvm, struct kvm_run *kvm_run)
 {
 	struct kvm_vcpu *vcpu;
 	int r;
@@ -1568,7 +1568,7 @@ static int kvm_dev_ioctl_run(struct kvm *kvm, struct kvm_run *kvm_run)
 	return r;
 }
 
-static int kvm_dev_ioctl_get_regs(struct kvm *kvm, struct kvm_regs *regs)
+static int kvm_vm_ioctl_get_regs(struct kvm *kvm, struct kvm_regs *regs)
 {
 	struct kvm_vcpu *vcpu;
 
@@ -1614,7 +1614,7 @@ static int kvm_dev_ioctl_get_regs(struct kvm *kvm, struct kvm_regs *regs)
 	return 0;
 }
 
-static int kvm_dev_ioctl_set_regs(struct kvm *kvm, struct kvm_regs *regs)
+static int kvm_vm_ioctl_set_regs(struct kvm *kvm, struct kvm_regs *regs)
 {
 	struct kvm_vcpu *vcpu;
 
@@ -1660,7 +1660,7 @@ static void get_segment(struct kvm_vcpu *vcpu,
 	return kvm_arch_ops->get_segment(vcpu, var, seg);
 }
 
-static int kvm_dev_ioctl_get_sregs(struct kvm *kvm, struct kvm_sregs *sregs)
+static int kvm_vm_ioctl_get_sregs(struct kvm *kvm, struct kvm_sregs *sregs)
 {
 	struct kvm_vcpu *vcpu;
 	struct descriptor_table dt;
@@ -1711,7 +1711,7 @@ static void set_segment(struct kvm_vcpu *vcpu,
 	return kvm_arch_ops->set_segment(vcpu, var, seg);
 }
 
-static int kvm_dev_ioctl_set_sregs(struct kvm *kvm, struct kvm_sregs *sregs)
+static int kvm_vm_ioctl_set_sregs(struct kvm *kvm, struct kvm_sregs *sregs)
 {
 	struct kvm_vcpu *vcpu;
 	int mmu_reset_needed = 0;
@@ -1904,7 +1904,7 @@ out:
 /*
  * Translate a guest virtual address to a guest physical address.
  */
-static int kvm_dev_ioctl_translate(struct kvm *kvm, struct kvm_translation *tr)
+static int kvm_vm_ioctl_translate(struct kvm *kvm, struct kvm_translation *tr)
 {
 	unsigned long vaddr = tr->linear_address;
 	struct kvm_vcpu *vcpu;
@@ -1925,7 +1925,7 @@ static int kvm_dev_ioctl_translate(struct kvm *kvm, struct kvm_translation *tr)
 	return 0;
 }
 
-static int kvm_dev_ioctl_interrupt(struct kvm *kvm, struct kvm_interrupt *irq)
+static int kvm_vm_ioctl_interrupt(struct kvm *kvm, struct kvm_interrupt *irq)
 {
 	struct kvm_vcpu *vcpu;
 
@@ -1945,7 +1945,7 @@ static int kvm_dev_ioctl_interrupt(struct kvm *kvm, struct kvm_interrupt *irq)
 	return 0;
 }
 
-static int kvm_dev_ioctl_debug_guest(struct kvm *kvm,
+static int kvm_vm_ioctl_debug_guest(struct kvm *kvm,
 				     struct kvm_debug_guest *dbg)
 {
 	struct kvm_vcpu *vcpu;
@@ -1973,7 +1973,7 @@ static long kvm_vm_ioctl(struct file *filp,
 
 	switch (ioctl) {
 	case KVM_CREATE_VCPU:
-		r = kvm_dev_ioctl_create_vcpu(kvm, arg);
+		r = kvm_vm_ioctl_create_vcpu(kvm, arg);
 		if (r)
 			goto out;
 		break;
@@ -1983,7 +1983,7 @@ static long kvm_vm_ioctl(struct file *filp,
 		r = -EFAULT;
 		if (copy_from_user(&kvm_run, argp, sizeof kvm_run))
 			goto out;
-		r = kvm_dev_ioctl_run(kvm, &kvm_run);
+		r = kvm_vm_ioctl_run(kvm, &kvm_run);
 		if (r < 0 &&  r != -EINTR)
 			goto out;
 		if (copy_to_user(argp, &kvm_run, sizeof kvm_run)) {
@@ -1998,7 +1998,7 @@ static long kvm_vm_ioctl(struct file *filp,
 		r = -EFAULT;
 		if (copy_from_user(&kvm_regs, argp, sizeof kvm_regs))
 			goto out;
-		r = kvm_dev_ioctl_get_regs(kvm, &kvm_regs);
+		r = kvm_vm_ioctl_get_regs(kvm, &kvm_regs);
 		if (r)
 			goto out;
 		r = -EFAULT;
@@ -2013,7 +2013,7 @@ static long kvm_vm_ioctl(struct file *filp,
 		r = -EFAULT;
 		if (copy_from_user(&kvm_regs, argp, sizeof kvm_regs))
 			goto out;
-		r = kvm_dev_ioctl_set_regs(kvm, &kvm_regs);
+		r = kvm_vm_ioctl_set_regs(kvm, &kvm_regs);
 		if (r)
 			goto out;
 		r = 0;
@@ -2025,7 +2025,7 @@ static long kvm_vm_ioctl(struct file *filp,
 		r = -EFAULT;
 		if (copy_from_user(&kvm_sregs, argp, sizeof kvm_sregs))
 			goto out;
-		r = kvm_dev_ioctl_get_sregs(kvm, &kvm_sregs);
+		r = kvm_vm_ioctl_get_sregs(kvm, &kvm_sregs);
 		if (r)
 			goto out;
 		r = -EFAULT;
@@ -2040,7 +2040,7 @@ static long kvm_vm_ioctl(struct file *filp,
 		r = -EFAULT;
 		if (copy_from_user(&kvm_sregs, argp, sizeof kvm_sregs))
 			goto out;
-		r = kvm_dev_ioctl_set_sregs(kvm, &kvm_sregs);
+		r = kvm_vm_ioctl_set_sregs(kvm, &kvm_sregs);
 		if (r)
 			goto out;
 		r = 0;
@@ -2052,7 +2052,7 @@ static long kvm_vm_ioctl(struct file *filp,
 		r = -EFAULT;
 		if (copy_from_user(&tr, argp, sizeof tr))
 			goto out;
-		r = kvm_dev_ioctl_translate(kvm, &tr);
+		r = kvm_vm_ioctl_translate(kvm, &tr);
 		if (r)
 			goto out;
 		r = -EFAULT;
@@ -2067,7 +2067,7 @@ static long kvm_vm_ioctl(struct file *filp,
 		r = -EFAULT;
 		if (copy_from_user(&irq, argp, sizeof irq))
 			goto out;
-		r = kvm_dev_ioctl_interrupt(kvm, &irq);
+		r = kvm_vm_ioctl_interrupt(kvm, &irq);
 		if (r)
 			goto out;
 		r = 0;
@@ -2079,7 +2079,7 @@ static long kvm_vm_ioctl(struct file *filp,
 		r = -EFAULT;
 		if (copy_from_user(&dbg, argp, sizeof dbg))
 			goto out;
-		r = kvm_dev_ioctl_debug_guest(kvm, &dbg);
+		r = kvm_vm_ioctl_debug_guest(kvm, &dbg);
 		if (r)
 			goto out;
 		r = 0;
@@ -2091,7 +2091,7 @@ static long kvm_vm_ioctl(struct file *filp,
 		r = -EFAULT;
 		if (copy_from_user(&kvm_mem, argp, sizeof kvm_mem))
 			goto out;
-		r = kvm_dev_ioctl_set_memory_region(kvm, &kvm_mem);
+		r = kvm_vm_ioctl_set_memory_region(kvm, &kvm_mem);
 		if (r)
 			goto out;
 		break;
@@ -2102,7 +2102,7 @@ static long kvm_vm_ioctl(struct file *filp,
 		r = -EFAULT;
 		if (copy_from_user(&log, argp, sizeof log))
 			goto out;
-		r = kvm_dev_ioctl_get_dirty_log(kvm, &log);
+		r = kvm_vm_ioctl_get_dirty_log(kvm, &log);
 		if (r)
 			goto out;
 		break;
