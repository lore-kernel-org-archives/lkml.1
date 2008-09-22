Return-Path: <linux-kernel-owner+w=401wt.eu-S1753401AbYIVK7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbYIVK7a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 06:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753563AbYIVK6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 06:58:18 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:50100 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529AbYIVK6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 06:58:11 -0400
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
Subject: [PATCH 4/10] xfs: Fix error handling in write_super_lockfs/unlockfs
Message-Id: <20080922195637t-sato@mail.jp.nec.com>
Mime-Version: 1.0
X-Mailer: WeMail32[2.51] ID:1K0086
From: Takashi Sato <t-sato@yk.jp.nec.com>
Date: Mon, 22 Sep 2008 19:56:37 +0900
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
 xfs_super.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -uprN -X linux-2.6.27-rc7-lockfs/Documentation/dontdiff linux-2.6.27-rc7-lockfs/fs/xfs/linux-2.6/xfs_super.c linux-
2.6.27-rc7-lockfs-xfs/fs/xfs/linux-2.6/xfs_super.c
--- linux-2.6.27-rc7-lockfs/fs/xfs/linux-2.6/xfs_super.c	2008-09-22 07:29:55.000000000 +0900
+++ linux-2.6.27-rc7-lockfs-xfs/fs/xfs/linux-2.6/xfs_super.c	2008-09-22 10:13:39.000000000 +0900
@@ -1351,7 +1351,7 @@ xfs_fs_remount(
  * need to take care of themetadata. Once that's done write a dummy
  * record to dirty the log in case of a crash while frozen.
  */
-STATIC void
+STATIC int
 xfs_fs_lockfs(
 	struct super_block	*sb)
 {
@@ -1359,6 +1359,7 @@ xfs_fs_lockfs(
 
 	xfs_attr_quiesce(mp);
 	xfs_fs_log_dummy(mp);
+	return 0;
 }
 
 STATIC int
