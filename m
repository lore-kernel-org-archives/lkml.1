Return-Path: <linux-kernel-owner+w=401wt.eu-S1755570AbYLIUdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbYLIUdq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 15:33:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755413AbYLIUYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 15:24:03 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34896 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754942AbYLIUXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 15:23:13 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sheng Yang <sheng@linux.intel.com>
Subject: [PATCH 38/44] KVM: Clean up assigned_device_update_irq
Date: Tue,  9 Dec 2008 22:22:53 +0200
Message-Id: <1228854179-23002-39-git-send-email-avi@redhat.com>
In-Reply-To: <1228854179-23002-1-git-send-email-avi@redhat.com>
References: <1228854179-23002-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 virt/kvm/kvm_main.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 638de47..2089f8b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -180,11 +180,11 @@ static int assigned_device_update_intx(struct kvm *kvm,
 			struct kvm_assigned_dev_kernel *adev,
 			struct kvm_assigned_irq *airq)
 {
-	if (adev->irq_requested_type & KVM_ASSIGNED_DEV_GUEST_INTX) {
-		adev->guest_irq = airq->guest_irq;
-		adev->ack_notifier.gsi = airq->guest_irq;
+	adev->guest_irq = airq->guest_irq;
+	adev->ack_notifier.gsi = airq->guest_irq;
+
+	if (adev->irq_requested_type & KVM_ASSIGNED_DEV_HOST_INTX)
 		return 0;
-	}
 
 	if (irqchip_in_kernel(kvm)) {
 		if (!capable(CAP_SYS_RAWIO))
@@ -194,8 +194,6 @@ static int assigned_device_update_intx(struct kvm *kvm,
 			adev->host_irq = airq->host_irq;
 		else
 			adev->host_irq = adev->dev->irq;
-		adev->guest_irq = airq->guest_irq;
-		adev->ack_notifier.gsi = airq->guest_irq;
 
 		/* Even though this is PCI, we don't want to use shared
 		 * interrupts. Sharing host devices with guest-assigned devices
-- 
1.6.0.3

