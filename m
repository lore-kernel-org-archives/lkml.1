Return-Path: <linux-kernel-owner+w=401wt.eu-S1758610AbYLIUjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758610AbYLIUjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 15:39:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754659AbYLIUYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 15:24:45 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34853 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754717AbYLIUXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 15:23:09 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hollis Blanchard <hollisb@us.ibm.com>
Subject: [PATCH 13/44] KVM: ppc: use MMUCR accessor to obtain TID
Date: Tue,  9 Dec 2008 22:22:28 +0200
Message-Id: <1228854179-23002-14-git-send-email-avi@redhat.com>
In-Reply-To: <1228854179-23002-1-git-send-email-avi@redhat.com>
References: <1228854179-23002-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

We have an accessor; might as well use it.

Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/kvm/44x_tlb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kvm/44x_tlb.c b/arch/powerpc/kvm/44x_tlb.c
index 8b65fbd..260fa8b 100644
--- a/arch/powerpc/kvm/44x_tlb.c
+++ b/arch/powerpc/kvm/44x_tlb.c
@@ -339,7 +339,7 @@ int kvmppc_44x_emul_tlbwe(struct kvm_vcpu *vcpu, u8 ra, u8 rs, u8 ws)
 
 	switch (ws) {
 	case PPC44x_TLB_PAGEID:
-		tlbe->tid = vcpu->arch.mmucr & 0xff;
+		tlbe->tid = get_mmucr_stid(vcpu);
 		tlbe->word0 = vcpu->arch.gpr[rs];
 		break;
 
-- 
1.6.0.3

