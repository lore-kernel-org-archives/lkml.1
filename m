Return-Path: <linux-kernel-owner+w=401wt.eu-S1030810AbXCNJVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030810AbXCNJVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 05:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030771AbXCNJVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 05:21:07 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60565 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030819AbXCNJUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 05:20:31 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH 16/17] paride endianness annotations
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1HRPeo-0003bv-2f@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 14 Mar 2007 09:20:30 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/block/paride/pd.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/block/paride/pd.c b/drivers/block/paride/pd.c
index 99e2c8c..31e0148 100644
--- a/drivers/block/paride/pd.c
+++ b/drivers/block/paride/pd.c
@@ -663,11 +663,11 @@ static enum action pd_identify(struct pd_unit *disk)
 		return Fail;
 	pi_read_block(disk->pi, pd_scratch, 512);
 	disk->can_lba = pd_scratch[99] & 2;
-	disk->sectors = le16_to_cpu(*(u16 *) (pd_scratch + 12));
-	disk->heads = le16_to_cpu(*(u16 *) (pd_scratch + 6));
-	disk->cylinders = le16_to_cpu(*(u16 *) (pd_scratch + 2));
+	disk->sectors = le16_to_cpu(*(__le16 *) (pd_scratch + 12));
+	disk->heads = le16_to_cpu(*(__le16 *) (pd_scratch + 6));
+	disk->cylinders = le16_to_cpu(*(__le16 *) (pd_scratch + 2));
 	if (disk->can_lba)
-		disk->capacity = le32_to_cpu(*(u32 *) (pd_scratch + 120));
+		disk->capacity = le32_to_cpu(*(__le32 *) (pd_scratch + 120));
 	else
 		disk->capacity = disk->sectors * disk->heads * disk->cylinders;
 
-- 
1.5.0-rc2.GIT


