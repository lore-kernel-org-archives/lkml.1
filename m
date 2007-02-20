Return-Path: <linux-kernel-owner+w=401wt.eu-S932976AbXBTTUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932976AbXBTTUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 14:20:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932973AbXBTTUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 14:20:41 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:42422 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932976AbXBTTUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 14:20:40 -0500
Date: Tue, 20 Feb 2007 11:15:36 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH] kernel-doc fixes for 2.6.20-git15 (non-drivers)
Message-Id: <20070220111536.96d05646.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc warnings in 2.6.20-git15 (lib/, mm/, kernel/, include/).

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/linux/hrtimer.h |    1 +
 kernel/relay.c          |    3 +--
 kernel/timer.c          |    1 +
 lib/bitmap.c            |   16 ++++++++--------
 mm/slab.c               |    2 +-
 5 files changed, 12 insertions(+), 11 deletions(-)

--- linux-2.6.20-git15.orig/kernel/relay.c
+++ linux-2.6.20-git15/kernel/relay.c
@@ -474,13 +474,12 @@ static void setup_callbacks(struct rchan
 }
 
 /**
- *
  * 	relay_hotcpu_callback - CPU hotplug callback
  * 	@nb: notifier block
  * 	@action: hotplug action to take
  * 	@hcpu: CPU number
  *
- * 	Returns the success/failure of the operation. (NOTIFY_OK, NOTIFY_BAD)
+ * 	Returns the success/failure of the operation. (%NOTIFY_OK, %NOTIFY_BAD)
  */
 static int __cpuinit relay_hotcpu_callback(struct notifier_block *nb,
 				unsigned long action,
--- linux-2.6.20-git15.orig/mm/slab.c
+++ linux-2.6.20-git15/mm/slab.c
@@ -4026,7 +4026,7 @@ void drain_array(struct kmem_cache *cach
 
 /**
  * cache_reap - Reclaim memory from caches.
- * @unused: unused parameter
+ * @w: work descriptor
  *
  * Called from workqueue/eventd every few seconds.
  * Purpose:
--- linux-2.6.20-git15.orig/include/linux/hrtimer.h
+++ linux-2.6.20-git15/include/linux/hrtimer.h
@@ -140,6 +140,7 @@ struct hrtimer_sleeper {
 
 /**
  * struct hrtimer_base - the timer base for a specific clock
+ * @cpu_base:		per cpu clock base
  * @index:		clock type index for per_cpu support when moving a
  *			timer to a base on another cpu.
  * @active:		red black tree root node for the active timers
--- linux-2.6.20-git15.orig/kernel/timer.c
+++ linux-2.6.20-git15/kernel/timer.c
@@ -711,6 +711,7 @@ static unsigned long cmp_next_hrtimer_ev
 
 /**
  * next_timer_interrupt - return the jiffy of the next pending timer
+ * @now: current time (in jiffies)
  */
 unsigned long get_next_timer_interrupt(unsigned long now)
 {
--- linux-2.6.20-git15.orig/lib/bitmap.c
+++ linux-2.6.20-git15/lib/bitmap.c
@@ -97,10 +97,10 @@ EXPORT_SYMBOL(__bitmap_complement);
 
 /**
  * __bitmap_shift_right - logical right shift of the bits in a bitmap
- *   @dst - destination bitmap
- *   @src - source bitmap
- *   @nbits - shift by this many bits
- *   @bits - bitmap size, in bits
+ *   @dst : destination bitmap
+ *   @src : source bitmap
+ *   @shift : shift by this many bits
+ *   @bits : bitmap size, in bits
  *
  * Shifting right (dividing) means moving bits in the MS -> LS bit
  * direction.  Zeros are fed into the vacated MS positions and the
@@ -141,10 +141,10 @@ EXPORT_SYMBOL(__bitmap_shift_right);
 
 /**
  * __bitmap_shift_left - logical left shift of the bits in a bitmap
- *   @dst - destination bitmap
- *   @src - source bitmap
- *   @nbits - shift by this many bits
- *   @bits - bitmap size, in bits
+ *   @dst : destination bitmap
+ *   @src : source bitmap
+ *   @shift : shift by this many bits
+ *   @bits : bitmap size, in bits
  *
  * Shifting left (multiplying) means moving bits in the LS -> MS
  * direction.  Zeros are fed into the vacated LS bit positions
