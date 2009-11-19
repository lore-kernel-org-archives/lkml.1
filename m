Return-Path: <linux-kernel-owner+w=401wt.eu-S1756848AbZKSNnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848AbZKSNnM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 08:43:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756821AbZKSNnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 08:43:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37826 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753421AbZKSNfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 08:35:07 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 10/35] KVM: x86: Drop unneeded CONFIG_HAS_IOMEM check
Date: Thu, 19 Nov 2009 15:34:46 +0200
Message-Id: <1258637711-11674-11-git-send-email-avi@redhat.com>
In-Reply-To: <1258637711-11674-1-git-send-email-avi@redhat.com>
References: <1258637711-11674-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@web.de>

This (broken) check dates back to the days when this code was shared
across architectures. x86 has IOMEM, so drop it.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/x86.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3cffa2c..5d450cc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3814,7 +3814,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		if (r)
 			goto out;
 	}
-#if CONFIG_HAS_IOMEM
 	if (vcpu->mmio_needed) {
 		memcpy(vcpu->mmio_data, kvm_run->mmio.data, 8);
 		vcpu->mmio_read_completed = 1;
@@ -3832,7 +3831,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 			goto out;
 		}
 	}
-#endif
 	if (kvm_run->exit_reason == KVM_EXIT_HYPERCALL)
 		kvm_register_write(vcpu, VCPU_REGS_RAX,
 				     kvm_run->hypercall.ret);
-- 
1.6.5.2

