Return-Path: <linux-kernel-owner+w=401wt.eu-S1760901AbXEPSnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760901AbXEPSnx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 14:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756223AbXEPSnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 14:43:47 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55012 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756132AbXEPSnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 14:43:46 -0400
Date: Wed, 16 May 2007 11:41:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bernd Schubert <bs@q-leap.de>
Cc: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       "Bernd Schubert" <bschubert@q-leap.de>, linux-kernel@vger.kernel.org
Subject: Re: mkfs.ext2 triggered softlockup
Message-Id: <20070516114100.9cd642b8.akpm@linux-foundation.org>
In-Reply-To: <200705161901.09072.bs@q-leap.de>
References: <f2fcc1$otm$2@sea.gmane.org>
	<6bffcb0e0705160949m7486705s1b2fc5bbe8a025df@mail.gmail.com>
	<200705161901.09072.bs@q-leap.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2007 19:01:08 +0200
Bernd Schubert <bs@q-leap.de> wrote:

> On Wednesday 16 May 2007 18:49:57 Michal Piotrowski wrote:
> > Hi Bernd,
> >
> > On 16/05/07, Bernd Schubert <bschubert@q-leap.de> wrote:
> > > Maybe you still remember my report about an mkfs.ext2 triggered ram disk
> > > corruption?
> > >
> > > http://lkml.org/lkml/2007/5/4/272
> > >
> > > Well, in principle I'm now doing the same stuff, only this time with
> > > another initrd, which mounts the root-fs over nfs.
> > >
> > > [ 1596.928552] BUG: soft lockup detected on CPU#2!
> > > [ 1596.933109]
> > > [ 1596.933110] Call Trace:
> > > [ 1596.933111]  <IRQ>  [<ffffffff8025167b>] softlockup_tick+0xd8/0xef
> > > [ 1596.933129]  [<ffffffff802329f8>] run_local_timers+0x13/0x15
> > > [ 1596.933132]  [<ffffffff80232a44>] update_process_times+0x4a/0x77
> > > [ 1596.933138]  [<ffffffff8021434b>] smp_local_timer_interrupt+0x34/0x54
> > > [ 1596.933143]  [<ffffffff802143cc>] smp_apic_timer_interrupt+0x61/0x78
> > > [ 1596.933147]  [<ffffffff8020a29b>] apic_timer_interrupt+0x6b/0x70
> > > [ 1596.933151]  <EOI>  [<ffffffff80299dff>] free_buffer_head+0x24/0x3e
> > > [ 1596.933162]  [<ffffffff80272a63>] kmem_cache_free+0x1f4/0x201
> > > [ 1596.933170]  [<ffffffff80299dff>] free_buffer_head+0x24/0x3e
> > > [ 1596.933175]  [<ffffffff80299ea1>] try_to_free_buffers+0x88/0x9f
> > > [ 1596.933181]  [<ffffffff802565a9>] try_to_release_page+0x39/0x40
> > > [ 1596.933188]  [<ffffffff8025b76d>] invalidate_mapping_pages+0x9d/0x121
> > > [ 1596.933196]  [<ffffffff8025b800>] invalidate_inode_pages+0xf/0x11
> > > [ 1596.933200]  [<ffffffff80299053>] invalidate_bdev+0x3b/0x3f
> > > [ 1596.933203]  [<ffffffff8029c9ee>] kill_bdev+0x13/0x29
> > > [ 1596.933208]  [<ffffffff8029d6e8>] __blkdev_put+0x62/0x141
> > > [ 1596.933213]  [<ffffffff8029db62>] blkdev_put+0xb/0xd
> > > [ 1596.933218]  [<ffffffff8029dbf7>] blkdev_close+0x2e/0x33
> > > [ 1596.933222]  [<ffffffff8027a3c3>] __fput+0xc3/0x172
> > > [ 1596.933228]  [<ffffffff8027a486>] fput+0x14/0x16
> > > [ 1596.933233]  [<ffffffff80278c4f>] filp_close+0x61/0x6d
> > > [ 1596.933238]  [<ffffffff80278ce7>] sys_close+0x8c/0xce
> > > [ 1596.933244]  [<ffffffff8020965e>] system_call+0x7e/0x83
> > > [ 1596.933250]
> >
> > Can you tell me which kernel version you are using?
> 
> Sorry, forgot that. I think 2.6.20.6 or 2.6.20.7 (I always rename them to .3, 
> for some reasons thats easier than to change our tftp-rembo config). The 
> kernel is patches with lustre patches, hmm, one of them also adds a read-only 
> test to the block device layer.
> Probably I should test a vanilla kernel. Going to do that now...
> 

Don't bother - it'll happen here too.

I assume the disk is large, and that the machine has a lot of RAM?

Root cause: I suck.




From: Andrew Morton <akpm@linux-foundation.org>

invalidate_mapping_pages() can sometimes take a long time (millions of pages
to free).  Long enough for the softlockup detector to trigger.

We used to have a cond_resched() in there but I took it out because the
drop_caches code calls invalidate_mapping_pages() under inode_lock.

The patch adds a nasty flag and puts the cond_resched() back.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/drop_caches.c   |    2 +-
 include/linux/fs.h |    3 +++
 mm/truncate.c      |   38 +++++++++++++++++++++++---------------
 3 files changed, 27 insertions(+), 16 deletions(-)

diff -puN fs/drop_caches.c~invalidate_mapping_pages-add-cond_resched fs/drop_caches.c
--- a/fs/drop_caches.c~invalidate_mapping_pages-add-cond_resched
+++ a/fs/drop_caches.c
@@ -20,7 +20,7 @@ static void drop_pagecache_sb(struct sup
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		if (inode->i_state & (I_FREEING|I_WILL_FREE))
 			continue;
-		invalidate_mapping_pages(inode->i_mapping, 0, -1);
+		__invalidate_mapping_pages(inode->i_mapping, 0, -1, true);
 	}
 	spin_unlock(&inode_lock);
 }
diff -puN include/linux/fs.h~invalidate_mapping_pages-add-cond_resched include/linux/fs.h
--- a/include/linux/fs.h~invalidate_mapping_pages-add-cond_resched
+++ a/include/linux/fs.h
@@ -1583,6 +1583,9 @@ extern int __invalidate_device(struct bl
 extern int invalidate_partition(struct gendisk *, int);
 #endif
 extern int invalidate_inodes(struct super_block *);
+unsigned long __invalidate_mapping_pages(struct address_space *mapping,
+					pgoff_t start, pgoff_t end,
+					bool be_atomic);
 unsigned long invalidate_mapping_pages(struct address_space *mapping,
 					pgoff_t start, pgoff_t end);
 
diff -puN mm/truncate.c~invalidate_mapping_pages-add-cond_resched mm/truncate.c
--- a/mm/truncate.c~invalidate_mapping_pages-add-cond_resched
+++ a/mm/truncate.c
@@ -253,21 +253,8 @@ void truncate_inode_pages(struct address
 }
 EXPORT_SYMBOL(truncate_inode_pages);
 
-/**
- * invalidate_mapping_pages - Invalidate all the unlocked pages of one inode
- * @mapping: the address_space which holds the pages to invalidate
- * @start: the offset 'from' which to invalidate
- * @end: the offset 'to' which to invalidate (inclusive)
- *
- * This function only removes the unlocked pages, if you want to
- * remove all the pages of one inode, you must call truncate_inode_pages.
- *
- * invalidate_mapping_pages() will not block on IO activity. It will not
- * invalidate pages which are dirty, locked, under writeback or mapped into
- * pagetables.
- */
-unsigned long invalidate_mapping_pages(struct address_space *mapping,
-				pgoff_t start, pgoff_t end)
+unsigned long __invalidate_mapping_pages(struct address_space *mapping,
+				pgoff_t start, pgoff_t end, bool be_atomic)
 {
 	struct pagevec pvec;
 	pgoff_t next = start;
@@ -308,9 +295,30 @@ unlock:
 				break;
 		}
 		pagevec_release(&pvec);
+		if (likely(!be_atomic))
+			cond_resched();
 	}
 	return ret;
 }
+
+/**
+ * invalidate_mapping_pages - Invalidate all the unlocked pages of one inode
+ * @mapping: the address_space which holds the pages to invalidate
+ * @start: the offset 'from' which to invalidate
+ * @end: the offset 'to' which to invalidate (inclusive)
+ *
+ * This function only removes the unlocked pages, if you want to
+ * remove all the pages of one inode, you must call truncate_inode_pages.
+ *
+ * invalidate_mapping_pages() will not block on IO activity. It will not
+ * invalidate pages which are dirty, locked, under writeback or mapped into
+ * pagetables.
+ */
+unsigned long invalidate_mapping_pages(struct address_space *mapping,
+				pgoff_t start, pgoff_t end)
+{
+	return __invalidate_mapping_pages(mapping, start, end, false);
+}
 EXPORT_SYMBOL(invalidate_mapping_pages);
 
 /*
_

