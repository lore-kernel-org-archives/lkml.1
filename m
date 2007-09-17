Return-Path: <linux-kernel-owner+w=401wt.eu-S1757214AbXIQIru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214AbXIQIru (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754409AbXIQIdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:33:09 -0400
Received: from il.qumranet.com ([82.166.9.18]:45264 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754290AbXIQIcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:32 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Izik Eidus <izike@qumranet.com>
Subject: [PATCH 060/104] KVM: VMX: allow rmode_tss_base() to work with >2G of guest memory
Date: Mon, 17 Sep 2007 10:31:42 +0200
Message-Id: <11900179481990-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Izik Eidus <izike@qumranet.com>

Signed-off-by: Izik Eidus <izike@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/vmx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index cd999c0..b400668 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -1030,7 +1030,7 @@ static void enter_pmode(struct kvm_vcpu *vcpu)
 	vmcs_write32(GUEST_CS_AR_BYTES, 0x9b);
 }
 
-static int rmode_tss_base(struct kvm* kvm)
+static gva_t rmode_tss_base(struct kvm* kvm)
 {
 	gfn_t base_gfn = kvm->memslots[0].base_gfn + kvm->memslots[0].npages - 3;
 	return base_gfn << PAGE_SHIFT;
-- 
1.5.3

