Return-Path: <linux-kernel-owner+w=401wt.eu-S933816AbXDZJX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933816AbXDZJX1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 05:23:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933773AbXDZJWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 05:22:55 -0400
Received: from il.qumranet.com ([82.166.9.18]:53041 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933808AbXDZJW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 05:22:28 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 18/18] KVM: Don't complain about cpu erratum AA15
Date: Thu, 26 Apr 2007 12:22:18 +0300
Message-Id: <11775793382053-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11775793382353-git-send-email-avi@qumranet.com>
References: <11775793382353-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It slows down Windows x64 horribly.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/vmx.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 10845b7..d28c848 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -1566,8 +1566,6 @@ static int handle_cr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 			skip_emulated_instruction(vcpu);
 			return 1;
 		case 8:
-			printk(KERN_DEBUG "handle_cr: read CR8 "
-			       "cpu erratum AA15\n");
 			vcpu_load_rsp_rip(vcpu);
 			vcpu->regs[reg] = vcpu->cr8;
 			vcpu_put_rsp_rip(vcpu);
-- 
1.5.0.6

