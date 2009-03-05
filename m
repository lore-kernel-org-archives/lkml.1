Return-Path: <linux-kernel-owner+w=401wt.eu-S1754841AbZCEMOE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbZCEMOE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 07:14:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753732AbZCEMM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 07:12:57 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:54449 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209AbZCEMMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 07:12:55 -0500
X-BigFish: VPS1(zzzzzzz32i65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KG18L0-02-DE9-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/6] kvm/x86/svm: force new asid on vcpu migration
Date: Thu, 5 Mar 2009 13:12:28 +0100
Message-ID: <1236255153-4432-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1236255153-4432-1-git-send-email-joerg.roedel@amd.com>
References: <1236255153-4432-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 05 Mar 2009 12:12:33.0702 (UTC) FILETIME=[AA202C60:01C99D8B]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 1821c20..0e66bca 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -180,7 +180,7 @@ static inline void kvm_write_cr2(unsigned long val)
 
 static inline void force_new_asid(struct kvm_vcpu *vcpu)
 {
-	to_svm(vcpu)->asid_generation--;
+	to_svm(vcpu)->asid_generation = 0;
 }
 
 static inline void flush_guest_tlb(struct kvm_vcpu *vcpu)
@@ -716,6 +716,7 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		svm->vmcb->control.tsc_offset += delta;
 		vcpu->cpu = cpu;
 		kvm_migrate_timers(vcpu);
+		force_new_asid(vcpu);
 	}
 
 	for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++)
-- 
1.5.6.4


