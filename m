Return-Path: <linux-kernel-owner+w=401wt.eu-S1763892AbZEHUk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763892AbZEHUk1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 16:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758170AbZEHUkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 16:40:11 -0400
Received: from ppp121-45-82-25.lns10.adl6.internode.on.net ([121.45.82.25]:52313
	"EHLO homer.shelbyville.oz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758150AbZEHUkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 16:40:10 -0400
X-Greylist: delayed 2116 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 May 2009 16:40:09 EDT
Date: Sat, 9 May 2009 05:34:44 +0930
From: Ron <ron@debian.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: [PATCH] fix for sched_clock() when using jiffies
Message-ID: <20090508200444.GA22132@homer.shelbyville.oz>
References: <20081126150645.GA28153@homer.shelbyville.oz> <1227712598.4454.199.camel@twins> <20081126153152.GB28153@homer.shelbyville.oz> <20081128144039.GG28138@elte.hu> <20090508132449.GV5417@homer.shelbyville.oz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090508132449.GV5417@homer.shelbyville.oz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ron@debian.org
X-SA-Exim-Scanned: No (on homer.shelbyville.oz); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
Account for the initial offset to the jiffy count.

Signed-off-by: Ron Lee <ron@debian.org>

---
 kernel/sched_clock.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_clock.c b/kernel/sched_clock.c
index a0b0852..a1567b1 100644
--- a/kernel/sched_clock.c
+++ b/kernel/sched_clock.c
@@ -37,7 +37,8 @@
  */
 unsigned long long __attribute__((weak)) sched_clock(void)
 {
-	return (unsigned long long)jiffies * (NSEC_PER_SEC / HZ);
+	return (unsigned long long)(jiffies - INITIAL_JIFFIES)
+					* (NSEC_PER_SEC / HZ);
 }
 
 static __read_mostly int sched_clock_running;
-- 
1.6.1.3

