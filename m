Return-Path: <linux-kernel-owner+w=401wt.eu-S1757219AbZHZKa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219AbZHZKa2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757198AbZHZKaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:30:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757081AbZHZKaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:30:13 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 21/47] KVM: SVM: simplify nested_svm_check_exception
Date: Wed, 26 Aug 2009 13:29:43 +0300
Message-Id: <1251282609-12835-22-git-send-email-avi@redhat.com>
In-Reply-To: <1251282609-12835-1-git-send-email-avi@redhat.com>
References: <1251282609-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

Makes the code of this function more readable by removing on
indentation level for the core logic.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 3bb6d4b..67fad66 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1359,18 +1359,15 @@ static int nested_svm_check_permissions(struct vcpu_svm *svm)
 static int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
 				      bool has_error_code, u32 error_code)
 {
-	if (is_nested(svm)) {
-		svm->vmcb->control.exit_code = SVM_EXIT_EXCP_BASE + nr;
-		svm->vmcb->control.exit_code_hi = 0;
-		svm->vmcb->control.exit_info_1 = error_code;
-		svm->vmcb->control.exit_info_2 = svm->vcpu.arch.cr2;
-		if (nested_svm_exit_handled(svm, false)) {
-			nsvm_printk("VMexit -> EXCP 0x%x\n", nr);
-			return 1;
-		}
-	}
+	if (!is_nested(svm))
+		return 0;
 
-	return 0;
+	svm->vmcb->control.exit_code = SVM_EXIT_EXCP_BASE + nr;
+	svm->vmcb->control.exit_code_hi = 0;
+	svm->vmcb->control.exit_info_1 = error_code;
+	svm->vmcb->control.exit_info_2 = svm->vcpu.arch.cr2;
+
+	return nested_svm_exit_handled(svm, false);
 }
 
 static inline int nested_svm_intr(struct vcpu_svm *svm)
-- 
1.6.4.1

