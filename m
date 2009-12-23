Return-Path: <linux-kernel-owner+w=401wt.eu-S1753611AbZLWEPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611AbZLWEPO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 23:15:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbZLWEPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 23:15:12 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:51207 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbZLWEPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 23:15:10 -0500
Subject: [RFC][PATCH 13/14] Convert sh to read/update_persistent_clock
From: john stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org
In-Reply-To: <1261541643.3508.74.camel@localhost.localdomain>
References: <1261540762.3508.61.camel@localhost.localdomain>
	 <1261540826.3508.62.camel@localhost.localdomain>
	 <1261540902.3508.63.camel@localhost.localdomain>
	 <1261540988.3508.64.camel@localhost.localdomain>
	 <1261541054.3508.65.camel@localhost.localdomain>
	 <1261541130.3508.66.camel@localhost.localdomain>
	 <1261541188.3508.67.camel@localhost.localdomain>
	 <1261541286.3508.69.camel@localhost.localdomain>
	 <1261541342.3508.70.camel@localhost.localdomain>
	 <1261541415.3508.71.camel@localhost.localdomain>
	 <1261541491.3508.72.camel@localhost.localdomain>
	 <1261541567.3508.73.camel@localhost.localdomain>
	 <1261541643.3508.74.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Dec 2009 20:15:03 -0800
Message-ID: <1261541703.3508.75.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the sh architecture to use the generic
read_persistent_clock and update_persistent_clock interfaces, reducing
the amount of arch specific code we have to maintain, and allowing for
further cleanups in the future.

I have not built or tested this patch, so help from arch maintainers
would be appreciated.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 time.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)


Index: gettimeoffset/arch/sh/kernel/time.c
===================================================================
--- gettimeoffset.orig/arch/sh/kernel/time.c	2009-12-22 18:50:55.000000000 -0800
+++ gettimeoffset/arch/sh/kernel/time.c	2009-12-22 18:51:12.000000000 -0800
@@ -39,12 +39,12 @@ static int null_rtc_set_time(const time_
 void (*rtc_sh_get_time)(struct timespec *) = null_rtc_get_time;
 int (*rtc_sh_set_time)(const time_t) = null_rtc_set_time;
 
-#ifdef CONFIG_GENERIC_CMOS_UPDATE
 void read_persistent_clock(struct timespec *ts)
 {
 	rtc_sh_get_time(ts);
 }
 
+#ifdef CONFIG_GENERIC_CMOS_UPDATE
 int update_persistent_clock(struct timespec now)
 {
 	return rtc_sh_set_time(now.tv_sec);
@@ -113,9 +113,5 @@ void __init time_init(void)
 	hwblk_init();
 	clk_init();
 
-	rtc_sh_get_time(&xtime);
-	set_normalized_timespec(&wall_to_monotonic,
-				-xtime.tv_sec, -xtime.tv_nsec);
-
 	late_time_init = sh_late_time_init;
 }


