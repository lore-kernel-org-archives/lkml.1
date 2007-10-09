Return-Path: <linux-kernel-owner+w=401wt.eu-S1754145AbXJIKCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbXJIKCd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 06:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbXJIKC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 06:02:26 -0400
Received: from cantor.suse.de ([195.135.220.2]:45291 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897AbXJIKCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 06:02:25 -0400
Date: Tue, 9 Oct 2007 12:02:24 +0200
From: Andi Kleen <ak@suse.de>
To: torvalds@osdl.org, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH for 2.6.23] Fix scheduler domain sysctl list
Message-ID: <20071009100224.GA22834@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo has this already fixed in sched-devel (but he also adds
more parameters here). Since the fix is very simple I think it should
be fixed for .23. Especially cache_nice_tries is useful to tune
because it is very magic and the current values are a little dubious.

----

Fix holes in the scheduler domain sysctl setup that prevented
reaching the last two parameters.

Also allocate array of the correct size.

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux-2.6.23-rc8-misc/kernel/sched.c
===================================================================
--- linux-2.6.23-rc8-misc.orig/kernel/sched.c
+++ linux-2.6.23-rc8-misc/kernel/sched.c
@@ -5224,7 +5224,7 @@ set_table_entry(struct ctl_table *entry,
 static struct ctl_table *
 sd_alloc_ctl_domain_table(struct sched_domain *sd)
 {
-	struct ctl_table *table = sd_alloc_ctl_entry(14);
+	struct ctl_table *table = sd_alloc_ctl_entry(11);
 
 	set_table_entry(&table[0], "min_interval", &sd->min_interval,
 		sizeof(long), 0644, proc_doulongvec_minmax);
@@ -5244,10 +5244,10 @@ sd_alloc_ctl_domain_table(struct sched_d
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
