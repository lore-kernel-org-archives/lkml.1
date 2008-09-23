Return-Path: <linux-kernel-owner+w=401wt.eu-S1755042AbYIWNun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042AbYIWNun (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 09:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753338AbYIWNrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 09:47:24 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52364 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752847AbYIWNrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 09:47:16 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 11/40] KVM: Add a pending interrupt queue
Date: Tue, 23 Sep 2008 16:46:25 +0300
Message-Id: <1222177614-26669-12-git-send-email-avi@redhat.com>
In-Reply-To: <1222177614-26669-1-git-send-email-avi@redhat.com>
References: <1222177614-26669-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avi Kivity <avi@qumranet.com>

Similar to the exception queue, this hold interrupts that have been
accepted by the virtual processor core but not yet injected.

Not yet used.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86.h         |   11 +++++++++++
 include/asm-x86/kvm_host.h |    5 +++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index c666649..6a4be78 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -8,4 +8,15 @@ static inline void kvm_clear_exception_queue(struct kvm_vcpu *vcpu)
 	vcpu->arch.exception.pending = false;
 }
 
+static inline void kvm_queue_interrupt(struct kvm_vcpu *vcpu, u8 vector)
+{
+	vcpu->arch.interrupt.pending = true;
+	vcpu->arch.interrupt.nr = vector;
+}
+
+static inline void kvm_clear_interrupt_queue(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.interrupt.pending = false;
+}
+
 #endif
diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index 501d215..af1c0f7 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -275,6 +275,11 @@ struct kvm_vcpu_arch {
 		u32 error_code;
 	} exception;
 
+	struct kvm_queued_interrupt {
+		bool pending;
+		u8 nr;
+	} interrupt;
+
 	struct {
 		int active;
 		u8 save_iopl;
-- 
1.6.0.1

