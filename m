Return-Path: <linux-kernel-owner+w=401wt.eu-S1757341AbZFDItF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341AbZFDItF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 04:49:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753592AbZFDIsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 04:48:50 -0400
Received: from smtp.nokia.com ([192.100.122.233]:34033 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949AbZFDIst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 04:48:49 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       "Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>
Subject: [PATCH v2 03/17] BFS: do not manipulate s_dirt directly
Date: Thu,  4 Jun 2009 13:41:40 +0300
Message-Id: <1244112114-23144-4-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1244112114-23144-1-git-send-email-dedekind@infradead.org>
References: <1244112114-23144-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 04 Jun 2009 08:48:36.0310 (UTC) FILETIME=[3FA99760:01C9E4F1]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

... use new VFS helpers instead.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Tigran A. Aivazian <tigran@aivazian.fsnet.co.uk>
---
 fs/bfs/inode.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/bfs/inode.c b/fs/bfs/inode.c
index 3a9a136..7ab0792 100644
--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -219,7 +219,7 @@ static void bfs_put_super(struct super_block *s)
 
 	lock_kernel();
 
-	if (s->s_dirt)
+	if (sb_is_dirty(s))
 		bfs_write_super(s);
 
 	brelse(info->si_sbh);
@@ -255,7 +255,7 @@ static void bfs_write_super(struct super_block *s)
 	mutex_lock(&info->bfs_lock);
 	if (!(s->s_flags & MS_RDONLY))
 		mark_buffer_dirty(info->si_sbh);
-	s->s_dirt = 0;
+	mark_sb_clean(s);
 	mutex_unlock(&info->bfs_lock);
 }
 
@@ -464,7 +464,7 @@ static int bfs_fill_super(struct super_block *s, void *data, int silent)
 	brelse(bh);
 	if (!(s->s_flags & MS_RDONLY)) {
 		mark_buffer_dirty(info->si_sbh);
-		s->s_dirt = 1;
+		mark_sb_dirty(s);
 	} 
 	dump_imap("read_super", s);
 	mutex_init(&info->bfs_lock);
-- 
1.6.0.6

