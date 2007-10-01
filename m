Return-Path: <linux-kernel-owner+w=401wt.eu-S1755200AbXJAFyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200AbXJAFyz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 01:54:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbXJAFvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 01:51:47 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:40794 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974AbXJAFve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 01:51:34 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 17/19] Unionfs: coding style: avoid multiple assignments on same line
Date: Mon,  1 Oct 2007 01:50:54 -0400
Message-Id: <11912178641006-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <1191217856647-git-send-email-ezk@cs.sunysb.edu>
References: <1191217856647-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/mmap.c  |    3 ++-
 fs/unionfs/super.c |    9 ++++++---
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/unionfs/mmap.c b/fs/unionfs/mmap.c
index ac1a060..6440282 100644
--- a/fs/unionfs/mmap.c
+++ b/fs/unionfs/mmap.c
@@ -179,7 +179,8 @@ static int unionfs_do_readpage(struct file *file, struct page *page)
 	 * may be a little slower, but a lot safer, as the VFS does a lot of
 	 * the necessary magic for us.
 	 */
-	offset = lower_file->f_pos = page_offset(page);
+	lower_file->f_pos = page_offset(page);
+	offset = page_offset(page);
 	old_fs = get_fs();
 	set_fs(KERNEL_DS);
 	err = vfs_read(lower_file, page_data, PAGE_CACHE_SIZE,
diff --git a/fs/unionfs/super.c b/fs/unionfs/super.c
index 0da9181..0a0b075 100644
--- a/fs/unionfs/super.c
+++ b/fs/unionfs/super.c
@@ -477,13 +477,16 @@ static int unionfs_remount_fs(struct super_block *sb, int *flags,
 	 * "add" and "del" commands.  Copy the "options" string because
 	 * strsep modifies the string and we need it later.
 	 */
-	optionstmp = tmp_to_free = kstrdup(options, GFP_KERNEL);
+	tmp_to_free = kstrdup(options, GFP_KERNEL);
+	optionstmp = tmp_to_free;
 	if (unlikely(!optionstmp)) {
 		err = -ENOMEM;
 		goto out_free;
 	}
-	new_branches = cur_branches = sbmax(sb); /* current no. branches */
-	add_branches = del_branches = 0;
+	cur_branches = sbmax(sb); /* current no. branches */
+	new_branches = sbmax(sb);
+	del_branches = 0;
+	add_branches = 0;
 	new_high_branch_id = sbhbid(sb); /* save current high_branch_id */
 	while ((optname = strsep(&optionstmp, ",")) != NULL) {
 		char *optarg;
-- 
1.5.2.2

