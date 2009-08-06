Return-Path: <linux-kernel-owner+w=401wt.eu-S1756358AbZHFRGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358AbZHFRGP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 13:06:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756319AbZHFRGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 13:06:14 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:59582 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756321AbZHFRGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 13:06:13 -0400
From: Subrata Modak <subrata@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       Subrata Modak <subrata@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Date: Thu, 06 Aug 2009 22:36:00 +0530
Message-Id: <20090806170600.32631.77680.sendpatchset@subratamodak.linux.ibm.com>
Subject: [PATCH] Address Sparse Static Warning inside kernel/fork.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

The patch below fixes the following SPARSE warning:
kernel/fork.c:81:5: warning: symbol 'max_threads' was not declared. Should it be static?
kernel/fork.c:171:13: warning: symbol 'fork_init' was not declared. Should it be static?

Signed-off-by: Subrata Modak<subrata@linux.vnet.ibm.com>

To: Ingo Molnar <mingo@elte.hu>,
Cc: LKML <linux-kernel@vger.kernel.org>,
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
Cc: Sachin P Sant <sachinp@linux.vnet.ibm.com>,
---

--- a/kernel/fork.c	2009-08-05 12:00:51.000000000 +0530
+++ b/kernel/fork.c	2009-08-06 22:26:30.000000000 +0530
@@ -78,7 +78,7 @@
 unsigned long total_forks;	/* Handle normal Linux uptimes. */
 int nr_threads; 		/* The idle threads do not count.. */
 
-int max_threads;		/* tunable limit on nr_threads */
+static int max_threads;		/* tunable limit on nr_threads */
 
 DEFINE_PER_CPU(unsigned long, process_counts) = 0;
 
@@ -168,7 +168,7 @@ void __put_task_struct(struct task_struc
 #define arch_task_cache_init()
 #endif
 
-void __init fork_init(unsigned long mempages)
+static void __init fork_init(unsigned long mempages)
 {
 #ifndef __HAVE_ARCH_TASK_STRUCT_ALLOCATOR
 #ifndef ARCH_MIN_TASKALIGN

Regards--
Subrata

