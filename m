Return-Path: <linux-kernel-owner+w=401wt.eu-S1754594AbYIKCah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594AbYIKCah (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 22:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752409AbYIKCa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 22:30:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:17863 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752253AbYIKCa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 22:30:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,375,1217833200"; 
   d="scan'208";a="438091312"
From: Sheng Yang <sheng.yang@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>,
       Sheng Yang <sheng.yang@intel.com>
Subject: [PATCH 1/2] KVM: VMX: Rename IA32_FEATURE_CONTROL bits
Date: Thu, 11 Sep 2008 10:33:51 +0800
Message-Id: <1221100432-9511-2-git-send-email-sheng.yang@intel.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Sheng Yang <sheng.yang@intel.com>
---
 arch/x86/kvm/vmx.c |   18 +++++++++---------
 arch/x86/kvm/vmx.h |    4 ++--
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 2a69773..bab7b1e 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1031,9 +1031,9 @@ static __init int vmx_disabled_by_bios(void)
 	u64 msr;
 
 	rdmsrl(MSR_IA32_FEATURE_CONTROL, msr);
-	return (msr & (MSR_IA32_FEATURE_CONTROL_LOCKED |
-		       MSR_IA32_FEATURE_CONTROL_VMXON_ENABLED))
-	    == MSR_IA32_FEATURE_CONTROL_LOCKED;
+	return (msr & (FEATURE_CONTROL_LOCKED |
+		       FEATURE_CONTROL_VMXON_ENABLED))
+	    == FEATURE_CONTROL_LOCKED;
 	/* locked but not enabled */
 }
 
@@ -1045,14 +1045,14 @@ static void hardware_enable(void *garbage)
 
 	INIT_LIST_HEAD(&per_cpu(vcpus_on_cpu, cpu));
 	rdmsrl(MSR_IA32_FEATURE_CONTROL, old);
-	if ((old & (MSR_IA32_FEATURE_CONTROL_LOCKED |
-		    MSR_IA32_FEATURE_CONTROL_VMXON_ENABLED))
-	    != (MSR_IA32_FEATURE_CONTROL_LOCKED |
-		MSR_IA32_FEATURE_CONTROL_VMXON_ENABLED))
+	if ((old & (FEATURE_CONTROL_LOCKED |
+		    FEATURE_CONTROL_VMXON_ENABLED))
+	    != (FEATURE_CONTROL_LOCKED |
+		FEATURE_CONTROL_VMXON_ENABLED))
 		/* enable and lock */
 		wrmsrl(MSR_IA32_FEATURE_CONTROL, old |
-		       MSR_IA32_FEATURE_CONTROL_LOCKED |
-		       MSR_IA32_FEATURE_CONTROL_VMXON_ENABLED);
+		       FEATURE_CONTROL_LOCKED |
+		       FEATURE_CONTROL_VMXON_ENABLED);
 	write_cr4(read_cr4() | X86_CR4_VMXE); /* FIXME: not cpu hotplug safe */
 	asm volatile (ASM_VMX_VMXON_RAX
 		      : : "a"(&phys_addr), "m"(phys_addr)
diff --git a/arch/x86/kvm/vmx.h b/arch/x86/kvm/vmx.h
index b32d4e5..bb35c23 100644
--- a/arch/x86/kvm/vmx.h
+++ b/arch/x86/kvm/vmx.h
@@ -331,8 +331,8 @@ enum vmcs_field {
 
 #define AR_RESERVD_MASK 0xfffe0f00
 
-#define MSR_IA32_FEATURE_CONTROL_LOCKED         0x1
-#define MSR_IA32_FEATURE_CONTROL_VMXON_ENABLED  0x4
+#define FEATURE_CONTROL_LOCKED			(1<<0)
+#define FEATURE_CONTROL_VMXON_ENABLED		(1<<2)
 
 #define APIC_ACCESS_PAGE_PRIVATE_MEMSLOT	9
 #define IDENTITY_PAGETABLE_PRIVATE_MEMSLOT	10
-- 
1.5.4.5

