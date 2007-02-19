Return-Path: <linux-kernel-owner+w=401wt.eu-S1750842AbXBSKZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750842AbXBSKZy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 05:25:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750844AbXBSKZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 05:25:54 -0500
Received: from il.qumranet.com ([82.166.9.18]:35429 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840AbXBSKZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 05:25:53 -0500
Subject: [PATCH 5/13] KVM: Use ARRAY_SIZE macro instead of manual calculation.
From: Avi Kivity <avi@qumranet.com>
Date: Mon, 19 Feb 2007 10:25:51 -0000
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, mingo@elte.hu
References: <45D979D3.2020907@qumranet.com>
In-Reply-To: <45D979D3.2020907@qumranet.com>
Content-Type: text/plain; charset=UTF-8
Message-Id: <20070219102551.EF9A725016B@il.qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ahmed S. Darwish <darwish.07@gmail.com>

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
Signed-off-by: Dor Laor <dor.laor@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>

Index: linux-2.6/drivers/kvm/svm.c
===================================================================
--- linux-2.6.orig/drivers/kvm/svm.c
+++ linux-2.6/drivers/kvm/svm.c
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
 
@@ -1297,7 +1298,7 @@ static int handle_exit(struct kvm_vcpu *
 		       __FUNCTION__, vcpu->svm->vmcb->control.exit_int_info,
 		       exit_code);
 
-	if (exit_code >= sizeof(svm_exit_handlers) / sizeof(*svm_exit_handlers)
+	if (exit_code >= ARRAY_SIZE(svm_exit_handlers)
 	    || svm_exit_handlers[exit_code] == 0) {
 		kvm_run->exit_reason = KVM_EXIT_UNKNOWN;
 		printk(KERN_ERR "%s: 0x%x @ 0x%llx cr0 0x%lx rflags 0x%llx\n",
Index: linux-2.6/drivers/kvm/vmx.c
===================================================================
--- linux-2.6.orig/drivers/kvm/vmx.c
+++ linux-2.6/drivers/kvm/vmx.c
@@ -19,6 +19,7 @@
 #include "vmx.h"
 #include "kvm_vmx.h"
 #include <linux/module.h>
+#include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/highmem.h>
 #include <linux/profile.h>
@@ -75,7 +76,7 @@ static const u32 vmx_msr_index[] = {
 #endif
 	MSR_EFER, MSR_K6_STAR,
 };
-#define NR_VMX_MSR (sizeof(vmx_msr_index) / sizeof(*vmx_msr_index))
+#define NR_VMX_MSR ARRAY_SIZE(vmx_msr_index)
 
 static inline int is_page_fault(u32 intr_info)
 {
Index: linux-2.6/drivers/kvm/kvm_svm.h
===================================================================
--- linux-2.6.orig/drivers/kvm/kvm_svm.h
+++ linux-2.6/drivers/kvm/kvm_svm.h
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
