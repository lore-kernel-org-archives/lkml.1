Return-Path: <linux-kernel-owner+w=401wt.eu-S1752654AbZLWEIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbZLWEIN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 23:08:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbZLWEIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 23:08:12 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:50083 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908AbZLWEIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 23:08:11 -0500
Subject: [RFC][PATCH 7/14] Convert h8300 to read/update_persistent_clock
From: john stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
In-Reply-To: <1261541188.3508.67.camel@localhost.localdomain>
References: <1261540762.3508.61.camel@localhost.localdomain>
	 <1261540826.3508.62.camel@localhost.localdomain>
	 <1261540902.3508.63.camel@localhost.localdomain>
	 <1261540988.3508.64.camel@localhost.localdomain>
	 <1261541054.3508.65.camel@localhost.localdomain>
	 <1261541130.3508.66.camel@localhost.localdomain>
	 <1261541188.3508.67.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Dec 2009 20:08:06 -0800
Message-ID: <1261541286.3508.69.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the h8300  architecture to use the generic
read_persistent_clock and update_persistent_clock interfaces, reducing
the amount of arch specific code we have to maintain, and allowing for
further cleanups in the future.

I have not built or tested this patch, so help from arch maintainers
would be appreciated.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
time.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

Index: gettimeoffset/arch/h8300/kernel/time.c
===================================================================
--- gettimeoffset.orig/arch/h8300/kernel/time.c	2009-12-22 18:50:55.000000000 -0800
+++ gettimeoffset/arch/h8300/kernel/time.c	2009-12-22 18:51:08.000000000 -0800
@@ -41,7 +41,7 @@ void h8300_timer_tick(void)
 	update_process_times(user_mode(get_irq_regs()));
 }
 
-void __init time_init(void)
+void read_persistent_clock(struct timespec *ts)
 {
 	unsigned int year, mon, day, hour, min, sec;
 
@@ -56,8 +56,12 @@ void __init time_init(void)
 #endif
 	if ((year += 1900) < 1970)
 		year += 100;
-	xtime.tv_sec = mktime(year, mon, day, hour, min, sec);
-	xtime.tv_nsec = 0;
+	ts->tv_sec = mktime(year, mon, day, hour, min, sec);
+	ts->tv_nsec = 0;
+}
+
+void __init time_init(void)
+{
 
 	h8300_timer_setup();
 }


