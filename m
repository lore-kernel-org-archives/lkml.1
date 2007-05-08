Return-Path: <linux-kernel-owner+w=401wt.eu-S967481AbXEHMGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967481AbXEHMGJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 08:06:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967405AbXEHMGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 08:06:07 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46976 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967453AbXEHMFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 08:05:55 -0400
Date: Tue, 8 May 2007 21:04:08 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, Lee.Schermerhorn@hp.com,
       clameter@sgi.com, akpm@linux-foundation.org, ak@suse.de,
       jbarnes@virtuousgeek.org
Subject: Re: [PATCH] change zonelist order v5 [4/3] compile fix.....
Message-Id: <20070508210408.50cafc47.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070508201401.8f78ec37.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070508201401.8f78ec37.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm very sorry for missing this fix for non-NUMA arch...
I'll repost the whole set if necessary....
-Kame

Compile-fix...

Signed-Off-By: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Index: linux-2.6.21-mm1/mm/page_alloc.c
===================================================================
--- linux-2.6.21-mm1.orig/mm/page_alloc.c
+++ linux-2.6.21-mm1/mm/page_alloc.c
@@ -2321,6 +2321,7 @@ static void build_zonelists(pg_data_t *p
 	prev_node = local_node;
 	nodes_clear(used_mask);
 
+	memset(node_load, 0, sizeof(node_load));
 	memset(node_order, 0, sizeof(node_order));
 	j = 0;
 
@@ -2455,7 +2456,6 @@ void build_all_zonelists(void)
 		__build_all_zonelists(&order);
 		cpuset_init_current_mems_allowed();
 	} else {
-		memset(node_load, 0, sizeof(node_load));
 		/* we have to stop all cpus to guaranntee there is no user
 		   of zonelist */
 		stop_machine_run(__build_all_zonelists, &order, NR_CPUS);

