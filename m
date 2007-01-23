Return-Path: <linux-kernel-owner+w=401wt.eu-S965564AbXAWWJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965564AbXAWWJe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 17:09:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965501AbXAWWBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 17:01:10 -0500
Received: from www.osadl.org ([213.239.205.134]:35881 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933160AbXAWWBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 17:01:05 -0500
Message-Id: <20070123211206.565559000@localhost.localdomain>
References: <20070123211159.178138000@localhost.localdomain>
Date: Tue, 23 Jan 2007 22:01:20 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       John Stultz <johnstul@us.ibm.com>,
       Arjan van de Veen <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [patch 24/46] hrtimers: namespace and enum cleanup vs. git-input
Content-Disposition: inline;
	filename=hrtimers-namespace-and-enum-cleanup-vs-git-input.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@osdl.org>

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/input/touchscreen/ads7846.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

Index: linux-2.6.20-rc4-mm1-bo/drivers/input/touchscreen/ads7846.c
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/drivers/input/touchscreen/ads7846.c
+++ linux-2.6.20-rc4-mm1-bo/drivers/input/touchscreen/ads7846.c
@@ -546,7 +546,7 @@ static void ads7846_rx(void *ads)
 			ts->spi->dev.bus_id, ts->tc.ignore, Rt);
 #endif
 		hrtimer_start(&ts->timer, ktime_set(0, TS_POLL_PERIOD),
-			      HRTIMER_REL);
+			      HRTIMER_MODE_REL);
 		return;
 	}
 
@@ -578,7 +578,8 @@ static void ads7846_rx(void *ads)
 #endif
 	}
 
-	hrtimer_start(&ts->timer, ktime_set(0, TS_POLL_PERIOD), HRTIMER_REL);
+	hrtimer_start(&ts->timer, ktime_set(0, TS_POLL_PERIOD),
+			HRTIMER_MODE_REL);
 }
 
 static int ads7846_debounce(void *ads, int data_idx, int *val)
@@ -667,7 +668,7 @@ static void ads7846_rx_val(void *ads)
 				status);
 }
 
-static int ads7846_timer(struct hrtimer *handle)
+static enum hrtimer_restart ads7846_timer(struct hrtimer *handle)
 {
 	struct ads7846	*ts = container_of(handle, struct ads7846, timer);
 	int		status = 0;
@@ -724,7 +725,7 @@ static irqreturn_t ads7846_irq(int irq, 
 			disable_irq(ts->spi->irq);
 			ts->pending = 1;
 			hrtimer_start(&ts->timer, ktime_set(0, TS_POLL_DELAY),
-					HRTIMER_REL);
+					HRTIMER_MODE_REL);
 		}
 	}
 	spin_unlock_irqrestore(&ts->lock, flags);
@@ -862,7 +863,7 @@ static int __devinit ads7846_probe(struc
 	ts->spi = spi;
 	ts->input = input_dev;
 
-	hrtimer_init(&ts->timer, CLOCK_MONOTONIC, HRTIMER_REL);
+	hrtimer_init(&ts->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	ts->timer.function = ads7846_timer;
 
 	spin_lock_init(&ts->lock);

--

