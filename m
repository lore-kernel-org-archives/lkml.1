Return-Path: <linux-kernel-owner+w=401wt.eu-S1755034AbXLZLTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034AbXLZLTr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:19:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752613AbXLZLG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:06:58 -0500
Received: from il.qumranet.com ([82.166.9.18]:50479 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856AbXLZLGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:06:07 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Dor Laor <dor.laor@qumranet.com>
Subject: [PATCH 36/55] KVM: Add make_page_dirty() to kvm_clear_guest_page()
Date: Wed, 26 Dec 2007 13:05:41 +0200
Message-Id: <1198667160-22953-37-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198667160-22953-1-git-send-email-avi@qumranet.com>
References: <1198667160-22953-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dor Laor <dor.laor@qumranet.com>

Every write access to guest pages should be tracked.

Signed-off-by: Dor Laor <dor.laor@qumranet.com>
Signed-off-by: Izik Eidus <izike@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index e12bdc1..302473d 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -706,6 +706,7 @@ int kvm_clear_guest_page(struct kvm *kvm, gfn_t gfn, int offset, int len)
 
 	kunmap_atomic(page_virt, KM_USER0);
 	kvm_release_page(page);
+	mark_page_dirty(kvm, gfn);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(kvm_clear_guest_page);
-- 
1.5.3.7

