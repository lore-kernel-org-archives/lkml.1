Return-Path: <linux-kernel-owner+w=401wt.eu-S1751244AbZCNAR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751244AbZCNAR3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750865AbZCNARU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:17:20 -0400
Received: from kroah.org ([198.145.64.141]:46532 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750854AbZCNART (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:17:19 -0400
Date: Fri, 13 Mar 2009 17:14:49 -0700
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
Subject: [patch 00/96] 2.6.27.20-stable review
Message-ID: <20090314001449.GA4485@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.27.20 release.
There are 96 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Tuesday, March 17, 00:00:00 UTC.  Anything
received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.20-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 Makefile                              |    2 +-
 arch/arm/mach-rpc/riscpc.c            |    6 +
 arch/ia64/include/asm/mmzone.h        |    4 -
 arch/ia64/mm/numa.c                   |    4 +-
 arch/powerpc/include/asm/compat.h     |    5 +
 arch/powerpc/include/asm/seccomp.h    |    4 -
 arch/powerpc/kernel/align.c           |   29 +++---
 arch/sparc/include/asm/compat.h       |    5 +
 arch/sparc/include/asm/ptrace_32.h    |   10 ++
 arch/sparc/include/asm/ptrace_64.h    |   10 ++
 arch/sparc/include/asm/seccomp.h      |    6 -
 arch/sparc64/kernel/traps.c           |   17 +++-
 arch/x86/ia32/ia32entry.S             |    8 +-
 arch/x86/kernel/cpu/mtrr/main.c       |    3 +-
 arch/x86/kernel/io_apic_64.c          |    2 +-
 arch/x86/kernel/ptrace.c              |    2 +-
 arch/x86/kernel/reboot.c              |    8 ++
 arch/x86/kernel/vmiclock_32.c         |    5 +-
 arch/x86/mm/numa_64.c                 |    2 +-
 arch/x86/xen/enlighten.c              |    3 +
 drivers/acpi/ec.c                     |    5 +-
 drivers/ata/libata-core.c             |   10 +-
 drivers/ata/libata-eh.c               |    5 +-
 drivers/atm/fore200e.c                |    4 +-
 drivers/block/aoe/aoe.h               |    1 +
 drivers/block/aoe/aoenet.c            |    2 +
 drivers/block/xen-blkfront.c          |   30 +++---
 drivers/char/agp/intel-agp.c          |    8 +-
 drivers/hwmon/f71882fg.c              |    2 +-
 drivers/hwmon/it87.c                  |    8 +-
 drivers/i2c/busses/i2c-acorn.c        |    3 +-
 drivers/i2c/busses/i2c-amd8111.c      |    4 +-
 drivers/i2c/busses/i2c-pxa.c          |    2 +-
 drivers/i2c/i2c-core.c                |    3 +-
 drivers/ide/ide-iops.c                |    2 +
 drivers/infiniband/hw/nes/nes_cm.c    |   37 ++++++-
 drivers/infiniband/hw/nes/nes_verbs.c |    2 +
 drivers/infiniband/hw/nes/nes_verbs.h |    1 +
 drivers/md/raid1.c                    |    3 +-
 drivers/md/raid10.c                   |   19 ++--
 drivers/media/common/tuners/tda8290.c |    3 +-
 drivers/media/dvb/frontends/s5h1409.c |    7 +-
 drivers/media/video/ivtv/ivtv-ioctl.c |   24 +++---
 drivers/misc/hpilo.c                  |    1 +
 drivers/mmc/card/mmc_test.c           |    2 +-
 drivers/mmc/host/s3cmci.c             |    3 +-
 drivers/mmc/host/sdhci.c              |    4 +-
 drivers/mmc/host/sdhci.h              |    1 +
 drivers/mtd/devices/mtd_dataflash.c   |    3 +-
 drivers/net/sis190.c                  |    1 +
 drivers/net/usb/asix.c                |   12 +++
 drivers/net/usb/cdc_ether.c           |    5 +
 drivers/net/usb/zaurus.c              |    5 +
 drivers/net/wireless/rtl8187_dev.c    |   12 +++
 drivers/pci/pcie/aer/aerdrv_core.c    |   48 ++++++++--
 drivers/pci/pcie/portdrv_pci.c        |    3 +-
 drivers/pci/quirks.c                  |  144 +++++++++++++++++++++++++---
 drivers/scsi/hptiop.c                 |    1 +
 drivers/scsi/sd.c                     |    7 ++
 drivers/serial/8250.c                 |   15 +++
 drivers/serial/8250_pci.c             |   36 +++++++
 drivers/serial/jsm/jsm_driver.c       |    3 +
 drivers/usb/class/cdc-acm.c           |    2 +
 drivers/usb/core/message.c            |   11 ++-
 drivers/usb/host/ehci-hcd.c           |    2 +
 drivers/usb/host/ehci-mem.c           |    1 +
 drivers/usb/host/ehci-sched.c         |   56 ++++++++++--
 drivers/usb/host/ehci.h               |    6 +
 drivers/usb/serial/option.c           |    5 +
 drivers/usb/storage/unusual_devs.h    |    4 +-
 drivers/watchdog/ks8695_wdt.c         |    1 +
 drivers/watchdog/rc32434_wdt.c        |  168 ++++++++++++++-------------------
 fs/cifs/CHANGES                       |    2 +
 fs/cifs/sess.c                        |    4 +-
 fs/compat_ioctl.c                     |    2 +
 fs/ext4/ext4.h                        |    2 +-
 fs/ext4/ialloc.c                      |    7 ++
 fs/ext4/inode.c                       |   15 +++-
 fs/ext4/mballoc.c                     |   32 ++++---
 fs/ext4/migrate.c                     |    8 +-
 fs/ext4/super.c                       |   12 +-
 fs/fs-writeback.c                     |    9 ++-
 fs/inode.c                            |    7 ++
 fs/inotify.c                          |    2 +-
 fs/jbd2/journal.c                     |   17 ++-
 fs/jbd2/transaction.c                 |   42 ++++++--
 fs/jffs2/readinode.c                  |   42 +++++++--
 fs/proc/proc_misc.c                   |    4 +-
 fs/seq_file.c                         |   36 ++++++-
 fs/timerfd.c                          |   12 +-
 include/asm-mips/compat.h             |    7 ++
 include/asm-mips/seccomp.h            |    1 -
 include/asm-x86/mmzone_32.h           |    2 -
 include/asm-x86/mmzone_64.h           |    2 -
 include/asm-x86/seccomp_32.h          |    6 -
 include/asm-x86/seccomp_64.h          |    8 --
 include/linux/fs.h                    |   29 ++++---
 include/linux/jbd2.h                  |    3 +-
 include/linux/mm.h                    |   19 +++-
 include/linux/mmzone.h                |    2 +-
 include/linux/pci_ids.h               |    4 +
 include/linux/seq_file.h              |    1 +
 include/linux/serial_core.h           |    1 +
 include/linux/skbuff.h                |    9 --
 include/linux/timerfd.h               |   16 +++-
 include/net/sock.h                    |    1 -
 kernel/fork.c                         |   11 +-
 kernel/seccomp.c                      |    7 +-
 kernel/tsacct.c                       |    6 +-
 mm/page_alloc.c                       |   27 +++++-
 net/bridge/br_netfilter.c             |   13 +++
 net/core/skbuff.c                     |    8 --
 net/core/sock.c                       |    3 +-
 security/selinux/netlabel.c           |    9 +-
 sound/core/oss/rate.c                 |    2 +-
 sound/pci/aw2/aw2-alsa.c              |    2 +-
 sound/pci/hda/patch_realtek.c         |    1 +
 sound/pci/oxygen/virtuoso.c           |   22 ++---
 sound/usb/usbaudio.c                  |   20 ++--
 sound/usb/usbmidi.c                   |    1 +
 120 files changed, 954 insertions(+), 426 deletions(-)
