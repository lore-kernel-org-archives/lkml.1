Return-Path: <linux-kernel-owner+w=401wt.eu-S1763471AbXE2SDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763471AbXE2SDU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 14:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbXE2SDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 14:03:13 -0400
Received: from mga03.intel.com ([143.182.124.21]:16040 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752357AbXE2SDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 14:03:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,589,1170662400"; 
   d="scan'208";a="233222050"
Date: Tue, 29 May 2007 10:59:51 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] Make page-writeback timers 1 sec jiffy aligned
Message-ID: <20070529175951.GB5411@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



timer round_jiffies in page-writeback.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Index: linux-2.6.22-rc-mm/mm/page-writeback.c
===================================================================
--- linux-2.6.22-rc-mm.orig/mm/page-writeback.c	2007-05-25 10:49:11.000000000 -0700
+++ linux-2.6.22-rc-mm/mm/page-writeback.c	2007-05-25 10:49:29.000000000 -0700
@@ -469,7 +469,7 @@
 	if (time_before(next_jif, jiffies + HZ))
 		next_jif = jiffies + HZ;
 	if (dirty_writeback_interval)
-		mod_timer(&wb_timer, next_jif);
+		mod_timer(&wb_timer, round_jiffies(next_jif));
 }
 
 /*
@@ -481,7 +481,7 @@
 	proc_dointvec_userhz_jiffies(table, write, file, buffer, length, ppos);
 	if (dirty_writeback_interval) {
 		mod_timer(&wb_timer,
-			jiffies + dirty_writeback_interval);
+			round_jiffies(jiffies + dirty_writeback_interval));
 		} else {
 		del_timer(&wb_timer);
 	}
@@ -491,7 +491,8 @@
 static void wb_timer_fn(unsigned long unused)
 {
 	if (pdflush_operation(wb_kupdate, 0) < 0)
-		mod_timer(&wb_timer, jiffies + HZ); /* delay 1 second */
+		mod_timer(&wb_timer, round_jiffies(jiffies + HZ));
+		/* delay 1 second */
 }
 
 static void laptop_flush(unsigned long unused)
@@ -511,7 +512,7 @@
  */
 void laptop_io_completion(void)
 {
-	mod_timer(&laptop_mode_wb_timer, jiffies + laptop_mode);
+	mod_timer(&laptop_mode_wb_timer, round_jiffies(jiffies + laptop_mode));
 }
 
 /*
@@ -582,7 +583,7 @@
  */
 void __init page_writeback_init(void)
 {
-	mod_timer(&wb_timer, jiffies + dirty_writeback_interval);
+	mod_timer(&wb_timer, round_jiffies(jiffies + dirty_writeback_interval));
 	writeback_set_ratelimit();
 	register_cpu_notifier(&ratelimit_nb);
 }
