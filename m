Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933886Ab0BQNug (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 08:50:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933844Ab0BQNpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 08:45:36 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 07/20] KVM: ia64: destroy ioapic device if fail to setup default irq routing
Date: Wed, 17 Feb 2010 15:45:17 +0200
Message-Id: <1266414330-27444-8-git-send-email-avi@redhat.com>
In-Reply-To: <1266414330-27444-1-git-send-email-avi@redhat.com>
References: <1266414330-27444-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yjwei@cn.fujitsu.com>

If KVM_CREATE_IRQCHIP fail due to kvm_setup_default_irq_routing(),
ioapic device is not destroyed and kvm->arch.vioapic is not set to
NULL, this may cause KVM_GET_IRQCHIP and KVM_SET_IRQCHIP access to
unexcepted memory.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/ia64/kvm/kvm-ia64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index 0618898..26e0e08 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -968,7 +968,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
 			goto out;
 		r = kvm_setup_default_irq_routing(kvm);
 		if (r) {
-			kfree(kvm->arch.vioapic);
+			kvm_ioapic_destroy(kvm);
 			goto out;
 		}
 		break;
-- 
1.6.5.3

