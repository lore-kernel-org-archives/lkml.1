Return-Path: <linux-kernel-owner+w=401wt.eu-S1757760AbYLHLwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757760AbYLHLwY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:52:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754019AbYLHLiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:38:54 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48219 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753239AbYLHLhC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:37:02 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Gleb Natapov <gleb@redhat.com>
Subject: [PATCH 15/45] KVM: call kvm_arch_vcpu_reset() instead of the kvm_x86_ops callback
Date: Mon,  8 Dec 2008 13:36:26 +0200
Message-Id: <1228736216-15787-16-git-send-email-avi@redhat.com>
In-Reply-To: <1228736216-15787-1-git-send-email-avi@redhat.com>
References: <1228736216-15787-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Call kvm_arch_vcpu_reset() instead of directly using arch callback.
The function does additional things.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0797145..a2c4b55 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3010,7 +3010,7 @@ static int __vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		pr_debug("vcpu %d received sipi with vector # %x\n",
 			 vcpu->vcpu_id, vcpu->arch.sipi_vector);
 		kvm_lapic_reset(vcpu);
-		r = kvm_x86_ops->vcpu_reset(vcpu);
+		r = kvm_arch_vcpu_reset(vcpu);
 		if (r)
 			return r;
 		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
-- 
1.6.0.3

