Return-Path: <linux-kernel-owner+w=401wt.eu-S1754640AbZKBKHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640AbZKBKHc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 05:07:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754613AbZKBKHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 05:07:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58508 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754375AbZKBKHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 05:07:00 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       Jan Blunck <jblunck@suse.de>, Ian Kent <raven@themaw.net>,
       James Morris <jmorris@namei.org>, Al Viro <viro@zeniv.linux.org.uk>,
       Jeff Moyer <jmoyer@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, autofs@linux.kernel.org
Subject: [PATCH 10/27] BKL: Remove BKL from autofs4
Date: Mon,  2 Nov 2009 11:04:50 +0100
Message-Id: <1257156307-24175-11-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1257156307-24175-1-git-send-email-jblunck@suse.de>
References: <1257156307-24175-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BKL is only used in fill_super. It is safe to remove it.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/autofs4/inode.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/fs/autofs4/inode.c b/fs/autofs4/inode.c
index 3adaba9..69c8142 100644
--- a/fs/autofs4/inode.c
+++ b/fs/autofs4/inode.c
@@ -323,8 +323,6 @@ int autofs4_fill_super(struct super_block *s, void *data, int silent)
 	struct autofs_sb_info *sbi;
 	struct autofs_info *ino;
 
-	lock_kernel();
-
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	if (!sbi)
 		goto fail_unlock;
@@ -420,7 +418,6 @@ int autofs4_fill_super(struct super_block *s, void *data, int silent)
 	 * Success! Install the root dentry now to indicate completion.
 	 */
 	s->s_root = root;
-	unlock_kernel();
 	return 0;
 	
 	/*
@@ -442,7 +439,6 @@ fail_free:
 	kfree(sbi);
 	s->s_fs_info = NULL;
 fail_unlock:
-	unlock_kernel();
 	return -EINVAL;
 }
 
-- 
1.6.4.2

