Return-Path: <linux-kernel-owner+w=401wt.eu-S934003AbYBTQXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934003AbYBTQXo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 11:23:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765455AbYBTQLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 11:11:25 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764423AbYBTQKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 11:10:16 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 33/37] NFS: nfs_readpage_async() needs to be accessible as a
	fallback for local caching
To: Trond.Myklebust@netapp.com, chuck.lever@oracle.com, casey@schaufler-ca.com
Cc: nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Wed, 20 Feb 2008 16:08:55 +0000
Message-ID: <20080220160855.4715.84031.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080220160557.4715.66608.stgit@warthog.procyon.org.uk>
References: <20080220160557.4715.66608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nfs_readpage_async() needs to be non-static so that it can be used as a
fallback for the local on-disk caching should an EIO crop up when reading the
cache.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/nfs/read.c          |    4 ++--
 include/linux/nfs_fs.h |    2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)


diff --git a/fs/nfs/read.c b/fs/nfs/read.c
index 3d7d963..725a5a2 100644
--- a/fs/nfs/read.c
+++ b/fs/nfs/read.c
@@ -114,8 +114,8 @@ static void nfs_readpage_truncate_uninitialised_page(struct nfs_read_data *data)
 	}
 }
 
-static int nfs_readpage_async(struct nfs_open_context *ctx, struct inode *inode,
-		struct page *page)
+int nfs_readpage_async(struct nfs_open_context *ctx, struct inode *inode,
+		       struct page *page)
 {
 	LIST_HEAD(one_request);
 	struct nfs_page	*new;
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index d9adb53..d1d545e 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -505,6 +505,8 @@ extern int  nfs_readpages(struct file *, struct address_space *,
 		struct list_head *, unsigned);
 extern int  nfs_readpage_result(struct rpc_task *, struct nfs_read_data *);
 extern void nfs_readdata_release(void *data);
+extern int  nfs_readpage_async(struct nfs_open_context *, struct inode *,
+			       struct page *);
 
 /*
  * Allocate nfs_read_data structures

