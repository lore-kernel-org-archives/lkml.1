Return-Path: <linux-kernel-owner+w=401wt.eu-S1753421AbXISDWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbXISDWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 23:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751540AbXISDWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 23:22:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:20902 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894AbXISDWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 23:22:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,271,1186383600"; 
   d="scan'208";a="298168761"
Subject: [Patch]some proc entries are missed in sched_domain sys_ctl debug
	code.
From: Zou Nan hai <nanhai.zou@intel.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>
Content-Type: text/plain
Organization: 
Message-Id: <1190171811.2583.11.camel@linux-znh>
Mime-Version: 1.0
X-Mailer: Ximian Evolution 1.2.2 (1.2.2-4) 
Date: 19 Sep 2007 11:16:51 +0800
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cache_nice_tries and flags entry do not appear in proc fs sched_domain directory,
because ctl_table entry is skipped.

This patch fix the issue.

Signed-off-by: Zou Nan hai <nanhai.zou@intel.com>

--- linux-2.6.23-rc6/kernel/sched.c	2007-09-18 23:47:07.000000000 -0400
+++ b/kernel/sched.c	2007-09-18 23:47:20.000000000 -0400
@@ -5304,7 +5304,7 @@ set_table_entry(struct ctl_table *entry,
 static struct ctl_table *
 sd_alloc_ctl_domain_table(struct sched_domain *sd)
 {
-	struct ctl_table *table = sd_alloc_ctl_entry(14);
+	struct ctl_table *table = sd_alloc_ctl_entry(12);
 
 	set_table_entry(&table[0], "min_interval", &sd->min_interval,
 		sizeof(long), 0644, proc_doulongvec_minmax);
@@ -5324,10 +5324,10 @@ sd_alloc_ctl_domain_table(struct sched_d
 		sizeof(int), 0644, proc_dointvec_minmax);
 	set_table_entry(&table[8], "imbalance_pct", &sd->imbalance_pct,
 		sizeof(int), 0644, proc_dointvec_minmax);
-	set_table_entry(&table[10], "cache_nice_tries",
+	set_table_entry(&table[9], "cache_nice_tries",
 		&sd->cache_nice_tries,
 		sizeof(int), 0644, proc_dointvec_minmax);
-	set_table_entry(&table[12], "flags", &sd->flags,
+	set_table_entry(&table[10], "flags", &sd->flags,
 		sizeof(int), 0644, proc_dointvec_minmax);
 
 	return table;
