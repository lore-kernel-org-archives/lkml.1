Return-Path: <linux-kernel-owner+w=401wt.eu-S935438AbZDCTfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935438AbZDCTfA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 15:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757889AbZDCTeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 15:34:50 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:41946 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002AbZDCTet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 15:34:49 -0400
Subject: [GIT PULL] Btrfs updates for 2.6.30-rc (batch #2)
From: Chris Mason <chris.mason@oracle.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 03 Apr 2009 15:32:58 -0400
Message-Id: <1238787179.24082.7.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020A.49D6648C.0098:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

This is the second batch of btrfs updates for the merge window, which
includes an assortment of optimizations, fixes, cleanups and small
features.

>From a performance point of view, synchronous writes get a big boost by
making sure we unplug instead of letting kblockd do it for us, and Josef
got rid of two more mutexes from the allocator.

mount -o ssd is much faster in multi-process workloads, and it does a
better job of preventing free space fragmentation as well.

Linus, you'll find these changes in the master branch of:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git

Amit Gud (1):
      Btrfs: fix race in worker_loop

Chris Mason (5):
      Btrfs: keep processing bios for a given bdev if our proc is batching
      Btrfs: unplug in the async bio submission threads
      Btrfs: break up btrfs_search_slot into smaller pieces
      Btrfs: Optimize locking in btrfs_next_leaf()
      Btrfs: rework allocation clustering

Dan Carpenter (2):
      Btrfs: remove dead code
      Btrfs: remove dead code

Eric Paris (1):
      Btrfs: introduce btrfs_show_options

Heiko Carstens (1):
      Btrfs: fix __ucmpdi2 compile bug on 32 bit builds

Jim Owens (1):
      Btrfs: remove unused ftrace include

Josef Bacik (4):
      Btrfs: free space cache cleanups
      Btrfs: clean up find_free_extent
      Btrfs: kill the block group alloc mutex
      Btrfs: kill the pinned_mutex

Sage Weil (2):
      Btrfs: notreelog mount option
      Btrfs: add flushoncommit mount option

Shen Feng (1):
      Btrfs: free inode struct when btrfs_new_inode fails

Stoyan Gaydarov (1):
      Btrfs: BUG to BUG_ON changes

Wu Fengguang (1):
      Btrfs: fix typos in comments

 fs/btrfs/async-thread.c     |    7
 fs/btrfs/ctree.c            |  312 ++++++++++++++++---------
 fs/btrfs/ctree.h            |   84 ++++--
 fs/btrfs/delayed-ref.c      |    1
 fs/btrfs/disk-io.c          |    8
 fs/btrfs/extent-tree.c      |  398 ++++++++++++++++-----------------
 fs/btrfs/extent_io.c        |   16 -
 fs/btrfs/extent_map.c       |    1
 fs/btrfs/free-space-cache.c |  530 +++++++++++++++++++++++++++++++-------------
 fs/btrfs/free-space-cache.h |   44 +++
 fs/btrfs/inode.c            |    5
 fs/btrfs/locking.c          |    4
 fs/btrfs/super.c            |   54 ++++
 fs/btrfs/transaction.c      |    7
 fs/btrfs/tree-log.c         |   12
 fs/btrfs/volumes.c          |   41 +++
 fs/btrfs/volumes.h          |    2
 17 files changed, 982 insertions(+), 544 deletions(-)


