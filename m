Return-Path: <linux-kernel-owner+w=401wt.eu-S1752712AbZHSNNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbZHSNNn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:13:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbZHSNMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:12:53 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50553 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751906AbZHSNCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:02:46 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 10/47] KVM: MMU: make for_each_shadow_entry aware of largepages
Date: Wed, 19 Aug 2009 16:02:06 +0300
Message-Id: <1250686963-8357-11-git-send-email-avi@redhat.com>
In-Reply-To: <1250686963-8357-1-git-send-email-avi@redhat.com>
References: <1250686963-8357-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

This way there is no need to add explicit checks in every
for_each_shadow_entry user.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/mmu.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 780ce3f..e18f65b 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1302,6 +1302,11 @@ static bool shadow_walk_okay(struct kvm_shadow_walk_iterator *iterator)
 {
 	if (iterator->level < PT_PAGE_TABLE_LEVEL)
 		return false;
+
+	if (iterator->level == PT_PAGE_TABLE_LEVEL)
+		if (is_large_pte(*iterator->sptep))
+			return false;
+
 	iterator->index = SHADOW_PT_INDEX(iterator->addr, iterator->level);
 	iterator->sptep	= ((u64 *)__va(iterator->shadow_addr)) + iterator->index;
 	return true;
-- 
1.6.3.3

