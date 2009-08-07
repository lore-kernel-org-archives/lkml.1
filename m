Return-Path: <linux-kernel-owner+w=401wt.eu-S1757252AbZHGJum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252AbZHGJum (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 05:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757201AbZHGJul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 05:50:41 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:35863
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755934AbZHGJuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 05:50:11 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KO03BD-03-0WY-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 19/21] kvm/svm: move nested_svm_intr main logic out of if-clause
Date: Fri, 7 Aug 2009 11:49:46 +0200
Message-ID: <1249638588-10982-20-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249638588-10982-1-git-send-email-joerg.roedel@amd.com>
References: <1249638588-10982-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 07 Aug 2009 09:49:51.0265 (UTC) FILETIME=[688B3910:01CA1744]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes one indentation level from nested_svm_intr and
makes the logic more readable.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 9a2354d..089310d 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1377,19 +1377,20 @@ static int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
 
 static inline int nested_svm_intr(struct vcpu_svm *svm)
 {
-	if (is_nested(svm)) {
-		if (!(svm->vcpu.arch.hflags & HF_VINTR_MASK))
-			return 0;
+	if (!is_nested(svm))
+		return 0;
 
-		if (!(svm->vcpu.arch.hflags & HF_HIF_MASK))
-			return 0;
+	if (!(svm->vcpu.arch.hflags & HF_VINTR_MASK))
+		return 0;
 
-		svm->vmcb->control.exit_code = SVM_EXIT_INTR;
+	if (!(svm->vcpu.arch.hflags & HF_HIF_MASK))
+		return 0;
 
-		if (nested_svm_exit_handled(svm)) {
-			nsvm_printk("VMexit -> INTR\n");
-			return 1;
-		}
+	svm->vmcb->control.exit_code = SVM_EXIT_INTR;
+
+	if (nested_svm_exit_handled(svm)) {
+		nsvm_printk("VMexit -> INTR\n");
+		return 1;
 	}
 
 	return 0;
-- 
1.6.3.3


