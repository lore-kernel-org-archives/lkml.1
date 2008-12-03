Return-Path: <linux-kernel-owner+w=401wt.eu-S1753629AbYLCTsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629AbYLCTsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 14:48:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751753AbYLCTsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:48:08 -0500
Received: from kroah.org ([198.145.64.141]:34423 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751227AbYLCTsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:48:06 -0500
Date: Wed, 3 Dec 2008 11:47:25 -0800
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
Subject: [patch 000/104] 2.6.27-stable review
Message-ID: <20081203194725.GA8950@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.27.8 release.
There are 104 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

And yes, there are a lot of patches here, the big series are:
	- cifs data corruption patches
	- pci hotplug slot patches to fix the most common warning
	  showing up on kerneloops.org
	- ext4 bugfixes

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Friday, December 5, 20:00:00 UTC.  Anything
received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.8-rc1.gz
and the diffstat can be found below.


thanks,

greg k-h

 Documentation/filesystems/proc.txt        |   27 +
 Makefile                                  |    2 +-
 arch/ia64/kernel/acpi.c                   |   29 +-
 arch/ia64/kernel/setup.c                  |    7 +-
 arch/parisc/kernel/traps.c                |   43 +-
 arch/powerpc/platforms/cell/spufs/file.c  |    3 +
 arch/powerpc/platforms/cell/spufs/inode.c |    2 +
 arch/x86/kernel/acpi/boot.c               |    8 +
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |   18 +-
 arch/x86/kernel/cpu/cpufreq/powernow-k8.h |   17 +-
 arch/x86/kernel/early-quirks.c            |   55 ++-
 arch/x86/kernel/setup.c                   |    2 +-
 arch/x86/mm/discontig_32.c                |   35 ++
 arch/x86/power/hibernate_32.c             |    4 +
 arch/x86/xen/enlighten.c                  |    2 +-
 drivers/acpi/ec.c                         |    3 +-
 drivers/acpi/pci_slot.c                   |    2 +-
 drivers/ata/libata-core.c                 |   25 +-
 drivers/ata/libata-sff.c                  |   13 +-
 drivers/firewire/fw-sbp2.c                |    5 +
 drivers/gpio/gpiolib.c                    |    2 +-
 drivers/ieee1394/sbp2.c                   |    5 +
 drivers/infiniband/hw/mlx4/cq.c           |    5 +
 drivers/input/keyboard/atkbd.c            |   25 +
 drivers/media/video/compat_ioctl32.c      |    3 +
 drivers/net/atl1e/atl1e_hw.c              |    4 -
 drivers/net/e1000/e1000_ethtool.c         |    8 +-
 drivers/net/e1000/e1000_main.c            |    1 +
 drivers/net/e1000e/ethtool.c              |    8 +-
 drivers/net/e1000e/netdev.c               |    1 +
 drivers/net/igb/igb_ethtool.c             |    8 +-
 drivers/net/igb/igb_main.c                |    1 +
 drivers/net/pcmcia/axnet_cs.c             |    1 +
 drivers/net/pcmcia/pcnet_cs.c             |    1 -
 drivers/net/wireless/ath9k/recv.c         |   10 +-
 drivers/net/wireless/rtl8187_dev.c        |    3 +
 drivers/parport/parport_serial.c          |    2 +
 drivers/pci/hotplug/acpiphp.h             |    9 +-
 drivers/pci/hotplug/acpiphp_core.c        |   32 +-
 drivers/pci/hotplug/cpci_hotplug.h        |    6 +
 drivers/pci/hotplug/cpci_hotplug_core.c   |   75 +--
 drivers/pci/hotplug/cpci_hotplug_pci.c    |    4 +-
 drivers/pci/hotplug/cpqphp.h              |   13 +-
 drivers/pci/hotplug/cpqphp_core.c         |   43 +-
 drivers/pci/hotplug/fakephp.c             |   18 +-
 drivers/pci/hotplug/ibmphp.h              |    5 +-
 drivers/pci/hotplug/ibmphp_ebda.c         |   19 +-
 drivers/pci/hotplug/pci_hotplug_core.c    |   64 +--
 drivers/pci/hotplug/pciehp.h              |    9 +-
 drivers/pci/hotplug/pciehp_core.c         |   49 +-
 drivers/pci/hotplug/pciehp_ctrl.c         |   48 +-
 drivers/pci/hotplug/pciehp_hpc.c          |    1 -
 drivers/pci/hotplug/rpaphp_slot.c         |   10 +-
 drivers/pci/hotplug/sgi_hotplug.c         |   18 +-
 drivers/pci/hotplug/shpchp.h              |    9 +-
 drivers/pci/hotplug/shpchp_core.c         |   52 +--
 drivers/pci/hotplug/shpchp_ctrl.c         |   48 +-
 drivers/pci/slot.c                        |  143 ++++-
 drivers/spi/pxa2xx_spi.c                  |   24 +-
 drivers/usb/gadget/f_rndis.c              |    3 +-
 drivers/usb/host/ehci-pci.c               |   24 +
 drivers/usb/mon/mon_bin.c                 |    5 +-
 drivers/video/fbmem.c                     |    2 +-
 drivers/watchdog/hpwdt.c                  |    5 +-
 fs/cifs/cifs_debug.c                      |  277 +++++-----
 fs/cifs/cifs_spnego.c                     |    3 +-
 fs/cifs/cifsfs.c                          |   30 +-
 fs/cifs/cifsglob.h                        |   43 +-
 fs/cifs/cifsproto.h                       |    2 +-
 fs/cifs/cifssmb.c                         |   97 ++--
 fs/cifs/connect.c                         |  869 +++++++++++++++--------------
 fs/cifs/file.c                            |    9 +-
 fs/cifs/misc.c                            |   90 ++--
 fs/cifs/transport.c                       |   48 ++-
 fs/ecryptfs/keystore.c                    |   31 +-
 fs/eventpoll.c                            |   85 +++-
 fs/ext2/balloc.c                          |    3 +-
 fs/ext3/balloc.c                          |    3 +-
 fs/ext3/dir.c                             |   22 +-
 fs/ext3/resize.c                          |    3 +-
 fs/ext4/balloc.c                          |    4 +-
 fs/ext4/dir.c                             |   20 +-
 fs/ext4/ext4.h                            |   10 +-
 fs/ext4/ialloc.c                          |    6 +-
 fs/ext4/inode.c                           |    7 +-
 fs/ext4/ioctl.c                           |   21 +-
 fs/ext4/mballoc.c                         |   22 +-
 fs/ext4/migrate.c                         |   10 +-
 fs/ext4/resize.c                          |    9 +
 fs/ext4/super.c                           |   77 ++-
 fs/ext4/xattr.c                           |    6 +
 fs/inotify.c                              |  150 +++++-
 fs/jbd/transaction.c                      |   16 +-
 fs/jbd2/checkpoint.c                      |   41 ++-
 fs/jbd2/commit.c                          |    5 +-
 fs/jbd2/journal.c                         |   49 ++-
 include/asm-x86/mmzone_32.h               |    4 +
 include/asm-x86/pci_64.h                  |   14 -
 include/linux/idr.h                       |    3 +-
 include/linux/inotify.h                   |   11 +
 include/linux/jbd2.h                      |    3 +-
 include/linux/libata.h                    |    1 +
 include/linux/pci.h                       |    8 +-
 include/linux/pci_hotplug.h               |   11 +-
 include/linux/sched.h                     |    4 +
 include/net/af_unix.h                     |    1 +
 ipc/util.c                                |   14 +-
 kernel/Makefile                           |    4 +-
 kernel/audit_tree.c                       |   91 ++--
 kernel/auditfilter.c                      |   14 +-
 kernel/cgroup.c                           |    7 +-
 kernel/cpuset.c                           |   12 +-
 kernel/sched.c                            |   13 +-
 kernel/sysctl.c                           |   10 +
 lib/idr.c                                 |   14 +-
 lib/scatterlist.c                         |    2 +-
 net/unix/af_unix.c                        |    2 +
 net/unix/garbage.c                        |   13 +-
 118 files changed, 2118 insertions(+), 1334 deletions(-)
