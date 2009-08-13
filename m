Return-Path: <linux-kernel-owner+w=401wt.eu-S1752658AbZHMEpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbZHMEpg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 00:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbZHMEpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 00:45:35 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:38948 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751434AbZHMEpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 00:45:34 -0400
Subject: [PATCH][RT] btrfs compile fix
From: Sven-Thorsten Dietrich <sdietrich@novell.com>
To: linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: Novell
Date: Wed, 12 Aug 2009 21:45:29 -0700
Message-Id: <1250138729.15796.22.camel@quadrophenia.thebigcorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: add back in btrfs commit_root_sem.
From: rt-2.6.31-rc4-rt1

Seems to be in flux, but these are required for the status-quo to compile.

Not run-time tested.

Signed-off-by: Sven-Thorsten Dietrich <sdietrich@suse.de>
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -942,6 +959,9 @@ struct btrfs_root {
 	/* the node lock is held while changing the node pointer */
 	spinlock_t node_lock;
 
+	/* taken when updating the commit root */
+	struct rw_semaphore commit_root_sem;
+
 	struct extent_buffer *commit_root;
 	struct btrfs_root *log_root;
 	struct btrfs_root *reloc_root;
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -909,6 +909,7 @@ static int __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
 	spin_lock_init(&root->inode_lock);
 	mutex_init(&root->objectid_mutex);
 	mutex_init(&root->log_mutex);
+	init_rwsem(&root->commit_root_sem);
 	init_waitqueue_head(&root->log_writer_wait);
 	init_waitqueue_head(&root->log_commit_wait[0]);
 	init_waitqueue_head(&root->log_commit_wait[1]);
 


