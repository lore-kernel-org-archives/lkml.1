Return-Path: <linux-kernel-owner+w=401wt.eu-S1757243AbXIQI6E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243AbXIQI6E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:58:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754924AbXIQIdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:33:42 -0400
Received: from il.qumranet.com ([82.166.9.18]:45259 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754460AbXIQIce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:34 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 083/104] KVM: Remove the unused invlpg member of struct kvm_arch_ops.
Date: Mon, 17 Sep 2007 10:32:05 +0200
Message-Id: <11900179491596-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h |    1 -
 drivers/kvm/svm.c |    6 ------
 2 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 5e318b6..7c35352 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -487,7 +487,6 @@ struct kvm_arch_ops {
 	unsigned long (*get_rflags)(struct kvm_vcpu *vcpu);
 	void (*set_rflags)(struct kvm_vcpu *vcpu, unsigned long rflags);
 
-	void (*invlpg)(struct kvm_vcpu *vcpu, gva_t addr);
 	void (*tlb_flush)(struct kvm_vcpu *vcpu);
 	void (*inject_page_fault)(struct kvm_vcpu *vcpu,
 				  unsigned long addr, u32 err_code);
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 3de9ec3..dbd4e81 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -881,11 +881,6 @@ static void new_asid(struct vcpu_svm *svm, struct svm_cpu_data *svm_data)
 	svm->vmcb->control.asid = svm_data->next_asid++;
 }
 
-static void svm_invlpg(struct kvm_vcpu *vcpu, gva_t address)
-{
-	invlpga(address, to_svm(vcpu)->vmcb->control.asid); // is needed?
-}
-
 static unsigned long svm_get_dr(struct kvm_vcpu *vcpu, int dr)
 {
 	return to_svm(vcpu)->db_regs[dr];
@@ -1795,7 +1790,6 @@ static struct kvm_arch_ops svm_arch_ops = {
 	.get_rflags = svm_get_rflags,
 	.set_rflags = svm_set_rflags,
 
-	.invlpg = svm_invlpg,
 	.tlb_flush = svm_flush_tlb,
 	.inject_page_fault = svm_inject_page_fault,
 
-- 
1.5.3

