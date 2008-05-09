Return-Path: <linux-kernel-owner+w=401wt.eu-S1764999AbYEIQW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764999AbYEIQW0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 12:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764682AbYEIQWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 12:22:01 -0400
Received: from saeurebad.de ([85.214.36.134]:37352 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764667AbYEIQWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 12:22:00 -0400
X-Mailbox-Line: From hannes@saeurebad.de Fri May  9 17:22:45 2008
Message-Id: <20080509152245.510691866@saeurebad.de>
References: <20080509151713.939253437@saeurebad.de>
User-Agent: quilt/0.46-1
Date: Fri, 09 May 2008 17:17:14 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 1/3] mm: Make NR_NODE_MEMBLKS global
Content-Disposition: inline; filename=global-NR_NODE_MEMBLKS.patch
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bootmem needs to work on contiguous memory block quantities rather
than whole nodes.  So make the maxium number of blocks and the
resulting number of blocks per node available to generic code like
bootmem.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
---

 include/linux/numa.h |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/include/linux/numa.h
+++ b/include/linux/numa.h
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

