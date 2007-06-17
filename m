Return-Path: <linux-kernel-owner+w=401wt.eu-S1762333AbXFQKA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762333AbXFQKA6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 06:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759751AbXFQJpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:45:44 -0400
Received: from il.qumranet.com ([82.166.9.18]:55192 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759338AbXFQJos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:48 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 41/58] KVM: MMU: Remove cr0.wp tricks
Date: Sun, 17 Jun 2007 12:44:22 +0300
Message-Id: <11820734812517-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1182073479890-git-send-email-avi@qumranet.com>
References: <1182073479890-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

No longer needed as we do everything in one place.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/paging_tmpl.h |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index fabc2c9..59b4cb2 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -240,17 +240,6 @@ static void FNAME(set_pte_common)(struct kvm_vcpu *vcpu,
 
 	spte |= paddr;
 
-	if (!write_fault && (spte & PT_SHADOW_USER_MASK) &&
-	    !(spte & PT_USER_MASK)) {
-		/*
-		 * If supervisor write protect is disabled, we shadow kernel
-		 * pages as user pages so we can trap the write access.
-		 */
-		spte |= PT_USER_MASK;
-		spte &= ~PT_WRITABLE_MASK;
-		access_bits &= ~PT_WRITABLE_MASK;
-	}
-
 	if ((access_bits & PT_WRITABLE_MASK)
 	    || (write_fault && !is_write_protection(vcpu) && !user_fault)) {
 		struct kvm_mmu_page *shadow;
-- 
1.5.0.6

