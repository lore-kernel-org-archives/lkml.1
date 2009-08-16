Return-Path: <linux-kernel-owner+w=401wt.eu-S1754207AbZHPJaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbZHPJaa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 05:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbZHPJa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 05:30:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45378 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754112AbZHPJaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 05:30:15 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 42/48] KVM: MMU: Fix is_dirty_pte()
Date: Sun, 16 Aug 2009 12:30:02 +0300
Message-Id: <1250415008-17175-43-git-send-email-avi@redhat.com>
In-Reply-To: <1250415008-17175-1-git-send-email-avi@redhat.com>
References: <1250415008-17175-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

is_dirty_pte() is used on guest ptes, not shadow ptes, so it needs to avoid
shadow_dirty_mask and use PT_DIRTY_MASK instead.

Misdetecting dirty pages could lead to unnecessarily setting the dirty bit
under EPT.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/mmu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 8ee67e3..8f2cb29 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -242,7 +242,7 @@ static int is_writeble_pte(unsigned long pte)
 
 static int is_dirty_pte(unsigned long pte)
 {
-	return pte & shadow_dirty_mask;
+	return pte & PT_DIRTY_MASK;
 }
 
 static int is_rmap_pte(u64 pte)
-- 
1.6.3.3

