Return-Path: <linux-kernel-owner+w=401wt.eu-S1758787AbZERJoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787AbZERJoA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 05:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756795AbZERJZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 05:25:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38427 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754411AbZERJXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 05:23:11 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 33/43] KVM: SVM: Remove duplicate code in svm_do_inject_vector()
Date: Mon, 18 May 2009 12:22:55 +0300
Message-Id: <1242638585-18470-34-git-send-email-avi@redhat.com>
In-Reply-To: <1242638585-18470-1-git-send-email-avi@redhat.com>
References: <1242638585-18470-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

svm_do_inject_vector() reimplements pop_irq().

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 1f8510c..5b35ebd 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2346,15 +2346,7 @@ static void kvm_reput_irq(struct vcpu_svm *svm)
 
 static void svm_do_inject_vector(struct vcpu_svm *svm)
 {
-	struct kvm_vcpu *vcpu = &svm->vcpu;
-	int word_index = __ffs(vcpu->arch.irq_summary);
-	int bit_index = __ffs(vcpu->arch.irq_pending[word_index]);
-	int irq = word_index * BITS_PER_LONG + bit_index;
-
-	clear_bit(bit_index, &vcpu->arch.irq_pending[word_index]);
-	if (!vcpu->arch.irq_pending[word_index])
-		clear_bit(word_index, &vcpu->arch.irq_summary);
-	svm_inject_irq(svm, irq);
+	svm_inject_irq(svm, pop_irq(&svm->vcpu));
 }
 
 static void do_interrupt_requests(struct kvm_vcpu *vcpu,
-- 
1.6.0.6

