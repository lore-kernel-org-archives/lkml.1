Return-Path: <linux-kernel-owner+w=401wt.eu-S1759598AbZBZOV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759598AbZBZOV3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 09:21:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754499AbZBZOQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 09:16:12 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43059 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754376AbZBZOPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 09:15:41 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 33/40] KVM: Fallback support for MSR_VM_HSAVE_PA
Date: Thu, 26 Feb 2009 16:15:23 +0200
Message-Id: <1235657730-27683-34-git-send-email-avi@redhat.com>
In-Reply-To: <1235657730-27683-1-git-send-email-avi@redhat.com>
References: <1235657730-27683-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we advertise MSR_VM_HSAVE_PA, userspace will attempt to read it
even on Intel.  Implement fake support for this MSR to avoid the
warnings.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2a4f3a6..c3fbe8c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -742,6 +742,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 		break;
 	case MSR_IA32_UCODE_REV:
 	case MSR_IA32_UCODE_WRITE:
+	case MSR_VM_HSAVE_PA:
 		break;
 	case 0x200 ... 0x2ff:
 		return set_msr_mtrr(vcpu, msr, data);
@@ -863,6 +864,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 	case MSR_IA32_LASTBRANCHTOIP:
 	case MSR_IA32_LASTINTFROMIP:
 	case MSR_IA32_LASTINTTOIP:
+	case MSR_VM_HSAVE_PA:
 		data = 0;
 		break;
 	case MSR_MTRRcap:
-- 
1.6.0.6

