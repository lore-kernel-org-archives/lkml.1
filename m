Return-Path: <linux-kernel-owner+w=401wt.eu-S1756896AbXIABwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896AbXIABwg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 21:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752646AbXIABoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 21:44:00 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51610 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751750AbXIABmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 21:42:24 -0400
Message-Id: <20070901014224.140616098@sgi.com>
References: <20070901014107.719506437@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 31 Aug 2007 18:41:28 -0700
From: Christoph Lameter <clameter@sgi.com>
To: Andy Whitcroft <apw@shadowen.org>
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: David Chinner <dgc@sgi.com>
Subject: [RFC 21/26] FS: Slab defrag: Reiserfs support
Content-Disposition: inline; filename=0021-slab_defrag_reiserfs.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Slab defragmentation: Support reiserfs inode defragmentation

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 fs/reiserfs/super.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 5b68dd3..0344be9 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -520,6 +520,12 @@ static void init_once(void *foo, struct kmem_cache * cachep, unsigned long flags
 #endif
 }
 
+static void *reiserfs_get_inodes(struct kmem_cache *s, int nr, void **v)
+{
+	return fs_get_inodes(s, nr, v,
+		offsetof(struct reiserfs_inode_info, vfs_inode));
+}
+
 static int init_inodecache(void)
 {
 	reiserfs_inode_cachep = kmem_cache_create("reiser_inode_cache",
@@ -530,6 +536,8 @@ static int init_inodecache(void)
 						  init_once);
 	if (reiserfs_inode_cachep == NULL)
 		return -ENOMEM;
+	kmem_cache_setup_defrag(reiserfs_inode_cachep,
+			reiserfs_get_inodes, kick_inodes);
 	return 0;
 }
 
-- 
1.5.2.4

-- 
