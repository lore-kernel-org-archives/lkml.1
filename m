Return-Path: <linux-kernel-owner+w=401wt.eu-S1755037AbZKCUF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037AbZKCUF7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 15:05:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753216AbZKCUF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 15:05:58 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56358 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751523AbZKCUFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 15:05:55 -0500
Date: Tue, 3 Nov 2009 12:05:27 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.32-rc6
Message-ID: <alpine.LFD.2.01.0911031142170.31845@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It's been over two weeks since -rc5, partly because of a very quiet week 
there due to lots of kernel people (including me) being in Tokyo for the 
annual kernel summit, but also partly because we had an annoying problem 
with ext4 filesystem corruption after unclean shutdowns.

It turns out that the ext4 problem was "just" thanks to enabling checksum 
testing of journal transactions in recovery mode, and the fix was to just 
disable that by default again - and the ext4 people will take a loong hard 
look at why that caused problems without even any printk to warn about 
journal problems. 

Lots of thanks to Eric Sandeen who bisected that hard-to-consistently- 
reproduce problem, and the people who helped testing. Once it was pinned 
down, the fix may have been a trivial revert, but filesystem corruption 
troubles make me more nervous than just about anything else.

There's been a number of other nasty regressions since 2.6.31 that got 
fixed too (largely drivers, several of them suspend/resume related or in 
some cases apparently most easily triggered that way), so I'm hoping the 
delay resulted in a better -rc all around. And I'm obviously hopefult that 
we didn't introduce any major new regressions (one post-rc5 regression fix 
was merged today, let's hope that was the only major one).

Bulk-wise, the biggest part of the -rc6 changes is the removal of the 
stlc45xx driver from staging (it's superseded by the p54 driver that 
drives both isl38xx and stlc45xx based hardware: P54_SPI is the stlc45xx 
replacement part). That alone accounts for about a third of the patch.

Another third (and then some) is arch updates - powerpc (with some bulky 
defconfig updates) along with arm, ia64 and mips updates.

And the remaining 30% is the stuff most people will care about. Lots of 
(mostly small) fixes, and mostly to drivers - but also documentation. The 
appended ShortLog gives some idea of the details.

				Linus

---
Alan Cox (4):
      pata_sc1200: Fix crash on boot
      dpt_i2o: Fix up copy*user
      ray_cs: Fix copy_from_user handling
      tty: Mark generic_serial users as BROKEN

Alex Chiang (7):
      Documentation: ABI: rename sysfs-devices-cache_disable properly
      Documentation: ABI: document /sys/devices/system/cpu/
      Documentation: ABI: /sys/devices/system/cpu/ topology files
      Documentation: ABI: /sys/devices/system/cpu/cpu#/ topology files
      Documentation: ABI: /sys/devices/system/cpu/sched_[mc|smt]_power_savings
      Documentation: ABI: /sys/devices/system/cpu/cpuidle/
      Documentation: ABI: /sys/devices/system/cpu/cpu#/node

Alexander Duyck (3):
      igb: fix memory leak when setting ring size while interface is down
      ixgbe: fix memory leak when resizing rings while interface is down
      igbvf: fix memory leak when ring size changed while interface down

Alexey Dobriyan (2):
      loop: fix NULL dereference if mount fails
      sysctl: fix false positives when PROC_SYSCTL=n

Amit Kumar Salecha (1):
      netxen: fix tx timeout handling on firmware hang

Andi Kleen (4):
      HWPOISON: Clean up PR_MCE_KILL interface
      HWPOISON: Add brief hwpoison description to Documentation
      HWPOISON: Fix page count leak in hwpoison late kill in do_swap_page
      HWPOISON: Allow schedule_on_each_cpu() from keventd

Andreas Gruenbacher (1):
      dnotify: ignore FS_EVENT_ON_CHILD

Andreas Schwab (2):
      powerpc: Fix segment mapping in vdso32
      powerpc: Align vDSO base address

Andrew Morton (2):
      dm log: userspace fix incorrect luid cast in userspace_ctr
      revert "mm: oom analysis: add buffer cache information to show_free_areas()"

Andrey Yurovsky (1):
      mac80211: trivial: fix spelling in mesh_hwmp

Andy Whitcroft (7):
      checkpatch: possible types -- prevent illegal modifiers being added
      checkpatch: correctly stop scanning at the bottom of a hunk
      checkpatch: update copyright dates
      checkpatch: fix false errors due to macro concatenation
      checkpatch: fix __attribute__ matching
      checkpatch: fix false EXPORT_SYMBOL warning
      checkpatch: version 0.30

Anton Vorontsov (1):
      USB: fsl_udc_core: Fix kernel oops on module removal

Arjan van de Ven (4):
      perf timechart: Fix the wakeup-arrows that point to non-visible processes
      perf timechart: Improve the visual appearance of scheduler delays
      net: use WARN() for the WARN_ON in commit b6b39e8f3fbbb
      x86: Remove STACKPROTECTOR_ALL

Arnaud Patard (1):
      MIPS: O32: Fix ppoll

Artem Bityutskiy (2):
      ARM: 5759/1: Add register information of threads to coredump
      UBI: fix backward compatibility

Atsushi Nemoto (1):
      MIPS: TXx9: Fix spi-baseclk value

Barry Song (1):
      ASoC: Fix possible codec_dai->ops NULL pointer problems

Bartlomiej Zolnierkiewicz (2):
      MAINTAINERS: rt2x00 list is moderated
      MAINTAINERS: rt2x00 list is moderated

Ben Dooks (10):
      KS8851: Add soft reset at probe time
      KS8851: Fix MAC address write order
      KS8851: Fix ks8851_set_rx_mode() for IFF_MULTICAST
      DM9000: Fix revision ID for DM9000B
      ARM: S3C: Add info for supporting circular DMA buffers
      ARM: S3C2410: Fix link if CONFIG_S3C2410_IOTIMING is not set
      ARM: S3C2440: mini2440: Fix missing CONFIG_S3C_DEV_USB_HOST
      ARM: S3C24XX: Fix warnings in arch/arm/plat-s3c24xx/gpio.c
      ARM: S3C2440: mini2440: Fix spare warnings
      ARM: S3C2410: Fix sparse warnings in arch/arm/mach-s3c2410/gpio.c

Ben Hutchings (2):
      sfc: Set ip_summed correctly for page buffers passed to GRO
      hfsplus: refuse to mount volumes larger than 2TB

Benjamin Herrenschmidt (2):
      powerpc/ppc64: Use preempt_schedule_irq instead of preempt_schedule
      8250_pci: add IBM Saturn serial card

Benoit PAPILLAULT (1):
      rt2x00: Fix crypto in TX frame for rt2800usb

Björn Smedman (1):
      mac80211: fix for incorrect sequence number on hostapd injected frames

Bo Liu (1):
      mm: remove incorrect swap_count() from try_to_unuse()

Borislav Petkov (1):
      amd64_edac: fix DRAM base and limit extraction masks, v2

Brandon Philips (1):
      sky2: set carrier off in probe

Brice Goglin (1):
      myri10ge: improve port type reporting in ethtool

Bruce Allan (9):
      e1000e: reset the PHY on 82577/82578 when going to Sx
      e1000e: clear PHY wakeup bit after LCD reset on 82577/82578
      e1000e: increase swflag acquisition timeout for ICHx/PCH
      e1000e: 82577/82578 requires a different method to configure LPLU
      e1000e: separate mutex usage between NVM and PHY/CSR register for ICHx/PCH
      e1000e: allow for swflag to be held over consecutive PHY accesses
      e100: e100_phy_init() isolates selected PHY, causes 10 second boot delay
      e1000e: config PHY via software after resets
      e1000e: rework disable K1 at 1000Mbps for 82577/82578

Bryan Wu (1):
      USB: option: TLAYTECH TUE800 support

Catalin Marinas (1):
      ARM: 5757/1: Thumb-2: Correct "mov.w pc, lr" instruction which is unpredictable

Chris Dearman (4):
      MIPS: MTI: Fix accesses to device registers on MIPS boards
      MIPS: SPRAM: Clean up support code a little
      MIPS: CMP: Fix memory barriers for correct operation of amon_cpu_start
      MIPS: GIC: Random fixes and enhancements.

Christian Borntraeger (2):
      virtio: let header files include virtio_ids.h
      connector: fix regression introduced by sid connector

Christof Schmitt (4):
      [SCSI] zfcp: Handle WWPN mismatch in PLOGI payload
      [SCSI] zfcp: Warn about storage devices with broken PLOGI data
      [SCSI] zfcp: Fix timer initialization for ct and els requests
      [SCSI] zfcp: Flush SCSI registration work when adding unit

Christoph Hellwig (2):
      xfs: fix double IRELE in xfs_dqrele_inode
      virtio_blk: revert QUEUE_FLAG_VIRT addition

Claudio Scordino (1):
      ARM: 5776/1: Check compiler version and EABI support when adding ARM unwind support.

Clemens Ladisch (1):
      sound: via82xx: deactivate DXS controls of inactive streams

Daisuke Nishimura (1):
      mm: don't call pte_unmap() against an improper pte

Dan Williams (6):
      md/raid5: initialize conf->device_lock earlier
      md/raid456: downlevel multicore operations to raid_run_ops
      md/raid6: kill a gcc-4.0.1 'uninitialized variable' warning
      async_pq: kill a stray dma_map() call and other cleanups
      async_pq: rename scribble page
      async_tx: fix asynchronous raid6 recovery for ddf layouts

Daniel T Chen (1):
      ALSA: hda: Use quirk mask for Dell Inspiron Mini9/Vostro A90 using ALC268

Darren Hart (2):
      futex: Check for NULL keys in match_futex
      futex: Move drop_futex_key_refs out of spinlock'ed region

Darrick J. Wong (2):
      KVM: Prevent kvm_init from corrupting debugfs structures
      hwmon: enhance the sysfs API for power meters

Dave Airlie (2):
      drm/radeon/kms: ignore vga arbiter return.
      drm/kms: fix kms/fbdev colormap support properly.

Dave Young (2):
      bluetooth: scheduling while atomic bug fix
      bluetooth: static lock key fix

David Daney (3):
      MIPS: Octeon: Fix compile error in arch/mips/cavium-octeon/smp.c
      MIPS: Octeon: Use write_{un,}lock_irq{restore,save} to set irq affinity
      MIPS: Octeon: Use lockless interrupt controller operations when possible.

David Howells (1):
      NOMMU: Don't pass NULL pointers to fput() in do_mmap_pgoff()

David Härdeman (1):
      Input: winbond-cir - select LEDS_TRIGGERS

David S. Miller (1):
      Revert "tcp: fix tcp_defer_accept to consider the timeout"

David Woodhouse (1):
      libertas if_usb: Fix crash on 64-bit machines

Dhananjay Phadke (2):
      netxen: fix i2c init
      netxen: avoid undue board config check

Dmitry Eremin-Solenikov (1):
      Input: gpio-keys - use IRQF_SHARED

Dmitry Torokhov (9):
      Input: synaptics - add another Protege M300 to rate blacklist
      Input: i8042 - make pnp_data_busted variable boolean instead of int
      Input: atkbd - restore resetting LED state at startup
      Input: atkbd - postpone restoring LED/repeat rate at resume
      Input: fix locking issue in /proc/bus/input/ handlers
      Input: i8042 - add Sony Vaio VGN-FZ240E to the nomux list
      Input: logips2pp - model 73 is actually TrackMan FX
      Driver core: allow certain drivers prohibit bind/unbind via sysfs
      Input: i8042 - try to get stable CTR value when initializing

Dominik Brodowski (3):
      pcmcia: pccard_read_tuple and TUPLE_RETURN_COMMON cleanup
      pcmcia: do not try to store more than 4 version strings
      ALSA: pcmcia: use dynamic debug infrastructure, deprecate CS_CHECK (sound)

Earl Chew (1):
      fs: pipe.c null pointer dereference

Eero Nurkkala (1):
      ASoC: Serialize access to dapm_power_widgets()

Eli Cohen (1):
      mlx4_core: Add a new supported 40 GigE device ID

Elina Pasheva (2):
      USB: serial: sierra driver send_setup() autopm fix
      USB: serial: sierra driver autopm fixes

Eric Dumazet (7):
      virtio_net: use dev_kfree_skb_any() in free_old_xmit_skbs()
      net: Fix IP_MULTICAST_IF
      net: Fix struct inet_timewait_sock bitfield annotation
      ifb: should not use __dev_get_by_index() without locks
      pktgen: Dont leak kernel memory
      net: fix kmemcheck annotations
      net: fix sk_forward_alloc corruption

Eric Paris (2):
      fsnotify: do not set group for a mark before it is on the i_list
      inotify: deprecate the inotify kernel interface

Eric Sandeen (1):
      xfs: free temporary cursor in xfs_dialloc

Eric Van Hensbergen (1):
      9p: fix readdir corner cases

Feng Tang (1):
      x86: Make EFI RTC function depend on 32bit again

Florian Fainelli (6):
      MIPS: BCM63xx: Fix soft-reset lockup on BCM6345
      MIPS: AU1000: Fix build failure for db1x00 configured for Au1100 SoC
      MIPS: BCM63xx: Make bcm63xx_uart_register an initfunc
      MIPS: BCM63xx: Prepare for watchdog support
      MIPS: AR7: register watchdog device only if enabled in hw configuration
      MIPS: bcm63xx: Set the correct BCM3302 CPU name

Frans Pop (1):
      pcmcia: properly close previous dev_printk if kzalloc fails in do_io_probe

Frederik Deweerdt (1):
      KVM: MMU: fix pointer cast

Gabor Gombas (1):
      net: Fix 'Re: PACKET_TX_RING: packet size is too long'

George Nassar (1):
      USB: rndis_host: debug info clobbered before it is logged

Grant Likely (2):
      powerpc/5200: Update defconfigs
      MAINTAINERS: add Open Firmware / Flattened Device Tree entry

Greg Kroah-Hartman (3):
      Staging: remove stlc45xx driver
      Staging: android: mark subsystem as broken
      Staging: wireless drivers Kconfig change

Guennadi Liakhovetski (2):
      fix compilation of i.MX31 platforms
      fix pcm037_eet compilation with the new SPI driver

Gwendal Grignou (1):
      sata_mv: Prevent PIO commands to be defered too long if traffic in progress.

Haavard Skinnemoen (1):
      atmel_serial: fix bad BUILD_BUG_ON() usage

Haiyang Zhang (1):
      Staging: hv: Fix null pointer error after vmbus loading

Hank Janssen (1):
      Staging: hv: Fix vmbus load hang caused by faulty data packing

Harald Welte (1):
      ARM: S3C24XX: Introduce S3C2442B CPU

Hartley Sweeten (4):
      ARM: 5760/1: ep93xx: fix build error in edb93xx.c
      ARM: 5767/1: ep93xx: remove ep93xx_init_time() prototype
      ARM: 5768/1: ep93xx: remove dead code in ep93xx_gpio_ab_irq_handler()
      ARM: 5769/1: CPU_ARM920T: remove dead Maverick EP9312 URL

Heiko Carstens (6):
      [SCSI] zfcp: fix kfree handling in zfcp_init_device_setup
      [S390] smp: fix prefix handling of offlined cpus
      [S390] call home: fix error handling in init function
      [S390] call home: fix string length handling
      [S390] smp: fix sigp stop handling
      [S390] smp: fix sigp sense handling

Heiko Schocher (2):
      mpc5200: support for the MAN mpc5200 based board uc101
      mpc5200: support for the MAN mpc5200 based board mucmc52

Herbert Xu (3):
      crypto: padlock-sha - Fix stack alignment
      tcp: Try to catch MSG_PEEK bug
      gre: Fix dev_addr clobbering for gretap

Herton Ronaldo Krzesinski (2):
      Input: atkbd - consolidate force release quirks for volume keys
      Staging: rtl8187se/rtl8192e/rtl8192su: allow module unload

Hiroshi DOYU (1):
      omap: iommu: fix wrong condition check for SUPERSECTION

Holger Schurig (1):
      libertas spi: fix sparse errors

Huang Ying (1):
      crypto: aesni-intel - Fix irq_fpu_usable usage

Huaxu Wan (1):
      hwmon: (coretemp) Maintainer update

Hugh Dickins (4):
      HWPOISON: fix oops on ksm pages
      HWPOISON: fix/proc/meminfo alignment
      hwpoison: fix oops on ksm pages
      hwpoison: fix/proc/meminfo alignment

Ian Campbell (1):
      Correct nr_processes() when CPUs have been unplugged

Ian E. Morgan (1):
      lis3: add support for the HP HDX 18

Ilkka Koskinen (1):
      mfd: Do not dereference null pointer in twl4030 error path

Ingo Molnar (2):
      x86: Document linker script ASSERT() quirk
      perf tools: Bump version to 0.0.2

Ira W. Snyder (1):
      edac: i5400 fix missing CONFIG_PCI define

Jaidev Patwardhan (2):
      MIPS: GCMP: Avoid accessing registers when they are not present
      MIPS: SMTC: Avoid queing multiple reschedule IPIs

James Bottomley (1):
      [SCSI] fix memory leak in initialization

Jamie Lentin (1):
      Input: atkbd - add a quirk for OQO 01+ multimedia keys

Jan Beulich (1):
      x86-64: Fix register leak in 32-bit syscall audting

Janusz Krzysztofik (5):
      omap: Fix omap-keypad by restoring old keypad.h without breaking omap2 boards that use matrix_keypad
      omap1: Fix redundant UARTs pin muxing that can break other hardware support
      omap1: Fix DSP public peripherals support for ams-delta
      ASoC: Amstrad Delta: add info about the line discipline requirement to Kconfig help text
      netdev: usb: dm9601.c can drive a device not supported yet, add support for it

Jasper Spaans (1):
      bonding: Modify hash transmit policies to use the packet's source MAC address

Jean Delvare (2):
      hwmon: (dme1737) No vid attributes for SCH311x
      hwmon: (it87) Fix VID reading on IT8718F/IT8720F

Jeff Mahoney (1):
      hfs: fix oops on mount with corrupted btree extent records

Jeff Roberson (1):
      edac: i5400 fix csrow mapping

Jens Axboe (1):
      backing-dev: ensure that a removed bdi no longer has super_block referencing it

Jeremy Fitzhardinge (1):
      xen: set up mmu_ops before trying to set any ptes

Jesse Barnes (1):
      Revert "PCI: get larger bridge ranges when space is available"

Jiri Bohac (1):
      bonding: fix a race condition in calls to slave MII ioctls

Jiri Kosina (2):
      percpu: allow pcpu_alloc() to be called with IRQs off
      sched: move rq_weight data array out of .percpu

Jiri Olsa (4):
      tracing: Update *ppos instead of filp->f_pos
      tracing: Fix trace_seq_printf() return value
      tracing: Fix comment typo and documentation example
      tracing: Remove cpu arg from the rb_time_stamp() function

Jiri Slaby (4):
      x86: crash_dump: Fix non-pae kdump kernel memory accesses
      PM / Hibernate: Fix blkdev refleaks
      PM / Hibernate: Fix error handling in save_image()
      PM / Hibernate: Add newline to load_image() fail path

Joakim Tjernlund (1):
      i2c-mpc: Do not generate STOP after read.

Joe Perches (13):
      MAINTAINERS: update GENERIC UIO FOR PCI DEVICES
      MAINTAINERS: update TRACING section
      MAINTAINERS: update OMAP Tony Lindgren email name
      MAINTAINERS: change ATM mailing list to moderated
      MAINTAINERS: use tab not spaces after field types
      MAINTAINERS: update Kernel Janitors after mismerge
      MAINTAINERS: update SCORE architecture name style and add file pattern
      MAINTAINERS: SIMPLE FIRMWARE INTERFACE: update email style
      MAINTAINERS: WINBOND CIR - Integrate P:/M: lines, fixup David Härdeman's name
      MAINTAINERS: fix up PERIPHERAL spelling
      MAINTAINERS: update WOLFSON MICROELECTRONICS
      scripts/get_maintainer.pl: add patch/file search for keywords
      MAINTAINERS: document new "K:" entry type

Johannes Berg (7):
      mac80211: keep auth state when assoc fails
      cfg80211: sme: deauthenticate on assoc failure
      mac80211: fix BSS leak
      mac80211: fix addba timer
      mac80211: fix reason code output endianness
      cfg80211: fix NULL ptr deref
      mac80211: check interface is down before type change

Johannes Weiner (1):
      vmscan: order evictable rescue in LRU putback

Jonathan Brassow (1):
      dm snapshot: free exception store on init failure

JosephChan@via.com.tw (1):
      pata_via: extend the rev_max for VT6330

Josh Boyer (1):
      powerpc/booke: Fix xmon single step on PowerPC Book-E

Joyce Yu (1):
      niu: VLAN_ETH_HLEN should be used to make sure that the whole MAC header was copied to the head buffer in the Vlan packets case

Julia Lawall (4):
      drivers/serial/mpc52xx_uart.c: Use UPIO_MEM rather than SERIAL_IO_MEM
      ARM: S3C24XX: arch/arm/plat-s3c24xx: Move dereference after NULL test
      ALSA: sound: Move dereference after NULL test and drop unnecessary NULL tests
      ALSA: sound/parisc: Move dereference after NULL test

Julian Anastasov (3):
      tcp: accept socket after TCP_DEFER_ACCEPT period
      tcp: reduce SYN-ACK retrans for TCP_DEFER_ACCEPT
      tcp: fix TCP_DEFER_ACCEPT retrans calculation

Jérôme Pouiller (1):
      of: Remove nested function

KOSAKI Motohiro (5):
      congestion_wait(): don't use WRITE
      cgroup: fix strstrip() misuse
      strstrip(): mark as as must_check
      mbind(): fix leak of never putback pages
      do_mbind(): fix memory leak

Keith Mannthey (1):
      edac: i5100 fix initialization code

Ken Kawasaki (1):
      pcnet_cs: add cis of PreMax PE-200 ethernet pcmcia card

Kevin Cernekee (1):
      MIPS: Fix machine check exception in kmap_coherent()

Kevin Hilman (2):
      omap3: PM: enable UART3 module wakeups
      cpuidle: always return with interrupts enabled

Kiyoshi Ueda (1):
      dm: dec_pending needs locking to save error value

Komuro (1):
      pcmcia: do not load the pd6729 driver if io_base is NULL

Krauth.Julien (1):
      serial: add ADDI-DATA GmbH PCI-Express communication cards in 8250_pci.c and pci_ids.h

Kukjin Kim (1):
      ARM: S3C64XX: Fix S3C64XX_CLKDIV0_ARM_MASK value

Kumar Gala (7):
      powerpc: Add a Book-3E 64-bit defconfig
      powerpc: Fix compile errors found by new ppc64e_defconfig
      powerpc: Limit hugetlbfs support to PPC64 Book-3S machines
      powerpc: Limit memory hotplug support to PPC64 Book-3S machines
      powerpc: Minor cleanup to init/Kconfig
      powerpc: Minor cleanup to sound/ppc/Kconfig
      powerpc: Minor cleanup to lib/Kconfig.debug

Larry Finger (1):
      b43: Fix Bugzilla #14181 and the bug from the previous 'fix'

Leo Chen (1):
      ARM: 5764/1: bcmring: add oprofile pmu support

Linus Torvalds (3):
      i915: fix intel graphics suspend breakage due to resume/lid event confusion
      Revert "ext4: Remove journal_checksum mount option and enable it by default"
      Linux 2.6.32-rc6

Linus Walleij (1):
      ARM: 5765/1: Updated U300 defconfig

Lubomir Rintel (1):
      sh: Build fix: define more __movmem* symbols

Luis R. Rodriguez (1):
      ath9k: fix misplaced semicolon on rate control

Magnus Damm (3):
      sh: disabled cache handling fix.
      sh: rsk7203 CONFIG_MTD=n fix
      sh: add uImage.bin target

Manuel Lauss (2):
      net: au1000_eth: add missing capability.h
      MIPS: Alchemy: Fix hang with high-frequency edge interrupts

Marcelo Tosatti (1):
      KVM: use proper hrtimer function to retrieve expiration time

Marcin Slusarz (1):
      [IA64] use printk_once() unaligned.c/io_common.c

Mark Brown (2):
      ARM: S3C64XX: Set rate of crystal mux
      mfd: Always initialise WM831x IRQ mutex

Mark Hills (3):
      ALSA: snd-usb-caiaq: Missing lock around use of buffer positions
      ALSA: snd-usb-caiaq: Lock on stream start/unpause
      ALSA: snd-usb-caiaq: Bump version number to 1.3.20

Mark McLoughlin (1):
      block: silently error unsupported empty barriers too

Marti Raudsepp (1):
      perf tools: Fix compatibility with libelf 0.8 and autodetect

Martin Schwidefsky (2):
      [S390] s/r: cmm resume fix
      [S390] cputime: fix overflow on 31 bit systems

Martin Stava (2):
      9p: fix a small bug in readdir for long directories
      9p: fix readlink

Matt Fleming (1):
      sh: Check for return_to_handler when unwinding the stack

Matthew Wilcox (1):
      [IA64] Require SAL 3.2 in order to do extended config space ops

Michael Buesch (1):
      b43: Fix DMA TX bounce buffer copying

Michael Chan (1):
      cnic: Fix L2CTX_STATUSB_NUM offset in context memory.

Michael Neuling (1):
      powerpc/perf_events: Fix priority of MSR HV vs PR bits

Michael S. Tsirkin (3):
      virtio-net: fix data corruption with OOM
      virtio-pci: fix per-vq MSI-X request logic
      virtio: order used ring after used index read

Michal Ostrowski (1):
      PPPoE: Fix flush/close races.

Miguel Boton (1):
      b43: add 'struct b43_wl' missing declaration

Mike Frysinger (1):
      twl4030-gpio: remove __devexit markings from remove func

Mike Rapoport (1):
      [ARM] pxa/cm-x300: fix mmc numbering

Mikulas Patocka (7):
      dm snapshot: sort by chunk size to fix race
      dm snapshot: require non zero chunk size by end of ctr
      dm exception store: fix failed set_chunk_size error path
      dm snapshot: lock snapshot while supplying status
      dm snapshot: use unsigned integer chunk size
      dm snapshot: allow chunk size to be less than page size
      ide: Serialize CMD643 and CMD646 to fix a hardware bug with SSD

Milan Dadok (3):
      Staging: hv: fix oops in vmbus - udev events
      Staging: hv: fix oops in vmbus - netvsc list_head
      Staging: hv: fix oops in vmbus - missing #include

Neil Brown (1):
      block: use after free bug in __blkdev_get

Neil Horman (1):
      AF_RAW: Augment raw_send_hdrinc to expand skb to fit iphdr->ihl (v2)

NeilBrown (8):
      Revert "md: do not progress the resync process if the stripe was blocked"
      md/raid1/raid10: add a cond_resched
      md: raid1/raid10: handle allocation errors during array setup.
      md: remove clumsy usage of do_sync_mapping_range from bitmap code
      md: fix problems with RAID6 calculations for DDF.
      md: Fix handling of raid5 array which is being reshaped to fewer devices.
      md/async: don't pass a memory pointer as a page pointer.
      raid6/async_tx: handle holes in block list in async_syndrome_val

Nicolas Ferre (2):
      avr32: add two new at91 to cpu.h definition
      at91: at91sam9g45 family: identify several chip versions

Nigel Stephens (1):
      MIPS: Fix abs.[sd] and neg.[sd] emulation for NaN operands

Nobuhiro Iwamatsu (1):
      sh_eth: Add asm/cacheflush.h

OGAWA Hirofumi (1):
      dpt_i2o: Fix typo of EINVAL

Paul E. McKenney (3):
      rcu: Prevent RCU IPI storms in presence of high call_rcu() load
      rcu: Stopgap fix for synchronize_rcu_expedited() for TREE_PREEMPT_RCU
      rcu: Fix TREE_PREEMPT_RCU CPU_HOTPLUG bad-luck hang

Paul Mackerras (1):
      perf_event: Adjust frequency and unthrottle for non-group-leader events

Paul Mundt (5):
      sh: Kill off stray HAVE_FTRACE_SYSCALLS reference.
      sh: __irq_entry annotate do_IRQ().
      perf tools: Remove -Wcast-align
      sh: Document uImage.bin target in archhelp.
      sh: Fix hugetlbfs dependencies for SH-3 && MMU configurations.

Pavel Herrmann (1):
      lis3: better support for hp 6730x

Pavel Machek (1):
      PM: Remove some debug messages producing too much noise

Peter Huewe (1):
      Staging: Panel: prevent driver from calling misc_deregister twice on same ressource

Peter Zijlstra (2):
      sched: Disable SD_PREFER_LOCAL for MC/CPU domains
      sched: Do less agressive buddy clearing

Philby John (1):
      ARM: 5774/1: Fix Realview ARM1176PB board reboot

Rafael J. Wysocki (2):
      PM: Make warning in suspend_test_finish() less likely to happen
      PM / yenta: Split resume into early and late parts (rev. 4)

Raimonds Cicans (1):
      r8169: Fix card drop incoming VLAN tagged MTU byte large jumbo frames

Ralf Baechle (11):
      MIPS: Extend COMMAND_LINE_SIZE
      MIPS: Don't write ones to reserved entryhi bits.
      MIPS: Cleanup CONFIG_DEBUG_STACK_USAGE version of alloc_thread_info.
      MIPS: IP27: Fix build
      MIPS: VPE: Remove stray unlock_kernel.
      MIPS: MTX-1: Fix build if CONFIG_PCI is disabled.
      MIPS: Kconfig: Fix duplicate default value for MIPS_L1_CACHE_SHIFT.
      MIPS: Malta: Enable PCI 2.1 compatibility in PIIX4
      MIPS: 1004K: Enable SPRAM support.
      MIPS: Set S-cache linesize to 64-bytes for MTI's S-cache
      MIPS: Avoid potential hazard on Context register

Ralf Roesch (1):
      MIPS: TXx9: Fix error handling / Fix for noenexisting gpio_remove.

Ramax Lo (1):
      ARM: S3C24XX: Define a macro to avoid compilation error

Randy Dunlap (5):
      [IA64] fix percpu warnings
      vmxnet3: use dev_dbg, fix build for CONFIG_BLOCK=n
      pcmcia: fix controller printk format warnings
      cpufreq: add cpufreq_get() stub for CONFIG_CPU_FREQ=n
      Staging: fix wireless drivers depends

Reinette Chatre (1):
      mac80211: fix ibss joining

Richard Zhao (3):
      i2c: imx: check busy bit when START/STOP
      i2c: imx: only imx1 needs disable delay
      i2c: imx: disable clock when it's possible to save power.

Robin Holt (3):
      x86, UV: Fix information in __uv_hub_info structure
      x86, UV: Fix and clean up bau code to use uv_gpa_to_pnode()
      x86, UV: Set DELIVERY_MODE=4 for vector=NMI_VECTOR in uv_hub_send_ipi()

Roel Kluin (6):
      [IA64] unsigned cannot be less than 0 in sn_hwperf_ioctl()
      Input: hp_sdc_rtc - fix test in hp_sdc_rtc_read_rt()
      UBI: fix check on unsigned long
      hwmon: (fschmd) Fix check on unsigned in watchdog_write()
      airo: Reorder tests, check bounds before element
      frv: fix check on unsigned in do_signal()

Roger Quadros (1):
      omap_hsmmc: add missing probe handler hook

Roland Dreier (1):
      x86: Don't print number of MCE banks for every CPU

Romit Dasgupta (1):
      PM: Fix warning on suspend errors

Ron Mercer (2):
      qlge: Fix EEH handling.
      qlge: Fix firmware mailbox command timeout.

Russell King (8):
      ARM: Fix lubbock defconfig build
      ARM: Fix signal restart issues with NX and OABI compat
      ARM: integrator: allow Integrator to be built with highmem
      ARM: Use GFP_DMA only for masks _less_ than 32-bit
      mm: fix sparsemem configuration
      ARM: Fix sparsemem with SPARSEMEM_EXTREME enabled
      ARM: Fix errata 411920 workarounds
      ARM: ensure initial page tables are setup for SMP systems

Rusty Russell (5):
      virtio_blk: Revert serial number support
      x86: Side-step lguest problem by only building cmpxchg8b_emu for pre-Pentium
      param: fix lots of bugs with writing charp params from sysfs, by leaking mem.
      param: fix NULL comparison on oom
      param: fix setting arrays of bool

Ryan Mallon (1):
      ARM: S3C: Fix adc function exports

Ryota Yamauchi (1):
      xfs: fix xfs_quota remove error

Ryusuke Konishi (3):
      nilfs2: fix dirty page accounting leak causing hang at write
      nilfs2: fix irregular checkpoint creation due to data flush
      nilfs2: add zero-fill for new btree node buffers

Santosh Shilimkar (4):
      ARM: 5763/1: ARM: SMP: Fix the BUG with CONFIG_PREEMPT enabled
      omap: SDMA: Fix omap_stop_dma() API for channel linking
      omap4: Allow omap_serial_early_init() for OMAP4430 board
      omap4: Fix UART4 platform data on omap4

Sascha Hauer (6):
      i.MX27 clock: rename spi clocks to match device
      mx25 devices: Add missing include
      mx25pdk: remove nand support as it is not present in current tree
      mx25: Add missing copyright / license header
      pcm038: Add SPI/MC13783 support
      pcm970 mmc: Fix ro switch

Sathya Perla (2):
      be2net: fix promiscuous and multicast promiscuous modes being enabled always
      be2net: fix support for PCI hot plug

Sebastian Ott (1):
      [S390] call home: fix local buffer usage in proc handler

Shane Huang (1):
      ahci / atiixp / pci quirks: rename AMD SB900 into Hudson-2

Simon Wunderlich (1):
      r8169: fix Ethernet Hangup for RTL8110SC rev d

Soeren Sandmann (2):
      perf events: Fix swevent hrtimer sampling by keeping track of remaining time when enabling/disabling swevent hrtimers
      perf events: Don't generate events for the idle task when exclude_idle is set

Stanislav Brabec (1):
      [ARM] pxa/spitz: add gpio button support (fixes regression)

Stas Sergeev (2):
      ALSA: pcsp - Fix nforce workaround
      Driver core: fix driver_register() return value

Stephen Hemminger (1):
      Staging: hv TODO patches

Stephen Rothwell (1):
      powerpc/iseries: Remove compiler version dependent hack

Steve French (1):
      [CIFS] Fixing to avoid invalid kfree() in cifs_get_tcp_session()

Steven King (1):
      net: fix section mismatch in fec.c

Takao Indoh (1):
      [IA64] Restore registers in the stack on INIT

Takashi Iwai (3):
      ALSA: hda - Fix capture source checks for ALC662/663 codecs
      ALSA: dummy - Fix descriptions of pcm_substreams parameter
      ALSA: hda - Don't check invalid HP pin

Tejun Heo (3):
      sata_nv: make sure link is brough up online when skipping hardreset
      libata: fix PMP initialization
      libata: fix internal command failure handling

Terry Loftin (1):
      nfs: Panic when commit fails

Thomas Chou (2):
      ethoc: inline regs access
      ethoc: clear only pending irqs

Thomas Gleixner (3):
      futex: Handle spurious wake up
      sh: Remove BKL from landisk gio.
      futex: Fix spurious wakeup for requeue_pi really

Tim Blechmann (1):
      perf top: Fix --delay_secs 0 division by zero

Tomoki Sekiyama (1):
      AF_UNIX: Fix deadlock on connecting to shutdown socket

Tony Lindgren (2):
      omap2: Fix detection of n8x0
      omap2: Fix console serial port number for n8x0

Tony Luck (4):
      [IA64] Squeeze ticket locks back into 4 bytes.
      [IA64] Re-implement spinaphores using ticket lock concepts
      [IA64] SMT friendly version of spin_unlock_wait()
      Revert "[IA64] fix percpu warnings"

Trond Myklebust (3):
      NFSv4: Fix a bug when the server returns NFS4ERR_RESOURCE
      NFSv4: Fix two unbalanced put_rpccred() issues.
      NFSv4: The link() operation should return any delegation on the file

Uwe Kleine-König (3):
      mmc: at91_mci: Don't include asm/mach/mmc.h
      move virtballoon_remove to .devexit.text
      move virtrng_remove to .devexit.text

Valentin Longchamp (1):
      MXC: fix reset for mx31, mx35 and mx27 SoCs

Valentin Sitdikov (1):
      sh: Fix up single page flushing to use PAGE_SIZE.

Vladimir Dronnikov (1):
      md: drivers/md/unroll.pl replaced with awk analog

Wei Yongjun (1):
      inotify: fix coalesce duplicate events into a single event in special case

Wolfram Sang (2):
      powerpc/boot/dts: drop obsolete 'fsl5200-clocking'
      pcmcia: Fix possible printk format warnings

Wu Fengguang (3):
      HWPOISON: return early on non-LRU pages
      HWPOISON: fix invalid page count in printk output
      vmscan: limit VM_EXEC protection to file pages

Wu Zhangjin (6):
      ALSA: SND_CS5535AUDIO: Remove the X86 platform dependency
      MIPS: Loongson: Remove redundant local_irq_disable()
      MIPS: Add IRQF_TIMER flag for timer interrupts
      MIPS: 64-bit: Fix o32 lookup_dcookie syscall
      MIPS: Add IRQF_TIMER flag for timer interrupts
      MIPS: Oprofile: Rename cpu_type from godson2 to loongson2

Xiaotian Feng (1):
      isdn: fix possible circular locking dependency

Xose Vazquez Perez (1):
      rt73usb.c : more ids

Yegor Yefremov (1):
      ARM: 5766/1: Fix watchdog enabling for AT91SAM9G45

Yinghai Lu (1):
      nfs: Fix nfs_parse_mount_options() kfree() leak

Yoshihiro Shimoda (1):
      USB: r8a66597-hcd: fix cannot detect a device when uses_new_polling is set

Zdenek Kabelac (1):
      dm: add missing del_gendisk to alloc_dev error path

Zhang Le (1):
      MIPS: Loongson 2: Set cpu_has_dc_aliases and cpu_icache_snoops_remote_store

Zhao Yakui (1):
      drm: Add the basic check for the detailed timing in EDID

Zhu Yi (1):
      ipw2200: fix oops on missing firmware

jamal (1):
      net: Fix RPF to work with policy routing

miaofng (1):
      Staging: vt6656: fix the memory free bug in vntwusb_disconnect()

peer chen (2):
      ahci: Add the AHCI controller Linux Device ID for NVIDIA chipsets.
      ALSA: hda_intel: Add the Linux device ID for NVIDIA HDA controller

roel kluin (1):
      ibmtr: possible Read buffer overflow?

Éric Piel (1):
      lis3: add support for the HP EliteBook 8530w
