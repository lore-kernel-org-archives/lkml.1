Return-Path: <linux-kernel-owner+w=401wt.eu-S1761529AbXFQJ4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761529AbXFQJ4Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 05:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759643AbXFQJpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:45:17 -0400
Received: from il.qumranet.com ([82.166.9.18]:55160 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759363AbXFQJos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:48 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 44/58] KVM: MMU: Remove unused large page marker
Date: Sun, 17 Jun 2007 12:44:25 +0300
Message-Id: <11820734811219-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1182073479890-git-send-email-avi@qumranet.com>
References: <1182073479890-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This has not been used for some time, as the same information is available
in the page header.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/mmu.c         |    1 -
 drivers/kvm/paging_tmpl.h |    2 --
 2 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index 986d012..283df03 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -94,7 +94,6 @@ static int dbg = 1;
 #define PT_FIRST_AVAIL_BITS_SHIFT 9
 #define PT64_SECOND_AVAIL_BITS_SHIFT 52
 
-#define PT_SHADOW_PS_MARK (1ULL << PT_FIRST_AVAIL_BITS_SHIFT)
 #define PT_SHADOW_IO_MARK (1ULL << PT_FIRST_AVAIL_BITS_SHIFT)
 
 #define VALID_PAGE(x) ((x) != INVALID_PAGE)
diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index adc1206..a7c5cb0 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -384,8 +384,6 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 	}
 
 	if (walker->level == PT_DIRECTORY_LEVEL) {
-		if (prev_shadow_ent)
-			*prev_shadow_ent |= PT_SHADOW_PS_MARK;
 		FNAME(set_pde)(vcpu, guest_ent, shadow_ent,
 			       walker->inherited_ar, user_fault, write_fault,
 			       ptwrite, walker, walker->gfn);
-- 
1.5.0.6

