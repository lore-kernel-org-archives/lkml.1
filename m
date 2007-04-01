Return-Path: <linux-kernel-owner+w=401wt.eu-S933219AbXDAOnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933219AbXDAOnS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 10:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933127AbXDAOm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 10:42:59 -0400
Received: from il.qumranet.com ([82.166.9.18]:47548 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933103AbXDAOfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 10:35:43 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 21/41] KVM: MMU: Remove unnecessary check for pdptr access
Date: Sun,  1 Apr 2007 17:35:18 +0300
Message-Id: <11754381392186-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.5
In-Reply-To: <11754381393061-git-send-email-avi@qumranet.com>
References: <1175438138288-git-send-email-avi@qumranet.com> <11754381381990-git-send-email-avi@qumranet.com> <11754381384009-git-send-email-avi@qumranet.com> <1175438138805-git-send-email-avi@qumranet.com> <11754381382515-git-send-email-avi@qumranet.com> <11754381383730-git-send-email-avi@qumranet.com> <11754381383144-git-send-email-avi@qumranet.com> <11754381381597-git-send-email-avi@qumranet.com> <1175438139242-git-send-email-avi@qumranet.com> <1175438139494-git-send-email-avi@qumranet.com> <11754381392046-git-send-email-avi@qumranet.com> <1175438139795-git-send-email-avi@qumranet.com> <1175438139430-git-send-email-avi@qumranet.com> <11754381393496-git-send-email-avi@qumranet.com> <11754381391514-git-send-email-avi@qumranet.com> <11754381392382-git-send-email-avi@qumranet.com> <11754381392358-git-send-email-avi@qumranet.com> <1175438139872-git-send-email-avi@qumranet.com> <11754381392921-git-send-email-avi@qumranet.com> <117543813978-git-send-email-avi@qumranet.com> <117543
 81393061-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We already special case the pdptr access, so no need to check it again.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/paging_tmpl.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index f3bcee9..17bd440 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -148,8 +148,7 @@ static int FNAME(walk_addr)(struct guest_walker *walker,
 			break;
 		}
 
-		if (walker->level != 3 || is_long_mode(vcpu))
-			walker->inherited_ar &= walker->table[index];
+		walker->inherited_ar &= walker->table[index];
 		table_gfn = (*ptep & PT_BASE_ADDR_MASK) >> PAGE_SHIFT;
 		paddr = safe_gpa_to_hpa(vcpu, *ptep & PT_BASE_ADDR_MASK);
 		kunmap_atomic(walker->table, KM_USER0);
-- 
1.5.0.5

