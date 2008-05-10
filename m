Return-Path: <linux-kernel-owner+w=401wt.eu-S1760866AbYEJDPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760866AbYEJDPt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 23:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753794AbYEJDJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 23:09:55 -0400
Received: from relay1.sgi.com ([192.48.171.29]:54161 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752411AbYEJDJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 23:09:19 -0400
Message-Id: <20080510030918.882272887@sgi.com>
References: <20080510030831.796641881@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 09 May 2008 20:08:49 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
CC: linux-fsdevel@vger.kernel.org
Cc: Mel Gorman <mel@skynet.ie>
Cc: andi@firstfloor.org
Cc: Rik van Riel <riel@redhat.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: mpm@selenic.com
Subject: [patch 18/21] Filesystem: Socket inode defragmentation
Content-Disposition: inline; filename=0030-FS-Socket-inode-defragmentation.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support inode defragmentation for sockets

Cc: netdev@vger.kernel.org
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 net/socket.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/net/socket.c b/net/socket.c
index 9d3fbfb..205f450 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -269,6 +269,12 @@ static void init_once(struct kmem_cache *cachep, void *foo)
 	inode_init_once(&ei->vfs_inode);
 }
 
+static void *sock_get_inodes(struct kmem_cache *s, int nr, void **v)
+{
+	return fs_get_inodes(s, nr, v,
+		offsetof(struct socket_alloc, vfs_inode));
+}
+
 static int init_inodecache(void)
 {
 	sock_inode_cachep = kmem_cache_create("sock_inode_cache",
@@ -280,6 +286,8 @@ static int init_inodecache(void)
 					      init_once);
 	if (sock_inode_cachep == NULL)
 		return -ENOMEM;
+	kmem_cache_setup_defrag(sock_inode_cachep,
+			sock_get_inodes, kick_inodes);
 	return 0;
 }
 
-- 
1.5.4.4

-- 
