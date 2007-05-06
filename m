Return-Path: <linux-kernel-owner+w=401wt.eu-S1754833AbXEFRsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbXEFRsg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 13:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754764AbXEFRsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 13:48:12 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:60375 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754746AbXEFRsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 13:48:06 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: hch@infradead.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 2/2] fs: Use path_walk in do_path_lookup
Date: Sun,  6 May 2007 13:47:56 -0400
Message-Id: <11784736761029-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.rc1.20.g86b9
In-Reply-To: <11784736762516-git-send-email-jsipek@cs.sunysb.edu>
References: <11784736762516-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since, path_walk sets the total_link_count to 0, and calls link_path_walk,
we can just call path_walk directly.

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/namei.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 2a5c232..25aaf8c 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1156,8 +1156,8 @@ static int fastcall do_path_lookup(int dfd, const char *name,
 
 		fput_light(file, fput_needed);
 	}
-	current->total_link_count = 0;
-	retval = link_path_walk(name, nd);
+
+	retval = path_walk(name, nd);
 out:
 	if (unlikely(!retval && !audit_dummy_context() && nd->dentry &&
 				nd->dentry->d_inode))
-- 
1.5.2.rc1.20.g86b9

