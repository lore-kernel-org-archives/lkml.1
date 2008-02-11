Return-Path: <linux-kernel-owner+w=401wt.eu-S1756828AbYBKOUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828AbYBKOUk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 09:20:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753789AbYBKOTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 09:19:34 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:33023 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172AbYBKOTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 09:19:32 -0500
Message-Id: <20080211141814.281584000@bull.net>
References: <20080211141646.948191000@bull.net>
User-Agent: quilt/0.45-1
Date: Mon, 11 Feb 2008 15:16:49 +0100
From: Nadia.Derbey@bull.net
To: linux-kernel@vger.kernel.org, y-goto@jp.fujitsu.com,
       akpm@linux-foundation.org
Cc: linux-mm@kvack.org, containers@lists.linux-foundation.org,
       matthltc@us.ibm.com, cmm@us.ibm.com,
       Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [PATCH 3/8] Defining the slab_memory_callback priority as a constant
Content-Disposition: inline; filename=ipc_slab_memory_callback_prio_to_const.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 03/08]

This is a trivial patch that defines the priority of slab_memory_callback in
the callback chain as a constant.
This is to prepare for next patch in the series.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>

---
 include/linux/memory.h |    6 ++++++
 mm/slub.c              |    2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

Index: linux-2.6.24-mm1/include/linux/memory.h
===================================================================
--- linux-2.6.24-mm1.orig/include/linux/memory.h	2008-02-07 13:40:35.000000000 +0100
+++ linux-2.6.24-mm1/include/linux/memory.h	2008-02-07 17:10:07.000000000 +0100
@@ -53,6 +53,12 @@ struct memory_notify {
 struct notifier_block;
 struct mem_section;
 
+/*
+ * Priorities for the hotplug memory callback routines (stored in decreasing
+ * order in the callback chain)
+ */
+#define SLAB_CALLBACK_PRI       1
+
 #ifndef CONFIG_MEMORY_HOTPLUG_SPARSE
 static inline int memory_dev_init(void)
 {
Index: linux-2.6.24-mm1/mm/slub.c
===================================================================
--- linux-2.6.24-mm1.orig/mm/slub.c	2008-02-07 13:40:46.000000000 +0100
+++ linux-2.6.24-mm1/mm/slub.c	2008-02-07 17:16:09.000000000 +0100
@@ -3001,7 +3001,7 @@ void __init kmem_cache_init(void)
 	kmalloc_caches[0].refcount = -1;
 	caches++;
 
-	hotplug_memory_notifier(slab_memory_callback, 1);
+	hotplug_memory_notifier(slab_memory_callback, SLAB_CALLBACK_PRI);
 #endif
 
 	/* Able to allocate the per node structures */

--
