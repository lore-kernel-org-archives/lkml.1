Return-Path: <linux-kernel-owner+w=401wt.eu-S1759427AbYGERsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759427AbYGERsr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 13:48:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744AbYGERiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 13:38:09 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:33083 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755792AbYGERgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 13:36:32 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 22/52] ext4: Fix sparse warning
Date: Sat,  5 Jul 2008 13:35:48 -0400
Message-Id: <1215279378-30504-23-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.6.rc3.1.g36b7.dirty
In-Reply-To: <1215279378-30504-22-git-send-email-tytso@mit.edu>
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
 <1215279378-30504-22-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/balloc.c |    2 +-
 fs/ext4/super.c  |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 0b2b754..6dcbec9 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -47,7 +47,7 @@ static int ext4_block_in_group(struct super_block *sb, ext4_fsblk_t block,
 			ext4_group_t block_group)
 {
 	ext4_group_t actual_group;
-	ext4_get_group_no_and_offset(sb, block, &actual_group, 0);
+	ext4_get_group_no_and_offset(sb, block, &actual_group, NULL);
 	if (actual_group == block_group)
 		return 1;
 	return 0;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index b1166a9..c4b9faf 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1858,8 +1858,8 @@ static unsigned long ext4_get_stripe_size(struct ext4_sb_info *sbi)
 }
 
 static int ext4_fill_super (struct super_block *sb, void *data, int silent)
-				__releases(kernel_sem)
-				__acquires(kernel_sem)
+				__releases(kernel_lock)
+				__acquires(kernel_lock)
 
 {
 	struct buffer_head * bh;
-- 
1.5.6.rc3.1.g36b7.dirty

