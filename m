Return-Path: <linux-kernel-owner+w=401wt.eu-S1756203AbZCEMP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203AbZCEMP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 07:15:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755289AbZCEMNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 07:13:36 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:4313 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755250AbZCEMNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 07:13:34 -0500
X-BigFish: VPS1(zzzzzzz32i66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0KG18L4-01-8SG-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 3/6] kvm/x86/mmu: don't unnecessarily recalculate table_gfn in *fetch
Date: Thu, 5 Mar 2009 13:12:30 +0100
Message-ID: <1236255153-4432-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1236255153-4432-1-git-send-email-joerg.roedel@amd.com>
References: <1236255153-4432-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 05 Mar 2009 12:12:33.0796 (UTC) FILETIME=[AA2E8440:01C99D8B]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/paging_tmpl.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index a0c11ea..79668ba 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -315,7 +315,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 			direct = 1;
 			if (!is_dirty_pte(gw->ptes[level - 1]))
 				access &= ~ACC_WRITE_MASK;
-			table_gfn = gpte_to_gfn(gw->ptes[level - 1]);
+			table_gfn = gw->table_gfn[level - delta];
 		} else {
 			direct = 0;
 			table_gfn = gw->table_gfn[level - 2];
-- 
1.5.6.4


