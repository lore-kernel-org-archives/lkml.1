Return-Path: <linux-kernel-owner+w=401wt.eu-S1755729AbYLHLwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729AbYLHLwA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:52:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754021AbYLHLiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:38:52 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48221 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753244AbYLHLhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:37:03 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>
Subject: [PATCH 05/45] KVM: x86: Reset pending/inject NMI state on CPU reset
Date: Mon,  8 Dec 2008 13:36:16 +0200
Message-Id: <1228736216-15787-6-git-send-email-avi@redhat.com>
In-Reply-To: <1228736216-15787-1-git-send-email-avi@redhat.com>
References: <1228736216-15787-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

CPU reset invalidates pending or already injected NMIs, therefore reset
the related state variables.

Based on original patch by Gleb Natapov.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f1f8ff2..1a71f67 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3925,6 +3925,9 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 
 int kvm_arch_vcpu_reset(struct kvm_vcpu *vcpu)
 {
+	vcpu->arch.nmi_pending = false;
+	vcpu->arch.nmi_injected = false;
+
 	return kvm_x86_ops->vcpu_reset(vcpu);
 }
 
-- 
1.6.0.3

