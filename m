Return-Path: <linux-kernel-owner+w=401wt.eu-S1762122AbZBMU0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762122AbZBMU0Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 15:26:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753373AbZBMU0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 15:26:14 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:56486 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155AbZBMU0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 15:26:13 -0500
Subject: [GIT PULL] Btrfs updates for 2.6.29-rc
From: Chris Mason <chris.mason@oracle.com>
To: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 13 Feb 2009 15:25:55 -0500
Message-Id: <1234556755.4985.7.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4995D756.021E:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

The master branch
git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git

Has the following fixes and updates for 2.6.29-rc.  There is also a
branch named experimental that is very very experimental.

I think I pushed things out correctly so that master and experimental
didn't mix, but we've long established my ability to mess that part up.

These are cleanups and fixes that came out of testing and review.  The
lockdep fix is actually the biggest in terms of code, but that is under
CONFIG_DEBUG_LOCK_ALLOC.

SSD mode is changed to work better on ssds that do random writes poorly,
and btrfs_sync_fs is changed to skip the cleaning of old snapshots.
That still happens in the background, and it was making sync look slower
than it really was.

mount -o remount finally looks at the new options sent, so you can send
important things like mount -o compress,ssd for remounting now.

-chris

Chris Mason (4):
      Btrfs: process mount options on mount -o remount,
      Btrfs: use larger metadata clusters in ssd mode
      Btrfs: don't clean old snapshots on sync(1)
      Btrfs: make a lockdep class for the extent buffer locks

Jeff Mahoney (2):
      Btrfs: balance_level checks !child after access
      Btrfs: remove btrfs_init_path

Josef Bacik (1):
      Btrfs: make sure all pending extent operations are complete

Julia Lawall (1):
      Btrfs: fs/btrfs/volumes.c: remove useless kzalloc

Qinghuang Feng (1):
      Btrfs: remove unused code in split_state()

Yan Zheng (2):
      Btrfs: Avoid using __GFP_HIGHMEM with slab allocator
      Btrfs: hold trans_mutex when using btrfs_record_root_in_trans

 b/fs/btrfs/ctree.c       |   45 +++++++++++++++++++-------
 b/fs/btrfs/ctree.h       |   10 +----
 b/fs/btrfs/disk-io.c     |   46 ++++++++++++++++++++++++++
 b/fs/btrfs/disk-io.h     |   10 +++++
 b/fs/btrfs/extent-tree.c |    2 +
 b/fs/btrfs/extent_io.c   |    2 -
 b/fs/btrfs/inode-map.c   |    1 
 b/fs/btrfs/inode.c       |    2 -
 b/fs/btrfs/locking.c     |   11 ------
 b/fs/btrfs/super.c       |    1 
 b/fs/btrfs/transaction.c |    2 +
 b/fs/btrfs/tree-log.c    |    2 +
 b/fs/btrfs/volumes.c     |    2 +
 fs/btrfs/ctree.c         |   13 +------
 fs/btrfs/ctree.h         |    1 
 fs/btrfs/extent-tree.c   |   81 ++++++++++++++++++++++++++++-------------------
 fs/btrfs/inode.c         |    2 -
 fs/btrfs/super.c         |    4 ++
 fs/btrfs/volumes.c       |    4 --
 19 files changed, 157 insertions(+), 84 deletions(-)


