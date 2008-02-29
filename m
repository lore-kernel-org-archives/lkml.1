Return-Path: <linux-kernel-owner+w=401wt.eu-S1760031AbYB2AzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760031AbYB2AzA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 19:55:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932494AbYB2Aq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 19:46:28 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58713 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932302AbYB2AqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 19:46:14 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 19/37] CacheFiles: Export things for CacheFiles [ver #34]
To: Trond.Myklebust@netapp.com, chuck.lever@oracle.com, casey@schaufler-ca.com
Cc: nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Fri, 29 Feb 2008 00:45:15 +0000
Message-ID: <20080229004515.4142.89228.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080229004332.4142.51771.stgit@warthog.procyon.org.uk>
References: <20080229004332.4142.51771.stgit@warthog.procyon.org.uk>
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
index 88811f6..1133b43 100644
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
index e7345e1..d860a70 100644
--- a/security/security.c
+++ b/security/security.c
@@ -351,6 +351,7 @@ int security_inode_create(struct inode *dir, struct dentry *dentry, int mode)
 		return 0;
 	return security_ops->inode_create(dir, dentry, mode);
 }
+EXPORT_SYMBOL_GPL(security_inode_create);
 
 int security_inode_link(struct dentry *old_dentry, struct inode *dir,
 			 struct dentry *new_dentry)
@@ -381,6 +382,7 @@ int security_inode_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 		return 0;
 	return security_ops->inode_mkdir(dir, dentry, mode);
 }
+EXPORT_SYMBOL_GPL(security_inode_mkdir);
 
 int security_inode_rmdir(struct inode *dir, struct dentry *dentry)
 {

