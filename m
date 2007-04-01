Return-Path: <linux-kernel-owner+w=401wt.eu-S933331AbXDAOjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933331AbXDAOjr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 10:39:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933297AbXDAOjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 10:39:47 -0400
Received: from il.qumranet.com ([82.166.9.18]:47571 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933277AbXDAOfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 10:35:45 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 28/41] KVM: Remove unused and write-only variables
Date: Sun,  1 Apr 2007 17:35:25 +0300
Message-Id: <1175438139877-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.5
In-Reply-To: <11754381391993-git-send-email-avi@qumranet.com>
References: <1175438138288-git-send-email-avi@qumranet.com> <11754381381990-git-send-email-avi@qumranet.com> <11754381384009-git-send-email-avi@qumranet.com> <1175438138805-git-send-email-avi@qumranet.com> <11754381382515-git-send-email-avi@qumranet.com> <11754381383730-git-send-email-avi@qumranet.com> <11754381383144-git-send-email-avi@qumranet.com> <11754381381597-git-send-email-avi@qumranet.com> <1175438139242-git-send-email-avi@qumranet.com> <1175438139494-git-send-email-avi@qumranet.com> <11754381392046-git-send-email-avi@qumranet.com> <1175438139795-git-send-email-avi@qumranet.com> <1175438139430-git-send-email-avi@qumranet.com> <11754381393496-git-send-email-avi@qumranet.com> <11754381391514-git-send-email-avi@qumranet.com> <11754381392382-git-send-email-avi@qumranet.com> <11754381392358-git-send-email-avi@qumranet.com> <1175438139872-git-send-email-avi@qumranet.com> <11754381392921-git-send-email-avi@qumranet.com> <117543813978-git-send-email-avi@qumranet.com> <117543
 81393061-git-send-email-avi@qumranet.com> <11754381392186-git-send-email-avi@qumranet.com> <117543813916-git-send-email-avi@qumranet.com> <1175438139530-git-send-email-avi@qumranet.com> <1175438139960-git-send-email-avi@qumranet.com> <1175438139816-git-send-email-avi@qumranet.com> <1175438139141-git-send-email-avi@qumranet.com> <11754381391993-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial cleanup.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_svm.h |    2 --
 drivers/kvm/svm.c     |    2 --
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/kvm/kvm_svm.h b/drivers/kvm/kvm_svm.h
index 624f1ca..a1a9eba 100644
--- a/drivers/kvm/kvm_svm.h
+++ b/drivers/kvm/kvm_svm.h
@@ -28,8 +28,6 @@ struct vcpu_svm {
 	struct svm_cpu_data *svm_data;
 	uint64_t asid_generation;
 
-	unsigned long cr0;
-	unsigned long cr4;
 	unsigned long db_regs[NUM_DB_REGS];
 
 	u64 next_rip;
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 191bc45..ddc0505 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -576,7 +576,6 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 	vcpu->svm->vmcb = page_address(page);
 	memset(vcpu->svm->vmcb, 0, PAGE_SIZE);
 	vcpu->svm->vmcb_pa = page_to_pfn(page) << PAGE_SHIFT;
-	vcpu->svm->cr0 = 0x00000010;
 	vcpu->svm->asid_generation = 0;
 	memset(vcpu->svm->db_regs, 0, sizeof(vcpu->svm->db_regs));
 	init_vmcb(vcpu->svm->vmcb);
@@ -736,7 +735,6 @@ static void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 		}
 	}
 #endif
-	vcpu->svm->cr0 = cr0;
 	vcpu->cr0 = cr0;
 	cr0 |= CR0_PG_MASK | CR0_WP_MASK;
 	cr0 &= ~(CR0_CD_MASK | CR0_NW_MASK);
-- 
1.5.0.5

