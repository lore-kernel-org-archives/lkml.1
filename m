Return-Path: <linux-kernel-owner+w=401wt.eu-S1757737AbZJEApZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757737AbZJEApZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 20:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755161AbZJEApY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 20:45:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34304 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754332AbZJEApW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 20:45:22 -0400
Date: Sun, 4 Oct 2009 17:44:43 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.32-rc3
Message-ID: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Yes, it's really -rc3, because I'm skipping -rc2 entirely.

Or not "entirely". As too many people pointed out, I had been somewhat 
less than careful, and the 2.6.32-rc1 release actually called itself -rc2 
in the Makefile. As a result, I don't want to make a 2.6.32-rc2 release, 
since any bug-reports etc would then be met with the inevitable confusion: 
do you mean -rc2 as in the Makefile (ie really -rc1) or -rc2 as in the 
tagged release.

So I'm avoiding that confusion entirely, and consider the -rc1 release to 
have also been -rc2, and thus a week later we're now at -rc3. And let's 
hope that I won't have that particular "senior moment" any more. Although 
I'm sure I can screw up releases some other way.

Anyway. On to the actual changes.  It's actually been fairly calm, 
although I'm not sure exactly why. Regardless, I'm not going to complain, 
or look the gift horse in the mouth. The shortlog is appended (quite 
often, the -rc2 shortlogs are still big enough that I skip them).

The biggest change in the diff is the e1000 network driver update, but the 
bulk of that is actually just whitespace changes thanks to running it 
through lindent along with dropping dead PCIe code (the PCIe support is in 
the e1000e driver).

Apart from that single driver update (which is almost 60% of the diffs), 
there's a fair number of one-liners, but also some DRM updates (mainly the 
experimental radeon driver but also a capability to specify modes etc), 
some pcmcia and serial updates, ext4 and btrfs, etc. With a smattering of 
ACPI, sound and network code to fill in the cracks.

The appended shortlog probably gives a reasonable view into it, but one 
thing that might be worth mention (despite being fairly small) is that 
there's been some IO latency tweaking in the block layer (CFS scheduler). 
I'm hoping that ends up being one of those noticeable things, where people 
might actually notice better responsiveness. Give it a try.

		Linus

---
Aaro Koskinen (1):
      iop3xx: ATU and PCI memory configuration corrected

Adam Jackson (4):
      drm/edid: const cleanup
      drm/edid: Ignore bad standard timings.
      drm/edid: Detailed standard timing blocks have six timings, not five.
      drm/edid: Fix standard timing parse for EDID <= 1.2

Ajay Kumar Gupta (1):
      omap: Add missing mux pin for EHCI phy reset line

Ajit Khaparde (1):
      be2net: Workaround to fix a bug in Rx Completion processing.

Alan Jenkins (3):
      sony-laptop: Don't unregister the SPIC driver if it wasn't registered
      sony-laptop: check for rfkill hard block at load time
      sony-laptop: re-read the rfkill state when resuming from suspend

Albert Herranz (1):
      sdio: pass whitelisted cis funce tuples to sdio drivers

Alex Chiang (1):
      ACPI: dock: fix "sibiling" typo

Alex Deucher (5):
      drm/radeon/kms/r600: clamp vram to aperture size
      drm/radeon/kms: fix some bugs in vline reloc
      drm/radeon/kms/r600: add support for vline relocs
      drm/radeon/kms/r600: fix forcing pci mode on agp cards
      drm/radeon/r600: fix offset handling in CS parser

Alexander Beregalov (1):
      cciss: fix build when !PROC_FS

Alexey Dobriyan (4):
      cpqarray: switch to seq_file
      dac960: switch to seq_file
      const: constify remaining file_operations
      headers: remove sched.h from poll.h

Alexey Starikovskiy (3):
      ACPI: EC: Restart command even if no interrupts from EC
      ACPI: EC: Rewrite DMI checks
      ACPI: EC: Don't parse DSDT for EC early init on Compal

Amerigo Wang (1):
      drm: create gitignore file for radeon

Andrew Morton (3):
      net/ipv4/tcp.c: fix min() type mismatch warning
      drivers/input/input.c: fix CONFIG_PM=n warning
      revert "m68k: convert to asm-generic/hardirq.h"

Andrew Patterson (3):
      cciss: Remove sysfs entries for logical drives on driver cleanup.
      cciss: Use one scan thread per controller and fix hang during rmmod
      cciss: Allow triggering of rescan of logical drive topology via sysfs entry

Andy Spencer (1):
      sscanf(): fix %*s%n

Angelo Arrifano (2):
      omap: Fix wrong jtag_id for 850
      omap: Fix a OMAP_MPUIO_VBASE typo for 850

Anton Vorontsov (1):
      3c59x: Rework suspend and resume

Arjan van de Ven (5):
      net: Add explicit bound checks in net/socket.c
      wext: Add bound checks for copy_from_user
      x86: Provide an alternative() based cmpxchg64()
      ACPI: Fix bound checks for copy_from_user in the acpi /proc code
      SFI: remove __init from sfi_verify_table

Atis Elsts (1):
      net: Use sk_mark for routing lookup in more places

Atsushi Nemoto (1):
      serial_txx9: use container_of() instead of direct cast

Barry Song (1):
      ASoC: fix kconfig order of Blackfin drivers

Ben Dooks (11):
      s3cmci: use resource_size() instead of local macro
      s3cmci: update probe to use new platform id list
      s3cmci: change GPIO to gpiolib from S3C24XX specific calls
      s3cmci: change to use dev_pm_ops
      s3cmci: fix direct write to interrupt mask
      s3cmci: add debugfs support for examining driver and hardware state
      s3cmci: add SDIO IRQ support
      s3cmci: Kconfig selection for PIO/DMA/Both
      s3cmci: DMA fixes
      s3cmci: make SDIO IRQ hardware IRQ support build-time configurable
      s3cmci: add better support for no card detect or write protect available

Ben Greear (1):
      ixgbe patch to provide NIC's tx/rx counters via ethtool

Bjorn Helgaas (1):
      ACPI: fix bus scanning memory leaks

Breno Leitao (1):
      icom: convert space to tabs

Chaithrika U S (1):
      ASoC: DaVinci: Correct McASP FIFO initialization

Choi, David (1):
      drivers/net: ks8851_mll ethernet network driver

Chris Ball (2):
      Btrfs: Fix setting umask when POSIX ACLs are not enabled
      Btrfs: Use CONFIG_BTRFS_POSIX_ACL to enable ACL code

Chris Mason (1):
      Btrfs: take i_mutex before generic_write_checks

Christian Lamparter (1):
      ar9170: fix bug in iq-auto calibration value calculation

Christoph Hellwig (5):
      Btrfs: fix arguments to btrfs_wait_on_page_writeback_range
      Btrfs: remove duplicates of filemap_ helpers
      block: use normal I/O path for discard requests
      block: allow large discard requests
      afs: remove cache.h

Chuck Ebbert (1):
      serial: add parameter to force skipping the test for the TXEN bug

Cliff Cai (1):
      ASoC: Blackfin: fix inverted handling of SPORT0 on PORT F/G

Curt Wohlgemuth (3):
      ext4: Make sure ext4_dirty_inode() updates the inode in no journal mode
      ext4: Handle nested ext4_journal_start/stop calls without a journal
      ext4: Fix build warning in ext4_dirty_inode()

Dan Williams (2):
      iop33x: update defconfig (default atu to on)
      iop: downgrade maintenance status

Daniel T Chen (3):
      ALSA: hda - Add HP Pavilion dv4t-1300 to MSI whitelist
      ALSA: intel8x0 - Mute External Amplifier by default for Sony VAIO VGN-T350P
      ALSA: intel8x0 - Mute External Amplifier by default for Sony VAIO VGN-B1VP

Dave Airlie (11):
      drm/radeon/kms: enable r600 tv outputs.
      drm/radeon/kms: enable dac load detection by default.
      drm/radeon/kms: don't require up to 64k allocations. (v2)
      fb: change rules for global rules match.
      drm/kms: start adding command line interface using fb.
      drm/radeon/kms: remove unneeded master create/destroy functions.
      drm/r600: get values from the passed in IB not the copy.
      drm/kms: protect against fb helper not being created.
      drm/radeon/kms: fix for the extra pages copying.
      drm/kms: make fb helper work for all drivers.
      drm/r600: fix memory leak introduced with 64k malloc avoidance fix.

David Brown (1):
      ARM: 5739/1: ARM: allow empty ATAG_CORE

David S. Miller (1):
      net: Make setsockopt() optlen be unsigned.

Dmitry Artamonow (1):
      ARM: 5734/1: arm: fix compilation of entry-common.S for older CPUs

Don Skidmore (1):
      e1000: cleanup unused prototype

Eric Dumazet (6):
      sched_clock: Fix atomicity/continuity bug by using cmpxchg64()
      net: Fix sock_wfree() race
      net: restore tx timestamping for accelerated vlans
      pktgen: Fix delay handling
      tg3: Remove prev_vlan_tag from struct tx_ring_info
      net: splice() from tcp to pipe should take into account O_NONBLOCK

Eric Sandeen (2):
      ext4: drop ext4dev compat
      ext4: retry failed direct IO allocations

Frank Mayhar (1):
      ext4: Avoid updating the inode table bh twice in no journal mode

Frans Pop (1):
      e1000e/igb/ixgbe: Don't report an error if devices don't support AER

Giuliano Pochini (1):
      ALSA: echoaudio - Re-enable the line-out control for the Mia card

Greg Ungerer (1):
      ARM: 5740/1: fix valid_phys_addr_range() range check

H Hartley Sweeten (1):
      fs/bio.c: move EXPORT* macros to line after function

Hartley Sweeten (1):
      ARM: 5735/1: sa1111: CodingStyle cleanups

Hirokazu Takata (5):
      m32r: fix tme_handler
      m32r: export delay loop symbols
      m32r: define ioread* and iowrite* macros
      m32r: add rtc_lock variable
      m32r: Fix set_memory() for DISCONTIGMEM

Hiroshi DOYU (3):
      omap: mailbox: Execute softreset at startup
      omap: mailbox: Flush posted write when acking mailbox irq
      omap: Fix wrong condition check in while loop for mailbox and iommu2

Huang Shijie (1):
      mm/rmap.c: fix comment

Huang Weiyi (2):
      MIPS: BCM63xx: Remove duplicated #include
      MIPS: Remove duplicated #include

Igor Perminov (1):
      mac80211: Fix [re]association power saving issue on AP side

Jan Kara (1):
      ext4: Update documentation about quota mount options

Jarek Poplawski (1):
      ax25: Fix possible oops in ax25_make_new

Jarkko Nikula (1):
      omap: Fix MMC gpio_wp for BeagleBoard C2 and above

Jaswinder Singh Rajput (2):
      ARM: Remove unused CONFIG SA1100_H3XXX
      ARM: includecheck fix: mach-davinci, board-dm365-evm.c

Jean Delvare (12):
      sound: Make keywest_driver static
      net: Fix wrong sizeof
      i2c: Move misc devices documentation
      max6875: Discard obsolete detect method
      ds2482: Discard obsolete detect method
      ltc4215/ltc4245: Discard obsolete detect methods
      leds: leds-pca9532 - Drop unused module parameters
      Staging: IIO: tsl2561: Drop unused module parameters
      mfd: AB3100 drop unused module parameters
      i2c: Minor documentation update
      i2c: Hide probe errors caused by ACPI resource conflicts
      macintosh: Don't assume i2c device probing always succeeds

Jeff Hansen (1):
      bridge: Fix double-free in br_add_if.

Jens Axboe (7):
      cciss: cciss_host_attr_groups should be const
      cfq-iosched: add a knob for desktop interactiveness
      cfq-iosched: implement slower async initiate and queue ramp up
      cfq-iosched: rename 'desktop' sysfs entry to 'low_latency'
      cfq-iosched: use assigned slice sync value, not default
      cfq-iosched: don't delay async queue if it hasn't dispatched at all
      Revert "Seperate read and write statistics of in_flight requests"

Jerome Glisse (2):
      drm/radeon/kms: Convert RV515 to new init path and associated cleanup
      drm/radeon/kms: Convert R520 to new init path and associated cleanup

Jesse Brandeburg (12):
      e1000: drop dead pcie code from e1000
      e1000: remove unused functions
      e1000: use netif_tx_disable
      e1000: stop timers at appropriate times
      e1000: test link state conclusively
      e1000: fix tx waking queue after queue stopped during shutdown
      e1000: two workarounds were incomplete, fix them
      e1000: remove races when changing mtu
      e1000: drop redunant line of code, cleanup
      e1000: updated whitespace and comments
      e1000: drop unused functionality for eeprom write/read
      e1000: fix namespacecheck warnings

Jiri Pirko (2):
      ixgbe: correct the parameter description
      bonding: set primary param via sysfs

Jiri Slaby (1):
      Char: vt_ioctl, fix BKL imbalance

Joe Perches (1):
      MAINTAINERS: ARM/Palm file patterns

Johannes Berg (5):
      cfg80211: wext: don't display BSSID unless associated
      cfg80211: don't set privacy w/o key
      cfg80211: always get BSS
      mac80211: improve/fix mlme messages
      wext: add back wireless/ dir in sysfs for cfg80211 interfaces

John Fastabend (3):
      net: fix vlan_get_size to include vlan_flags size
      net: fix nlmsg len size for skb when error bit is set.
      net: fix double skb free in dcbnl

Josef Bacik (2):
      Btrfs: proper -ENOSPC handling
      Btrfs: fix data space leak fix

Josh Stone (1):
      ext4: Add a stub for mpage_da_data in the trace header

Jouni Malinen (1):
      mac80211_hwsim: Fix initial beacon timer configuration

Juha Leppanen (1):
      atm: dereference of he_dev->rbps_virt in he_init_group()

Julia Lawall (3):
      arch/arm/plat-iop: Use DIV_ROUND_CLOSEST
      Btrfs: introduce missing kfree
      MIPS: SMTC: Remove duplicate structure field initialization

Jun'ichi Nomura (1):
      Add a tracepoint for block request remapping

KAMEZAWA Hiroyuki (4):
      memcg: fix refcnt going negative
      cgroup: catch bad css refcnt at css_put
      memcg: some modification to softlimit under hierarchical memory reclaim.
      memcg: reduce check for softlimit excess

Kevin Cernekee (1):
      MIPS: MIPSxx SC: Avoid destructive invalidation on partial L2 cachelines.

Kirill A. Shutemov (2):
      ARM: 5727/1: Pass IFSR register to do_PrefetchAbort()
      ARM: 5728/1: Proper prefetch abort handling on ARMv6 and ARMv7

Len Brown (1):
      acpi_pad: build only on X86

Leo Chen (2):
      ARM: 5732/1: remove redundant include file
      ARM: 5733/1: fix bcmring compile error

Linus Torvalds (4):
      Revert "x86, mce: do not compile mcelog message on AMD"
      pty: reconnect the BSD TIOCSPTLCK handling to legacy ptys
      tty: Avoid dropping ldisc_mutex over hangup tty re-initialization
      Linux 2.6.32-rc3

Linus Walleij (2):
      ARM: 5731/2: Fix U300 generic GPIO, remove ifdefs from MMCI v3
      ARM: 5738/1: Correct TCM documentation

Lukasz Marcinowski (1):
      ALSA: hda - CD-audio sound for hda-intel conexant benq laptop

Manoj Iyer (1):
      ALSA: hda - Added quirk to enable sound on Toshiba NB200

Mark Mason (1):
      MIPS: Sibyte: Fix compilation error.

Mark Salter (1):
      mn10300: fix kernel build failures when using gcc-4.x

Martin K. Petersen (3):
      block: Set max_sectors correctly for stacking devices
      block: Do not clamp max_hw_sectors for stacking devices
      block: Topology ioctls

Mattia Dongili (3):
      sony-laptop: remove device_ctrl and the SPIC mini drivers
      sony-laptop: SPIC unset IRQF_SHARED, set IRQF_DISABLED
      sony-laptop: remove _INI call at init time

Maxime Bizon (2):
      MIPS: BCM63xx: Add serial driver for bcm63xx integrated UART.
      MIPS: BCM63xx: Add PCMCIA & Cardbus support.

Michael Buesch (1):
      b43: Always use block-I/O for the PIO data registers

Michael Chan (1):
      cnic: Fix NETDEV_UP event processing.

Michal Schmidt (1):
      skge: use unique IRQ name

Michal Szalata (1):
      rt2x00: Thrustmaster FunAccess WIFI USB and rt73usb

Miguel de Barros (1):
      ALSA: hda - Analog Devices AD1984A add HP Touchsmart model

Mikael Pettersson (2):
      drm: fix drm_fb_helper warning when !CONFIG_MAGIC_SYSRQ
      drm: fix radeon DRM warnings when !CONFIG_DEBUG_FS

Mike Frysinger (1):
      asm-generic/gpio.h: pull in linux/kernel.h for might_sleep()

Mike McCormack (1):
      skge: Make sure both ports initialize correctly

Mingming Cao (4):
      ext4: release reserved quota when block reservation for delalloc retry
      ext4: Split uninitialized extents for direct I/O
      ext4: Use end_io callback to avoid direct I/O fallback to buffered I/O
      ext4: async direct IO for holes and fallocate support

OGAWA Hirofumi (2):
      fat/nls: Fix handling of utf8 invalid char
      fat: Check s_dirt in fat_sync_fs()

Ori Finkelman (1):
      IPv4 TCP fails to send window scale option when window scale is zero

Paul Mundt (1):
      module: fix up CONFIG_KALLSYMS=n build.

Paul Wise (1):
      vfat: change the default from shortname=lower to shortname=mixed

Peter P Waskiewicz Jr (4):
      ixgbe: Fix disabling of relaxed ordering with Tx DCA
      ixgbe: Fix backplane flow control autoneg
      ixgbe: Bump driver version number
      ixgbe: Remove ATR computation for UDP traffic

Philipp Reisner (8):
      connector: Keep the skb in cn_callback_data
      connector: Provide the sender's credentials to the callback
      connector/dm: Fixed a compilation warning
      connector: Removed the destruct_data callback since it is always kfree_skb()
      dm/connector: Only process connector packages from privileged processes
      dst/connector: Disallow unpliviged users to configure dst
      pohmelfs/connector: Disallow unpliviged users to configure pohmelfs
      uvesafb/connector: Disallow unpliviged users to send netlink packets

Rafael J. Wysocki (2):
      PM / PCMCIA: Drop second argument of pcmcia_socket_dev_suspend()
      PM / yenta: Fix cardbus suspend/resume regression

Rakib Mullick (1):
      SFI: fix section mismatch warnings in sfi_core.c

Ralf Baechle (11):
      ax25: Add missing dev_put in ax25_setsockopt
      MIPS: BCM1480: Re-apply patch lost due to bad resolution of merge conflict.
      MIPS: SMP: Fix build.
      MIPS: SMP: Inline arch_send_call_function_{single_ipi,ipi_mask}
      MIPS: Sibyte: Get rid of BKL.
      MIPS: Excite: Get rid of BKL.
      MIPS: VPE: Fix build after the credential changes a while ago.
      MIPS: VPE: Get rid of BKL.
      MIPS: Avoid spurious make includecheck message
      NET: mkiss: Fix typo
      Kconfig: STRIP: Remove stale bits of STRIP help text

Randy Dunlap (3):
      isdn: fix netjet/isdnhdlc build errors
      cciss: fix schedule_timeout() parameters
      docs: update patch size in SubmittingPatches

Reinette Chatre (3):
      iwlwifi: fix debugfs buffer handling
      iwlwifi: fix memory leak in command queue handling
      iwlwifi: fix 3945 ucode info retrieval after failure

Richard Röjfors (1):
      uartlite: allow building for timberdale MFD

Roel Kluin (4):
      MIPS: Decrease size of au1xxx_dbdma_pm_regs[][]
      MIPS: MSP71xx: request_irq() failure ignored in msp_pcibios_config_access()
      cyclades: fix read buffer overflow
      serial167: fix read buffer overflow

Roland Dreier (1):
      ACPI: kill overly verbose "throttling states" log messages

Ron Mercer (5):
      qlge: Fix bad bit definitions.
      qlge: Fix out of sync hardware semaphore.
      qlge: Fix spin_lock warning.
      qlge: Protect reset recovery with rtnl_lock().
      qlge: Fix error exit for probe call.

Russell King (9):
      ARM: Fix section mismatch warning in Integrator pci_v3
      ARM: Fix SA1100 Assabet/Neponset PCMCIA section mismatch warnings
      ARM: Fix SA1100 Neponset serial section mismatch
      ARM: Fix SA11x0 clocksource warning
      ARM: Fix warning: #warning syscall migrate_pages not implemented
      ARM: Fix warning: unused variable 'highmem'
      ARM: Don't allow highmem on SMP platforms without h/w TLB ops broadcast
      ARM: Fix __cpuexit section mismatch warnings
      ARM: Ensure do_cache_op takes mmap_sem

Ryusuke Konishi (2):
      nilfs2: fix missing zero-fill initialization of btree node cache
      nilfs2: fix missing initialization of i_dir_start_lookup member

Rémi Denis-Courmont (1):
      Phonet: fix mutex imbalance

Sage Weil (2):
      Btrfs: fix error cases for ioctl transactions
      Btrfs: fix deadlock with free space handling and user transactions

Samuel Thibault (1):
      x86: fix csum_ipv6_magic asm memory clobber

Sanjeev Premi (1):
      omap: iovmm: Fix compiler warning

Sascha Hauer (3):
      spi-imx: update state correctly
      spi-imx: fix initial chipselect settings
      spi-imx: setup mode_bits we can handle

Sascha Hlusiak (2):
      Revert "sit: stateless autoconf for isatap"
      sit: fix off-by-one in ipip6_tunnel_get_prl

Shaohua Li (1):
      ACPI: create Processor Aggregator Device driver

Stephen Hemminger (1):
      sky2: irqname based on pci address

Stephen M. Cameron (17):
      cciss: Remove some unused code in rebuild_lun_table()
      cciss: Dynamically allocate struct device for each logical drive as needed.
      cciss: Rearrange logical drive sysfs code to make the "changing a disk" path work.
      cciss: Handle failure of blk_init_queue gracefully in cciss_add_disk.
      cciss: Handle cases when cciss_add_disk fails.
      cciss: Handle special case for sysfs attributes of the first logical drive.
      cciss: Clear all sysfs-exposed data for deleted logical drives.
      cciss: Fix usage_count check in rebuild_lun_table when triggered via sysfs.
      cciss: Fix excessive gendisk freeing bug on driver unload.
      cciss: Silence noisy per-disk messages output by cciss_read_capacity
      cciss: Preserve all 8 bytes of LUN ID for logical drives.
      cciss: Don't check h->busy_initializing in cciss_open().
      cciss: Add lunid attribute to each logical drive in /sys
      cciss: fix some magic numbers in the raid-level decoding
      cciss: Add a "raid_level" attribute to each logical drive in /sys
      cciss: Add usage_count attribute to each logical drive in /sys
      cciss: Dynamically allocate the drive_info_struct for each logical drive.

Suresh Jayaraman (1):
      swapfile: avoid NULL pointer dereference in swapon when s_bdev is NULL

Sven Eckelmann (1):
      ALSA: ctxfi: Swapped SURROUND-SIDE mute

Takashi Iwai (7):
      ALSA: hda - Resurrect input-source mixer of ALC268 model=acer
      ALSA: Don't assume i2c device probing always succeeds
      ASoC: Fix dependency of CONFIG_SND_PXA2XX_SOC_IMOTE2
      ALSA: hda - Fix digita/analog mic auto-switching with IDT codecs
      ALSA: hda - Fix / improve ALC66x parser
      ALSA: Fix invalid __exit in sound/mips/*.c
      ALSA: usb - Use strlcat() correctly

Tejun Heo (6):
      percpu: fix unit_map[] verification in pcpu_setup_first_chunk()
      percpu: make pcpu_build_alloc_info() clear static buffers
      sparc64: implement page mapping percpu first chunk allocator
      percpu: make embedding first chunk allocator check vmalloc space size
      percpu: make pcpu_setup_first_chunk() failures more verbose
      percpu: make allocation failures more verbose

Theodore Ts'o (9):
      ext4: Use ext4_msg() for ext4_da_writepage() errors
      ext4: Fix hueristic which avoids group preallocation for closed files
      ext4: Adjust ext4_da_writepages() to write out larger contiguous chunks
      ext4: EXT4_IOC_MOVE_EXT: Check for different original and donor inodes first
      ext4, jbd2: Drop unneeded printks at mount and unmount time
      ext4: Use tracepoints for mb_history trace file
      jbd2: Use tracepoints for history file
      ext4: Fix time encoding with extra epoch bits
      ext4: fix a BUG_ON crash by checking that page has buffers attached to it

Tobias Klauser (1):
      omap: rng: Use resource_size instead of manual calculation

Tony Lindgren (4):
      omap: Fix compile for arch/arm/mach-omap2
      omap: Fix mcspi compile for 2420
      omap: Fix 44xx compile
      omap: Fix matrix_keymap_data usage

Toshihiro HANAWA (1):
      m32r: Fix IPI function calls for SMP

Troy Kisky (2):
      ASoC: DaVinci: Fix divide by zero error during 1st execution
      ASoC: Davinci: Fix race with cpu_dai->dma_data

Uwe Kleine-König (8):
      MIPS: Loongson2: Fix typo "enalbe" -> "enable"
      don't use __devexit_p to wrap meth_remove
      don't use __devexit_p to wrap sgiseeq_remove
      move virtnet_remove to .devexit.text
      spi-imx: rename source file to spi_imx.c
      spi-imx: no need to assert bits_per_word being initialized
      spi-imx: initialize complete config struct
      spi-imx: strip down chipselect function to only drive the chipselect

Vivek Goyal (1):
      cfq-iosched: delay async IO dispatch, if sync IO was just done

Zdenek Kabelac (1):
      Add missing blk_trace_remove_sysfs to be in pair with blk_trace_init_sysfs

roel kluin (1):
      bcm63xx_enet: timeout off by one in do_mdio_op()
