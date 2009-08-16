Return-Path: <linux-kernel-owner+w=401wt.eu-S1755071AbZHPJgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071AbZHPJgp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 05:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754751AbZHPJfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 05:35:40 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45356 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754048AbZHPJaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 05:30:13 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 29/48] KVM: VMX: Fix reporting of unhandled EPT violations
Date: Sun, 16 Aug 2009 12:29:49 +0300
Message-Id: <1250415008-17175-30-git-send-email-avi@redhat.com>
In-Reply-To: <1250415008-17175-1-git-send-email-avi@redhat.com>
References: <1250415008-17175-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of returning -ENOTSUPP, exit normally but indicate the hardware
exit reason.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index d726dec..959cb59 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3153,8 +3153,8 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		printk(KERN_ERR "EPT: Exit qualification is 0x%lx\n",
 			(long unsigned int)exit_qualification);
 		kvm_run->exit_reason = KVM_EXIT_UNKNOWN;
-		kvm_run->hw.hardware_exit_reason = 0;
-		return -ENOTSUPP;
+		kvm_run->hw.hardware_exit_reason = EXIT_REASON_EPT_VIOLATION;
+		return 0;
 	}
 
 	gpa = vmcs_read64(GUEST_PHYSICAL_ADDRESS);
-- 
1.6.3.3

