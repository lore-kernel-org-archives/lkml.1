Return-Path: <linux-kernel-owner+w=401wt.eu-S1754218AbXJULKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218AbXJULKi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 07:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751742AbXJULH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 07:07:59 -0400
Received: from il.qumranet.com ([82.166.9.18]:58444 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490AbXJULHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 07:07:55 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 07/11] KVM: VMX: Force vm86 mode if setting flags during real mode
Date: Sun, 21 Oct 2007 13:08:08 +0200
Message-Id: <11929648921223-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <1192964892617-git-send-email-avi@qumranet.com>
References: <1192964892617-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When resetting from userspace, we need to handle the flags being cleared
even after we are in real mode.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/vmx.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index f130c01..bb56ae3 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -523,6 +523,8 @@ static unsigned long vmx_get_rflags(struct kvm_vcpu *vcpu)
 
 static void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
 {
+	if (vcpu->rmode.active)
+		rflags |= IOPL_MASK | X86_EFLAGS_VM;
 	vmcs_writel(GUEST_RFLAGS, rflags);
 }
 
-- 
1.5.3

