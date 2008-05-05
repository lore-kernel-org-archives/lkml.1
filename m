Return-Path: <linux-kernel-owner+w=401wt.eu-S1758622AbYEELAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758622AbYEELAJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 07:00:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754772AbYEEK7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 06:59:36 -0400
Received: from saeurebad.de ([85.214.36.134]:59708 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757360AbYEEK7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 06:59:35 -0400
X-Mailbox-Line: From hannes@symbol.fehenstaub.lan Mon May  5 12:08:46 2008
Message-Id: <20080505100846.142962623@symbol.fehenstaub.lan>
References: <20080505095938.326928514@symbol.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Mon, 05 May 2008 11:59:39 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: [rfc][patch 1/3] mm: Define NR_NODE_MEMBLKS unconditionally
Content-Disposition: inline; filename=nr_node_memblks.patch
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bootmem needs to work on contiguous memory block quantities rather
than whole nodes, for the latter may overlap.  So make this maxium
number and the resulting number of blocks per node available to
generic code like bootmem.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
---

Index: linux-2.6/include/linux/numa.h
===================================================================
--- linux-2.6.orig/include/linux/numa.h
+++ linux-2.6/include/linux/numa.h
@@ -1,13 +1,17 @@
 #ifndef _LINUX_NUMA_H
 #define _LINUX_NUMA_H
 
-
 #ifdef CONFIG_NODES_SHIFT
-#define NODES_SHIFT     CONFIG_NODES_SHIFT
+#define NODES_SHIFT		CONFIG_NODES_SHIFT
 #else
-#define NODES_SHIFT     0
+#define NODES_SHIFT		0
 #endif
 
-#define MAX_NUMNODES    (1 << NODES_SHIFT)
+#define MAX_NUMNODES		(1 << NODES_SHIFT)
+
+#ifndef NR_NODE_MEMBLKS
+#define NR_NODE_MEMBLKS		MAX_NUMNODES
+#endif
+#define NR_MEMBLKS_PER_NODE	(NR_NODE_MEMBLKS / MAX_NUMNODES)
 
 #endif /* _LINUX_NUMA_H */

-- 

