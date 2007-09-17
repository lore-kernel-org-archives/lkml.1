Return-Path: <linux-kernel-owner+w=401wt.eu-S1759068AbXIQI6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759068AbXIQI6p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754946AbXIQIdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:33:44 -0400
Received: from il.qumranet.com ([82.166.9.18]:45264 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754525AbXIQIce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:34 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Amit Shah <amit.shah@qumranet.com>
Subject: [PATCH 082/104] KVM: Set the ET flag in CR0 after initializing FX
Date: Mon, 17 Sep 2007 10:32:04 +0200
Message-Id: <11900179492158-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amit Shah <amit.shah@qumranet.com>

This was missed when moving stuff around in fbc4f2e

Fixes Solaris guests and bug #1773613

Signed-off-by: Amit Shah <amit.shah@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index f101430..f0a8780 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -655,6 +655,7 @@ void fx_init(struct kvm_vcpu *vcpu)
 	fx_restore(&vcpu->host_fx_image);
 	preempt_enable();
 
+	vcpu->cr0 |= X86_CR0_ET;
 	after_mxcsr_mask = offsetof(struct i387_fxsave_struct, st_space);
 	vcpu->guest_fx_image.mxcsr = 0x1f80;
 	memset((void *)&vcpu->guest_fx_image + after_mxcsr_mask,
-- 
1.5.3

