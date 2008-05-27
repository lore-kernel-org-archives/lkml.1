Return-Path: <linux-kernel-owner+w=401wt.eu-S1756743AbYE0H5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743AbYE0H5b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 03:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754777AbYE0H5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 03:57:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57844 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754760AbYE0H5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 03:57:22 -0400
Message-ID: <483BBE82.3020805@cn.fujitsu.com>
Date: Tue, 27 May 2008 15:55:46 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: shaggy@austin.ibm.com
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       jfs-discussion@lists.sourceforge.net
Subject: [PATCH] JFS: diAlloc() should return -EIO rather than EIO
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comment above the function says one of its return value is -EIO,
and also the caller of diAlloc() checks for -EIO:

struct inode *ialloc(struct inode *parent, umode_t mode)
{
	...
	rc = diAlloc(parent, S_ISDIR(mode), inode);
	if (rc) {
		jfs_warn("ialloc: diAlloc returned %d!", rc);
		if (rc == -EIO)
			make_bad_inode(inode);
	...

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/jfs/jfs_imap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/jfs/jfs_imap.c b/fs/jfs/jfs_imap.c
index 734ec91..d6363d8 100644
--- a/fs/jfs/jfs_imap.c
+++ b/fs/jfs/jfs_imap.c
@@ -1520,7 +1520,7 @@ int diAlloc(struct inode *pip, bool dir, struct inode *ip)
 					jfs_error(ip->i_sb,
 						  "diAlloc: can't find free bit "
 						  "in wmap");
-					return EIO;
+					return -EIO;
 				}
 
 				/* determine the inode number within the
-- 1.5.4.rc3
