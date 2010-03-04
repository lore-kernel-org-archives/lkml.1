Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab0CDD6Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 22:58:16 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:44895 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057Ab0CDD5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 22:57:44 -0500
From: John Stultz <johnstul@us.ibm.com>
To: "	lkml" <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 06/14] avr32: Convert avr32 to use read/update_persistent_clock
Date: Wed,  3 Mar 2010 19:57:21 -0800
Message-Id: <1267675049-12337-7-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1267675049-12337-6-git-send-email-johnstul@us.ibm.com>
References: <1267675049-12337-1-git-send-email-johnstul@us.ibm.com>
 <1267675049-12337-2-git-send-email-johnstul@us.ibm.com>
 <1267675049-12337-3-git-send-email-johnstul@us.ibm.com>
 <1267675049-12337-4-git-send-email-johnstul@us.ibm.com>
 <1267675049-12337-5-git-send-email-johnstul@us.ibm.com>
 <1267675049-12337-6-git-send-email-johnstul@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the avr32 architecture to use the generic read_persistent_clock and update_persistent_clock interfaces, reducing the amount of arch specific code we have to maintain, and allowing for further cleanups in the future.

I have not built or tested this patch, so help from arch maintainers would be appreciated.

Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 arch/avr32/kernel/time.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/avr32/kernel/time.c b/arch/avr32/kernel/time.c
index f27aa3b..a047d69 100644
--- a/arch/avr32/kernel/time.c
+++ b/arch/avr32/kernel/time.c
@@ -110,17 +110,17 @@ static struct clock_event_device comparator = {
 	.set_mode	= comparator_mode,
 };
 
+void read_persistent_clock(struct timespec *ts)
+{
+	ts->tv.sec = mktime(2007, 1, 1, 0, 0, 0);
+	ts->tv_nsec = 0;
+}
+
 void __init time_init(void)
 {
 	unsigned long counter_hz;
 	int ret;
 
-	xtime.tv_sec = mktime(2007, 1, 1, 0, 0, 0);
-	xtime.tv_nsec = 0;
-
-	set_normalized_timespec(&wall_to_monotonic,
-				-xtime.tv_sec, -xtime.tv_nsec);
-
 	/* figure rate for counter */
 	counter_hz = clk_get_rate(boot_cpu_data.clk);
 	counter.mult = clocksource_hz2mult(counter_hz, counter.shift);
-- 
1.6.0.4

