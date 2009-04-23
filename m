Return-Path: <linux-kernel-owner+w=401wt.eu-S1757650AbZDWHga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650AbZDWHga (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755960AbZDWH2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:28:53 -0400
Received: from sous-sol.org ([216.99.217.87]:48396 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755981AbZDWH2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:28:51 -0400
Message-Id: <20090423072020.428683652@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:20:20 -0700
From: Chris Wright <chrisw@sous-sol.org>
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
Subject: [patch 000/100] 2.6.29.2 -stable review
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.29.2 release.
There are 100 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the
Cc: line.  If you wish to be a reviewer, please email stable@kernel.org
to add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Sat, Apr 25, 07:00 UTC.  Anything received
after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.29.2-rc1.gz
and the diffstat can be found below.

thanks,
-chris

 Documentation/networking/bonding.txt       |    2 
 Makefile                                   |    2 
 arch/ia64/kvm/Kconfig                      |    4 
 arch/mips/kernel/linux32.c                 |    6 
 arch/powerpc/include/asm/futex.h           |   12 
 arch/powerpc/kvm/Kconfig                   |    3 
 arch/s390/kvm/Kconfig                      |    3 
 arch/sparc/include/asm/tlb_64.h            |    4 
 arch/x86/Kconfig.cpu                       |    1 
 arch/x86/boot/memory.c                     |    7 
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |   12 
 arch/x86/kernel/io_apic.c                  |   13 
 arch/x86/kvm/Kconfig                       |    4 
 arch/x86/kvm/i8254.c                       |   15 
 arch/x86/kvm/i8254.h                       |    1 
 arch/x86/kvm/mmu.h                         |    2 
 arch/x86/kvm/paging_tmpl.h                 |    4 
 arch/x86/kvm/vmx.c                         |   54 +--
 arch/x86/mm/pat.c                          |   98 +----
 arch/x86/pci/fixup.c                       |   20 -
 crypto/shash.c                             |    3 
 drivers/acpi/dock.c                        |    3 
 drivers/acpi/processor_idle.c              |   63 +--
 drivers/ata/pata_hpt37x.c                  |   22 -
 drivers/char/agp/generic.c                 |    4 
 drivers/char/vt.c                          |    2 
 drivers/gpu/drm/drm_gem.c                  |    7 
 drivers/gpu/drm/i915/i915_dma.c            |    9 
 drivers/gpu/drm/i915/i915_gem.c            |    1 
 drivers/gpu/drm/i915/i915_gem_tiling.c     |   31 -
 drivers/gpu/drm/i915/i915_reg.h            |   16 
 drivers/gpu/drm/i915/intel_crt.c           |   45 +-
 drivers/gpu/drm/i915/intel_display.c       |   10 
 drivers/gpu/drm/i915/intel_tv.c            |   30 +
 drivers/ide/hpt366.c                       |    4 
 drivers/ide/ide-atapi.c                    |   10 
 drivers/ide/ide-io.c                       |    9 
 drivers/input/gameport/gameport.c          |   14 
 drivers/md/dm-bio-record.h                 |   26 +
 drivers/md/dm-io.c                         |    5 
 drivers/md/dm-kcopyd.c                     |   23 -
 drivers/md/dm-path-selector.c              |   21 -
 drivers/md/dm-raid1.c                      |   25 +
 drivers/md/dm-snap.c                       |  101 +++--
 drivers/md/dm-table.c                      |   26 -
 drivers/md/dm-target.c                     |   20 -
 drivers/md/raid1.c                         |    7 
 drivers/media/video/cx88/cx88-input.c      |   25 -
 drivers/message/fusion/mptbase.c           |    2 
 drivers/net/bonding/bond_main.c            |    5 
 drivers/net/bonding/bond_sysfs.c           |   14 
 drivers/net/ixgbe/ixgbe_ethtool.c          |  101 +++--
 drivers/net/r8169.c                        |    5 
 drivers/net/sfc/efx.c                      |    8 
 drivers/net/skge.c                         |    4 
 drivers/net/wireless/rt2x00/rt2x00.h       |    3 
 drivers/net/wireless/rt2x00/rt2x00dev.c    |    2 
 drivers/net/wireless/rt2x00/rt2x00lib.h    |   10 
 drivers/net/wireless/rt2x00/rt2x00rfkill.c |   86 ++---
 drivers/pci/probe.c                        |    9 
 drivers/platform/x86/acer-wmi.c            |   25 +
 drivers/scsi/libiscsi.c                    |    9 
 drivers/scsi/sg.c                          |  495 ++++++++++++++---------------
 drivers/spi/spi.c                          |   22 -
 drivers/usb/class/cdc-wdm.c                |    2 
 drivers/usb/gadget/u_ether.c               |    8 
 drivers/usb/serial/ftdi_sio.c              |    1 
 drivers/usb/serial/ftdi_sio.h              |    7 
 drivers/usb/serial/ti_usb_3410_5052.c      |   26 -
 drivers/usb/storage/unusual_devs.h         |    6 
 drivers/video/console/fbcon.c              |   24 -
 drivers/video/fbmem.c                      |   18 -
 drivers/virtio/virtio_balloon.c            |    3 
 fs/dquot.c                                 |    2 
 fs/drop_caches.c                           |    2 
 fs/ext4/mballoc.c                          |    4 
 fs/fs-writeback.c                          |    3 
 fs/hugetlbfs/inode.c                       |    3 
 fs/nfs/nfs3xdr.c                           |    3 
 fs/ocfs2/file.c                            |    8 
 fs/splice.c                                |   25 +
 include/linux/capability.h                 |   23 +
 include/linux/hrtimer.h                    |    5 
 include/linux/interrupt.h                  |    1 
 include/linux/kvm_host.h                   |   17 
 include/linux/pagemap.h                    |   12 
 include/linux/sched.h                      |    3 
 kernel/fork.c                              |   13 
 kernel/hrtimer.c                           |   55 +--
 kernel/kprobes.c                           |    4 
 kernel/posix-cpu-timers.c                  |    9 
 kernel/sched.c                             |   79 +++-
 kernel/softirq.c                           |    2 
 kernel/sysctl.c                            |   15 
 kernel/trace/trace.c                       |    3 
 lib/cpumask.c                              |    4 
 mm/filemap_xip.c                           |    4 
 mm/mmap.c                                  |    2 
 net/core/skbuff.c                          |    2 
 net/ipv4/netfilter/arp_tables.c            |    4 
 net/ipv4/netfilter/ip_tables.c             |    4 
 net/ipv6/netfilter/ip6_tables.c            |    4 
 net/netrom/af_netrom.c                     |    8 
 net/rose/af_rose.c                         |    4 
 net/x25/af_x25.c                           |    6 
 security/commoncap.c                       |    1 
 security/smack/smack_lsm.c                 |    4 
 sound/pci/hda/hda_codec.c                  |    6 
 sound/pci/hda/patch_analog.c               |    2 
 virt/kvm/ioapic.c                          |    6 
 virt/kvm/irq_comm.c                        |   24 +
 virt/kvm/kvm_main.c                        |   11 
 112 files changed, 1206 insertions(+), 905 deletions(-)
