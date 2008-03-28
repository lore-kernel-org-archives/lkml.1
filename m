Return-Path: <linux-kernel-owner+w=401wt.eu-S1758524AbYC1Ol1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758524AbYC1Ol1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 10:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754789AbYC1OfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 10:35:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49282 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756335AbYC1Oei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 10:34:38 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 24/45] CacheFiles: Export things for CacheFiles [ver #35]
To: torvalds@osdl.org, akpm@linux-foundation.org, trond.myklebust@fys.uio.no,
       chuck.lever@oracle.com
Cc: nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Fri, 28 Mar 2008 14:32:14 +0000
Message-ID: <20080328143214.3483.24952.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080328143010.3483.99079.stgit@warthog.procyon.org.uk>
References: <20080328143010.3483.99079.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export a number of functions for CacheFiles's use.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/super.c          |    1 +
 security/security.c |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)


diff --git a/fs/super.c b/fs/super.c
index 09008db..8030909 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -267,6 +267,7 @@ int fsync_super(struct super_block *sb)
 	__fsync_super(sb);
 	return sync_blockdev(sb->s_bdev);
 }
+EXPORT_SYMBOL_GPL(fsync_super);
 
 /**
  *	generic_shutdown_super	-	common helper for ->kill_sb()
diff --git a/security/security.c b/security/security.c
index 87cd150..deb2e65 100644
--- a/security/security.c
+++ b/security/security.c
@@ -358,6 +358,7 @@ int security_inode_create(struct inode *dir, struct dentry *dentry, int mode)
 		return 0;
 	return security_ops->inode_create(dir, dentry, mode);
 }
+EXPORT_SYMBOL_GPL(security_inode_create);
 
 int security_inode_link(struct dentry *old_dentry, struct inode *dir,
 			 struct dentry *new_dentry)
@@ -388,6 +389,7 @@ int security_inode_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 		return 0;
 	return security_ops->inode_mkdir(dir, dentry, mode);
 }
+EXPORT_SYMBOL_GPL(security_inode_mkdir);
 
 int security_inode_rmdir(struct inode *dir, struct dentry *dentry)
 {

