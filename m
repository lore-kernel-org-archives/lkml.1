Return-Path: <linux-kernel-owner+w=401wt.eu-S1756288AbZKSNjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288AbZKSNjq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 08:39:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756158AbZKSNjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 08:39:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7589 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753574AbZKSNfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 08:35:08 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 19/35] KVM: SVM: init_vmcb(): remove redundant save->cr0 initialization
Date: Thu, 19 Nov 2009 15:34:55 +0200
Message-Id: <1258637711-11674-20-git-send-email-avi@redhat.com>
In-Reply-To: <1258637711-11674-1-git-send-email-avi@redhat.com>
References: <1258637711-11674-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eduardo Habkost <ehabkost@redhat.com>

The svm_set_cr0() call will initialize save->cr0 properly even when npt is
enabled, clearing the NW and CD bits as expected, so we don't need to
initialize it manually for npt_enabled anymore.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index c9ef6c0..34b700f 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -648,8 +648,6 @@ static void init_vmcb(struct vcpu_svm *svm)
 		control->intercept_cr_write &= ~(INTERCEPT_CR0_MASK|
 						 INTERCEPT_CR3_MASK);
 		save->g_pat = 0x0007040600070406ULL;
-		/* enable caching because the QEMU Bios doesn't enable it */
-		save->cr0 = X86_CR0_ET;
 		save->cr3 = 0;
 		save->cr4 = 0;
 	}
-- 
1.6.5.2

