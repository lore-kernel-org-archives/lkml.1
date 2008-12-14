Return-Path: <linux-kernel-owner+w=401wt.eu-S1755552AbYLNILf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552AbYLNILf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 03:11:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754353AbYLNIH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 03:07:29 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59907 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752644AbYLNIHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 03:07:15 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH 14/36] KVM: remove the IRQ ACK notifier assertions
Date: Sun, 14 Dec 2008 10:06:47 +0200
Message-Id: <1229242029-13410-15-git-send-email-avi@redhat.com>
In-Reply-To: <1229242029-13410-1-git-send-email-avi@redhat.com>
References: <1229242029-13410-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark McLoughlin <markmc@redhat.com>

We will obviously never pass a NULL struct kvm_irq_ack_notifier* to
this functions. They are always embedded in the assigned device
structure, so the assertion add nothing.

The irqchip_in_kernel() assertion is very out of place - clearly
this little abstraction needs to know nothing about the upper
layer details.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 virt/kvm/irq_comm.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
index 9fbbdea..973df99 100644
--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -58,9 +58,6 @@ void kvm_notify_acked_irq(struct kvm *kvm, unsigned gsi)
 void kvm_register_irq_ack_notifier(struct kvm *kvm,
 				   struct kvm_irq_ack_notifier *kian)
 {
-	/* Must be called with in-kernel IRQ chip, otherwise it's nonsense */
-	ASSERT(irqchip_in_kernel(kvm));
-	ASSERT(kian);
 	hlist_add_head(&kian->link, &kvm->arch.irq_ack_notifier_list);
 }
 
-- 
1.6.0.3

