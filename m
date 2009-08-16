Return-Path: <linux-kernel-owner+w=401wt.eu-S1754855AbZHPJfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbZHPJfo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 05:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753808AbZHPJfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 05:35:42 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45354 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754043AbZHPJaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 05:30:13 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 32/48] KVM: ppc: e500: Directly pass pvr to guest
Date: Sun, 16 Aug 2009 12:29:52 +0300
Message-Id: <1250415008-17175-33-git-send-email-avi@redhat.com>
In-Reply-To: <1250415008-17175-1-git-send-email-avi@redhat.com>
References: <1250415008-17175-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Yu <yu.liu@freescale.com>

Signed-off-by: Liu Yu <yu.liu@freescale.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/include/asm/kvm_host.h |    1 -
 arch/powerpc/kvm/e500.c             |    3 ---
 arch/powerpc/kvm/emulate.c          |    2 +-
 3 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index fddc3ed..d4caa61 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -153,7 +153,6 @@ struct kvm_vcpu_arch {
 	u32 pid;
 	u32 swap_pid;
 
-	u32 pvr;
 	u32 ccr0;
 	u32 ccr1;
 	u32 dbcr0;
diff --git a/arch/powerpc/kvm/e500.c b/arch/powerpc/kvm/e500.c
index 674e796..64949ee 100644
--- a/arch/powerpc/kvm/e500.c
+++ b/arch/powerpc/kvm/e500.c
@@ -60,9 +60,6 @@ int kvmppc_core_vcpu_setup(struct kvm_vcpu *vcpu)
 
 	kvmppc_e500_tlb_setup(vcpu_e500);
 
-	/* Use the same core vertion as host's */
-	vcpu->arch.pvr = mfspr(SPRN_PVR);
-
 	return 0;
 }
 
diff --git a/arch/powerpc/kvm/emulate.c b/arch/powerpc/kvm/emulate.c
index a561d6e..f8b8248 100644
--- a/arch/powerpc/kvm/emulate.c
+++ b/arch/powerpc/kvm/emulate.c
@@ -187,7 +187,7 @@ int kvmppc_emulate_instruction(struct kvm_run *run, struct kvm_vcpu *vcpu)
 			case SPRN_SRR1:
 				vcpu->arch.gpr[rt] = vcpu->arch.srr1; break;
 			case SPRN_PVR:
-				vcpu->arch.gpr[rt] = vcpu->arch.pvr; break;
+				vcpu->arch.gpr[rt] = mfspr(SPRN_PVR); break;
 
 			/* Note: mftb and TBRL/TBWL are user-accessible, so
 			 * the guest can always access the real TB anyways.
-- 
1.6.3.3

