Return-Path: <linux-kernel-owner+w=401wt.eu-S1755264AbYAAPjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264AbYAAPjt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:39:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755258AbYAAPgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:36:32 -0500
Received: from il.qumranet.com ([82.166.9.18]:33793 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754154AbYAAPgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:36:24 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 11/54] KVM: Remove misleading check for mmio during event injection
Date: Tue,  1 Jan 2008 17:35:37 +0200
Message-Id: <1199201780-14001-12-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199201780-14001-1-git-send-email-avi@qumranet.com>
References: <1199201780-14001-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mmio was already handled in kvm_arch_vcpu_ioctl_run(), so no need to check
again.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/x86.c b/drivers/kvm/x86.c
index 2be5936..5e58156 100644
--- a/drivers/kvm/x86.c
+++ b/drivers/kvm/x86.c
@@ -2344,7 +2344,7 @@ again:
 
 	if (irqchip_in_kernel(vcpu->kvm))
 		kvm_x86_ops->inject_pending_irq(vcpu);
-	else if (!vcpu->mmio_read_completed)
+	else
 		kvm_x86_ops->inject_pending_vectors(vcpu, kvm_run);
 
 	vcpu->guest_mode = 1;
-- 
1.5.3.7

