Return-Path: <linux-kernel-owner+w=401wt.eu-S1756921AbXLWO44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921AbXLWO44 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 09:56:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755882AbXLWOvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 09:51:55 -0500
Received: from il.qumranet.com ([82.166.9.18]:35917 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753011AbXLWOvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 09:51:43 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 18/50] KVM: VMX: Don't clear the vmcs if the vcpu is not loaded on any processor
Date: Sun, 23 Dec 2007 16:51:03 +0200
Message-Id: <1198421495-31481-19-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198421495-31481-1-git-send-email-avi@qumranet.com>
References: <1198421495-31481-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Noted by Eddie Dong.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/vmx.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index d32e63d..8929575 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -225,7 +225,9 @@ static void __vcpu_clear(void *arg)
 
 static void vcpu_clear(struct vcpu_vmx *vmx)
 {
-	if (vmx->vcpu.cpu != raw_smp_processor_id() && vmx->vcpu.cpu != -1)
+	if (vmx->vcpu.cpu == -1)
+		return;
+	if (vmx->vcpu.cpu != raw_smp_processor_id())
 		smp_call_function_single(vmx->vcpu.cpu, __vcpu_clear,
 					 vmx, 0, 1);
 	else
-- 
1.5.3.7

