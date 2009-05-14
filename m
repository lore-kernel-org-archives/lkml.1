Return-Path: <linux-kernel-owner+w=401wt.eu-S1755850AbZENWlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850AbZENWlg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 18:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754595AbZENWlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 18:41:24 -0400
Received: from kroah.org ([198.145.64.141]:51371 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754552AbZENWlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 18:41:23 -0400
Date: Thu, 14 May 2009 15:37:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: [patch 00/51] 2.6.29-stable review
Message-ID: <20090514223755.GA27019@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.29.4 release.
There are 51 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Saturday, May 16, 20:00:00 UTC.  Anything
received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.29.4-rc1.gz
and the diffstat can be found below.


thanks,

greg k-h


 Documentation/filesystems/Locking   |   26 ++-
 Makefile                            |    2 +-
 arch/x86/kvm/svm.c                  |    1 -
 arch/x86/kvm/x86.c                  |    4 +-
 drivers/dma/dmatest.c               |    4 +-
 drivers/hid/hid-ids.h               |    5 +
 drivers/hid/usbhid/hid-quirks.c     |    3 +
 drivers/hwmon/w83781d.c             |    3 +-
 drivers/i2c/algos/i2c-algo-bit.c    |    2 +-
 drivers/i2c/algos/i2c-algo-pca.c    |   11 ++
 drivers/md/bitmap.c                 |   29 ++--
 drivers/md/md.c                     |    7 +-
 drivers/md/raid10.c                 |   12 +-
 drivers/net/e1000/e1000_main.c      |    2 +-
 drivers/net/ehea/ehea_main.c        |   31 +++--
 drivers/net/ne2k-pci.c              |    7 +-
 drivers/serial/mpc52xx_uart.c       |    2 +-
 drivers/usb/gadget/usbstring.c      |    6 +-
 drivers/usb/serial/ftdi_sio.c       |   18 ++-
 drivers/video/fb_defio.c            |    3 +-
 fs/btrfs/ctree.h                    |    2 +-
 fs/btrfs/inode.c                    |   12 +-
 fs/buffer.c                         |   20 ++-
 fs/cifs/cifs_unicode.h              |    7 +
 fs/cifs/cifssmb.c                   |   17 +-
 fs/cifs/connect.c                   |    6 +-
 fs/cifs/misc.c                      |    5 +-
 fs/cifs/readdir.c                   |    2 +-
 fs/cifs/sess.c                      |   46 +++---
 fs/eventpoll.c                      |    2 +-
 fs/ext4/ext4.h                      |    2 +-
 fs/ext4/inode.c                     |    5 +-
 fs/fcntl.c                          |    6 +-
 fs/fuse/file.c                      |    3 +-
 fs/fuse/inode.c                     |    1 +
 fs/gfs2/ops_file.c                  |    7 +-
 fs/ioctl.c                          |   75 +++++++---
 fs/lockd/svc.c                      |   15 ++-
 fs/nfs/dir.c                        |    9 +-
 fs/nfs/file.c                       |    9 +-
 fs/nfsd/nfs4xdr.c                   |   16 ++-
 fs/ocfs2/file.c                     |   94 ++++++++++---
 fs/ocfs2/mmap.c                     |    6 +-
 fs/splice.c                         |  276 ++++++++++++++++++++++-------------
 fs/ubifs/file.c                     |    9 +-
 fs/xfs/linux-2.6/xfs_file.c         |    4 +-
 include/linux/buffer_head.h         |    2 +-
 include/linux/compiler.h            |    3 +-
 include/linux/mm.h                  |    3 +-
 include/linux/splice.h              |   12 ++
 include/net/cipso_ipv4.h            |   17 ++
 include/net/netlabel.h              |   15 ++-
 mm/memory.c                         |  132 ++++++++++++-----
 net/ipv4/cipso_ipv4.c               |  130 ++++++++++++++++
 net/ipv4/syncookies.c               |    9 +-
 net/ipv4/tcp_ipv4.c                 |    7 +-
 net/mac80211/rc80211_pid_algo.c     |   73 +++++-----
 net/netlabel/netlabel_kapi.c        |   84 +++++++++++
 security/selinux/hooks.c            |   49 ++-----
 security/selinux/include/netlabel.h |   23 ++-
 security/selinux/netlabel.c         |  185 +++++++-----------------
 security/smack/smack.h              |    1 -
 security/smack/smack_lsm.c          |  130 ++++++++++-------
 sound/pci/hda/patch_sigmatel.c      |    7 +-
 sound/soc/codecs/wm8990.c           |   40 +++---
 65 files changed, 1131 insertions(+), 625 deletions(-)
