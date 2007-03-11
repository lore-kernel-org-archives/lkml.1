Return-Path: <linux-kernel-owner+w=401wt.eu-S1752369AbXCKNzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369AbXCKNzE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 09:55:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbXCKNyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 09:54:39 -0400
Received: from il.qumranet.com ([82.166.9.18]:43431 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752341AbXCKNxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 09:53:30 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@osdl.org>, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 05/15] KVM: Remove the 'emulated' field from the userspace interface
Date: Sun, 11 Mar 2007 15:53:17 +0200
Message-Id: <11736212073022-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.2
In-Reply-To: <11736212072915-git-send-email-avi@qumranet.com>
References: <11736212072915-git-send-email-avi@qumranet.com>
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
index 347467e..747966e 100644
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
1.5.0.2

