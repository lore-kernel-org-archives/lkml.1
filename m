Return-Path: <linux-kernel-owner+w=401wt.eu-S1756001AbZLOEH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001AbZLOEH4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 23:07:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751054AbZLOEHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 23:07:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932589AbZLOEHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 23:07:39 -0500
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
       Dor Laor <dlaor@redhat.com>
Subject: [PATCH RFC: kvm tsc virtualization 20/20] Get passthrough TSC working in SVM again
Date: Mon, 14 Dec 2009 18:08:47 -1000
Message-Id: <1260850127-9766-21-git-send-email-zamsden@redhat.com>
In-Reply-To: <1260850127-9766-20-git-send-email-zamsden@redhat.com>
References: <1260850127-9766-1-git-send-email-zamsden@redhat.com>
 <1260850127-9766-2-git-send-email-zamsden@redhat.com>
 <1260850127-9766-3-git-send-email-zamsden@redhat.com>
 <1260850127-9766-4-git-send-email-zamsden@redhat.com>
 <1260850127-9766-5-git-send-email-zamsden@redhat.com>
 <1260850127-9766-6-git-send-email-zamsden@redhat.com>
 <1260850127-9766-7-git-send-email-zamsden@redhat.com>
 <1260850127-9766-8-git-send-email-zamsden@redhat.com>
 <1260850127-9766-9-git-send-email-zamsden@redhat.com>
 <1260850127-9766-10-git-send-email-zamsden@redhat.com>
 <1260850127-9766-11-git-send-email-zamsden@redhat.com>
 <1260850127-9766-12-git-send-email-zamsden@redhat.com>
 <1260850127-9766-13-git-send-email-zamsden@redhat.com>
 <1260850127-9766-14-git-send-email-zamsden@redhat.com>
 <1260850127-9766-15-git-send-email-zamsden@redhat.com>
 <1260850127-9766-16-git-send-email-zamsden@redhat.com>
 <1260850127-9766-17-git-send-email-zamsden@redhat.com>
 <1260850127-9766-18-git-send-email-zamsden@redhat.com>
 <1260850127-9766-19-git-send-email-zamsden@redhat.com>
 <1260850127-9766-20-git-send-email-zamsden@redhat.com>
Organization: Frobozz Magic Timekeeping Company
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quick and dirty hack to get passthrough TSC back in SVM.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/kvm/svm.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 91eb263..91107a4 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -571,7 +571,6 @@ static void init_vmcb(struct vcpu_svm *svm)
 	control->intercept = 	(1ULL << INTERCEPT_INTR) |
 				(1ULL << INTERCEPT_NMI) |
 				(1ULL << INTERCEPT_SMI) |
-				(1ULL << INTERCEPT_RDTSC) |
 				(1ULL << INTERCEPT_CPUID) |
 				(1ULL << INTERCEPT_INVD) |
 				(1ULL << INTERCEPT_HLT) |
@@ -592,6 +591,9 @@ static void init_vmcb(struct vcpu_svm *svm)
 				(1ULL << INTERCEPT_MONITOR) |
 				(1ULL << INTERCEPT_MWAIT);
 
+	if (svm->vcpu.kvm->arch.tsc_mode != KVM_TSC_MODE_PASSTHROUGH)
+		control->intercept |= (1ULL << INTERCEPT_RDTSC);
+
 	control->iopm_base_pa = iopm_base;
 	control->msrpm_base_pa = __pa(svm->msrpm);
 	control->tsc_offset = 0;
-- 
1.6.5.2

