Return-Path: <linux-kernel-owner+w=401wt.eu-S1751011AbZHSQ4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751011AbZHSQ4c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 12:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750837AbZHSQ4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 12:56:32 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38065 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750763AbZHSQ4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 12:56:31 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 1/2] pohmelfs: fix atomic type spew
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 19 Aug 2009 17:52:02 +0100
Message-ID: <20090819165201.14632.96567.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

atomic_long != atomic

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/pohmelfs/inode.c |    2 +-
 drivers/staging/pohmelfs/net.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/drivers/staging/pohmelfs/inode.c b/drivers/staging/pohmelfs/inode.c
index 7b60579..834edc5 100644
--- a/drivers/staging/pohmelfs/inode.c
+++ b/drivers/staging/pohmelfs/inode.c
@@ -1865,7 +1865,7 @@ static int pohmelfs_fill_super(struct super_block *sb, void *data, int silent)
 	INIT_LIST_HEAD(&psb->crypto_active_list);
 
 	atomic_set(&psb->trans_gen, 1);
-	atomic_set(&psb->total_inodes, 0);
+	atomic_long_set(&psb->total_inodes, 0);
 
 	mutex_init(&psb->state_lock);
 	INIT_LIST_HEAD(&psb->state_list);
diff --git a/drivers/staging/pohmelfs/net.c b/drivers/staging/pohmelfs/net.c
index 5f312c9..bdaab69 100644
--- a/drivers/staging/pohmelfs/net.c
+++ b/drivers/staging/pohmelfs/net.c
@@ -680,7 +680,7 @@ static int pohmelfs_root_cap_response(struct netfs_state *st)
 		printk(KERN_INFO "Mounting POHMELFS (%d) "
 			"with extended attributes support.\n", psb->idx);
 
-	if (atomic_read(&psb->total_inodes) <= 1)
+	if (atomic_long_read(&psb->total_inodes) <= 1)
 		atomic_long_set(&psb->total_inodes, cap->nr_files);
 
 	dprintk("%s: total: %llu, avail: %llu, flags: %llx, inodes: %llu.\n",

