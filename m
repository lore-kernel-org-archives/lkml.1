Return-Path: <linux-kernel-owner+w=401wt.eu-S1753767AbZHPJaN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767AbZHPJaN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 05:30:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753985AbZHPJaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 05:30:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45332 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248AbZHPJaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 05:30:10 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 04/48] KVM: Use MSR names in place of address
Date: Sun, 16 Aug 2009 12:29:24 +0300
Message-Id: <1250415008-17175-5-git-send-email-avi@redhat.com>
In-Reply-To: <1250415008-17175-1-git-send-email-avi@redhat.com>
References: <1250415008-17175-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jaswinder Singh Rajput <jaswinder@kernel.org>

Replace 0xc0010010 with MSR_K8_SYSCFG and 0xc0010015 with MSR_K7_HWCR.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 55a9dd1..a93ba37 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -973,8 +973,6 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 	u64 data;
 
 	switch (msr) {
-	case 0xc0010010: /* SYSCFG */
-	case 0xc0010015: /* HWCR */
 	case MSR_IA32_PLATFORM_ID:
 	case MSR_IA32_UCODE_REV:
 	case MSR_IA32_EBL_CR_POWERON:
@@ -983,6 +981,8 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 	case MSR_IA32_LASTBRANCHTOIP:
 	case MSR_IA32_LASTINTFROMIP:
 	case MSR_IA32_LASTINTTOIP:
+	case MSR_K8_SYSCFG:
+	case MSR_K7_HWCR:
 	case MSR_VM_HSAVE_PA:
 	case MSR_P6_EVNTSEL0:
 	case MSR_P6_EVNTSEL1:
-- 
1.6.3.3

