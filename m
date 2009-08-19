Return-Path: <linux-kernel-owner+w=401wt.eu-S1752278AbZHSNK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278AbZHSNK2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbZHSNJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:09:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50562 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751950AbZHSNCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:02:47 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 21/47] KVM: Implement MSRs used by Hyper-V
Date: Wed, 19 Aug 2009 16:02:17 +0300
Message-Id: <1250686963-8357-22-git-send-email-avi@redhat.com>
In-Reply-To: <1250686963-8357-1-git-send-email-avi@redhat.com>
References: <1250686963-8357-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Graf <agraf@suse.de>

Hyper-V uses some MSRs, some of which are actually reserved for BIOS usage.

But let's be nice today and have it its way, because otherwise it fails
terribly.

[jaswinder: fix build for linux-next changes]

Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 5a1f26c..8f80190 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2132,6 +2132,11 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 data)
 	case MSR_VM_HSAVE_PA:
 		svm->hsave_msr = data;
 		break;
+	case MSR_VM_CR:
+	case MSR_VM_IGNNE:
+	case MSR_K7_HWCR:
+		pr_unimpl(vcpu, "unimplemented wrmsr: 0x%x data 0x%llx\n", ecx, data);
+		break;
 	default:
 		return kvm_set_msr_common(vcpu, ecx, data);
 	}
-- 
1.6.3.3

