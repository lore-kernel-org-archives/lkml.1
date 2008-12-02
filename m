Return-Path: <linux-kernel-owner+w=401wt.eu-S1754271AbYLBWKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271AbYLBWKl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 17:10:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753300AbYLBWKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 17:10:16 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:35239 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111AbYLBWKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 17:10:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=WCAYNejOCO0GI506UtY9VDbW8b/ON60q2yS6BZLIupxByD3T0q8oWwcoXZ+e++7H5N
         91GvkHmN3mAjOrGOqrJ/LuD/u2cWAjT4ty8vk7H7CO/ONqNEXrHJEW3bCnbHqqhP5rhU
         ankbslf+DvQcaR2/rk3pKjVNPKoy2wDVhj3d8=
Message-ID: <4935B249.6020906@gmail.com>
Date: Tue, 02 Dec 2008 23:10:17 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: jack@suse.cz
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] udf: in scan_anchors() sector_t last[] is unsigned and cannot
 be negative.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sector_t last[] is unsigned and cannot be negative.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Maybe you can suggest a less ugly solution?

diff --git a/fs/udf/super.c b/fs/udf/super.c
index e25e701..d53c6fc 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -721,7 +721,7 @@ static sector_t udf_scan_anchors(struct super_block *sb, sector_t lastblock)
 	 *  however, if the disc isn't closed, it could be 512 */
 
 	for (i = 0; i < ARRAY_SIZE(last); i++) {
-		if (last[i] < 0)
+		if (last[i] > last[0] + 1)
 			continue;
 		if (last[i] >= sb->s_bdev->bd_inode->i_size >>
 				sb->s_blocksize_bits)

