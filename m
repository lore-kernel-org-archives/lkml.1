Return-Path: <linux-kernel-owner+w=401wt.eu-S1758879AbYAAPtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758879AbYAAPtG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:49:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754582AbYAAPg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:36:56 -0500
Received: from il.qumranet.com ([82.166.9.18]:33796 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754515AbYAAPg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:36:27 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Marcelo Tosatti <marcelo@kvack.org>
Subject: [PATCH 31/54] KVM: MMU: Remove unused prev_shadow_ent variable from fetch()
Date: Tue,  1 Jan 2008 17:35:57 +0200
Message-Id: <1199201780-14001-32-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199201780-14001-1-git-send-email-avi@qumranet.com>
References: <1199201780-14001-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <marcelo@kvack.org>

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/paging_tmpl.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index b24bc7c..3c40a59 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -300,7 +300,6 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 	hpa_t shadow_addr;
 	int level;
 	u64 *shadow_ent;
-	u64 *prev_shadow_ent = NULL;
 
 	if (!is_present_pte(walker->pte))
 		return NULL;
@@ -326,7 +325,6 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 			if (level == PT_PAGE_TABLE_LEVEL)
 				break;
 			shadow_addr = *shadow_ent & PT64_BASE_ADDR_MASK;
-			prev_shadow_ent = shadow_ent;
 			continue;
 		}
 
@@ -355,7 +353,6 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 		shadow_pte = shadow_addr | PT_PRESENT_MASK | PT_ACCESSED_MASK
 			| PT_WRITABLE_MASK | PT_USER_MASK;
 		*shadow_ent = shadow_pte;
-		prev_shadow_ent = shadow_ent;
 	}
 
 	FNAME(set_pte)(vcpu, walker->pte, shadow_ent,
-- 
1.5.3.7

