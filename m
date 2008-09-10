Return-Path: <linux-kernel-owner+w=401wt.eu-S1753660AbYIJIsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660AbYIJIsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 04:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477AbYIJIsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 04:48:16 -0400
Received: from ns1.suse.de ([195.135.220.2]:40671 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226AbYIJIsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 04:48:15 -0400
Date: Wed, 10 Sep 2008 01:48:13 -0700
From: Mark Fasheh <mfasheh@suse.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
       Joel Becker <joel.becker@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [git patches] Ocfs2 regression fix
Message-ID: <20080910084813.GZ4563@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: SUSE Labs, Novell, Inc
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from 'upstream-linus' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-linus

to receive the following updates:

 fs/ocfs2/aops.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Tao Ma (1):
      ocfs2: Fix a bug in direct IO read.

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 506c24f..a53da14 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -594,7 +594,7 @@ static int ocfs2_direct_IO_get_blocks(struct inode *inode, sector_t iblock,
 		goto bail;
 	}
 
-	if (!ocfs2_sparse_alloc(OCFS2_SB(inode->i_sb)) && !p_blkno) {
+	if (!ocfs2_sparse_alloc(OCFS2_SB(inode->i_sb)) && !p_blkno && create) {
 		ocfs2_error(inode->i_sb,
 			    "Inode %llu has a hole at block %llu\n",
 			    (unsigned long long)OCFS2_I(inode)->ip_blkno,
