Return-Path: <linux-kernel-owner+w=401wt.eu-S1759135AbYEJDQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759135AbYEJDQe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 23:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756421AbYEJDKB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 23:10:01 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55071 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753120AbYEJDJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 23:09:22 -0400
Message-Id: <20080510030919.604216074@sgi.com>
References: <20080510030831.796641881@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 09 May 2008 20:08:52 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
CC: linux-fsdevel@vger.kernel.org
Cc: Mel Gorman <mel@skynet.ie>
Cc: andi@firstfloor.org
Cc: Rik van Riel <riel@redhat.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: mpm@selenic.com
Subject: [patch 21/21] slab defrag: Obsolete SLAB
Content-Disposition: inline; filename=slab_experimental
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Slab defragmentation introduces new functionality not supported by SLAB and
SLOB.

Make slab depend on EXPERIMENTAL and note its obsoleteness and that
various functionality is not supported by SLAB.

Also update SLOB's description a bit to indicate that certain OS
support is limited by design.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 init/Kconfig |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

Index: linux-2.6/init/Kconfig
===================================================================
--- linux-2.6.orig/init/Kconfig	2008-05-09 18:41:41.000000000 -0700
+++ linux-2.6/init/Kconfig	2008-05-09 18:46:13.000000000 -0700
@@ -749,12 +749,16 @@ choice
 	   This option allows to select a slab allocator.
 
 config SLAB
-	bool "SLAB"
+	bool "SLAB (Obsolete)"
+	depends on EXPERIMENTAL
 	help
-	  The regular slab allocator that is established and known to work
-	  well in all environments. It organizes cache hot objects in
-	  per cpu and per node queues. SLAB is the default choice for
-	  a slab allocator.
+	  The old slab allocator that is being replaced by SLUB.
+	  SLAB does not support slab defragmentation and has limited
+	  debugging support. There is no sysfs support for /sys/kernel/slab.
+	  SLAB requires order 1 allocations for some caches which may under
+	  extreme circumstances fail. New general object debugging methods
+	  (such as kmemcheck) do not support SLAB. The code is complex,
+	  difficult to comprehend and has a history of subtle bugs.
 
 config SLUB
 	bool "SLUB (Unqueued Allocator)"
@@ -771,7 +775,10 @@ config SLOB
 	help
 	   SLOB replaces the stock allocator with a drastically simpler
 	   allocator. SLOB is generally more space efficient but
-	   does not perform as well on large systems.
+	   does not perform as well on large systems. SLOBs functionality
+	   is limited by design (no sysfs support, no defrag, no debugging
+	   etc).
+
 
 endchoice
 

-- 
