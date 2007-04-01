Return-Path: <linux-kernel-owner+w=401wt.eu-S933113AbXDAOiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933113AbXDAOiT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 10:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933102AbXDAOfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 10:35:45 -0400
Received: from il.qumranet.com ([82.166.9.18]:47540 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933113AbXDAOfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 10:35:41 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 05/41] KVM: Fix bogus sign extension in mmu mapping audit
Date: Sun,  1 Apr 2007 17:35:02 +0300
Message-Id: <11754381383730-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.5
In-Reply-To: <11754381382515-git-send-email-avi@qumranet.com>
References: <1175438138288-git-send-email-avi@qumranet.com> <11754381381990-git-send-email-avi@qumranet.com> <11754381384009-git-send-email-avi@qumranet.com> <1175438138805-git-send-email-avi@qumranet.com> <11754381382515-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When auditing a 32-bit guest on a 64-bit host, sign extension of the page
table directory pointer table index caused bogus addresses to be shown on
audit errors.

Fix by declaring the index unsigned.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/mmu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index e85b4c7..266444a 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -1359,7 +1359,7 @@ static void audit_mappings_page(struct kvm_vcpu *vcpu, u64 page_pte,
 
 static void audit_mappings(struct kvm_vcpu *vcpu)
 {
-	int i;
+	unsigned i;
 
 	if (vcpu->mmu.root_level == 4)
 		audit_mappings_page(vcpu, vcpu->mmu.root_hpa, 0, 4);
-- 
1.5.0.5

