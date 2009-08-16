Return-Path: <linux-kernel-owner+w=401wt.eu-S1755449AbZHPJkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449AbZHPJkt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 05:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753987AbZHPJir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 05:38:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45341 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753982AbZHPJaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 05:30:11 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 13/48] KVM: ia64: Correct itc_offset calculations
Date: Sun, 16 Aug 2009 12:29:33 +0300
Message-Id: <1250415008-17175-14-git-send-email-avi@redhat.com>
In-Reply-To: <1250415008-17175-1-git-send-email-avi@redhat.com>
References: <1250415008-17175-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jes Sorensen <jes@sgi.com>

Init the itc_offset for all possible vCPUs. The current code by
mistake ends up only initializing the offset on vCPU 0.

Spotted by Gleb Natapov.

Signed-off-by: Jes Sorensen <jes@sgi.com>
Acked-by : Xiantao Zhang <xiantao.zhang@intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/ia64/kvm/kvm-ia64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index 80c57b0..3199221 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -1224,7 +1224,7 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 
 		/*Initialize itc offset for vcpus*/
 		itc_offset = 0UL - kvm_get_itc(vcpu);
-		for (i = 0; i < kvm->arch.online_vcpus; i++) {
+		for (i = 0; i < KVM_MAX_VCPUS; i++) {
 			v = (struct kvm_vcpu *)((char *)vcpu +
 					sizeof(struct kvm_vcpu_data) * i);
 			v->arch.itc_offset = itc_offset;
-- 
1.6.3.3

