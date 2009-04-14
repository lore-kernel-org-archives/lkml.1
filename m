Return-Path: <linux-kernel-owner+w=401wt.eu-S1756177AbZDNNwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177AbZDNNwi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 09:52:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753220AbZDNNw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 09:52:28 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:48835 "EHLO
	teyla.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753059AbZDNNw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 09:52:27 -0400
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       Ben Dooks <ben-linux@fluff.org>
Subject: [PATCH] fs/super.c: Fix cast of 0 to pointer.
Date: Tue, 14 Apr 2009 14:48:49 +0100
Message-Id: <1239716929-29202-1-git-send-email-ben-linux@fluff.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following warning in fs/super.c:

900:19: warning: Using plain integer as NULL pointer.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
---
 fs/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 786fe7d..14e59bc 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -897,7 +897,7 @@ void kill_block_super(struct super_block *sb)
 	struct block_device *bdev = sb->s_bdev;
 	fmode_t mode = sb->s_mode;
 
-	bdev->bd_super = 0;
+	bdev->bd_super = NULL;
 	generic_shutdown_super(sb);
 	sync_blockdev(bdev);
 	close_bdev_exclusive(bdev, mode);
-- 
1.5.6.5

