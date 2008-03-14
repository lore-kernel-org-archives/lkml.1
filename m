Return-Path: <linux-kernel-owner+w=401wt.eu-S1753112AbYCNFVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbYCNFVt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 01:21:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753616AbYCNFVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 01:21:13 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:24244 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757853AbYCNFVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 01:21:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=UQDzsHndaw35b83ve7goHj2i+JSHojhIcOAhBLi3AIZXEGS+LeyDficlcTxm+YmwohmkA2tqMP8yzb/9gVqfpn+ghWWU0Oulkb6km3DJ8pMQzvpG4dv29SbPxPYS3EQ8Y2ZDv4Ws7xzo/j98SbLRNsTGJ5YaHeuXpehSQnknG/U=
Subject: [PATCH 07/10] fuse: use clamp() rather than nested min/max
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 13 Mar 2008 22:21:10 -0700
Message-Id: <1205472070.19712.24.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clamp() exists for this use.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/fuse/file.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 676b0bc..8c6d51d 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -613,7 +613,7 @@ static int fuse_get_user_pages(struct fuse_req *req, const char __user *buf,
 
 	nbytes = min(nbytes, (unsigned) FUSE_MAX_PAGES_PER_REQ << PAGE_SHIFT);
 	npages = (nbytes + offset + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	npages = min(max(npages, 1), FUSE_MAX_PAGES_PER_REQ);
+	npages = clamp(npages, 1, FUSE_MAX_PAGES_PER_REQ);
 	down_read(&current->mm->mmap_sem);
 	npages = get_user_pages(current, current->mm, user_addr, npages, write,
 				0, req->pages, NULL);
-- 
1.5.4.4.653.g7cf1e


