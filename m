Return-Path: <linux-kernel-owner+w=401wt.eu-S1757288AbYCQCBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288AbYCQCBQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 22:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755940AbYCQB61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 21:58:27 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:45309 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769AbYCQB6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 21:58:24 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080317258.659191058@firstfloor.org>
In-Reply-To: <20080317258.659191058@firstfloor.org>
To: linux-kernel@vger.kernel.org, pj@sgi.com, linux-mm@kvack.org,
       nickpiggin@yahoo.com.au
Subject: [PATCH] [8/18] Add a __alloc_bootmem_node_nopanic
Message-Id: <20080317015821.F18431B41E0@basil.firstfloor.org>
Date: Mon, 17 Mar 2008 02:58:21 +0100 (CET)
X-OriginalArrivalTime: 17 Mar 2008 01:51:47.0705 (UTC) FILETIME=[75F64E90:01C887D1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Straight forward variant of the existing __alloc_bootmem_node, only 
Signed-off-by: Andi Kleen <ak@suse.de>

difference is that it doesn't panic on failure

Signed-off-by: Andi Kleen <ak@suse.de>
---
 include/linux/bootmem.h |    4 ++++
 mm/bootmem.c            |   12 ++++++++++++
 2 files changed, 16 insertions(+)

Index: linux/mm/bootmem.c
===================================================================
--- linux.orig/mm/bootmem.c
+++ linux/mm/bootmem.c
@@ -471,6 +471,18 @@ void * __init __alloc_bootmem_node(pg_da
 	return __alloc_bootmem(size, align, goal);
 }
 
+void * __init __alloc_bootmem_node_nopanic(pg_data_t *pgdat, unsigned long size,
+				   unsigned long align, unsigned long goal)
+{
+	void *ptr;
+
+	ptr = __alloc_bootmem_core(pgdat->bdata, size, align, goal, 0);
+	if (ptr)
+		return ptr;
+
+	return __alloc_bootmem_nopanic(size, align, goal);
+}
+
 #ifndef ARCH_LOW_ADDRESS_LIMIT
 #define ARCH_LOW_ADDRESS_LIMIT	0xffffffffUL
 #endif
Index: linux/include/linux/bootmem.h
===================================================================
--- linux.orig/include/linux/bootmem.h
+++ linux/include/linux/bootmem.h
@@ -90,6 +90,10 @@ extern void *__alloc_bootmem_node(pg_dat
 				  unsigned long size,
 				  unsigned long align,
 				  unsigned long goal);
+extern void *__alloc_bootmem_node_nopanic(pg_data_t *pgdat,
+				  unsigned long size,
+				  unsigned long align,
+				  unsigned long goal);
 extern unsigned long init_bootmem_node(pg_data_t *pgdat,
 				       unsigned long freepfn,
 				       unsigned long startpfn,
