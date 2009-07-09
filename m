Return-Path: <linux-kernel-owner+w=401wt.eu-S1761320AbZGIOgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761320AbZGIOgb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 10:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759701AbZGIOgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 10:36:24 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:19655 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759070AbZGIOgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 10:36:23 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KMIR7Z-04-GZP-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH] kvm/mmu: fix MMU_DEBUG compile breakage
Date: Thu, 9 Jul 2009 16:36:01 +0200
Message-ID: <1247150161-28052-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 09 Jul 2009 14:36:03.0245 (UTC) FILETIME=[95DCADD0:01CA00A2]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/mmu.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 231d880..7162651 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1786,8 +1786,8 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	pgprintk("%s: setting spte %llx\n", __func__, *sptep);
 	pgprintk("instantiating %s PTE (%s) at %ld (%llx) addr %p\n",
 		 is_large_pte(*sptep)? "2MB" : "4kB",
-		 is_present_pte(*sptep)?"RW":"R", gfn,
-		 *shadow_pte, sptep);
+		 *sptep & PT_PRESENT_MASK ?"RW":"R", gfn,
+		 *sptep, sptep);
 	if (!was_rmapped && is_large_pte(*sptep))
 		++vcpu->kvm->stat.lpages;
 
-- 
1.6.3.3


