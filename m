Return-Path: <linux-kernel-owner+w=401wt.eu-S1752721AbZFOER2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbZFOER2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 00:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750805AbZFOERV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 00:17:21 -0400
Received: from sh.osrg.net ([192.16.179.4]:48645 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbZFOERU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 00:17:20 -0400
Date: Mon, 15 Jun 2009 13:17:17 +0900 (JST)
Message-Id: <20090615.131717.43576215.ryusuke@osrg.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [GIT PULL] nilfs2 update for 2.6.31 merge window
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 15 Jun 2009 13:17:18 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from

 git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-linus

to receive updates of nilfs:

 * Clean-ups of b-tree/block-mapping code
 * Several read performance tuning
 * Error code fix on snapshot delete request
 * Enhance forward compatibility in get-information ioctl commands
 * Clean-ups of removal list of segments
 * A correction in nilfs2.txt

The following changes since commit 07a2039b8eb0af4ff464efd3dfd95de5c02648c6
 Linus Torvalds (1):
      Linux 2.6.30

Hisashi Hifumi (1):
      NILFS2: Pagecache usage optimization on NILFS2

Ryusuke Konishi (21):
      nilfs2: remove nilfs_dat_prepare_free function
      nilfs2: unify bmap operations starting use of indirect block address
      nilfs2: add sufile function that can modify multiple segment usages
      nilfs2: eliminate removal list of segments
      nilfs2: remove header file for segment list operations
      nilfs2: remove nilfs_bmap_put_block
      nilfs2: remove nilfs_bmap_delete_block
      nilfs2: move get block functions in bmap.c into btree codes
      nilfs2: remove pointless NULL check of bpop_commit_alloc_ptr function
      nilfs2: remove useless b_low and b_high fields from nilfs_bmap struct
      nilfs2: remove bmap pointer operations
      nilfs2: remove nilfs_direct_operations from direct mapping
      nilfs2: remove nilfs_btree_operations from btree mapping
      nilfs2: allow future expansion of metadata read out via get info ioctl
      nilfs2: set bio unplug flag for the last bio in segment
      nilfs2: enable sync_page method
      nilfs2: modify list of unsupported features in caveats
      nilfs2: return EBUSY against delete request on snapshot
      nilfs2: use device's backing_dev_info for btree node caches
      nilfs2: add sync_page method to page caches of meta data
      nilfs2: support contiguous lookup of blocks

 Documentation/filesystems/nilfs2.txt |    5 +-
 fs/nilfs2/bmap.c                     |  272 +++++++------------------
 fs/nilfs2/bmap.h                     |  135 ++++++++-----
 fs/nilfs2/btnode.c                   |    9 +-
 fs/nilfs2/btnode.h                   |    2 +-
 fs/nilfs2/btree.c                    |  366 +++++++++++++++++++---------------
 fs/nilfs2/btree.h                    |   31 +---
 fs/nilfs2/cpfile.c                   |   47 ++---
 fs/nilfs2/cpfile.h                   |    4 +-
 fs/nilfs2/dat.c                      |   36 +---
 fs/nilfs2/dat.h                      |    2 +-
 fs/nilfs2/direct.c                   |  139 +++++++-------
 fs/nilfs2/direct.h                   |   20 +--
 fs/nilfs2/gcinode.c                  |    5 +-
 fs/nilfs2/inode.c                    |   18 +-
 fs/nilfs2/ioctl.c                    |   35 +---
 fs/nilfs2/mdt.c                      |    3 +-
 fs/nilfs2/nilfs.h                    |    1 +
 fs/nilfs2/recovery.c                 |   37 +++--
 fs/nilfs2/segbuf.c                   |    3 +-
 fs/nilfs2/seglist.h                  |   85 --------
 fs/nilfs2/segment.c                  |  130 ++++---------
 fs/nilfs2/segment.h                  |   12 +-
 fs/nilfs2/sufile.c                   |  119 ++++++++++-
 fs/nilfs2/sufile.h                   |   62 ++++--
 fs/nilfs2/super.c                    |    9 +-
 fs/nilfs2/the_nilfs.c                |    1 -
 27 files changed, 727 insertions(+), 861 deletions(-)
 delete mode 100644 fs/nilfs2/seglist.h

Thanks,
Ryusuke Konishi
