Return-Path: <linux-kernel-owner+w=401wt.eu-S1759543AbYBSPWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759543AbYBSPWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 10:22:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758274AbYBSPV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 10:21:59 -0500
Received: from yoi5.greathalifaxhome.com ([66.180.172.116]:33108 "HELO
	vps1.tull.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1753041AbYBSPV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 10:21:57 -0500
X-Spam-Check-By: mail.local.tull.net
Date: Wed, 20 Feb 2008 02:21:17 +1100
From: Nick Andrew <nick@nick-andrew.net>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Improve init/Kconfig help descriptions [PATCH 8/9]
Message-ID: <20080219152117.GF27352@tull.net>
References: <20080219140609.GA26619@tull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219140609.GA26619@tull.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2008 at 01:06:09AM +1100, Nick Andrew wrote:
> Here is a series of 9 patches to init/Kconfig intended to improve the
> usefulness and consistency of the help descriptions. The patches are
> against linux-2.6.24.2.
> [...]
> Patch 8
> 	SLUB_DEBUG
> 	SLAB
> 	SLUB
> 	SLOB

Changelog:

Improve usefulness and consistency of kernel configuration help messages.

Signed-off-by: Nick Andrew <nick@nick-andrew.net>


--- a/init/Kconfig	2008-02-20 00:45:07.000000000 +1100
+++ b/init/Kconfig	2008-02-20 00:52:07.000000000 +1100
@@ -616,31 +616,48 @@ config SLUB_DEBUG
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
 
@@ -648,11 +665,14 @@ config SLOB
 	depends on EMBEDDED
 	bool "SLOB (Simple Allocator)"
 	help
-	   SLOB replaces the SLAB allocator with a drastically simpler
-	   allocator.  SLOB is more space efficient than SLAB but does not
-	   scale well (single lock for all operations) and is also highly
-	   susceptible to fragmentation. SLUB can accomplish a higher object
-	   density. It is usually better to use SLUB instead of SLOB.
+	   SLOB is a drastically simpler allocator for use in embedded
+	   systems.
+
+	   SLOB is more space efficient than SLAB but does not scale well
+	   (it uses a single lock for all operations) and is also highly
+	   susceptible to fragmentation. SLUB can accomplish a higher
+	   object density. It is usually better to use SLUB instead
+	   of SLOB.
 
 endchoice
 
