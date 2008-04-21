Return-Path: <linux-kernel-owner+w=401wt.eu-S1758851AbYDUKgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758851AbYDUKgt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 06:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755549AbYDUKa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 06:30:26 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:37888
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756161AbYDUKaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 06:30:09 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 25/31] KVM: export kvm_lapic_set_tpr() to modules
Date: Mon, 21 Apr 2008 13:29:51 +0300
Message-Id: <1208773797-7829-26-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208773797-7829-1-git-send-email-avi@qumranet.com>
References: <1208773797-7829-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

This patch exports the kvm_lapic_set_tpr() function from the lapic code to
modules. It is required in the kvm-amd module to optimize CR8 intercepts.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/lapic.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 2ccf994..57ac4e4 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -822,6 +822,7 @@ void kvm_lapic_set_tpr(struct kvm_vcpu *vcpu, unsigned long cr8)
 	apic_set_tpr(apic, ((cr8 & 0x0f) << 4)
 		     | (apic_get_reg(apic, APIC_TASKPRI) & 4));
 }
+EXPORT_SYMBOL_GPL(kvm_lapic_set_tpr);
 
 u64 kvm_lapic_get_cr8(struct kvm_vcpu *vcpu)
 {
-- 
1.5.5

