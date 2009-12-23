Return-Path: <linux-kernel-owner+w=401wt.eu-S1752220AbZLWEDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220AbZLWEDV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 23:03:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbZLWEDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 23:03:17 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:60186 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397AbZLWEDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 23:03:16 -0500
Subject: [RFC][PATCH 3/14] Convert avr32 to read/update_persistent_clock
From: john stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
In-Reply-To: <1261540902.3508.63.camel@localhost.localdomain>
References: <1261540762.3508.61.camel@localhost.localdomain>
	 <1261540826.3508.62.camel@localhost.localdomain>
	 <1261540902.3508.63.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Dec 2009 20:03:08 -0800
Message-ID: <1261540988.3508.64.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the avr32 architecture to use the generic
read_persistent_clock and update_persistent_clock interfaces, reducing
the amount of arch specific code we have to maintain, and allowing for
further cleanups in the future.

I have not built or tested this patch, so help from arch maintainers
would be appreciated.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 time.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: gettimeoffset/arch/avr32/kernel/time.c
===================================================================
--- gettimeoffset.orig/arch/avr32/kernel/time.c	2009-12-22 18:50:55.000000000 -0800
+++ gettimeoffset/arch/avr32/kernel/time.c	2009-12-22 18:51:09.000000000 -0800
@@ -110,17 +110,17 @@ static struct clock_event_device compara
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


