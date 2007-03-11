Return-Path: <linux-kernel-owner+w=401wt.eu-S933567AbXCKNxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933567AbXCKNxa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 09:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbXCKNxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 09:53:30 -0400
Received: from il.qumranet.com ([82.166.9.18]:43423 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752259AbXCKNx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 09:53:29 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@osdl.org>, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 03/15] KVM: Initialize PIO I/O count
Date: Sun, 11 Mar 2007 15:53:15 +0200
Message-Id: <1173621207798-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.2
In-Reply-To: <11736212072915-git-send-email-avi@qumranet.com>
References: <11736212072915-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This allows userspace to ignore the io.rep field.  No a big deal, but
friendly.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/svm.c |    1 +
 drivers/kvm/vmx.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index b176f5a..c35b8c8 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -1037,6 +1037,7 @@ static int io_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	kvm_run->io.size = ((io_info & SVM_IOIO_SIZE_MASK) >> SVM_IOIO_SIZE_SHIFT);
 	kvm_run->io.string = (io_info & SVM_IOIO_STR_MASK) != 0;
 	kvm_run->io.rep = (io_info & SVM_IOIO_REP_MASK) != 0;
+	kvm_run->io.count = 1;
 
 	if (kvm_run->io.string) {
 		unsigned addr_mask;
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 7fd572a..d4c9f33 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -1459,6 +1459,7 @@ static int handle_io(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		= (vmcs_readl(GUEST_RFLAGS) & X86_EFLAGS_DF) != 0;
 	kvm_run->io.rep = (exit_qualification & 32) != 0;
 	kvm_run->io.port = exit_qualification >> 16;
+	kvm_run->io.count = 1;
 	if (kvm_run->io.string) {
 		if (!get_io_count(vcpu, &kvm_run->io.count))
 			return 1;
-- 
1.5.0.2

