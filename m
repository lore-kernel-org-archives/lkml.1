Return-Path: <linux-kernel-owner+w=401wt.eu-S1761280AbYBGMvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761280AbYBGMvU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 07:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758835AbYBGMsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 07:48:54 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:41181 "EHLO
	outbound5-va3-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758807AbYBGMsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 07:48:38 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: 9D002D81-0D89-4A8A-BDDE-D174997CF0D6
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Avi Kivity" <avi@qumranet.com>
cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       "Joerg Roedel" <joerg.roedel@amd.com>
Subject: [PATCH 1/8] SVM: move feature detection to hardware setup code
Date: Thu,  7 Feb 2008 13:47:38 +0100
Message-ID: <1202388465-8657-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1202388465-8657-1-git-send-email-joerg.roedel@amd.com>
References: <1202388465-8657-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 07 Feb 2008 12:47:45.0642 (UTC)
 FILETIME=[A302A4A0:01C86987]
MIME-Version: 1.0
X-WSS-ID: 6BB421940QK10781164-02-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By moving the SVM feature detection from the each_cpu code to the hardware
setup code it runs only once. As an additional advance the feature check is now
available earlier in the module setup process.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index d1c7fcb..c0aaa85 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -302,7 +302,6 @@ static void svm_hardware_enable(void *garbage)
 	svm_data->asid_generation = 1;
 	svm_data->max_asid = cpuid_ebx(SVM_CPUID_FUNC) - 1;
 	svm_data->next_asid = svm_data->max_asid + 1;
-	svm_features = cpuid_edx(SVM_CPUID_FUNC);
 
 	asm volatile ("sgdt %0" : "=m"(gdt_descr));
 	gdt = (struct desc_struct *)gdt_descr.address;
@@ -408,6 +407,9 @@ static __init int svm_hardware_setup(void)
 		if (r)
 			goto err_2;
 	}
+
+	svm_features = cpuid_edx(SVM_CPUID_FUNC);
+
 	return 0;
 
 err_2:
-- 
1.5.3.7



