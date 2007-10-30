Return-Path: <linux-kernel-owner+w=401wt.eu-S1758604AbXJ3Jg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758604AbXJ3Jg0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 05:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758448AbXJ3Je6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 05:34:58 -0400
Received: from nic2.axis.se ([193.13.178.10]:39933 "EHLO krynn.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757479AbXJ3Je5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 05:34:57 -0400
Date: Tue, 30 Oct 2007 10:34:46 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 13/16] CRIS architecture: Correct compile errors
Message-ID: <20071030093446.GP11960@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

- Remove debug print.
- Change #if to #ifdef to avoid compile time warning if CONFIG_PROFILING
  isn't set.
- Number of parameters to profile_tick has changed, drop the regs parameter.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>

---
 time.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff -urBb -X /h/jespern/.exclude_files clean_linux-2.6.23/arch/cris/kernel/time.c linux-2.6.23/arch/cris/kernel/time.c
--- clean_linux-2.6.23/arch/cris/kernel/time.c	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.23/arch/cris/kernel/time.c	2007-10-22 13:37:20.000000000 +0200
@@ -171,10 +170,6 @@
 	mon = CMOS_READ(RTC_MONTH);
 	year = CMOS_READ(RTC_YEAR);
 
-	printk(KERN_DEBUG
-	       "rtc: sec 0x%x min 0x%x hour 0x%x day 0x%x mon 0x%x year 0x%x\n",
-	       sec, min, hour, day, mon, year);
-
 	BCD_TO_BIN(sec);
 	BCD_TO_BIN(min);
 	BCD_TO_BIN(hour);
@@ -207,12 +202,12 @@
 cris_do_profile(struct pt_regs* regs)
 {
 
-#if CONFIG_SYSTEM_PROFILER
+#ifdef CONFIG_SYSTEM_PROFILER
         cris_profile_sample(regs);
 #endif
 
-#if CONFIG_PROFILING
-        profile_tick(CPU_PROFILING, regs);
+#ifdef CONFIG_PROFILING
+        profile_tick(CPU_PROFILING);
 #endif
 }
 

/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
