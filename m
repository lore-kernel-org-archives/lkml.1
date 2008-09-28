Return-Path: <linux-kernel-owner+w=401wt.eu-S1754582AbYI1PtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582AbYI1PtU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 11:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753239AbYI1Pph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 11:45:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50870 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753204AbYI1Ppd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 11:45:33 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Sheng Yang <sheng.yang@intel.com>
Subject: [PATCH 14/25] KVM: VMX: Rename IA32_FEATURE_CONTROL bits
Date: Sun, 28 Sep 2008 18:44:50 +0300
Message-Id: <1222616701-1206-15-git-send-email-avi@redhat.com>
In-Reply-To: <1222616701-1206-1-git-send-email-avi@redhat.com>
References: <1222616701-1206-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng.yang@intel.com>

Signed-off-by: Sheng Yang <sheng.yang@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/vmx.c |   18 +++++++++---------
 arch/x86/kvm/vmx.h |    4 ++--
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index f8e615f..046a91b 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1041,9 +1041,9 @@ static __init int vmx_disabled_by_bios(void)
 	u64 msr;
 
 	rdmsrl(MSR_IA32_FEATURE_CONTROL, msr);
-	return (msr & (IA32_FEATURE_CONTROL_LOCKED_BIT |
-		       IA32_FEATURE_CONTROL_VMXON_ENABLED_BIT))
-	    == IA32_FEATURE_CONTROL_LOCKED_BIT;
+	return (msr & (FEATURE_CONTROL_LOCKED |
+		       FEATURE_CONTROL_VMXON_ENABLED))
+	    == FEATURE_CONTROL_LOCKED;
 	/* locked but not enabled */
 }
 
@@ -1055,14 +1055,14 @@ static void hardware_enable(void *garbage)
 
 	INIT_LIST_HEAD(&per_cpu(vcpus_on_cpu, cpu));
 	rdmsrl(MSR_IA32_FEATURE_CONTROL, old);
-	if ((old & (IA32_FEATURE_CONTROL_LOCKED_BIT |
-		    IA32_FEATURE_CONTROL_VMXON_ENABLED_BIT))
-	    != (IA32_FEATURE_CONTROL_LOCKED_BIT |
-		IA32_FEATURE_CONTROL_VMXON_ENABLED_BIT))
+	if ((old & (FEATURE_CONTROL_LOCKED |
+		    FEATURE_CONTROL_VMXON_ENABLED))
+	    != (FEATURE_CONTROL_LOCKED |
+		FEATURE_CONTROL_VMXON_ENABLED))
 		/* enable and lock */
 		wrmsrl(MSR_IA32_FEATURE_CONTROL, old |
-		       IA32_FEATURE_CONTROL_LOCKED_BIT |
-		       IA32_FEATURE_CONTROL_VMXON_ENABLED_BIT);
+		       FEATURE_CONTROL_LOCKED |
+		       FEATURE_CONTROL_VMXON_ENABLED);
 	write_cr4(read_cr4() | X86_CR4_VMXE); /* FIXME: not cpu hotplug safe */
 	asm volatile (ASM_VMX_VMXON_RAX
 		      : : "a"(&phys_addr), "m"(phys_addr)
diff --git a/arch/x86/kvm/vmx.h b/arch/x86/kvm/vmx.h
index 86059f4..44cfab7 100644
--- a/arch/x86/kvm/vmx.h
+++ b/arch/x86/kvm/vmx.h
@@ -331,8 +331,8 @@ enum vmcs_field {
 
 #define AR_RESERVD_MASK 0xfffe0f00
 
-#define IA32_FEATURE_CONTROL_LOCKED_BIT		0x1
-#define IA32_FEATURE_CONTROL_VMXON_ENABLED_BIT	0x4
+#define FEATURE_CONTROL_LOCKED		    (1<<0)
+#define FEATURE_CONTROL_VMXON_ENABLED	    (1<<2)
 
 #define APIC_ACCESS_PAGE_PRIVATE_MEMSLOT	9
 #define IDENTITY_PAGETABLE_PRIVATE_MEMSLOT	10
-- 
1.6.0.1

