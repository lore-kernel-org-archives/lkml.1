Return-Path: <linux-kernel-owner+w=401wt.eu-S932237AbYBGMuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237AbYBGMuw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 07:50:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755989AbYBGMsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 07:48:52 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:41185 "EHLO
	outbound6-va3-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758835AbYBGMsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 07:48:38 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: 9D002D81-0D89-4A8A-BDDE-D174997CF0D6
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Avi Kivity" <avi@qumranet.com>
cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       "Joerg Roedel" <joerg.roedel@amd.com>
Subject: [PATCH 2/8] SVM: add detection of Nested Paging feature
Date: Thu,  7 Feb 2008 13:47:39 +0100
Message-ID: <1202388465-8657-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1202388465-8657-1-git-send-email-joerg.roedel@amd.com>
References: <1202388465-8657-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 07 Feb 2008 12:47:45.0673 (UTC)
 FILETIME=[A3075F90:01C86987]
MIME-Version: 1.0
X-WSS-ID: 6BB421940QK10781164-03-01
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
index c0aaa85..b037b27 100644
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



