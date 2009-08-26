Return-Path: <linux-kernel-owner+w=401wt.eu-S932332AbZHZKba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332AbZHZKba (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757176AbZHZKaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:30:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18623 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757084AbZHZKaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:30:13 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 31/47] KVM: SVM: check for nested VINTR flag in svm_interrupt_allowed
Date: Wed, 26 Aug 2009 13:29:53 +0300
Message-Id: <1251282609-12835-32-git-send-email-avi@redhat.com>
In-Reply-To: <1251282609-12835-1-git-send-email-avi@redhat.com>
References: <1251282609-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

Not checking for this flag breaks any nested hypervisor that does not
set VINTR. So fix it with this patch.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index ff04a4b..825035e 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2466,7 +2466,7 @@ static int svm_interrupt_allowed(struct kvm_vcpu *vcpu)
 	return (vmcb->save.rflags & X86_EFLAGS_IF) &&
 		!(vmcb->control.int_state & SVM_INTERRUPT_SHADOW_MASK) &&
 		gif_set(svm) &&
-		!is_nested(svm);
+		!(is_nested(svm) && (svm->vcpu.arch.hflags & HF_VINTR_MASK));
 }
 
 static void enable_irq_window(struct kvm_vcpu *vcpu)
-- 
1.6.4.1

