Return-Path: <linux-kernel-owner+w=401wt.eu-S1758621AbXLWPAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758621AbXLWPAh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 10:00:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753143AbXLWOwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 09:52:09 -0500
Received: from il.qumranet.com ([82.166.9.18]:35928 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753719AbXLWOvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 09:51:45 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 32/50] KVM: MMU: Fix nx access bit for huge pages
Date: Sun, 23 Dec 2007 16:51:17 +0200
Message-Id: <1198421495-31481-33-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198421495-31481-1-git-send-email-avi@qumranet.com>
References: <1198421495-31481-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We must set the bit before the shift, otherwise the wrong bit gets set.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/paging_tmpl.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index da36e48..e07cb2e 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -382,9 +382,9 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 			metaphysical = 1;
 			hugepage_access = walker->pte;
 			hugepage_access &= PT_USER_MASK | PT_WRITABLE_MASK;
+			hugepage_access >>= PT_WRITABLE_SHIFT;
 			if (walker->pte & PT64_NX_MASK)
 				hugepage_access |= (1 << 2);
-			hugepage_access >>= PT_WRITABLE_SHIFT;
 			table_gfn = (walker->pte & PT_BASE_ADDR_MASK)
 				>> PAGE_SHIFT;
 		} else {
-- 
1.5.3.7

