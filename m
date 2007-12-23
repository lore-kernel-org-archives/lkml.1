Return-Path: <linux-kernel-owner+w=401wt.eu-S1757036AbXLWO7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036AbXLWO7q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 09:59:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753019AbXLWOwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 09:52:07 -0500
Received: from il.qumranet.com ([82.166.9.18]:35898 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998AbXLWOvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 09:51:43 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 19/50] KVM: VMX: Simplify vcpu_clear()
Date: Sun, 23 Dec 2007 16:51:04 +0200
Message-Id: <1198421495-31481-20-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198421495-31481-1-git-send-email-avi@qumranet.com>
References: <1198421495-31481-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that smp_call_function_single() knows how to call a function on the
current cpu, there's no need to check explicitly.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/vmx.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 8929575..c87f52b 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -227,11 +227,7 @@ static void vcpu_clear(struct vcpu_vmx *vmx)
 {
 	if (vmx->vcpu.cpu == -1)
 		return;
-	if (vmx->vcpu.cpu != raw_smp_processor_id())
-		smp_call_function_single(vmx->vcpu.cpu, __vcpu_clear,
-					 vmx, 0, 1);
-	else
-		__vcpu_clear(vmx);
+	smp_call_function_single(vmx->vcpu.cpu, __vcpu_clear, vmx, 0, 1);
 	vmx->launched = 0;
 }
 
-- 
1.5.3.7

