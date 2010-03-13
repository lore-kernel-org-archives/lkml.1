Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935192Ab0CMAZX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:25:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:46493 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935069Ab0CMAVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:21:12 -0500
Date: Sat, 13 Mar 2010 00:20:22 GMT
From: tip-bot for John Stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       akpm@linux-foundation.org, johnstul@us.ibm.com, tglx@linutronix.de,
       hskinnemoen@atmel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, akpm@linux-foundation.org, tglx@linutronix.de,
       hskinnemoen@atmel.com
In-Reply-To: <1267675049-12337-7-git-send-email-johnstul@us.ibm.com>
References: <1267675049-12337-7-git-send-email-johnstul@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/cleanup] avr32: Convert avr32 to use read/update_persistent_clock
Message-ID: <tip-e2032a4a7237e97cd2ee36e2d806c5742ace189f@git.kernel.org>
Git-Commit-ID: e2032a4a7237e97cd2ee36e2d806c5742ace189f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 13 Mar 2010 00:20:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e2032a4a7237e97cd2ee36e2d806c5742ace189f
Gitweb:     http://git.kernel.org/tip/e2032a4a7237e97cd2ee36e2d806c5742ace189f
Author:     John Stultz <johnstul@us.ibm.com>
AuthorDate: Wed, 3 Mar 2010 19:57:21 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 13 Mar 2010 01:14:10 +0100

avr32: Convert avr32 to use read/update_persistent_clock

This patch converts the avr32 architecture to use the generic
read_persistent_clock and update_persistent_clock interfaces, reducing
the amount of arch specific code we have to maintain, and allowing for
further cleanups in the future.

I have not built or tested this patch, so help from arch maintainers
would be appreciated.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <1267675049-12337-7-git-send-email-johnstul@us.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
