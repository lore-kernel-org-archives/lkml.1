Return-Path: <linux-kernel-owner+w=401wt.eu-S1754566AbZARWp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbZARWp1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 17:45:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbZARWpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 17:45:15 -0500
Received: from mail-ew0-f20.google.com ([209.85.219.20]:60907 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbZARWpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 17:45:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=TooS+axavpV+IqYB7Rh/T1LIPJgefyAoMjJZnJHOW0nppXmCJ+XevZpW1UQmuPhQsD
         CmrnRGMW+8zreR1Kh8GiV1eFoqU4QNoemZAo+7h5355gvIUukbZPQlOVwsd25tlwSGea
         9TFWeopUnQ9XxRRVKodzpz+NpDgUrjA0Auq2I=
Message-ID: <4973B0F9.7010603@gmail.com>
Date: Sun, 18 Jan 2009 23:45:13 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: jack@suse.cz
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] sector_t last is unsigned, so cannot be less than 0.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sector_t last is unsigned, so cannot be less than 0.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/fs/udf/super.c b/fs/udf/super.c
index e25e701..1f3941d 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -721,7 +721,7 @@ static sector_t udf_scan_anchors(struct super_block *sb, sector_t lastblock)
 	 *  however, if the disc isn't closed, it could be 512 */
 
 	for (i = 0; i < ARRAY_SIZE(last); i++) {
-		if (last[i] < 0)
+		if (last[i] > lastblock + 1)
 			continue;
 		if (last[i] >= sb->s_bdev->bd_inode->i_size >>
 				sb->s_blocksize_bits)
