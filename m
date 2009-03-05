Return-Path: <linux-kernel-owner+w=401wt.eu-S1755120AbZCEMNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120AbZCEMNa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 07:13:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbZCEMMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 07:12:54 -0500
Received: from wa4ehsobe005.messaging.microsoft.com ([216.32.181.15]:59320
	"EHLO WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752890AbZCEMMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 07:12:52 -0500
X-BigFish: VPS11(z1857rzzzzzz32i66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0KG18L3-01-8SF-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/6] kvm/x86/mmu: remove call to kvm_mmu_pte_write from walk_addr
Date: Thu, 5 Mar 2009 13:12:29 +0100
Message-ID: <1236255153-4432-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1236255153-4432-1-git-send-email-joerg.roedel@amd.com>
References: <1236255153-4432-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 05 Mar 2009 12:12:33.0718 (UTC) FILETIME=[AA229D60:01C99D8B]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no reason to update the shadow pte here because the guest pte
is only changed to dirty state.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/paging_tmpl.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 0f11792..a0c11ea 100644
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
1.5.6.4


