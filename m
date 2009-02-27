Return-Path: <linux-kernel-owner+w=401wt.eu-S1759523AbZB0KeE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759523AbZB0KeE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 05:34:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757141AbZB0K1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 05:27:50 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53590 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756080AbZB0K1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 05:27:11 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 33/37] KVM: ppc: Fix e500 warnings and some spelling problems
Date: Fri, 27 Feb 2009 12:26:56 +0200
Message-Id: <1235730420-7929-34-git-send-email-avi@redhat.com>
In-Reply-To: <1235730420-7929-1-git-send-email-avi@redhat.com>
References: <1235730420-7929-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Yu <yu.liu@freescale.com>

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/kvm/e500_emulate.c |    2 --
 arch/powerpc/kvm/e500_tlb.c     |    6 +++---
 arch/powerpc/kvm/e500_tlb.h     |    2 +-
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kvm/e500_emulate.c b/arch/powerpc/kvm/e500_emulate.c
index d3c0c7c..7a98d4a 100644
--- a/arch/powerpc/kvm/e500_emulate.c
+++ b/arch/powerpc/kvm/e500_emulate.c
@@ -30,8 +30,6 @@ int kvmppc_core_emulate_op(struct kvm_run *run, struct kvm_vcpu *vcpu,
 	int emulated = EMULATE_DONE;
 	int ra;
 	int rb;
-	int rs;
-	int rt;
 
 	switch (get_op(inst)) {
 	case 31:
diff --git a/arch/powerpc/kvm/e500_tlb.c b/arch/powerpc/kvm/e500_tlb.c
index 6a50340..e3daf57 100644
--- a/arch/powerpc/kvm/e500_tlb.c
+++ b/arch/powerpc/kvm/e500_tlb.c
@@ -260,7 +260,7 @@ static inline void kvmppc_e500_deliver_tlb_miss(struct kvm_vcpu *vcpu,
 	unsigned int victim, pidsel, tsized;
 	int tlbsel;
 
-	/* since we only have tow TLBs, only lower bit is used. */
+	/* since we only have two TLBs, only lower bit is used. */
 	tlbsel = (vcpu_e500->mas4 >> 28) & 0x1;
 	victim = (tlbsel == 0) ? tlb0_get_next_victim(vcpu_e500) : 0;
 	pidsel = (vcpu_e500->mas4 >> 16) & 0xf;
@@ -402,7 +402,7 @@ int kvmppc_e500_emul_tlbivax(struct kvm_vcpu *vcpu, int ra, int rb)
 
 	ia = (ea >> 2) & 0x1;
 
-	/* since we only have tow TLBs, only lower bit is used. */
+	/* since we only have two TLBs, only lower bit is used. */
 	tlbsel = (ea >> 3) & 0x1;
 
 	if (ia) {
@@ -471,7 +471,7 @@ int kvmppc_e500_emul_tlbsx(struct kvm_vcpu *vcpu, int rb)
 	} else {
 		int victim;
 
-		/* since we only have tow TLBs, only lower bit is used. */
+		/* since we only have two TLBs, only lower bit is used. */
 		tlbsel = vcpu_e500->mas4 >> 28 & 0x1;
 		victim = (tlbsel == 0) ? tlb0_get_next_victim(vcpu_e500) : 0;
 
diff --git a/arch/powerpc/kvm/e500_tlb.h b/arch/powerpc/kvm/e500_tlb.h
index d8833f9..ab49e93 100644
--- a/arch/powerpc/kvm/e500_tlb.h
+++ b/arch/powerpc/kvm/e500_tlb.h
@@ -126,7 +126,7 @@ static inline unsigned int get_tlb_tlbsel(
 {
 	/*
 	 * Manual says that tlbsel has 2 bits wide.
-	 * Since we only have tow TLBs, only lower bit is used.
+	 * Since we only have two TLBs, only lower bit is used.
 	 */
 	return (vcpu_e500->mas0 >> 28) & 0x1;
 }
-- 
1.6.0.6

