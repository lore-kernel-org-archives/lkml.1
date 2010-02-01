Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab0BAQVX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 11:21:23 -0500
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:43312 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623Ab0BAQVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 11:21:22 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: stable@kernel.org, gregkh@suse.de, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: [PATCH v2 -stable 2.6.32.7] clocksource: fix compilation if no GENERIC_TIME
Date: Mon,  1 Feb 2010 18:24:58 +0200
Message-Id: <1265041498-2434-1-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit a9238ce3bb0fda6e760780b702c6cbd3793087d3 broke compilation on
platforms that do not implement GENERIC_TIME (e.g. iop32x):

  kernel/time/clocksource.c: In function 'clocksource_register':
  kernel/time/clocksource.c:556: error: implicit declaration of function 'clocksource_max_deferment'

Provide the implementation of clocksource_max_deferment() also for
such platforms.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: stable <stable@kernel.org>
---

v2: Instead of adding a dummy function, just move the #ifdef. This
is actually the same change that was included in the upstream commit
a362c638bdf052bf424bce7645d39b101090f6ba.

 kernel/time/clocksource.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 5155dc3..ecc7adb 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -413,8 +413,6 @@ void clocksource_touch_watchdog(void)
 	clocksource_resume_watchdog();
 }
 
-#ifdef CONFIG_GENERIC_TIME
-
 /**
  * clocksource_max_deferment - Returns max time the clocksource can be deferred
  * @cs:         Pointer to clocksource
@@ -456,6 +454,8 @@ static u64 clocksource_max_deferment(struct clocksource *cs)
 	return max_nsecs - (max_nsecs >> 5);
 }
 
+#ifdef CONFIG_GENERIC_TIME
+
 /**
  * clocksource_select - Select the best clocksource available
  *
-- 
1.5.6.5

