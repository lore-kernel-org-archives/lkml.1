Return-Path: <linux-kernel-owner+w=401wt.eu-S1756241AbXLNPam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241AbXLNPam (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 10:30:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753308AbXLNPaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 10:30:35 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57016 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890AbXLNPae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 10:30:34 -0500
Message-ID: <4762A192.3020600@redhat.com>
Date: Fri, 14 Dec 2007 09:30:26 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Halcrow <mhalcrow@us.ibm.com>
Subject: [PATCH] ecryptfs: set s_blocksize from lower fs in sb
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

eCryptfs wasn't setting s_blocksize in it's superblock; just pick
it up from the lower FS.  Having an s_blocksize of 0 made things
like "filefrag" which call FIGETBSZ unhappy.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

---

Index: linux-2.6.24-rc3/fs/ecryptfs/main.c
===================================================================
--- linux-2.6.24-rc3.orig/fs/ecryptfs/main.c
+++ linux-2.6.24-rc3/fs/ecryptfs/main.c
@@ -523,6 +523,7 @@ static int ecryptfs_read_super(struct su
 	lower_mnt = nd.mnt;
 	ecryptfs_set_superblock_lower(sb, lower_root->d_sb);
 	sb->s_maxbytes = lower_root->d_sb->s_maxbytes;
+	sb->s_blocksize = lower_root->d_sb->s_blocksize;
 	ecryptfs_set_dentry_lower(sb->s_root, lower_root);
 	ecryptfs_set_dentry_lower_mnt(sb->s_root, lower_mnt);
 	rc = ecryptfs_interpose(lower_root, sb->s_root, sb, 0);

