Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab0BXEFx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 23:05:53 -0500
Received: from ozlabs.org ([203.10.76.45]:47947 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754381Ab0BXEFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 23:05:52 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] virtio & lguest
Date: Wed, 24 Feb 2010 14:35:39 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       Adam Litke <agl@us.ibm.com>, Amit Shah <amit.shah@redhat.com>,
       hch@lst.de, Jamie Lokier <jamie@shareable.org>,
       "Michael S. Tsirkin" <mst@redhat.com>, Shirley Ma <mashirle@us.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201002241435.40377.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Will be away for a month from tomorrow, so this is an early pull request).

The following changes since commit 9f3a6284880ceea452903e2043c88d7226736318:
  Linus Torvalds (1):
        Merge branch 'upstream' of git://ftp.linux-mips.org/pub/scm/upstream-linus

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git master

Adam Litke (2):
      virtio: Add memory statistics reporting to the balloon driver (V4)
      virtio: Fix scheduling while atomic in virtio_balloon stats

Amit Shah (29):
      virtio: Initialize vq->data entries to NULL
      virtio: console: We support only one device at a time
      virtio: console: encapsulate buffer information in a struct
      virtio: console: ensure add_inbuf can work for multiple ports as well
      virtio: console: introduce a get_inbuf helper to fetch bufs from in_vq
      virtio: console: don't assume a single console port.
      virtio: console: struct ports for multiple ports per device.
      virtio: console: ensure console size is updated on hvc open
      virtio: console: Separate out console-specific data into a separate struct
      virtio: console: Separate out console init into a new function
      virtio: console: Separate out find_vqs operation into a different function
      virtio: console: Introduce function to hand off data from host to readers
      virtio: console: Introduce a send_buf function for a common path for sending data to host
      virtio: console: Add a new MULTIPORT feature, support for generic ports
      virtio: console: Prepare for writing to userspace buffers
      virtio: console: Associate each port with a char device
      virtio: console: Add file operations to ports for open/read/write/poll
      virtio: console: Ensure only one process can have a port open at a time
      virtio: console: Register with sysfs and create a 'name' attribute for ports
      virtio: console: Remove cached data on port close
      virtio: console: Handle port hot-plug
      virtio: console: Add ability to hot-unplug ports
      virtio: console: Add debugfs files for each port to expose debug info
      virtio: console: show error message if hvc_alloc fails for console ports
      virtio: console: Ensure no memleaks in case of unused buffers
      virtio: console: Add ability to remove module
      virtio: console: Error out if we can't allocate buffers for control queue
      virtio: console: Fill ports' entire in_vq with buffers
      Add MAINTAINERS entry for virtio_console

Christoph Hellwig (1):
      virtio_blk: add block topology support

Jamie Lokier (1):
      Add __devexit_p around reference to virtio_pci_remove

Michael S. Tsirkin (1):
      virtio: use smp_XX barriers on SMP

Rusty Russell (9):
      virtio: fix balloon without VIRTIO_BALLOON_F_STATS_VQ
      lguest: remove unneeded zlib.h include in example launcher
      virtio: remove bogus barriers from DEBUG version of virtio_ring.c
      virtio: console: comment cleanup
      virtio: console: statically initialize virtio_cons
      hvc_console: make the ops pointer const.
      virtio: console: port encapsulation
      virtio: console: use vdev->priv to avoid accessing global var.
      virtio: console: remove global var

Shirley Ma (1):
      virtio: Add ability to detach unused buffers from vrings

 Documentation/lguest/lguest.c   |    1 -
 MAINTAINERS                     |    6 +
 drivers/block/virtio_blk.c      |   61 ++-
 drivers/char/Kconfig            |    8 +
 drivers/char/hvc_beat.c         |    2 +-
 drivers/char/hvc_console.c      |    7 +-
 drivers/char/hvc_console.h      |    7 +-
 drivers/char/hvc_iseries.c      |    2 +-
 drivers/char/hvc_iucv.c         |    2 +-
 drivers/char/hvc_rtas.c         |    2 +-
 drivers/char/hvc_udbg.c         |    2 +-
 drivers/char/hvc_vio.c          |    2 +-
 drivers/char/hvc_xen.c          |    2 +-
 drivers/char/virtio_console.c   | 1578 +++++++++++++++++++++++++++++++++++----
 drivers/virtio/virtio_balloon.c |  109 +++-
 drivers/virtio/virtio_pci.c     |    2 +-
 drivers/virtio/virtio_ring.c    |   59 ++-
 include/linux/virtio.h          |    4 +
 include/linux/virtio_balloon.h  |   15 +
 include/linux/virtio_blk.h      |   13 +
 include/linux/virtio_console.h  |   30 +-
 21 files changed, 1721 insertions(+), 193 deletions(-)

-- 
Away travelling 25Feb-26Mar (6 .de + 1 .pl + 17 .lt + 2 .sg)
