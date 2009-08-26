Return-Path: <linux-kernel-owner+w=401wt.eu-S932257AbZHZKcL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257AbZHZKcL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:32:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932433AbZHZKbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:31:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757133AbZHZKaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:30:15 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 45/47] KVM: VMX: Fix EPT with WP bit change during paging
Date: Wed, 26 Aug 2009 13:30:07 +0300
Message-Id: <1251282609-12835-46-git-send-email-avi@redhat.com>
In-Reply-To: <1251282609-12835-1-git-send-email-avi@redhat.com>
References: <1251282609-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

QNX update WP bit when paging enabled, which is not covered yet. This one fix
QNX boot with EPT.

Cc: stable@kernel.org
Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 2b7e7bd..1ee811c 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1642,7 +1642,6 @@ static void ept_update_paging_mode_cr0(unsigned long *hw_cr0,
 			      CPU_BASED_CR3_STORE_EXITING));
 		vcpu->arch.cr0 = cr0;
 		vmx_set_cr4(vcpu, vcpu->arch.cr4);
-		*hw_cr0 &= ~X86_CR0_WP;
 	} else if (!is_paging(vcpu)) {
 		/* From nonpaging to paging */
 		vmcs_write32(CPU_BASED_VM_EXEC_CONTROL,
@@ -1651,9 +1650,10 @@ static void ept_update_paging_mode_cr0(unsigned long *hw_cr0,
 			       CPU_BASED_CR3_STORE_EXITING));
 		vcpu->arch.cr0 = cr0;
 		vmx_set_cr4(vcpu, vcpu->arch.cr4);
-		if (!(vcpu->arch.cr0 & X86_CR0_WP))
-			*hw_cr0 &= ~X86_CR0_WP;
 	}
+
+	if (!(cr0 & X86_CR0_WP))
+		*hw_cr0 &= ~X86_CR0_WP;
 }
 
 static void ept_update_paging_mode_cr4(unsigned long *hw_cr4,
-- 
1.6.4.1

