Return-Path: <linux-kernel-owner+w=401wt.eu-S1757266AbZETLWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266AbZETLWK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 07:22:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756216AbZETLTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 07:19:07 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55295 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755843AbZETLSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 07:18:51 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 44/46] KVM: Use kvm_arch_interrupt_allowed() instead of checking interrupt_window_open directly
Date: Wed, 20 May 2009 14:18:41 +0300
Message-Id: <1242818323-10413-45-git-send-email-avi@redhat.com>
In-Reply-To: <1242818323-10413-1-git-send-email-avi@redhat.com>
References: <1242818323-10413-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

kvm_arch_interrupt_allowed() also checks IF so drop the check.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7a572ec..28919d2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3067,8 +3067,7 @@ static int dm_request_for_irq_injection(struct kvm_vcpu *vcpu,
 {
 	return (!irqchip_in_kernel(vcpu->kvm) && !kvm_cpu_has_interrupt(vcpu) &&
 		kvm_run->request_interrupt_window &&
-		vcpu->arch.interrupt_window_open &&
-		(kvm_x86_ops->get_rflags(vcpu) & X86_EFLAGS_IF));
+		kvm_arch_interrupt_allowed(vcpu));
 }
 
 static void post_kvm_run_save(struct kvm_vcpu *vcpu,
@@ -3081,7 +3080,7 @@ static void post_kvm_run_save(struct kvm_vcpu *vcpu,
 		kvm_run->ready_for_interrupt_injection = 1;
 	else
 		kvm_run->ready_for_interrupt_injection =
-					(vcpu->arch.interrupt_window_open &&
+					(kvm_arch_interrupt_allowed(vcpu) &&
 					 !kvm_cpu_has_interrupt(vcpu));
 }
 
-- 
1.6.0.6

