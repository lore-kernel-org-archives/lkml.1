Return-Path: <linux-kernel-owner+w=401wt.eu-S1760830AbYFHJDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760830AbYFHJDq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 05:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754862AbYFHJDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 05:03:38 -0400
Received: from 1wt.eu ([62.212.114.60]:1558 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754776AbYFHJDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 05:03:38 -0400
Date: Sun, 8 Jun 2008 10:58:02 +0200
From: Willy Tarreau <w@1wt.eu>
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
       Michael Halcrow <mhalcrow@us.ibm.com>
Subject: Missing patch from stable [2/7]
Message-ID: <20080608085802.GB6439@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this patch from mainline seems suitable for -stable, but was not proposed
for inclusion. I think we should include it for next review unless the
author disagrees.

Thanks,
Willy
--

>From 2f9b12a31fcb738ea8c9eb0d4ddf906c6f1d696c Mon Sep 17 00:00:00 2001
From: Michael Halcrow <mhalcrow@us.ibm.com>
Date: Tue, 29 Apr 2008 00:59:52 -0700
Subject: eCryptfs: protect crypt_stat->flags in ecryptfs_open()

Make sure crypt_stat->flags is protected with a lock in ecryptfs_open().

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 fs/ecryptfs/file.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index 2b8f5ed..2258b8f 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -195,7 +195,9 @@ static int ecryptfs_open(struct inode *inode, struct file *file)
 		file, ecryptfs_inode_to_private(inode)->lower_file);
 	if (S_ISDIR(ecryptfs_dentry->d_inode->i_mode)) {
 		ecryptfs_printk(KERN_DEBUG, "This is a directory\n");
+		mutex_lock(&crypt_stat->cs_mutex);
 		crypt_stat->flags &= ~(ECRYPTFS_ENCRYPTED);
+		mutex_unlock(&crypt_stat->cs_mutex);
 		rc = 0;
 		goto out;
 	}
-- 
1.5.3.8

