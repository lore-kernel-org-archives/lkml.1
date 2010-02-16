Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932976Ab0BPKlc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 05:41:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41229 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932800Ab0BPKfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 05:35:40 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 13/38] KVM: Allow kvm_load_guest_fpu() even when !vcpu->fpu_active
Date: Tue, 16 Feb 2010 12:35:11 +0200
Message-Id: <1266316536-28936-14-git-send-email-avi@redhat.com>
In-Reply-To: <1266316536-28936-1-git-send-email-avi@redhat.com>
References: <1266316536-28936-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows accessing the guest fpu from the instruction emulator, as well as
being symmetric with kvm_put_guest_fpu().

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/x86.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ce267d9..4cf4eac 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4239,7 +4239,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	preempt_disable();
 
 	kvm_x86_ops->prepare_guest_switch(vcpu);
-	kvm_load_guest_fpu(vcpu);
+	if (vcpu->fpu_active)
+		kvm_load_guest_fpu(vcpu);
 
 	local_irq_disable();
 
@@ -5285,7 +5286,7 @@ EXPORT_SYMBOL_GPL(fx_init);
 
 void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
 {
-	if (!vcpu->fpu_active || vcpu->guest_fpu_loaded)
+	if (vcpu->guest_fpu_loaded)
 		return;
 
 	vcpu->guest_fpu_loaded = 1;
-- 
1.6.5.3

