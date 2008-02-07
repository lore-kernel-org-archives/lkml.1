Return-Path: <linux-kernel-owner+w=401wt.eu-S1758672AbYBGMsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758672AbYBGMsh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 07:48:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755717AbYBGMsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 07:48:25 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:1580 "EHLO
	outbound3-wa4-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754720AbYBGMsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 07:48:24 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: C391E81C-6590-4A2B-9214-A04D45AF4E95
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Avi Kivity" <avi@qumranet.com>
cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       "Joerg Roedel" <joerg.roedel@amd.com>
Subject: [PATCH 3/8] SVM: add module parameter to disable Nested Paging
Date: Thu,  7 Feb 2008 13:47:40 +0100
Message-ID: <1202388465-8657-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1202388465-8657-1-git-send-email-joerg.roedel@amd.com>
References: <1202388465-8657-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 07 Feb 2008 12:47:45.0720 (UTC)
 FILETIME=[A30E8B80:01C86987]
MIME-Version: 1.0
X-WSS-ID: 6BB421852IW10730680-02-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To disable the use of the Nested Paging feature even if it is available in
hardware this patch adds a module parameter. Nested Paging can be disabled by
passing npt=0 to the kvm_amd module.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index b037b27..8173ba6 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -48,6 +48,9 @@ MODULE_LICENSE("GPL");
 #define SVM_DEATURE_SVML (1 << 2)
 
 static bool npt_enabled = false;
+static int npt = 1;
+
+module_param(npt, int, S_IRUGO);
 
 static void kvm_reput_irq(struct vcpu_svm *svm);
 
@@ -415,6 +418,11 @@ static __init int svm_hardware_setup(void)
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
1.5.3.7



