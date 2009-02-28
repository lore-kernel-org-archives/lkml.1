Return-Path: <linux-kernel-owner+w=401wt.eu-S1761938AbZB1BwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761938AbZB1BwB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 20:52:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754362AbZB1BnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 20:43:00 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41778 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754696AbZB1Bl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 20:41:58 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 28/30] KVM: is_long_mode() should check for EFER.LMA
Date: Sat, 28 Feb 2009 03:41:47 +0200
Message-Id: <1235785309-12835-29-git-send-email-avi@redhat.com>
In-Reply-To: <1235785309-12835-1-git-send-email-avi@redhat.com>
References: <1235785309-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amit Shah <amit.shah@qumranet.com>

is_long_mode currently checks the LongModeEnable bit in
EFER instead of the LongModeActive bit. This is wrong, but
we survived this till now since it wasn't triggered. This
breaks guests that go from long mode to compatibility mode.

This is noticed on a solaris guest and fixes bug #1842160

Signed-off-by: Amit Shah <amit.shah@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/mmu.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 258e5d5..eaab214 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -54,7 +54,7 @@ static inline int kvm_mmu_reload(struct kvm_vcpu *vcpu)
 static inline int is_long_mode(struct kvm_vcpu *vcpu)
 {
 #ifdef CONFIG_X86_64
-	return vcpu->arch.shadow_efer & EFER_LME;
+	return vcpu->arch.shadow_efer & EFER_LMA;
 #else
 	return 0;
 #endif
-- 
1.6.0.6

