Return-Path: <linux-kernel-owner+w=401wt.eu-S1763969AbXE2SBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763969AbXE2SBy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 14:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757666AbXE2SBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 14:01:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:44066 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755761AbXE2SBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 14:01:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,589,1170662400"; 
   d="scan'208";a="248465285"
Date: Tue, 29 May 2007 10:58:21 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] Make usb-autosuspend timer 1 sec jiffy aligned
Message-ID: <20070529175821.GA5411@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Below are a bunch of random timers, that were active on my system,
that can better be round_jiffies() aligned.

I guess we need a audit of all timer usages atleast in kernel-core.

This patch:

Make usb autosuspend timers 1sec jiffy aligned.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Index: linux-2.6.22-rc-mm/drivers/usb/core/driver.c
===================================================================
--- linux-2.6.22-rc-mm.orig/drivers/usb/core/driver.c	2007-05-24 11:16:00.000000000 -0700
+++ linux-2.6.22-rc-mm/drivers/usb/core/driver.c	2007-05-25 10:00:50.000000000 -0700
@@ -974,7 +974,7 @@
 			 * or for the past.
 			 */
 			queue_delayed_work(ksuspend_usb_wq, &udev->autosuspend,
-					suspend_time - jiffies);
+				round_jiffies_relative(suspend_time - jiffies));
 			}
 		return -EAGAIN;
 	}
