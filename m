Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932899Ab0BPKkG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 05:40:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28898 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932815Ab0BPKfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 05:35:41 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 23/38] KVM: PPC: Add PVR/PIR init for E500
Date: Tue, 16 Feb 2010 12:35:21 +0200
Message-Id: <1266316536-28936-24-git-send-email-avi@redhat.com>
In-Reply-To: <1266316536-28936-1-git-send-email-avi@redhat.com>
References: <1266316536-28936-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Yu <yu.liu@freescale.com>

commit 513579e3a391a3874c478a8493080822069976e8 change the way
we emulate PVR/PIR,
which left PVR/PIR uninitialized on E500, and make guest puzzled.

Signed-off-by: Liu Yu <yu.liu@freescale.com>
Acked-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/powerpc/kvm/e500.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kvm/e500.c b/arch/powerpc/kvm/e500.c
index 64949ee..efa1198 100644
--- a/arch/powerpc/kvm/e500.c
+++ b/arch/powerpc/kvm/e500.c
@@ -60,6 +60,12 @@ int kvmppc_core_vcpu_setup(struct kvm_vcpu *vcpu)
 
 	kvmppc_e500_tlb_setup(vcpu_e500);
 
+	/* Registers init */
+	vcpu->arch.pvr = mfspr(SPRN_PVR);
+
+	/* Since booke kvm only support one core, update all vcpus' PIR to 0 */
+	vcpu->vcpu_id = 0;
+
 	return 0;
 }
 
-- 
1.6.5.3

