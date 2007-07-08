Return-Path: <linux-kernel-owner+w=401wt.eu-S1757383AbXGHL56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383AbXGHL56 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 07:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754853AbXGHLzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 07:55:16 -0400
Received: from il.qumranet.com ([82.166.9.18]:38405 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751785AbXGHLyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 07:54:46 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 10/20] KVM: VMX: Remove unnecessary code in vmx_tlb_flush()
Date: Sun,  8 Jul 2007 14:54:39 +0300
Message-Id: <11838956892130-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11838956891287-git-send-email-avi@qumranet.com>
References: <11838956891287-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A vmexit implicitly flushes the tlb; the code is bogus.

Noted by Shaohua Li.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/vmx.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 42a9163..7d04ffa 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -1987,7 +1987,6 @@ static int dm_request_for_irq_injection(struct kvm_vcpu *vcpu,
 
 static void vmx_flush_tlb(struct kvm_vcpu *vcpu)
 {
-	vmcs_writel(GUEST_CR3, vmcs_readl(GUEST_CR3));
 }
 
 static int vmx_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
-- 
1.5.2.2

