Return-Path: <linux-kernel-owner+w=401wt.eu-S933574AbZHWL4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933574AbZHWL4v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 07:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933532AbZHWL4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 07:56:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39712 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933518AbZHWL4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 07:56:46 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 02/46] KVM: Ignore PCI ECS I/O enablement
Date: Sun, 23 Aug 2009 14:56:01 +0300
Message-Id: <1251028605-31977-3-git-send-email-avi@redhat.com>
In-Reply-To: <1251028605-31977-1-git-send-email-avi@redhat.com>
References: <1251028605-31977-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andre Przywara <andre.przywara@amd.com>

Linux guests will try to enable access to the extended PCI config space
via the I/O ports 0xCF8/0xCFC on AMD Fam10h CPU. Since we (currently?)
don't use ECS, simply ignore write and read attempts.

Signed-off-by: Andre Przywara <andre.przywara@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 96f0ae7..af40e23 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -844,6 +844,8 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 			return 1;
 		}
 		break;
+	case MSR_AMD64_NB_CFG:
+		break;
 	case MSR_IA32_DEBUGCTLMSR:
 		if (!data) {
 			/* We support the non-activated case already */
@@ -1049,6 +1051,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 	case MSR_P6_EVNTSEL1:
 	case MSR_K7_EVNTSEL0:
 	case MSR_K8_INT_PENDING_MSG:
+	case MSR_AMD64_NB_CFG:
 		data = 0;
 		break;
 	case MSR_MTRRcap:
-- 
1.6.4.1

