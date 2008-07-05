Return-Path: <linux-kernel-owner+w=401wt.eu-S1758977AbYGERvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758977AbYGERvE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 13:51:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756678AbYGERiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 13:38:22 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:33096 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755961AbYGERgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 13:36:32 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Mingming Cao <cmm@us.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 21/52] ext4: cleanup never-used magic numbers from htree code
Date: Sat,  5 Jul 2008 13:35:47 -0400
Message-Id: <1215279378-30504-22-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.6.rc3.1.g36b7.dirty
In-Reply-To: <1215279378-30504-21-git-send-email-tytso@mit.edu>
References: <1215279378-30504-1-git-send-email-tytso@mit.edu>
 <1215279378-30504-2-git-send-email-tytso@mit.edu>
 <1215279378-30504-3-git-send-email-tytso@mit.edu>
 <1215279378-30504-4-git-send-email-tytso@mit.edu>
 <1215279378-30504-5-git-send-email-tytso@mit.edu>
 <1215279378-30504-6-git-send-email-tytso@mit.edu>
 <1215279378-30504-7-git-send-email-tytso@mit.edu>
 <1215279378-30504-8-git-send-email-tytso@mit.edu>
 <1215279378-30504-9-git-send-email-tytso@mit.edu>
 <1215279378-30504-10-git-send-email-tytso@mit.edu>
 <1215279378-30504-11-git-send-email-tytso@mit.edu>
 <1215279378-30504-12-git-send-email-tytso@mit.edu>
 <1215279378-30504-13-git-send-email-tytso@mit.edu>
 <1215279378-30504-14-git-send-email-tytso@mit.edu>
 <1215279378-30504-15-git-send-email-tytso@mit.edu>
 <1215279378-30504-16-git-send-email-tytso@mit.edu>
 <1215279378-30504-17-git-send-email-tytso@mit.edu>
 <1215279378-30504-18-git-send-email-tytso@mit.edu>
 <1215279378-30504-19-git-send-email-tytso@mit.edu>
 <1215279378-30504-20-git-send-email-tytso@mit.edu>
 <1215279378-30504-21-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

dx_root_limit() will had some dead code which forced it to always return
20, and dx_node_limit to always return 22 for debugging purposes.
Remove it.

Acked-by: Andreas Dilger <adilger@sun.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/namei.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index ab16bea..1bec343 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -231,13 +231,13 @@ static inline unsigned dx_root_limit (struct inode *dir, unsigned infosize)
 {
 	unsigned entry_space = dir->i_sb->s_blocksize - EXT4_DIR_REC_LEN(1) -
 		EXT4_DIR_REC_LEN(2) - infosize;
-	return 0? 20: entry_space / sizeof(struct dx_entry);
+	return entry_space / sizeof(struct dx_entry);
 }
 
 static inline unsigned dx_node_limit (struct inode *dir)
 {
 	unsigned entry_space = dir->i_sb->s_blocksize - EXT4_DIR_REC_LEN(0);
-	return 0? 22: entry_space / sizeof(struct dx_entry);
+	return entry_space / sizeof(struct dx_entry);
 }
 
 /*
-- 
1.5.6.rc3.1.g36b7.dirty

