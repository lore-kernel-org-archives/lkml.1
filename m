Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab0BOLQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 06:16:17 -0500
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:64848 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753986Ab0BOLQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 06:16:16 -0500
Subject: [PATCH] fs: inode - remove 8 bytes of padding on 64bits allowing 1
 more objects/slab under slub
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Matthew Wilcox <matthew@wil.cx>, Al Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
       Christoph Hellwig <hch@lst.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Feb 2010 11:16:11 +0000
Message-ID: <1266232571.2149.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes 8 bytes of padding from struct inode on 64bit builds, and
so allows 1 more object/slab in the inode_cache when using slub.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
----
patch against 2.6.33-rc8
compiled & tested on x86_64 AMDX2 

I've been running this patch for over a week with no obvious problems
regards
Richard


diff --git a/include/linux/fs.h b/include/linux/fs.h
index b1bcb27..ebb1cd5 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -729,6 +729,7 @@ struct inode {
 	uid_t			i_uid;
 	gid_t			i_gid;
 	dev_t			i_rdev;
+	unsigned int		i_blkbits;
 	u64			i_version;
 	loff_t			i_size;
 #ifdef __NEED_I_SIZE_ORDERED
@@ -738,7 +739,6 @@ struct inode {
 	struct timespec		i_mtime;
 	struct timespec		i_ctime;
 	blkcnt_t		i_blocks;
-	unsigned int		i_blkbits;
 	unsigned short          i_bytes;
 	umode_t			i_mode;
 	spinlock_t		i_lock;	/* i_blocks, i_bytes, maybe i_size */


