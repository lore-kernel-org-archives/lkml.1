Return-Path: <linux-kernel-owner+w=401wt.eu-S1759583AbYAJWMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759583AbYAJWMW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 17:12:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755009AbYAJWMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 17:12:08 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:45356 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756861AbYAJWMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 17:12:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=jkhvlpogKuF2dXvts9oyjqpoeIRA5l9Go4oQUlLReTCpG8iOObCqBNFd7HFuMpujlEKqN/WPQ8WqY9owjnAZkuG7RCEWbob3Z5OchAiNQMEIk/qKTTDNc9Me3URjGAVGTku6gaK1NER6K4KLcuXzXBfrKqUyi/3AMZ9F3kdOmDg=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>, Jan Kara <jack@suse.cz>,
       Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 16/16] udf: improve readability of udf_load_partition
Date: Thu, 10 Jan 2008 23:06:32 +0100
Message-Id: <1200002792-8449-17-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1200002792-8449-1-git-send-email-marcin.slusarz@gmail.com>
References: <1200002792-8449-1-git-send-email-marcin.slusarz@gmail.com>
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: Jan Kara <jack@suse.cz>
CC: Christoph Hellwig <hch@infradead.org>
---
 fs/udf/super.c |   59 ++++++++++++++++++++++++++++---------------------------
 1 files changed, 30 insertions(+), 29 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index 52d2c32..2048351 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1447,44 +1447,45 @@ static int udf_load_partition(struct super_block *sb, kernel_lb_addr *fileset)
 	sbi = UDF_SB(sb);
 
 	for (i = 0; i < ARRAY_SIZE(sbi->s_anchor); i++) {
-		if (sbi->s_anchor[i] &&
-		    (bh = udf_read_tagged(sb, sbi->s_anchor[i],
-					  sbi->s_anchor[i], &ident))) {
-			anchor = (struct anchorVolDescPtr *)bh->b_data;
-
-			/* Locate the main sequence */
-			main_s = le32_to_cpu(
-					anchor->mainVolDescSeqExt.extLocation);
-			main_e = le32_to_cpu(
-					anchor->mainVolDescSeqExt.extLength);
-			main_e = main_e >> sb->s_blocksize_bits;
-			main_e += main_s;
-
-			/* Locate the reserve sequence */
-			reserve_s = le32_to_cpu(
+		if (!sbi->s_anchor[i])
+			continue;
+		bh = udf_read_tagged(sb, sbi->s_anchor[i], sbi->s_anchor[i],
+				     &ident);
+		if (!bh)
+			continue;
+
+		anchor = (struct anchorVolDescPtr *)bh->b_data;
+
+		/* Locate the main sequence */
+		main_s = le32_to_cpu(anchor->mainVolDescSeqExt.extLocation);
+		main_e = le32_to_cpu(anchor->mainVolDescSeqExt.extLength);
+		main_e = main_e >> sb->s_blocksize_bits;
+		main_e += main_s;
+
+		/* Locate the reserve sequence */
+		reserve_s = le32_to_cpu(
 				anchor->reserveVolDescSeqExt.extLocation);
-			reserve_e = le32_to_cpu(
+		reserve_e = le32_to_cpu(
 				anchor->reserveVolDescSeqExt.extLength);
-			reserve_e = reserve_e >> sb->s_blocksize_bits;
-			reserve_e += reserve_s;
+		reserve_e = reserve_e >> sb->s_blocksize_bits;
+		reserve_e += reserve_s;
 
-			brelse(bh);
+		brelse(bh);
 
-			/* Process the main & reserve sequences */
-			/* responsible for finding the PartitionDesc(s) */
-			if (!(udf_process_sequence(sb, main_s, main_e,
-						   fileset) &&
-			      udf_process_sequence(sb, reserve_s, reserve_e,
-						   fileset)))
-				break;
-		}
+		/* Process the main & reserve sequences */
+		/* responsible for finding the PartitionDesc(s) */
+		if (!(udf_process_sequence(sb, main_s, main_e,
+					   fileset) &&
+		      udf_process_sequence(sb, reserve_s, reserve_e,
+					   fileset)))
+			break;
 	}
 
 	if (i == ARRAY_SIZE(sbi->s_anchor)) {
 		udf_debug("No Anchor block found\n");
 		return 1;
-	} else
-		udf_debug("Using anchor in block %d\n", sbi->s_anchor[i]);
+	}
+	udf_debug("Using anchor in block %d\n", sbi->s_anchor[i]);
 
 	for (i = 0; i < sbi->s_partitions; i++) {
 		kernel_lb_addr uninitialized_var(ino);
-- 
1.5.3.7

