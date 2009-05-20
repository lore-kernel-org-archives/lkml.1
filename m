Return-Path: <linux-kernel-owner+w=401wt.eu-S1759363AbZETLb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759363AbZETLb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 07:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757137AbZETLVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 07:21:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55264 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755137AbZETLSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 07:18:47 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 08/46] KVM: VMX: Clean up Flex Priority related
Date: Wed, 20 May 2009 14:18:05 +0300
Message-Id: <1242818323-10413-9-git-send-email-avi@redhat.com>
In-Reply-To: <1242818323-10413-1-git-send-email-avi@redhat.com>
References: <1242818323-10413-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

And clean paranthes on returns.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |   47 ++++++++++++++++++++++++++++++-----------------
 1 files changed, 30 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index aba41ae..1caa1fc 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -216,61 +216,69 @@ static inline int is_external_interrupt(u32 intr_info)
 
 static inline int cpu_has_vmx_msr_bitmap(void)
 {
-	return (vmcs_config.cpu_based_exec_ctrl & CPU_BASED_USE_MSR_BITMAPS);
+	return vmcs_config.cpu_based_exec_ctrl & CPU_BASED_USE_MSR_BITMAPS;
 }
 
 static inline int cpu_has_vmx_tpr_shadow(void)
 {
-	return (vmcs_config.cpu_based_exec_ctrl & CPU_BASED_TPR_SHADOW);
+	return vmcs_config.cpu_based_exec_ctrl & CPU_BASED_TPR_SHADOW;
 }
 
 static inline int vm_need_tpr_shadow(struct kvm *kvm)
 {
-	return ((cpu_has_vmx_tpr_shadow()) && (irqchip_in_kernel(kvm)));
+	return (cpu_has_vmx_tpr_shadow()) && (irqchip_in_kernel(kvm));
 }
 
 static inline int cpu_has_secondary_exec_ctrls(void)
 {
-	return (vmcs_config.cpu_based_exec_ctrl &
-		CPU_BASED_ACTIVATE_SECONDARY_CONTROLS);
+	return vmcs_config.cpu_based_exec_ctrl &
+		CPU_BASED_ACTIVATE_SECONDARY_CONTROLS;
 }
 
 static inline bool cpu_has_vmx_virtualize_apic_accesses(void)
 {
-	return flexpriority_enabled;
+	return vmcs_config.cpu_based_2nd_exec_ctrl &
+		SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES;
+}
+
+static inline bool cpu_has_vmx_flexpriority(void)
+{
+	return cpu_has_vmx_tpr_shadow() &&
+		cpu_has_vmx_virtualize_apic_accesses();
 }
 
 static inline int cpu_has_vmx_invept_individual_addr(void)
 {
-	return (!!(vmx_capability.ept & VMX_EPT_EXTENT_INDIVIDUAL_BIT));
+	return !!(vmx_capability.ept & VMX_EPT_EXTENT_INDIVIDUAL_BIT);
 }
 
 static inline int cpu_has_vmx_invept_context(void)
 {
-	return (!!(vmx_capability.ept & VMX_EPT_EXTENT_CONTEXT_BIT));
+	return !!(vmx_capability.ept & VMX_EPT_EXTENT_CONTEXT_BIT);
 }
 
 static inline int cpu_has_vmx_invept_global(void)
 {
-	return (!!(vmx_capability.ept & VMX_EPT_EXTENT_GLOBAL_BIT));
+	return !!(vmx_capability.ept & VMX_EPT_EXTENT_GLOBAL_BIT);
 }
 
 static inline int cpu_has_vmx_ept(void)
 {
-	return (vmcs_config.cpu_based_2nd_exec_ctrl &
-		SECONDARY_EXEC_ENABLE_EPT);
+	return vmcs_config.cpu_based_2nd_exec_ctrl &
+		SECONDARY_EXEC_ENABLE_EPT;
 }
 
 static inline int vm_need_virtualize_apic_accesses(struct kvm *kvm)
 {
-	return ((cpu_has_vmx_virtualize_apic_accesses()) &&
-		(irqchip_in_kernel(kvm)));
+	return flexpriority_enabled &&
+		(cpu_has_vmx_virtualize_apic_accesses()) &&
+		(irqchip_in_kernel(kvm));
 }
 
 static inline int cpu_has_vmx_vpid(void)
 {
-	return (vmcs_config.cpu_based_2nd_exec_ctrl &
-		SECONDARY_EXEC_ENABLE_VPID);
+	return vmcs_config.cpu_based_2nd_exec_ctrl &
+		SECONDARY_EXEC_ENABLE_VPID;
 }
 
 static inline int cpu_has_virtual_nmis(void)
@@ -278,6 +286,11 @@ static inline int cpu_has_virtual_nmis(void)
 	return vmcs_config.pin_based_exec_ctrl & PIN_BASED_VIRTUAL_NMIS;
 }
 
+static inline bool report_flexpriority(void)
+{
+	return flexpriority_enabled;
+}
+
 static int __find_msr_index(struct vcpu_vmx *vmx, u32 msr)
 {
 	int i;
@@ -1201,7 +1214,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf)
 	if (!cpu_has_vmx_ept())
 		enable_ept = 0;
 
-	if (!(vmcs_config.cpu_based_2nd_exec_ctrl & SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES))
+	if (!cpu_has_vmx_flexpriority())
 		flexpriority_enabled = 0;
 
 	min = 0;
@@ -3655,7 +3668,7 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.check_processor_compatibility = vmx_check_processor_compat,
 	.hardware_enable = hardware_enable,
 	.hardware_disable = hardware_disable,
-	.cpu_has_accelerated_tpr = cpu_has_vmx_virtualize_apic_accesses,
+	.cpu_has_accelerated_tpr = report_flexpriority,
 
 	.vcpu_create = vmx_create_vcpu,
 	.vcpu_free = vmx_free_vcpu,
-- 
1.6.0.6

