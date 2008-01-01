Return-Path: <linux-kernel-owner+w=401wt.eu-S1759505AbYAAPws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759505AbYAAPws (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:52:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755408AbYAAPhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:37:09 -0500
Received: from il.qumranet.com ([82.166.9.18]:33803 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755231AbYAAPgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:36:31 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 46/54] KVM: MMU: No need to pick up nx bit from guest pte
Date: Tue,  1 Jan 2008 17:36:12 +0200
Message-Id: <1199201780-14001-47-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199201780-14001-1-git-send-email-avi@qumranet.com>
References: <1199201780-14001-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We already set it according to cumulative access permissions.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/paging_tmpl.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index 211fef8..179ce9e 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -258,7 +258,6 @@ static void FNAME(set_pte)(struct kvm_vcpu *vcpu, pt_element_t gpte,
 	 * demand paging).
 	 */
 	spte = PT_PRESENT_MASK | PT_DIRTY_MASK;
-	spte |= gpte & PT64_NX_MASK;
 	if (!dirty)
 		pte_access &= ~ACC_WRITE_MASK;
 	if (!(pte_access & ACC_EXEC_MASK))
-- 
1.5.3.7

