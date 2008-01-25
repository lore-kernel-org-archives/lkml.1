Return-Path: <linux-kernel-owner+w=401wt.eu-S1760387AbYAYUyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760387AbYAYUyl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 15:54:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756648AbYAYUyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 15:54:23 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:41432 "EHLO
	outbound10-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756198AbYAYUyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 15:54:22 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: 9D002D81-0D89-4A8A-BDDE-D174997CF0D6
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Avi Kivity" <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
cc: "Joerg Roedel" <joerg.roedel@amd.com>
Subject: [PATCH 1/8] SVM: move feature detection to hardware setup code
Date: Fri, 25 Jan 2008 21:53:06 +0100
Message-ID: <1201294393-22613-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1201294393-22613-1-git-send-email-joerg.roedel@amd.com>
References: <1201294393-22613-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 25 Jan 2008 20:53:14.0583 (UTC)
 FILETIME=[4DD78E70:01C85F94]
MIME-Version: 1.0
X-WSS-ID: 6B8493E00QK8882743-01-01
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
index 7bdbe16..0c58527 100644
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



