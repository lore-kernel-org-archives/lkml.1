Return-Path: <linux-kernel-owner+w=401wt.eu-S1755218AbZGAStT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbZGAStT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 14:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752456AbZGAStM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 14:49:12 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:63209 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbZGAStL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 14:49:11 -0400
From: Abhishek Kulkarni <adkulkar@umail.iu.edu>
To: linux-kernel@vger.kernel.org
Cc: v9fs-developer@lists.sourceforge.net,
       Abhishek Kulkarni <adkulkar@umail.iu.edu>
Subject: [9P PATCH 1/2] 9p: Fix incorrect parameters to v9fs_file_readn.
Date: Wed,  1 Jul 2009 12:50:53 -0600
Message-Id: <1246474254-10401-1-git-send-email-adkulkar@umail.iu.edu>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix v9fs_vfs_readpage. The offset and size parameters to v9fs_file_readn
were interchanged and hence passed incorrectly.

Signed-off-by: Abhishek Kulkarni <adkulkar@umail.iu.edu>
---
:100644 100644 6fcb1e7... 9282828... M	fs/9p/vfs_addr.c
 fs/9p/vfs_addr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/9p/vfs_addr.c b/fs/9p/vfs_addr.c
index 6fcb1e7..9282828 100644
--- a/fs/9p/vfs_addr.c
+++ b/fs/9p/vfs_addr.c
@@ -57,7 +57,7 @@ static int v9fs_vfs_readpage(struct file *filp, struct page *page)
 	buffer = kmap(page);
 	offset = page_offset(page);
 
-	retval = v9fs_file_readn(filp, buffer, NULL, offset, PAGE_CACHE_SIZE);
+	retval = v9fs_file_readn(filp, buffer, NULL, PAGE_CACHE_SIZE, offset);
 	if (retval < 0)
 		goto done;
 
-- 
1.6.3.3

