Return-Path: <linux-kernel-owner+w=401wt.eu-S1759072AbYCaOoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759072AbYCaOoi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 10:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753117AbYCaOhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 10:37:45 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:51322
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbYCaOhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 10:37:34 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 20/40] KVM: SVM: move feature detection to hardware setup code
Date: Mon, 31 Mar 2008 17:37:04 +0300
Message-Id: <1206974244-9716-21-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1206974244-9716-1-git-send-email-avi@qumranet.com>
References: <1206974244-9716-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

By moving the SVM feature detection from the each_cpu code to the hardware
setup code it runs only once. As an additional advance the feature check is now
available earlier in the module setup process.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/svm.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index ff3bc74..5f527dc 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -302,7 +302,6 @@ static void svm_hardware_enable(void *garbage)
 	svm_data->asid_generation = 1;
 	svm_data->max_asid = cpuid_ebx(SVM_CPUID_FUNC) - 1;
 	svm_data->next_asid = svm_data->max_asid + 1;
-	svm_features = cpuid_edx(SVM_CPUID_FUNC);
 
 	asm volatile ("sgdt %0" : "=m"(gdt_descr));
 	gdt = (struct desc_struct *)gdt_descr.address;
@@ -411,6 +410,9 @@ static __init int svm_hardware_setup(void)
 		if (r)
 			goto err_2;
 	}
+
+	svm_features = cpuid_edx(SVM_CPUID_FUNC);
+
 	return 0;
 
 err_2:
-- 
1.5.4.5

