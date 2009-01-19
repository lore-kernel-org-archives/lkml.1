Return-Path: <linux-kernel-owner+w=401wt.eu-S1754980AbZASQ31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980AbZASQ31 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 11:29:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbZASQ3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 11:29:08 -0500
Received: from ti-out-0910.google.com ([209.85.142.189]:49227 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbZASQ3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 11:29:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:to:cc:bcc:subject:date:user-agent;
        b=ddetRV7n+Dj7i1k7uYDBMJyeMOMTmFEMc8AkBtMcUsl/gKlyO81Pq5NJo6ffEQy+vS
         AmH2ztwGgjMgDWLKNcuSvjQZjQ9eIRk7S6hOj8lqhpn9QO9c8Wps3HCi4q67BVTPEmpP
         ykLRUeGjk+Hc5mHVqv1x6QPKw67NJgb4w3M1Y=
Message-ID: <4974aa4d.0e0d6e0a.4824.5c2b@mx.google.com>
From: Qinghuang Feng <qhfeng.kernel@gmail.com>
To: chris.mason@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: check return value for kthread_run() correctly
Date: Tue, 20 Jan 2009 00:28:44 +0800
User-Agent: sniper-patch-carrier/1.06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kthread_run() returns the kthread or ERR_PTR(-ENOMEM), not NULL.

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
---
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 81a3138..f718d25 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1740,13 +1740,13 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	fs_info->system_alloc_profile = fs_info->metadata_alloc_profile;
 	fs_info->cleaner_kthread = kthread_run(cleaner_kthread, tree_root,
 					       "btrfs-cleaner");
-	if (!fs_info->cleaner_kthread)
+	if (IS_ERR(fs_info->cleaner_kthread))
 		goto fail_csum_root;
 
 	fs_info->transaction_kthread = kthread_run(transaction_kthread,
 						   tree_root,
 						   "btrfs-transaction");
-	if (!fs_info->transaction_kthread)
+	if (IS_ERR(fs_info->transaction_kthread))
 		goto fail_cleaner;
 
 	if (btrfs_super_log_root(disk_super) != 0) {

