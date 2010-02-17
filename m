Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934352Ab0BQNvc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 08:51:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36002 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932695Ab0BQNpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 08:45:35 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 05/20] KVM: kvm->arch.vioapic should be NULL if kvm_ioapic_init() failure
Date: Wed, 17 Feb 2010 15:45:15 +0200
Message-Id: <1266414330-27444-6-git-send-email-avi@redhat.com>
In-Reply-To: <1266414330-27444-1-git-send-email-avi@redhat.com>
References: <1266414330-27444-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yjwei@cn.fujitsu.com>

kvm->arch.vioapic should be NULL in case of kvm_ioapic_init() failure
due to cannot register io dev.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 virt/kvm/ioapic.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index a2edfd1..f3d0693 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -393,8 +393,10 @@ int kvm_ioapic_init(struct kvm *kvm)
 	mutex_lock(&kvm->slots_lock);
 	ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS, &ioapic->dev);
 	mutex_unlock(&kvm->slots_lock);
-	if (ret < 0)
+	if (ret < 0) {
+		kvm->arch.vioapic = NULL;
 		kfree(ioapic);
+	}
 
 	return ret;
 }
-- 
1.6.5.3

