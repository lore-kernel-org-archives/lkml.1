Return-Path: <linux-kernel-owner+w=401wt.eu-S1758482AbYJ2W5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758482AbYJ2W5n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 18:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756514AbYJ2Wq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 18:46:26 -0400
Received: from kroah.org ([198.145.64.141]:56269 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755889AbYJ2WqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 18:46:07 -0400
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: "vijaykumar@bravegnu.org" <vijaykumar@bravegnu.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 37/49] Staging: poch: Block size bug fix
Date: Wed, 29 Oct 2008 15:40:04 -0700
Message-Id: <1225320016-21803-37-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081029223832.GC21657@kroah.com>
References: <20081029223832.GC21657@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: vijaykumar@bravegnu.org <vijaykumar@bravegnu.org>

Block size is to be expressed in no. of 64 bit transfers. But the code
specifies the block size in bytes. Fix this issue.

Signed-off-by: Vijay Kumar <vijaykumar@bravegnu.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/poch/poch.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/poch/poch.c b/drivers/staging/poch/poch.c
index 0e113f9..de3f8c6 100644
--- a/drivers/staging/poch/poch.c
+++ b/drivers/staging/poch/poch.c
@@ -432,7 +432,10 @@ static void channel_dma_init(struct channel_info *channel)
 	}
 
 	printk(KERN_WARNING "block_size, group_size, group_count\n");
-	iowrite32(channel->block_size, fpga + block_size_reg);
+	/*
+	 * Block size is represented in no. of 64 bit transfers.
+	 */
+	iowrite32(channel->block_size / 8, fpga + block_size_reg);
 	iowrite32(channel->group_size / channel->block_size,
 		  fpga + block_count_reg);
 	iowrite32(channel->group_count, fpga + group_count_reg);
-- 
1.6.0.2

