Return-Path: <linux-kernel-owner+w=401wt.eu-S1758438AbZHRAMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758438AbZHRAMV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 20:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758225AbZHRAMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 20:12:20 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53680 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730AbZHRAMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 20:12:19 -0400
Date: Tue, 18 Aug 2009 10:12:15 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Chinner <david@fromorbit.com>, xfs-masters@oss.sgi.com
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Eric Sandeen <sandeen@sandeen.net>, Felix Blyakher <felixb@sgi.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: linux-next: manual merge of the xfs tree with Linus' tree
Message-Id: <20090818101215.aba4d0bf.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the xfs tree got a conflict in
fs/xfs/linux-2.6/xfs_sync.h between commit
bc990f5cb424cdca9dda866785d088e2c2110ecc ("xfs: fix locking in
xfs_iget_cache_hit") from Linus' tree and commit
370f048214b4e9aa2102fa3c454ae1374da287c5 ("xfs: add more statics & drop
some unused functions") from the xfs tree.

Just context changes (add/remove). I fixed it up (see below) and can
carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/xfs/linux-2.6/xfs_sync.h
index 5912060,23e7e7e..0000000
--- a/fs/xfs/linux-2.6/xfs_sync.h
+++ b/fs/xfs/linux-2.6/xfs_sync.h
@@@ -48,8 -48,6 +48,7 @@@ int xfs_reclaim_inode(struct xfs_inode 
  int xfs_reclaim_inodes(struct xfs_mount *mp, int mode);
  
  void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
 +void __xfs_inode_set_reclaim_tag(struct xfs_perag *pag, struct xfs_inode *ip);
- void xfs_inode_clear_reclaim_tag(struct xfs_inode *ip);
  void __xfs_inode_clear_reclaim_tag(struct xfs_mount *mp, struct xfs_perag *pag,
  				struct xfs_inode *ip);
  
