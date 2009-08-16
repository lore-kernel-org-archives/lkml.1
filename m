Return-Path: <linux-kernel-owner+w=401wt.eu-S1754814AbZHPJei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbZHPJei (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 05:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754478AbZHPJcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 05:32:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45371 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754080AbZHPJaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 05:30:14 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 35/48] KVM: Grab pic lock in kvm_pic_clear_isr_ack
Date: Sun, 16 Aug 2009 12:29:55 +0300
Message-Id: <1250415008-17175-36-git-send-email-avi@redhat.com>
In-Reply-To: <1250415008-17175-1-git-send-email-avi@redhat.com>
References: <1250415008-17175-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

isr_ack is protected by kvm_pic->lock.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/i8259.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index 2520922..bf94a45 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -72,8 +72,10 @@ static void pic_clear_isr(struct kvm_kpic_state *s, int irq)
 void kvm_pic_clear_isr_ack(struct kvm *kvm)
 {
 	struct kvm_pic *s = pic_irqchip(kvm);
+	pic_lock(s);
 	s->pics[0].isr_ack = 0xff;
 	s->pics[1].isr_ack = 0xff;
+	pic_unlock(s);
 }
 
 /*
-- 
1.6.3.3

