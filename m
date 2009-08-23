Return-Path: <linux-kernel-owner+w=401wt.eu-S933663AbZHWL76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933663AbZHWL76 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 07:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933596AbZHWL6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 07:58:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56556 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933561AbZHWL4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 07:56:50 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 34/46] KVM: PIT: Unregister ack notifier callback when freeing
Date: Sun, 23 Aug 2009 14:56:33 +0300
Message-Id: <1251028605-31977-35-git-send-email-avi@redhat.com>
In-Reply-To: <1251028605-31977-1-git-send-email-avi@redhat.com>
References: <1251028605-31977-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/i8254.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 137e548..472653c 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -672,6 +672,8 @@ void kvm_free_pit(struct kvm *kvm)
 	if (kvm->arch.vpit) {
 		kvm_unregister_irq_mask_notifier(kvm, 0,
 					       &kvm->arch.vpit->mask_notifier);
+		kvm_unregister_irq_ack_notifier(kvm,
+				&kvm->arch.vpit->pit_state.irq_ack_notifier);
 		mutex_lock(&kvm->arch.vpit->pit_state.lock);
 		timer = &kvm->arch.vpit->pit_state.pit_timer.timer;
 		hrtimer_cancel(timer);
-- 
1.6.4.1

