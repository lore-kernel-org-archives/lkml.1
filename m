Return-Path: <linux-kernel-owner+w=401wt.eu-S1762944AbXFJTFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762944AbXFJTFl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 15:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755925AbXFJTFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 15:05:34 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:39373 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755437AbXFJTFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 15:05:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=T+jV+Mp6tzJT6y4rFub2B8iCFaJ2KOMyawGb5AIVM/5VXWFJ9pIInlkS//XAxupMhmwzKV9X0xHbjQ8nlDQs2zuCj02ArTlr+7Bbf4tPXszNdWxQwzygA2iCe5/6NJlAUWnkwUJfsdECsVXpjey6f3Cg9e4L+uPutrnuyJU78T4=
Date: Sun, 10 Jun 2007 23:09:52 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org, miklos@szeredi.hu
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] fuse: ->fs_flags fixlet
Message-ID: <20070610190952.GA5708@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

fs/fuse/inode.c:658:3: error: Initializer entry defined twice
fs/fuse/inode.c:661:3:   also defined here

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/fuse/inode.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -655,10 +655,9 @@ static int fuse_get_sb_blk(struct file_system_type *fs_type,
 static struct file_system_type fuseblk_fs_type = {
 	.owner		= THIS_MODULE,
 	.name		= "fuseblk",
-	.fs_flags	= FS_HAS_SUBTYPE,
 	.get_sb		= fuse_get_sb_blk,
 	.kill_sb	= kill_block_super,
-	.fs_flags	= FS_REQUIRES_DEV,
+	.fs_flags	= FS_REQUIRES_DEV | FS_HAS_SUBTYPE,
 };
 
 static inline int register_fuseblk(void)

