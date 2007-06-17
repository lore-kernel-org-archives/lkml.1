Return-Path: <linux-kernel-owner+w=401wt.eu-S1760738AbXFQJ7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760738AbXFQJ7E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 05:59:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759716AbXFQJpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:45:34 -0400
Received: from il.qumranet.com ([82.166.9.18]:55176 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759463AbXFQJou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:50 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Shani Moideen <shani.moideen@wipro.com>,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH 55/58] KVM: SVM: Replace memset(<addr>, 0, PAGESIZE) with clear_page(<addr>)
Date: Sun, 17 Jun 2007 12:44:36 +0300
Message-Id: <1182073481246-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1182073479890-git-send-email-avi@qumranet.com>
References: <1182073479890-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shani Moideen <shani.moideen@wipro.com>

Signed-off-by: Shani Moideen <shani.moideen@wipro.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/svm.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index eb175c5..68841ef 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -581,7 +581,7 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 		goto out2;
 
 	vcpu->svm->vmcb = page_address(page);
-	memset(vcpu->svm->vmcb, 0, PAGE_SIZE);
+	clear_page(vcpu->svm->vmcb);
 	vcpu->svm->vmcb_pa = page_to_pfn(page) << PAGE_SHIFT;
 	vcpu->svm->asid_generation = 0;
 	memset(vcpu->svm->db_regs, 0, sizeof(vcpu->svm->db_regs));
@@ -957,7 +957,7 @@ static int shutdown_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	 * VMCB is undefined after a SHUTDOWN intercept
 	 * so reinitialize it.
 	 */
-	memset(vcpu->svm->vmcb, 0, PAGE_SIZE);
+	clear_page(vcpu->svm->vmcb);
 	init_vmcb(vcpu->svm->vmcb);
 
 	kvm_run->exit_reason = KVM_EXIT_SHUTDOWN;
-- 
1.5.0.6

