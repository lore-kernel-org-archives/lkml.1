Return-Path: <linux-kernel-owner+w=401wt.eu-S1755478AbZKTTXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478AbZKTTXv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 14:23:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754067AbZKTTXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 14:23:50 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52737 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928AbZKTTXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 14:23:49 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Luming Yu <luming.yu@gmail.com>
Subject: [PATCH 2/2] clockevents: assert min_delta_ns being increased in error path
Date: Fri, 20 Nov 2009 20:23:40 +0100
Message-Id: <1258745020-28060-2-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1258745020-28060-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1258745020-28060-1-git-send-email-u.kleine-koenig@pengutronix.de>
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

tick_dev_program_event failed to increase min_delta_ns if the initial
value was 1.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Luming Yu <luming.yu@gmail.com>
---
 kernel/time/tick-oneshot.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/time/tick-oneshot.c b/kernel/time/tick-oneshot.c
index 2dd23c3..c3712c4 100644
--- a/kernel/time/tick-oneshot.c
+++ b/kernel/time/tick-oneshot.c
@@ -44,7 +44,7 @@ int tick_dev_program_event(struct clock_event_device *dev, ktime_t expires,
 		 */
 		if (++i > 2) {
 			/* Increase the min. delta and try again */
-			if (!dev->min_delta_ns)
+			if (dev->min_delta_ns <= 1)
 				dev->min_delta_ns = 5000;
 			else
 				dev->min_delta_ns += dev->min_delta_ns >> 1;
-- 
1.6.5.2

