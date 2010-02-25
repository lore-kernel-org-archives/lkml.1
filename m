Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933059Ab0BYRRM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 12:17:12 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:42256
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933055Ab0BYRQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 12:16:59 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i87h6bh43h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYEQML-01-QHQ-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 5/5] KVM: SVM: Ignore lower 12 bit of nested msrpm_pa
Date: Thu, 25 Feb 2010 18:15:49 +0100
Message-ID: <1267118149-15737-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267118149-15737-1-git-send-email-joerg.roedel@amd.com>
References: <1267118149-15737-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 25 Feb 2010 17:15:52.0614 (UTC) FILETIME=[2EFE8460:01CAB63E]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These bits are ignored by the hardware. Implement this
for nested svm too.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 3859e2c..cfc8a90 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2012,7 +2012,7 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 	svm->vmcb->save.dr6 = nested_vmcb->save.dr6;
 	svm->vmcb->save.cpl = nested_vmcb->save.cpl;
 
-	svm->nested.vmcb_msrpm = nested_vmcb->control.msrpm_base_pa;
+	svm->nested.vmcb_msrpm = nested_vmcb->control.msrpm_base_pa & ~0x0fffULL;
 	svm->nested.vmcb_iopm  = nested_vmcb->control.iopm_base_pa  & ~0x0fffULL;
 
 	/* cache intercepts */
-- 
1.7.0


