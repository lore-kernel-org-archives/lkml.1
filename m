Return-Path: <linux-kernel-owner+w=401wt.eu-S2992588AbXEBAsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992588AbXEBAsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 20:48:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992584AbXEBAsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 20:48:11 -0400
Received: from canuck.infradead.org ([209.217.80.40]:55062 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992592AbXEBAsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 20:48:06 -0400
Date: Tue, 1 May 2007 17:45:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.20.11
Message-ID: <20070502004508.GA22995@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.20.11 kernel.
It contains a number of bugfixes from the 2.6.20.10 release, and anyone
who is having any issues with 2.6.20.10 is encouraged to update.

I'll also be replying to this message with a copy of the patch between
2.6.20.10 and 2.6.20.11.

The updated 2.6.20.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.20.y.git
and can be browsed at the normal kernel.org git web browser:
        www.kernel.org/git/

thanks,

greg k-h

--------
 Makefile                               |    2 
 arch/i386/boot/video.S                 |   14 
 arch/sparc64/kernel/pci_iommu.c        |    2 
 arch/sparc64/kernel/sbus.c             |  560 +++++++++++++--------------------
 arch/sparc64/kernel/sys32.S            |    1 
 arch/sparc64/kernel/systbls.S          |    2 
 arch/x86_64/boot/video.S               |   14 
 arch/x86_64/kernel/k8.c                |    4 
 block/cfq-iosched.c                    |   12 
 drivers/char/agp/intel-agp.c           |    3 
 drivers/char/mem.c                     |    2 
 drivers/char/vt_ioctl.c                |   16 
 drivers/hid/hid-core.c                 |    4 
 drivers/hwmon/w83627ehf.c              |    6 
 drivers/infiniband/hw/mthca/mthca_mr.c |    1 
 drivers/kvm/mmu.c                      |   53 ++-
 drivers/pci/probe.c                    |   45 --
 drivers/scsi/3w-xxxx.c                 |   11 
 drivers/scsi/qlogicpti.c               |    2 
 drivers/serial/8250.c                  |    3 
 fs/exec.c                              |   18 -
 fs/nfs/dir.c                           |    3 
 fs/nfs/inode.c                         |    6 
 fs/reiserfs/xattr.c                    |   92 +----
 include/linux/taskstats.h              |   13 
 mm/madvise.c                           |   19 -
 mm/migrate.c                           |   15 
 mm/oom_kill.c                          |    2 
 mm/shmem.c                             |  132 +++++--
 net/core/netpoll.c                     |    7 
 net/ipv4/tcp.c                         |   13 
 net/irda/af_irda.c                     |    3 
 net/sunrpc/svcauth_unix.c              |   21 -
 sound/pci/intel8x0.c                   |    5 
 34 files changed, 571 insertions(+), 535 deletions(-)

Summary of changes from v2.6.20.10 to v2.6.20.11
===============================================

Alan Cox (1):
      exec.c: fix coredump to pipe problem and obscure "security hole"

Aubrey.Li (1):
      Fix netpoll UDP input path

Avi Kivity (2):
      KVM: MMU: Fix guest writes to nonpae pde
      KVM: MMU: Fix host memory corruption on i386 with >= 4GB ram

Badari Pulavarty (1):
      cache_k8_northbridges() overflows beyond allocation

Balbir Singh (1):
      Taskstats fix the structure members alignment issue

Bartlomiej Zolnierkiewicz (1):
      Revert "adjust legacy IDE resource setting (v2)"

Benjamin Herrenschmidt (1):
      fix bogon in /dev/mem mmap'ing on nommu

Christoph Lameter (1):
      page migration: fix NR_FILE_PAGES accounting

David Miller (3):
      Fix sparc64 SBUS IOMMU allocator
      Fix qlogicpti DMA unmapping
      Fix compat sys_ipc() on sparc64

Greg Kroah-Hartman (1):
      Linux 2.6.20.11

Hugh Dickins (5):
      holepunch: fix shmem_truncate_range punching too far
      holepunch: fix shmem_truncate_range punch locking
      holepunch: fix disconnected pages after second truncate
      holepunch: fix mmap_sem i_mutex deadlock
      fix OOM killing processes wrongly thought MPOL_BIND

James Bottomley (1):
      3w-xxxx: fix oops caused by incorrect REQUEST_SENSE handling

Jean Delvare (1):
      hwmon/w83627ehf: Fix the fan5 clock divider write

Jeff Mahoney (1):
      reiserfs: fix xattr root locking/refcount bug

Jens Axboe (1):
      cfq-iosched: fix alias + front merge bug

Jiri Kosina (1):
      HID: zeroing of bytes in output fields is bogus

John Heffner (1):
      Fix errors in tcp_mem[] calculations.

Michael S. Tsirkin (1):
      IB/mthca: Fix data corruption after FMR unmap on Sinai

Michal Januszewski (1):
      vt: fix potential race in VT_WAITACTIVE handler

NeilBrown (1):
      knfsd: Use a spinlock to protect sk_info_authunix

Olaf Kirch (1):
      Fix IRDA oops'er

Taku Izumi (1):
      Fix possible NULL pointer access in 8250 serial driver

Tom "spot" Callaway (1):
      Fix bogus inline directive in sparc64 PCI code

Tommi Kyntola (1):
      ALSA: intel8x0 - Fix speaker output after S2RAM

Trond Myklebust (1):
      NFS: Fix an Oops in nfs_setattr()

Wang Zhenyu (1):
      AGPGART: intel_agp: fix G965 GTT size detect

Zwane Mwaikambo (1):
      x86: Don't probe for DDC on VBE1.2

