Return-Path: <linux-kernel-owner+w=401wt.eu-S1761890AbXJDQEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761890AbXJDQEp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 12:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759879AbXJDP6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 11:58:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45682 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759870AbXJDP6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 11:58:11 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 18/32] IGET: Stop FUSE from using iget() and read_inode() [try
	#2]
To: hch@infradead.org, viro@ftp.linux.org.uk, torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       dhowells@redhat.com
Date: Thu, 04 Oct 2007 16:57:34 +0100
Message-ID: <20071004155734.2814.58153.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071004155602.2814.47731.stgit@warthog.procyon.org.uk>
References: <20071004155602.2814.47731.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stop the FUSE filesystem from using read_inode(), which it doesn't use anyway.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/fuse/inode.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 5448f62..2986654 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -73,11 +73,6 @@ static void fuse_destroy_inode(struct inode *inode)
 	kmem_cache_free(fuse_inode_cachep, inode);
 }
 
-static void fuse_read_inode(struct inode *inode)
-{
-	/* No op */
-}
-
 void fuse_send_forget(struct fuse_conn *fc, struct fuse_req *req,
 		      unsigned long nodeid, u64 nlookup)
 {
@@ -452,7 +447,6 @@ static struct inode *get_root_inode(struct super_block *sb, unsigned mode)
 static const struct super_operations fuse_super_operations = {
 	.alloc_inode    = fuse_alloc_inode,
 	.destroy_inode  = fuse_destroy_inode,
-	.read_inode	= fuse_read_inode,
 	.clear_inode	= fuse_clear_inode,
 	.drop_inode	= generic_delete_inode,
 	.remount_fs	= fuse_remount_fs,

