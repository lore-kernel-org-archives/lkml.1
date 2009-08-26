Return-Path: <linux-kernel-owner+w=401wt.eu-S932754AbZHZKlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932754AbZHZKlR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757334AbZHZKkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:40:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3412 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756807AbZHZKaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:30:11 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 06/47] KVM: ignore reads to perfctr msrs
Date: Wed, 26 Aug 2009 13:29:28 +0300
Message-Id: <1251282609-12835-7-git-send-email-avi@redhat.com>
In-Reply-To: <1251282609-12835-1-git-send-email-avi@redhat.com>
References: <1251282609-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amit Shah <amit.shah@redhat.com>

We ignore writes to the perfctr msrs. Ignore reads as well.

Kaspersky antivirus crashes Windows guests if it can't read
these MSRs.

Signed-off-by: Amit Shah <amit.shah@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 92b5edd..132c510 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1048,9 +1048,12 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 	case MSR_K8_SYSCFG:
 	case MSR_K7_HWCR:
 	case MSR_VM_HSAVE_PA:
+	case MSR_P6_PERFCTR0:
+	case MSR_P6_PERFCTR1:
 	case MSR_P6_EVNTSEL0:
 	case MSR_P6_EVNTSEL1:
 	case MSR_K7_EVNTSEL0:
+	case MSR_K7_PERFCTR0:
 	case MSR_K8_INT_PENDING_MSG:
 	case MSR_AMD64_NB_CFG:
 	case MSR_FAM10H_MMIO_CONF_BASE:
-- 
1.6.4.1

