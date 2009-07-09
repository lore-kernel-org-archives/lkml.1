Return-Path: <linux-kernel-owner+w=401wt.eu-S1760633AbZGIHDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760633AbZGIHDs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 03:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760031AbZGIHA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 03:00:26 -0400
Received: from smtp.nokia.com ([192.100.105.134]:41776 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756620AbZGIHAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 03:00:23 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Al Viro <viro@ZenIV.linux.org.uk>, Jens Axboe <jens.axboe@oracle.com>
Cc: linux-fsdevel@vger.kernel.org,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 09 Jul 2009 11:50:20 +0300
Message-Id: <20090709085020.12122.31230.sendpatchset@localhost.localdomain>
In-Reply-To: <20090709084822.12122.79749.sendpatchset@localhost.localdomain>
References: <20090709084822.12122.79749.sendpatchset@localhost.localdomain>
Subject: [PATCH v3 17/18] rename s_dirt to s_dirty
X-OriginalArrivalTime: 09 Jul 2009 06:59:49.0087 (UTC) FILETIME=[D997A6F0:01CA0062]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to make sure no one uses 's_dirt' directly any more,
re-name it to 's_dirty'.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 include/linux/fs.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index d98d8d1..7882a61 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1315,7 +1315,7 @@ struct super_block {
 	dev_t			s_dev;		/* search index; _not_ kdev_t */
 	unsigned long		s_blocksize;
 	unsigned char		s_blocksize_bits;
-	unsigned char		s_dirt;
+	unsigned char		s_dirty;
 	unsigned long long	s_maxbytes;	/* Max file size */
 	struct file_system_type	*s_type;
 	const struct super_operations	*s_op;
@@ -1795,15 +1795,15 @@ int __put_super_and_need_restart(struct super_block *sb);
  */
 static inline void mark_sb_dirty(struct super_block *sb)
 {
-	sb->s_dirt = 1;
+	sb->s_dirty = 1;
 }
 static inline void mark_sb_clean(struct super_block *sb)
 {
-	sb->s_dirt = 0;
+	sb->s_dirty = 0;
 }
 static inline int is_sb_dirty(struct super_block *sb)
 {
-	return sb->s_dirt;
+	return sb->s_dirty;
 }
 
 /* Alas, no aliases. Too much hassle with bringing module.h everywhere */
-- 
1.6.0.6

