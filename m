Return-Path: <linux-kernel-owner+w=401wt.eu-S1758005AbZIPN12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005AbZIPN12 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 09:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbZIPN1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 09:27:10 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:12515
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752585AbZIPNYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 09:24:51 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KQ2FX8-02-2UT-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alexander Graf <agraf@suse.de>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/5] KVM: SVM: don't copy exit_int_info on nested vmrun
Date: Wed, 16 Sep 2009 15:24:16 +0200
Message-ID: <1253107459-8967-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253107459-8967-1-git-send-email-joerg.roedel@amd.com>
References: <1253107459-8967-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 16 Sep 2009 13:24:23.0171 (UTC) FILETIME=[01523530:01CA36D1]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The exit_int_info field is only written by the hardware and
never read. So it does not need to be copied on a vmrun
emulation.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 668460c..80f5309 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1790,8 +1790,6 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 	svm->nested.intercept            = nested_vmcb->control.intercept;
 
 	force_new_asid(&svm->vcpu);
-	svm->vmcb->control.exit_int_info = nested_vmcb->control.exit_int_info;
-	svm->vmcb->control.exit_int_info_err = nested_vmcb->control.exit_int_info_err;
 	svm->vmcb->control.int_ctl = nested_vmcb->control.int_ctl | V_INTR_MASKING_MASK;
 	if (nested_vmcb->control.int_ctl & V_IRQ_MASK) {
 		nsvm_printk("nSVM Injecting Interrupt: 0x%x\n",
-- 
1.6.3.3


