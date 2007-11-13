Return-Path: <linux-kernel-owner+w=401wt.eu-S1755232AbXKMKNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbXKMKNa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 05:13:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753885AbXKMKLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 05:11:11 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:50702 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbXKMKK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 05:10:59 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>, Hugh Dickins <hugh@veritas.com>
Subject: [PATCH 5/9] Unionfs: clear partial read in readpage
Date: Tue, 13 Nov 2007 05:10:24 -0500
Message-Id: <11949486303084-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11949486283697-git-send-email-ezk@cs.sunysb.edu>
References: <11949486283697-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/mmap.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/unionfs/mmap.c b/fs/unionfs/mmap.c
index 468dc61..bb00fd5 100644
--- a/fs/unionfs/mmap.c
+++ b/fs/unionfs/mmap.c
@@ -178,7 +178,8 @@ static int unionfs_do_readpage(struct file *file, struct page *page)
 	err = vfs_read(lower_file, page_data, PAGE_CACHE_SIZE,
 		       &lower_file->f_pos);
 	set_fs(old_fs);
-
+	if (err >= 0 && err < PAGE_CACHE_SIZE)
+		memset(page_data + err, 0, PAGE_CACHE_SIZE - err);
 	kunmap(page);
 
 	if (err < 0)
-- 
1.5.2.2

