Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252Ab0BJRbe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 12:31:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65403 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755385Ab0BJRXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 12:23:13 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 08/40] KVM: VMX: When using ept, allow the guest to own cr4.pge
Date: Wed, 10 Feb 2010 19:22:37 +0200
Message-Id: <1265822589-11155-9-git-send-email-avi@redhat.com>
In-Reply-To: <1265822589-11155-1-git-send-email-avi@redhat.com>
References: <1265822589-11155-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We make no use of cr4.pge if ept is enabled, but the guest does (to flush
global mappings, as with vmap()), so give the guest ownership of this bit.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 755811a..a7ebaa5 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2424,6 +2424,8 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
 
 	vmcs_writel(CR0_GUEST_HOST_MASK, ~0UL);
 	vmx->vcpu.arch.cr4_guest_owned_bits = KVM_CR4_GUEST_OWNED_BITS;
+	if (enable_ept)
+		vmx->vcpu.arch.cr4_guest_owned_bits |= X86_CR4_PGE;
 	vmcs_writel(CR4_GUEST_HOST_MASK, ~vmx->vcpu.arch.cr4_guest_owned_bits);
 
 	tsc_base = vmx->vcpu.kvm->arch.vm_init_tsc;
-- 
1.6.5.3

