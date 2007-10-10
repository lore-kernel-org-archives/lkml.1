Return-Path: <linux-kernel-owner+w=401wt.eu-S1758350AbXJJVtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758350AbXJJVtf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 17:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757022AbXJJVoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 17:44:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757491AbXJJVof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 17:44:35 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 15/31] IGET: Stop FAT from using iget() and read_inode() [try
	#3]
To: hch@infradead.org, viro@ftp.linux.org.uk, torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       dhowells@redhat.com
Date: Wed, 10 Oct 2007 22:44:25 +0100
Message-ID: <20071010214424.17535.65855.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071010214308.17535.5406.stgit@warthog.procyon.org.uk>
References: <20071010214308.17535.5406.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stop the FAT filesystem from using iget() and read_inode().  Replace
the call to iget() with a call to ilookup().

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/fat/inode.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 960ed3d..9ae2e9f 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -629,8 +629,6 @@ static const struct super_operations fat_sops = {
 	.clear_inode	= fat_clear_inode,
 	.remount_fs	= fat_remount,
 
-	.read_inode	= make_bad_inode,
-
 	.show_options	= fat_show_options,
 };
 
@@ -667,8 +665,8 @@ static struct dentry *fat_get_dentry(struct super_block *sb, void *inump)
 	struct dentry *result;
 	__u32 *fh = inump;
 
-	inode = iget(sb, fh[0]);
-	if (!inode || is_bad_inode(inode) || inode->i_generation != fh[1]) {
+	inode = ilookup(sb, fh[0]);
+	if (!inode || inode->i_generation != fh[1]) {
 		if (inode)
 			iput(inode);
 		inode = NULL;

