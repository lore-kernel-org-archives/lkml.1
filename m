Return-Path: <linux-kernel-owner+w=401wt.eu-S1753803AbZKPMXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbZKPMXs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 07:23:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753438AbZKPMUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 07:20:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20064 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752973AbZKPMTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 07:19:43 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 26/42] KVM: SVM: don't copy exit_int_info on nested vmrun
Date: Mon, 16 Nov 2009 14:19:27 +0200
Message-Id: <1258373983-8693-27-git-send-email-avi@redhat.com>
In-Reply-To: <1258373983-8693-1-git-send-email-avi@redhat.com>
References: <1258373983-8693-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

The exit_int_info field is only written by the hardware and
never read. So it does not need to be copied on a vmrun
emulation.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/svm.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 3f3fe81..41c996a 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1797,8 +1797,6 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 	svm->nested.intercept            = nested_vmcb->control.intercept;
 
 	force_new_asid(&svm->vcpu);
-	svm->vmcb->control.exit_int_info = nested_vmcb->control.exit_int_info;
-	svm->vmcb->control.exit_int_info_err = nested_vmcb->control.exit_int_info_err;
 	svm->vmcb->control.int_ctl = nested_vmcb->control.int_ctl | V_INTR_MASKING_MASK;
 	if (nested_vmcb->control.int_ctl & V_IRQ_MASK) {
 		nsvm_printk("nSVM Injecting Interrupt: 0x%x\n",
-- 
1.6.5.2

