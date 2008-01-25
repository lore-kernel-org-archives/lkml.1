Return-Path: <linux-kernel-owner+w=401wt.eu-S1760222AbYAYU5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760222AbYAYU5S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 15:57:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755046AbYAYU5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 15:57:06 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:56960 "EHLO
	outbound7-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754502AbYAYU5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 15:57:03 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: 9D002D81-0D89-4A8A-BDDE-D174997CF0D6
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Avi Kivity" <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
cc: "Joerg Roedel" <joerg.roedel@amd.com>
Subject: [PATCH 2/8] SVM: add detection of Nested Paging feature
Date: Fri, 25 Jan 2008 21:53:07 +0100
Message-ID: <1201294393-22613-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1201294393-22613-1-git-send-email-joerg.roedel@amd.com>
References: <1201294393-22613-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 25 Jan 2008 20:53:14.0583 (UTC)
 FILETIME=[4DD78E70:01C85F94]
MIME-Version: 1.0
X-WSS-ID: 6B8493B50QK8882643-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let SVM detect if the Nested Paging feature is available on the hardware.
Disable it to keep this patch series bisectable.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 0c58527..49bb57a 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -47,6 +47,8 @@ MODULE_LICENSE("GPL");
 #define SVM_FEATURE_LBRV (1 << 1)
 #define SVM_DEATURE_SVML (1 << 2)
 
+static bool npt_enabled = false;
+
 static void kvm_reput_irq(struct vcpu_svm *svm);
 
 static inline struct vcpu_svm *to_svm(struct kvm_vcpu *vcpu)
@@ -410,6 +412,12 @@ static __init int svm_hardware_setup(void)
 
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
1.5.3.7



