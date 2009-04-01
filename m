Return-Path: <linux-kernel-owner+w=401wt.eu-S935810AbZDAX10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935810AbZDAX10 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 19:27:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934365AbZDAXHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 19:07:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34730 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934290AbZDAXGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 19:06:49 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 39/43] NFS: nfs_readpage_async() needs to be accessible as a
	fallback for local caching [ver #46]
To: viro@ZenIV.linux.org.uk
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Date: Thu, 02 Apr 2009 00:06:43 +0100
Message-ID: <20090401230643.28177.48857.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090401230321.28177.12010.stgit@warthog.procyon.org.uk>
References: <20090401230321.28177.12010.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
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
Acked-by: Steve Dickson <steved@redhat.com>
Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 fs/nfs/read.c          |    4 ++--
 include/linux/nfs_fs.h |    2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)


diff --git a/fs/nfs/read.c b/fs/nfs/read.c
index f856004..98b7400 100644
--- a/fs/nfs/read.c
+++ b/fs/nfs/read.c
@@ -111,8 +111,8 @@ static void nfs_readpage_truncate_uninitialised_page(struct nfs_read_data *data)
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
index 8a99e79..fdffb41 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -516,6 +516,8 @@ extern int  nfs_readpages(struct file *, struct address_space *,
 		struct list_head *, unsigned);
 extern int  nfs_readpage_result(struct rpc_task *, struct nfs_read_data *);
 extern void nfs_readdata_release(void *data);
+extern int  nfs_readpage_async(struct nfs_open_context *, struct inode *,
+			       struct page *);
 
 /*
  * Allocate nfs_read_data structures

