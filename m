Return-Path: <linux-kernel-owner+w=401wt.eu-S933771AbXDZJYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933771AbXDZJYL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 05:24:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933793AbXDZJYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 05:24:06 -0400
Received: from il.qumranet.com ([82.166.9.18]:53038 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933771AbXDZJW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 05:22:27 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Eddie Dong <eddie.dong@intel.com>,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH 14/18] KVM: VMX: Avoid unnecessary vcpu_load()/vcpu_put() cycles
Date: Thu, 26 Apr 2007 12:22:14 +0300
Message-Id: <1177579338397-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11775793382353-git-send-email-avi@qumranet.com>
References: <11775793382353-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eddie Dong <eddie.dong@intel.com>

By checking if a reschedule is needed, we avoid dropping the vcpu.

[With changes by me, based on Anthony Liguori's observations]

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 03c0ee7..f535635 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -1590,6 +1590,8 @@ static int set_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 
 void kvm_resched(struct kvm_vcpu *vcpu)
 {
+	if (!need_resched())
+		return;
 	vcpu_put(vcpu);
 	cond_resched();
 	vcpu_load(vcpu);
-- 
1.5.0.6

