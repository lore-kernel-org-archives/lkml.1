Return-Path: <linux-kernel-owner+w=401wt.eu-S1753363Ab0AKSdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab0AKSdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 13:33:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753172Ab0AKSdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 13:33:16 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:56204 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab0AKSdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 13:33:15 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 1/2] vfs: cleanup path_to_nameidata()
Date: Tue, 12 Jan 2010 03:33:11 +0900
Message-ID: <87vdf8jxug.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/namei.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/namei.c~namei-path_to_nameidata-cleanup fs/namei.c
--- linux-2.6/fs/namei.c~namei-path_to_nameidata-cleanup	2010-01-10 21:15:42.000000000 +0900
+++ linux-2.6-hirofumi/fs/namei.c	2010-01-12 00:15:04.000000000 +0900
@@ -541,9 +541,10 @@ static void path_put_conditional(struct 
 static inline void path_to_nameidata(struct path *path, struct nameidata *nd)
 {
 	dput(nd->path.dentry);
-	if (nd->path.mnt != path->mnt)
+	if (nd->path.mnt != path->mnt) {
 		mntput(nd->path.mnt);
-	nd->path.mnt = path->mnt;
+		nd->path.mnt = path->mnt;
+	}
 	nd->path.dentry = path->dentry;
 }
 
_

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
