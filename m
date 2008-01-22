Return-Path: <linux-kernel-owner+w=401wt.eu-S1762337AbYAVDSD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762337AbYAVDSD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 22:18:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760281AbYAVDHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 22:07:13 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:32924 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754938AbYAVDHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 22:07:04 -0500
From: "Theodore Ts'o" <tytso@MIT.EDU>
To: linux-kernel@vger.kernel.org
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Mingming Cao <cmm@us.ibm.com>
Subject: [PATCH 43/49] ext4: Check for return value from sb_set_blocksize
Date: Mon, 21 Jan 2008 22:02:22 -0500
Message-Id: <1200970948-17903-44-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.4.rc3.31.g1271-dirty
In-Reply-To: <1200970948-17903-43-git-send-email-tytso@mit.edu>
References: <1200970948-17903-1-git-send-email-tytso@mit.edu>
 <1200970948-17903-2-git-send-email-tytso@mit.edu>
 <1200970948-17903-3-git-send-email-tytso@mit.edu>
 <1200970948-17903-4-git-send-email-tytso@mit.edu>
 <1200970948-17903-5-git-send-email-tytso@mit.edu>
 <1200970948-17903-6-git-send-email-tytso@mit.edu>
 <1200970948-17903-7-git-send-email-tytso@mit.edu>
 <1200970948-17903-8-git-send-email-tytso@mit.edu>
 <1200970948-17903-9-git-send-email-tytso@mit.edu>
 <1200970948-17903-10-git-send-email-tytso@mit.edu>
 <1200970948-17903-11-git-send-email-tytso@mit.edu>
 <1200970948-17903-12-git-send-email-tytso@mit.edu>
 <1200970948-17903-13-git-send-email-tytso@mit.edu>
 <1200970948-17903-14-git-send-email-tytso@mit.edu>
 <1200970948-17903-15-git-send-email-tytso@mit.edu>
 <1200970948-17903-16-git-send-email-tytso@mit.edu>
 <1200970948-17903-17-git-send-email-tytso@mit.edu>
 <1200970948-17903-18-git-send-email-tytso@mit.edu>
 <1200970948-17903-19-git-send-email-tytso@mit.edu>
 <1200970948-17903-20-git-send-email-tytso@mit.edu>
 <1200970948-17903-21-git-send-email-tytso@mit.edu>
 <1200970948-17903-22-git-send-email-tytso@mit.edu>
 <1200970948-17903-23-git-send-email-tytso@mit.edu>
 <1200970948-17903-24-git-send-email-tytso@mit.edu>
 <1200970948-17903-25-git-send-email-tytso@mit.edu>
 <1200970948-17903-26-git-send-email-tytso@mit.edu>
 <1200970948-17903-27-git-send-email-tytso@mit.edu>
 <1200970948-17903-28-git-send-email-tytso@mit.edu>
 <1200970948-17903-29-git-send-email-tytso@mit.edu>
 <1200970948-17903-30-git-send-email-tytso@mit.edu>
 <1200970948-17903-31-git-send-email-tytso@mit.edu>
 <1200970948-17903-32-git-send-email-tytso@mit.edu>
 <1200970948-17903-33-git-send-email-tytso@mit.edu>
 <1200970948-17903-34-git-send-email-tytso@mit.edu>
 <1200970948-17903-35-git-send-email-tytso@mit.edu>
 <1200970948-17903-36-git-send-email-tytso@mit.edu>
 <1200970948-17903-37-git-send-email-tytso@mit.edu>
 <1200970948-17903-38-git-send-email-tytso@mit.edu>
 <1200970948-17903-39-git-send-email-tytso@mit.edu>
 <1200970948-17903-40-git-send-email-tytso@mit.edu>
 <1200970948-17903-41-git-send-email-tytso@mit.edu>
 <1200970948-17903-42-git-send-email-tytso@mit.edu>
 <1200970948-17903-43-git-send-email-tytso@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

sb_set_blocksize validates whether the specfied block size can be used by
the file system. Make sure we fail mounting the file system if the
blocksize specfied cannot be used.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/ext4/super.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 91a11ec..a91e17e 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1809,7 +1809,6 @@ static int ext4_fill_super (struct super_block *sb, void *data, int silent)
 	unsigned long def_mount_opts;
 	struct inode *root;
 	int blocksize;
-	int hblock;
 	int db_count;
 	int i;
 	int needs_recovery;
@@ -1966,20 +1965,16 @@ static int ext4_fill_super (struct super_block *sb, void *data, int silent)
 		goto failed_mount;
 	}
 
-	hblock = bdev_hardsect_size(sb->s_bdev);
 	if (sb->s_blocksize != blocksize) {
-		/*
-		 * Make sure the blocksize for the filesystem is larger
-		 * than the hardware sectorsize for the machine.
-		 */
-		if (blocksize < hblock) {
-			printk(KERN_ERR "EXT4-fs: blocksize %d too small for "
-			       "device blocksize %d.\n", blocksize, hblock);
+
+		/* Validate the filesystem blocksize */
+		if (!sb_set_blocksize(sb, blocksize)) {
+			printk(KERN_ERR "EXT4-fs: bad block size %d.\n",
+					blocksize);
 			goto failed_mount;
 		}
 
 		brelse (bh);
-		sb_set_blocksize(sb, blocksize);
 		logical_sb_block = sb_block * EXT4_MIN_BLOCK_SIZE;
 		offset = do_div(logical_sb_block, blocksize);
 		bh = sb_bread(sb, logical_sb_block);
-- 
1.5.4.rc3.31.g1271-dirty

