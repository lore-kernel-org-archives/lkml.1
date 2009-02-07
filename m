Return-Path: <linux-kernel-owner+w=401wt.eu-S1754711AbZBGALW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbZBGALW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 19:11:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751784AbZBGALO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 19:11:14 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:36796 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbZBGALN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 19:11:13 -0500
Subject: Re: [GIT PULL] Btrfs updates for 2.6.29-rc
From: Chris Mason <chris.mason@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.0902061358070.3048@localhost.localdomain>
References: <1233937349.17551.18.camel@think.oraclecorp.com>
	 <alpine.LFD.2.00.0902060851270.3048@localhost.localdomain>
	 <1233957067.10366.0.camel@think.oraclecorp.com>
	 <alpine.LFD.2.00.0902061358070.3048@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 06 Feb 2009 19:10:57 -0500
Message-Id: <1233965457.10366.11.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.498CD194.028D:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-06 at 13:59 -0800, Linus Torvalds wrote:
> 
> On Fri, 6 Feb 2009, Chris Mason wrote:
> >
> >  18 files changed, 996 insertions(+), 134 deletions(-)
> 
> This is not at all what I get. I get
> 
>  27 files changed, 1421 insertions(+), 451 deletions(-)
> 
> so there is some confusion there.

Crud, the confusion would be me.  I missed the cleanups and bug fixes
between 2.6.29-rc1 and rc3.   The correct diffstat and short log are
below, and the only non-btrfs change is to the MAINTAINERS file.

MAINTAINERS             |    8
 fs/btrfs/Kconfig        |   13 +
 fs/btrfs/async-thread.c |   61 +++++-
 fs/btrfs/compression.c  |    1
 fs/btrfs/ctree.c        |  276 ++++++++++++++++++++++++++----
 fs/btrfs/ctree.h        |   28 +--
 fs/btrfs/disk-io.c      |  120 +++++++++----
 fs/btrfs/disk-io.h      |    2
 fs/btrfs/extent-tree.c  |  438 ++++++++++++++++++++++++++++++++++++++++--------
 fs/btrfs/extent_io.c    |  132 +++++++++++---
 fs/btrfs/extent_io.h    |   18 +
 fs/btrfs/extent_map.c   |    1
 fs/btrfs/file.c         |    5
 fs/btrfs/inode.c        |   84 +++++++--
 fs/btrfs/ioctl.c        |    1
 fs/btrfs/locking.c      |  208 ++++++++++++++++++++--
 fs/btrfs/locking.h      |    6
 fs/btrfs/ordered-data.c |    4
 fs/btrfs/ref-cache.c    |    1
 fs/btrfs/ref-cache.h    |    1
 fs/btrfs/super.c        |    6
 fs/btrfs/transaction.c  |    4
 fs/btrfs/tree-defrag.c  |    1
 fs/btrfs/tree-log.c     |  354 ++++++++++++++++++--------------------
 fs/btrfs/volumes.c      |   49 ++---
 fs/btrfs/xattr.c        |   48 ++++-
 fs/btrfs/xattr.h        |    2
 27 files changed, 1421 insertions(+), 451 deletions(-)

Chris Ball (1):
      Btrfs: Handle SGID bit when creating inodes

Chris Mason (19):
      Btrfs: stop providing a bmap operation to avoid swapfile corruptions
      Btrfs: do less aggressive btree readahead
      Merge branch 'master' of git://git.kernel.org/.../mason/btrfs-unstable
      Btrfs: fix readdir on 32 bit machines
      Btrfs: Catch missed bios in the async bio submission thread
      Btrfs: async threads should try harder to find work
      Btrfs: sort references by byte number during btrfs_inc_ref
      Btrfs: disable leak debugging checks in extent_io.c
      Btrfs: hash_lock is no longer needed
      Btrfs: Change btree locking to use explicit blocking points
      Btrfs: Make btrfs_drop_snapshot work in larger and more efficient chunks
      Btrfs: Don't try to compress pages past i_size
      Btrfs: Change btrfs_truncate_inode_items to stop when it hits the inode
      Btrfs: change btrfs_del_leaf to drop locks earlier
      Btrfs: fix btrfs_unlock_up_safe to walk the entire path
      Btrfs: Only prep for btree deletion balances when nodes are mostly empty
      Btrfs: don't return congestion in write_cache_pages as often
      Btrfs: Fix memory leak in cache_drop_leaf_ref
      Btrfs: Make sure dir is non-null before doing S_ISGID checks

Christian Hesse (1):
      Btrfs: make btrfs acls selectable

Huang Weiyi (2):
      Btrfs: removed unused #include <version.h>'s
      Btrfs: remove duplicated #include

Jan Engelhardt (1):
      Btrfs: change/remove typedef

Jim Owens (1):
      Btrfs: selinux support

Joe Perches (1):
      Btrfs: MAINTAINERS entry

Josef Bacik (2):
      Btrfs: cleanup xattr code
      Btrfs: join the transaction in __btrfs_setxattr

Qinghuang Feng (3):
      Btrfs: check return value for kthread_run() correctly
      Btrfs: simplify iteration codes
      Btrfs: open_ctree() error handling can oops on fs_info

Roland Dreier (1):
      Btrfs: Remove extra KERN_INFO in the middle of a line

Wang Cong (1):
      Btrfs: cleanup fs/btrfs/super.c::btrfs_control_ioctl()

Yan Zheng (4):
      Btrfs: fix locking issue in btrfs_remove_block_group
      Btrfs: Fix infinite loop in btrfs_extent_post_op
      Btrfs: fix stop searching test in replace_one_extent
      Btrfs: fix tree logs parallel sync

Yehuda Sadeh (1):
      Btrfs: fiemap support



