Return-Path: <linux-kernel-owner+w=401wt.eu-S1753365AbXJULJD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbXJULJD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 07:09:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751554AbXJULH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 07:07:57 -0400
Received: from il.qumranet.com ([82.166.9.18]:58411 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460AbXJULHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 07:07:53 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Izik Eidus <izike@qumranet.com>,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH 03/11] KVM: MMU: Set shadow pte atomically in mmu_pte_write_zap_pte()
Date: Sun, 21 Oct 2007 13:08:04 +0200
Message-Id: <1192964892875-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <1192964892617-git-send-email-avi@qumranet.com>
References: <1192964892617-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Izik Eidus <izike@qumranet.com>

Setting shadow page table entry should be set atomicly using set_shadow_pte().

Signed-off-by: Izik Eidus <izike@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/mmu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index 6d84d30..7171618 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -1088,7 +1088,7 @@ static void mmu_pte_write_zap_pte(struct kvm_vcpu *vcpu,
 			mmu_page_remove_parent_pte(child, spte);
 		}
 	}
-	*spte = 0;
+	set_shadow_pte(spte, 0);
 	kvm_flush_remote_tlbs(vcpu->kvm);
 }
 
-- 
1.5.3

