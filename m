Return-Path: <linux-kernel-owner+w=401wt.eu-S1757250AbXLJCvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250AbXLJCvo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 21:51:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755084AbXLJCnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 21:43:53 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:49812 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbXLJCnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 21:43:24 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: hch@infradead.org, viro@ftp.linux.org.uk, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 37/42] VFS: export release_open_intent symbol
Date: Sun,  9 Dec 2007 21:42:10 -0500
Message-Id: <11972545601666-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11972545353262-git-send-email-ezk@cs.sunysb.edu>
References: <11972545353262-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Needed to release the resources of the lower nameidata structures that we
create and pass to lower file systems (e.g., when calling vfs_create).

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/namei.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 3b993db..14f9861 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -389,6 +389,7 @@ void release_open_intent(struct nameidata *nd)
 	else
 		fput(nd->intent.open.file);
 }
+EXPORT_SYMBOL(release_open_intent);
 
 static inline struct dentry *
 do_revalidate(struct dentry *dentry, struct nameidata *nd)
-- 
1.5.2.2

