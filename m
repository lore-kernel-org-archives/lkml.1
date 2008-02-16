Return-Path: <linux-kernel-owner+w=401wt.eu-S1763666AbYBPD4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763666AbYBPD4k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 22:56:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756853AbYBPD4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 22:56:32 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:9440 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbYBPD4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 22:56:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=AtVW1RvIr0xC0Hl+/atNDQZNYrtEnmx0NoUyUKgFZp17zFbIqRdRlI8D+JMXx/XOIfmP7oA8Vp4ISuBAgc3gPQrEx31C7IsxtZ4wThhTXiYLpTCsoYKnHaoNjxjc3sc311/n/BWwHRKMQhY2H+aUoSCrMg+Kq39j8DHddsUc7Rk=
Subject: [PATCH] udf: fix sparse warning in namei.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 15 Feb 2008 19:56:30 -0800
Message-Id: <1203134190.7442.42.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's use bsize instead.
fs/udf/namei.c:960:12: warning: symbol 'elen' shadows an earlier one
fs/udf/namei.c:937:15: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/udf/namei.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index 112a5fb..e1c1492 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -957,7 +957,7 @@ static int udf_symlink(struct inode *dir, struct dentry *dentry,
 
 	if (iinfo->i_alloc_type != ICBTAG_FLAG_AD_IN_ICB) {
 		kernel_lb_addr eloc;
-		uint32_t elen;
+		uint32_t bsize;
 
 		block = udf_new_block(inode->i_sb, inode,
 				iinfo->i_location.partitionReferenceNum,
@@ -970,9 +970,9 @@ static int udf_symlink(struct inode *dir, struct dentry *dentry,
 		eloc.logicalBlockNum = block;
 		eloc.partitionReferenceNum =
 				iinfo->i_location.partitionReferenceNum;
-		elen = inode->i_sb->s_blocksize;
-		iinfo->i_lenExtents = elen;
-		udf_add_aext(inode, &epos, eloc, elen, 0);
+		bsize = inode->i_sb->s_blocksize;
+		iinfo->i_lenExtents = bsize;
+		udf_add_aext(inode, &epos, eloc, bsize, 0);
 		brelse(epos.bh);
 
 		block = udf_get_pblock(inode->i_sb, block,
-- 
1.5.4.1.1278.gc75be



