Return-Path: <linux-kernel-owner+w=401wt.eu-S1763931AbXE2SEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763931AbXE2SEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 14:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753615AbXE2SEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 14:04:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:39416 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752857AbXE2SEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 14:04:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,589,1170662400"; 
   d="scan'208";a="91454316"
Date: Tue, 29 May 2007 11:01:13 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] Make net watchdog timers 1 sec jiffy aligned
Message-ID: <20070529180112.GC5411@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


round_jiffies for net dev watchdog timer.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Index: linux-2.6.22-rc-mm/net/sched/sch_generic.c
===================================================================
--- linux-2.6.22-rc-mm.orig/net/sched/sch_generic.c	2007-05-24 11:16:03.000000000 -0700
+++ linux-2.6.22-rc-mm/net/sched/sch_generic.c	2007-05-25 15:10:02.000000000 -0700
@@ -224,7 +224,8 @@
 	if (dev->tx_timeout) {
 		if (dev->watchdog_timeo <= 0)
 			dev->watchdog_timeo = 5*HZ;
-		if (!mod_timer(&dev->watchdog_timer, jiffies + dev->watchdog_timeo))
+		if (!mod_timer(&dev->watchdog_timer,
+			       round_jiffies(jiffies + dev->watchdog_timeo)))
 			dev_hold(dev);
 	}
 }
