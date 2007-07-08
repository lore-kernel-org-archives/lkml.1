Return-Path: <linux-kernel-owner+w=401wt.eu-S1753705AbXGHLz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705AbXGHLz2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 07:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751724AbXGHLyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 07:54:45 -0400
Received: from il.qumranet.com ([82.166.9.18]:38355 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085AbXGHLyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 07:54:43 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Gregory Haskins <ghaskins@novell.com>,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH 04/20] KVM: VMX: Fix interrupt checking on lightweight exit
Date: Sun,  8 Jul 2007 14:54:33 +0300
Message-Id: <1183895689337-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11838956891287-git-send-email-avi@qumranet.com>
References: <11838956891287-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gregory Haskins <ghaskins@novell.com>

With kernel-injected interrupts, we need to check for interrupts on
lightweight exits too.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/vmx.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index d06c362..b47ddcc 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -1992,13 +1992,13 @@ static int vmx_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	int r;
 
 preempted:
-	if (!vcpu->mmio_read_completed)
-		do_interrupt_requests(vcpu, kvm_run);
-
 	if (vcpu->guest_debug.enabled)
 		kvm_guest_debug_pre(vcpu);
 
 again:
+	if (!vcpu->mmio_read_completed)
+		do_interrupt_requests(vcpu, kvm_run);
+
 	vmx_save_host_state(vcpu);
 	kvm_load_guest_fpu(vcpu);
 
-- 
1.5.2.2

