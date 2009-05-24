Return-Path: <linux-kernel-owner+w=401wt.eu-S1758886AbZEXPyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758886AbZEXPyh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 11:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757825AbZEXPvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 11:51:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41857 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755041AbZEXPuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 11:50:35 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 37/45] KVM: Do not allow interrupt injection from userspace if there is a pending event.
Date: Sun, 24 May 2009 18:50:22 +0300
Message-Id: <1243180230-2480-38-git-send-email-avi@redhat.com>
In-Reply-To: <1243180230-2480-1-git-send-email-avi@redhat.com>
References: <1243180230-2480-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

The exception will immediately close the interrupt window.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 33f850b..d9396a7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3101,8 +3101,9 @@ static void post_kvm_run_save(struct kvm_vcpu *vcpu,
 		kvm_run->ready_for_interrupt_injection = 1;
 	else
 		kvm_run->ready_for_interrupt_injection =
-					(kvm_arch_interrupt_allowed(vcpu) &&
-					 !kvm_cpu_has_interrupt(vcpu));
+			kvm_arch_interrupt_allowed(vcpu) &&
+			!kvm_cpu_has_interrupt(vcpu) &&
+			!kvm_event_needs_reinjection(vcpu);
 }
 
 static void vapic_enter(struct kvm_vcpu *vcpu)
-- 
1.6.0.6

