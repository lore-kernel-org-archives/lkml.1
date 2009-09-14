Return-Path: <linux-kernel-owner+w=401wt.eu-S1752491AbZINNkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491AbZINNkt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 09:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751563AbZINNks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 09:40:48 -0400
Received: from sh.osrg.net ([192.16.179.4]:49014 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751063AbZINNkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 09:40:47 -0400
Date: Mon, 14 Sep 2009 22:40:14 +0900 (JST)
Message-Id: <20090914.224014.26151575.ryusuke@osrg.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [GIT PULL] nilfs2 updates for 2.6.32-rc1
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 14 Sep 2009 22:40:15 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please consider pulling the 'for-linus' branch from

 git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-linus

to receive the following updates of nilfs.  There is no major change
made in this series.  Meanwhile, a certain number of small
improvements and some amount of cleanups are included.


The following changes since commit 74fca6a42863ffacaf7ba6f1936a9f228950f657
 Linus Torvalds (1):
      Linux 2.6.31

Heiko Carstens (1):
      nilfs2: fix format string compile warning (ino_t)

Jiro SEKIBA (6):
      nilfs2: implement nilfs_show_options to display mount options in /proc/mounts
      nilfs2: remove redundant super block commit
      nilfs2: fix disorder of nilfs_write_super in nilfs_sync_fs
      nilfs2: clean up nilfs_write_super
      nilfs2: stop using periodic write_super callback
      nilfs2: shorten freeze period due to GC in write operation v3

Ryusuke Konishi (12):
      nilfs2: fix ignored error code in __nilfs_read_inode()
      nilfs2: use semaphore to protect pointer to a writable FS-instance
      nilfs2: always lookup disk block address before reading metadata block
      nilfs2: use GFP_NOIO for bio_alloc instead of GFP_NOWAIT
      nilfs2: remove nilfs_dat_abort_start and nilfs_dat_abort_free
      nilfs2: remove unused btree argument from btree functions
      nilfs2: stop zero-fill of btree path just before free it
      nilfs2: remove individual gfp constants for each metadata file
      nilfs2: add update functions of virtual block address to dat
      nilfs2: allow btree code to directly call dat operations
      nilfs2: convert nilfs_bmap_lookup to an inline function
      fs/Kconfig: move nilfs2 outside misc filesystems

Zhang Qiang (1):
      nilfs2: An unassigned variable is assigned to a never used structure member

Zhu Yanhai (1):
      nilfs2: add more check routines in mount process

 fs/Kconfig            |    2 +-
 fs/nilfs2/Kconfig     |    2 +-
 fs/nilfs2/bmap.c      |  151 ++-----------
 fs/nilfs2/bmap.h      |   76 +++----
 fs/nilfs2/btree.c     |  625 +++++++++++++++++++++++--------------------------
 fs/nilfs2/cpfile.c    |   11 +-
 fs/nilfs2/cpfile.h    |    2 -
 fs/nilfs2/dat.c       |   42 +++-
 fs/nilfs2/dat.h       |    8 +-
 fs/nilfs2/direct.c    |  161 +++++--------
 fs/nilfs2/ifile.h     |    1 -
 fs/nilfs2/inode.c     |    3 +-
 fs/nilfs2/ioctl.c     |   26 ++-
 fs/nilfs2/mdt.c       |   40 ++--
 fs/nilfs2/mdt.h       |    3 +-
 fs/nilfs2/recovery.c  |    3 +-
 fs/nilfs2/segbuf.c    |    4 +-
 fs/nilfs2/segment.c   |    7 +-
 fs/nilfs2/sufile.h    |    1 -
 fs/nilfs2/super.c     |  100 +++-----
 fs/nilfs2/the_nilfs.c |   15 +-
 fs/nilfs2/the_nilfs.h |   43 ++--
 22 files changed, 567 insertions(+), 759 deletions(-)

Thanks,
Ryusuke Konishi
