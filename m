Return-Path: <linux-kernel-owner+w=401wt.eu-S933812AbZHWMEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933812AbZHWMEz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 08:04:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933789AbZHWMDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 08:03:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34347 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933531AbZHWL4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 07:56:49 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 15/46] KVM: ignore msi request if !level
Date: Sun, 23 Aug 2009 14:56:14 +0300
Message-Id: <1251028605-31977-16-git-send-email-avi@redhat.com>
In-Reply-To: <1251028605-31977-1-git-send-email-avi@redhat.com>
References: <1251028605-31977-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael S. Tsirkin <mst@redhat.com>

Irqfd sets level for interrupt to 1 and then to 0.
For MSI, check level so that a single message is sent.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 virt/kvm/irq_comm.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
index 56e6961..a9d7fd1 100644
--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -139,7 +139,9 @@ int kvm_set_irq(struct kvm *kvm, int irq_source_id, int irq, int level)
 		else
 			clear_bit(irq_source_id, irq_state);
 		sig_level = !!(*irq_state);
-	} else /* Deal with MSI/MSI-X */
+	} else if (!level)
+		return ret;
+	else /* Deal with MSI/MSI-X */
 		sig_level = 1;
 
 	/* Not possible to detect if the guest uses the PIC or the
-- 
1.6.4.1

