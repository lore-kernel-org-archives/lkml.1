Return-Path: <linux-kernel-owner+w=401wt.eu-S1755549AbZKMHHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549AbZKMHHs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 02:07:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755196AbZKMHHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 02:07:44 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:42340 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbZKMHHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 02:07:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=EMgSvglO1BsZg/ja9SKdiuklXZKJDceukVTvUxSs9JOz4OoZGFMmts3o2FiUW/y/nb
         a6yxNAHGLLcV67hnhe5QRDEEoMmKqiZs7uhFZwkZU1WcgmRRQXHu0gus/XsDYRQGOYFA
         /iHOaaFZOMW+mr2nX5wDV9FTxqXunYRRs9D6M=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
       Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] hpfs: Use hweight32
Date: Fri, 13 Nov 2009 16:07:08 +0900
Message-Id: <1258096028-13426-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use hweight32 instead of counting for each bit

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/hpfs/super.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/hpfs/super.c b/fs/hpfs/super.c
index f2feaa0..cf6fe4a 100644
--- a/fs/hpfs/super.c
+++ b/fs/hpfs/super.c
@@ -119,11 +119,8 @@ unsigned hpfs_count_one_bitmap(struct super_block *s, secno secno)
 	unsigned i, count;
 	if (!(bits = hpfs_map_4sectors(s, secno, &qbh, 4))) return 0;
 	count = 0;
-	for (i = 0; i < 2048 / sizeof(unsigned); i++) {
-		unsigned b; 
-		if (!bits[i]) continue;
-		for (b = bits[i]; b; b>>=1) count += b & 1;
-	}
+	for (i = 0; i < 2048 / sizeof(unsigned); i++)
+		count += hweight32(bits[i]);
 	hpfs_brelse4(&qbh);
 	return count;
 }
-- 
1.6.5.1

