Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251Ab0CFVjV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 16:39:21 -0500
Received: from lazybastard.de ([212.112.238.170]:50767 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463Ab0CFVjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 16:39:20 -0500
Date: Sat, 6 Mar 2010 22:04:59 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Linus <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Please pull logfs tree
Message-ID: <20100306210459.GA21570@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

in principle this should be a simple pull request.  But as Stephen
noted, the logfs tree conflicts with a patch from hch and I am unsure
how best to proceed.

On Mon, 1 March 2010 16:04:45 +1100, Stephen Rothwell wrote:
> 
> I am carrying a few merge fixup patches in linux-next that I thought you
> might want a heads up about.  Hopefully, these will be fixed before you
> see them, but just in case, here they are (in no particular order).
> 
> This could also be taken as a reminder to the respective maintiners that
> they may want to do a merge of your tree before asking you to pull theirs.
> 
> [...]
> 
> 5) The vfs[9] tree modifies the write_inode method API (commit
> 716c28c0bc8bcbdd26e819f38dfc8fdfaafc0289 "pass writeback_control to
> ->write_inode") and the logfs[10] tree adds a write_inode method (commit
> 5db53f3e80dee2d9dff5e534f9e9fe1db17c9936 "[LogFS] add new flash file
> system"), so:

I see three solutions that are remotely sane.

1) pull git://git.kernel.org/pub/scm/linux/kernel/git/joern/logfs.git
and apply the patch at the bottom yourself.

2) pull git://git.kernel.org/pub/scm/linux/kernel/git/joern/logfs_for_2.6.34
A tree with the patch applied that won't work standalone but will work
after being pulled into your tree (tested locally).

3) pull git://git.kernel.org/pub/scm/linux/kernel/git/joern/logfs_for_2.6.34_alternative
A tree that merged your tree and the logfs tree, then has the patch
applied.  Works standalone but has an additional merge commit.

I would slightly prefer option 2), but you surely know better.

PS: And trees 2) and 3) haven't made it over from master.kernel.org yet.
    Not sure if I made a mistake or simply have to wait longer.

Jörn

-- 
Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it.
-- Brian W. Kernighan

>From aaaa4c850bbe2e02aca24b681180258d1671b15e Mon Sep 17 00:00:00 2001
From: Joern Engel <joern@logfs.org>
Date: Sat, 6 Mar 2010 21:25:08 +0100
Subject: [PATCH] [LogFS] Follow write_inode changes

Commit a9185b41a4f84971b930c519f0c63bd450c4810d changed the
write_inode prototype.
---
 fs/logfs/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/logfs/inode.c b/fs/logfs/inode.c
index 6d08b37..33ec1ae 100644
--- a/fs/logfs/inode.c
+++ b/fs/logfs/inode.c
@@ -282,7 +282,7 @@ struct inode *logfs_read_meta_inode(struct super_block *sb, u64 ino)
 	return inode;
 }
 
-static int logfs_write_inode(struct inode *inode, int do_sync)
+static int logfs_write_inode(struct inode *inode, struct writeback_control *wbc)
 {
 	int ret;
 	long flags = WF_LOCK;
-- 
1.6.6.1

