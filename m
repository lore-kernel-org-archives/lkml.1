Return-Path: <linux-kernel-owner+w=401wt.eu-S932140AbZHFTtI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140AbZHFTtI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 15:49:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756203AbZHFTtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 15:49:06 -0400
Received: from mail-fx0-f228.google.com ([209.85.220.228]:33667 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756018AbZHFTtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 15:49:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=Z4AvAOY7MgPwx/o+YQ6isOg/FlZFMWaTZ/XE+GqSrBxRxbxb69GZJzEsXDroHBXrBK
         DnKtFDYAlk9fuRKcPpAuSXbK9Vp5NNGoyV46yDhmkaR5H76q/ipJojwfKEkbmxvp+Vkd
         /snTSgPt43vbpBjg5kQmUWpOM1ktMmBE4RXfA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Chris Mason <chris.mason@oracle.com>
Subject: [PATCH] btrfs: remove superfluous NULL pointer check in btrfs_rename()
Date: Thu, 6 Aug 2009 21:48:11 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc5-next-20090806; KDE/4.2.4; i686; ; )
Cc: Dan Carpenter <error27@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
       Eugene Teo <eteo@redhat.com>, Julia Lawall <julia@diku.dk>,
       linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908062148.12946.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] btrfs: remove superfluous NULL pointer check in btrfs_rename()

This takes care of the following entry from Dan's list:

fs/btrfs/inode.c +4788 btrfs_rename(36) warning: variable derefenced before check 'old_inode'

Reported-by: Dan Carpenter <error27@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Eugene Teo <eteo@redhat.com>
Cc: Julia Lawall <julia@diku.dk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 fs/btrfs/inode.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: b/fs/btrfs/inode.c
===================================================================
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4785,8 +4785,7 @@ static int btrfs_rename(struct inode *ol
 	 * and the replacement file is large.  Start IO on it now so
 	 * we don't add too much work to the end of the transaction
 	 */
-	if (new_inode && old_inode && S_ISREG(old_inode->i_mode) &&
-	    new_inode->i_size &&
+	if (new_inode && S_ISREG(old_inode->i_mode) && new_inode->i_size &&
 	    old_inode->i_size > BTRFS_ORDERED_OPERATIONS_FLUSH_LIMIT)
 		filemap_flush(old_inode->i_mapping);
 
