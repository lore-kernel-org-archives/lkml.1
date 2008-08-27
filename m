Return-Path: <linux-kernel-owner+w=401wt.eu-S1754132AbYH0HxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbYH0HxJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 03:53:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752045AbYH0Hw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 03:52:59 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:40135 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018AbYH0Hw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 03:52:57 -0400
Date: Wed, 27 Aug 2008 09:52:55 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] block bits for 2.6.27
Message-ID: <20080827075254.GA20055@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Lets try this again. I pulled out the b0rken xen patch and the scsi
command table addition, since the latter can easily wait for 2.6.28 (and
in 2.6.27, users can just change the table after boot).

So please pull the revised collection from the below git url, thanks!

  git://git.kernel.dk/linux-2.6-block.git for-linus

Adel Gadllah (1):
      block: clean up cmdfilter sysfs interface

FUJITA Tomonori (5):
      block: move cmdfilter from gendisk to request_queue
      sg: restore command permission for TYPE_SCANNER
      block: rename blk_scsi_cmd_filter to blk_cmd_filter
      bio: fix bio_copy_kern() handling of bio->bv_len
      bio: fix __bio_copy_iov() handling of bio->bv_len

Jens Axboe (2):
      block: submit_bh() inadvertently discards barrier flag on a sync write
      block: remove blk_queue_tag_depth() and blk_queue_tag_queue()

Matthew Wilcox (1):
      block: remove unused ->busy part of the block queue tag map

 block/blk-core.c       |    2 +
 block/blk-tag.c        |    6 +-
 block/bsg.c            |   44 +++--------
 block/cmd-filter.c     |  196 ++++++++++++------------------------------------
 block/scsi_ioctl.c     |   94 ++++++++++++++++++++++-
 drivers/scsi/sg.c      |   17 ++++-
 fs/bio.c               |   48 ++++++++----
 fs/buffer.c            |   13 ++-
 include/linux/blkdev.h |   18 +++-
 include/linux/genhd.h  |   10 ---
 10 files changed, 223 insertions(+), 225 deletions(-)

-- 
Jens Axboe

