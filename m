Return-Path: <linux-kernel-owner+w=401wt.eu-S933786AbXDZJ1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933786AbXDZJ1s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 05:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933769AbXDZJ1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 05:27:14 -0400
Received: from il.qumranet.com ([82.166.9.18]:53031 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933786AbXDZJW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 05:22:26 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 07/18] KVM: SVM: Report hardware exit reason to userspace instead of dmesg
Date: Thu, 26 Apr 2007 12:22:07 +0300
Message-Id: <117757933872-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11775793382353-git-send-email-avi@qumranet.com>
References: <11775793382353-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/svm.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index c9b700d..61ed735 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -1332,12 +1332,7 @@ static int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	if (exit_code >= ARRAY_SIZE(svm_exit_handlers)
 	    || svm_exit_handlers[exit_code] == 0) {
 		kvm_run->exit_reason = KVM_EXIT_UNKNOWN;
-		printk(KERN_ERR "%s: 0x%x @ 0x%llx cr0 0x%lx rflags 0x%llx\n",
-		       __FUNCTION__,
-		       exit_code,
-		       vcpu->svm->vmcb->save.rip,
-		       vcpu->cr0,
-		       vcpu->svm->vmcb->save.rflags);
+		kvm_run->hw.hardware_exit_reason = exit_code;
 		return 0;
 	}
 
-- 
1.5.0.6

