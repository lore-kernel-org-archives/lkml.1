Return-Path: <linux-kernel-owner+w=401wt.eu-S932638AbZHZKhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932638AbZHZKhJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:37:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932505AbZHZKdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:33:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63351 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757108AbZHZKaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:30:14 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 30/47] KVM: SVM: move nested_svm_intr main logic out of if-clause
Date: Wed, 26 Aug 2009 13:29:52 +0300
Message-Id: <1251282609-12835-31-git-send-email-avi@redhat.com>
In-Reply-To: <1251282609-12835-1-git-send-email-avi@redhat.com>
References: <1251282609-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

This patch removes one indentation level from nested_svm_intr and
makes the logic more readable.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index f275d77..ff04a4b 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1374,19 +1374,20 @@ static int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
 
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
1.6.4.1

