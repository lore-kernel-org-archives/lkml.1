Return-Path: <linux-kernel-owner+w=401wt.eu-S1758475AbZETL0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758475AbZETL0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 07:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756649AbZETLUC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 07:20:02 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55285 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755706AbZETLSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 07:18:50 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 35/46] KVM: ia64: Flush all TLBs once guest's memory mapping changes.
Date: Wed, 20 May 2009 14:18:32 +0300
Message-Id: <1242818323-10413-36-git-send-email-avi@redhat.com>
In-Reply-To: <1242818323-10413-1-git-send-email-avi@redhat.com>
References: <1242818323-10413-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiantao Zhang <xiantao.zhang@intel.com>

Flush all vcpu's TLB entries once changes guest's memory mapping.

Signed-off-by: Xiantao Zhang <xiantao.zhang@intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/ia64/kvm/kvm-ia64.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index f127fb7..9addca6 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -1631,6 +1631,7 @@ int kvm_arch_set_memory_region(struct kvm *kvm,
 
 void kvm_arch_flush_shadow(struct kvm *kvm)
 {
+	kvm_flush_remote_tlbs(kvm);
 }
 
 long kvm_arch_dev_ioctl(struct file *filp,
-- 
1.6.0.6

