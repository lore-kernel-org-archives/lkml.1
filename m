Return-Path: <linux-kernel-owner+w=401wt.eu-S1761158AbZB0Kfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761158AbZB0Kfx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 05:35:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758083AbZB0K2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 05:28:03 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53581 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755723AbZB0K1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 05:27:11 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 29/37] KVM: MMU: drop zeroing on mmu_memory_cache_alloc
Date: Fri, 27 Feb 2009 12:26:52 +0200
Message-Id: <1235730420-7929-30-git-send-email-avi@redhat.com>
In-Reply-To: <1235730420-7929-1-git-send-email-avi@redhat.com>
References: <1235730420-7929-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Zeroing on mmu_memory_cache_alloc is unnecessary since:

- Smaller areas are pre-allocated with kmem_cache_zalloc.
- Page pointed by ->spt is overwritten with prefetch_page
  and entries in page pointed by ->gfns are initialized
  before reading.

[avi: zeroing pages is unnecessary]

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/mmu.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index aac0499..de9a9fb 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -352,7 +352,6 @@ static void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc,
 
 	BUG_ON(!mc->nobjs);
 	p = mc->objects[--mc->nobjs];
-	memset(p, 0, size);
 	return p;
 }
 
-- 
1.6.0.6

