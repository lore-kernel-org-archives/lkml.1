Return-Path: <linux-kernel-owner+w=401wt.eu-S1756058AbXIQIlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058AbXIQIlA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754709AbXIQIcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:32:45 -0400
Received: from il.qumranet.com ([82.166.9.18]:45251 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753719AbXIQIc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:28 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Gabriel C <nix.or.die@googlemail.com>
Subject: [PATCH 045/104] KVM: Fix defined but not used warning in drivers/kvm/vmx.c
Date: Mon, 17 Sep 2007 10:31:27 +0200
Message-Id: <11900179473956-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gabriel C <nix.or.die@googlemail.com>

move_msr_up() is used only on X86_64 and generates a warning on !X86_64

Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/vmx.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index a94eb20..3bf3650 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -544,6 +544,7 @@ static void vmx_inject_gp(struct kvm_vcpu *vcpu, unsigned error_code)
 /*
  * Swap MSR entry in host/guest MSR entry array.
  */
+#ifdef CONFIG_X86_64
 static void move_msr_up(struct vcpu_vmx *vmx, int from, int to)
 {
 	struct kvm_msr_entry tmp;
@@ -555,6 +556,7 @@ static void move_msr_up(struct vcpu_vmx *vmx, int from, int to)
 	vmx->host_msrs[to] = vmx->host_msrs[from];
 	vmx->host_msrs[from] = tmp;
 }
+#endif
 
 /*
  * Set up the vmcs to automatically save and restore system
-- 
1.5.3

