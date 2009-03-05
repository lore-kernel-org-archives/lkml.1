Return-Path: <linux-kernel-owner+w=401wt.eu-S1755876AbZCEMOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876AbZCEMOo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 07:14:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754413AbZCEMNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 07:13:07 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:45553 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753304AbZCEMM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 07:12:56 -0500
X-BigFish: VPS11(z1857rzzzzzz32i62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KG18L5-02-DEG-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6/6] kvm/x86/mmu: include PT_PAGE_SIZE_MASK in PT64_PERM_MASK
Date: Thu, 5 Mar 2009 13:12:33 +0100
Message-ID: <1236255153-4432-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1236255153-4432-1-git-send-email-joerg.roedel@amd.com>
References: <1236255153-4432-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 05 Mar 2009 12:12:33.0858 (UTC) FILETIME=[AA37FA20:01C99D8B]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We also need to do a remote tlb flush if the PSE bit changes. The
pte_pfn should also change if this bit changes but we can't rely on
that. So check this bit too to be on the save side.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/mmu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 2a36f7f..055b181 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -121,7 +121,7 @@ module_param(oos_shadow, bool, 0644);
 	(PAGE_MASK & ~((1ULL << (PAGE_SHIFT + PT32_LEVEL_BITS)) - 1))
 
 #define PT64_PERM_MASK (PT_PRESENT_MASK | PT_WRITABLE_MASK | PT_USER_MASK \
-			| PT64_NX_MASK)
+			| PT64_NX_MASK | PT_PAGE_SIZE_MASK)
 
 #define PFERR_PRESENT_MASK (1U << 0)
 #define PFERR_WRITE_MASK (1U << 1)
-- 
1.5.6.4


