Return-Path: <linux-kernel-owner+w=401wt.eu-S1757381AbZETLWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381AbZETLWZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 07:22:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756235AbZETLTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 07:19:10 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55294 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755840AbZETLSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 07:18:51 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 39/46] KVM: ia64: ia64 vcpu_reset() do not call kmalloc() with irqs disabled
Date: Wed, 20 May 2009 14:18:36 +0300
Message-Id: <1242818323-10413-40-git-send-email-avi@redhat.com>
In-Reply-To: <1242818323-10413-1-git-send-email-avi@redhat.com>
References: <1242818323-10413-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jes Sorensen <jes@sgi.com>

Restore local irq enabled state before calling kvm_arch_vcpu_init(),
which calls kmalloc(GFP_KERNEL).

Signed-off-by: Jes Sorensen <jes@sgi.com>
Acked-by: Xiantao Zhang <xiantao.zhang@intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/ia64/kvm/kvm-ia64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index cf5a193..be4413e 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -2001,6 +2001,7 @@ static int vcpu_reset(struct kvm_vcpu *vcpu)
 	long psr;
 	local_irq_save(psr);
 	r = kvm_insert_vmm_mapping(vcpu);
+	local_irq_restore(psr);
 	if (r)
 		goto fail;
 
@@ -2013,7 +2014,6 @@ static int vcpu_reset(struct kvm_vcpu *vcpu)
 	kvm_purge_vmm_mapping(vcpu);
 	r = 0;
 fail:
-	local_irq_restore(psr);
 	return r;
 }
 
-- 
1.6.0.6

