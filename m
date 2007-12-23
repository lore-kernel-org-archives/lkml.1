Return-Path: <linux-kernel-owner+w=401wt.eu-S1757279AbXLWPBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279AbXLWPBS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 10:01:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753122AbXLWOwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 09:52:11 -0500
Received: from il.qumranet.com ([82.166.9.18]:35929 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753899AbXLWOvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 09:51:45 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 34/50] KVM: MMU: Instantiate real-mode shadows as user writable shadows
Date: Sun, 23 Dec 2007 16:51:19 +0200
Message-Id: <1198421495-31481-35-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198421495-31481-1-git-send-email-avi@qumranet.com>
References: <1198421495-31481-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is consistent with real-mode permissions.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/mmu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index e6616a6..f52604a 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -902,7 +902,7 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, hpa_t p)
 				>> PAGE_SHIFT;
 			new_table = kvm_mmu_get_page(vcpu, pseudo_gfn,
 						     v, level - 1,
-						     1, 0, &table[index]);
+						     1, 3, &table[index]);
 			if (!new_table) {
 				pgprintk("nonpaging_map: ENOMEM\n");
 				return -ENOMEM;
-- 
1.5.3.7

