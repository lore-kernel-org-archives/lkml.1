Return-Path: <linux-kernel-owner+w=401wt.eu-S1761145AbXJLJfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761145AbXJLJfz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 05:35:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759601AbXJLJfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 05:35:31 -0400
Received: from sullivan.realtime.net ([205.238.132.226]:3757 "EHLO
	sullivan.realtime.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080AbXJLJfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 05:35:30 -0400
Date: Fri, 12 Oct 2007 04:35:17 -0500 (CDT)
From: Milton Miller <miltonm@bga.com>
Subject: [PATCH] sched.c: use kcalloc
In-Reply-To: <mm-sched-0@bga.com>
Message-Id: <mm-sched-3@bga.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

kcalloc checks for n * sizeof(element) overflows and it zeros.

Signed-off-by: Milton Miller <miltonm@bga.com>


Index: kernel/kernel/sched.c
===================================================================
--- kernel.orig/kernel/sched.c	2007-10-12 03:58:35.000000000 -0500
+++ kernel/kernel/sched.c	2007-10-12 03:58:38.000000000 -0500
@@ -5283,10 +5283,9 @@ static struct ctl_table sd_ctl_root[] = 
 static struct ctl_table *sd_alloc_ctl_entry(int n)
 {
 	struct ctl_table *entry =
-		kmalloc(n * sizeof(struct ctl_table), GFP_KERNEL);
+		kcalloc(n, sizeof(struct ctl_table), GFP_KERNEL);
 
 	BUG_ON(!entry);
-	memset(entry, 0, n * sizeof(struct ctl_table));
 
 	return entry;
 }
@@ -6080,7 +6079,7 @@ static int build_sched_domains(const cpu
 	/*
 	 * Allocate the per-node list of sched groups
 	 */
-	sched_group_nodes = kzalloc(sizeof(struct sched_group *)*MAX_NUMNODES,
+	sched_group_nodes = kcalloc(MAX_NUMNODES, sizeof(struct sched_group *),
 					   GFP_KERNEL);
 	if (!sched_group_nodes) {
 		printk(KERN_WARNING "Can not alloc sched group node list\n");
