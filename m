Return-Path: <linux-kernel-owner+w=401wt.eu-S1760258AbYBGMt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760258AbYBGMt1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 07:49:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758747AbYBGMsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 07:48:38 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:40622 "EHLO
	outbound3-va3-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755587AbYBGMsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 07:48:25 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: C391E81C-6590-4A2B-9214-A04D45AF4E95
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Avi Kivity" <avi@qumranet.com>
cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       "Joerg Roedel" <joerg.roedel@amd.com>
Subject: [PATCH 6/8] X86: export the load_pdptrs() function to modules
Date: Thu,  7 Feb 2008 13:47:43 +0100
Message-ID: <1202388465-8657-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1202388465-8657-1-git-send-email-joerg.roedel@amd.com>
References: <1202388465-8657-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 07 Feb 2008 12:47:45.0751 (UTC)
 FILETIME=[A3134670:01C86987]
MIME-Version: 1.0
X-WSS-ID: 6BB421852IW10730682-02-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The load_pdptrs() function is required in the SVM module for NPT support.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/x86.c         |    1 +
 include/asm-x86/kvm_host.h |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8f94a0b..31cdf09 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -202,6 +202,7 @@ out:
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(load_pdptrs);
 
 static bool pdptrs_changed(struct kvm_vcpu *vcpu)
 {
diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index 7661da0..38f29fa 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -410,6 +410,8 @@ void kvm_mmu_zap_all(struct kvm *kvm);
 unsigned int kvm_mmu_calculate_mmu_pages(struct kvm *kvm);
 void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned int kvm_nr_mmu_pages);
 
+int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3);
+
 enum emulation_result {
 	EMULATE_DONE,       /* no further processing */
 	EMULATE_DO_MMIO,      /* kvm_run filled with mmio request */
-- 
1.5.3.7



