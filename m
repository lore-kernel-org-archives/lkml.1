Return-Path: <linux-kernel-owner+w=401wt.eu-S933875AbZHWMHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933875AbZHWMHT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 08:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933839AbZHWMHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 08:07:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59971 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933520AbZHWL4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 07:56:46 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 04/46] KVM: Trace apic registers using their symbolic names
Date: Sun, 23 Aug 2009 14:56:03 +0300
Message-Id: <1251028605-31977-5-git-send-email-avi@redhat.com>
In-Reply-To: <1251028605-31977-1-git-send-email-avi@redhat.com>
References: <1251028605-31977-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/trace.h |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index cd8c90d..6c2c87f 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -111,6 +111,15 @@ TRACE_EVENT(kvm_cpuid,
 		  __entry->rbx, __entry->rcx, __entry->rdx)
 );
 
+#define AREG(x) { APIC_##x, "APIC_" #x }
+
+#define kvm_trace_symbol_apic						    \
+	AREG(ID), AREG(LVR), AREG(TASKPRI), AREG(ARBPRI), AREG(PROCPRI),    \
+	AREG(EOI), AREG(RRR), AREG(LDR), AREG(DFR), AREG(SPIV), AREG(ISR),  \
+	AREG(TMR), AREG(IRR), AREG(ESR), AREG(ICR), AREG(ICR2), AREG(LVTT), \
+	AREG(LVTTHMR), AREG(LVTPC), AREG(LVT0), AREG(LVT1), AREG(LVTERR),   \
+	AREG(TMICT), AREG(TMCCT), AREG(TDCR), AREG(SELF_IPI), AREG(EFEAT),  \
+	AREG(ECTRL)
 /*
  * Tracepoint for apic access.
  */
@@ -130,9 +139,10 @@ TRACE_EVENT(kvm_apic,
 		__entry->val		= val;
 	),
 
-	TP_printk("apic_%s 0x%x = 0x%x",
+	TP_printk("apic_%s %s = 0x%x",
 		  __entry->rw ? "write" : "read",
-		  __entry->reg, __entry->val)
+		  __print_symbolic(__entry->reg, kvm_trace_symbol_apic),
+		  __entry->val)
 );
 
 #define trace_kvm_apic_read(reg, val)		trace_kvm_apic(0, reg, val)
-- 
1.6.4.1

