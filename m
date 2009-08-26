Return-Path: <linux-kernel-owner+w=401wt.eu-S1757295AbZHZKem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295AbZHZKem (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757255AbZHZKdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:33:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33105 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757063AbZHZKaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:30:13 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 35/47] KVM: Move #endif KVM_CAP_IRQ_ROUTING to correct place
Date: Wed, 26 Aug 2009 13:29:57 +0300
Message-Id: <1251282609-12835-36-git-send-email-avi@redhat.com>
In-Reply-To: <1251282609-12835-1-git-send-email-avi@redhat.com>
References: <1251282609-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symbol only controls irq routing, not MSI-X.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 virt/kvm/kvm_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4470251..1df4c04 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2236,6 +2236,7 @@ static long kvm_vm_ioctl(struct file *filp,
 		vfree(entries);
 		break;
 	}
+#endif /* KVM_CAP_IRQ_ROUTING */
 #ifdef __KVM_HAVE_MSIX
 	case KVM_ASSIGN_SET_MSIX_NR: {
 		struct kvm_assigned_msix_nr entry_nr;
@@ -2258,7 +2259,6 @@ static long kvm_vm_ioctl(struct file *filp,
 		break;
 	}
 #endif
-#endif /* KVM_CAP_IRQ_ROUTING */
 	case KVM_IRQFD: {
 		struct kvm_irqfd data;
 
-- 
1.6.4.1

