Return-Path: <linux-kernel-owner+w=401wt.eu-S1761939AbXEOQnE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761939AbXEOQnE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 12:43:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761648AbXEOQmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 12:42:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761640AbXEOQmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 12:42:50 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] AFS: Write back dirty data on unmount
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       dhowells@redhat.com
Date: Tue, 15 May 2007 17:42:39 +0100
Message-ID: <20070515164239.326.26554.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix AFS to write back dirty on unmounting.  This didn't happen because
afs_super_ops.drop_inode was pointing to generic_delete_inode.  Now this
pointer is left set to NULL so that the default behaviour occurs instead.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/super.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/afs/super.c b/fs/afs/super.c
index 579af63..370cecc 100644
--- a/fs/afs/super.c
+++ b/fs/afs/super.c
@@ -47,7 +47,6 @@ struct file_system_type afs_fs_type = {
 static const struct super_operations afs_super_ops = {
 	.statfs		= afs_statfs,
 	.alloc_inode	= afs_alloc_inode,
-	.drop_inode	= generic_delete_inode,
 	.write_inode	= afs_write_inode,
 	.destroy_inode	= afs_destroy_inode,
 	.clear_inode	= afs_clear_inode,

