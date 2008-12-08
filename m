Return-Path: <linux-kernel-owner+w=401wt.eu-S1753098AbYLHLiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098AbYLHLiO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:38:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753343AbYLHLhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:37:06 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48210 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753212AbYLHLhC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:37:02 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>
Subject: [PATCH 02/45] KVM: VMX: include all IRQ window exits in statistics
Date: Mon,  8 Dec 2008 13:36:13 +0200
Message-Id: <1228736216-15787-3-git-send-email-avi@redhat.com>
In-Reply-To: <1228736216-15787-1-git-send-email-avi@redhat.com>
References: <1228736216-15787-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

irq_window_exits only tracks IRQ window exits due to user space
requests, nmi_window_exits include all exits. The latter makes more
sense, so let's adjust irq_window_exits accounting.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index a4018b0..ac34537 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2767,6 +2767,7 @@ static int handle_interrupt_window(struct kvm_vcpu *vcpu,
 	vmcs_write32(CPU_BASED_VM_EXEC_CONTROL, cpu_based_vm_exec_control);
 
 	KVMTRACE_0D(PEND_INTR, vcpu, handler);
+	++vcpu->stat.irq_window_exits;
 
 	/*
 	 * If the user space waits to inject interrupts, exit as soon as
@@ -2775,7 +2776,6 @@ static int handle_interrupt_window(struct kvm_vcpu *vcpu,
 	if (kvm_run->request_interrupt_window &&
 	    !vcpu->arch.irq_summary) {
 		kvm_run->exit_reason = KVM_EXIT_IRQ_WINDOW_OPEN;
-		++vcpu->stat.irq_window_exits;
 		return 0;
 	}
 	return 1;
-- 
1.6.0.3

