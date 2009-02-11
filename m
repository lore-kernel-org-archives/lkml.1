Return-Path: <linux-kernel-owner+w=401wt.eu-S1755741AbZBKN65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741AbZBKN65 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 08:58:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753084AbZBKN6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 08:58:48 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38235 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbZBKN6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 08:58:47 -0500
Subject: Re: next-20090211: BUG: MAX_LOCKDEP_SUBCLASSES too low!
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Mason <chris.mason@oracle.com>
In-Reply-To: <1234357467.23438.151.camel@twins>
References: <a4423d670902110414r72f14c1eq850cda59533bd9db@mail.gmail.com>
	 <1234355010.23438.132.camel@twins> <1234355070.23438.133.camel@twins>
	 <1234355201.23438.134.camel@twins>
	 <a4423d670902110452s5fb6d041l2363c8ad9b9618fb@mail.gmail.com>
	 <1234357467.23438.151.camel@twins>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 11 Feb 2009 15:00:34 +0100
Message-Id: <1234360834.23438.162.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-11 at 14:04 +0100, Peter Zijlstra wrote:
> On Wed, 2009-02-11 at 15:52 +0300, Alexander Beregalov wrote:
> > 2009/2/11 Peter Zijlstra <peterz@infradead.org>:
> > > On Wed, 2009-02-11 at 13:24 +0100, Peter Zijlstra wrote:
> > >> On Wed, 2009-02-11 at 13:23 +0100, Peter Zijlstra wrote:
> > >> > On Wed, 2009-02-11 at 15:14 +0300, Alexander Beregalov wrote:
> > >> > > Hi
> > >> > >
> > >> > > Full dmesg is attached.
> > >> > >
> > >> > > Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> > >> > > .... MAX_LOCKDEP_SUBCLASSES:  8
> > >> > > .... MAX_LOCK_DEPTH:          48
> > >> > > .... MAX_LOCKDEP_KEYS:        8191
> > >> > > .... CLASSHASH_SIZE:          4096
> > >> > > .... MAX_LOCKDEP_ENTRIES:     8192
> > >> > > .... MAX_LOCKDEP_CHAINS:      16384
> > >> > > .... CHAINHASH_SIZE:          8192
> > >> > >  memory used by lock dependency info: 4351 kB
> > >> > >  per task-struct memory footprint: 2688 bytes
> > >> > > <..>
> > >> > > BUG: MAX_LOCKDEP_SUBCLASSES too low!
> > >> > > turning off the locking correctness validator.
> > >> >
> > >> > Is this an allyesconfig or something other massive bloated?
> > >>
> > >> Sorry, not playing attention, its SUB classes.. let me look at that,
> > >> that smells like a rotten annotation.
> > >
> > > Could you run with the below patch, so that we can see where this
> > > happens?
> 
> Tssk, Chris what you have been doing?

Would something like this work?

---
 fs/btrfs/extent_io.c |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/locking.c   |   11 -----------
 2 files changed, 49 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 37d43b5..d6cf792 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2972,6 +2972,45 @@ static inline unsigned long num_extent_pages(u64 start, u64 len)
 		(start >> PAGE_CACHE_SHIFT);
 }
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+#define BTRFS_MAX_EXTENT_DEPTH 32 /* mason knows */
+static struct lock_class_key btrfs_eb_class[BTRFS_MAX_EXTENT_DEPTH];
+static const char *btrfs_eb_name[BTRFS_MAX_EXTENT_DEPTH] = {
+	"btrfs-extent-00",
+	"btrfs-extent-01",
+	"btrfs-extent-02",
+	"btrfs-extent-03",
+	"btrfs-extent-04",
+	"btrfs-extent-05",
+	"btrfs-extent-06",
+	"btrfs-extent-07",
+	"btrfs-extent-08",
+	"btrfs-extent-09",
+	"btrfs-extent-10",
+	"btrfs-extent-11",
+	"btrfs-extent-12",
+	"btrfs-extent-13",
+	"btrfs-extent-14",
+	"btrfs-extent-15",
+	"btrfs-extent-16",
+	"btrfs-extent-17",
+	"btrfs-extent-18",
+	"btrfs-extent-19",
+	"btrfs-extent-20",
+	"btrfs-extent-21",
+	"btrfs-extent-22",
+	"btrfs-extent-23",
+	"btrfs-extent-24",
+	"btrfs-extent-25",
+	"btrfs-extent-26",
+	"btrfs-extent-27",
+	"btrfs-extent-28",
+	"btrfs-extent-29",
+	"btrfs-extent-30",
+	"btrfs-extent-31",
+};
+#endif
+
 static struct extent_buffer *__alloc_extent_buffer(struct extent_io_tree *tree,
 						   u64 start,
 						   unsigned long len,
@@ -3070,6 +3109,16 @@ struct extent_buffer *alloc_extent_buffer(struct extent_io_tree *tree,
 	if (uptodate)
 		set_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	/*
+	 * apparently we're done loading the eb here
+	 */
+	i = btrfs_header_level(eb);
+	lockdep_set_class_and_name(eb->lock,
+			&btrfs_eb_class[i],
+			btrfs_eb_name[i]);
+#endif
+
 	spin_lock(&tree->buffer_lock);
 	exists = buffer_tree_insert(tree, start, &eb->rb_node);
 	if (exists) {
diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
index 9ebe938..85506c4 100644
--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -25,21 +25,10 @@
 #include "extent_io.h"
 #include "locking.h"
 
-/*
- * btrfs_header_level() isn't free, so don't call it when lockdep isn't
- * on
- */
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-static inline void spin_nested(struct extent_buffer *eb)
-{
-	spin_lock_nested(&eb->lock, BTRFS_MAX_LEVEL - btrfs_header_level(eb));
-}
-#else
 static inline void spin_nested(struct extent_buffer *eb)
 {
 	spin_lock(&eb->lock);
 }
-#endif
 
 /*
  * Setting a lock to blocking will drop the spinlock and set the

