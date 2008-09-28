Return-Path: <linux-kernel-owner+w=401wt.eu-S1754537AbYI1Psy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbYI1Psy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 11:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbYI1Ppf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 11:45:35 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50867 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753176AbYI1Ppc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 11:45:32 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Sheng Yang <sheng.yang@intel.com>
Subject: [PATCH 13/25] x86: Move VMX MSRs to msr-index.h
Date: Sun, 28 Sep 2008 18:44:49 +0300
Message-Id: <1222616701-1206-14-git-send-email-avi@redhat.com>
In-Reply-To: <1222616701-1206-1-git-send-email-avi@redhat.com>
References: <1222616701-1206-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng.yang@intel.com>

They are hardware specific MSRs, and we would use them in virtualization
feature detection later.

Signed-off-by: Sheng Yang <sheng.yang@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/vmx.h          |   15 ---------------
 include/asm-x86/msr-index.h |   16 ++++++++++++++++
 2 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/vmx.h b/arch/x86/kvm/vmx.h
index 41e8c10..86059f4 100644
--- a/arch/x86/kvm/vmx.h
+++ b/arch/x86/kvm/vmx.h
@@ -331,21 +331,6 @@ enum vmcs_field {
 
 #define AR_RESERVD_MASK 0xfffe0f00
 
-#define MSR_IA32_VMX_BASIC                      0x480
-#define MSR_IA32_VMX_PINBASED_CTLS              0x481
-#define MSR_IA32_VMX_PROCBASED_CTLS             0x482
-#define MSR_IA32_VMX_EXIT_CTLS                  0x483
-#define MSR_IA32_VMX_ENTRY_CTLS                 0x484
-#define MSR_IA32_VMX_MISC                       0x485
-#define MSR_IA32_VMX_CR0_FIXED0                 0x486
-#define MSR_IA32_VMX_CR0_FIXED1                 0x487
-#define MSR_IA32_VMX_CR4_FIXED0                 0x488
-#define MSR_IA32_VMX_CR4_FIXED1                 0x489
-#define MSR_IA32_VMX_VMCS_ENUM                  0x48a
-#define MSR_IA32_VMX_PROCBASED_CTLS2            0x48b
-#define MSR_IA32_VMX_EPT_VPID_CAP               0x48c
-
-#define MSR_IA32_FEATURE_CONTROL                0x3a
 #define IA32_FEATURE_CONTROL_LOCKED_BIT		0x1
 #define IA32_FEATURE_CONTROL_VMXON_ENABLED_BIT	0x4
 
diff --git a/include/asm-x86/msr-index.h b/include/asm-x86/msr-index.h
index 44bce77..63632b8 100644
--- a/include/asm-x86/msr-index.h
+++ b/include/asm-x86/msr-index.h
@@ -176,6 +176,7 @@
 #define MSR_IA32_TSC			0x00000010
 #define MSR_IA32_PLATFORM_ID		0x00000017
 #define MSR_IA32_EBL_CR_POWERON		0x0000002a
+#define MSR_IA32_FEATURE_CONTROL        0x0000003a
 
 #define MSR_IA32_APICBASE		0x0000001b
 #define MSR_IA32_APICBASE_BSP		(1<<8)
@@ -310,4 +311,19 @@
 /* Geode defined MSRs */
 #define MSR_GEODE_BUSCONT_CONF0		0x00001900
 
+/* Intel VT MSRs */
+#define MSR_IA32_VMX_BASIC              0x00000480
+#define MSR_IA32_VMX_PINBASED_CTLS      0x00000481
+#define MSR_IA32_VMX_PROCBASED_CTLS     0x00000482
+#define MSR_IA32_VMX_EXIT_CTLS          0x00000483
+#define MSR_IA32_VMX_ENTRY_CTLS         0x00000484
+#define MSR_IA32_VMX_MISC               0x00000485
+#define MSR_IA32_VMX_CR0_FIXED0         0x00000486
+#define MSR_IA32_VMX_CR0_FIXED1         0x00000487
+#define MSR_IA32_VMX_CR4_FIXED0         0x00000488
+#define MSR_IA32_VMX_CR4_FIXED1         0x00000489
+#define MSR_IA32_VMX_VMCS_ENUM          0x0000048a
+#define MSR_IA32_VMX_PROCBASED_CTLS2    0x0000048b
+#define MSR_IA32_VMX_EPT_VPID_CAP       0x0000048c
+
 #endif /* __ASM_MSR_INDEX_H */
-- 
1.6.0.1

