Return-Path: <linux-kernel-owner+w=401wt.eu-S1758353AbZB0KbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758353AbZB0KbA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 05:31:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757548AbZB0K1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 05:27:23 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53562 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755328AbZB0K1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 05:27:09 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 05/37] KVM: ppc: Add dbsr in kvm_vcpu_arch
Date: Fri, 27 Feb 2009 12:26:28 +0200
Message-Id: <1235730420-7929-6-git-send-email-avi@redhat.com>
In-Reply-To: <1235730420-7929-1-git-send-email-avi@redhat.com>
References: <1235730420-7929-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

Kernel for E500 need clear dbsr when startup.
So add dbsr register in kvm_vcpu_arch for BOOKE.

Signed-off-by: Liu Yu <yu.liu@freescale.com>
Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/include/asm/kvm_host.h |    1 +
 arch/powerpc/kvm/booke_emulate.c    |    4 ++++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 65c4d49..50e5ce1 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -163,6 +163,7 @@ struct kvm_vcpu_arch {
 	u32 ccr1;
 	u32 dbcr0;
 	u32 dbcr1;
+	u32 dbsr;
 
 #ifdef CONFIG_KVM_EXIT_TIMING
 	struct kvmppc_exit_timing timing_exit;
diff --git a/arch/powerpc/kvm/booke_emulate.c b/arch/powerpc/kvm/booke_emulate.c
index 8aa78f1..aebc65e 100644
--- a/arch/powerpc/kvm/booke_emulate.c
+++ b/arch/powerpc/kvm/booke_emulate.c
@@ -111,6 +111,8 @@ int kvmppc_booke_emulate_mtspr(struct kvm_vcpu *vcpu, int sprn, int rs)
 		vcpu->arch.dbcr0 = vcpu->arch.gpr[rs]; break;
 	case SPRN_DBCR1:
 		vcpu->arch.dbcr1 = vcpu->arch.gpr[rs]; break;
+	case SPRN_DBSR:
+		vcpu->arch.dbsr &= ~vcpu->arch.gpr[rs]; break;
 	case SPRN_TSR:
 		vcpu->arch.tsr &= ~vcpu->arch.gpr[rs]; break;
 	case SPRN_TCR:
@@ -204,6 +206,8 @@ int kvmppc_booke_emulate_mfspr(struct kvm_vcpu *vcpu, int sprn, int rt)
 		vcpu->arch.gpr[rt] = vcpu->arch.dbcr0; break;
 	case SPRN_DBCR1:
 		vcpu->arch.gpr[rt] = vcpu->arch.dbcr1; break;
+	case SPRN_DBSR:
+		vcpu->arch.gpr[rt] = vcpu->arch.dbsr; break;
 
 	case SPRN_IVOR0:
 		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_CRITICAL];
-- 
1.6.0.6

