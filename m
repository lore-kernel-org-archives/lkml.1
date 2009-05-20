Return-Path: <linux-kernel-owner+w=401wt.eu-S1753579AbZETFd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579AbZETFd7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 01:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751488AbZETFdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 01:33:50 -0400
Received: from kroah.org ([198.145.64.141]:41952 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471AbZETFdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 01:33:49 -0400
Date: Tue, 19 May 2009 22:29:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.27.24
Message-ID: <20090520052906.GA13453@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.27.24 kernel.  All users of the
2.6.27 kernel series are very strongly encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.27.23 and 2.6.27.24

The updated 2.6.27.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary

thanks,

greg k-h

------------

 Documentation/filesystems/Locking |   26 ++-
 Makefile                          |    2 
 drivers/i2c/algos/i2c-algo-bit.c  |    2 
 drivers/i2c/algos/i2c-algo-pca.c  |   11 +
 drivers/md/bitmap.c               |   29 ++--
 drivers/md/md.c                   |    7 
 drivers/md/raid10.c               |   12 -
 drivers/net/ehea/ehea_main.c      |   31 ++--
 drivers/serial/mpc52xx_uart.c     |    2 
 drivers/usb/gadget/usbstring.c    |    6 
 drivers/video/fb_defio.c          |    3 
 fs/buffer.c                       |   20 ++
 fs/cifs/cifs_unicode.h            |    7 
 fs/cifs/cifssmb.c                 |   17 +-
 fs/cifs/connect.c                 |    6 
 fs/cifs/misc.c                    |    5 
 fs/cifs/readdir.c                 |    2 
 fs/cifs/sess.c                    |   44 +++---
 fs/eventpoll.c                    |    2 
 fs/ext4/ext4.h                    |    2 
 fs/ext4/inode.c                   |    5 
 fs/fcntl.c                        |    6 
 fs/fuse/file.c                    |    3 
 fs/gfs2/ops_file.c                |    7 
 fs/nfs/dir.c                      |    9 -
 fs/nfs/file.c                     |    9 -
 fs/nfsd/nfs4xdr.c                 |   16 ++
 fs/ocfs2/file.c                   |   94 ++++++++++---
 fs/ocfs2/mmap.c                   |    6 
 fs/splice.c                       |  274 +++++++++++++++++++++++---------------
 fs/ubifs/file.c                   |    9 -
 fs/xfs/linux-2.6/xfs_file.c       |    4 
 include/linux/buffer_head.h       |    2 
 include/linux/mm.h                |    3 
 include/linux/splice.h            |   12 +
 mm/memory.c                       |  132 +++++++++++++-----
 36 files changed, 546 insertions(+), 281 deletions(-)

Alan Stern (1):
      USB: Gadget: fix UTF conversion in the usbstring library

Dave Airlie (1):
      i2c-algo-bit: Fix timeout test

Davide Libenzi (1):
      epoll: fix size check in epoll_create()

Enrik Berkhan (1):
      i2c-algo-pca: Let PCA9564 recover from unacked data byte (state 0x30)

Grant Likely (1):
      powerpc/5200: Don't specify IRQF_SHARED in PSC UART driver

Greg Kroah-Hartman (1):
      Linux 2.6.27.24

Hannes Hering (1):
      ehea: fix invalid pointer access

J. Bruce Fields (1):
      nfsd4: check for negative dentry before use in nfsv4 readdir

Jeff Layton (2):
      cifs: Fix buffer size for tcon->nativeFileSystem field
      cifs: Fix unicode string area word alignment in session setup

Jeff Mahoney (1):
      dup2: Fix return value with oldfd == newfd and invalid fd

Miklos Szeredi (4):
      splice: split up __splice_from_pipe()
      splice: remove i_mutex locking in splice_from_pipe()
      splice: fix i_mutex locking in generic_splice_write()
      ocfs2: fix i_mutex locking in ocfs2_splice_to_file()

NeilBrown (4):
      md: fix loading of out-of-date bitmap.
      md: fix some (more) errors with bitmaps on devices larger than 2TB.
      md/raid10: don't clear bitmap during recovery if array will still be degraded.
      md: remove ability to explicit set an inactive array to 'clean'.

Nick Piggin (3):
      mm: page_mkwrite change prototype to match fault
      fs: fix page_mkwrite error cases in core code and btrfs
      mm: close page_mkwrite races

Steven Whitehouse (1):
      GFS2: Fix page_mkwrite() return code

Suresh Jayaraman (3):
      cifs: Increase size of tmp_buf in cifs_readdir to avoid potential overflows
      cifs: Fix incorrect destination buffer size in cifs_strncpy_to_host
      cifs: Fix buffer size in cifs_convertUCSpath

Trond Myklebust (3):
      NFS: Fix the return value in nfs_page_mkwrite()
      NFS: Close page_mkwrite() races
      NFS: Fix the notifications when renaming onto an existing file

