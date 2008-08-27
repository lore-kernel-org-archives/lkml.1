Return-Path: <linux-kernel-owner+w=401wt.eu-S1758212AbYH0Nzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212AbYH0Nzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 09:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757346AbYH0Nti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:49:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49271 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757295AbYH0Ntg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:49:36 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 18/59] CRED: Wrap task credential accesses in the BFS
	filesystem
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Serge Hallyn <serue@us.ibm.com>,
       "Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>
Date: Wed, 27 Aug 2008 14:47:15 +0100
Message-ID: <20080827134715.19980.64010.stgit@warthog.procyon.org.uk>
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
Cc: Tigran A. Aivazian <tigran@aivazian.fsnet.co.uk>
---

 fs/bfs/dir.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/bfs/dir.c b/fs/bfs/dir.c
index 87ee5cc..e892a71 100644
--- a/fs/bfs/dir.c
+++ b/fs/bfs/dir.c
@@ -105,8 +105,8 @@ static int bfs_create(struct inode *dir, struct dentry *dentry, int mode,
 	}
 	set_bit(ino, info->si_imap);
 	info->si_freei--;
-	inode->i_uid = current->fsuid;
-	inode->i_gid = (dir->i_mode & S_ISGID) ? dir->i_gid : current->fsgid;
+	inode->i_uid = current_fsuid();
+	inode->i_gid = (dir->i_mode & S_ISGID) ? dir->i_gid : current_fsgid();
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
 	inode->i_blocks = 0;
 	inode->i_op = &bfs_file_inops;

