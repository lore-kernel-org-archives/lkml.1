Return-Path: <linux-kernel-owner+w=401wt.eu-S1750838AbXBSKXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750838AbXBSKXy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 05:23:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750839AbXBSKXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 05:23:54 -0500
Received: from il.qumranet.com ([82.166.9.18]:58933 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838AbXBSKXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 05:23:53 -0500
Subject: [PATCH 3/13] KVM: Cosmetics
From: Avi Kivity <avi@qumranet.com>
Date: Mon, 19 Feb 2007 10:23:51 -0000
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, mingo@elte.hu
References: <45D979D3.2020907@qumranet.com>
In-Reply-To: <45D979D3.2020907@qumranet.com>
Content-Type: text/plain; charset=UTF-8
Message-Id: <20070219102351.AD3C025016B@il.qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@qumranet.com>

Index: linux-2.6/drivers/kvm/kvm_main.c
===================================================================
--- linux-2.6.orig/drivers/kvm/kvm_main.c
+++ linux-2.6/drivers/kvm/kvm_main.c
@@ -126,10 +126,8 @@ static inline int valid_vcpu(int n)
 	return likely(n >= 0 && n < KVM_MAX_VCPUS);
 }
 
-int kvm_read_guest(struct kvm_vcpu *vcpu,
-			     gva_t addr,
-			     unsigned long size,
-			     void *dest)
+int kvm_read_guest(struct kvm_vcpu *vcpu, gva_t addr, unsigned long size,
+		   void *dest)
 {
 	unsigned char *host_buf = dest;
 	unsigned long req_size = size;
@@ -161,10 +159,8 @@ int kvm_read_guest(struct kvm_vcpu *vcpu
 }
 EXPORT_SYMBOL_GPL(kvm_read_guest);
 
-int kvm_write_guest(struct kvm_vcpu *vcpu,
-			     gva_t addr,
-			     unsigned long size,
-			     void *data)
+int kvm_write_guest(struct kvm_vcpu *vcpu, gva_t addr, unsigned long size,
+		    void *data)
 {
 	unsigned char *host_buf = data;
 	unsigned long req_size = size;
@@ -457,7 +453,7 @@ EXPORT_SYMBOL_GPL(set_cr4);
 void set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 {
 	if (is_long_mode(vcpu)) {
-		if ( cr3 & CR3_L_MODE_RESEVED_BITS) {
+		if (cr3 & CR3_L_MODE_RESEVED_BITS) {
 			printk(KERN_DEBUG "set_cr3: #GP, reserved bits\n");
 			inject_gp(vcpu);
 			return;
@@ -774,7 +770,6 @@ static int kvm_dev_ioctl_get_dirty_log(s
 	if (copy_to_user(log->dirty_bitmap, memslot->dirty_bitmap, n))
 		goto out;
 
-
 	if (any) {
 		cleared = 0;
 		for (i = 0; i < KVM_MAX_VCPUS; ++i) {
@@ -903,8 +898,9 @@ static int emulator_read_emulated(unsign
 		return X86EMUL_CONTINUE;
 	else {
 		gpa_t gpa = vcpu->mmu.gva_to_gpa(vcpu, addr);
+
 		if (gpa == UNMAPPED_GVA)
-			return vcpu_printf(vcpu, "not present\n"), X86EMUL_PROPAGATE_FAULT;
+			return X86EMUL_PROPAGATE_FAULT;
 		vcpu->mmio_needed = 1;
 		vcpu->mmio_phys_addr = gpa;
 		vcpu->mmio_size = bytes;
@@ -1801,12 +1797,11 @@ static long kvm_dev_ioctl(struct file *f
 	case KVM_GET_API_VERSION:
 		r = KVM_API_VERSION;
 		break;
-	case KVM_CREATE_VCPU: {
+	case KVM_CREATE_VCPU:
 		r = kvm_dev_ioctl_create_vcpu(kvm, arg);
 		if (r)
 			goto out;
 		break;
-	}
 	case KVM_RUN: {
 		struct kvm_run kvm_run;
 
Index: linux-2.6/drivers/kvm/svm.c
===================================================================
--- linux-2.6.orig/drivers/kvm/svm.c
+++ linux-2.6/drivers/kvm/svm.c
@@ -1042,22 +1042,22 @@ static int io_interception(struct kvm_vc
 
 		addr_mask = io_adress(vcpu, _in, &kvm_run->io.address);
 		if (!addr_mask) {
-			printk(KERN_DEBUG "%s: get io address failed\n", __FUNCTION__);
+			printk(KERN_DEBUG "%s: get io address failed\n",
+			       __FUNCTION__);
 			return 1;
 		}
 
 		if (kvm_run->io.rep) {
-			kvm_run->io.count = vcpu->regs[VCPU_REGS_RCX] & addr_mask;
+			kvm_run->io.count
+				= vcpu->regs[VCPU_REGS_RCX] & addr_mask;
 			kvm_run->io.string_down = (vcpu->svm->vmcb->save.rflags
 						   & X86_EFLAGS_DF) != 0;
 		}
-	} else {
+	} else
 		kvm_run->io.value = vcpu->svm->vmcb->save.rax;
-	}
 	return 0;
 }
 
-
 static int nop_on_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	return 1;
Index: linux-2.6/drivers/kvm/vmx.c
===================================================================
--- linux-2.6.orig/drivers/kvm/vmx.c
+++ linux-2.6/drivers/kvm/vmx.c
@@ -27,7 +27,6 @@
 
 #include "segment_descriptor.h"
 
-
 MODULE_AUTHOR("Qumranet");
 MODULE_LICENSE("GPL");
 
@@ -418,10 +417,9 @@ static int vmx_set_msr(struct kvm_vcpu *
 	case MSR_IA32_SYSENTER_ESP:
 		vmcs_write32(GUEST_SYSENTER_ESP, data);
 		break;
-	case MSR_IA32_TIME_STAMP_COUNTER: {
+	case MSR_IA32_TIME_STAMP_COUNTER:
 		guest_write_tsc(data);
 		break;
-	}
 	default:
 		msr = find_msr_entry(vcpu, msr_index);
 		if (msr) {
Index: linux-2.6/drivers/kvm/paging_tmpl.h
===================================================================
--- linux-2.6.orig/drivers/kvm/paging_tmpl.h
+++ linux-2.6/drivers/kvm/paging_tmpl.h
@@ -441,9 +441,8 @@ static int FNAME(page_fault)(struct kvm_
 	/*
 	 * mmio: emulate if accessible, otherwise its a guest fault.
 	 */
-	if (is_io_pte(*shadow_pte)) {
+	if (is_io_pte(*shadow_pte))
 		return 1;
-	}
 
 	++kvm_stat.pf_fixed;
 	kvm_mmu_audit(vcpu, "post page fault (fixed)");
