Return-Path: <linux-kernel-owner+w=401wt.eu-S1757200AbZHGJyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200AbZHGJyg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 05:54:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755946AbZHGJuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 05:50:22 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:45387 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755906AbZHGJuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 05:50:09 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j63h)
X-Spam-TCS-SCL: 2:0
X-FB-SS: 5,
X-WSS-ID: 0KO03B9-04-L8C-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 10/21] kvm/svm: simplify nested_svm_check_exception
Date: Fri, 7 Aug 2009 11:49:37 +0200
Message-ID: <1249638588-10982-11-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249638588-10982-1-git-send-email-joerg.roedel@amd.com>
References: <1249638588-10982-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 07 Aug 2009 09:49:51.0077 (UTC) FILETIME=[686E8950:01CA1744]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Makes the code of this function more readable by removing on
indentation level for the core logic.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index c473ad9..a85b0a2 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1362,18 +1362,15 @@ static int nested_svm_check_permissions(struct vcpu_svm *svm)
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
1.6.3.3


