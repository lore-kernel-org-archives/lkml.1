Return-Path: <linux-kernel-owner+w=401wt.eu-S1752251AbXCKNyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251AbXCKNyX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 09:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933589AbXCKNyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 09:54:18 -0400
Received: from il.qumranet.com ([82.166.9.18]:43447 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933579AbXCKNxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 09:53:32 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@osdl.org>, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 12/15] KVM: Initialize the apic_base msr on svm too
Date: Sun, 11 Mar 2007 15:53:24 +0200
Message-Id: <1173621208161-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.2
In-Reply-To: <11736212072915-git-send-email-avi@qumranet.com>
References: <11736212072915-git-send-email-avi@qumranet.com>
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
1.5.0.2

