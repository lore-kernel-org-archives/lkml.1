Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932928Ab0BPPnr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 10:43:47 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52554 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932892Ab0BPPno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 10:43:44 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] timer: print function name for timer callbacks modifying preemption count
Date: Tue, 16 Feb 2010 16:43:25 +0100
Message-Id: <1266335005-22780-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.6.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A function scheduled with a timer must not exit with a different preempt
count than it was entered.
To make helping users running into the corresponding BUG() easier also
print the name of the bad function not only its address.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 kernel/timer.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index c61a794..ef9a4db 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1027,10 +1027,10 @@ static inline void __run_timers(struct tvec_base *base)
 				lock_map_release(&lockdep_map);
 
 				if (preempt_count != preempt_count()) {
-					printk(KERN_ERR "huh, entered %p "
+					printk(KERN_ERR "huh, entered %p (%pF)"
 					       "with preempt_count %08x, exited"
 					       " with %08x?\n",
-					       fn, preempt_count,
+					       fn, fn, preempt_count,
 					       preempt_count());
 					BUG();
 				}
-- 
1.6.6.2

