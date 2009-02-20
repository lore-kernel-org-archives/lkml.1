Return-Path: <linux-kernel-owner+w=401wt.eu-S1756560AbZBTW7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560AbZBTW7u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 17:59:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754353AbZBTW7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 17:59:12 -0500
Received: from kroah.org ([198.145.64.141]:40679 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754109AbZBTW7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 17:59:09 -0500
Date: Fri, 20 Feb 2009 14:55:49 -0800
From: Og <og@kroah.com>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: greg@kroah.com
Subject: Re: Li-nux 2.6.27.19
Message-ID: <20090220225549.GB14122@kroah.com>
References: <20090220225448.GA14122@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090220225448.GA14122@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.19:

 Makefile                    |    2 
 arch/powerpc/kernel/align.c |    7 
 arch/x86/mm/pageattr.c      |   14 +
 drivers/ata/pata_via.c      |    4 
 drivers/ata/sata_nv.c       |   14 -
 drivers/bluetooth/btsdio.c  |    3 
 drivers/net/3c505.c         |   26 +
 drivers/pci/intel-iommu.c   |   13 
 drivers/scsi/libiscsi.c     |    1 
 fs/ext2/super.c             |    9 
 fs/ext4/balloc.c            |  156 +++++++++++
 fs/ext4/ext4.h              |   41 ++-
 fs/ext4/ext4_sb.h           |    4 
 fs/ext4/hash.c              |   77 ++++-
 fs/ext4/ialloc.c            |  166 +++++++-----
 fs/ext4/inode.c             |   59 +++-
 fs/ext4/mballoc.c           |  595 ++++++++++++++++++++++++++++++++------------
 fs/ext4/mballoc.h           |   51 +--
 fs/ext4/namei.c             |   28 +-
 fs/ext4/resize.c            |   61 +---
 fs/ext4/super.c             |   46 ++-
 fs/jbd2/commit.c            |   27 +
 include/linux/jbd2.h        |    4 
 include/linux/pci_ids.h     |    1 
 include/linux/pid.h         |   18 +
 ipc/mqueue.c                |    3 
 26 files changed, 1068 insertions(+), 362 deletions(-)

Aneesh Kumar K.V (14):
      ext4: Fix the delalloc writepages to allocate blocks at the right offset.
      ext4: avoid ext4_error when mounting a fs with a single bg
      ext4: Don't overwrite allocation_context ac_status
      ext4: Add blocks added during resize to bitmap
      ext4: Use EXT4_GROUP_INFO_NEED_INIT_BIT during resize
      ext4: cleanup mballoc header files
      ext4: Use an rbtree for tracking blocks freed during transaction.
      ext4: don't use blocks freed but not yet committed in buddy cache init
      ext4: Fix race between read_block_bitmap() and mark_diskspace_used()
      ext4: Fix the race between read_inode_bitmap() and ext4_new_inode()
      ext4: Use new buffer_head flag to check uninit group bitmaps initialization
      ext4: mark the blocks/inode bitmap beyond end of group as used
      ext4: Don't allow new groups to be added during block allocation
      ext4: Init the complete page while building buddy cache

Carsten Otte (1):
      ext2/xip: refuse to change xip flag during remount with busy inodes

David Woodhouse (1):
      Fix Intel IOMMU write-buffer flushing

Eric W. Biederman (1):
      pid: implement ns_of_pid

Greg Kroah-Hartman (1):
      Linux 2.6.27.19

Jeremy Fitzhardinge (1):
      x86/cpa: make sure cpa is safe to call in lazy mmu mode

Mark Fasheh (1):
      jbd2: Add BH_JBDPrivateStart

Michael Neuling (1):
      powerpc/vsx: Fix VSX alignment handler for regs 32-63

Mike Christie (1):
      SCSI: libiscsi: fix iscsi pool leak

Roel Kluin (1):
      3c505: do not set pcb->data.raw beyond its size

Sergio Luis (1):
      btsdio: free sk_buff with kfree_skb

Sukadev Bhattiprolu (1):
      mqueue: fix si_pid value in mqueue do_notify()

Tejun Heo (1):
      sata_nv: give up hardreset on nf2

Theodore Ts'o (8):
      ext4: Add support for non-native signed/unsigned htree hash algorithms
      ext4: tone down ext4_da_writepages warnings
      jbd2: Add barrier not supported test to journal_wait_on_commit_record
      ext4: Add sanity checks for the superblock before mounting the filesystem
      ext4: only use i_size_high for regular files
      ext4: Add sanity check to make_indexed_dir
      jbd2: On a __journal_expect() assertion failure printk "JBD2", not "EXT3-fs"
      ext4: Initialize the new group descriptor when resizing the filesystem

Tomas Winkler (1):
      Bluetooth: Fix TX error path in btsdio driver

Yasunori Goto (1):
      ext4: Widen type of ext4_sb_info.s_mb_maxs[]

Zlatko Calusic (1):
      Add support for VT6415 PCIE PATA IDE Host Controller

