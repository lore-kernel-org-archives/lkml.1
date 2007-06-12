Return-Path: <linux-kernel-owner+w=401wt.eu-S1756223AbXFLXXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223AbXFLXXP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 19:23:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754336AbXFLXXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 19:23:00 -0400
Received: from ns.suse.de ([195.135.220.2]:48706 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753696AbXFLXW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 19:22:59 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/3] sysfs: fix condition check in sysfs_drop_dentry()
Date: Tue, 12 Jun 2007 16:22:45 -0700
Message-Id: <11816905694164-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.1
In-Reply-To: <11816905661989-git-send-email-gregkh@suse.de>
References: <20070612232159.GA12971@suse.de>
 <11816905661989-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

The condition check doesn't make much sense as it basically always
succeeds.  This causes NULL dereferencing on certain cases.  It seems
that parentheses are put in the wrong place.  Fix it.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 082e2d4..38bbe07 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -252,7 +252,7 @@ void sysfs_drop_dentry(struct sysfs_dirent * sd, struct dentry * parent)
 	if (dentry) {
 		spin_lock(&dcache_lock);
 		spin_lock(&dentry->d_lock);
-		if (!(d_unhashed(dentry) && dentry->d_inode)) {
+		if (!d_unhashed(dentry) && dentry->d_inode) {
 			inode = dentry->d_inode;
 			spin_lock(&inode->i_lock);
 			__iget(inode);
-- 
1.5.2.1

