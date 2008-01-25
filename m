Return-Path: <linux-kernel-owner+w=401wt.eu-S1760237AbYAYVA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760237AbYAYVA0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 16:00:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756085AbYAYVAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 16:00:13 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:16096 "EHLO
	outbound6-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755675AbYAYVAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 16:00:11 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: C391E81C-6590-4A2B-9214-A04D45AF4E95
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Avi Kivity" <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
cc: "Joerg Roedel" <joerg.roedel@amd.com>
Subject: [PATCH 6/8] X86: export the load_pdptrs() function to modules
Date: Fri, 25 Jan 2008 21:53:11 +0100
Message-ID: <1201294393-22613-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1201294393-22613-1-git-send-email-joerg.roedel@amd.com>
References: <1201294393-22613-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 25 Jan 2008 20:53:14.0723 (UTC)
 FILETIME=[4DECEB30:01C85F94]
MIME-Version: 1.0
X-WSS-ID: 6B8493E02IW8829123-01-01
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
index 45a9d05..b55a7a6 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -412,6 +412,8 @@ void kvm_mmu_zap_all(struct kvm *kvm);
 unsigned int kvm_mmu_calculate_mmu_pages(struct kvm *kvm);
 void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned int kvm_nr_mmu_pages);
 
+int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3);
+
 enum emulation_result {
 	EMULATE_DONE,       /* no further processing */
 	EMULATE_DO_MMIO,      /* kvm_run filled with mmio request */
-- 
1.5.3.7



