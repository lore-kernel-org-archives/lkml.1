Return-Path: <linux-kernel-owner+w=401wt.eu-S1760771AbZF2QCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760771AbZF2QCP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 12:02:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754752AbZF2QCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 12:02:07 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:48796 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbZF2QCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 12:02:05 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: chris.mason@oracle.com
Cc: linux-btrfs@vger.kernel.org, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 3/5] FS: btrfs, don't touch freed memory
Date: Mon, 29 Jun 2009 18:01:45 +0200
Message-Id: <1246291305-3444-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

worker memory is already freed on one fail path in btrfs_start_workers,
but is still dereferenced. Switch the dereference and kfree.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 fs/btrfs/async-thread.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index 7f88628..6e4f6c5 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -299,8 +299,8 @@ int btrfs_start_workers(struct btrfs_workers *workers, int num_workers)
 					   "btrfs-%s-%d", workers->name,
 					   workers->num_workers + i);
 		if (IS_ERR(worker->task)) {
-			kfree(worker);
 			ret = PTR_ERR(worker->task);
+			kfree(worker);
 			goto fail;
 		}
 
-- 
1.6.3.2

