Return-Path: <linux-kernel-owner+w=401wt.eu-S1754248AbZJERaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbZJERaA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 13:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754111AbZJER37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 13:29:59 -0400
Received: from kroah.org ([198.145.64.141]:52605 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754149AbZJER3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 13:29:45 -0400
Date: Mon, 5 Oct 2009 10:26:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.31.2
Message-ID: <20091005172621.GE18332@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.31.2 kernel.  All users of the
2.6.31 kernel series are very strongly encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.31.1 and 2.6.31.2

The updated 2.6.31.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.31.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.31.y.git;a=summary

thanks,

greg k-h

------------

 MAINTAINERS                                 |    6 
 Makefile                                    |    2 
 arch/alpha/kernel/core_marvel.c             |    2 
 arch/alpha/kernel/core_titan.c              |    2 
 arch/alpha/kernel/pci_impl.h                |    2 
 arch/alpha/kernel/pci_iommu.c               |    4 
 arch/arm/mach-pxa/sharpsl_pm.c              |    4 
 arch/powerpc/include/asm/pte-common.h       |    2 
 arch/powerpc/mm/pgtable.c                   |   19 +
 arch/x86/include/asm/elf.h                  |    2 
 arch/x86/include/asm/uv/uv_hub.h            |    2 
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c   |   17 -
 arch/x86/kvm/mmu.c                          |    6 
 arch/x86/kvm/vmx.c                          |    6 
 arch/x86/kvm/x86.c                          |   15 -
 arch/x86/mm/Makefile                        |    5 
 arch/x86/mm/mmap.c                          |   17 +
 arch/x86/mm/pageattr.c                      |    1 
 arch/x86/xen/Makefile                       |    2 
 arch/x86/xen/enlighten.c                    |  139 ++++++++--
 arch/x86/xen/smp.c                          |    1 
 arch/x86/xen/spinlock.c                     |   28 +-
 drivers/acpi/pci_slot.c                     |    4 
 drivers/ata/ahci.c                          |    4 
 drivers/ata/pata_amd.c                      |    3 
 drivers/base/base.h                         |    2 
 drivers/base/bus.c                          |   23 -
 drivers/base/core.c                         |    2 
 drivers/char/agp/intel-agp.c                |   30 +-
 drivers/char/pty.c                          |    6 
 drivers/char/tty_io.c                       |    1 
 drivers/char/tty_port.c                     |   29 +-
 drivers/gpu/drm/i915/i915_drv.c             |    2 
 drivers/gpu/drm/i915/i915_gem.c             |   55 +---
 drivers/gpu/drm/i915/i915_gem_tiling.c      |   15 -
 drivers/gpu/drm/i915/i915_reg.h             |    6 
 drivers/gpu/drm/i915/intel_bios.c           |    3 
 drivers/gpu/drm/i915/intel_crt.c            |    9 
 drivers/gpu/drm/i915/intel_display.c        |   35 ++
 drivers/gpu/drm/i915/intel_lvds.c           |   11 
 drivers/gpu/drm/i915/intel_sdvo.c           |   96 +++++-
 drivers/hid/hid-core.c                      |    1 
 drivers/isdn/gigaset/interface.c            |   19 -
 drivers/media/video/em28xx/em28xx-cards.c   |   32 +-
 drivers/media/video/em28xx/em28xx.h         |    4 
 drivers/media/video/saa7134/saa7134-input.c |   56 +---
 drivers/media/video/saa7134/saa7134.h       |    4 
 drivers/message/fusion/mptbase.c            |   10 
 drivers/mfd/ab3100-core.c                   |    2 
 drivers/mmc/core/mmc.c                      |   10 
 drivers/mmc/core/sd.c                       |   10 
 drivers/mtd/chips/cfi_cmdset_0002.c         |   11 
 drivers/mtd/chips/cfi_util.c                |    4 
 drivers/mtd/nand/ndfc.c                     |    4 
 drivers/mtd/ofpart.c                        |   21 -
 drivers/net/can/vcan.c                      |    2 
 drivers/net/usb/kaweth.c                    |   18 -
 drivers/net/wireless/ath/ar9170/usb.c       |    2 
 drivers/net/wireless/ath/ath5k/ath5k.h      |    1 
 drivers/net/wireless/ath/ath5k/attach.c     |    2 
 drivers/net/wireless/ath/ath5k/base.c       |   55 +---
 drivers/net/wireless/ath/ath5k/reset.c      |  155 ++++++++---
 drivers/net/wireless/iwlwifi/iwl-1000.c     |    6 
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   40 ++
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   39 ++
 drivers/net/wireless/iwlwifi/iwl-5000.c     |   58 ++++
 drivers/net/wireless/iwlwifi/iwl-6000.c     |   25 +
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   57 ++--
 drivers/net/wireless/iwlwifi/iwl-core.h     |   16 +
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   43 ++-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c   |  185 ++++++++++---
 drivers/net/wireless/iwlwifi/iwl-eeprom.h   |   10 
 drivers/net/wireless/iwlwifi/iwl-prph.h     |    5 
 drivers/net/wireless/iwlwifi/iwl-scan.c     |    3 
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   45 +--
 drivers/net/wireless/p54/p54usb.c           |    1 
 drivers/pcmcia/at91_cf.c                    |    2 
 drivers/pcmcia/au1000_generic.c             |    2 
 drivers/pcmcia/bfin_cf_pcmcia.c             |    2 
 drivers/pcmcia/cs.c                         |    2 
 drivers/pcmcia/i82092.c                     |    2 
 drivers/pcmcia/i82365.c                     |    2 
 drivers/pcmcia/m32r_cfc.c                   |    2 
 drivers/pcmcia/m32r_pcc.c                   |    2 
 drivers/pcmcia/m8xx_pcmcia.c                |    2 
 drivers/pcmcia/omap_cf.c                    |    2 
 drivers/pcmcia/pd6729.c                     |    2 
 drivers/pcmcia/pxa2xx_base.c                |    2 
 drivers/pcmcia/sa1100_generic.c             |    2 
 drivers/pcmcia/sa1111_generic.c             |    2 
 drivers/pcmcia/tcic.c                       |    2 
 drivers/pcmcia/vrc4171_card.c               |    2 
 drivers/pcmcia/yenta_socket.c               |   88 +++---
 drivers/platform/x86/sony-laptop.c          |    6 
 drivers/platform/x86/thinkpad_acpi.c        |    8 
 drivers/serial/bfin_5xx.c                   |    4 
 drivers/serial/serial_cs.c                  |    1 
 drivers/usb/class/cdc-acm.c                 |    7 
 drivers/usb/class/cdc-wdm.c                 |   30 +-
 drivers/usb/class/usbtmc.c                  |   22 +
 drivers/usb/core/config.c                   |    2 
 drivers/usb/host/sl811-hcd.c                |    8 
 drivers/usb/host/xhci-dbg.c                 |    5 
 drivers/usb/host/xhci-hcd.c                 |  370 +++++++++++++++++++++-----
 drivers/usb/host/xhci-mem.c                 |   64 ++++
 drivers/usb/host/xhci-pci.c                 |   13 
 drivers/usb/host/xhci-ring.c                |  232 +++++++++++++++-
 drivers/usb/host/xhci.h                     |   41 ++
 drivers/usb/serial/ark3116.c                |   46 ---
 drivers/usb/serial/console.c                |   28 +-
 drivers/usb/serial/cp210x.c                 |    6 
 drivers/usb/serial/cypress_m8.c             |   12 
 drivers/usb/serial/empeg.c                  |   12 
 drivers/usb/serial/ftdi_sio.c               |    7 
 drivers/usb/serial/ftdi_sio.h               |   10 
 drivers/usb/serial/iuu_phoenix.c            |   31 +-
 drivers/usb/serial/kobil_sct.c              |   22 -
 drivers/usb/serial/option.c                 |    4 
 drivers/usb/serial/oti6858.c                |   21 -
 drivers/usb/serial/pl2303.c                 |    1 
 drivers/usb/serial/pl2303.h                 |    4 
 drivers/usb/serial/spcp8x5.c                |   21 -
 drivers/usb/serial/usb-serial.c             |  385 ++++++++++++----------------
 drivers/usb/serial/whiteheat.c              |    6 
 drivers/usb/storage/initializers.c          |    2 
 drivers/usb/storage/onetouch.c              |    2 
 drivers/video/console/fbcon.c               |   10 
 drivers/video/s3c-fb.c                      |    2 
 drivers/video/sis/vstruct.h                 |    2 
 drivers/xen/Makefile                        |    3 
 fs/cifs/cifsglob.h                          |    4 
 fs/ecryptfs/crypto.c                        |    5 
 fs/ecryptfs/inode.c                         |    2 
 fs/ecryptfs/keystore.c                      |   28 +-
 fs/ecryptfs/kthread.c                       |   24 -
 fs/ecryptfs/main.c                          |    3 
 fs/inode.c                                  |   14 -
 fs/nfsd/nfs4callback.c                      |    4 
 fs/nilfs2/btnode.c                          |    1 
 fs/proc/kcore.c                             |    8 
 fs/proc/uptime.c                            |    7 
 include/linux/tty.h                         |    8 
 include/linux/usb/serial.h                  |    3 
 include/pcmcia/ss.h                         |    2 
 kernel/perf_counter.c                       |   20 -
 mm/hugetlb.c                                |    2 
 mm/memory.c                                 |    3 
 mm/mlock.c                                  |   99 ++-----
 mm/mmap.c                                   |    4 
 mm/nommu.c                                  |   34 --
 mm/page_alloc.c                             |   12 
 net/ax25/af_ax25.c                          |    2 
 net/bridge/br_netfilter.c                   |    2 
 net/bridge/netfilter/ebt_ulog.c             |    2 
 net/can/af_can.c                            |    4 
 net/ipv4/netfilter/nf_nat_core.c            |    2 
 net/netfilter/nf_conntrack_core.c           |    6 
 net/packet/af_packet.c                      |    4 
 scripts/Kbuild.include                      |    4 
 scripts/kallsyms.c                          |    2 
 tools/perf/builtin-annotate.c               |    4 
 tools/perf/builtin-report.c                 |    4 
 tools/perf/util/module.c                    |    2 
 163 files changed, 2340 insertions(+), 1131 deletions(-)


Aaro Koskinen (1):
      sisfb: change SiS_DDC_Port type to SISIOADDRESS

Alan Cox (6):
      cdc_acm: Fix to use modern speed interfaces
      tty: remove dtr/rts use from the driver open methods
      tty: Add a full port_close function
      tty: USB hangup is racy
      tty: USB can now use the shutdown method for kref based freeing of ports
      tty: USB serial termios bits

Alan Jenkins (1):
      sony-laptop: check for rfkill hard block at load time

Alan Stern (10):
      Driver core: add new device to bus's list before probing
      usb-serial: change referencing of port and serial structures
      usb-serial: put subroutines in logical order
      usb-serial: change logic of serial lookups
      usb-serial: acquire references when a new tty is installed
      usb-serial: fix termios initialization logic
      usb-serial: rename subroutines
      usb-serial: add missing tests and debug lines
      usb-serial: straighten out serial_open
      USB serial: update the console driver

Alex Chiang (1):
      ACPI: pci_slot.ko wants a 64-bit _SUN

Andrew Morton (1):
      drivers/mfd/ab3100-core.c: fix powerpc build error

Arjan van de Ven (2):
      net ax25: Fix signed comparison in the sockopt handler
      net: Make the copy length in af_packet sockopt handler unsigned

Avi Kivity (1):
      KVM: Protect update_cr8_intercept() when running without an apic

Benjamin Krill (1):
      mtd: ofpart: Check availability of reg property instead of name property

Bob Copeland (1):
      ath5k: do not release irq across suspend/resume

Brian Rogers (2):
      em28xx: ir-kbd-i2c init data needs a persistent object
      saa7134: ir-kbd-i2c init data needs a persistent object

Chris Wilson (4):
      drm/i915: Only destroy a constructed mmap offset
      drm/i915: Add buffer to inactive list immediately during fault
      drm/i915: Check that the relocation points to within the target
      drm/i915: Handle ERESTARTSYS during page fault

Christian Lamparter (2):
      p54usb: add Zcomax XG-705A usbid
      ar9170usb: add usbid for TP-Link TL-WN821N v2

Chuck Ebbert (1):
      Re-enable Lanman security

David Howells (1):
      NOMMU: Fix MAP_PRIVATE mmap() of objects where the data can be mapped directly

Eric Anholt (1):
      agp/intel: Fix the pre-9xx chipset flush.

Eric Dumazet (1):
      perf tools: Fix buffer allocation

Feng Kan (1):
      mtd: nand: fix ECC Correction bug for SMC ordering for NDFC driver

Greg Kroah-Hartman (1):
      Linux 2.6.31.2

Guus Sliepen (1):
      USB: usbtmc: sanity checks for DEV_DEP_MSG_IN urbs

Hennerich, Michael (1):
      USB: sl811-hcd: Fix device disconnect:

Henrique de Moraes Holschuh (1):
      thinkpad-acpi: don't ask about brightness_mode for fw. 1V and 1R

Hugh Dickins (2):
      mm: munlock use follow_page
      mm: fix anonymous dirtying

Huzaifa Sidhpurwala (1):
      USB: option.c Add support for ZTE AC2726 EVDO modem

Ian Armstrong (1):
      fbcon: only unbind from console if successfully registered

Ian Schram (1):
      perf_counter: Fix perf_copy_attr() pointer arithmetic

Ivan Kokshaysky (1):
      alpha: AGP update (fixes compile failure)

J. Bruce Fields (1):
      nfsd4: fix null dereference creating nfsv4 callback client

Jack Steiner (1):
      x86: SGI UV: Fix IPI macros

Jan Kara (1):
      fs: make sure data stored into inode is properly seen before unlocking new inode

Jan Scholz (1):
      HID: completely remove apple mightymouse from blacklist

Jay Sternberg (2):
      iwlwifi: Handle new firmware file with ucode build number in header
      iwlwifi: update 1000 series API version to match firmware

Jeremy Fitzhardinge (3):
      xen: make -fstack-protector work under Xen
      xen: only enable interrupts while actually blocking for spinlock
      xen: check EFER for NX before setting up GDT mapping

Jesse Barnes (1):
      drm/i915: prevent FIFO calculation overflows on 32 bits with high dotclocks

Jory A. Pratt (1):
      kbuild: fix cc1 options check to ensure we do not use -fPIC when compiling

KAMEZAWA Hiroyuki (1):
      /proc/kcore: work around a BUG()

Kashyap, Desai (1):
      mptsas : PAE Kernel more than 4 GB kernel panic

Keith Packard (1):
      drm/I915: Use the CRT DDC to get the EDID for DVI-connector on Mac

Kevin Cernekee (1):
      kaweth: Fix memory leak in kaweth_control()

Kurt Roeckx (1):
      Fix NULL ptr regression in powernow-k8

Lee Schermerhorn (2):
      hugetlb: restore interleaving of bootmem huge pages (2.6.31)
      mmap: avoid unnecessary anon_vma lock acquisition in vma_adjust()

Linus Torvalds (1):
      pty_write: don't do a tty_wakeup() when the buffers are full

Luca Tettamanti (1):
      hwmon: (asus_atk0110) Add maintainer information

Manuel Lauss (1):
      USB: option: TELIT UC864G support

Marcelo Tosatti (3):
      KVM: MMU: fix missing locking in alloc_mmu_pages
      KVM: MMU: fix bogus alloc_mmu_pages assignment
      Revert "KVM: x86: check for cr3 validity in ioctl_set_sregs"

Mark McLoughlin (1):
      KVM: fix cpuid E2BIG handling for extended request types

Massimo Cirillo (1):
      mtd: cfi_cmdset_0002: add 0xFF intolerance for M29W128G

Mel Gorman (1):
      page-allocator: limit the number of MIGRATE_RESERVE pageblocks per zone

Michael Abbott (1):
      Fix idle time field in /proc/uptime

Michael Hennerich (1):
      USB: serial: ftdi: handle gnICE+ JTAG adaptors

Michal Hocko (1):
      x86: Increase MIN_GAP to include randomized stack

Mike Frysinger (1):
      serial: bfin_5xx: fix building as module when early printk is enabled

Nick Kossifidis (1):
      ath5k: Wakeup fixes

Oliver Hartkopp (1):
      can: fix NOHZ local_softirq_pending 08 warning

Oliver Neukum (3):
      USB: CDC WDM driver doesn't support non-blocking reads
      USB: fix cdc-acm regression in open
      USB: storage: fix a resume path GFP_NOIO must be used

Patrick McHardy (4):
      netfilter: nf_nat: fix inverted logic for persistent NAT mappings
      netfilter: nf_conntrack: netns fix re reliable conntrack event delivery
      netfilter: bridge: refcount fix
      netfilter: ebt_ulog: fix checkentry return value

Paul Mundt (1):
      kallsyms: fix segfault in prefix_underscores_count()

Pavel Machek (1):
      pxa/sharpsl_pm: zaurus c3000 aka spitz: fix resume

Pawel Ludwikow (2):
      USB: serial: ftdi_sio: new hardware support - hameg power supply
      USB: serial: pl2303: new hardware support - sanwa multimeter

Peter Korsgaard (1):
      video: s3c_fb.c: fix build with CONFIG_HOTPLUG=n

Pierre Habouzit (1):
      perf tools: do not complain if root is owning perf.data

Rafael J. Wysocki (2):
      PM / PCMCIA: Drop second argument of pcmcia_socket_dev_suspend()
      PM / yenta: Fix cardbus suspend/resume regression

Rex Feany (1):
      powerpc/8xx: Fix regression introduced by cache coherency rewrite

Robert Hancock (1):
      pata_amd: do not filter out valid modes in nv_mode_filter

Ryusuke Konishi (1):
      nilfs2: fix missing zero-fill initialization of btree node cache

Sarah Sharp (15):
      USB: xhci: Work around for chain bit in link TRBs.
      USB: xhci: Fix slot and endpoint context debugging.
      USB: xhci: Configure endpoint code refactoring.
      USB: xhci: Set correct max packet size for HS/FS control endpoints.
      USB: xhci: Support full speed devices.
      USB: xhci: Handle stalled control endpoints.
      USB: xhci: Add quirk for Fresco Logic xHCI hardware.
      USB: xhci: Make TRB completion code comparison readable.
      USB: xhci: Handle babbling endpoints correctly.
      USB: xhci: Don't touch xhci_td after it's freed.
      USB: xhci: Check URB's actual transfer buffer size.
      USB: xhci: Check URB_SHORT_NOT_OK before setting short packet status.
      USB: xhci: Set -EREMOTEIO when xHC gives bad transfer length.
      USB: xhci: Support interrupt transfers.
      USB: Fix SS endpoint companion descriptor parsing.

Sheng Yang (1):
      KVM: VMX: Fix EPT with WP bit change during paging

Tejun Heo (1):
      ahci: restore pci_intx() handling

Tilman Schmidt (1):
      tty: gigaset: really fix chars_in_buffer

Tyler Hicks (5):
      eCryptfs: Handle unrecognized tag 3 cipher codes
      eCryptfs: Check for O_RDONLY lower inodes when opening lower files
      eCryptfs: Filename encryption only supports password auth tokens
      eCryptfs: Validate global auth tok keys
      eCryptfs: Prevent lower dentry from going negative during unlink

Weirich, Bernhard (1):
      powerpc: Fix incorrect setting of __HAVE_ARCH_PTE_SPECIAL

Wey-Yi Guy (3):
      iwlagn: modify digital SVR for 1000
      iwlwifi: traverse linklist to find the valid OTP block
      iwlwifi: fix unloading driver while scanning

Wolfgang Muees (1):
      mmc_spi: fail gracefully if host or card do not support the switch command

Wolfram Sang (1):
      tty: serial/pcmcia: add ID for Advantech card

Yang Xiaowei (1):
      xen: use stronger barrier after unlocking lock

Zhenyu Wang (6):
      drm/i915: remove restore in resume
      drm/i915: Fix typo for wrong LVDS clock setting on IGDNG
      drm/i915: Fix SSC frequence for IGDNG
      drm/i915: Remove DAC disable in CRT force detect on IGDNG
      drm/i915: Fix LVDS panel fitting on Arrandale
      drm/i915: fix tiling on IGDNG

fangxiaozhi (1):
      USB: usb-storage fails to attach to Huawei Datacard cdrom device

mail@rainerkeller.de (1):
      USB: add PIDs for FTDI based OpenDCC hardware

