Return-Path: <linux-kernel-owner+w=401wt.eu-S1762442AbZLKEiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762442AbZLKEiN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:38:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762379AbZLKEhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:37:31 -0500
Received: from kroah.org ([198.145.64.141]:37134 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762283AbZLKEgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:36:45 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:28:18 2009
Message-Id: <20091211042818.062493875@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:25:59 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dmitry Monakhov <dmonakhov@openvz.org>, Mingming Cao <cmm@us.ibm.com>,
       "Theodore Tso" <tytso@mit.edu>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [81/90] ext4: ext4_get_reserved_space() must return bytes instead of blocks
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0081-ext4-ext4_get_reserved_space-must-return-bytes-inste.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

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
@@ -1053,7 +1053,7 @@ qsize_t ext4_get_reserved_space(struct i
 		EXT4_I(inode)->i_reserved_meta_blocks;
 	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 
-	return total;
+	return (total << inode->i_blkbits);
 }
 /*
  * Calculate the number of metadata blocks need to reserve


