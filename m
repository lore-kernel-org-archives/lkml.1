Return-Path: <linux-kernel-owner+w=401wt.eu-S933330AbXD2Pur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933330AbXD2Pur (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 11:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933327AbXD2Pup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 11:50:45 -0400
Received: from il.qumranet.com ([82.166.9.18]:34353 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756516AbXD2PuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 11:50:24 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Adrian Bunk <bunk@stusta.de>,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH 3/7] KVM: fix an if() condition
Date: Sun, 29 Apr 2007 18:50:18 +0300
Message-Id: <11778618221062-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1177861822889-git-send-email-avi@qumranet.com>
References: <1177861822889-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@stusta.de>

It might have worked in this case since PT_PRESENT_MASK is 1, but let's
express this correctly.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/mmu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index 32c64f6..e8e2281 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -1408,7 +1408,7 @@ static void audit_mappings_page(struct kvm_vcpu *vcpu, u64 page_pte,
 	for (i = 0; i < PT64_ENT_PER_PAGE; ++i, va += va_delta) {
 		u64 ent = pt[i];
 
-		if (!ent & PT_PRESENT_MASK)
+		if (!(ent & PT_PRESENT_MASK))
 			continue;
 
 		va = canonicalize(va);
-- 
1.5.0.6

