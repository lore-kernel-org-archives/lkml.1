Return-Path: <linux-kernel-owner+w=401wt.eu-S1758502AbZBBWFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758502AbZBBWFq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 17:05:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753865AbZBBWFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 17:05:13 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49313 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755701AbZBBWFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 17:05:12 -0500
Date: Mon, 2 Feb 2009 23:05:10 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] [ARM] use __preempt_enable_no_resched in cpu_idle()
Message-ID: <20090202220510.GA2605@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

instead of preempt_enable_no_resched.  The only difference is that the
latter wails if preempt_count drops to zero.  This however is OK here as
schedule is called afterwards.  The same was done for x86 in
932e227146fbb26ea4688c126d0fd3953787f6a4.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
Hello,

this patch can be found in my repo at

	git://git.pengutronix.de/git/ukl/linux-2.6.git rt/rt-locks

as 7750516b5d0 basing on Steven's rt/rt-locks branch.

Best regards
Uwe

 arch/arm/kernel/process.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index d3ea6fa..8fbf03b 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -167,7 +167,7 @@ void cpu_idle(void)
 			idle();
 		leds_event(led_idle_end);
 		tick_nohz_restart_sched_tick();
-		preempt_enable_no_resched();
+		__preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
 	}
-- 
1.5.6.5


-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
