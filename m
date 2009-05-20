Return-Path: <linux-kernel-owner+w=401wt.eu-S1754502AbZETFfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502AbZETFfZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 01:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751009AbZETFfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 01:35:12 -0400
Received: from kroah.org ([198.145.64.141]:41959 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892AbZETFfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 01:35:11 -0400
Date: Tue, 19 May 2009 22:30:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.29.4
Message-ID: <20090520053031.GC13453@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.29.4 kernel.  All users of the
2.6.29 kernel series are very strongly encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.29.3 and 2.6.29.4

The updated 2.6.29.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.29.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.29.y.git;a=summary

thanks,

greg k-h

------------

 Documentation/filesystems/Locking   |   26 ++-
 Makefile                            |    2 
 arch/x86/kvm/svm.c                  |    1 
 arch/x86/kvm/x86.c                  |    4 
 drivers/dma/dmatest.c               |    4 
 drivers/hid/hid-ids.h               |    5 
 drivers/hid/usbhid/hid-quirks.c     |    3 
 drivers/hwmon/w83781d.c             |    3 
 drivers/i2c/algos/i2c-algo-bit.c    |    2 
 drivers/i2c/algos/i2c-algo-pca.c    |   11 +
 drivers/md/bitmap.c                 |   29 +--
 drivers/md/md.c                     |    7 
 drivers/md/raid10.c                 |   12 -
 drivers/net/e1000/e1000_main.c      |    2 
 drivers/net/ehea/ehea_main.c        |   31 ++--
 drivers/net/ne2k-pci.c              |    7 
 drivers/serial/mpc52xx_uart.c       |    2 
 drivers/usb/gadget/usbstring.c      |    6 
 drivers/usb/serial/ftdi_sio.c       |   18 +-
 drivers/video/fb_defio.c            |    3 
 fs/btrfs/ctree.h                    |    2 
 fs/btrfs/inode.c                    |   12 +
 fs/buffer.c                         |   20 +-
 fs/cifs/cifs_unicode.h              |    7 
 fs/cifs/cifssmb.c                   |   17 +-
 fs/cifs/connect.c                   |    6 
 fs/cifs/misc.c                      |    5 
 fs/cifs/readdir.c                   |    2 
 fs/cifs/sess.c                      |   46 +++---
 fs/eventpoll.c                      |    2 
 fs/ext4/ext4.h                      |    2 
 fs/ext4/inode.c                     |    5 
 fs/fcntl.c                          |    6 
 fs/fuse/file.c                      |    3 
 fs/fuse/inode.c                     |    1 
 fs/gfs2/ops_file.c                  |    7 
 fs/ioctl.c                          |   75 +++++++--
 fs/lockd/svc.c                      |   15 +
 fs/nfs/dir.c                        |    9 -
 fs/nfs/file.c                       |    9 -
 fs/nfsd/nfs4xdr.c                   |   16 +-
 fs/ocfs2/file.c                     |   94 +++++++++---
 fs/ocfs2/mmap.c                     |    6 
 fs/splice.c                         |  274 ++++++++++++++++++++++--------------
 fs/ubifs/file.c                     |    9 -
 fs/xfs/linux-2.6/xfs_file.c         |    4 
 include/linux/buffer_head.h         |    2 
 include/linux/compiler.h            |    3 
 include/linux/mm.h                  |    3 
 include/linux/splice.h              |   12 +
 include/net/cipso_ipv4.h            |   17 ++
 include/net/netlabel.h              |   15 +
 mm/memory.c                         |  132 ++++++++++++-----
 net/ipv4/cipso_ipv4.c               |  130 +++++++++++++++++
 net/ipv4/syncookies.c               |    9 -
 net/ipv4/tcp_ipv4.c                 |    7 
 net/netlabel/netlabel_kapi.c        |   84 +++++++++++
 security/selinux/hooks.c            |   49 +-----
 security/selinux/include/netlabel.h |   23 +--
 security/selinux/netlabel.c         |  185 ++++++------------------
 security/smack/smack.h              |    1 
 security/smack/smack_lsm.c          |  130 +++++++++--------
 sound/pci/hda/patch_sigmatel.c      |    7 
 sound/soc/codecs/wm8990.c           |   40 ++---
 64 files changed, 1091 insertions(+), 590 deletions(-)

Alan Stern (3):
      usb-serial: ftdi_sio: fix reference counting of ftdi_private
      USB: Gadget: fix UTF conversion in the usbstring library
      HID: add NOGET quirk for devices from CH Products

Avi Kivity (2):
      KVM: SVM: Remove port 80 passthrough
      KVM: Make EFER reads safe when EFER does not exist

Bart Van Assche (1):
      Fix for enabling branch profiling makes sparse unusable

Dan Williams (1):
      dmatest: fix max channels handling

Dave Airlie (1):
      i2c-algo-bit: Fix timeout test

Davide Libenzi (1):
      epoll: fix size check in epoll_create()

Enrik Berkhan (1):
      i2c-algo-pca: Let PCA9564 recover from unacked data byte (state 0x30)

Grant Likely (1):
      powerpc/5200: Don't specify IRQF_SHARED in PSC UART driver

Greg Kroah-Hartman (1):
      Linux 2.6.29.4

Hannes Hering (1):
      ehea: fix invalid pointer access

J. Bruce Fields (2):
      nfsd4: check for negative dentry before use in nfsv4 readdir
      lockd: fix list corruption on lockd restart

Jean Delvare (1):
      hwmon: (w83781d) Fix W83782D support (NULL pointer dereference)

Jeff Layton (2):
      cifs: Fix buffer size for tcon->nativeFileSystem field
      cifs: Fix unicode string area word alignment in session setup

Jeff Mahoney (1):
      dup2: Fix return value with oldfd == newfd and invalid fd

Jesse Brandeburg (1):
      e1000: fix virtualization bug

Jinyoung Park (1):
      ASoC: Fix errors in WM8990

Josef Bacik (1):
      fiemap: fix problem with setting FIEMAP_EXTENT_LAST

Lubomir Rintel (1):
      ne2k-pci: Do not register device until initialized.

Miklos Szeredi (5):
      fuse: destroy bdi on error
      splice: split up __splice_from_pipe()
      splice: remove i_mutex locking in splice_from_pipe()
      splice: fix i_mutex locking in generic_splice_write()
      ocfs2: fix i_mutex locking in ocfs2_splice_to_file()

NeilBrown (4):
      md: remove ability to explicit set an inactive array to 'clean'.
      md: fix some (more) errors with bitmaps on devices larger than 2TB.
      md/raid10: don't clear bitmap during recovery if array will still be degraded.
      md: fix loading of out-of-date bitmap.

Nick Piggin (3):
      mm: page_mkwrite change prototype to match fault
      fs: fix page_mkwrite error cases in core code and btrfs
      mm: close page_mkwrite races

Paul Moore (7):
      lsm: Relocate the IPv4 security_inet_conn_request() hooks
      netlabel: Add CIPSO {set, del}attr request_sock functions
      netlabel: Add new NetLabel KAPI interfaces for request_sock security attributes
      selinux: Add new NetLabel glue code to handle labeling of connection requests
      selinux: Set the proper NetLabel security attributes for connection requests
      selinux: Remove dead code labeled networking code
      smack: Set the proper NetLabel security attributes for connection requests

Steve French (1):
      CIFS: Fix endian conversion of vcnum field

Steven Whitehouse (1):
      GFS2: Fix page_mkwrite() return code

Suresh Jayaraman (3):
      cifs: Increase size of tmp_buf in cifs_readdir to avoid potential overflows
      cifs: Fix incorrect destination buffer size in cifs_strncpy_to_host
      cifs: Fix buffer size in cifs_convertUCSpath

Takashi Iwai (1):
      ALSA: hda - Fix line-in on Mac Mini Core2 Duo

Trond Myklebust (3):
      NFS: Fix the return value in nfs_page_mkwrite()
      NFS: Close page_mkwrite() races
      NFS: Fix the notifications when renaming onto an existing file

