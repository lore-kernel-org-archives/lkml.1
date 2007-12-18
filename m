Return-Path: <linux-kernel-owner+w=401wt.eu-S1754457AbXLRVqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457AbXLRVqZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 16:46:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbXLRVqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 16:46:17 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45194 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750700AbXLRVqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 16:46:16 -0500
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH x86/mm] kvm IOPL_MASK cleanup
X-Fcc: ~/Mail/linus
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20071218214604.E07B326F8C2@magilla.localdomain>
Date: Tue, 18 Dec 2007 13:46:01 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IOPL_MASK went away and kvm/vmx.c doesn't compile.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index bb56ae3..0000000 100644  
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -524,7 +524,7 @@ static unsigned long vmx_get_rflags(stru
 static void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
 {
 	if (vcpu->rmode.active)
-		rflags |= IOPL_MASK | X86_EFLAGS_VM;
+		rflags |= X86_EFLAGS_IOPL | X86_EFLAGS_VM;
 	vmcs_writel(GUEST_RFLAGS, rflags);
 }
 
@@ -1050,7 +1050,7 @@ static void enter_pmode(struct kvm_vcpu 
 	vmcs_write32(GUEST_TR_AR_BYTES, vcpu->rmode.tr.ar);
 
 	flags = vmcs_readl(GUEST_RFLAGS);
-	flags &= ~(IOPL_MASK | X86_EFLAGS_VM);
+	flags &= ~(X86_EFLAGS_IOPL | X86_EFLAGS_VM);
 	flags |= (vcpu->rmode.save_iopl << IOPL_SHIFT);
 	vmcs_writel(GUEST_RFLAGS, flags);
 
@@ -1107,9 +1107,9 @@ static void enter_rmode(struct kvm_vcpu 
 	vmcs_write32(GUEST_TR_AR_BYTES, 0x008b);
 
 	flags = vmcs_readl(GUEST_RFLAGS);
-	vcpu->rmode.save_iopl = (flags & IOPL_MASK) >> IOPL_SHIFT;
+	vcpu->rmode.save_iopl = (flags & X86_EFLAGS_IOPL) >> IOPL_SHIFT;
 
-	flags |= IOPL_MASK | X86_EFLAGS_VM;
+	flags |= X86_EFLAGS_IOPL | X86_EFLAGS_VM;
 
 	vmcs_writel(GUEST_RFLAGS, flags);
 	vmcs_writel(GUEST_CR4, vmcs_readl(GUEST_CR4) | X86_CR4_VME);
