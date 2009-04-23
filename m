Return-Path: <linux-kernel-owner+w=401wt.eu-S1759564AbZDWSis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759564AbZDWSis (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 14:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753825AbZDWSig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 14:38:36 -0400
Received: from smtp-out.google.com ([216.239.33.17]:6826 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756080AbZDWSif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 14:38:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:message-id:user-agent:
	mime-version:content-type:x-system-of-record;
	b=QNDBC30RSyBgkC6kIhhMcwidfFRNYQxMQhHMF5IOKmHPU95Smb9ElslsATutKHzUg
	vwItx+2Qf2J6KJzPfPBXw==
Date: Thu, 23 Apr 2009 11:38:26 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [patch 1/2] slub: rename cpuslab_flush to cpu_slab_flush
Message-ID: <alpine.DEB.2.00.0904231136390.20852@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is already a `cpu_slabs' file to display the number of cpu slabs,
so cpuslab_flush should follow this pattern.

The first documentation of this file will be in a subsequent patch that
adds Documentation/ABI/testing/sysfs-kernel-slab, so no stable guarantee
has been made that the name of this file would not change.

Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 include/linux/slub_def.h |    2 +-
 mm/slub.c                |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -24,7 +24,7 @@ enum stat_item {
 	ALLOC_SLAB,		/* Cpu slab acquired from page allocator */
 	ALLOC_REFILL,		/* Refill cpu slab from slab freelist */
 	FREE_SLAB,		/* Slab freed to the page allocator */
-	CPUSLAB_FLUSH,		/* Abandoning of the cpu slab */
+	CPU_SLAB_FLUSH,		/* Abandoning of the cpu slab */
 	DEACTIVATE_FULL,	/* Cpu slab was full when deactivated */
 	DEACTIVATE_EMPTY,	/* Cpu slab was empty when deactivated */
 	DEACTIVATE_TO_HEAD,	/* Cpu slab was moved to the head of partials */
diff --git a/mm/slub.c b/mm/slub.c
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1438,7 +1438,7 @@ static void deactivate_slab(struct kmem_cache *s, struct kmem_cache_cpu *c)
 
 static inline void flush_slab(struct kmem_cache *s, struct kmem_cache_cpu *c)
 {
-	stat(c, CPUSLAB_FLUSH);
+	stat(c, CPU_SLAB_FLUSH);
 	slab_lock(c->page);
 	deactivate_slab(s, c);
 }
@@ -4220,7 +4220,7 @@ STAT_ATTR(ALLOC_FROM_PARTIAL, alloc_from_partial);
 STAT_ATTR(ALLOC_SLAB, alloc_slab);
 STAT_ATTR(ALLOC_REFILL, alloc_refill);
 STAT_ATTR(FREE_SLAB, free_slab);
-STAT_ATTR(CPUSLAB_FLUSH, cpuslab_flush);
+STAT_ATTR(CPU_SLAB_FLUSH, cpu_slab_flush);
 STAT_ATTR(DEACTIVATE_FULL, deactivate_full);
 STAT_ATTR(DEACTIVATE_EMPTY, deactivate_empty);
 STAT_ATTR(DEACTIVATE_TO_HEAD, deactivate_to_head);
@@ -4274,7 +4274,7 @@ static struct attribute *slab_attrs[] = {
 	&alloc_slab_attr.attr,
 	&alloc_refill_attr.attr,
 	&free_slab_attr.attr,
-	&cpuslab_flush_attr.attr,
+	&cpu_slab_flush_attr.attr,
 	&deactivate_full_attr.attr,
 	&deactivate_empty_attr.attr,
 	&deactivate_to_head_attr.attr,
