Return-Path: <linux-kernel-owner+w=401wt.eu-S1759989AbYAFOuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759989AbYAFOuW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 09:50:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754438AbYAFOk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 09:40:26 -0500
Received: from il.qumranet.com ([82.166.9.18]:46655 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758110AbYAFOjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 09:39:52 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: "Dong, Eddie" <eddie.dong@intel.com>
Subject: [PATCH 32/33] KVM: MMU: Merge shadow level check in FNAME(fetch)
Date: Sun,  6 Jan 2008 16:39:38 +0200
Message-Id: <1199630379-28638-33-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199630379-28638-1-git-send-email-avi@qumranet.com>
References: <1199630379-28638-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong, Eddie <eddie.dong@intel.com>

Remove the redundant level check when fetching
shadow pte for present & non-present spte.

Signed-off-by: Yaozu (Eddie) Dong <eddie.dong@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/paging_tmpl.h |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 3499205..03ba860 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -300,16 +300,13 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 		bool new_page = 0;
 
 		shadow_ent = ((u64 *)__va(shadow_addr)) + index;
+		if (level == PT_PAGE_TABLE_LEVEL)
+			break;
 		if (is_shadow_present_pte(*shadow_ent)) {
-			if (level == PT_PAGE_TABLE_LEVEL)
-				break;
 			shadow_addr = *shadow_ent & PT64_BASE_ADDR_MASK;
 			continue;
 		}
 
-		if (level == PT_PAGE_TABLE_LEVEL)
-			break;
-
 		if (level - 1 == PT_PAGE_TABLE_LEVEL
 		    && walker->level == PT_DIRECTORY_LEVEL) {
 			metaphysical = 1;
-- 
1.5.3.7

