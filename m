Return-Path: <linux-kernel-owner+w=401wt.eu-S932496AbZHZKdD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932496AbZHZKdD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:33:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932445AbZHZKcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:32:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62922 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757129AbZHZKaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:30:14 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 46/47] KVM: Protect update_cr8_intercept() when running without an apic
Date: Wed, 26 Aug 2009 13:30:08 +0300
Message-Id: <1251282609-12835-47-git-send-email-avi@redhat.com>
In-Reply-To: <1251282609-12835-1-git-send-email-avi@redhat.com>
References: <1251282609-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

update_cr8_intercept() can be triggered from userspace while there
is no apic present.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 59a8ba4..35e7fc5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3500,6 +3500,9 @@ static void update_cr8_intercept(struct kvm_vcpu *vcpu)
 	if (!kvm_x86_ops->update_cr8_intercept)
 		return;
 
+	if (!vcpu->arch.apic)
+		return;
+
 	if (!vcpu->arch.apic->vapic_addr)
 		max_irr = kvm_lapic_find_highest_irr(vcpu);
 	else
-- 
1.6.4.1

