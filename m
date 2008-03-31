Return-Path: <linux-kernel-owner+w=401wt.eu-S1754487AbYCaOpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487AbYCaOpc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 10:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753175AbYCaOhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 10:37:45 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:51314
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbYCaOhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 10:37:34 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 25/40] KVM: export the load_pdptrs() function to modules
Date: Mon, 31 Mar 2008 17:37:09 +0300
Message-Id: <1206974244-9716-26-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1206974244-9716-1-git-send-email-avi@qumranet.com>
References: <1206974244-9716-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

The load_pdptrs() function is required in the SVM module for NPT support.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86.c         |    1 +
 include/asm-x86/kvm_host.h |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 38edb2f..0c910c7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -213,6 +213,7 @@ out:
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(load_pdptrs);
 
 static bool pdptrs_changed(struct kvm_vcpu *vcpu)
 {
diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index 15fb2e8..da61255 100644
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
1.5.4.5

