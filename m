Return-Path: <linux-kernel-owner+w=401wt.eu-S1751771AbYBCShX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771AbYBCShX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 13:37:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751274AbYBCShF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 13:37:05 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:28629 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbYBCShB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 13:37:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=ugK2S4GqzSC1mhpWxIFCLFEAg+i8DXbbu1ryEBiu9T15HOE4Ys/4cw8FMDhtt40o4DaX6r5atqnOf+Cu7c5qFl61urVUp8EVjOAFsxzOu1S7qvrbxYXrg2jk9uX+9K7AbhCJH5aNyD/7Ilk0wz1B4AByiWXIm69SRfkUXQwOH0w=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>, Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 1/6] udf: udf_get_block, inode_bmap - remove unneeded checks
Date: Sun,  3 Feb 2008 19:36:06 +0100
Message-Id: <1202063771-18172-2-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1202063771-18172-1-git-send-email-marcin.slusarz@gmail.com>
References: <1202063771-18172-1-git-send-email-marcin.slusarz@gmail.com>
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

block cannot be less than 0, because it's sector_t,
so remove unneeded checks

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Jan Kara <jack@suse.cz>
---
 fs/udf/inode.c |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index c2d0477..531443d 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -323,9 +323,6 @@ static int udf_get_block(struct inode *inode, sector_t block,
 
 	lock_kernel();
 
-	if (block < 0)
-		goto abort_negative;
-
 	iinfo = UDF_I(inode);
 	if (block == iinfo->i_next_alloc_block + 1) {
 		iinfo->i_next_alloc_block++;
@@ -347,10 +344,6 @@ static int udf_get_block(struct inode *inode, sector_t block,
 abort:
 	unlock_kernel();
 	return err;
-
-abort_negative:
-	udf_warning(inode->i_sb, "udf_get_block", "block < 0");
-	goto abort;
 }
 
 static struct buffer_head *udf_getblk(struct inode *inode, long block,
@@ -2081,11 +2074,6 @@ int8_t inode_bmap(struct inode *inode, sector_t block,
 	int8_t etype;
 	struct udf_inode_info *iinfo;
 
-	if (block < 0) {
-		printk(KERN_ERR "udf: inode_bmap: block < 0\n");
-		return -1;
-	}
-
 	iinfo = UDF_I(inode);
 	pos->offset = 0;
 	pos->block = iinfo->i_location;
-- 
1.5.3.7

