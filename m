Return-Path: <linux-kernel-owner+w=401wt.eu-S1757844AbYFLRyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757844AbYFLRyT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 13:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755794AbYFLRyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 13:54:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55031 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751839AbYFLRyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 13:54:03 -0400
Date: Thu, 12 Jun 2008 13:53:53 -0400
From: Rik van Riel <riel@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: [PATCH] undo the brd.c part of
 ramfs-and-ram-disk-pages-are-unevictable.patch
Message-ID: <20080612135353.2d17436a@cuia.bos.redhat.com>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Undo the brd.c part of ramfs-and-ram-disk-pages-are-unevictable.patch.
The brd pages do not live on the LRU at all, so there is no need to
play these tricks.

Debugged-by: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Rik van Riel <riel@redhat.com>

---
 drivers/block/brd.c |   13 -------------
 1 file changed, 13 deletions(-)

Index: linux-2.6.26-rc5-mm2/drivers/block/brd.c
===================================================================
--- linux-2.6.26-rc5-mm2.orig/drivers/block/brd.c	2008-06-11 14:39:43.000000000 -0400
+++ linux-2.6.26-rc5-mm2/drivers/block/brd.c	2008-06-12 13:49:18.000000000 -0400
@@ -374,21 +374,8 @@ static int brd_ioctl(struct inode *inode
 	return error;
 }
 
-/*
- * brd_open():
- * Just mark the mapping as containing unevictable pages
- */
-static int brd_open(struct inode *inode, struct file *filp)
-{
-	struct address_space *mapping = inode->i_mapping;
-
-	mapping_set_unevictable(mapping);
-	return 0;
-}
-
 static struct block_device_operations brd_fops = {
 	.owner =		THIS_MODULE,
-	.open  =		brd_open,
 	.ioctl =		brd_ioctl,
 #ifdef CONFIG_BLK_DEV_XIP
 	.direct_access =	brd_direct_access,

