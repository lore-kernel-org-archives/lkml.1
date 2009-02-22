Return-Path: <linux-kernel-owner+w=401wt.eu-S1756865AbZBVAMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865AbZBVAMe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 19:12:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756712AbZBVAMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 19:12:22 -0500
Received: from mail-fx0-f167.google.com ([209.85.220.167]:51713 "EHLO
	mail-fx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755985AbZBVAMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 19:12:20 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 11/16] fs/super.c: fix sparse warning: Using plain integer as
	NULL pointer
To: trivial@kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 22 Feb 2009 01:05:03 +0100
Message-ID: <20090222000459.17557.20005.stgit@vmbox.hanneseder.net>
In-Reply-To: <20090221235706.17557.97714.stgit@vmbox.hanneseder.net>
References: <20090221235706.17557.97714.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warning:
  fs/super.c:849:26: warning: Using plain integer as NULL pointer

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
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

