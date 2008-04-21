Return-Path: <linux-kernel-owner+w=401wt.eu-S1756511AbYDUKbC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511AbYDUKbC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 06:31:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754588AbYDUKaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 06:30:05 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:37845
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510AbYDUK37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 06:29:59 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 04/31] KVM: SVM: align shadow CR4.MCE with host
Date: Mon, 21 Apr 2008 13:29:30 +0300
Message-Id: <1208773797-7829-5-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208773797-7829-1-git-send-email-avi@qumranet.com>
References: <1208773797-7829-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

This patch aligns the host version of the CR4.MCE bit with the CR4 active in
the guest. This is necessary to get MCE exceptions when the guest is running.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/svm.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index d7439ce..8af463b 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -878,9 +878,12 @@ set:
 
 static void svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
+	unsigned long host_cr4_mce = read_cr4() & X86_CR4_MCE;
+
 	vcpu->arch.cr4 = cr4;
 	if (!npt_enabled)
 		cr4 |= X86_CR4_PAE;
+	cr4 |= host_cr4_mce;
 	to_svm(vcpu)->vmcb->save.cr4 = cr4;
 }
 
-- 
1.5.5

