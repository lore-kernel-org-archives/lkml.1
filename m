Return-Path: <linux-kernel-owner+w=401wt.eu-S1758582AbYCaOnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758582AbYCaOnc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 10:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752953AbYCaOhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 10:37:42 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:51307
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbYCaOhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 10:37:33 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 21/40] KVM: SVM: add detection of Nested Paging feature
Date: Mon, 31 Mar 2008 17:37:05 +0300
Message-Id: <1206974244-9716-22-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1206974244-9716-1-git-send-email-avi@qumranet.com>
References: <1206974244-9716-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

Let SVM detect if the Nested Paging feature is available on the hardware.
Disable it to keep this patch series bisectable.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/svm.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 5f527dc..c12a759 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -47,6 +47,8 @@ MODULE_LICENSE("GPL");
 #define SVM_FEATURE_LBRV (1 << 1)
 #define SVM_DEATURE_SVML (1 << 2)
 
+static bool npt_enabled = false;
+
 static void kvm_reput_irq(struct vcpu_svm *svm);
 
 static inline struct vcpu_svm *to_svm(struct kvm_vcpu *vcpu)
@@ -413,6 +415,12 @@ static __init int svm_hardware_setup(void)
 
 	svm_features = cpuid_edx(SVM_CPUID_FUNC);
 
+	if (!svm_has(SVM_FEATURE_NPT))
+		npt_enabled = false;
+
+	if (npt_enabled)
+		printk(KERN_INFO "kvm: Nested Paging enabled\n");
+
 	return 0;
 
 err_2:
-- 
1.5.4.5

