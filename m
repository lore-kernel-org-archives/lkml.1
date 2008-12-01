Return-Path: <linux-kernel-owner+w=401wt.eu-S1754191AbYLAMKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191AbYLAMKF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 07:10:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbYLAMJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 07:09:53 -0500
Received: from styx.suse.cz ([82.119.242.94]:36608 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752848AbYLAMJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 07:09:52 -0500
Date: Mon, 1 Dec 2008 13:09:51 +0100
From: Jan Kara <jack@suse.cz>
To: Hannes Eder <hannes@hanneseder.net>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       trivial@kernel.org
Subject: Re: [PATCH] udf: fix sparse warnings
Message-ID: <20081201120951.GD17303@duck.suse.cz>
References: <493049b5.170e660a.26c3.ffff8fd8@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <493049b5.170e660a.26c3.ffff8fd8@mx.google.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 27-11-08 23:12:55, Hannes Eder wrote:
> Fix this sparse warnings:
> 
>   fs/udf/balloc.c:843:3: warning: returning void-valued expression
>   fs/udf/balloc.c:847:3: warning: returning void-valued expression
>   fs/udf/balloc.c:851:3: warning: returning void-valued expression
>   fs/udf/balloc.c:855:3: warning: returning void-valued expression
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>
  Thanks for the patch. But when we are at it, I'd rather go for the
following change:

>From f3facf9a4a60bba9f1fa0c779fc441c6aff90eb4 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Mon, 1 Dec 2008 13:06:10 +0100
Subject: [PATCH] udf: fix sparse warnings:

Fix sparse warnings:

  fs/udf/balloc.c:843:3: warning: returning void-valued expression
  fs/udf/balloc.c:847:3: warning: returning void-valued expression
  fs/udf/balloc.c:851:3: warning: returning void-valued expression
  fs/udf/balloc.c:855:3: warning: returning void-valued expression

Reported-by: Hannes Eder <hannes@hanneseder.net>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/udf/balloc.c |   23 +++++++++--------------
 1 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/fs/udf/balloc.c b/fs/udf/balloc.c
index c0e87db..cde1a0d 100644
--- a/fs/udf/balloc.c
+++ b/fs/udf/balloc.c
@@ -840,24 +840,19 @@ void udf_free_blocks(struct super_block *sb, struct inode *inode,
 	struct udf_part_map *map = &UDF_SB(sb)->s_partmaps[partition];
 
 	if (map->s_partition_flags & UDF_PART_FLAG_UNALLOC_BITMAP) {
-		return udf_bitmap_free_blocks(sb, inode,
-					      map->s_uspace.s_bitmap,
-					      bloc, offset, count);
+		udf_bitmap_free_blocks(sb, inode, map->s_uspace.s_bitmap,
+				       bloc, offset, count);
 	} else if (map->s_partition_flags & UDF_PART_FLAG_UNALLOC_TABLE) {
-		return udf_table_free_blocks(sb, inode,
-					     map->s_uspace.s_table,
-					     bloc, offset, count);
+		udf_table_free_blocks(sb, inode, map->s_uspace.s_table,
+				      bloc, offset, count);
 	} else if (map->s_partition_flags & UDF_PART_FLAG_FREED_BITMAP) {
-		return udf_bitmap_free_blocks(sb, inode,
-					      map->s_fspace.s_bitmap,
-					      bloc, offset, count);
+		udf_bitmap_free_blocks(sb, inode, map->s_fspace.s_bitmap,
+				       bloc, offset, count);
 	} else if (map->s_partition_flags & UDF_PART_FLAG_FREED_TABLE) {
-		return udf_table_free_blocks(sb, inode,
-					     map->s_fspace.s_table,
-					     bloc, offset, count);
-	} else {
-		return;
+		udf_table_free_blocks(sb, inode, map->s_fspace.s_table,
+				      bloc, offset, count);
 	}
+	return;
 }
 
 inline int udf_prealloc_blocks(struct super_block *sb,
-- 
1.6.0.4


