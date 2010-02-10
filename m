Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191Ab0BJRaj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 12:30:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755438Ab0BJRXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 12:23:13 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 10/40] KVM: VMX: Remove redundant variable
Date: Wed, 10 Feb 2010 19:22:39 +0200
Message-Id: <1265822589-11155-11-git-send-email-avi@redhat.com>
In-Reply-To: <1265822589-11155-1-git-send-email-avi@redhat.com>
References: <1265822589-11155-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

It's no longer necessary.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 694baed..f8f2fdc 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2399,14 +2399,12 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
 	for (i = 0; i < NR_VMX_MSR; ++i) {
 		u32 index = vmx_msr_index[i];
 		u32 data_low, data_high;
-		u64 data;
 		int j = vmx->nmsrs;
 
 		if (rdmsr_safe(index, &data_low, &data_high) < 0)
 			continue;
 		if (wrmsr_safe(index, data_low, data_high) < 0)
 			continue;
-		data = data_low | ((u64)data_high << 32);
 		vmx->guest_msrs[j].index = i;
 		vmx->guest_msrs[j].data = 0;
 		vmx->guest_msrs[j].mask = -1ull;
-- 
1.6.5.3

