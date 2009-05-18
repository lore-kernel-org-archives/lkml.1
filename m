Return-Path: <linux-kernel-owner+w=401wt.eu-S1757818AbZERJcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757818AbZERJcf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 05:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756338AbZERJXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 05:23:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38411 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753709AbZERJXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 05:23:09 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 19/43] KVM: MMU: remove call to kvm_mmu_pte_write from walk_addr
Date: Mon, 18 May 2009 12:22:41 +0300
Message-Id: <1242638585-18470-20-git-send-email-avi@redhat.com>
In-Reply-To: <1242638585-18470-1-git-send-email-avi@redhat.com>
References: <1242638585-18470-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

There is no reason to update the shadow pte here because the guest pte
is only changed to dirty state.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/paging_tmpl.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 6bd7020..855eb71 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -209,7 +209,6 @@ walk:
 		if (ret)
 			goto walk;
 		pte |= PT_DIRTY_MASK;
-		kvm_mmu_pte_write(vcpu, pte_gpa, (u8 *)&pte, sizeof(pte), 0);
 		walker->ptes[walker->level - 1] = pte;
 	}
 
-- 
1.6.0.6

