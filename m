Return-Path: <linux-kernel-owner+w=401wt.eu-S1755771AbXJ3LTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771AbXJ3LTq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 07:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752930AbXJ3LTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 07:19:39 -0400
Received: from miranda.se.axis.com ([193.13.178.8]:38250 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbXJ3LTi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 07:19:38 -0400
From: "Mikael Starvik" <mikael.starvik@axis.com>
To: "Jesper Nilsson" <Jesper.Nilsson@axis.com>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       "Mikael Starvik" <mikael.starvik@axis.com>,
       "Jesper Nilsson" <Jesper.Nilsson@axis.com>,
       <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 13/16] CRIS architecture: Correct compile errors
Date: Tue, 30 Oct 2007 12:19:28 +0100
Message-ID: <BFECAF9E178F144FAEF2BF4CE739C66804C4014E@exmail1.se.axis.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook, Build 10.0.6626
In-Reply-To: <BFECAF9E178F144FAEF2BF4CE739C6680549C7F1@exmail1.se.axis.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1896
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mikael Starvik <starvik@axis.com>

-----Original Message-----
From: Jesper Nilsson [mailto:jespern@axis.com] 
Sent: Tuesday, October 30, 2007 10:35 AM
To: Andrew Morton; Mikael Starvik; Jesper Nilsson;
linux-kernel@vger.kernel.org
Subject: [PATCH 13/16] CRIS architecture: Correct compile errors


- Remove debug print.
- Change #if to #ifdef to avoid compile time warning if CONFIG_PROFILING
  isn't set.
- Number of parameters to profile_tick has changed, drop the regs parameter.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>

---
 time.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff -urBb -X /h/jespern/.exclude_files
clean_linux-2.6.23/arch/cris/kernel/time.c
linux-2.6.23/arch/cris/kernel/time.c
--- clean_linux-2.6.23/arch/cris/kernel/time.c	2007-10-09
22:31:38.000000000 +0200
+++ linux-2.6.23/arch/cris/kernel/time.c	2007-10-22
13:37:20.000000000 +0200
@@ -171,10 +170,6 @@
 	mon = CMOS_READ(RTC_MONTH);
 	year = CMOS_READ(RTC_YEAR);
 
-	printk(KERN_DEBUG
-	       "rtc: sec 0x%x min 0x%x hour 0x%x day 0x%x mon 0x%x year
0x%x\n",
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

