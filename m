Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023Ab0CAFjB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 00:39:01 -0500
Received: from mga09.intel.com ([134.134.136.24]:39534 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892Ab0CAFh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 00:37:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,557,1262592000"; 
   d="scan'208";a="600016149"
Message-Id: <20100301053621.102557225@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 01 Mar 2010 13:26:57 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jens Axboe <jens.axboe@oracle.com>, Matt Mackall <mpm@selenic.com>,
       Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
       Rik van Riel <riel@redhat.com>, Wu Fengguang <fengguang.wu@intel.com>
CC: Chris Mason <chris.mason@oracle.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Clemens Ladisch <clemens@ladisch.de>
CC: Olivier Galibert <galibert@pobox.com>
cc: Vivek Goyal <vgoyal@redhat.com>
CC: Nick Piggin <npiggin@suse.de>
cc: Linux Memory Management List <linux-mm@kvack.org>
CC: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 06/16] readahead: add notes on readahead size
References: <20100301052651.857984880@intel.com>
Content-Disposition: inline; filename=readahead-size-comment.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Basically, currently the default max readahead size
- is 512k
- is boot time configurable with "readahead="
and is auto scaled down:
- for small devices
- for small memory systems (read-around size alone)

CC: Matt Mackall <mpm@selenic.com>
CC: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/readahead.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- linux.orig/mm/readahead.c	2010-02-26 10:11:41.000000000 +0800
+++ linux/mm/readahead.c	2010-02-26 10:11:55.000000000 +0800
@@ -7,6 +7,28 @@
  *		Initial version.
  */
 
+/*
+ * Notes on readahead size.
+ *
+ * The default max readahead size is VM_MAX_READAHEAD=512k,
+ * which can be changed by user with boot time parameter "readahead="
+ * or runtime interface "/sys/devices/virtual/bdi/default/read_ahead_kb".
+ * The latter normally only takes effect in future for hot added devices.
+ *
+ * The effective max readahead size for each block device can be accessed with
+ * 1) the `blockdev` command
+ * 2) /sys/block/sda/queue/read_ahead_kb
+ * 3) /sys/devices/virtual/bdi/$(env stat -c '%t:%T' /dev/sda)/read_ahead_kb
+ *
+ * They are typically initialized with the global default size, however may be
+ * auto scaled down for small devices in add_disk(). NFS, software RAID, btrfs
+ * etc. have special rules to setup their default readahead size.
+ *
+ * The mmap read-around size typically equals with readahead size, with an
+ * extra limit proportional to system memory size.  For example, a 64MB box
+ * will have a 64KB read-around size limit, 128MB mem => 128KB limit, etc.
+ */
+
 #include <linux/kernel.h>
 #include <linux/fs.h>
 #include <linux/memcontrol.h>


