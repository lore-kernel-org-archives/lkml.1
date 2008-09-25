Return-Path: <linux-kernel-owner+w=401wt.eu-S1756153AbYIYMBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153AbYIYMBX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 08:01:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754330AbYIYLzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 07:55:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48565 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754875AbYIYLzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 07:55:48 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 17/39] KVM: VMX: Change cs reset state to be a data segment
Date: Thu, 25 Sep 2008 14:54:49 +0300
Message-Id: <1222343711-12508-18-git-send-email-avi@redhat.com>
In-Reply-To: <1222343711-12508-1-git-send-email-avi@redhat.com>
References: <1222343711-12508-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avi Kivity <avi@qumranet.com>

Real mode cs is a data segment, not a code segment.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/vmx.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 9840f37..6aa305a 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2239,6 +2239,7 @@ static int vmx_vcpu_reset(struct kvm_vcpu *vcpu)
 
 	fx_init(&vmx->vcpu);
 
+	seg_setup(VCPU_SREG_CS);
 	/*
 	 * GUEST_CS_BASE should really be 0xffff0000, but VT vm86 mode
 	 * insists on having GUEST_CS_BASE == GUEST_CS_SELECTOR << 4.  Sigh.
@@ -2250,8 +2251,6 @@ static int vmx_vcpu_reset(struct kvm_vcpu *vcpu)
 		vmcs_write16(GUEST_CS_SELECTOR, vmx->vcpu.arch.sipi_vector << 8);
 		vmcs_writel(GUEST_CS_BASE, vmx->vcpu.arch.sipi_vector << 12);
 	}
-	vmcs_write32(GUEST_CS_LIMIT, 0xffff);
-	vmcs_write32(GUEST_CS_AR_BYTES, 0x9b);
 
 	seg_setup(VCPU_SREG_DS);
 	seg_setup(VCPU_SREG_ES);
-- 
1.6.0.1

