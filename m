Return-Path: <linux-kernel-owner+w=401wt.eu-S1757166AbYAYUyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757166AbYAYUyZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 15:54:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753765AbYAYUyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 15:54:16 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:47146 "EHLO
	outbound2-va3-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753636AbYAYUyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 15:54:15 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: C391E81C-6590-4A2B-9214-A04D45AF4E95
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Avi Kivity" <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
cc: "Joerg Roedel" <joerg.roedel@amd.com>
Subject: [PATCH 3/8] SVM: add module parameter to disable Nested Paging
Date: Fri, 25 Jan 2008 21:53:08 +0100
Message-ID: <1201294393-22613-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1201294393-22613-1-git-send-email-joerg.roedel@amd.com>
References: <1201294393-22613-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 25 Jan 2008 20:53:14.0583 (UTC)
 FILETIME=[4DD78E70:01C85F94]
MIME-Version: 1.0
X-WSS-ID: 6B8493E02IW8829122-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To disable the use of the Nested Paging feature even if it is available in
hardware this patch adds a module parameter. Nested Paging can be disabled by
passing npt=off to the kvm_amd module.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 49bb57a..2e718ff 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -48,6 +48,9 @@ MODULE_LICENSE("GPL");
 #define SVM_DEATURE_SVML (1 << 2)
 
 static bool npt_enabled = false;
+static char *npt = "on";
+
+module_param(npt, charp, S_IRUGO);
 
 static void kvm_reput_irq(struct vcpu_svm *svm);
 
@@ -415,6 +418,11 @@ static __init int svm_hardware_setup(void)
 	if (!svm_has(SVM_FEATURE_NPT))
 		npt_enabled = false;
 
+	if (npt_enabled && strncmp(npt, "off", 3) == 0) {
+		printk(KERN_INFO "kvm: Nested Paging disabled\n");
+		npt_enabled = false;
+	}
+
 	if (npt_enabled)
 		printk(KERN_INFO "kvm: Nested Paging enabled\n");
 
-- 
1.5.3.7



