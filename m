Return-Path: <linux-kernel-owner+w=401wt.eu-S1757648AbZERJbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757648AbZERJbi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 05:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756079AbZERJXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 05:23:40 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38407 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753276AbZERJXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 05:23:09 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 12/43] KVM: x86: paravirt skip pit-through-ioapic boot check
Date: Mon, 18 May 2009 12:22:34 +0300
Message-Id: <1242638585-18470-13-git-send-email-avi@redhat.com>
In-Reply-To: <1242638585-18470-1-git-send-email-avi@redhat.com>
References: <1242638585-18470-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Skip the test which checks if the PIT is properly routed when
using the IOAPIC, aimed at buggy hardware.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kernel/kvm.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 33019dd..057173d 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -27,6 +27,7 @@
 #include <linux/mm.h>
 #include <linux/highmem.h>
 #include <linux/hardirq.h>
+#include <asm/timer.h>
 
 #define MMU_QUEUE_SIZE 1024
 
@@ -230,6 +231,9 @@ static void paravirt_ops_setup(void)
 		pv_mmu_ops.lazy_mode.enter = kvm_enter_lazy_mmu;
 		pv_mmu_ops.lazy_mode.leave = kvm_leave_lazy_mmu;
 	}
+#ifdef CONFIG_X86_IO_APIC
+	no_timer_check = 1;
+#endif
 }
 
 void __init kvm_guest_init(void)
-- 
1.6.0.6

