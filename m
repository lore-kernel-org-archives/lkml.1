Return-Path: <linux-kernel-owner+w=401wt.eu-S1760270AbZB0KjG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760270AbZB0KjG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 05:39:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758181AbZB0K22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 05:28:28 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53575 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755419AbZB0K1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 05:27:10 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 22/37] KVM: SVM: Add microcode patch level dummy
Date: Fri, 27 Feb 2009 12:26:45 +0200
Message-Id: <1235730420-7929-23-git-send-email-avi@redhat.com>
In-Reply-To: <1235730420-7929-1-git-send-email-avi@redhat.com>
References: <1235730420-7929-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Graf <agraf@suse.de>

VMware ESX checks if the microcode level is correct when using a barcelona
CPU, in order to see if it actually can use SVM. Let's tell it we're on the
safe side...

Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index b3a7a31..3a60c3f 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1928,6 +1928,9 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 *data)
 	case MSR_VM_CR:
 		*data = 0;
 		break;
+	case MSR_IA32_UCODE_REV:
+		*data = 0x01000065;
+		break;
 	default:
 		return kvm_get_msr_common(vcpu, ecx, data);
 	}
-- 
1.6.0.6

