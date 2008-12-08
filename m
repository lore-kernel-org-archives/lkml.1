Return-Path: <linux-kernel-owner+w=401wt.eu-S1757468AbYLHLu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468AbYLHLu4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:50:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753416AbYLHLiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:38:46 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48229 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752915AbYLHLhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:37:03 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>
Subject: [PATCH 10/45] KVM: x86: VCPU with pending NMI is runnabled
Date: Mon,  8 Dec 2008 13:36:21 +0200
Message-Id: <1228736216-15787-11-git-send-email-avi@redhat.com>
In-Reply-To: <1228736216-15787-1-git-send-email-avi@redhat.com>
References: <1228736216-15787-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

Ensure that a VCPU with pending NMIs is considered runnable.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1a71f67..1fa9a6d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4130,7 +4130,8 @@ void kvm_arch_flush_shadow(struct kvm *kvm)
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE
-	       || vcpu->arch.mp_state == KVM_MP_STATE_SIPI_RECEIVED;
+	       || vcpu->arch.mp_state == KVM_MP_STATE_SIPI_RECEIVED
+	       || vcpu->arch.nmi_pending;
 }
 
 static void vcpu_kick_intr(void *info)
-- 
1.6.0.3

