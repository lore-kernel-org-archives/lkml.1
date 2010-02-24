Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558Ab0BXSB1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 13:01:27 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:22301
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757470Ab0BXR7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 12:59:40 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i6bh87h43h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYCXZ3-01-2RB-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 10/11] KVM: SVM: Clear exit_info for injected INTR exits
Date: Wed, 24 Feb 2010 18:59:19 +0100
Message-ID: <1267034360-5907-11-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267034360-5907-1-git-send-email-joerg.roedel@amd.com>
References: <1267034360-5907-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 24 Feb 2010 17:59:23.0699 (UTC) FILETIME=[18E8B830:01CAB57B]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When injecting an vmexit.intr into the nested hypervisor
there might be leftover values in the exit_info fields.
Clear them to not confuse nested hypervisors.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 22654de..ae2f211 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1485,7 +1485,9 @@ static inline bool nested_svm_intr(struct vcpu_svm *svm)
 	if (!(svm->vcpu.arch.hflags & HF_HIF_MASK))
 		return false;
 
-	svm->vmcb->control.exit_code = SVM_EXIT_INTR;
+	svm->vmcb->control.exit_code   = SVM_EXIT_INTR;
+	svm->vmcb->control.exit_info_1 = 0;
+	svm->vmcb->control.exit_info_2 = 0;
 
 	if (svm->nested.intercept & 1ULL) {
 		/*
-- 
1.7.0


