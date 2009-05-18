Return-Path: <linux-kernel-owner+w=401wt.eu-S1756877AbZERJfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877AbZERJfi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 05:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756577AbZERJYC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 05:24:02 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38425 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754324AbZERJXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 05:23:11 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 32/43] KVM: x86: Ignore reads to EVNTSEL MSRs
Date: Mon, 18 May 2009 12:22:54 +0300
Message-Id: <1242638585-18470-33-git-send-email-avi@redhat.com>
In-Reply-To: <1242638585-18470-1-git-send-email-avi@redhat.com>
References: <1242638585-18470-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amit Shah <amit.shah@redhat.com>

We ignore writes to the performance counters and performance event
selector registers already. Kaspersky antivirus reads the eventsel
MSR causing it to crash with the current behaviour.

Return 0 as data when the eventsel registers are read to stop the
crash.

Signed-off-by: Amit Shah <amit.shah@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a27a64c..0131b5f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -891,6 +891,8 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 	case MSR_IA32_LASTINTFROMIP:
 	case MSR_IA32_LASTINTTOIP:
 	case MSR_VM_HSAVE_PA:
+	case MSR_P6_EVNTSEL0:
+	case MSR_P6_EVNTSEL1:
 		data = 0;
 		break;
 	case MSR_MTRRcap:
-- 
1.6.0.6

