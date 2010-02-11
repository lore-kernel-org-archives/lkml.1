Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab0BKMEL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 07:04:11 -0500
Received: from mail.2ka.mipt.ru ([194.85.80.4]:34412 "EHLO mail.2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015Ab0BKMEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 07:04:08 -0500
Content-transfer-encoding: 7BIT
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: jens.axboe@oracle.com, Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/4] block: support compat discard mode by default.
Date: Thu, 11 Feb 2010 13:57:50 +0300
Message-id: <1265885870-21858-1-git-send-email-dmonakhov@openvz.org>
X-Mailer: git-send-email 1.6.6
In-reply-to: <1265885625-21608-1-git-send-email-dmonakhov@openvz.org>
References: <1265885625-21608-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently there are many filesystems which has implemented
discard support, but ssd discs not widely used yet.
Let's allow user to use compat discard mode by default.
After this feature is enabled by default for all devices which has
no native discard support it will be possible to use this feature
simply by passing appropriate mount option to fs (-odiscard in ext4)

This default option has many advantages:
- Hope that this helps in real filesystem testing.
- People who are crazy about data security whould be really happy.
- Virtual machine developers also would like this feature.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 include/linux/blkdev.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index c762c9f..d7d028c 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1010,7 +1010,7 @@ static inline int sb_issue_discard(struct super_block *sb,
 	block <<= (sb->s_blocksize_bits - 9);
 	nr_blocks <<= (sb->s_blocksize_bits - 9);
 	return blkdev_issue_discard(sb->s_bdev, block, nr_blocks, GFP_KERNEL,
-				    DISCARD_FL_BARRIER);
+				    DISCARD_FL_BARRIER|DISCARD_FL_COMPAT);
 }
 
 extern int blk_verify_command(unsigned char *cmd, fmode_t has_write_perm);
-- 
1.6.6

