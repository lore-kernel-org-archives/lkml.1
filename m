Return-Path: <linux-kernel-owner+w=401wt.eu-S1754556AbZHPJc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbZHPJc0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 05:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754075AbZHPJcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 05:32:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45363 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754066AbZHPJaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 05:30:13 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 33/48] KVM: ppc: e500: Add MMUCFG and PVR emulation
Date: Sun, 16 Aug 2009 12:29:53 +0300
Message-Id: <1250415008-17175-34-git-send-email-avi@redhat.com>
In-Reply-To: <1250415008-17175-1-git-send-email-avi@redhat.com>
References: <1250415008-17175-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Yu <yu.liu@freescale.com>

Latest kernel started to use these two registers.

Signed-off-by: Liu Yu <yu.liu@freescale.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/kvm/e500_emulate.c |    3 +++
 arch/powerpc/kvm/emulate.c      |    2 ++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kvm/e500_emulate.c b/arch/powerpc/kvm/e500_emulate.c
index 3f76041..be95b8d 100644
--- a/arch/powerpc/kvm/e500_emulate.c
+++ b/arch/powerpc/kvm/e500_emulate.c
@@ -180,6 +180,9 @@ int kvmppc_core_emulate_mfspr(struct kvm_vcpu *vcpu, int sprn, int rt)
 	case SPRN_MMUCSR0:
 		vcpu->arch.gpr[rt] = 0; break;
 
+	case SPRN_MMUCFG:
+		vcpu->arch.gpr[rt] = mfspr(SPRN_MMUCFG); break;
+
 	/* extra exceptions */
 	case SPRN_IVOR32:
 		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_SPE_UNAVAIL];
diff --git a/arch/powerpc/kvm/emulate.c b/arch/powerpc/kvm/emulate.c
index f8b8248..28a8237 100644
--- a/arch/powerpc/kvm/emulate.c
+++ b/arch/powerpc/kvm/emulate.c
@@ -188,6 +188,8 @@ int kvmppc_emulate_instruction(struct kvm_run *run, struct kvm_vcpu *vcpu)
 				vcpu->arch.gpr[rt] = vcpu->arch.srr1; break;
 			case SPRN_PVR:
 				vcpu->arch.gpr[rt] = mfspr(SPRN_PVR); break;
+			case SPRN_PIR:
+				vcpu->arch.gpr[rt] = mfspr(SPRN_PIR); break;
 
 			/* Note: mftb and TBRL/TBWL are user-accessible, so
 			 * the guest can always access the real TB anyways.
-- 
1.6.3.3

