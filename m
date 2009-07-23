Return-Path: <linux-kernel-owner+w=401wt.eu-S1752493AbZGWCoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493AbZGWCoo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 22:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751689AbZGWCon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 22:44:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55832 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751295AbZGWCol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 22:44:41 -0400
Date: Wed, 22 Jul 2009 19:44:12 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.31-rc4
Message-ID: <alpine.LFD.2.01.0907221936220.3352@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ok, that was a fun week.

We had a binutils bug, a ccache bug, and a compiler bug. And that was just 
the bugs that were outside the kernel, but resulted in a broken build.

But while that was unusual, the rest of the stuff is pretty regular. Lots 
of small fixes all around. The patch is dominated by a couple of new 
network drivers, but apart from those, it's generally pretty small - lots 
of one-liners and "few-liners".

The shortlog gives a reasonable idea about what's happened. 

		Linus

---
Abhishek Kulkarni (3):
      9p: default 9p transport module fix
      9p: Possible regression in p9_client_stat
      9p: Fix incorrect parameters to v9fs_file_readn.

Alan Cox (4):
      tty: fix close/hangup race
      n_tty: Fix echo race
      tty_port: Fix return on interrupted use
      tty: fix chars_in_buffers

Alberto Panizzo (2):
      ARM MXC: Armadillo 500 add NOR flash device support (resend).
      Armadillo 500 add NAND flash device support (resend).

Alex Deucher (1):
      drm/radeon: add some missing pci ids

Alex Williamson (1):
      virtio_net: Sync header with qemu

Andreas Jaggi (1):
      gre: fix ToS/DiffServ inherit bug

Andreas Schwab (1):
      powerpc: Fix another bug in move of altivec code to vector.S

Andrew Morton (1):
      drivers/serial/bfin_sport_uart.c: remove wrong and unneeded memset

Anton Blanchard (8):
      perf_counter tools: Rename cache events to remove $
      perf_counter: Make sure we dont leak kernel memory to userspace
      perf_counter: Synthesize VDSO mmap event
      perf_counter: Log vfork as a fork event
      perf_counter: Add perf record option to log addresses
      perf_counter: Make call graph option consistent
      perf_counter: Improve perf stat and perf record option parsing
      perf_counter: Fix throttle/unthrottle event logging

Arjan van de Ven (3):
      perf: Fix stack data leak
      perf: avoid structure size confusion by using a fixed size
      perf: fix stack data leak

Arnaldo Carvalho de Melo (7):
      perf report: Adjust column width to the values sampled
      perf report: Tidy up reporting of symbols not found
      strlist: Introduce strlist__entry and strlist__nr_entries methods
      perf report: Make the output more compact
      perf_counter tools: PLT info is stripped in -debuginfo packages
      perf report: Introduce -n/--show-nr-samples
      perf symbol: C++ demangling

Arnaud Lacombe (2):
      kconfig: variable argument lists needs `stdarg.h'
      kconfig: initialize the screen before using curses(3) functions

Artem Bityutskiy (1):
      UBI: gluebi: initialize ubi_num field

Aurelien Jarno (1):
      Revert "Neither asm/types.h nor linux/types.h is required for arch/ia64/include/asm/fpu.h"

Barry Song (1):
      Blackfin: bf537-stamp: fix irq decl for AD7142

Ben Dooks (1):
      net: Micrel KS8851 SPI network driver

Ben Hutchings (2):
      netdev: restore MAC address set and validate operations
      netdev: restore MTU change operation

Bruno Premont (1):
      genirq: Fix UP compile failure caused by irq_thread_check_affinity

Casey Dahlin (1):
      dlm: free socket in error exit path

Cesar Eduardo Barros (1):
      New device ID for sc92031 [1088:2031]

Chris Wilson (1):
      perf_counter: Fix the tracepoint channel to perfcounters

Christoph Hellwig (2):
      virtio_blk: don't bounce highmem requests
      virtio_blk: ioctl return value fix

Clemens Ladisch (1):
      sound: usb-audio: add workaround for Blue Microphones devices

Daniel Mack (4):
      [ARM] pxa: correct I2CPWR clock for pxa3xx
      [ARM] pxa: use kzalloc() in pxa_init_gpio_chip()
      ASoC: Fix NULL pointer dereference in __pxa2xx_pcm_hw_free
      Input: fix EVIOCGNAME/JSIOCGNAME regression

Daniel Qarras (1):
      perf_counter, x86: Extend perf_counter Pentium M support

Dave Jones (1):
      x86: Fix warning in pvclock.c

Dave Kleikamp (1):
      powerpc: Fix booke user_disable_single_step()

David Brownell (1):
      i2c-davinci: behave with i2cdetect

David S. Miller (1):
      Revert "NET: Fix locking issues in PPP, 6pack, mkiss and strip line disciplines."

David Teigland (1):
      dlm: fix plock use-after-free

Davide Libenzi (1):
      lguest: remove unnecessary forward struct declaration

Dhananjay Phadke (3):
      netxen: fix context deletion sequence
      netxen: fix deadlock on dev close
      netxen: fix thermal check and shutdown

Dongdong Deng (1):
      drivers/net: using spin_lock_irqsave() in net_send_packet()

Eric Dumazet (5):
      net: sk_prot_alloc() should not blindly overwrite memory
      net: ip_push_pending_frames() fix
      igb: gcc-3.4.6 fix
      netfilter: nf_conntrack: nf_conntrack_alloc() fixes
      net: sock_copy() fixes

Eugene Teo (1):
      Add '-fno-delete-null-pointer-checks' to gcc CFLAGS

Evgeniy Polyakov (1):
      connector: maintainer/mail update.

Fabio Checconi (2):
      sched: Fix rt_rq->pushable_tasks initialization in init_rt_rq()
      sched: Account for vruntime wrapping

Fenghua Yu (1):
      Fix ia64 compilation IS_ERR and PTE_ERR errors.

Finn Thain (1):
      macsonic, jazzsonic: fix oops on module unload

Frank Roth (1):
      ALSA: ctxfi: Swapped SURROUND-SIDE channels on emu20k2

Frans Pop (1):
      Input: pcspkr - switch driver to dev_pm_ops

Giuseppe Mazzotta (1):
      Input: wistron_btns - recognize Maxdata Pro 7000 notebooks

Graf Yang (3):
      Blackfin: update anomaly lists to match latest sheets/usage
      Blackfin: update handling of anomaly 364 (wrong rev id in BF527-0.1)
      Blackfin: add CPLB entries for Core B on-chip L1 SRAM regions

Guennadi Liakhovetski (2):
      pcm037: add MT9T031 camera support
      ARM: add support for the EET board, based on the i.MX31 pcm037 module

Hao Song (1):
      ALSA: hda - Add quirk for Gateway T6834c laptop

Hartley Sweeten (1):
      [ARM] 5595/1: ep93xx: missing header in dma-m2p.c

Heiko Carstens (1):
      timer stats: fix quick check optimization

Holger Brunck (1):
      UBI: fix bug in image sequence number handling

Huang Weiyi (1):
      mx31: remove duplicated #include

Jaroslav Kysela (2):
      ALSA: hda_intel: more strict alc880_parse_auto_config dig_nid checking
      ALSA: hda_codec: Check for invalid zero connections

Jason Baron (2):
      perf_counter: Add tracepoint support to perf list, perf stat
      perf_counter: Detect debugfs location

Jaswinder Singh Rajput (2):
      ALSA: riptide -  proper handling of pci_register_driver for joystick
      ALSA: OSS sequencer should be initialized after snd_seq_system_client_init

Jeff Layton (1):
      cifs: free nativeFileSystem field before allocating a new one

Jerone Young (1):
      Input: atkbd - add force relese key quirk for Soltech TA12

Jesse Barnes (1):
      fb/intelfb: conflict with DRM_I915 and hide by default

Jie Zhang (1):
      Blackfin: fix miscompilation in lshrdi3

Jiri Slaby (5):
      HID: hiddev, fix lock imbalance
      NET: phy_device, fix lock imbalance
      drm: drm_debugfs, check kmalloc retval
      drm: drm_gem, check kzalloc retval
      tty: nozomi, fix tty refcounting bug

Joe Perches (1):
      netfilter: add netfilter git to MAINTAINERS

Johannes Weiner (1):
      vt: drop bootmem/slab memory distinction

John Dykstra (2):
      tcp: Fix MD5 signature checking on IPv4 mapped sockets
      tcp: Use correct peer adr when copying MD5 keys

Julia Lawall (11):
      i2c: Use resource_size
      drivers/ata: Move a dereference below a NULL test
      drm: Move a dereference below a NULL test
      arch/blackfin: Add kmalloc NULL tests
      ataflop: adjust NULL test
      ALSA: sound/isa: convert nested spin_lock_irqsave to spin_lock
      HID: Move dereferences below a NULL test
      specialix.c: convert nested spin_lock_irqsave to spin_lock
      drivers/net: Move a dereference below a NULL test
      drivers/net: Move a dereference below a NULL test
      drivers/net/mlx4: Adjust constant

Kay Sievers (1):
      vc: create vcs(a) devices for consoles

Ken Kawasaki (1):
      3c589_cs: re-initialize the multicast in the tc589_reset

Kevin Hilman (1):
      i2c-davinci: convert clock usage after clkdev conversion

Krzysztof Halasa (1):
      E100: work around the driver using streaming DMA mapping for RX descriptors.

Li Zefan (1):
      tracing/events: Move TRACE_SYSTEM outside of include guard

Linus Torvalds (3):
      Revert "ppp: Fix throttling bugs"
      fbmon: work around compiler bug in gcc-2.4.2
      Linux 2.6.31-rc4

Linus Walleij (2):
      [ARM] 5594/1: Correct U300 VIC init PM setting
      [ARM] 5608/1: Updated U300 defconfig

Lothar Waßmann (2):
      net/can bugfix: use after free bug in can protocol drivers
      net/can: add module alias to can protocol drivers

Lucas De Marchi (1):
      sched: Reset sched stats on fork()

Lucy Liu (2):
      ixgbe: clear mac address data block in DCB mode
      ixgbe: Remove DPRINTK messages in DCB mode

Marc Zyngier (1):
      backlight: fix pwm_bl.c to notify platform code when suspending

Mark Goodwin (1):
      ahci: add device ID for 82801JI sata controller

Mark McLoughlin (1):
      virtio-pci: correctly unregister root device on error

Matias Zabaljauregui (1):
      lguest: fix journey

Matt Reimer (1):
      pxamci: correct DMA flow control

Maxime Bizon (1):
      ide: fix memory leak when flush command is issued

Michael Buesch (1):
      ide-tape: Don't leak kernel stack information

Michael Gruber (1):
      Input: xpad - don't resend successfully sent outgoing requests

Michael Hennerich (3):
      Blackfin: fix incomplete renaming of the bfin-twi-lcd driver
      Blackfin: fix bugs in GPIO resume code
      Blackfin: drop per-cpu loops_per_jiffy tracking

Mike Frysinger (5):
      Blackfin: drop dead flash_probe call
      Blackfin: restore exception banner when dumping crash info
      Blackfin: handle BF561 Core B memory regions better when SMP=n
      Blackfin: fix early_dma_memcpy() handling of busy channels
      Blackfin: define HARDIRQ_BITS again for now

Mike Galbraith (2):
      perf_counter tools: Fix vmlinux symbol generation breakage
      perf_counter tools: Give perf top inherit option

Mike McCormack (1):
      sky2: Avoid races in sky2_down

Mike Rapoport (1):
      [ARM] pxa: fix ULPI_{DIR,NXT,STP} MFP defines

Moni Shoua (1):
      bonding: clean muticast addresses when device changes type

Nicolas Pitre (1):
      mvsdio: fix handling of partial word at the end of PIO transfer

Patrick McHardy (1):
      netfilter: xt_osf: fix nf_log_packet() arguments

Paul Turner (1):
      sched: Fix bug in SCHED_IDLE interaction with group scheduling

Pavel Roskin (1):
      timer: Avoid reading uninitialized data

Peter Zijlstra (9):
      perf_counter: Fix up P6 PMU details
      perf_counter: Clean up global vs counter enable
      perf_counter: Stop open coding unclone_ctx
      sched_rt: Fix overload bug on rt group scheduling
      softirq: introduce tasklet_hrtimer infrastructure
      perf_counter: Remove unused variables
      perf_counter: Plug more stack leaks
      perf_counter: PERF_SAMPLE_ID and inherited counters
      lockdep: Fix lockdep annotation for pipe_double_lock()

Rakib Mullick (3):
      x86: Fix false positive section mismatch in es7000_32.c
      x86, apic: Fix false positive section mismatch in numaq_32.c
      virtio_blk: mark virtio_blk with __refdata to kill spurious section mismatch

Ralf Baechle (3):
      NET: Fix locking issues in PPP, 6pack, mkiss and strip line disciplines.
      MAINTAINERS entry for STRIP driver
      Update Andreas Koensgen's email address

Robin Getz (6):
      Blackfin: cleanup code a bit with comments and defines
      Blackfin: work around anomaly 05000281
      Blackfin: fix silent crash when no uClinux MTD filesystem exists
      Blackfin: drop duplicate runtime checking of anomaly 05000448
      Blackfin: fix handling of IPEND in interrupt context save
      Blackfin: work around anomaly 05000189

Roel Kluin (2):
      perf_counter tools: Fix index boundary check
      drm/ttm: fix misplaced parentheses

Roland Dreier (1):
      x86: Remove spurious printk level from segfault message

Russell King (1):
      ARM: Realview & Versatile: Fix i2c_board_info definitions

Rusty Russell (1):
      lguest: restrict CPUID to avoid perf counter wrmsr

Ryan Mallon (1):
      [ARM] 5606/1: Fix ep93xx watchdog driver headers

Ryusuke Konishi (1):
      fs/Kconfig: move nilfs2 out

Rémi Denis-Courmont (2):
      Fix error return for setsockopt(SO_TIMESTAMPING)
      USB host CDC Phonet network interface driver

Sascha Hlusiak (1):
      sit: fix regression: do not release skb->dst before xmit

Simon Davie (1):
      Input: atkbd - add forced release keys quirk for FSC Amilo Pi 3525

Simon Farnsworth (1):
      drm/via: Fix vblank IRQ on VIA hardware.

Simon Kagstrom (1):
      [ARM] Kirkwood: Correct header define

Sonic Zhang (2):
      Blackfin: fix wrong CTS inversion
      blackfin: fix wrong CTS inversion

Sonny Rao (1):
      futexes: Fix infinite loop in get_futex_key() on huge page

Stephen Hemminger (1):
      sky2: revert shutdown changes

Steve French (1):
      [CIFS] Distinguish posix opens and mkdirs from legacy mkdirs in stats

Steven Rostedt (1):
      tracing/function-profiler: do not free per cpu variable stat

Steven Whitehouse (1):
      dlm: Fix uninitialised variable warning in lock.c

Takashi Iwai (2):
      ALSA: hda - Fix pin-setup for Sony VAIO with STAC9872 codecs
      ALSA: ca0106 - Fix the max capture buffer size

Tejun Heo (3):
      libata: fix follow-up SRST failure path
      libata: implement and use HORKAGE_NOSETXFER, take#2
      block: fix failfast merge testing in elv_rq_merge_ok()

Thomas Gleixner (6):
      hrtimer: migration: do not check expiry time on current CPU
      hrtimer: Fix migration expiry check
      sched: fix load average accounting vs. cpu hotplug
      sched: fix nr_uninterruptible accounting of frozen tasks really
      clocksource: Prevent NULL pointer dereference
      genirq: Delegate irq affinity setting to the irq thread

Tim Abbott (1):
      vmlinux.lds.h: restructure BSS linker script macros

Tobias Klauser (1):
      skbuff.h: Fix comment for NET_IP_ALIGN

Trond Myklebust (3):
      NFSv4: Fix an Oops in nfs4_free_lock_state
      NFSv4: Fix an NFSv4 mount regression
      NFSv4: Fix a problem whereby a buggy server can oops the kernel

Uwe Kleine-König (2):
      serial: don't add msm_serial's probe function to the driver struct
      macsonic: move probe function to .devinit.text

Vince Weaver (1):
      perf_counter: Add P6 PMU support

Vincent CUISSARD (1):
      cdc-eem: bad crc checking

Wan ZongShun (1):
      Add mac driver for w90p910

Wolfgang Grandegger (3):
      can: sja1000: remove duplicated includes
      can: restart device even if dev_alloc_skb() fails
      can: switch carrier on if device was stopped while in bus-off state

Wolfram Sang (1):
      sched: Documentation/sched-rt-group: Fix style issues & bump version

Xiao Guangrong (1):
      tracing/function: Fix the return value of ftrace_trace_onoff_callback()

Xiaotian Feng (1):
      block: sysfs fix mismatched queue_var_{store,show} in 64bit kernel

Yevgeny Petrilin (2):
      mlx4_core: Handle multi-physical function devices
      mlx4_core: Add new ConnectX EN PCI ID 0x6764

Yinghai Lu (1):
      x86/pci: insert ioapic resource before assigning unassigned resources

Zhaolei (1):
      z2ram: Small cleanup for z2ram.c

fujita (1):
      Add dma_debug_init() for ia64

maximilian attems (1):
      kbuild, deb-pkg: fix install scripts for posix sh

roel kluin (3):
      atlx: duplicate testing of MCAST flag
      atl1c: add missing parentheses
      atl1c: misplaced parenthesis
