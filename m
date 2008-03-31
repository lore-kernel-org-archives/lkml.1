Return-Path: <linux-kernel-owner+w=401wt.eu-S1759666AbYCaOqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759666AbYCaOqu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 10:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753298AbYCaOht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 10:37:49 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:51326
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbYCaOhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 10:37:35 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Ryan Harper <ryanh@us.ibm.com>
Subject: [PATCH 28/40] KVM: VMX: fix typo in VMX header define
Date: Mon, 31 Mar 2008 17:37:12 +0300
Message-Id: <1206974244-9716-29-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1206974244-9716-1-git-send-email-avi@qumranet.com>
References: <1206974244-9716-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ryan Harper <ryanh@us.ibm.com>

Looking at Intel Volume 3b, page 148, table 20-11 and noticed
that the field name is 'Deliver' not 'Deliever'.  Attached patch changes
the define name and its user in vmx.c

Signed-off-by: Ryan Harper <ryanh@us.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/vmx.c |    6 +++---
 arch/x86/kvm/vmx.h |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 76944f2..2d5ccec 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -632,7 +632,7 @@ static void vmx_queue_exception(struct kvm_vcpu *vcpu, unsigned nr,
 {
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD,
 		     nr | INTR_TYPE_EXCEPTION
-		     | (has_error_code ? INTR_INFO_DELIEVER_CODE_MASK : 0)
+		     | (has_error_code ? INTR_INFO_DELIVER_CODE_MASK : 0)
 		     | INTR_INFO_VALID_MASK);
 	if (has_error_code)
 		vmcs_write32(VM_ENTRY_EXCEPTION_ERROR_CODE, error_code);
@@ -1935,7 +1935,7 @@ static int handle_exception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 	error_code = 0;
 	rip = vmcs_readl(GUEST_RIP);
-	if (intr_info & INTR_INFO_DELIEVER_CODE_MASK)
+	if (intr_info & INTR_INFO_DELIVER_CODE_MASK)
 		error_code = vmcs_read32(VM_EXIT_INTR_ERROR_CODE);
 	if (is_page_fault(intr_info)) {
 		cr2 = vmcs_readl(EXIT_QUALIFICATION);
@@ -2351,7 +2351,7 @@ static void vmx_intr_assist(struct kvm_vcpu *vcpu)
 		vmcs_write32(VM_ENTRY_INSTRUCTION_LEN,
 				vmcs_read32(VM_EXIT_INSTRUCTION_LEN));
 
-		if (unlikely(idtv_info_field & INTR_INFO_DELIEVER_CODE_MASK))
+		if (unlikely(idtv_info_field & INTR_INFO_DELIVER_CODE_MASK))
 			vmcs_write32(VM_ENTRY_EXCEPTION_ERROR_CODE,
 				vmcs_read32(IDT_VECTORING_ERROR_CODE));
 		if (unlikely(has_ext_irq))
diff --git a/arch/x86/kvm/vmx.h b/arch/x86/kvm/vmx.h
index 436ce0f..5dff460 100644
--- a/arch/x86/kvm/vmx.h
+++ b/arch/x86/kvm/vmx.h
@@ -233,12 +233,12 @@ enum vmcs_field {
  */
 #define INTR_INFO_VECTOR_MASK           0xff            /* 7:0 */
 #define INTR_INFO_INTR_TYPE_MASK        0x700           /* 10:8 */
-#define INTR_INFO_DELIEVER_CODE_MASK    0x800           /* 11 */
+#define INTR_INFO_DELIVER_CODE_MASK     0x800           /* 11 */
 #define INTR_INFO_VALID_MASK            0x80000000      /* 31 */
 
 #define VECTORING_INFO_VECTOR_MASK           	INTR_INFO_VECTOR_MASK
 #define VECTORING_INFO_TYPE_MASK        	INTR_INFO_INTR_TYPE_MASK
-#define VECTORING_INFO_DELIEVER_CODE_MASK    	INTR_INFO_DELIEVER_CODE_MASK
+#define VECTORING_INFO_DELIVER_CODE_MASK    	INTR_INFO_DELIVER_CODE_MASK
 #define VECTORING_INFO_VALID_MASK       	INTR_INFO_VALID_MASK
 
 #define INTR_TYPE_EXT_INTR              (0 << 8) /* external interrupt */
-- 
1.5.4.5

