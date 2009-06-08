Return-Path: <linux-kernel-owner+w=401wt.eu-S1751752AbZFHTXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751752AbZFHTXp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 15:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753316AbZFHTXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 15:23:13 -0400
Received: from thunk.org ([69.25.196.29]:39518 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216AbZFHTXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 15:23:11 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: [PATCH 05/49] ext4: Use is_power_of_2() for clarity
Date: Mon,  8 Jun 2009 15:22:23 -0400
Message-Id: <1244488987-32564-6-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.6.3.2.1.gb9f7d.dirty
In-Reply-To: <1244488987-32564-5-git-send-email-tytso@mit.edu>
References: <1244488987-32564-1-git-send-email-tytso@mit.edu>
 <1244488987-32564-2-git-send-email-tytso@mit.edu>
 <1244488987-32564-3-git-send-email-tytso@mit.edu>
 <1244488987-32564-4-git-send-email-tytso@mit.edu>
 <1244488987-32564-5-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/super.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 3f4475d..3e509bc 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1483,7 +1483,7 @@ set_qf_format:
 				return 0;
 			if (option < 0 || option > (1 << 30))
 				return 0;
-			if (option & (option - 1)) {
+			if (!is_power_of_2(option)) {
 				printk(KERN_ERR "EXT4-fs: inode_readahead_blks"
 				       " must be a power of 2\n");
 				return 0;
@@ -2101,8 +2101,7 @@ static ssize_t inode_readahead_blks_store(struct ext4_attr *a,
 	if (parse_strtoul(buf, 0x40000000, &t))
 		return -EINVAL;
 
-	/* inode_readahead_blks must be a power of 2 */
-	if (t & (t-1))
+	if (!is_power_of_2(t))
 		return -EINVAL;
 
 	sbi->s_inode_readahead_blks = t;
-- 
1.6.3.2.1.gb9f7d.dirty

