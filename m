Return-Path: <linux-kernel-owner+w=401wt.eu-S1759659AbXIQJB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759659AbXIQJB4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 05:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754721AbXIQIdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:33:53 -0400
Received: from il.qumranet.com ([82.166.9.18]:45244 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753907AbXIQIc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:29 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, "Li, Xin B" <xin.b.li@intel.com>
Subject: [PATCH 050/104] KVM: VMX: Remove a duplicated ia32e mode vm entry control
Date: Mon, 17 Sep 2007 10:31:32 +0200
Message-Id: <11900179481890-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li, Xin B <xin.b.li@intel.com>

Remove a duplicated ia32e mode VM Entry control definition and use the
proper one.

Signed-off-by: Xin Li <xin.b.li@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/vmx.c |    8 ++++----
 drivers/kvm/vmx.h |    3 ---
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 708055a..30c627d 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -1111,7 +1111,7 @@ static void enter_lmode(struct kvm_vcpu *vcpu)
 	find_msr_entry(to_vmx(vcpu), MSR_EFER)->data |= EFER_LMA | EFER_LME;
 	vmcs_write32(VM_ENTRY_CONTROLS,
 		     vmcs_read32(VM_ENTRY_CONTROLS)
-		     | VM_ENTRY_CONTROLS_IA32E_MASK);
+		     | VM_ENTRY_IA32E_MODE);
 }
 
 static void exit_lmode(struct kvm_vcpu *vcpu)
@@ -1120,7 +1120,7 @@ static void exit_lmode(struct kvm_vcpu *vcpu)
 
 	vmcs_write32(VM_ENTRY_CONTROLS,
 		     vmcs_read32(VM_ENTRY_CONTROLS)
-		     & ~VM_ENTRY_CONTROLS_IA32E_MASK);
+		     & ~VM_ENTRY_IA32E_MODE);
 }
 
 #endif
@@ -1185,13 +1185,13 @@ static void vmx_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 	if (efer & EFER_LMA) {
 		vmcs_write32(VM_ENTRY_CONTROLS,
 				     vmcs_read32(VM_ENTRY_CONTROLS) |
-				     VM_ENTRY_CONTROLS_IA32E_MASK);
+				     VM_ENTRY_IA32E_MODE);
 		msr->data = efer;
 
 	} else {
 		vmcs_write32(VM_ENTRY_CONTROLS,
 				     vmcs_read32(VM_ENTRY_CONTROLS) &
-				     ~VM_ENTRY_CONTROLS_IA32E_MASK);
+				     ~VM_ENTRY_IA32E_MODE);
 
 		msr->data = efer & ~EFER_LME;
 	}
diff --git a/drivers/kvm/vmx.h b/drivers/kvm/vmx.h
index 7e4dc12..35d0b58 100644
--- a/drivers/kvm/vmx.h
+++ b/drivers/kvm/vmx.h
@@ -268,9 +268,6 @@ enum vmcs_field {
 /* segment AR */
 #define SEGMENT_AR_L_MASK (1 << 13)
 
-/* entry controls */
-#define VM_ENTRY_CONTROLS_IA32E_MASK (1 << 9)
-
 #define AR_TYPE_ACCESSES_MASK 1
 #define AR_TYPE_READABLE_MASK (1 << 1)
 #define AR_TYPE_WRITEABLE_MASK (1 << 2)
-- 
1.5.3

