Return-Path: <linux-kernel-owner+w=401wt.eu-S932607AbZHZKf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932607AbZHZKf7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757107AbZHZKdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:33:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24052 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757098AbZHZKaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:30:13 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 29/47] KVM: SVM: remove unnecessary is_nested check from svm_cpu_run
Date: Wed, 26 Aug 2009 13:29:51 +0300
Message-Id: <1251282609-12835-30-git-send-email-avi@redhat.com>
In-Reply-To: <1251282609-12835-1-git-send-email-avi@redhat.com>
References: <1251282609-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

This check is not necessary. We have to sync the vcpu->arch.cr2 always
back to the VMCB. This patch remove the is_nested check.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index e9e3931..f275d77 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2605,8 +2605,7 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	fs_selector = kvm_read_fs();
 	gs_selector = kvm_read_gs();
 	ldt_selector = kvm_read_ldt();
-	if (!is_nested(svm))
-		svm->vmcb->save.cr2 = vcpu->arch.cr2;
+	svm->vmcb->save.cr2 = vcpu->arch.cr2;
 	/* required for live migration with NPT */
 	if (npt_enabled)
 		svm->vmcb->save.cr3 = vcpu->arch.cr3;
-- 
1.6.4.1

