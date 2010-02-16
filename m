Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880Ab0BPKj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 05:39:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932816Ab0BPKfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 05:35:41 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 27/38] KVM: Fix msr trace
Date: Tue, 16 Feb 2010 12:35:25 +0200
Message-Id: <1266316536-28936-28-git-send-email-avi@redhat.com>
In-Reply-To: <1266316536-28936-1-git-send-email-avi@redhat.com>
References: <1266316536-28936-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- data is 64 bits wide, not unsigned long
- rw is confusingly named

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/trace.h |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 1cb3d0e..45903a9 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -246,23 +246,23 @@ TRACE_EVENT(kvm_page_fault,
  * Tracepoint for guest MSR access.
  */
 TRACE_EVENT(kvm_msr,
-	TP_PROTO(unsigned int rw, unsigned int ecx, unsigned long data),
-	TP_ARGS(rw, ecx, data),
+	TP_PROTO(unsigned write, u32 ecx, u64 data),
+	TP_ARGS(write, ecx, data),
 
 	TP_STRUCT__entry(
-		__field(	unsigned int,	rw		)
-		__field(	unsigned int,	ecx		)
-		__field(	unsigned long,	data		)
+		__field(	unsigned,	write		)
+		__field(	u32,		ecx		)
+		__field(	u64,		data		)
 	),
 
 	TP_fast_assign(
-		__entry->rw		= rw;
+		__entry->write		= write;
 		__entry->ecx		= ecx;
 		__entry->data		= data;
 	),
 
-	TP_printk("msr_%s %x = 0x%lx",
-		  __entry->rw ? "write" : "read",
+	TP_printk("msr_%s %x = 0x%llx",
+		  __entry->write ? "write" : "read",
 		  __entry->ecx, __entry->data)
 );
 
-- 
1.6.5.3

