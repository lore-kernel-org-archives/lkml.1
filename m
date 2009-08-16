Return-Path: <linux-kernel-owner+w=401wt.eu-S1754894AbZHPJfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbZHPJfq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 05:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754804AbZHPJfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 05:35:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45355 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753808AbZHPJaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 05:30:13 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 23/48] KVM: Clean up coalesced_mmio destruction
Date: Sun, 16 Aug 2009 12:29:43 +0300
Message-Id: <1250415008-17175-24-git-send-email-avi@redhat.com>
In-Reply-To: <1250415008-17175-1-git-send-email-avi@redhat.com>
References: <1250415008-17175-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gregory Haskins <ghaskins@novell.com>

We invoke kfree() on a data member instead of the structure.  This works today
because the kvm_io_device is the first element of the private structure, but
this could change in the future, so lets clean this up.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
Acked-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 virt/kvm/coalesced_mmio.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index 5ae620d..03ea280 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -80,7 +80,10 @@ static void coalesced_mmio_write(struct kvm_io_device *this,
 
 static void coalesced_mmio_destructor(struct kvm_io_device *this)
 {
-	kfree(this);
+	struct kvm_coalesced_mmio_dev *dev =
+		(struct kvm_coalesced_mmio_dev *)this->private;
+
+	kfree(dev);
 }
 
 int kvm_coalesced_mmio_init(struct kvm *kvm)
-- 
1.6.3.3

