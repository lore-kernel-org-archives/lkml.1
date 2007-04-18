Return-Path: <linux-kernel-owner+w=401wt.eu-S1754226AbXDRTto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbXDRTto (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 15:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754241AbXDRTtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 15:49:43 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:56642 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225AbXDRTtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 15:49:42 -0400
X-AuditID: d80ac287-9beabbb000002c59-a9-462676558aaf 
Date: Wed, 18 Apr 2007 20:35:22 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <clameter@engr.sgi.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] fix OOM killing processes wrongly thought MPOL_BIND
Message-ID: <Pine.LNX.4.64.0704182022440.11100@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 18 Apr 2007 19:49:40.0829 (UTC) FILETIME=[B42D60D0:01C781F2]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I only have CONFIG_NUMA=y for build testing: surprised when trying a memhog
to see lots of other processes killed with "No available memory (MPOL_BIND)".
memhog is killed correctly once we initialize nodemask in constrained_alloc().

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
Perhaps appropriate for 2.6.20-stable too - regression since 2.6.19.

 mm/oom_kill.c |    2 ++
 1 file changed, 2 insertions(+)

--- 2.6.21-rc7/mm/oom_kill.c	2007-03-26 07:30:54.000000000 +0100
+++ linux/mm/oom_kill.c	2007-04-18 20:18:21.000000000 +0100
@@ -176,6 +176,8 @@ static inline int constrained_alloc(stru
 	struct zone **z;
 	nodemask_t nodes;
 	int node;
+
+	nodes_clear(nodes);
 	/* node has memory ? */
 	for_each_online_node(node)
 		if (NODE_DATA(node)->node_present_pages)
