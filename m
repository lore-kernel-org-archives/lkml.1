Return-Path: <linux-kernel-owner+w=401wt.eu-S1755342AbYIYMES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbYIYMES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 08:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754841AbYIYL4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 07:56:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48606 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754681AbYIYL4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 07:56:16 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 32/39] KVM: MMU: Account for npt/ept/realmode page faults
Date: Thu, 25 Sep 2008 14:55:04 +0300
Message-Id: <1222343711-12508-33-git-send-email-avi@redhat.com>
In-Reply-To: <1222343711-12508-1-git-send-email-avi@redhat.com>
References: <1222343711-12508-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avi Kivity <avi@qumranet.com>

Now that two-dimensional paging is becoming common, account for tdp page
faults.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/mmu.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index a1ca4ff..a24da8f 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1283,6 +1283,7 @@ static int direct_map_entry(struct kvm_shadow_walk *_walk,
 		mmu_set_spte(vcpu, sptep, ACC_ALL, ACC_ALL,
 			     0, walk->write, 1, &walk->pt_write,
 			     walk->largepage, gfn, walk->pfn, false);
+		++vcpu->stat.pf_fixed;
 		return 1;
 	}
 
-- 
1.6.0.1

