Return-Path: <linux-kernel-owner+w=401wt.eu-S1758032AbXERKkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032AbXERKkP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 06:40:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754848AbXERKkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 06:40:05 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:43940 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754335AbXERKkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 06:40:04 -0400
To: akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org
Subject: [patch] fix unused setup_nr_node_ids
Message-Id: <E1Hozre-0003rZ-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 18 May 2007 12:39:14 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is now the only (!) compiler warning I get in my UML build :)

----
From: Miklos Szeredi <mszeredi@suse.cz>

mm/page_alloc.c:931: warning: 'setup_nr_node_ids' defined but not used

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/mm/page_alloc.c
===================================================================
--- linux.orig/mm/page_alloc.c	2007-04-26 13:07:11.000000000 +0200
+++ linux/mm/page_alloc.c	2007-04-26 13:07:12.000000000 +0200
@@ -914,7 +914,10 @@ static int rmqueue_bulk(struct zone *zon
 #if MAX_NUMNODES > 1
 int nr_node_ids __read_mostly = MAX_NUMNODES;
 EXPORT_SYMBOL(nr_node_ids);
+#endif
 
+#ifdef CONFIG_ARCH_POPULATES_NODE_MAP
+#if MAX_NUMNODES > 1
 /*
  * Figure out the number of possible node ids.
  */
@@ -930,6 +933,7 @@ static void __init setup_nr_node_ids(voi
 #else
 static void __init setup_nr_node_ids(void) {}
 #endif
+#endif
 
 #ifdef CONFIG_NUMA
 /*
Index: linux/drivers/base/core.c
