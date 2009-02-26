Return-Path: <linux-kernel-owner+w=401wt.eu-S1758943AbZBZOT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758943AbZBZOT4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 09:19:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756949AbZBZOP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 09:15:58 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43056 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754186AbZBZOPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 09:15:40 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 09/40] KVM: SVM: Allow read access to MSR_VM_VR
Date: Thu, 26 Feb 2009 16:14:59 +0200
Message-Id: <1235657730-27683-10-git-send-email-avi@redhat.com>
In-Reply-To: <1235657730-27683-1-git-send-email-avi@redhat.com>
References: <1235657730-27683-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

KVM tries to read the VM_CR MSR to find out if SVM was disabled by
the BIOS. So implement read support for this MSR to make nested
SVM running.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 4cb2920..df5b411 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1869,6 +1869,9 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 *data)
 	case MSR_VM_HSAVE_PA:
 		*data = svm->hsave_msr;
 		break;
+	case MSR_VM_CR:
+		*data = 0;
+		break;
 	default:
 		return kvm_get_msr_common(vcpu, ecx, data);
 	}
-- 
1.6.0.6

