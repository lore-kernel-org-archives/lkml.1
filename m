Return-Path: <linux-kernel-owner+w=401wt.eu-S1756285AbZLKFdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285AbZLKFdh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 00:33:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754575AbZLKF35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 00:29:57 -0500
Received: from kroah.org ([198.145.64.141]:53486 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544AbZLKF3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 00:29:49 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 21:25:47 2009
Message-Id: <20091211052546.544464652@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 21:23:24 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Julia Lawall <julia@diku.dk>, "Theodore Tso" <tytso@mit.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [12/34] ext4: fix i_flags access in ext4_da_writepages_trans_blocks()
References: <20091211052312.805428372@linux.site>
Content-Disposition: inline; filename=0008-ext4-fix-i_flags-access-in-ext4_da_writepages_trans_.patch
In-Reply-To: <20091211052858.GA23229@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

(cherry picked from commit 30c6e07a92ea4cb87160d32ffa9bce172576ae4c)

We need to be testing the i_flags field in the ext4 specific portion
of the inode, instead of the (confusingly aliased) i_flags field in
the generic struct inode.

Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2788,7 +2788,7 @@ static int ext4_da_writepages_trans_bloc
 	 * number of contiguous block. So we will limit
 	 * number of contiguous block to a sane value
 	 */
-	if (!(inode->i_flags & EXT4_EXTENTS_FL) &&
+	if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL) &&
 	    (max_blocks > EXT4_MAX_TRANS_DATA))
 		max_blocks = EXT4_MAX_TRANS_DATA;
 


