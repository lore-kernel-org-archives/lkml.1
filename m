Return-Path: <linux-kernel-owner+w=401wt.eu-S1758983AbXLWPAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758983AbXLWPAx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 10:00:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755080AbXLWOwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 09:52:10 -0500
Received: from il.qumranet.com ([82.166.9.18]:35892 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753880AbXLWOvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 09:51:45 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 25/50] KVM: Remove gratuitous casts from lapic.c
Date: Sun, 23 Dec 2007 16:51:10 +0200
Message-Id: <1198421495-31481-26-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198421495-31481-1-git-send-email-avi@qumranet.com>
References: <1198421495-31481-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

Since vcpu->apic is of the correct type, there's not need to cast.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/lapic.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/kvm/lapic.c b/drivers/kvm/lapic.c
index 8e8dab0..554e73a 100644
--- a/drivers/kvm/lapic.c
+++ b/drivers/kvm/lapic.c
@@ -172,7 +172,7 @@ static inline int apic_find_highest_irr(struct kvm_lapic *apic)
 
 int kvm_lapic_find_highest_irr(struct kvm_vcpu *vcpu)
 {
-	struct kvm_lapic *apic = (struct kvm_lapic *)vcpu->apic;
+	struct kvm_lapic *apic = vcpu->apic;
 	int highest_irr;
 
 	if (!apic)
@@ -783,7 +783,7 @@ void kvm_free_lapic(struct kvm_vcpu *vcpu)
 
 void kvm_lapic_set_tpr(struct kvm_vcpu *vcpu, unsigned long cr8)
 {
-	struct kvm_lapic *apic = (struct kvm_lapic *)vcpu->apic;
+	struct kvm_lapic *apic = vcpu->apic;
 
 	if (!apic)
 		return;
@@ -792,7 +792,7 @@ void kvm_lapic_set_tpr(struct kvm_vcpu *vcpu, unsigned long cr8)
 
 u64 kvm_lapic_get_cr8(struct kvm_vcpu *vcpu)
 {
-	struct kvm_lapic *apic = (struct kvm_lapic *)vcpu->apic;
+	struct kvm_lapic *apic = vcpu->apic;
 	u64 tpr;
 
 	if (!apic)
@@ -805,7 +805,7 @@ EXPORT_SYMBOL_GPL(kvm_lapic_get_cr8);
 
 void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
 {
-	struct kvm_lapic *apic = (struct kvm_lapic *)vcpu->apic;
+	struct kvm_lapic *apic = vcpu->apic;
 
 	if (!apic) {
 		value |= MSR_IA32_APICBASE_BSP;
@@ -882,7 +882,7 @@ EXPORT_SYMBOL_GPL(kvm_lapic_reset);
 
 int kvm_lapic_enabled(struct kvm_vcpu *vcpu)
 {
-	struct kvm_lapic *apic = (struct kvm_lapic *)vcpu->apic;
+	struct kvm_lapic *apic = vcpu->apic;
 	int ret = 0;
 
 	if (!apic)
-- 
1.5.3.7

