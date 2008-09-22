Return-Path: <linux-kernel-owner+w=401wt.eu-S1752222AbYIVLAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbYIVLAK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 07:00:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752364AbYIVK6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 06:58:33 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:50116 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544AbYIVK6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 06:58:12 -0400
To: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "dm-devel@redhat.com" <dm-devel@redhat.com>,
       "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
       "xfs@oss.sgi.com" <xfs@oss.sgi.com>,
       "axboe@kernel.dk" <axboe@kernel.dk>,
       "mtk.manpages@googlemail.com" <mtk.manpages@googlemail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/10] reiserfs: Fix error handling in write_super_lockfs/unlockfs
Message-Id: <20080922195701t-sato@mail.jp.nec.com>
Mime-Version: 1.0
X-Mailer: WeMail32[2.51] ID:1K0086
From: Takashi Sato <t-sato@yk.jp.nec.com>
Date: Mon, 22 Sep 2008 19:57:01 +0900
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've changed write_super_lockfs/unlockfs so that they always return
0 (success) to keep a current behavior.

Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
Signed-off-by: Masayuki Hamaguchi <m-hamaguchi@ys.jp.nec.com>
---
 super.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -uprN -X linux-2.6.27-rc7-lockfs-jfs/Documentation/dontdiff linux-2.6.27-rc7-lockfs-jfs/fs/reiserfs/super.c linux-2
.6.27-rc7-lockfs-reiserfs/fs/reiserfs/super.c
--- linux-2.6.27-rc7-lockfs-jfs/fs/reiserfs/super.c	2008-09-22 07:29:55.000000000 +0900
+++ linux-2.6.27-rc7-lockfs-reiserfs/fs/reiserfs/super.c	2008-09-22 11:08:04.000000000 +0900
@@ -83,7 +83,7 @@ static void reiserfs_write_super(struct 
 	reiserfs_sync_fs(s, 1);
 }
 
-static void reiserfs_write_super_lockfs(struct super_block *s)
+static int reiserfs_write_super_lockfs(struct super_block *s)
 {
 	struct reiserfs_transaction_handle th;
 	reiserfs_write_lock(s);
@@ -101,11 +101,13 @@ static void reiserfs_write_super_lockfs(
 	}
 	s->s_dirt = 0;
 	reiserfs_write_unlock(s);
+	return 0;
 }
 
-static void reiserfs_unlockfs(struct super_block *s)
+static int reiserfs_unlockfs(struct super_block *s)
 {
 	reiserfs_allow_writes(s);
+	return 0;
 }
 
 extern const struct in_core_key MAX_IN_CORE_KEY;
