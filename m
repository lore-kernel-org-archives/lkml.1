Return-Path: <linux-kernel-owner+w=401wt.eu-S1756840AbZKJQC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840AbZKJQC4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 11:02:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756791AbZKJQCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 11:02:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49578 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756770AbZKJQCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 11:02:54 -0500
From: Jeff Layton <jlayton@redhat.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] vfs: remove extraneous NULL d_inode check from do_filp_open
Date: Tue, 10 Nov 2009 11:02:59 -0500
Message-Id: <1257868979-31012-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can't get to this point unless it's a valid pointer.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/namei.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index d11f404..3374917 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1805,7 +1805,7 @@ do_last:
 
 	path_to_nameidata(&path, &nd);
 	error = -EISDIR;
-	if (path.dentry->d_inode && S_ISDIR(path.dentry->d_inode->i_mode))
+	if (S_ISDIR(path.dentry->d_inode->i_mode))
 		goto exit;
 ok:
 	/*
-- 
1.5.5.6

