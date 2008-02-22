Return-Path: <linux-kernel-owner+w=401wt.eu-S964897AbYBVA7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964897AbYBVA7K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 19:59:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755024AbYBVA6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 19:58:52 -0500
Received: from yoi5.greathalifaxhome.com ([66.180.172.116]:42687 "HELO
	vps1.tull.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1754093AbYBVA6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 19:58:51 -0500
X-Spam-Check-By: mail.local.tull.net
Date: Fri, 22 Feb 2008 11:58:19 +1100
Message-ID: <20080222-114832-init-kconfig-8@tull.net>
From: Nick Andrew <nick@nick-andrew.net>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>,
       Serge Hallyn <serue@us.ibm.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       Paul Menage <menage@google.com>, Paul Jackson <pj@sgi.com>,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Subject: [PATCH 2.6.25-rc2 8/9] Kconfig: Improve init/Kconfig help descriptions - SLAB
References: <20080219140609.GA26619@tull.net>
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rewrite the help descriptions for clarity, accuracy and consistency.

Kernel config options affected:

  - SLUB_DEBUG
  - SLAB
  - SLUB
  - SLOB

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---
Try #3.

--- a/init/Kconfig	2008-02-20 09:34:48.000000000 +1100
+++ b/init/Kconfig	2008-02-20 09:50:54.000000000 +1100
@@ -683,31 +683,48 @@ config SLUB_DEBUG
 	bool "Enable SLUB debugging support" if EMBEDDED
 	depends on SLUB
 	help
+	  Enable debugging on the "SLUB" slab allocator.
+
 	  SLUB has extensive debug support features. Disabling these can
 	  result in significant savings in code size. This also disables
 	  SLUB sysfs support. /sys/slab will not exist and there will be
 	  no support for cache validation etc.
 
+	  If unsure, say N.
+
 choice
 	prompt "Choose SLAB allocator"
 	default SLUB
 	help
-	   This option allows to select a slab allocator.
+	   This option selects a slab allocator.
+
+	   A slab is a contiguous area of kernel memory. Slabs are of
+	   fixed size (1 or more times the page size) and are used as
+	   the container for allocation of kernel data structures. This
+	   reduces memory fragmentation and makes allocation very fast,
+	   improving kernel performance.
+
+	   "SLUB" is the default slab allocator.
+
+	   See wikipedia:Slab_allocation for more details.
 
 config SLAB
 	bool "SLAB"
 	help
-	  The regular slab allocator that is established and known to work
-	  well in all environments. It organizes cache hot objects in
-	  per cpu and per node queues. SLAB is the default choice for
-	  a slab allocator.
+	  SLAB is the original slab allocator that is established and
+	  known to work well in all environments. It organizes cache
+	  hot objects in per-CPU and per-node queues.
+
+	  SLAB has been superseded by SLUB.
 
 config SLUB
 	bool "SLUB (Unqueued Allocator)"
 	help
 	   SLUB is a slab allocator that minimizes cache line usage
-	   instead of managing queues of cached objects (SLAB approach).
-	   Per cpu caching is realized using slabs of objects instead
+	   instead of managing queues of cached objects (the SLAB
+	   approach).
+
+	   Per-CPU caching is realized using slabs of objects instead
 	   of queues of objects. SLUB can use memory efficiently
 	   and has enhanced diagnostics.
 
@@ -715,9 +732,11 @@ config SLOB
 	depends on EMBEDDED
 	bool "SLOB (Simple Allocator)"
 	help
-	   SLOB replaces the stock allocator with a drastically simpler
-	   allocator. SLOB is generally more space efficient but
-	   does not perform as well on large systems.
+	   SLOB is a drastically simpler allocator for use in embedded
+	   systems.
+
+	   SLOB is generally more space efficient but does not perform
+	   as well on large systems.
 
 endchoice
 
