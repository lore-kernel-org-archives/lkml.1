Return-Path: <linux-kernel-owner+w=401wt.eu-S1756545AbXKFJcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545AbXKFJcX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 04:32:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753176AbXKFJcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 04:32:16 -0500
Received: from pip9.gyao.ne.jp ([61.122.117.247]:30229 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753773AbXKFJcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 04:32:15 -0500
Date: Tue, 6 Nov 2007 18:32:04 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: lib: Move bitmap.o from lib-y to obj-y.
Message-ID: <20071106093204.GA6119@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

mac80211 has a reference to __bitmap_empty() via bitmap_empty().
In lib/bitmap.c this is flagged with an EXPORT_SYMBOL(), but
this is ultimately ineffective due to bitmap.o being linked in
lib-y, resulting in:

ERROR: "__bitmap_empty" [net/mac80211/mac80211.ko] undefined!

Moving bitmap.o to obj-y fixes this up.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

 lib/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/Makefile b/lib/Makefile
index 3a0983b..b6793ed 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -4,7 +4,7 @@
 
 lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 rbtree.o radix-tree.o dump_stack.o \
-	 idr.o int_sqrt.o bitmap.o extable.o prio_tree.o \
+	 idr.o int_sqrt.o extable.o prio_tree.o \
 	 sha1.o irq_regs.o reciprocal_div.o argv_split.o \
 	 proportions.o prio_heap.o
 
@@ -14,7 +14,7 @@ lib-$(CONFIG_SMP) += cpumask.o
 lib-y	+= kobject.o kref.o klist.o
 
 obj-y += div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
-	 bust_spinlocks.o hexdump.o kasprintf.o
+	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o
 
 ifeq ($(CONFIG_DEBUG_KOBJECT),y)
 CFLAGS_kobject.o += -DDEBUG
