Return-Path: <linux-kernel-owner+w=401wt.eu-S1756513AbXD2PvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513AbXD2PvN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 11:51:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933334AbXD2Pux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 11:50:53 -0400
Received: from il.qumranet.com ([82.166.9.18]:34368 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756519AbXD2Pu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 11:50:26 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 7/7] KVM: Remove unused 'instruction_length'
Date: Sun, 29 Apr 2007 18:50:22 +0300
Message-Id: <1177861822130-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1177861822889-git-send-email-avi@qumranet.com>
References: <1177861822889-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As we no longer emulate in userspace, this is meaningless.  We don't
compute it on SVM anyway.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/vmx.c   |    1 -
 include/linux/kvm.h |    5 ++---
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 1d2b41b..74d058e 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -1783,7 +1783,6 @@ static int kvm_handle_exit(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 				exit_reason != EXIT_REASON_EXCEPTION_NMI )
 		printk(KERN_WARNING "%s: unexpected, valid vectoring info and "
 		       "exit reason is 0x%x\n", __FUNCTION__, exit_reason);
-	kvm_run->instruction_length = vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
 	if (exit_reason < kvm_vmx_max_exit_handlers
 	    && kvm_vmx_exit_handlers[exit_reason])
 		return kvm_vmx_exit_handlers[exit_reason](vcpu, kvm_run);
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 738c2f5..e6edca8 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -11,7 +11,7 @@
 #include <asm/types.h>
 #include <linux/ioctl.h>
 
-#define KVM_API_VERSION 11
+#define KVM_API_VERSION 12
 
 /*
  * Architectural interrupt line count, and the size of the bitmap needed
@@ -63,10 +63,9 @@ struct kvm_run {
 
 	/* out */
 	__u32 exit_reason;
-	__u32 instruction_length;
 	__u8 ready_for_interrupt_injection;
 	__u8 if_flag;
-	__u8 padding2[6];
+	__u8 padding2[2];
 
 	/* in (pre_kvm_run), out (post_kvm_run) */
 	__u64 cr8;
-- 
1.5.0.6

