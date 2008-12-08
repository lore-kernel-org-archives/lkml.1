Return-Path: <linux-kernel-owner+w=401wt.eu-S1753552AbYLHLjH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbYLHLjH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:39:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341AbYLHLhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:37:07 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48212 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753214AbYLHLhC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:37:02 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>
Subject: [PATCH 03/45] KVM: VMX: Use INTR_TYPE_NMI_INTR instead of magic value
Date: Mon,  8 Dec 2008 13:36:14 +0200
Message-Id: <1228736216-15787-4-git-send-email-avi@redhat.com>
In-Reply-To: <1228736216-15787-1-git-send-email-avi@redhat.com>
References: <1228736216-15787-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index ac34537..81cf12b 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2492,7 +2492,7 @@ static int handle_exception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		set_bit(irq / BITS_PER_LONG, &vcpu->arch.irq_summary);
 	}
 
-	if ((intr_info & INTR_INFO_INTR_TYPE_MASK) == 0x200) /* nmi */
+	if ((intr_info & INTR_INFO_INTR_TYPE_MASK) == INTR_TYPE_NMI_INTR)
 		return 1;  /* already handled by vmx_vcpu_run() */
 
 	if (is_no_device(intr_info)) {
@@ -3337,7 +3337,7 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
 
 	/* We need to handle NMIs before interrupts are enabled */
-	if ((intr_info & INTR_INFO_INTR_TYPE_MASK) == 0x200 &&
+	if ((intr_info & INTR_INFO_INTR_TYPE_MASK) == INTR_TYPE_NMI_INTR &&
 	    (intr_info & INTR_INFO_VALID_MASK)) {
 		KVMTRACE_0D(NMI, vcpu, handler);
 		asm("int $2");
-- 
1.6.0.3

