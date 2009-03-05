Return-Path: <linux-kernel-owner+w=401wt.eu-S1757970AbZCETSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970AbZCETSe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 14:18:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757396AbZCETRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 14:17:44 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:36749 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757718AbZCETRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 14:17:43 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH v2 12/15] NULL noise: fs/super.c
Date: Thu, 05 Mar 2009 20:17:29 +0100
Message-ID: <20090305191722.30062.9528.stgit@f10box.hanneseder.net>
In-Reply-To: <20090305190954.30062.44759.stgit@f10box.hanneseder.net>
References: <20090305190954.30062.44759.stgit@f10box.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: trivial@kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warning:
  fs/super.c:849:26: warning: Using plain integer as NULL pointer

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
v2: other subject, as suggested by Al Viro

 fs/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index c38eef4..c6ad02d 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -846,7 +846,7 @@ void kill_block_super(struct super_block *sb)
 	struct block_device *bdev = sb->s_bdev;
 	fmode_t mode = sb->s_mode;
 
-	bdev->bd_super = 0;
+	bdev->bd_super = NULL;
 	generic_shutdown_super(sb);
 	sync_blockdev(bdev);
 	close_bdev_exclusive(bdev, mode);

