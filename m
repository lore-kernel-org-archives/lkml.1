Return-Path: <linux-kernel-owner+w=401wt.eu-S1756471AbZKSNjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471AbZKSNjx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 08:39:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756367AbZKSNju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 08:39:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44532 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752678AbZKSNfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 08:35:08 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 17/35] KVM: VMX: Use macros instead of hex value on cr0 initialization
Date: Thu, 19 Nov 2009 15:34:53 +0200
Message-Id: <1258637711-11674-18-git-send-email-avi@redhat.com>
In-Reply-To: <1258637711-11674-1-git-send-email-avi@redhat.com>
References: <1258637711-11674-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eduardo Habkost <ehabkost@redhat.com>

This should have no effect, it is just to make the code clearer.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 364263a..1773017 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2538,7 +2538,7 @@ static int vmx_vcpu_reset(struct kvm_vcpu *vcpu)
 	if (vmx->vpid != 0)
 		vmcs_write16(VIRTUAL_PROCESSOR_ID, vmx->vpid);
 
-	vmx->vcpu.arch.cr0 = 0x60000010;
+	vmx->vcpu.arch.cr0 = X86_CR0_NW | X86_CR0_CD | X86_CR0_ET;
 	vmx_set_cr0(&vmx->vcpu, vmx->vcpu.arch.cr0); /* enter rmode */
 	vmx_set_cr4(&vmx->vcpu, 0);
 	vmx_set_efer(&vmx->vcpu, 0);
-- 
1.6.5.2

