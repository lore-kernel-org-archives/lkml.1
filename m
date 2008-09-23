Return-Path: <linux-kernel-owner+w=401wt.eu-S1752191AbYIWNru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbYIWNru (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 09:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbYIWNrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 09:47:03 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52330 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592AbYIWNrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 09:47:00 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Sheng Yang <sheng.yang@intel.com>
Subject: [PATCH 01/40] KVM: VMX: Rename misnamed msr bits
Date: Tue, 23 Sep 2008 16:46:15 +0300
Message-Id: <1222177614-26669-2-git-send-email-avi@redhat.com>
In-Reply-To: <1222177614-26669-1-git-send-email-avi@redhat.com>
References: <1222177614-26669-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng.yang@intel.com>

MSR_IA32_FEATURE_LOCKED is just a bit in fact, which shouldn't be prefixed with
MSR_.  So is MSR_IA32_FEATURE_VMXON_ENABLED.

Signed-off-by: Sheng Yang <sheng.yang@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/vmx.c |   18 +++++++++---------
 arch/x86/kvm/vmx.h |    4 ++--
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 7041cc5..81dac72 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1031,9 +1031,9 @@ static __init int vmx_disabled_by_bios(void)
 	u64 msr;
 
 	rdmsrl(MSR_IA32_FEATURE_CONTROL, msr);
-	return (msr & (MSR_IA32_FEATURE_CONTROL_LOCKED |
-		       MSR_IA32_FEATURE_CONTROL_VMXON_ENABLED))
-	    == MSR_IA32_FEATURE_CONTROL_LOCKED;
+	return (msr & (IA32_FEATURE_CONTROL_LOCKED_BIT |
+		       IA32_FEATURE_CONTROL_VMXON_ENABLED_BIT))
+	    == IA32_FEATURE_CONTROL_LOCKED_BIT;
 	/* locked but not enabled */
 }
 
@@ -1045,14 +1045,14 @@ static void hardware_enable(void *garbage)
 
 	INIT_LIST_HEAD(&per_cpu(vcpus_on_cpu, cpu));
 	rdmsrl(MSR_IA32_FEATURE_CONTROL, old);
-	if ((old & (MSR_IA32_FEATURE_CONTROL_LOCKED |
-		    MSR_IA32_FEATURE_CONTROL_VMXON_ENABLED))
-	    != (MSR_IA32_FEATURE_CONTROL_LOCKED |
-		MSR_IA32_FEATURE_CONTROL_VMXON_ENABLED))
+	if ((old & (IA32_FEATURE_CONTROL_LOCKED_BIT |
+		    IA32_FEATURE_CONTROL_VMXON_ENABLED_BIT))
+	    != (IA32_FEATURE_CONTROL_LOCKED_BIT |
+		IA32_FEATURE_CONTROL_VMXON_ENABLED_BIT))
 		/* enable and lock */
 		wrmsrl(MSR_IA32_FEATURE_CONTROL, old |
-		       MSR_IA32_FEATURE_CONTROL_LOCKED |
-		       MSR_IA32_FEATURE_CONTROL_VMXON_ENABLED);
+		       IA32_FEATURE_CONTROL_LOCKED_BIT |
+		       IA32_FEATURE_CONTROL_VMXON_ENABLED_BIT);
 	write_cr4(read_cr4() | X86_CR4_VMXE); /* FIXME: not cpu hotplug safe */
 	asm volatile (ASM_VMX_VMXON_RAX
 		      : : "a"(&phys_addr), "m"(phys_addr)
diff --git a/arch/x86/kvm/vmx.h b/arch/x86/kvm/vmx.h
index 23e8373..41e8c10 100644
--- a/arch/x86/kvm/vmx.h
+++ b/arch/x86/kvm/vmx.h
@@ -346,8 +346,8 @@ enum vmcs_field {
 #define MSR_IA32_VMX_EPT_VPID_CAP               0x48c
 
 #define MSR_IA32_FEATURE_CONTROL                0x3a
-#define MSR_IA32_FEATURE_CONTROL_LOCKED         0x1
-#define MSR_IA32_FEATURE_CONTROL_VMXON_ENABLED  0x4
+#define IA32_FEATURE_CONTROL_LOCKED_BIT		0x1
+#define IA32_FEATURE_CONTROL_VMXON_ENABLED_BIT	0x4
 
 #define APIC_ACCESS_PAGE_PRIVATE_MEMSLOT	9
 #define IDENTITY_PAGETABLE_PRIVATE_MEMSLOT	10
-- 
1.6.0.1

