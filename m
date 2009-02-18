Return-Path: <linux-kernel-owner+w=401wt.eu-S1754300AbZBRNZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300AbZBRNZA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 08:25:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753459AbZBRNYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 08:24:31 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:6673 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753396AbZBRNYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 08:24:30 -0500
X-BigFish: VPS3(zzzzzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KF9J74-04-E9O-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 3/3] kvm mmu: alloc shadow pages with __GFP_ZERO
Date: Wed, 18 Feb 2009 14:09:00 +0100
Message-ID: <1234962540-7131-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1234962540-7131-1-git-send-email-joerg.roedel@amd.com>
References: <1234962540-7131-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 18 Feb 2009 13:09:00.0226 (UTC) FILETIME=[10747A20:01C991CA]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not using __GFP_ZERO when allocating shadow pages triggers the
assertion in the kvm_mmu_alloc_page() when MMU debugging is enabled.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/mmu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index c90b4b2..d93ecec 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -301,7 +301,7 @@ static int mmu_topup_memory_cache_page(struct kvm_mmu_memory_cache *cache,
 	if (cache->nobjs >= min)
 		return 0;
 	while (cache->nobjs < ARRAY_SIZE(cache->objects)) {
-		page = alloc_page(GFP_KERNEL);
+		page = alloc_page(GFP_KERNEL | __GFP_ZERO);
 		if (!page)
 			return -ENOMEM;
 		set_page_private(page, 0);
-- 
1.5.6.4


