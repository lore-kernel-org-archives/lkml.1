Return-Path: <linux-kernel-owner+w=401wt.eu-S933596AbZHWMBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933596AbZHWMBd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 08:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933683AbZHWMAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 08:00:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933549AbZHWL4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 07:56:50 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 36/46] KVM: VMX: Avoid to return ENOTSUPP to userland
Date: Sun, 23 Aug 2009 14:56:35 +0300
Message-Id: <1251028605-31977-37-git-send-email-avi@redhat.com>
In-Reply-To: <1251028605-31977-1-git-send-email-avi@redhat.com>
References: <1251028605-31977-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@web.de>

Choose some allowed error values for the cases VMX returned ENOTSUPP so
far as these values could be returned by the KVM_RUN IOCTL.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/vmx.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 686e1ab..c5aaa1b 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3133,7 +3133,7 @@ static int handle_apic_access(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		printk(KERN_ERR
 		       "Fail to handle apic access vmexit! Offset is 0x%lx\n",
 		       offset);
-		return -ENOTSUPP;
+		return -ENOEXEC;
 	}
 	return 1;
 }
@@ -3202,7 +3202,7 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 	if (exit_qualification & (1 << 6)) {
 		printk(KERN_ERR "EPT: GPA exceeds GAW!\n");
-		return -ENOTSUPP;
+		return -EINVAL;
 	}
 
 	gla_validity = (exit_qualification >> 7) & 0x3;
-- 
1.6.4.1

