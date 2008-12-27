Return-Path: <linux-kernel-owner+w=401wt.eu-S1754347AbYL0U3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347AbYL0U3I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 15:29:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754072AbYL0U2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 15:28:38 -0500
Received: from mail.parknet.ad.jp ([210.171.162.6]:46782 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025AbYL0U2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 15:28:37 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: hirofumi@mail.parknet.co.jp
Subject: [PATCH] fat: make sure to set d_ops in fat_get_parent
Date: Sun, 28 Dec 2008 05:17:25 +0900
Message-Id: <5a6bb10393eb9a1985e97af12f0cb2906bcbf1af.1230408710.git.hirofumi@mail.parknet.co.jp>
X-Mailer: git-send-email 1.6.0.5.dirty
In-Reply-To: <985eafcc5480b0d98419b96869f2560abb2764c7.1230408710.git.hirofumi@mail.parknet.co.jp>
References: <cover.1230408710.git.hirofumi@mail.parknet.co.jp>
 <ebeb0406f153db51ab2d4771faf2342bd6ca14dd.1230408710.git.hirofumi@mail.parknet.co.jp>
 <985eafcc5480b0d98419b96869f2560abb2764c7.1230408710.git.hirofumi@mail.parknet.co.jp>
In-Reply-To: <cover.1230408710.git.hirofumi@mail.parknet.co.jp>
References: <cover.1230408710.git.hirofumi@mail.parknet.co.jp>
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

fat_get_parent needs to setup the dentry operations, otherwise we might
lose them when the NFS server needs to reconnect out of cache inodes.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---
 fs/fat/inode.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index bdd8fb7..37a8af1 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -749,6 +749,8 @@ static struct dentry *fat_get_parent(struct dentry *child)
 	brelse(bh);
 
 	parent = d_obtain_alias(inode);
+	if (!IS_ERR(parent))
+		parent->d_op = sb->s_root->d_op;
 out:
 	unlock_super(sb);
 
-- 
1.6.0.5.dirty

