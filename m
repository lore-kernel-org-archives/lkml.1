Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620Ab0CCLFz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 06:05:55 -0500
Received: from mga05.intel.com ([192.55.52.89]:61647 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752322Ab0CCLFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 06:05:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,573,1262592000"; 
   d="scan'208";a="545630862"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH] x86/mrst: match clocksource prototype change
Date: Tue,  2 Mar 2010 20:58:23 -0800
Message-Id: <1267592303-7641-1-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function prototype in clocksource.resume has been changed by commit 17622339.
This patch makes the APB timer resume function match with the new prototype,
otherwise GCC would complain incompatible pointer assignment.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 arch/x86/kernel/apb_timer.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apb_timer.c b/arch/x86/kernel/apb_timer.c
index 83a345b..1232fe7 100644
--- a/arch/x86/kernel/apb_timer.c
+++ b/arch/x86/kernel/apb_timer.c
@@ -69,7 +69,7 @@ static void apbt_set_mode(enum clock_event_mode mode,
 static int apbt_next_event(unsigned long delta,
                           struct clock_event_device *evt);
 static cycle_t apbt_read_clocksource(struct clocksource *cs);
-static void apbt_restart_clocksource(void);
+static void apbt_restart_clocksource(struct clocksource *cs);
 
 struct apbt_dev {
        struct clock_event_device       evt;
@@ -248,7 +248,7 @@ static irqreturn_t apbt_interrupt_handler(int irq, void *data)
        return IRQ_HANDLED;
 }
 
-static void apbt_restart_clocksource(void)
+static void apbt_restart_clocksource(struct clocksource *cs)
 {
        apbt_start_counter(phy_cs_timer_id);
 }
-- 
1.5.6.5

