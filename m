Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934308Ab0BQNtR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 08:49:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934064Ab0BQNph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 08:45:37 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 03/20] KVM: VMX: Rename VMX_EPT_IGMT_BIT to VMX_EPT_IPAT_BIT
Date: Wed, 17 Feb 2010 15:45:13 +0200
Message-Id: <1266414330-27444-4-git-send-email-avi@redhat.com>
In-Reply-To: <1266414330-27444-1-git-send-email-avi@redhat.com>
References: <1266414330-27444-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

Following the new SDM. Now the bit is named "Ignore PAT memory type".

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/vmx.h |    2 +-
 arch/x86/kvm/vmx.c         |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 43f1e9b..fb9a080 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -377,7 +377,7 @@ enum vmcs_field {
 #define VMX_EPT_READABLE_MASK			0x1ull
 #define VMX_EPT_WRITABLE_MASK			0x2ull
 #define VMX_EPT_EXECUTABLE_MASK			0x4ull
-#define VMX_EPT_IGMT_BIT    			(1ull << 6)
+#define VMX_EPT_IPAT_BIT    			(1ull << 6)
 
 #define VMX_EPT_IDENTITY_PAGETABLE_ADDR		0xfffbc000ul
 
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index b400be0..f82b072 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -4001,7 +4001,7 @@ static u64 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 	 *   b. VT-d with snooping control feature: snooping control feature of
 	 *	VT-d engine can guarantee the cache correctness. Just set it
 	 *	to WB to keep consistent with host. So the same as item 3.
-	 * 3. EPT without VT-d: always map as WB and set IGMT=1 to keep
+	 * 3. EPT without VT-d: always map as WB and set IPAT=1 to keep
 	 *    consistent with host MTRR
 	 */
 	if (is_mmio)
@@ -4012,7 +4012,7 @@ static u64 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 		      VMX_EPT_MT_EPTE_SHIFT;
 	else
 		ret = (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT)
-			| VMX_EPT_IGMT_BIT;
+			| VMX_EPT_IPAT_BIT;
 
 	return ret;
 }
-- 
1.6.5.3

