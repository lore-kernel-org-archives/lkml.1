Return-Path: <linux-kernel-owner+w=401wt.eu-S1761792AbXJLQYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761792AbXJLQYX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932475AbXJLQIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:08:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43956 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932468AbXJLQIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:08:35 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 36/52] CRED: Make ext3_fill_super() pass credentials down
To: viro@ftp.linux.org.uk
Cc: kwc@citi.umich.edu, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Fri, 12 Oct 2007 17:08:23 +0100
Message-ID: <20071012160823.15119.14549.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
References: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make ext3_fill_super() pass credentials down to the functions that it calls.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/ext3/super.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 4bb76d3..2be33c1 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -1257,9 +1257,9 @@ static int ext3_check_descriptors (struct super_block * sb)
  * inode cleanup for us, so we can safely abort without any further action.
  */
 static void ext3_orphan_cleanup (struct super_block * sb,
-				 struct ext3_super_block * es)
+				 struct ext3_super_block * es,
+				 struct cred *cred)
 {
-	struct cred *cred = current->cred;
 	unsigned int s_flags = sb->s_flags;
 	int nr_orphans = 0, nr_truncates = 0;
 #ifdef CONFIG_QUOTA
@@ -1398,6 +1398,7 @@ static ext3_fsblk_t descriptor_loc(struct super_block *sb,
 
 static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 {
+	struct cred *cred = current->cred;
 	struct buffer_head * bh;
 	struct ext3_super_block *es = NULL;
 	struct ext3_sb_info *sbi;
@@ -1799,7 +1800,7 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 	 * superblock lock.
 	 */
 	EXT3_SB(sb)->s_mount_state |= EXT3_ORPHAN_FS;
-	ext3_orphan_cleanup(sb, es);
+	ext3_orphan_cleanup(sb, es, cred);
 	EXT3_SB(sb)->s_mount_state &= ~EXT3_ORPHAN_FS;
 	if (needs_recovery)
 		printk (KERN_INFO "EXT3-fs: recovery complete.\n");

