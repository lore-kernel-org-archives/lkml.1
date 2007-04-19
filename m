Return-Path: <linux-kernel-owner+w=401wt.eu-S1766866AbXDSQhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766866AbXDSQhB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 12:37:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766862AbXDSQgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 12:36:53 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:51452 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1766867AbXDSQfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 12:35:46 -0400
From: Christoph Lameter <clameter@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Paul Jackson <pj@sgi.com>, Dave Chinner <dgc@sgi.com>,
       Christoph Lameter <clameter@sgi.com>
Message-Id: <20070419163545.11948.60373.sendpatchset@schroedinger.engr.sgi.com>
In-Reply-To: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com>
References: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com>
Subject: [RFC 8/8] Add some debug output
Date: Thu, 19 Apr 2007 09:35:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Debugging patch

Show some output as to what is going on.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 fs/ramfs/inode.c |    1 +
 mm/filemap.c     |    8 ++++++++
 2 files changed, 9 insertions(+)

Index: linux-2.6.21-rc7/fs/ramfs/inode.c
===================================================================
--- linux-2.6.21-rc7.orig/fs/ramfs/inode.c	2007-04-19 09:14:35.000000000 -0700
+++ linux-2.6.21-rc7/fs/ramfs/inode.c	2007-04-19 09:14:42.000000000 -0700
@@ -174,6 +174,7 @@ static int ramfs_fill_super(struct super
 	if (options && *options)
 		order = simple_strtoul(options, NULL, 10);
 
+	printk(KERN_ERR "ramfs_fill_super: '%s' order=%d\n", options, order);
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
 	sb->s_blocksize = PAGE_CACHE_SIZE << order;
 	sb->s_blocksize_bits = order + PAGE_CACHE_SHIFT;
Index: linux-2.6.21-rc7/mm/filemap.c
===================================================================
--- linux-2.6.21-rc7.orig/mm/filemap.c	2007-04-19 09:14:16.000000000 -0700
+++ linux-2.6.21-rc7/mm/filemap.c	2007-04-19 09:16:45.000000000 -0700
@@ -121,6 +121,10 @@ void __remove_from_page_cache(struct pag
 	mapping->nrpages--;
 	__mod_zone_page_state(page_zone(page), NR_FILE_PAGES,
 			-(1 << mapping->order));
+
+	if (mapping->order)
+		printk(KERN_ERR "Removing page %p order %d from pagecache\n",
+				page, mapping->order);
 }
 
 void remove_from_page_cache(struct page *page)
@@ -451,6 +455,10 @@ int add_to_page_cache(struct page *page,
 			mapping->nrpages++;
 			__mod_zone_page_state(page_zone(page), NR_FILE_PAGES,
 					1 << mappig->order);
+
+			if (mapping->order)
+				printk(KERN_ERR "add_to_page_cache page %p order=%d\n",
+						page, mapping->order);
 		}
 		write_unlock_irq(&mapping->tree_lock);
 		radix_tree_preload_end();
