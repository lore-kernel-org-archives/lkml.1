Return-Path: <linux-kernel-owner+w=401wt.eu-S1759547AbYAFOnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759547AbYAFOnz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 09:43:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758282AbYAFOj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 09:39:57 -0500
Received: from il.qumranet.com ([82.166.9.18]:46646 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755795AbYAFOjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 09:39:47 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Ryan Harper <ryanh@us.ibm.com>
Subject: [PATCH 14/33] KVM: VMX: Add printk_ratelimit in vmx_intr_assist
Date: Sun,  6 Jan 2008 16:39:20 +0200
Message-Id: <1199630379-28638-15-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199630379-28638-1-git-send-email-avi@qumranet.com>
References: <1199630379-28638-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ryan Harper <ryanh@us.ibm.com>

Add printk_ratelimit check in front of printk.  This prevents spamming
of the message during 32-bit ubuntu 6.06server install.  Previously, it
would hang during the partition formatting stage.

Signed-off-by: Ryan Harper <ryanh@us.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/vmx.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 13c6a51..4407998 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -2262,7 +2262,8 @@ static void vmx_intr_assist(struct kvm_vcpu *vcpu)
 	if (intr_info_field & INTR_INFO_VALID_MASK) {
 		if (idtv_info_field & INTR_INFO_VALID_MASK) {
 			/* TODO: fault when IDT_Vectoring */
-			printk(KERN_ERR "Fault when IDT_Vectoring\n");
+			if (printk_ratelimit())
+				printk(KERN_ERR "Fault when IDT_Vectoring\n");
 		}
 		if (has_ext_irq)
 			enable_irq_window(vcpu);
-- 
1.5.3.7

