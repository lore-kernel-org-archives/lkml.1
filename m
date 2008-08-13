Return-Path: <linux-kernel-owner+w=401wt.eu-S1757307AbYHMIr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307AbYHMIr6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 04:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755781AbYHMIjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 04:39:51 -0400
Received: from smtp.nokia.com ([192.100.122.233]:46406 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755732AbYHMIjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 04:39:48 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Zoltan Sogor <weth@inf.u-szeged.hu>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH] UBIFS: do not union creat_sqnum and del_cmtno
Date: Wed, 13 Aug 2008 13:17:43 +0300
Message-Id: <1218622675-28853-15-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1218622675-28853-1-git-send-email-dedekind@infradead.org>
References: <1218622675-28853-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 13 Aug 2008 08:39:03.0503 (UTC) FILETIME=[0A61EDF0:01C8FD20]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <ext-adrian.hunter@nokia.com>

The values in these two fields need to be preserved independently
and so a union cannot be used.

Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
---
 fs/ubifs/ubifs.h |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index dfb4b93..d342c69 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -374,10 +374,8 @@ struct ubifs_gced_idx_leb {
  */
 struct ubifs_inode {
 	struct inode vfs_inode;
-	union {
-		unsigned long long creat_sqnum;
-		unsigned long long del_cmtno;
-	};
+	unsigned long long creat_sqnum;
+	unsigned long long del_cmtno;
 	unsigned int xattr_size;
 	unsigned int xattr_cnt;
 	unsigned int xattr_names;
-- 
1.5.4.1

