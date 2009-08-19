Return-Path: <linux-kernel-owner+w=401wt.eu-S1752409AbZHSNE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409AbZHSNE5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:04:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752378AbZHSNEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:04:53 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50574 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751996AbZHSNCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:02:49 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 36/47] KVM: ignore reads from AMDs C1E enabled MSR
Date: Wed, 19 Aug 2009 16:02:32 +0300
Message-Id: <1250686963-8357-37-git-send-email-avi@redhat.com>
In-Reply-To: <1250686963-8357-1-git-send-email-avi@redhat.com>
References: <1250686963-8357-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andre Przywara <andre.przywara@amd.com>

If the Linux kernel detects an C1E capable AMD processor (K8 RevF and
higher), it will access a certain MSR on every attempt to go to halt.
Explicitly handle this read and return 0 to let KVM run a Linux guest
with the native AMD host CPU propagated to the guest.

Signed-off-by: Andre Przywara <andre.przywara@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cae5b12..6aace61 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1038,6 +1038,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 	case MSR_P6_EVNTSEL0:
 	case MSR_P6_EVNTSEL1:
 	case MSR_K7_EVNTSEL0:
+	case MSR_K8_INT_PENDING_MSG:
 		data = 0;
 		break;
 	case MSR_MTRRcap:
-- 
1.6.3.3

