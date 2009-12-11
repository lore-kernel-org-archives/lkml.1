Return-Path: <linux-kernel-owner+w=401wt.eu-S933379AbZLKFbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933379AbZLKFbH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 00:31:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755236AbZLKFaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 00:30:11 -0500
Received: from kroah.org ([198.145.64.141]:53599 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754897AbZLKFaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 00:30:05 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 21:25:56 2009
Message-Id: <20091211052556.043172197@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 21:23:41 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dmitry Monakhov <dmonakhov@openvz.org>, Mingming Cao <cmm@us.ibm.com>,
       "Theodore Tso" <tytso@mit.edu>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [29/34] ext4: ext4_get_reserved_space() must return bytes instead of blocks
References: <20091211052312.805428372@linux.site>
Content-Disposition: inline; filename=0025-ext4-ext4_get_reserved_space-must-return-bytes-inste.patch
In-Reply-To: <20091211052858.GA23229@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

(cherry picked from commit 8aa6790f876e81f5a2211fe1711a5fe3fe2d7b20)

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Acked-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1052,7 +1052,7 @@ qsize_t ext4_get_reserved_space(struct i
 		EXT4_I(inode)->i_reserved_meta_blocks;
 	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 
-	return total;
+	return (total << inode->i_blkbits);
 }
 /*
  * Calculate the number of metadata blocks need to reserve


