Return-Path: <linux-kernel-owner+w=401wt.eu-S1756447AbYIIGw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756447AbYIIGw2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 02:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754982AbYIIGwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 02:52:01 -0400
Received: from mga14.intel.com ([143.182.124.37]:9744 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756261AbYIIGwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 02:52:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,363,1217833200"; 
   d="scan'208";a="43740651"
From: Sheng Yang <sheng.yang@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>,
       Andi Kleen <ak@linux.intel.com>, "\"H. Peter Anvin\"" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Sheng Yang <sheng.yang@intel.com>
Subject: [PATCH 1/2] x86: Move VMX MSRs to msr-index.h
Date: Tue,  9 Sep 2008 14:54:53 +0800
Message-Id: <1220943294558-git-send-email-sheng.yang@intel.com>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <12209432941440-git-send-email-sheng.yang@intel.com>
References: <12209432941440-git-send-email-sheng.yang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They are hardware specific MSRs, and we would use them in virtualization
feature detection later.

Signed-off-by: Sheng Yang <sheng.yang@intel.com>
---
 arch/x86/kvm/vmx.h          |   15 ---------------
 include/asm-x86/msr-index.h |   16 ++++++++++++++++
 2 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/vmx.h b/arch/x86/kvm/vmx.h
index 425a134..b32d4e5 100644
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
 #define MSR_IA32_FEATURE_CONTROL_LOCKED         0x1
 #define MSR_IA32_FEATURE_CONTROL_VMXON_ENABLED  0x4
 
diff --git a/include/asm-x86/msr-index.h b/include/asm-x86/msr-index.h
index 3052f05..0bb4330 100644
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
 #endif /* ASM_X86__MSR_INDEX_H */
-- 
1.5.4.5

