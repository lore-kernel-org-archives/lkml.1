Return-Path: <linux-kernel-owner+w=401wt.eu-S1760242AbYH0OCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760242AbYH0OCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 10:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756829AbYH0Nvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:51:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49538 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757830AbYH0Nva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:51:30 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 40/59] CRED: Wrap task credential accesses in the RAMFS
	filesystem
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Serge Hallyn <serue@us.ibm.com>
Date: Wed, 27 Aug 2008 14:49:08 +0100
Message-ID: <20080827134908.19980.42913.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
References: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap access to task credentials so that they can be separated more easily from
the task_struct during the introduction of COW creds.

Change most current->(|e|s|fs)[ug]id to current_(|e|s|fs)[ug]id().

Change some task->e?[ug]id to task_e?[ug]id().  In some places it makes more
sense to use RCU directly rather than a convenient wrapper; these will be
addressed by later patches.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: James Morris <jmorris@namei.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
---

 fs/ramfs/inode.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
index b131234..08c755d 100644
--- a/fs/ramfs/inode.c
+++ b/fs/ramfs/inode.c
@@ -55,8 +55,8 @@ struct inode *ramfs_get_inode(struct super_block *sb, int mode, dev_t dev)
 
 	if (inode) {
 		inode->i_mode = mode;
-		inode->i_uid = current->fsuid;
-		inode->i_gid = current->fsgid;
+		inode->i_uid = current_fsuid();
+		inode->i_gid = current_fsgid();
 		inode->i_blocks = 0;
 		inode->i_mapping->a_ops = &ramfs_aops;
 		inode->i_mapping->backing_dev_info = &ramfs_backing_dev_info;

