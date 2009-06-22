Return-Path: <linux-kernel-owner+w=401wt.eu-S1756768AbZFVTMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768AbZFVTMB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 15:12:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbZFVTLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 15:11:54 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:41144 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbZFVTLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 15:11:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=ttzGYJzY7kiiJoXSsqmsdNcDM/jyxxU+4ZDDl60Ux2gtEjiFFTgI4twEldA+YUuaWo
         iUccyM3M7/r8PLX+BEB7ghMwqhlsAlHjnKEz/bmz05kk1ijHn0pxw9PwZUMCuPdZUuzN
         +ODEfsekYZl3EqF9aTF9jjymG5zLz2IyG2qho=
Message-ID: <4A3FF3BD.1040702@gmail.com>
Date: Mon, 22 Jun 2009 23:12:29 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: jack@suse.cz, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] udf: remove redundant tests on unsigned
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

first_block and goal are unsigned. When negative they are wrapped and caught by
the other test.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/fs/udf/balloc.c b/fs/udf/balloc.c
index e48e9a3..1e06853 100644
--- a/fs/udf/balloc.c
+++ b/fs/udf/balloc.c
@@ -238,7 +238,7 @@ static int udf_bitmap_prealloc_blocks(struct super_block *sb,
 
 	mutex_lock(&sbi->s_alloc_mutex);
 	part_len = sbi->s_partmaps[partition].s_partition_len;
-	if (first_block < 0 || first_block >= part_len)
+	if (first_block >= part_len)
 		goto out;
 
 	if (first_block + block_count > part_len)
@@ -297,7 +297,7 @@ static int udf_bitmap_new_block(struct super_block *sb,
 	mutex_lock(&sbi->s_alloc_mutex);
 
 repeat:
-	if (goal < 0 || goal >= sbi->s_partmaps[partition].s_partition_len)
+	if (goal >= sbi->s_partmaps[partition].s_partition_len)
 		goal = 0;
 
 	nr_groups = bitmap->s_nr_groups;
@@ -666,8 +666,7 @@ static int udf_table_prealloc_blocks(struct super_block *sb,
 	int8_t etype = -1;
 	struct udf_inode_info *iinfo;
 
-	if (first_block < 0 ||
-		first_block >= sbi->s_partmaps[partition].s_partition_len)
+	if (first_block >= sbi->s_partmaps[partition].s_partition_len)
 		return 0;
 
 	iinfo = UDF_I(table);
@@ -743,7 +742,7 @@ static int udf_table_new_block(struct super_block *sb,
 		return newblock;
 
 	mutex_lock(&sbi->s_alloc_mutex);
-	if (goal < 0 || goal >= sbi->s_partmaps[partition].s_partition_len)
+	if (goal >= sbi->s_partmaps[partition].s_partition_len)
 		goal = 0;
 
 	/* We search for the closest matching block to goal. If we find
