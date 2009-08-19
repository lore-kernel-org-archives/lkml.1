Return-Path: <linux-kernel-owner+w=401wt.eu-S1752111AbZHSNDD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbZHSNDD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:03:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752076AbZHSNCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:02:53 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50550 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751892AbZHSNCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:02:46 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 09/47] KVM: VMX: more MSR_IA32_VMX_EPT_VPID_CAP capability bits
Date: Wed, 19 Aug 2009 16:02:05 +0300
Message-Id: <1250686963-8357-10-git-send-email-avi@redhat.com>
In-Reply-To: <1250686963-8357-1-git-send-email-avi@redhat.com>
References: <1250686963-8357-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Required for EPT misconfiguration handler.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/vmx.h |    7 +++++++
 arch/x86/kvm/vmx.c         |   20 ++++++++++++++++++++
 2 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index e7927a6..272514c 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -352,9 +352,16 @@ enum vmcs_field {
 #define VMX_EPT_EXTENT_INDIVIDUAL_ADDR		0
 #define VMX_EPT_EXTENT_CONTEXT			1
 #define VMX_EPT_EXTENT_GLOBAL			2
+
+#define VMX_EPT_EXECUTE_ONLY_BIT		(1ull)
+#define VMX_EPT_PAGE_WALK_4_BIT			(1ull << 6)
+#define VMX_EPTP_UC_BIT				(1ull << 8)
+#define VMX_EPTP_WB_BIT				(1ull << 14)
+#define VMX_EPT_2MB_PAGE_BIT			(1ull << 16)
 #define VMX_EPT_EXTENT_INDIVIDUAL_BIT		(1ull << 24)
 #define VMX_EPT_EXTENT_CONTEXT_BIT		(1ull << 25)
 #define VMX_EPT_EXTENT_GLOBAL_BIT		(1ull << 26)
+
 #define VMX_EPT_DEFAULT_GAW			3
 #define VMX_EPT_MAX_GAW				0x4
 #define VMX_EPT_MT_EPTE_SHIFT			3
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 6ee9292..6610181 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -270,6 +270,26 @@ static inline bool cpu_has_vmx_flexpriority(void)
 		cpu_has_vmx_virtualize_apic_accesses();
 }
 
+static inline bool cpu_has_vmx_ept_execute_only(void)
+{
+	return !!(vmx_capability.ept & VMX_EPT_EXECUTE_ONLY_BIT);
+}
+
+static inline bool cpu_has_vmx_eptp_uncacheable(void)
+{
+	return !!(vmx_capability.ept & VMX_EPTP_UC_BIT);
+}
+
+static inline bool cpu_has_vmx_eptp_writeback(void)
+{
+	return !!(vmx_capability.ept & VMX_EPTP_WB_BIT);
+}
+
+static inline bool cpu_has_vmx_ept_2m_page(void)
+{
+	return !!(vmx_capability.ept & VMX_EPT_2MB_PAGE_BIT);
+}
+
 static inline int cpu_has_vmx_invept_individual_addr(void)
 {
 	return !!(vmx_capability.ept & VMX_EPT_EXTENT_INDIVIDUAL_BIT);
-- 
1.6.3.3

