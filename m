Return-Path: <linux-kernel-owner+w=401wt.eu-S1760103AbYHaNR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760103AbYHaNR7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 09:17:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759625AbYHaNPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 09:15:05 -0400
Received: from smtp.nokia.com ([192.100.105.134]:44051 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759606AbYHaNPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 09:15:03 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-fsdevel-owner@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <ext-adrian.hunter@nokia.com>
Subject: [PATCH] UBIFS: introduce LEB overhead
Date: Sun, 31 Aug 2008 17:52:44 +0300
Message-Id: <1220194366-12731-11-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1220194366-12731-1-git-send-email-dedekind@infradead.org>
References: <1220194366-12731-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 31 Aug 2008 13:14:26.0103 (UTC) FILETIME=[7E0E1C70:01C90B6B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

This is a preparational patch for the following statfs()
report fix.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/ubifs/super.c |    6 ++++++
 fs/ubifs/ubifs.h |    5 +++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 1018053..be23fd3 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -530,6 +530,12 @@ static int init_constants_early(struct ubifs_info *c)
 	c->dead_wm = ALIGN(MIN_WRITE_SZ, c->min_io_size);
 	c->dark_wm = ALIGN(UBIFS_MAX_NODE_SZ, c->min_io_size);
 
+	/*
+	 * Calculate how many bytes would be wasted at the end of LEB if it was
+	 * fully filled with data nodes of maximum size. This is used in
+	 * calculations when reporting free space.
+	 */
+	c->leb_overhead = c->leb_size % UBIFS_MAX_DATA_NODE_SZ;
 	return 0;
 }
 
diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index 681d46e..57e5854 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -995,6 +995,9 @@ struct ubifs_mount_opts {
  * @max_idx_node_sz: maximum indexing node aligned on 8-bytes boundary
  * @max_inode_sz: maximum possible inode size in bytes
  * @max_znode_sz: size of znode in bytes
+ *
+ * @leb_overhead: how many bytes are wasted in an LEB when it is filled with
+ *                data nodes of maximum size - used in free space reporting
  * @dead_wm: LEB dead space watermark
  * @dark_wm: LEB dark space watermark
  * @block_cnt: count of 4KiB blocks on the FS
@@ -1226,6 +1229,8 @@ struct ubifs_info {
 	int max_idx_node_sz;
 	long long max_inode_sz;
 	int max_znode_sz;
+
+	int leb_overhead;
 	int dead_wm;
 	int dark_wm;
 	int block_cnt;
-- 
1.5.4.1

