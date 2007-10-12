Return-Path: <linux-kernel-owner+w=401wt.eu-S1761041AbXJLJgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761041AbXJLJgl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 05:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760680AbXJLJfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 05:35:39 -0400
Received: from sullivan.realtime.net ([205.238.132.226]:3593 "EHLO
	sullivan.realtime.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760644AbXJLJfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 05:35:38 -0400
Date: Fri, 12 Oct 2007 04:35:20 -0500 (CDT)
From: Milton Miller <miltonm@bga.com>
Subject: [PATCH] sched domain sysctl: sysctl tables can have no holes
In-Reply-To: <mm-sched-0@bga.com>
Message-Id: <mm-sched-5@bga.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The register_sysctl_table stops on the first entry without a
procname and ctl_name, so we need to fill in consecutive entries.

Signed-off-by: Milton Miller <miltonm@bga.com>

Index: kernel/kernel/sched.c
===================================================================
--- kernel.orig/kernel/sched.c	2007-10-12 03:59:07.000000000 -0500
+++ kernel/kernel/sched.c	2007-10-12 03:59:16.000000000 -0500
@@ -5315,7 +5315,7 @@ set_table_entry(struct ctl_table *entry,
 static struct ctl_table *
 sd_alloc_ctl_domain_table(struct sched_domain *sd)
 {
-	struct ctl_table *table = sd_alloc_ctl_entry(14);
+	struct ctl_table *table = sd_alloc_ctl_entry(12);
 
 	if (table == NULL)
 		return NULL;
@@ -5338,11 +5338,12 @@ sd_alloc_ctl_domain_table(struct sched_d
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
+	/* &table[11] is terminator */
 
 	return table;
 }
