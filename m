Return-Path: <linux-kernel-owner+w=401wt.eu-S1752246AbXBFQEE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246AbXBFQEE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 11:04:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752233AbXBFQEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 11:04:04 -0500
Received: from nz-out-0506.google.com ([64.233.162.232]:57604 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbXBFQEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 11:04:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=lmOqhOItBzUefqMvrVmIkFYuukHu3TMs/UR08PiWF4iLh2jJqM5XB5y+vYdA/tdy/w83PNFBGjrlUkxY21Gg51w6qDge20wrIpXWOkXgwKjAPIpYFkE8957VsJpL9u5eH8vn0/qeikAy678J31iFVc+hud04+xiPOOPchy9MEQA=
Date: Tue, 6 Feb 2007 18:03:48 +0200
To: avi@qumranet.com
Cc: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 2.6.20] KVM: Use ARRAY_SIZE macro when appropriate
Message-ID: <20070206160348.GC8991@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070206160204.GA8991@Ahmed>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

A patch to use ARRAY_SIZE macro already defined in kernel.h

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---
diff --git a/drivers/kvm/kvm_svm.h b/drivers/kvm/kvm_svm.h
index 74cc862..624f1ca 100644
--- a/drivers/kvm/kvm_svm.h
+++ b/drivers/kvm/kvm_svm.h
@@ -1,6 +1,7 @@
 #ifndef __KVM_SVM_H
 #define __KVM_SVM_H
 
+#include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/list.h>
 #include <asm/msr.h>
@@ -18,7 +19,7 @@ static const u32 host_save_msrs[] = {
 	MSR_IA32_LASTBRANCHTOIP, MSR_IA32_LASTINTFROMIP,MSR_IA32_LASTINTTOIP,*/
 };
 
-#define NR_HOST_SAVE_MSRS (sizeof(host_save_msrs) / sizeof(*host_save_msrs))
+#define NR_HOST_SAVE_MSRS ARRAY_SIZE(host_save_msrs)
 #define NUM_DB_REGS 4
 
 struct vcpu_svm {
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index c79df79..dc5c172 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -15,6 +15,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/kernel.h>
 #include <linux/vmalloc.h>
 #include <linux/highmem.h>
 #include <linux/profile.h>
@@ -75,7 +76,7 @@ struct svm_init_data {
 
 static u32 msrpm_ranges[] = {0, 0xc0000000, 0xc0010000};
 
-#define NUM_MSR_MAPS (sizeof(msrpm_ranges) / sizeof(*msrpm_ranges))
+#define NUM_MSR_MAPS ARRAY_SIZE(msrpm_ranges)
 #define MSRS_RANGE_SIZE 2048
 #define MSRS_IN_RANGE (MSRS_RANGE_SIZE * 8 / 2)
 
@@ -1287,7 +1288,7 @@ static int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		       __FUNCTION__, vcpu->svm->vmcb->control.exit_int_info,
 		       exit_code);
 
-	if (exit_code >= sizeof(svm_exit_handlers) / sizeof(*svm_exit_handlers)
+	if (exit_code >= ARRAY_SIZE(svm_exit_handlers)
 	    || svm_exit_handlers[exit_code] == 0) {
 		kvm_run->exit_reason = KVM_EXIT_UNKNOWN;
 		printk(KERN_ERR "%s: 0x%x @ 0x%llx cr0 0x%lx rflags 0x%llx\n",
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 54c35c0..072965b 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -19,6 +19,7 @@
 #include "vmx.h"
 #include "kvm_vmx.h"
 #include <linux/module.h>
+#include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/highmem.h>
 #include <linux/profile.h>
@@ -76,7 +77,7 @@ static const u32 vmx_msr_index[] = {
 #endif
 	MSR_EFER, MSR_K6_STAR,
 };
-#define NR_VMX_MSR (sizeof(vmx_msr_index) / sizeof(*vmx_msr_index))
+#define NR_VMX_MSR ARRAY_SIZE(vmx_msr_index)
 
 static inline int is_page_fault(u32 intr_info)
 {
@@ -1645,8 +1646,7 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu,
 	[EXIT_REASON_HLT]                     = handle_halt,
 };
 
-static const int kvm_vmx_max_exit_handlers =
-	sizeof(kvm_vmx_exit_handlers) / sizeof(*kvm_vmx_exit_handlers);
+static const int kvm_vmx_max_exit_handlers = ARRAY_SIZE(kvm_vmx_exit_handlers);
 
 /*
  * The guest has exited.  See if we can fix it or if we need userspace


-- 
Ahmed S. Darwish
http://darwish-07.blogspot.com
