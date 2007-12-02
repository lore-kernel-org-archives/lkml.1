Return-Path: <linux-kernel-owner+w=401wt.eu-S1752373AbXLBLUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373AbXLBLUU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 06:20:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753428AbXLBLSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 06:18:16 -0500
Received: from il.qumranet.com ([82.166.9.18]:41442 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751927AbXLBLSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 06:18:08 -0500
From: Avi Kivity <avi@qumranet.com>
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH 09/10] KVM: VMX: Force vm86 mode if setting flags during real mode
Date: Sun,  2 Dec 2007 13:18:46 +0200
Message-Id: <11965943271441-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <1196594327338-git-send-email-avi@qumranet.com>
References: <1196594327338-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When resetting from userspace, we need to handle the flags being cleared
even after we are in real mode.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/vmx.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 80628f6..c158a2d 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -463,6 +463,8 @@ static unsigned long vmx_get_rflags(struct kvm_vcpu *vcpu)
 
 static void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
 {
+	if (vcpu->rmode.active)
+		rflags |= IOPL_MASK | X86_EFLAGS_VM;
 	vmcs_writel(GUEST_RFLAGS, rflags);
 }
 
-- 
1.5.3

