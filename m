Return-Path: <linux-kernel-owner+w=401wt.eu-S1753572AbZFOOHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572AbZFOOHt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 10:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752672AbZFOOHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 10:07:21 -0400
Received: from www.tglx.de ([62.245.132.106]:50201 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759754AbZFOOHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 10:07:20 -0400
Date: Mon, 15 Jun 2009 16:06:45 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] clockevents updates for 2.6.31
Message-ID: <alpine.LFD.2.00.0906151454510.2800@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-for-linus-clockevents git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-for-linus-clockevents

Thanks,

	tglx

------------------>
Dmitri Vorobiev (1):
      clockevents: tick_broadcast_device can become static

Magnus Damm (1):
      clockevent: export register_device and delta2ns


 kernel/time/clockevents.c    |    2 ++
 kernel/time/tick-broadcast.c |    2 +-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index d13be21..3948fa6 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -54,6 +54,7 @@ unsigned long clockevent_delta2ns(unsigned long latch,
 
 	return (unsigned long) clc;
 }
+EXPORT_SYMBOL_GPL(clockevent_delta2ns);
 
 /**
  * clockevents_set_mode - set the operating mode of a clock event device
@@ -187,6 +188,7 @@ void clockevents_register_device(struct clock_event_device *dev)
 
 	spin_unlock(&clockevents_lock);
 }
+EXPORT_SYMBOL_GPL(clockevents_register_device);
 
 /*
  * Noop handler when we shut down an event device
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 118a3b3..877dbed 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -27,7 +27,7 @@
  * timer stops in C3 state.
  */
 
-struct tick_device tick_broadcast_device;
+static struct tick_device tick_broadcast_device;
 /* FIXME: Use cpumask_var_t. */
 static DECLARE_BITMAP(tick_broadcast_mask, NR_CPUS);
 static DECLARE_BITMAP(tmpmask, NR_CPUS);
