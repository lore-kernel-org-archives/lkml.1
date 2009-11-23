Return-Path: <linux-kernel-owner+w=401wt.eu-S1754864AbZKWOLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbZKWOLo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 09:11:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754160AbZKWOLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 09:11:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28404 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754006AbZKWOJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 09:09:30 -0500
From: Gleb Natapov <gleb@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       hpa@zytor.com, riel@redhat.com
Subject: [PATCH v2 12/12] Send async PF when guest is not in userspace too.
Date: Mon, 23 Nov 2009 16:06:07 +0200
Message-Id: <1258985167-29178-13-git-send-email-gleb@redhat.com>
In-Reply-To: <1258985167-29178-1-git-send-email-gleb@redhat.com>
References: <1258985167-29178-1-git-send-email-gleb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Gleb Natapov <gleb@redhat.com>
---
 arch/x86/kvm/mmu.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 1225c31..a538d82 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2204,10 +2204,11 @@ int kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr3, gva_t gva,
 
 static bool can_do_async_pf(struct kvm_vcpu *vcpu)
 {
-	if (!vcpu->arch.apf_data || kvm_event_needs_reinjection(vcpu))
+	if (!vcpu->arch.apf_data || kvm_event_needs_reinjection(vcpu) ||
+	    !kvm_x86_ops->interrupt_allowed(vcpu))
 		return false;
 
-	return !!kvm_x86_ops->get_cpl(vcpu);
+	return true;
 }
 
 static int tdp_page_fault(struct kvm_vcpu *vcpu, gpa_t cr3, gva_t gpa,
-- 
1.6.5

