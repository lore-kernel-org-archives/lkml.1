Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932813Ab0BPKfk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 05:35:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36258 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932476Ab0BPKfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 05:35:38 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 02/38] KVM: VMX: Remove emulation failure report
Date: Tue, 16 Feb 2010 12:35:00 +0200
Message-Id: <1266316536-28936-3-git-send-email-avi@redhat.com>
In-Reply-To: <1266316536-28936-1-git-send-email-avi@redhat.com>
References: <1266316536-28936-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

As Avi noted:

>There are two problems with the kernel failure report.  First, it
>doesn't report enough data - registers, surrounding instructions, etc.
>that are needed to explain what is going on.  Second, it can flood
>dmesg, which is a pretty bad thing to do.

So we remove the emulation failure report in handle_invalid_guest_state(),
and would inspected the guest using userspace tool in the future.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/vmx.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index fc1964d..516084f 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3449,7 +3449,6 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
 		}
 
 		if (err != EMULATE_DONE) {
-			kvm_report_emulation_failure(vcpu, "emulation failure");
 			vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 			vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
 			vcpu->run->internal.ndata = 0;
-- 
1.6.5.3

