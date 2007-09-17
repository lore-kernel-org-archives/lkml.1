Return-Path: <linux-kernel-owner+w=401wt.eu-S1759527AbXIQJHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759527AbXIQJHT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 05:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754883AbXIQIeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:34:13 -0400
Received: from il.qumranet.com ([82.166.9.18]:45248 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169AbXIQIcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:25 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 018/104] KVM: Return if the pdptrs are invalid when the guest turns on PAE.
Date: Mon, 17 Sep 2007 10:31:00 +0200
Message-Id: <11900179472967-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

Don't fall through and turn on PAE in this case.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index f0fc8d9..093cea3 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -558,6 +558,7 @@ void set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 		   && !load_pdptrs(vcpu, vcpu->cr3)) {
 		printk(KERN_DEBUG "set_cr4: #GP, pdptrs reserved bits\n");
 		inject_gp(vcpu);
+		return;
 	}
 
 	if (cr4 & X86_CR4_VMXE) {
-- 
1.5.3

