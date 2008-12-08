Return-Path: <linux-kernel-owner+w=401wt.eu-S1756748AbYLHLwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748AbYLHLwm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:52:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754003AbYLHLit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:38:49 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48223 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753253AbYLHLhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:37:03 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>
Subject: [PATCH 11/45] KVM: Kick NMI receiving VCPU
Date: Mon,  8 Dec 2008 13:36:22 +0200
Message-Id: <1228736216-15787-12-git-send-email-avi@redhat.com>
In-Reply-To: <1228736216-15787-1-git-send-email-avi@redhat.com>
References: <1228736216-15787-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

Kick the NMI receiving VCPU in case the triggering caller runs in a
different context.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/lapic.c |    1 +
 virt/kvm/ioapic.c    |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 206cc11..304f9dd 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -354,6 +354,7 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 
 	case APIC_DM_NMI:
 		kvm_inject_nmi(vcpu);
+		kvm_vcpu_kick(vcpu);
 		break;
 
 	case APIC_DM_INIT:
diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index 53772bb..c8f939c 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -150,6 +150,7 @@ static int ioapic_inj_irq(struct kvm_ioapic *ioapic,
 static void ioapic_inj_nmi(struct kvm_vcpu *vcpu)
 {
 	kvm_inject_nmi(vcpu);
+	kvm_vcpu_kick(vcpu);
 }
 
 static u32 ioapic_get_delivery_bitmask(struct kvm_ioapic *ioapic, u8 dest,
-- 
1.6.0.3

