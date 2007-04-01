Return-Path: <linux-kernel-owner+w=401wt.eu-S933102AbXDAOtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933102AbXDAOtc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 10:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933131AbXDAOtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 10:49:08 -0400
Received: from il.qumranet.com ([82.166.9.18]:47550 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933089AbXDAOfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 10:35:42 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 09/41] KVM: Remove the 'emulated' field from the userspace interface
Date: Sun,  1 Apr 2007 17:35:06 +0300
Message-Id: <1175438139494-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.5
In-Reply-To: <1175438139242-git-send-email-avi@qumranet.com>
References: <1175438138288-git-send-email-avi@qumranet.com> <11754381381990-git-send-email-avi@qumranet.com> <11754381384009-git-send-email-avi@qumranet.com> <1175438138805-git-send-email-avi@qumranet.com> <11754381382515-git-send-email-avi@qumranet.com> <11754381383730-git-send-email-avi@qumranet.com> <11754381383144-git-send-email-avi@qumranet.com> <11754381381597-git-send-email-avi@qumranet.com> <1175438139242-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We no longer emulate single instructions in userspace.  Instead, we service
mmio or pio requests.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |    5 -----
 include/linux/kvm.h    |    3 +--
 2 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index caec54f..5d24203 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -1588,11 +1588,6 @@ static int kvm_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	/* re-sync apic's tpr */
 	vcpu->cr8 = kvm_run->cr8;
 
-	if (kvm_run->emulated) {
-		kvm_arch_ops->skip_emulated_instruction(vcpu);
-		kvm_run->emulated = 0;
-	}
-
 	if (kvm_run->io_completed) {
 		if (vcpu->pio_pending)
 			complete_pio(vcpu);
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 15e23bc..c6dd4a7 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -51,10 +51,9 @@ enum kvm_exit_reason {
 /* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
 struct kvm_run {
 	/* in */
-	__u32 emulated;  /* skip current instruction */
 	__u32 io_completed; /* mmio/pio request completed */
 	__u8 request_interrupt_window;
-	__u8 padding1[7];
+	__u8 padding1[3];
 
 	/* out */
 	__u32 exit_type;
-- 
1.5.0.5

