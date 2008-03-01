Return-Path: <linux-kernel-owner+w=401wt.eu-S1757322AbYCAGCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322AbYCAGCy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 01:02:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753059AbYCAGCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 01:02:44 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:58488 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917AbYCAGCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 01:02:43 -0500
Date: Fri, 29 Feb 2008 22:02:31 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 1/6] docbook: fix filesystems.tmpl source files
Message-Id: <20080229220231.721a71b7.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix docbook problems in filesystems.tmpl.
These cause the generated docbook to be incorrect.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 fs/buffer.c          |    3 +--
 fs/jbd/transaction.c |   17 +++++++++--------
 fs/mpage.c           |   11 +++--------
 3 files changed, 13 insertions(+), 18 deletions(-)

--- lin2625-rc3g2-kdoc.orig/fs/mpage.c
+++ lin2625-rc3g2-kdoc/fs/mpage.c
@@ -325,16 +325,12 @@ confused:
 }
 
 /**
- * mpage_readpages - populate an address space with some pages, and
- *                       start reads against them.
- *
+ * mpage_readpages - populate an address space with some pages & start reads against them
  * @mapping: the address_space
  * @pages: The address of a list_head which contains the target pages.  These
  *   pages have their ->index populated and are otherwise uninitialised.
- *
  *   The page at @pages->prev has the lowest file offset, and reads should be
  *   issued in @pages->prev to @pages->next order.
- *
  * @nr_pages: The number of pages at *@pages
  * @get_block: The filesystem's block mapper function.
  *
@@ -360,6 +356,7 @@ confused:
  * So an mpage read of the first 16 blocks of an ext2 file will cause I/O to be
  * submitted in the following order:
  * 	12 0 1 2 3 4 5 6 7 8 9 10 11 13 14 15 16
+ *
  * because the indirect block has to be read to get the mappings of blocks
  * 13,14,15,16.  Obviously, this impacts performance.
  *
@@ -656,9 +653,7 @@ out:
 }
 
 /**
- * mpage_writepages - walk the list of dirty pages of the given
- * address space and writepage() all of them.
- * 
+ * mpage_writepages - walk the list of dirty pages of the given address space & writepage() all of them
  * @mapping: address space structure to write
  * @wbc: subtract the number of written pages from *@wbc->nr_to_write
  * @get_block: the filesystem's block mapper function.
--- lin2625-rc3g2-kdoc.orig/fs/buffer.c
+++ lin2625-rc3g2-kdoc/fs/buffer.c
@@ -627,8 +627,7 @@ repeat:
 }
 
 /**
- * sync_mapping_buffers - write out and wait upon a mapping's "associated"
- *                        buffers
+ * sync_mapping_buffers - write out & wait upon a mapping's "associated" buffers
  * @mapping: the mapping which wants those buffers written
  *
  * Starts I/O against the buffers at mapping->private_list, and waits upon
--- lin2625-rc3g2-kdoc.orig/fs/jbd/transaction.c
+++ lin2625-rc3g2-kdoc/fs/jbd/transaction.c
@@ -369,7 +369,7 @@ out:
 
 
 /**
- * int journal_restart() - restart a handle .
+ * int journal_restart() - restart a handle.
  * @handle:  handle to restart
  * @nblocks: nr credits requested
  *
@@ -844,8 +844,7 @@ out:
 }
 
 /**
- * int journal_get_undo_access() -  Notify intent to modify metadata with
- *     non-rewindable consequences
+ * int journal_get_undo_access() - Notify intent to modify metadata with non-rewindable consequences
  * @handle: transaction
  * @bh: buffer to undo
  * @credits: store the number of taken credits here (if not NULL)
@@ -921,12 +920,14 @@ out:
 }
 
 /**
- * int journal_dirty_data() -  mark a buffer as containing dirty data which
- *                             needs to be flushed before we can commit the
- *                             current transaction.
+ * int journal_dirty_data() - mark a buffer as containing dirty data to be flushed
  * @handle: transaction
  * @bh: bufferhead to mark
  *
+ * Description:
+ * Mark a buffer as containing dirty data which needs to be flushed before
+ * we can commit the current transaction.
+ *
  * The buffer is placed on the transaction's data list and is marked as
  * belonging to the transaction.
  *
@@ -1098,11 +1099,11 @@ no_journal:
 }
 
 /**
- * int journal_dirty_metadata() -  mark a buffer as containing dirty metadata
+ * int journal_dirty_metadata() - mark a buffer as containing dirty metadata
  * @handle: transaction to add buffer to.
  * @bh: buffer to mark
  *
- * mark dirty metadata which needs to be journaled as part of the current
+ * Mark dirty metadata which needs to be journaled as part of the current
  * transaction.
  *
  * The buffer is placed on the transaction's metadata list and is marked
