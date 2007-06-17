Return-Path: <linux-kernel-owner+w=401wt.eu-S1760135AbXFQJri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760135AbXFQJri (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 05:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759398AbXFQJor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:44:47 -0400
Received: from il.qumranet.com ([82.166.9.18]:55152 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757988AbXFQJol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:41 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 05/58] KVM: Unindent some code
Date: Sun, 17 Jun 2007 12:43:46 +0300
Message-Id: <11820734803069-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1182073479890-git-send-email-avi@qumranet.com>
References: <1182073479890-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/vmx.c |   58 ++++++++++++++++++++++++++--------------------------
 1 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 84ce0c0..9ebb18d 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -1998,39 +1998,39 @@ again:
 
 	asm ("mov %0, %%ds; mov %0, %%es" : : "r"(__USER_DS));
 
-	if (fail) {
+	if (unlikely(fail)) {
 		kvm_run->exit_reason = KVM_EXIT_FAIL_ENTRY;
 		kvm_run->fail_entry.hardware_entry_failure_reason
 			= vmcs_read32(VM_INSTRUCTION_ERROR);
 		r = 0;
-	} else {
-		/*
-		 * Profile KVM exit RIPs:
-		 */
-		if (unlikely(prof_on == KVM_PROFILING))
-			profile_hit(KVM_PROFILING, (void *)vmcs_readl(GUEST_RIP));
-
-		vcpu->launched = 1;
-		r = kvm_handle_exit(kvm_run, vcpu);
-		if (r > 0) {
-			/* Give scheduler a change to reschedule. */
-			if (signal_pending(current)) {
-				r = -EINTR;
-				kvm_run->exit_reason = KVM_EXIT_INTR;
-				++vcpu->stat.signal_exits;
-				goto out;
-			}
-
-			if (dm_request_for_irq_injection(vcpu, kvm_run)) {
-				r = -EINTR;
-				kvm_run->exit_reason = KVM_EXIT_INTR;
-				++vcpu->stat.request_irq_exits;
-				goto out;
-			}
-			if (!need_resched()) {
-				++vcpu->stat.light_exits;
-				goto again;
-			}
+		goto out;
+	}
+	/*
+	 * Profile KVM exit RIPs:
+	 */
+	if (unlikely(prof_on == KVM_PROFILING))
+		profile_hit(KVM_PROFILING, (void *)vmcs_readl(GUEST_RIP));
+
+	vcpu->launched = 1;
+	r = kvm_handle_exit(kvm_run, vcpu);
+	if (r > 0) {
+		/* Give scheduler a change to reschedule. */
+		if (signal_pending(current)) {
+			r = -EINTR;
+			kvm_run->exit_reason = KVM_EXIT_INTR;
+			++vcpu->stat.signal_exits;
+			goto out;
+		}
+
+		if (dm_request_for_irq_injection(vcpu, kvm_run)) {
+			r = -EINTR;
+			kvm_run->exit_reason = KVM_EXIT_INTR;
+			++vcpu->stat.request_irq_exits;
+			goto out;
+		}
+		if (!need_resched()) {
+			++vcpu->stat.light_exits;
+			goto again;
 		}
 	}
 
-- 
1.5.0.6

