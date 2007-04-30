Return-Path: <linux-kernel-owner+w=401wt.eu-S1946355AbXD3Qi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946355AbXD3Qi6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 12:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946365AbXD3Qi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 12:38:58 -0400
Received: from accolon.hansenpartnership.com ([64.109.89.108]:42110 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946355AbXD3Qi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 12:38:57 -0400
Subject: [PATCH] fix dynticks for voyager
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 30 Apr 2007 11:38:51 -0500
Message-Id: <1177951131.3674.37.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As usual voyager tripped over an explicit boot CPU is zero assumption in
the dynticks code.  This is the fix I have queued in the voyager tree.

James

---

>From 5d3e489cf8fcf12eff92476098b9bfa0120ee3c7 Mon Sep 17 00:00:00 2001
From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Mon, 30 Apr 2007 11:27:25 -0500
Subject: [VOYAGER] clockevents: correct boot cpu is zero assumption

This isn't true for voyager, so alter setup_pit_timer() to initialise
the cpumask from the current processor id (which should be the boot
processor) rather than defaulting to zero.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 arch/i386/kernel/i8253.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/i386/kernel/i8253.c b/arch/i386/kernel/i8253.c
index 10cef5c..f8a3c40 100644
--- a/arch/i386/kernel/i8253.c
+++ b/arch/i386/kernel/i8253.c
@@ -110,7 +110,7 @@ void __init setup_pit_timer(void)
 	 * Start pit with the boot cpu mask and make it global after the
 	 * IO_APIC has been initialized.
 	 */
-	pit_clockevent.cpumask = cpumask_of_cpu(0);
+	pit_clockevent.cpumask = cpumask_of_cpu(smp_processor_id());
 	pit_clockevent.mult = div_sc(CLOCK_TICK_RATE, NSEC_PER_SEC, 32);
 	pit_clockevent.max_delta_ns =
 		clockevent_delta2ns(0x7FFF, &pit_clockevent);
-- 
1.4.4.4



