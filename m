Return-Path: <linux-kernel-owner+w=401wt.eu-S1759629AbZDWSjG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759629AbZDWSjG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 14:39:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758550AbZDWSik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 14:38:40 -0400
Received: from smtp-out.google.com ([216.239.33.17]:6832 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757737AbZDWSii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 14:38:38 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=qr61XIaDoNvzXyNz9BLOqPMM+Gr/tztdUfeuNckpQhazi8l/yV1aiqYM027tDw4A8
	y2e0iOpOEVR69JeXo9Bng==
Date: Thu, 23 Apr 2009 11:38:32 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Christoph Lameter <cl@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: [patch 2/2] slub: add Documentation/ABI/testing/sysfs-kernel-slab
In-Reply-To: <alpine.DEB.2.00.0904231136390.20852@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.0904231137440.20852@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0904231136390.20852@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds documentation for the slub ABI.

This is placed in the `testing' directory since the meanings of these
files are still subject to change as slub is developed.

Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 Documentation/ABI/testing/sysfs-kernel-slab |  475 +++++++++++++++++++++++++++
 1 files changed, 475 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-kernel-slab

diff --git a/Documentation/ABI/testing/sysfs-kernel-slab b/Documentation/ABI/testing/sysfs-kernel-slab
new file mode 100644
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-kernel-slab
@@ -0,0 +1,475 @@
+What:		/sys/kernel/slab
+Date:		May 2007
+KernelVersion:	2.6.22
+Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
+		Christoph Lameter <cl@linux-foundation.org>
+Description:
+		The /sys/kernel/slab directory contains a snapshot of the
+		internal state of the SLUB allocator for each cache.  Certain
+		files may be modified to change the behavior of the cache (and
+		any cache it aliases, if any).
+Users:		kernel memory tuning tools
+
+What:		/sys/kernel/slab/cache/aliases
+Date:		May 2007
+KernelVersion:	2.6.22
+Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
+		Christoph Lameter <cl@linux-foundation.org>
+Description:
+		The aliases file is read-only and specifies how many caches
+		have merged into this cache.
+
+What:		/sys/kernel/slab/cache/align
+Date:		May 2007
+KernelVersion:	2.6.22
+Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
+		Christoph Lameter <cl@linux-foundation.org>
+Description:
+		The align file is read-only and specifies the cache's object
+		alignment in bytes.
+
+What:		/sys/kernel/slab/cache/alloc_calls
+Date:		May 2007
+KernelVersion:	2.6.22
+Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
+		Christoph Lameter <cl@linux-foundation.org>
+Description:
+		The alloc_calls file is read-only and lists the locations of
+		object allocs for SLAB_STORE_USER caches as specified on the
+		kernel command line (see Documentation/vm/slub.txt).
+
+What:		/sys/kernel/slab/cache/alloc_fastpath
+Date:		February 2008
+KernelVersion:	2.6.25
+Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
+		Christoph Lameter <cl@linux-foundation.org>
+Description:
+		The alloc_fastpath file is read-only and specifies how many
+		objects have been allocated utilizing the cache's fastpath
+		(i.e. from the cpu slab).
+		Available when CONFIG_SLUB_STATS is enabled.
+
+What:		/sys/kernel/slab/cache/alloc_from_partial
+Date:		February 2008
+KernelVersion:	2.6.25
+Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
+		Christoph Lameter <cl@linux-foundation.org>
+Description:
+		The alloc_from_partial file is read-only and specifies how
+		many times a cpu slab has been full and it has been refilled
+		by a partial slab.
+		Available when CONFIG_SLUB_STATS is enabled.
+
+What:		/sys/kernel/slab/cache/alloc_refill
+Date:		February 2008
+KernelVersion:	2.6.25
+Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
+		Christoph Lameter <cl@linux-foundation.org>
+Description:
+		The alloc_refill file is read-only and specifies how many
+		times a cpu slab needed to be refilled because it was full.
+		Available when CONFIG_SLUB_STATS is enabled.
+
+What:		/sys/kernel/slab/cache/alloc_slab
+Date:		February 2008
+KernelVersion:	2.6.25
+Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
+		Christoph Lameter <cl@linux-foundation.org>
+Description:
+		The alloc_slab file is read-only and specifies how many times
+		a new slab had to be allocated from the page allocator.
+		Available when CONFIG_SLUB_STATS is enabled.
+
+What:		/sys/kernel/slab/cache/alloc_slowpath
+Date:		February 2008
+KernelVersion:	2.6.25
+Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
+		Christoph Lameter <cl@linux-foundation.org>
+Description:
+		The alloc_slowpath file is read-only and specifies how many
+		objects have been allocated utilizing the cache's slowpath
+		(i.e. from a partial or new slab).
+		Available when CONFIG_SLUB_STATS is enabled.
+
+What:		/sys/kernel/slab/cache/cache_dma
+Date:		May 2007
+KernelVersion:	2.6.22
+Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
+		Christoph Lameter <cl@linux-foundation.org>
+Description:
+		The cache_dma file is read-only and specifies whether objects
+		are from ZONE_DMA.
+		Available when CONFIG_ZONE_DMA is enabled.
+
+What:		/sys/kernel/slab/cache/cpu_slabs
+Date:		May 2007
+KernelVersion:	2.6.22
+Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
+		Christoph Lameter <cl@linux-foundation.org>
+Description:
+		The cpu_slabs file is read-only and displays how many cpu slabs
+		are active and from which nodes they are from.
+
+What:		/sys/kernel/slab/cache/cpu_slab_flush
+Date:		April 2009
+KernelVersion:	2.6.31
+Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
+		Christoph Lameter <cl@linux-foundation.org>
+Description:
+		The file cpu_slab_flush is read-only and specifies how many
+		times a cache's cpu slabs have been flushed as the result of
+		destroying or shrinking a cache and when a cpu goes offline.
+		Available when CONFIG_SLUB_STATS is enabled.
+
+What:		/sys/kernel/slab/cache/ctor
+Date:		May 2007
+KernelVersion:	2.6.22
+Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
+		Christoph Lameter <cl@linux-foundation.org>
+Description:
+		The ctor file is read-only and specifies the cache's object
+		constructor function, which is invoked for each object when a
+		new slab is allocated.
+
+What:		/sys/kernel/slab/cache/deactivate_empty
+Date:		February 2008
+KernelVersion:	2.6.25
+Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
+		Christoph Lameter <cl@linux-foundation.org>
+Description:
+		The file deactivate_empty is read-only and specifies how many
+		times an empty cpu slab was deactivated.
+		Available when CONFIG_SLUB_STATS is enabled.
+
+What:		/sys/kernel/slab/cache/deactivate_full
+Date:		February 2008
+KernelVersion:	2.6.25
+Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
+		Christoph Lameter <cl@linux-foundation.org>
+Description:
+		The file deactivate_full is read-only and specifies how many
+		times a full cpu slab was deactivated.
+		Available when CONFIG_SLUB_STATS is enabled.
+
+What:		/sys/kernel/slab/cache/deactivate_remote_frees
+Date:		February 2008
+KernelVersion:	2.6.25
+Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
+		Christoph Lameter <cl@linux-foundation.org>
+Description:
+		The file deactivate_remote_frees is read-only and specifies how
+		many times a cpu slab has been deactivated and contained free
+		objects that were freed remotely.
+		Available when CONFIG_SLUB_STATS is enabled.
+
+What:		/sys/kernel/slab/cache/deactivate_to_head
+Date:		February 2008
+KernelVersion:	2.6.25
+Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
+		Christoph Lameter <cl@linux-foundation.org>
+Description:
+		The file deactivate_to_head is read-only and specifies how
+		many times a partial cpu slab was deactivated and added to the
+		head of its node's partial list.
+		Available when CONFIG_SLUB_STATS is enabled.
+
+What:		/sys/kernel/slab/cache/deactivate_to_tail
+Date:		February 2008
+KernelVersion:	2.6.25
+Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
+		Christoph Lameter <cl@linux-foundation.org>
+Description:
+		The file deactivate_to_tail is read-only and specifies how
+		many times a partial cpu slab was deactivated and added to the
+		tail of its node's partial list.
+		Available when CONFIG_SLUB_STATS is enabled.
+
+What:		/sys/kernel/slab/cache/destroy_by_rcu
+Date:		May 2007
+KernelVersion:	2.6.22
+Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
+		Christoph Lameter <cl@linux-foundation.org>
+Description:
+		The destroy_by_rcu file is read-only and specifies whether
+		slabs (not objects) are freed by rcu.
+
+What:		/sys/kernel/slab/cache/free_add_partial
+Date:		February 2008
+KernelVersion:	2.6.25
+Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
+		Christoph Lameter <cl@linux-foundation.org>
+Description:
+		The file free_add_partial is read-only and specifies how many
+		times an object has been freed to a full slab so that it had to
+		added to its node's partial list.
+		Available when CONFIG_SLUB_STATS is enabled.
+
+What:		/sys/kernel/slab/cache/free_calls
+Date:		May 2007
+KernelVersion:	2.6.22
+Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
+		Christoph Lameter <cl@linux-foundation.org>
+Description:
+		The free_calls file is read-only and lists the locations of
+		object frees for SLAB_STORE_USER caches as specified on the
+		kernel command line (see Documentation/vm/slub.txt).
+
+What:		/sys/kernel/slab/cache/free_fastpath
+Date:		February 2008
+KernelVersion:	2.6.25
+Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
+		Christoph Lameter <cl@linux-foundation.org>
+Description:
+		The free_fastpath file is read-only and specifies how many
+		objects have been freed utilizing the cache's fastpath (i.e.
+		to the cpu slab).
+		Available when CONFIG_SLUB_STATS is enabled.
+
+What:		/sys/kernel/slab/cache/free_frozen
+Date:		February 2008
+KernelVersion:	2.6.25
+Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
+		Christoph Lameter <cl@linux-foundation.org>
+Description:
+		The free_frozen file is read-only and specifies how many
+		objects have been freed to a frozen slab (i.e. a remote cpu
+		slab).
+		Available when CONFIG_SLUB_STATS is enabled.
+
+What:		/sys/kernel/slab/cache/free_remove_partial
+Date:		February 2008
+KernelVersion:	2.6.25
+Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
+		Christoph Lameter <cl@linux-foundation.org>
+Description:
+		The file free_remove_partial is read-only and specifies how
+		many times an object has been freed to a now-empty slab so
+		that it had to be removed from its node's partial list.
+		Available when CONFIG_SLUB_STATS is enabled.
+
+What:		/sys/kernel/slab/cache/free_slab
+Date:		February 2008
+KernelVersion:	2.6.25
+Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
+		Christoph Lameter <cl@linux-foundation.org>
+Description:
+		The free_slab file is read-only and specifies how many times an
+		empty slab has been freed back to the page allocator.
+		Available when CONFIG_SLUB_STATS is enabled.
+
+What:		/sys/kernel/slab/cache/free_slowpath
+Date:		February 2008
+KernelVersion:	2.6.25
+Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
+		Christoph Lameter <cl@linux-foundation.org>
+Description:
+		The free_slowpath file is read-only and specifies how many
+		objects have been freed utilizing the cache's slowpath (i.e.
+		to a full or partial slab).
+		Available when CONFIG_SLUB_STATS is enabled.
+
+What:		/sys/kernel/slab/cache/hwcache_align
+Date:		May 2007
+KernelVersion:	2.6.22
+Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
+		Christoph Lameter <cl@linux-foundation.org>
+Description:
+		The hwcache_align file is read-only and specifies whether
+		objects are aligned on cachelines.
+
+What:		/sys/kernel/slab/cache/min_partial
+Date:		February 2009
+KernelVersion:	2.6.30
+Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
+		David Rientjes <rientjes@google.com>
+Description:
+		The min_partial file specifies how many empty slabs shall
+		remain on a node's partial list to avoid the overhead of
+		allocating new slabs.  Such slabs may be reclaimed by utilizing
+		the shrink file.
+
+What:		/sys/kernel/slab/cache/object_size
+Date:		May 2007
+KernelVersion:	2.6.22
+Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
+		Christoph Lameter <cl@linux-foundation.org>
+Description:
+		The object_size file is read-only and specifies the cache's
+		object size.
+
+What:		/sys/kernel/slab/cache/objects
+Date:		May 2007
+KernelVersion:	2.6.22
+Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
+		Christoph Lameter <cl@linux-foundation.org>
+Description:
+		The objects file is read-only and displays how many objects are
+		active and from which nodes they are from.
+
+What:		/sys/kernel/slab/cache/objects_partial
+Date:		April 2008
+KernelVersion:	2.6.26
+Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
+		Christoph Lameter <cl@linux-foundation.org>
+Description:
+		The objects_partial file is read-only and displays how many
+		objects are on partial slabs and from which nodes they are
+		from.
+
+What:		/sys/kernel/slab/cache/objs_per_slab
+Date:		May 2007
+KernelVersion:	2.6.22
+Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
+		Christoph Lameter <cl@linux-foundation.org>
+Description:
+		The file objs_per_slab is read-only and specifies how many
+		objects may be allocated from a single slab of the order
+		specified in /sys/kernel/slab/cache/order.
+
+What:		/sys/kernel/slab/cache/order
+Date:		May 2007
+KernelVersion:	2.6.22
+Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
+		Christoph Lameter <cl@linux-foundation.org>
+Description:
+		The order file specifies the page order at which new slabs are
+		allocated.  If a slab cannot be allocated because of
+		fragmentation, SLUB will retry with the minimum order possible
+		depending on its characteristics.
+
+What:		/sys/kernel/slab/cache/order_fallback
+Date:		April 2008
+KernelVersion:	2.6.26
+Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
+		Christoph Lameter <cl@linux-foundation.org>
+Description:
+		The file order_fallback is read-only and specifies how many
+		times an allocation of a new slab has not been possible at the
+		cache's order and instead fallen back to its minimum possible
+		order.
+		Available when CONFIG_SLUB_STATS is enabled.
+
+What:		/sys/kernel/slab/cache/partial
+Date:		May 2007
+KernelVersion:	2.6.22
+Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
+		Christoph Lameter <cl@linux-foundation.org>
+Description:
+		The partial file is read-only and displays how long many
+		partial slabs there are and how long each node's list is.
+
+What:		/sys/kernel/slab/cache/poison
+Date:		May 2007
+KernelVersion:	2.6.22
+Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
+		Christoph Lameter <cl@linux-foundation.org>
+Description:
+		The poison file specifies whether objects should be poisoned
+		when a new slab is allocated.
+
+What:		/sys/kernel/slab/cache/reclaim_account
+Date:		May 2007
+KernelVersion:	2.6.22
+Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
+		Christoph Lameter <cl@linux-foundation.org>
+Description:
+		The reclaim_account file specifies whether the cache's objects
+		are reclaimable (and grouped by their mobility).
+
+What:		/sys/kernel/slab/cache/red_zone
+Date:		May 2007
+KernelVersion:	2.6.22
+Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
+		Christoph Lameter <cl@linux-foundation.org>
+Description:
+		The red_zone file specifies whether the cache's objects are red
+		zoned.
+
+What:		/sys/kernel/slab/cache/remote_node_defrag_ratio
+Date:		January 2008
+KernelVersion:	2.6.25
+Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
+		Christoph Lameter <cl@linux-foundation.org>
+Description:
+		The file remote_node_defrag_ratio specifies the percentage of
+		times SLUB will attempt to refill the cpu slab with a partial
+		slab from a remote node as opposed to allocating a new slab on
+		the local node.  This reduces the amount of wasted memory over
+		the entire system but can be expensive.
+		Available when CONFIG_NUMA is enabled.
+
+What:		/sys/kernel/slab/cache/sanity_checks
+Date:		May 2007
+KernelVersion:	2.6.22
+Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
+		Christoph Lameter <cl@linux-foundation.org>
+Description:
+		The sanity_checks file specifies whether expensive checks
+		should be performed on free.  This is actually a no-op for SLUB
+		so it only acts to prevent slab merging.
+
+What:		/sys/kernel/slab/cache/shrink
+Date:		May 2007
+KernelVersion:	2.6.22
+Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
+		Christoph Lameter <cl@linux-foundation.org>
+Description:
+		The shrink file is written when memory should be reclaimed from
+		a cache.  Empty partial slabs are freed and the partial list is
+		sorted so the slabs with the fewest available objects are used
+		first.
+
+What:		/sys/kernel/slab/cache/slab_size
+Date:		May 2007
+KernelVersion:	2.6.22
+Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
+		Christoph Lameter <cl@linux-foundation.org>
+Description:
+		The slab_size file is read-only and specifies the object size
+		with metadata (debugging information and alignment) in bytes.
+
+What:		/sys/kernel/slab/cache/slabs
+Date:		May 2007
+KernelVersion:	2.6.22
+Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
+		Christoph Lameter <cl@linux-foundation.org>
+Description:
+		The slabs file is read-only and displays how long many slabs
+		there are (both cpu and partial) and from which nodes they are
+		from.
+
+What:		/sys/kernel/slab/cache/store_user
+Date:		May 2007
+KernelVersion:	2.6.22
+Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
+		Christoph Lameter <cl@linux-foundation.org>
+Description:
+		The store_user file specifies whether the location of
+		allocation or free should be tracked for a cache.
+
+What:		/sys/kernel/slab/cache/total_objects
+Date:		April 2008
+KernelVersion:	2.6.26
+Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
+		Christoph Lameter <cl@linux-foundation.org>
+Description:
+		The total_objects file is read-only and displays how many total
+		objects a cache has and from which nodes they are from.
+
+What:		/sys/kernel/slab/cache/trace
+Date:		May 2007
+KernelVersion:	2.6.22
+Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
+		Christoph Lameter <cl@linux-foundation.org>
+Description:
+		The trace file specifies whether object allocations and frees
+		should be traced.
+
+What:		/sys/kernel/slab/cache/validate
+Date:		May 2007
+KernelVersion:	2.6.22
+Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
+		Christoph Lameter <cl@linux-foundation.org>
+Description:
+		The validate file is written whenever a cache should be
+		validated for correctness.
