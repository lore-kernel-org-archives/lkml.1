Return-Path: <linux-kernel-owner+w=401wt.eu-S1752211AbXDASRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211AbXDASRb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 14:17:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933794AbXDASQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 14:16:54 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:39897 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933795AbXDASQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 14:16:51 -0400
Date: Sun, 1 Apr 2007 20:15:20 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@osdl.org>
Subject: [PATCH 07/16] kconfig-dynamic-frequency.diff
In-Reply-To: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704012006060.12316@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Make HZ fully configurable through menuconfig.

Already posted at http://lkml.org/lkml/2006/6/18/111

Signed-off-by: Jan Engelhardt
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk> (http://lkml.org/lkml/2006/11/8/307)
Cc: Sam Ravnborg <sam@ravnborg.org>

 Kconfig.hz |   70 +++++++++++++++++++++++--------------------------------------
 1 file changed, 27 insertions(+), 43 deletions(-)

Index: linux-2.6.21-rc5/kernel/Kconfig.hz
===================================================================
--- linux-2.6.21-rc5.orig/kernel/Kconfig.hz
+++ linux-2.6.21-rc5/kernel/Kconfig.hz
@@ -2,50 +2,34 @@
 # Timer Interrupt Frequency Configuration
 #
 
-choice
-	prompt "Timer frequency"
-	default HZ_250
-	help
-	 Allows the configuration of the timer frequency. It is customary
-	 to have the timer interrupt run at 1000 Hz but 100 Hz may be more
-	 beneficial for servers and NUMA systems that do not need to have
-	 a fast response for user interaction and that may experience bus
-	 contention and cacheline bounces as a result of timer interrupts.
-	 Note that the timer interrupt occurs on each processor in an SMP
-	 environment leading to NR_CPUS * HZ number of timer interrupts
-	 per second.
-
-
-	config HZ_100
-		bool "100 HZ"
-	help
-	  100 Hz is a typical choice for servers, SMP and NUMA systems
-	  with lots of processors that may show reduced performance if
-	  too many timer interrupts are occurring.
-
-	config HZ_250
-		bool "250 HZ"
-	help
-	 250 Hz is a good compromise choice allowing server performance
-	 while also showing good interactive responsiveness even
-	 on SMP and NUMA systems. If you are going to be using NTSC video
-	 or multimedia, selected 300Hz instead.
-
-	config HZ_300
-		bool "300 HZ"
-	help
-	 300 Hz is a good compromise choice allowing server performance
-	 while also showing good interactive responsiveness even
-	 on SMP and NUMA systems and exactly dividing by both PAL and
-	 NTSC frame rates for video and multimedia work.
-
-	config HZ_1000
-		bool "1000 HZ"
-	help
-	 1000 Hz is the preferred choice for desktop systems and other
-	 systems requiring fast interactive responses to events.
+config HZ
+    int "Timer frequency"
+    default 100
+    ---help---
+        Allows the configuration of the timer frequency. It is customary
+        to have the timer interrupt run at 1000 Hz but 100 Hz may be more
+        beneficial for servers and NUMA systems that do not need to have
+        a fast response for user interaction and that may experience bus
+        contention and cacheline bounces as a result of timer interrupts.
+        Note that the timer interrupt occurs on each processor in an SMP
+        environment leading to NR_CPUS * HZ number of timer interrupts
+        per second.
+
+        100 Hz is a typical choice for servers, SMP and NUMA systems
+        with lots of processors that may show reduced performance if
+        too many timer interrupts are occurring.
+
+        250 Hz is a good compromise choice allowing server performance
+        while also showing good interactive responsiveness even on SMP
+        and NUMA systems.
+
+        300 Hz is a good compromise choice allowing server performance
+        while also showing good interactive responsiveness even
+        on SMP and NUMA systems and exactly dividing by both PAL and
+        NTSC frame rates for video and multimedia work.
 
-endchoice
+        1000 Hz is the preferred choice for desktop systems and other
+        systems requiring fast interactive responses to events.
 
 config HZ
 	int
#<EOF>
