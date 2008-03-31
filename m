Return-Path: <linux-kernel-owner+w=401wt.eu-S1759464AbYCaOqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759464AbYCaOqR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 10:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753241AbYCaOhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 10:37:46 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:51323
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbYCaOhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 10:37:34 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 22/40] KVM: SVM: add module parameter to disable Nested Paging
Date: Mon, 31 Mar 2008 17:37:06 +0300
Message-Id: <1206974244-9716-23-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1206974244-9716-1-git-send-email-avi@qumranet.com>
References: <1206974244-9716-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

To disable the use of the Nested Paging feature even if it is available in
hardware this patch adds a module parameter. Nested Paging can be disabled by
passing npt=0 to the kvm_amd module.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/svm.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index c12a759..fb5d6c2 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -48,6 +48,9 @@ MODULE_LICENSE("GPL");
 #define SVM_DEATURE_SVML (1 << 2)
 
 static bool npt_enabled = false;
+static int npt = 1;
+
+module_param(npt, int, S_IRUGO);
 
 static void kvm_reput_irq(struct vcpu_svm *svm);
 
@@ -418,6 +421,11 @@ static __init int svm_hardware_setup(void)
 	if (!svm_has(SVM_FEATURE_NPT))
 		npt_enabled = false;
 
+	if (npt_enabled && !npt) {
+		printk(KERN_INFO "kvm: Nested Paging disabled\n");
+		npt_enabled = false;
+	}
+
 	if (npt_enabled)
 		printk(KERN_INFO "kvm: Nested Paging enabled\n");
 
-- 
1.5.4.5

