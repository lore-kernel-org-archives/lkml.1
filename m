Return-Path: <linux-kernel-owner+w=401wt.eu-S1755246AbZHPJiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246AbZHPJiN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 05:38:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754730AbZHPJhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 05:37:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45349 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754020AbZHPJaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 05:30:12 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 26/48] KVM: VMX: Avoid duplicate ept tlb flush when setting cr3
Date: Sun, 16 Aug 2009 12:29:46 +0300
Message-Id: <1250415008-17175-27-git-send-email-avi@redhat.com>
In-Reply-To: <1250415008-17175-1-git-send-email-avi@redhat.com>
References: <1250415008-17175-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vmx_set_cr3() will call vmx_tlb_flush(), which will flush the ept context.
So there is no need to call ept_sync_context() explicitly.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index c14bffc..ea0e1d5 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1651,7 +1651,6 @@ static void vmx_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 	if (enable_ept) {
 		eptp = construct_eptp(cr3);
 		vmcs_write64(EPT_POINTER, eptp);
-		ept_sync_context(eptp);
 		ept_load_pdptrs(vcpu);
 		guest_cr3 = is_paging(vcpu) ? vcpu->arch.cr3 :
 			VMX_EPT_IDENTITY_PAGETABLE_ADDR;
-- 
1.6.3.3

