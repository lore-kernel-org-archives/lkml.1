Return-Path: <linux-kernel-owner+w=401wt.eu-S1752859AbZG3VYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859AbZG3VYY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 17:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbZG3VYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 17:24:23 -0400
Received: from brick.kernel.dk ([93.163.65.50]:48863 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752737AbZG3VYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 17:24:11 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr, fweisbec@gmail.com,
       Alan.Brunelle@hp.com
Subject: [PATCH 0/9] Per-bdi writeback flusher threads v13
Date: Thu, 30 Jul 2009 23:23:55 +0200
Message-Id: <1248989044-21605-1-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.3.2.306.g4f4fa
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here's the 13th version of the writeback patches. Changes since v12:

- Update to 2.6.31-rc4 ('ish, it's on top of current -git, but wil apply
  to -rc4 as well).
- Drop the last patch in the series, it was a questionable optimization
  that needs to be tested and evaluated separately.

For ease of patching, I've put the full diff here:

  http://kernel.dk/writeback-v13.patch

and also stored this in a writeback-v12 branch that will not change,
you can pull that into Linus tree from here:

  git://git.kernel.dk/linux-2.6-block.git writeback-v13

I'm not aware of any problems with this code at this point, and it's
been sitting in -next for a few months without reported incidents.
The target for the patchset is still 2.6.32.

 b/block/blk-core.c            |    1 
 b/drivers/block/aoe/aoeblk.c  |    1 
 b/drivers/char/mem.c          |    1 
 b/fs/btrfs/disk-io.c          |    1 
 b/fs/buffer.c                 |    2 
 b/fs/char_dev.c               |    1 
 b/fs/configfs/inode.c         |    1 
 b/fs/fs-writeback.c           |  766 ++++++++++++++++++++++++++--------
 b/fs/fuse/inode.c             |    1 
 b/fs/hugetlbfs/inode.c        |    1 
 b/fs/nfs/client.c             |    1 
 b/fs/ocfs2/dlm/dlmfs.c        |    1 
 b/fs/ramfs/inode.c            |    1 
 b/fs/super.c                  |    3 
 b/fs/sysfs/inode.c            |    1 
 b/fs/ubifs/super.c            |    1 
 b/include/linux/backing-dev.h |   71 +++
 b/include/linux/fs.h          |   11 
 b/include/linux/writeback.h   |   15 
 b/kernel/cgroup.c             |    1 
 b/mm/Makefile                 |    2 
 b/mm/backing-dev.c            |  533 +++++++++++++++++++++++
 b/mm/page-writeback.c         |  157 ------
 b/mm/swap_state.c             |    1 
 b/mm/vmscan.c                 |    2 
 mm/pdflush.c                  |  269 -----------
 26 files changed, 1250 insertions(+), 596 deletions(-)

-- 
Jens Axboe

