Return-Path: <linux-kernel-owner+w=401wt.eu-S1759300AbYFHJMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759300AbYFHJMs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 05:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755005AbYFHJMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 05:12:38 -0400
Received: from 1wt.eu ([62.212.114.60]:1569 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754820AbYFHJMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 05:12:38 -0400
Date: Sun, 8 Jun 2008 10:56:53 +0200
From: Willy Tarreau <w@1wt.eu>
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, Miklos Szeredi <mszeredi@suse.cz>,
       Michael Halcrow <mhalcrow@us.ibm.com>
Subject: Missing patch from stable [1/7]
Message-ID: <20080608085653.GA6439@1wt.eu>
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

>From 9c3580aa52195699065bc2d7242b1c7e3e6903fa Mon Sep 17 00:00:00 2001
From: Miklos Szeredi <mszeredi@suse.cz>
Date: Tue, 29 Apr 2008 00:59:48 -0700
Subject: ecryptfs: add missing lock around notify_change

Callers of notify_change() need to hold i_mutex.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 fs/ecryptfs/inode.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index a7d5d7d..1623ebf 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -908,7 +908,9 @@ static int ecryptfs_setattr(struct dentry *dentry, struct iattr *ia)
 	if (ia->ia_valid & (ATTR_KILL_SUID | ATTR_KILL_SGID))
 		ia->ia_valid &= ~ATTR_MODE;
 
+	mutex_lock(&lower_dentry->d_inode->i_mutex);
 	rc = notify_change(lower_dentry, ia);
+	mutex_unlock(&lower_dentry->d_inode->i_mutex);
 out:
 	fsstack_copy_attr_all(inode, lower_inode, NULL);
 	return rc;
-- 
1.5.3.8

