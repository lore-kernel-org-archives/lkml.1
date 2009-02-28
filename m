Return-Path: <linux-kernel-owner+w=401wt.eu-S1761702AbZB1BuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761702AbZB1BuW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 20:50:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756899AbZB1Bmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 20:42:50 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41789 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754862AbZB1Bl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 20:41:59 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 24/30] KVM: fix kvm_vm_ioctl_deassign_device
Date: Sat, 28 Feb 2009 03:41:43 +0200
Message-Id: <1235785309-12835-25-git-send-email-avi@redhat.com>
In-Reply-To: <1235785309-12835-1-git-send-email-avi@redhat.com>
References: <1235785309-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Weidong Han <weidong.han@intel.com>

only need to set assigned_dev_id for deassignment, use
match->flags to judge and deassign it.

Acked-by: Mark McLoughlin <markmc@redhat.com>
Signed-off-by: Weidong Han <weidong.han@intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 virt/kvm/kvm_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 0ed662d..c427897 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -517,7 +517,7 @@ static int kvm_vm_ioctl_deassign_device(struct kvm *kvm,
 		goto out;
 	}
 
-	if (assigned_dev->flags & KVM_DEV_ASSIGN_ENABLE_IOMMU)
+	if (match->flags & KVM_DEV_ASSIGN_ENABLE_IOMMU)
 		kvm_deassign_device(kvm, match);
 
 	kvm_free_assigned_device(kvm, match);
-- 
1.6.0.6

