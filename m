Return-Path: <linux-kernel-owner+w=401wt.eu-S1754841AbZKBKMI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbZKBKMI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 05:12:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754474AbZKBKHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 05:07:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58546 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754408AbZKBKHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 05:07:04 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       Jan Blunck <jblunck@suse.de>, Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Avan Anishchuk <matimatik@gmail.com>
Subject: [PATCH 23/27] BKL: Remove BKL from ramfs
Date: Mon,  2 Nov 2009 11:05:03 +0100
Message-Id: <1257156307-24175-24-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1257156307-24175-1-git-send-email-jblunck@suse.de>
References: <1257156307-24175-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BKL is only used in fill_super. It is safe to remove it.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/ramfs/inode.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
index 9b3983f..a6090aa 100644
--- a/fs/ramfs/inode.c
+++ b/fs/ramfs/inode.c
@@ -35,7 +35,6 @@
 #include <linux/sched.h>
 #include <linux/parser.h>
 #include <linux/magic.h>
-#include <linux/smp_lock.h> /* Only for lock_kernel() */
 #include <asm/uaccess.h>
 #include "internal.h"
 
@@ -221,8 +220,6 @@ static int ramfs_fill_super(struct super_block * sb, void * data, int silent)
 	struct dentry *root;
 	int err;
 
-	lock_kernel();
-
 	save_mount_options(sb, data);
 
 	fsi = kzalloc(sizeof(struct ramfs_fs_info), GFP_KERNEL);
@@ -256,13 +253,11 @@ static int ramfs_fill_super(struct super_block * sb, void * data, int silent)
 		goto fail;
 	}
 
-	unlock_kernel();
 	return 0;
 fail:
 	kfree(fsi);
 	sb->s_fs_info = NULL;
 	iput(inode);
-	unlock_kernel();
 	return err;
 }
 
-- 
1.6.4.2

