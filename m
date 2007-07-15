Return-Path: <linux-kernel-owner+w=401wt.eu-S1756411AbXGOT77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411AbXGOT77 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 15:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754673AbXGOT7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 15:59:33 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39906 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729AbXGOT7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 15:59:32 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] wrong order of arguments of ->readdir()
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1IAAFf-00053N-TV@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sun, 15 Jul 2007 20:59:31 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Shows how many people are testing coda - the bug had been there for 5 years
and results of stepping on it are not subtle.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/coda/dir.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/coda/dir.c b/fs/coda/dir.c
index 9ddf5ed..898a86d 100644
--- a/fs/coda/dir.c
+++ b/fs/coda/dir.c
@@ -470,7 +470,7 @@ int coda_readdir(struct file *coda_file, void *dirent, filldir_t filldir)
 
 		ret = -ENOENT;
 		if (!IS_DEADDIR(host_inode)) {
-			ret = host_file->f_op->readdir(host_file, filldir, dirent);
+			ret = host_file->f_op->readdir(host_file, dirent, filldir);
 			file_accessed(host_file);
 		}
 	}
-- 
1.5.3.GIT


