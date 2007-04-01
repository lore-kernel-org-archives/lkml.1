Return-Path: <linux-kernel-owner+w=401wt.eu-S933112AbXDAOqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933112AbXDAOqW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 10:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933185AbXDAOp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 10:45:59 -0400
Received: from il.qumranet.com ([82.166.9.18]:47560 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933112AbXDAOfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 10:35:42 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 16/41] KVM: Initialize the apic_base msr on svm too
Date: Sun,  1 Apr 2007 17:35:13 +0300
Message-Id: <11754381392358-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.5
In-Reply-To: <11754381392382-git-send-email-avi@qumranet.com>
References: <1175438138288-git-send-email-avi@qumranet.com> <11754381381990-git-send-email-avi@qumranet.com> <11754381384009-git-send-email-avi@qumranet.com> <1175438138805-git-send-email-avi@qumranet.com> <11754381382515-git-send-email-avi@qumranet.com> <11754381383730-git-send-email-avi@qumranet.com> <11754381383144-git-send-email-avi@qumranet.com> <11754381381597-git-send-email-avi@qumranet.com> <1175438139242-git-send-email-avi@qumranet.com> <1175438139494-git-send-email-avi@qumranet.com> <11754381392046-git-send-email-avi@qumranet.com> <1175438139795-git-send-email-avi@qumranet.com> <1175438139430-git-send-email-avi@qumranet.com> <11754381393496-git-send-email-avi@qumranet.com> <11754381391514-git-send-email-avi@qumranet.com> <11754381392382-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Older userspace didn't care, but newer userspace (with the cpuid changes)
does.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/svm.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 0311665..2396ada 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -582,6 +582,9 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 	init_vmcb(vcpu->svm->vmcb);
 
 	fx_init(vcpu);
+	vcpu->apic_base = 0xfee00000 |
+			/*for vcpu 0*/ MSR_IA32_APICBASE_BSP |
+			MSR_IA32_APICBASE_ENABLE;
 
 	return 0;
 
-- 
1.5.0.5

