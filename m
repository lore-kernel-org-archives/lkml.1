Return-Path: <linux-kernel-owner+w=401wt.eu-S932490AbZKBU6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490AbZKBU6s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 15:58:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932442AbZKBU6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 15:58:48 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:44381 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932387AbZKBU6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 15:58:47 -0500
Date: Mon, 2 Nov 2009 21:58:47 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: sandeen@redhat.com, cmm@us.ibm.com, "Theodore Ts'o" <tytso@mit.edu>,
       Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] fs/ext4: test the i_flags field of the right structure
Message-ID: <Pine.LNX.4.64.0911022158190.4930@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Elsewhere, EXT4_EXTENTS_FL is combined with EXT4_I(inode)->i_flags, rather
than inode->i_flags.

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 fs/ext4/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 5c5bc5d..c0e34ab 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2787,7 +2787,7 @@ static int ext4_da_writepages_trans_blocks(struct inode *inode)
 	 * number of contiguous block. So we will limit
 	 * number of contiguous block to a sane value
 	 */
-	if (!(inode->i_flags & EXT4_EXTENTS_FL) &&
+	if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL) &&
 	    (max_blocks > EXT4_MAX_TRANS_DATA))
 		max_blocks = EXT4_MAX_TRANS_DATA;
 
