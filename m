Return-Path: <linux-kernel-owner+w=401wt.eu-S1754453AbYI1Psi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453AbYI1Psi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 11:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753180AbYI1Ppc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 11:45:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50861 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752882AbYI1Pp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 11:45:26 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>
Subject: [PATCH 10/25] KVM: VMX: Cleanup stalled INTR_INFO read
Date: Sun, 28 Sep 2008 18:44:46 +0300
Message-Id: <1222616701-1206-11-git-send-email-avi@redhat.com>
In-Reply-To: <1222616701-1206-1-git-send-email-avi@redhat.com>
References: <1222616701-1206-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

Commit 1c0f4f5011829dac96347b5f84ba37c2252e1e08 left a useless access
of VM_ENTRY_INTR_INFO_FIELD in vmx_intr_assist behind. Clean this up.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/vmx.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index e7e8c86..f8e615f 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3135,11 +3135,8 @@ static void vmx_complete_interrupts(struct vcpu_vmx *vmx)
 
 static void vmx_intr_assist(struct kvm_vcpu *vcpu)
 {
-	u32 intr_info_field;
-
 	update_tpr_threshold(vcpu);
 
-	intr_info_field = vmcs_read32(VM_ENTRY_INTR_INFO_FIELD);
 	if (cpu_has_virtual_nmis()) {
 		if (vcpu->arch.nmi_pending && !vcpu->arch.nmi_injected) {
 			if (vmx_nmi_enabled(vcpu)) {
-- 
1.6.0.1

