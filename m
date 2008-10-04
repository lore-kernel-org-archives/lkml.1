Return-Path: <linux-kernel-owner+w=401wt.eu-S1753974AbYJDO4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbYJDO4d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 10:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753069AbYJDO4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 10:56:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51250 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752935AbYJDO4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 10:56:24 -0400
Date: Sat, 4 Oct 2008 16:56:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [git pull] timers fixes
Message-ID: <20081004145618.GA28623@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus

 Thanks,

	Ingo

------------------>
Thomas Gleixner (1):
      clockevents: check broadcast tick device not the clock events device


 kernel/time/tick-broadcast.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index bd70345..cb01cd8 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -235,7 +235,8 @@ static void tick_do_broadcast_on_off(void *why)
 	case CLOCK_EVT_NOTIFY_BROADCAST_FORCE:
 		if (!cpu_isset(cpu, tick_broadcast_mask)) {
 			cpu_set(cpu, tick_broadcast_mask);
-			if (bc->mode == TICKDEV_MODE_PERIODIC)
+			if (tick_broadcast_device.mode ==
+			    TICKDEV_MODE_PERIODIC)
 				clockevents_shutdown(dev);
 		}
 		if (*reason == CLOCK_EVT_NOTIFY_BROADCAST_FORCE)
@@ -245,7 +246,8 @@ static void tick_do_broadcast_on_off(void *why)
 		if (!tick_broadcast_force &&
 		    cpu_isset(cpu, tick_broadcast_mask)) {
 			cpu_clear(cpu, tick_broadcast_mask);
-			if (bc->mode == TICKDEV_MODE_PERIODIC)
+			if (tick_broadcast_device.mode ==
+			    TICKDEV_MODE_PERIODIC)
 				tick_setup_periodic(dev, 0);
 		}
 		break;
