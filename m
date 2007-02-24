Return-Path: <linux-kernel-owner+w=401wt.eu-S932791AbXBXADe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932791AbXBXADe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 19:03:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933206AbXBXADe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 19:03:34 -0500
Received: from ns1.suse.de ([195.135.220.2]:56910 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932791AbXBXADd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 19:03:33 -0500
Date: Fri, 23 Feb 2007 16:02:05 -0800
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@osdl.org>, torvalds@osdl.org, stable@kernel.org
Subject: Linux 2.6.18.8
Message-ID: <20070224000205.GC4503@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.18.8 kernel.
It contains a number of bugfixes, and all 2.6.18 users are recommended
to upgrade.

Barring anything extremely serious, this will be the last 2.6.18 based
release.

The diffstat and short summary of the fixes are below.

I'll also be replying to this message with a copy of the patch between
2.6.18.7 and 2.6.18.8, as it is small enough to do so.

The updated 2.6.18.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.18.y.git
and can be browsed at the normal kernel.org git web browser:
        www.kernel.org/git/

thanks,

greg k-h
--------

 Makefile                                          |    2 
 arch/x86_64/ia32/ptrace32.c                       |    1 
 arch/x86_64/kernel/entry.S                        |    4 
 arch/x86_64/kernel/setup64.c                      |    4 
 drivers/char/mem.c                                |   12 -
 drivers/i2c/chips/ds1337.c                        |    8 
 drivers/infiniband/core/mad.c                     |    2 
 drivers/infiniband/ulp/srp/ib_srp.c               |    2 
 drivers/infiniband/ulp/srp/ib_srp.h               |    2 
 drivers/media/dvb/dvb-core/dvb_net.c              |    4 
 drivers/media/video/cx88/cx88-cards.c             |    2 
 drivers/media/video/ks0127.c                      |    8 
 drivers/media/video/tveeprom.c                    |    2 
 drivers/media/video/usbvideo/quickcam_messenger.h |   14 -
 drivers/media/video/video-buf.c                   |    1 
 drivers/net/wireless/bcm43xx/bcm43xx.h            |    2 
 drivers/net/wireless/bcm43xx/bcm43xx_main.c       |    8 
 drivers/net/wireless/bcm43xx/bcm43xx_xmit.h       |   10 -
 drivers/scsi/scsi_lib.c                           |    1 
 fs/buffer.c                                       |   21 ++
 fs/ext2/super.c                                   |    4 
 fs/ext3/super.c                                   |    4 
 fs/hfs/super.c                                    |    2 
 include/asm-powerpc/current.h                     |   12 +
 include/asm-x86_64/system.h                       |    5 
 include/media/cx2341x.h                           |    2 
 mm/memory.c                                       |   32 ++-
 mm/mincore.c                                      |  183 +++++++++-------------
 mm/msync.c                                        |   66 +++----
 mm/shmem.c                                        |    7 
 30 files changed, 223 insertions(+), 204 deletions(-)

Summary of changes from v2.6.18.7 to v2.6.18.8
==============================================

Andi Kleen (1):
      Don't leak NT bit into next task

Andrew Morton (1):
      grow_buffers() infinite loop fix (CVE-2006-5757, CVE-2006-6060)

Ang Way Chuang (1):
      dvb-core: fix bug in CRC-32 checking on 64-bit systems

Badari Pulavarty (1):
      Fix for shmem_truncate_range() BUG_ON()

Dirk Eibach (1):
      i2c: fix broken ds1337 initialization

Eric Sandeen (1):
      hfs_fill_super returns success even if no root inode (CVE-2006-6056)

Grant Likely (1):
      V4L: Fix quickcam communicator driver for big endian architectures

Greg Kroah-Hartman (1):
      Linux 2.6.18.8

Hans Verkuil (1):
      v4l: cx2341x audio_properties is an u16, not u8

Hugh Dickins (4):
      read_zero_pagealigned() locking fix
      fix msync error on unmapped area
      make ppc64 current preempt-safe
      fix umask when noACL kernel meets extN tuned for ACLs

Jean Delvare (1):
      v4l: cx88: Fix leadtek_eeprom tagging

Larry Finger (1):
      bcm43xx: Fix for oops on resume

Linus Torvalds (1):
      Fix incorrect user space access locking in mincore() (CVE-2006-4814)

Martin Samuelsson (1):
      V4L: fix ks0127 status flags

Michael Buesch (1):
      bcm43xx: Fix for oops on ampdu status

Michael Krufky (1):
      V4L: tveeprom: autodetect LG TAPC G701D as tuner type 37

Oleg Nesterov (1):
      V4L: buf_qbuf: fix videobuf_queue->stream corruption and lockup

Paolo 'Blaisorblade' Giarrusso (1):
      x86_64: fix 2.6.18 regression - PTRACE_OLDSETOPTIONS should be accepted

Roland Dreier (2):
      IB/srp: Fix FMR mapping for 32-bit kernels and addresses above 4G
      IB/mad: Fix race between cancel and receive completion

Tejun Heo (1):
      SCSI: add missing cdb clearing in scsi_execute()

