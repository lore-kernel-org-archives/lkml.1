Return-Path: <linux-kernel-owner+w=401wt.eu-S1754539AbYANP6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbYANP6q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 10:58:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751807AbYANP5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 10:57:52 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:43403 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbYANP5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 10:57:50 -0500
Message-Id: <20080114155602.575533000@bull.net>
References: <20080114155402.690906000@bull.net>
User-Agent: quilt/0.45-1
Date: Mon, 14 Jan 2008 16:54:05 +0100
From: Nadia.Derbey@bull.net
To: akmp@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, matthltc@us.ibm.com,
       Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [RFC PATCH 3/4] [RESEND] Defining the slab_memory_callback priority as a constant
Content-Disposition: inline; filename=ipc_slab_memory_callback_prio_to_const.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 03/04]

This is a trivial patch that defines the priority of slab_memory_callback in
the callback chain as a constant.
This is to prepare for next patch in the series.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>

---
 include/linux/memory.h |    6 ++++++
 mm/slub.c              |    2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

Index: linux-2.6.24-rc7/include/linux/memory.h
===================================================================
--- linux-2.6.24-rc7.orig/include/linux/memory.h	2008-01-11 14:08:41.000000000 +0100
+++ linux-2.6.24-rc7/include/linux/memory.h	2008-01-11 16:26:03.000000000 +0100
@@ -54,6 +54,12 @@ struct memory_notify {
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
Index: linux-2.6.24-rc7/mm/slub.c
===================================================================
--- linux-2.6.24-rc7.orig/mm/slub.c	2008-01-11 14:08:45.000000000 +0100
+++ linux-2.6.24-rc7/mm/slub.c	2008-01-11 16:27:11.000000000 +0100
@@ -2816,7 +2816,7 @@ void __init kmem_cache_init(void)
 	kmalloc_caches[0].refcount = -1;
 	caches++;
 
-	hotplug_memory_notifier(slab_memory_callback, 1);
+	hotplug_memory_notifier(slab_memory_callback, SLAB_CALLBACK_PRI);
 #endif
 
 	/* Able to allocate the per node structures */

--
