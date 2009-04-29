Return-Path: <linux-kernel-owner+w=401wt.eu-S1761421AbZD2V3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761421AbZD2V3Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 17:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756233AbZD2V3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 17:29:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56321 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755490AbZD2V3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 17:29:11 -0400
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com
Subject: [PATCH] fix apic_debug instances
Date: Wed, 29 Apr 2009 17:29:09 -0400
Message-Id: <1241040549-25963-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Appearently nobody turned this on in a while...
setting apic_debug to something compilable, generates
some errors. This patch fixes it.

Signed-off-by: Glauber Costa <glommer@redhat.com>
---
 arch/x86/kvm/lapic.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 4d76bb6..15d9a96 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -48,8 +48,8 @@
 
 #define APIC_BUS_CYCLE_NS 1
 
-/* #define apic_debug(fmt,arg...) printk(KERN_WARNING fmt,##arg) */
-#define apic_debug(fmt, arg...)
+#define apic_debug(fmt,arg...) printk(KERN_WARNING fmt,##arg) 
+//#define apic_debug(fmt, arg...)
 
 #define APIC_LVT_NUM			6
 /* 14 is the version for Xeon and Pentium 8.4.8*/
@@ -445,7 +445,7 @@ static void apic_send_ipi(struct kvm_lapic *apic)
 	apic_debug("icr_high 0x%x, icr_low 0x%x, "
 		   "short_hand 0x%x, dest 0x%x, trig_mode 0x%x, level 0x%x, "
 		   "dest_mode 0x%x, delivery_mode 0x%x, vector 0x%x\n",
-		   icr_high, icr_low, irq.shorthand, irq.dest,
+		   icr_high, icr_low, irq.shorthand, irq.dest_id,
 		   irq.trig_mode, irq.level, irq.dest_mode, irq.delivery_mode,
 		   irq.vector);
 
@@ -560,7 +560,7 @@ static void update_divide_count(struct kvm_lapic *apic)
 	apic->divide_count = 0x1 << (tmp2 & 0x7);
 
 	apic_debug("timer divide count is 0x%x\n",
-				   apic->lapic_timer.divide_count);
+				   apic->divide_count);
 }
 
 static void start_apic_timer(struct kvm_lapic *apic)
-- 
1.5.6.6

