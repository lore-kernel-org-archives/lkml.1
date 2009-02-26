Return-Path: <linux-kernel-owner+w=401wt.eu-S1758353AbZBZOZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758353AbZBZOZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 09:25:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757585AbZBZOQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 09:16:54 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43098 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755265AbZBZOPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 09:15:45 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hollis Blanchard <hollisb@us.ibm.com>
Subject: [PATCH 37/40] KVM: ppc: cosmetic changes to mmu hook names
Date: Thu, 26 Feb 2009 16:15:27 +0200
Message-Id: <1235657730-27683-38-git-send-email-avi@redhat.com>
In-Reply-To: <1235657730-27683-1-git-send-email-avi@redhat.com>
References: <1235657730-27683-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/include/asm/kvm_ppc.h |    5 +++--
 arch/powerpc/kvm/44x_tlb.c         |    2 +-
 arch/powerpc/kvm/powerpc.c         |    2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index 36d2a50..7ba95d2 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -52,13 +52,14 @@ extern int kvmppc_emulate_instruction(struct kvm_run *run,
 extern int kvmppc_emulate_mmio(struct kvm_run *run, struct kvm_vcpu *vcpu);
 extern void kvmppc_emulate_dec(struct kvm_vcpu *vcpu);
 
+/* Core-specific hooks */
+
 extern void kvmppc_mmu_map(struct kvm_vcpu *vcpu, u64 gvaddr, gpa_t gpaddr,
                            u64 asid, u32 flags, u32 max_bytes,
                            unsigned int gtlb_idx);
 extern void kvmppc_mmu_priv_switch(struct kvm_vcpu *vcpu, int usermode);
 extern void kvmppc_mmu_switch_pid(struct kvm_vcpu *vcpu, u32 pid);
-
-/* Core-specific hooks */
+extern void kvmppc_mmu_destroy(struct kvm_vcpu *vcpu);
 
 extern struct kvm_vcpu *kvmppc_core_vcpu_create(struct kvm *kvm,
                                                 unsigned int id);
diff --git a/arch/powerpc/kvm/44x_tlb.c b/arch/powerpc/kvm/44x_tlb.c
index 9a34b8e..8f9c09c 100644
--- a/arch/powerpc/kvm/44x_tlb.c
+++ b/arch/powerpc/kvm/44x_tlb.c
@@ -248,7 +248,7 @@ static void kvmppc_44x_shadow_release(struct kvmppc_vcpu_44x *vcpu_44x,
 	KVMTRACE_1D(STLB_INVAL, &vcpu_44x->vcpu, stlb_index, handler);
 }
 
-void kvmppc_core_destroy_mmu(struct kvm_vcpu *vcpu)
+void kvmppc_mmu_destroy(struct kvm_vcpu *vcpu)
 {
 	struct kvmppc_vcpu_44x *vcpu_44x = to_44x(vcpu);
 	int i;
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 7c2ad40..f30be9e 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -216,7 +216,7 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 
 void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
 {
-	kvmppc_core_destroy_mmu(vcpu);
+	kvmppc_mmu_destroy(vcpu);
 }
 
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
-- 
1.6.0.6

