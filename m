Return-Path: <linux-kernel-owner+w=401wt.eu-S1756537AbYH0OBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbYH0OBf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 10:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756784AbYH0Nv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:51:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49501 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756527AbYH0NvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:51:23 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 30/59] CRED: Wrap task credential accesses in the HFSplus
	filesystem
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Serge Hallyn <serue@us.ibm.com>, Roman Zippel <zippel@linux-m68k.org>
Date: Wed, 27 Aug 2008 14:48:17 +0100
Message-ID: <20080827134816.19980.76336.stgit@warthog.procyon.org.uk>
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
Cc: Roman Zippel <zippel@linux-m68k.org>
---

 fs/hfsplus/inode.c   |    4 ++--
 fs/hfsplus/options.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)


diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index b085d64..7c711ca 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -307,8 +307,8 @@ struct inode *hfsplus_new_inode(struct super_block *sb, int mode)
 
 	inode->i_ino = HFSPLUS_SB(sb).next_cnid++;
 	inode->i_mode = mode;
-	inode->i_uid = current->fsuid;
-	inode->i_gid = current->fsgid;
+	inode->i_uid = current_fsuid();
+	inode->i_gid = current_fsgid();
 	inode->i_nlink = 1;
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
 	INIT_LIST_HEAD(&HFSPLUS_I(inode).open_dir_list);
diff --git a/fs/hfsplus/options.c b/fs/hfsplus/options.c
index 9997cbf..4cfe720 100644
--- a/fs/hfsplus/options.c
+++ b/fs/hfsplus/options.c
@@ -49,8 +49,8 @@ void hfsplus_fill_defaults(struct hfsplus_sb_info *opts)
 	opts->creator = HFSPLUS_DEF_CR_TYPE;
 	opts->type = HFSPLUS_DEF_CR_TYPE;
 	opts->umask = current->fs->umask;
-	opts->uid = current->uid;
-	opts->gid = current->gid;
+	opts->uid = current_uid();
+	opts->gid = current_gid();
 	opts->part = -1;
 	opts->session = -1;
 }

