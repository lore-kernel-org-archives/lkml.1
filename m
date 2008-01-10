Return-Path: <linux-kernel-owner+w=401wt.eu-S1759661AbYAJPHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759661AbYAJPHQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 10:07:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759495AbYAJPBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 10:01:24 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:57062 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755950AbYAJPA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 10:00:59 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       hch@infradead.org, viro@ftp.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 28/29] VFS: export release_open_intent symbol
Date: Thu, 10 Jan 2008 09:59:47 -0500
Message-Id: <1199977208820-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11999771882152-git-send-email-ezk@cs.sunysb.edu>
References: <11999771882152-git-send-email-ezk@cs.sunysb.edu>
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

