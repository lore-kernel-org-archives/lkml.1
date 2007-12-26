Return-Path: <linux-kernel-owner+w=401wt.eu-S1753390AbXLZLJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbXLZLJj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:09:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752500AbXLZLGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:06:25 -0500
Received: from il.qumranet.com ([82.166.9.18]:50469 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751696AbXLZLGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:06:05 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 17/55] KVM: MMU: Topup the mmu memory preallocation caches before emulating an insn
Date: Wed, 26 Dec 2007 13:05:22 +0200
Message-Id: <1198667160-22953-18-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198667160-22953-1-git-send-email-avi@qumranet.com>
References: <1198667160-22953-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Emulation may cause a shadow pte to be instantiated, which requires
memory resources.  Make sure the caches are filled to avoid an oops.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/mmu.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index ace3cb8..9be54a5 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -1362,6 +1362,10 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u32 error_code)
 		goto out;
 	}
 
+	r = mmu_topup_memory_caches(vcpu);
+	if (r)
+		goto out;
+
 	er = emulate_instruction(vcpu, vcpu->run, cr2, error_code, 0);
 	mutex_unlock(&vcpu->kvm->lock);
 
-- 
1.5.3.7

