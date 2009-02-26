Return-Path: <linux-kernel-owner+w=401wt.eu-S1761732AbZBZObL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761732AbZBZObL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 09:31:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758072AbZBZORw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 09:17:52 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43065 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754481AbZBZOPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 09:15:41 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alexander Graf <agraf@suse.de>
Subject: [PATCH 10/40] KVM: SVM: Allow setting the SVME bit
Date: Thu, 26 Feb 2009 16:15:00 +0200
Message-Id: <1235657730-27683-11-git-send-email-avi@redhat.com>
In-Reply-To: <1235657730-27683-1-git-send-email-avi@redhat.com>
References: <1235657730-27683-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Graf <agraf@suse.de>

Normally setting the SVME bit in EFER is not allowed, as we did
not support SVM. Not since we do, we should also allow enabling
SVM mode.

v2 comes as last patch, so we don't enable half-ready code
v4 introduces a module option to enable SVM
v6 warns that nesting is enabled

Acked-by: Joerg Roedel <joro@8bytes.org>
Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index df5b411..0fbbde5 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -69,6 +69,9 @@ static int npt = 1;
 
 module_param(npt, int, S_IRUGO);
 
+static int nested = 0;
+module_param(nested, int, S_IRUGO);
+
 static void kvm_reput_irq(struct vcpu_svm *svm);
 static void svm_flush_tlb(struct kvm_vcpu *vcpu);
 
@@ -443,6 +446,11 @@ static __init int svm_hardware_setup(void)
 	if (boot_cpu_has(X86_FEATURE_NX))
 		kvm_enable_efer_bits(EFER_NX);
 
+	if (nested) {
+		printk(KERN_INFO "kvm: Nested Virtualization enabled\n");
+		kvm_enable_efer_bits(EFER_SVME);
+	}
+
 	for_each_online_cpu(cpu) {
 		r = svm_cpu_init(cpu);
 		if (r)
-- 
1.6.0.6

