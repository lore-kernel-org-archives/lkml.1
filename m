Return-Path: <linux-kernel-owner+w=401wt.eu-S1757428AbYLEWgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428AbYLEWgB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 17:36:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbYLEWfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 17:35:53 -0500
Received: from kroah.org ([198.145.64.141]:58102 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752291AbYLEWfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 17:35:51 -0500
Date: Fri, 5 Dec 2008 14:34:31 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.27.8
Message-ID: <20081205223431.GA4388@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.27.8
kernel.

It contains a wide range of bugfixes, and all users of the 2.6.27 kernel
series are strongly encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.27.7 and 2.6.27.8

The updated 2.6.27.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary

thanks,

greg k-h

------------

 Documentation/filesystems/proc.txt        |   27 
 Makefile                                  |    2 
 arch/ia64/kernel/acpi.c                   |   29 -
 arch/ia64/kernel/setup.c                  |    7 
 arch/parisc/kernel/traps.c                |   43 -
 arch/powerpc/platforms/cell/spufs/file.c  |    3 
 arch/powerpc/platforms/cell/spufs/inode.c |    2 
 arch/x86/kernel/acpi/boot.c               |    8 
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |   18 
 arch/x86/kernel/cpu/cpufreq/powernow-k8.h |   17 
 arch/x86/kernel/early-quirks.c            |   55 +
 arch/x86/kernel/setup.c                   |    2 
 arch/x86/mm/discontig_32.c                |   35 +
 arch/x86/power/hibernate_32.c             |    4 
 arch/x86/xen/enlighten.c                  |    2 
 drivers/acpi/ec.c                         |    3 
 drivers/acpi/pci_slot.c                   |    2 
 drivers/ata/libata-core.c                 |   25 
 drivers/firewire/fw-sbp2.c                |    5 
 drivers/gpio/gpiolib.c                    |    2 
 drivers/ieee1394/sbp2.c                   |    5 
 drivers/infiniband/hw/mlx4/cq.c           |    5 
 drivers/input/keyboard/atkbd.c            |   25 
 drivers/media/video/compat_ioctl32.c      |    3 
 drivers/net/atl1e/atl1e_hw.c              |    4 
 drivers/net/e1000/e1000_ethtool.c         |    8 
 drivers/net/e1000/e1000_main.c            |    1 
 drivers/net/e1000e/ethtool.c              |    8 
 drivers/net/e1000e/netdev.c               |    1 
 drivers/net/igb/igb_ethtool.c             |    8 
 drivers/net/igb/igb_main.c                |    1 
 drivers/net/pcmcia/axnet_cs.c             |    1 
 drivers/net/pcmcia/pcnet_cs.c             |    1 
 drivers/net/wireless/ath9k/recv.c         |   10 
 drivers/net/wireless/rtl8187_dev.c        |    3 
 drivers/parport/parport_serial.c          |    2 
 drivers/pci/hotplug/acpiphp.h             |    9 
 drivers/pci/hotplug/acpiphp_core.c        |   32 -
 drivers/pci/hotplug/cpci_hotplug.h        |    6 
 drivers/pci/hotplug/cpci_hotplug_core.c   |   75 +-
 drivers/pci/hotplug/cpci_hotplug_pci.c    |    4 
 drivers/pci/hotplug/cpqphp.h              |   13 
 drivers/pci/hotplug/cpqphp_core.c         |   43 -
 drivers/pci/hotplug/fakephp.c             |   18 
 drivers/pci/hotplug/ibmphp.h              |    5 
 drivers/pci/hotplug/ibmphp_ebda.c         |   19 
 drivers/pci/hotplug/pci_hotplug_core.c    |   64 --
 drivers/pci/hotplug/pciehp.h              |    9 
 drivers/pci/hotplug/pciehp_core.c         |   49 -
 drivers/pci/hotplug/pciehp_ctrl.c         |   48 -
 drivers/pci/hotplug/pciehp_hpc.c          |    1 
 drivers/pci/hotplug/rpaphp_slot.c         |   10 
 drivers/pci/hotplug/sgi_hotplug.c         |   18 
 drivers/pci/hotplug/shpchp.h              |    9 
 drivers/pci/hotplug/shpchp_core.c         |   52 -
 drivers/pci/hotplug/shpchp_ctrl.c         |   48 -
 drivers/pci/slot.c                        |  143 +++-
 drivers/spi/pxa2xx_spi.c                  |   24 
 drivers/usb/gadget/f_rndis.c              |    3 
 drivers/usb/host/ehci-pci.c               |   24 
 drivers/usb/mon/mon_bin.c                 |    5 
 drivers/video/fbmem.c                     |    2 
 drivers/watchdog/hpwdt.c                  |    5 
 fs/cifs/cifs_debug.c                      |  277 +++++----
 fs/cifs/cifs_spnego.c                     |    3 
 fs/cifs/cifsfs.c                          |   30 -
 fs/cifs/cifsglob.h                        |   43 -
 fs/cifs/cifsproto.h                       |    2 
 fs/cifs/cifssmb.c                         |   97 +--
 fs/cifs/connect.c                         |  869 +++++++++++++++---------------
 fs/cifs/file.c                            |    9 
 fs/cifs/misc.c                            |   90 +--
 fs/cifs/transport.c                       |   48 +
 fs/ecryptfs/keystore.c                    |   31 -
 fs/eventpoll.c                            |   85 ++
 fs/ext2/balloc.c                          |    3 
 fs/ext3/balloc.c                          |    3 
 fs/ext3/dir.c                             |   22 
 fs/ext3/resize.c                          |    3 
 fs/ext4/dir.c                             |   20 
 fs/ext4/ext4.h                            |   10 
 fs/ext4/ialloc.c                          |    2 
 fs/ext4/inode.c                           |    7 
 fs/ext4/ioctl.c                           |   21 
 fs/ext4/mballoc.c                         |   18 
 fs/ext4/migrate.c                         |   10 
 fs/ext4/resize.c                          |    9 
 fs/ext4/super.c                           |   77 +-
 fs/ext4/xattr.c                           |    6 
 fs/inotify.c                              |  150 ++++-
 fs/jbd/transaction.c                      |   16 
 fs/jbd2/checkpoint.c                      |   41 +
 fs/jbd2/commit.c                          |    5 
 fs/jbd2/journal.c                         |   49 +
 include/asm-x86/mmzone_32.h               |    4 
 include/asm-x86/pci_64.h                  |   14 
 include/linux/idr.h                       |    3 
 include/linux/inotify.h                   |   11 
 include/linux/jbd2.h                      |    3 
 include/linux/libata.h                    |    1 
 include/linux/pci.h                       |    8 
 include/linux/pci_hotplug.h               |   11 
 include/linux/sched.h                     |    4 
 include/net/af_unix.h                     |    1 
 ipc/util.c                                |   14 
 kernel/Makefile                           |    4 
 kernel/audit_tree.c                       |   91 +--
 kernel/auditfilter.c                      |   14 
 kernel/cgroup.c                           |    7 
 kernel/cpuset.c                           |   12 
 kernel/sched.c                            |   13 
 kernel/sysctl.c                           |   10 
 lib/idr.c                                 |   14 
 lib/scatterlist.c                         |    2 
 net/unix/af_unix.c                        |    2 
 net/unix/garbage.c                        |   13 
 116 files changed, 2098 insertions(+), 1329 deletions(-)

Al Viro (1):
      Fix inotify watch removal/umount races

Alex Chiang (14):
      PCI Hotplug core: add 'name' param pci_hp_register interface
      PCI: update pci_create_slot() to take a 'hotplug' param
      PCI: prevent duplicate slot names
      PCI, PCI Hotplug: introduce slot_name helpers
      PCI: acpiphp: remove 'name' parameter
      PCI: cpci_hotplug: stop managing hotplug_slot->name
      PCI: cpqphp: stop managing hotplug_slot->name
      PCI: fakephp: remove 'name' parameter
      PCI: ibmphp: stop managing hotplug_slot->name
      PCI: pciehp: remove 'name' parameter
      PCI: rpaphp: kmalloc/kfree slot->name directly
      PCI: SGI Hotplug: stop managing bss_hotplug_slot->name
      PCI: shcphp: remove 'name' parameter
      PCI: Hotplug core: remove 'name'

Alexey Dobriyan (1):
      ext4: fix #11321: create /proc/ext4/*/stats more carefully

Alexey Starikovskiy (1):
      ACPI: EC: count interrupts only if called from interrupt handler.

Andiry Xu (1):
      USB: fix SB700 usb subsystem hang bug

Andreas Herrmann (3):
      CPUFREQ: powernow-k8: ignore out-of-range PstateStatus value
      x86: SB600: skip ACPI IRQ0 override if it is not routed to INT2 of IOAPIC
      x86: call dmi-quirks for HP Laptops after early-quirks are executed

Aneesh Kumar K.V (5):
      ext4: elevate write count for migrate ioctl
      ext4: Free ext4_prealloc_space using kmem_cache_free
      ext4: Do mballoc init before doing filesystem recovery
      ext4: Convert to host order before using the values.
      ext4: Mark the buffer_heads as dirty and uptodate after prepare_write

Arjan van de Ven (1):
      lib/scatterlist.c: fix kunmap() argument in sg_miter_stop()

Bernhard Walle (2):
      WATCHDOG: hpwdt: set the mapped BIOS address space as executable
      WATCHDOG: hpwdt: Fix kdump when using hpwdt

Chuck Ebbert (1):
      libata: Avoid overflow in libata when tf->hba_lbal > 127

Clemens Ladisch (1):
      fbdev: clean the penguin's dirty feet

Cord Walter (1):
      axnet_cs / pcnet_cs: moving PCMCIA_DEVICE_PROD_ID for Netgear FA411

Dave Kleikamp (1):
      cifs: prevent cifs_writepages() from skipping unwritten pages

David Brownell (1):
      USB: gadget rndis: stop windows self-immolation

Davide Libenzi (1):
      epoll: introduce resource usage limits

Doug Chapman (1):
      IA64: fix boot panic caused by offline CPUs

Duane Griffin (1):
      jbd2: abort instead of waiting for nonexistent transaction

Eugene Dashevsky (1):
      ext3: fix ext3_dx_readdir hash collision handling

Florent Fourcot (1):
      rtl8187: Add USB ID for Belkin F5D7050 with RTL8187B chip

Frederic Bohe (2):
      ext4: Update flex_bg free blocks and free inodes counters when resizing.
      ext4: add checksum calculation when clearing UNINIT flag in ext4_new_inode

Greg Kroah-Hartman (1):
      Linux 2.6.27.8

Gregor Jasny (1):
      V4L/DVB (9352): Add some missing compat32 ioctls

Helge Deller (1):
      parisc: fix kernel crash when unwinding a userspace process

Hidehiro Kawai (1):
      jbd: ordered data integrity fix

Ian Campbell (1):
      xen: do not reserve 2 pages of padding between hypervisor and fixmap.

J. K. Cliburn (1):
      atl1e: fix broken multicast by removing unnecessary crc inversion

Jack Morgenstein (1):
      IB/mlx4: Fix MTT leakage in resize CQ

Jarkko Nikula (1):
      gpiolib: extend gpio label column width in debugfs file

Jeff Layton (3):
      cifs: disable sharing session and tcon and add new TCP sharing code
      cifs: reinstate sharing of SMB sessions sans races
      cifs: reinstate sharing of tree connections

Jeremy Kerr (1):
      powerpc/spufs: Fix spinning in spufs_ps_fault on signal

Joerg Roedel (1):
      x86: always define DECLARE_PCI_UNMAP* macros

John W. Linville (1):
      rtl8187: add device ID 0bda:8198

Josef Bacik (1):
      ext3: don't try to resize if there are no reserved gdt blocks left

Kalpak Shah (1):
      ext4: fix xattr deadlock

Kenji Kaneshige (1):
      PCI Hotplug: serialize pci_hp_register and pci_hp_deregister

Kou Ishizaki (1):
      powerpc/spufs: add a missing mutex_unlock

Kumar Gala (1):
      Remove -mno-spe flags as they dont belong

Li Zefan (3):
      cpuset: fix regression when failed to generate sched domains
      cgroups: fix a serious bug in cgroupstats
      ext4: add missing unlock in ext4_check_descriptors() on error path

Luis R. Rodriguez (2):
      ath9k: Fix SW-IOMMU bounce buffer starvation
      ath9k: correct expected max RX buffer size

Manfred Spraul (1):
      lib/idr.c: fix rcu related race with idr_find

Matthew Garrett (1):
      Input: atkbd - add keymap quirk for Inventec Symphony systems

Michael Halcrow (1):
      eCryptfs: Allocate up to two scatterlists for crypto ops on keys

Mingming Cao (2):
      ext2: fix ext2 block reservation early ENOSPC issue
      ext3: fix ext3 block reservation early ENOSPC issue

Nadia Derbey (1):
      sysvipc: fix the ipc structures initialization

Ned Forrester (1):
      pxa2xx_spi: bugfix full duplex dma data corruption

Pete Zaitcev (1):
      USB: usbmon: fix read(2)

Philipp Kohlbecher (1):
      x86: more general identifier for Phoenix BIOS

Rafael J. Wysocki (4):
      x86: Hibernate: Fix breakage on x86_32 with CONFIG_NUMA set
      igb: Use device_set_wakeup_enable
      e1000: Use device_set_wakeup_enable
      e1000e: Use device_set_wakeup_enable

Richard Röjfors (1):
      USB: gadget rndis: send notifications

Shane Huang (1):
      USB: fix SB600 USB subsystem hang bug

Stefan Richter (2):
      ieee1394: sbp2: another iPod mini quirk entry
      firewire: fw-sbp2: another iPod mini quirk entry

Steve French (9):
      cifs: Reduce number of socket retries in large write path
      cifs: Fix error in smb_send2
      cifs: Fix cifs reconnection flags
      cifs: remove unused list, add new cifs sock list to prepare for mount/umount fix
      cifs: clean up server protocol handling
      cifs: minor cleanup to cifs_mount
      cifs: Fix build break
      cifs: Fix check for tcon seal setting and fix oops on failed mount from earlier patch
      cifs: fix check for dead tcon in smb_init

Takashi Iwai (1):
      parport_serial: fix array overflow

Tejun Heo (1):
      libata: blacklist Seagate drives which time out FLUSH_CACHE when used with NCQ

Theodore Ts'o (9):
      jbd2: fix /proc setup for devices that contain '/' in their names
      ext4: Renumber EXT4_IOC_MIGRATE
      ext4/jbd2: Avoid WARN() messages when failing to write to the superblock
      jbd2: Fix buffer head leak when writing the commit block
      ext4: Fix duplicate entries returned from getdents() system call
      jbd2: don't give up looking for space so easily in __jbd2_log_wait_for_space
      ext4: wait on all pending commits in ext4_sync_fs()
      ext4: calculate journal credits correctly
      ext3: Fix duplicate entries returned from getdents() system call

dann frazier (1):
      net: Fix soft lockups/OOM issues w/ unix garbage collector (CVE-2008-5300)

