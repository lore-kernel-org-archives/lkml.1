Return-Path: <linux-kernel-owner+w=401wt.eu-S1757559AbYBZH0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559AbYBZH0M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 02:26:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759514AbYBZHZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 02:25:21 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:53005 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759341AbYBZHZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 02:25:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=m0+8BwAHT25QvjSkUsVzIhiQPMTaiuq70RfJ0UnwE4Y6OaqmRkVOIOA3Y9tvWqr1dvcmixiv5l20/W4M1YnL7BDi7hF2tR0yOL6/qdKCapathXQprwzEBj00UVaxQhwexEJd/7RKD1Cn6snIYj1kRs9hDpRAfpPWUPnwDpC9Rd8=
From: Denis Cheng <crquan@gmail.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] [GFS2] re-support special inode
Date: Tue, 26 Feb 2008 15:25:04 +0800
Message-Id: <1204010704-11842-2-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <1204010704-11842-1-git-send-email-crquan@gmail.com>
References: <
 <1204010704-11842-1-git-send-email-crquan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit feaa7bba026c181ce071d5a4884f7f9dd26207a1 removed call to
init_special_inode from inode lookuping, this cause problems as:

 # mknod /mnt/gfs2/dev/null c 1 3
 # cat /mnt/gfs2/dev/null
 cat: /mnt/gfs2/dev/null: Invalid argument

without special inode, GFS2 cannot support char device file,
block device file, fifo pipe, and socket file, lose many important
features as a common file system.

this one line patch re add special inode support.

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 fs/gfs2/inode.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 1069ceb..18d8e0b 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -150,6 +150,7 @@ void gfs2_set_iop(struct inode *inode)
 		inode->i_op = &gfs2_symlink_iops;
 	} else {
 		inode->i_op = &gfs2_file_iops;
+		init_special_inode(inode, inode->i_mode, inode->i_rdev);
 	}
 
 	unlock_new_inode(inode);
-- 
1.5.4.2

