Return-Path: <linux-kernel-owner+w=401wt.eu-S933790AbZHWMDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933790AbZHWMDx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 08:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933536AbZHWMDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 08:03:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43287 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933534AbZHWL4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 07:56:49 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 17/46] KVM: No need to kick cpu if not in a guest mode
Date: Sun, 23 Aug 2009 14:56:16 +0300
Message-Id: <1251028605-31977-18-git-send-email-avi@redhat.com>
In-Reply-To: <1251028605-31977-1-git-send-email-avi@redhat.com>
References: <1251028605-31977-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

This will save a couple of IPIs.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Acked-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 95fa45c..e3d9040 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3506,6 +3506,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	smp_mb__after_clear_bit();
 
 	if (vcpu->requests || need_resched() || signal_pending(current)) {
+		set_bit(KVM_REQ_KICK, &vcpu->requests);
 		local_irq_enable();
 		preempt_enable();
 		r = 1;
-- 
1.6.4.1

