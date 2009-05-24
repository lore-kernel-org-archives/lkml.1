Return-Path: <linux-kernel-owner+w=401wt.eu-S1760023AbZEXQCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760023AbZEXQCn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 12:02:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758994AbZEXPzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 11:55:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41826 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209AbZEXPuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 11:50:32 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 14/45] KVM: fix apic_debug instances
Date: Sun, 24 May 2009 18:49:59 +0300
Message-Id: <1243180230-2480-15-git-send-email-avi@redhat.com>
In-Reply-To: <1243180230-2480-1-git-send-email-avi@redhat.com>
References: <1243180230-2480-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <glommer@redhat.com>

Apparently nobody turned this on in a while...
setting apic_debug to something compilable, generates
some errors. This patch fixes it.

Signed-off-by: Glauber Costa <glommer@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/lapic.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 4d76bb6..ae99d83 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
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
1.6.0.6

