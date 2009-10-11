Return-Path: <linux-kernel-owner+w=401wt.eu-S1750938AbZJKV7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750938AbZJKV7c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 17:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750730AbZJKV7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 17:59:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48799 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750703AbZJKV73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 17:59:29 -0400
Date: Sun, 11 Oct 2009 14:58:50 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.32-rc4
Message-ID: <alpine.LFD.2.01.0910111446410.3438@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Another week, another -rc. About 60% of the patch is just a single new 
huge and bloated SCSI FC driver (yeah, I was close to not merging it at 
all), and if you look at all drivers and arch/blackfin, they together 
account for about 97%+ of the diffs since -rc3.

So it's a bit lopsided that way, but perhaps because a lot of the rest is 
really one-liner fixes and cleanups, which just isn't very visible among 
the bulkier changes. And they're pretty random, so I suspect the appended 
shortlog gives the flavor of the thing better than anything I can say.

One thing I will note, though. The next -rc is definitely going to be 
smaller, both because I will definitely refuse to merge drivers-from-hell, 
but perhaps more relevantly because it will be a "short week" release. The 
kernel summit is coming up, and in order to avoid doing the release from 
Tokyo while jetlagged, I'll almost certainly do -rc5 on Thursday.

As usual, please test this for regressions, both new and old. 

		Linus

---
Aaro Koskinen (1):
      panic: Fix panic message visibility by calling bust_spinlocks(0) before dying

Adam Jackson (1):
      drm/i915: Initialize HDMI outputs as HDMI connectors, not DVI.

Ajit Khaparde (4):
      be2net: Fix a bug in preparation of mcc wrb which was causing flash operation to fail
      be2net: Bug Fix while accounting of multicast frames during netdev stats update
      be2net: Fix a typo in be_cmds.h
      be2net: Bug fix to properly update ethtool tx-checksumming after ethtool -K <ifname> tx off

Alan Stern (3):
      USB: serial: don't call release without attach
      USB: ipaq: fix oops when device is plugged in
      USB: storage: When a device returns no sense data, call it a Hardware Error

Alex Deucher (1):
      drm/radeon/kms: add support for "Surround View"

Alexander Duyck (1):
      e1000e: swap max hw supported frame size between 82574 and 82583

Alexey Dobriyan (2):
      Btrfs: constify dentry_operations
      headers: remove sched.h from interrupt.h

Amit Kucheria (1):
      Input: fix rx51 board keymap

Anil Ravindranath (1):
      [SCSI] pmcraid: Changed driver prints to scmd/sdev_printk

Anil Veerabhadrappa (1):
      [SCSI] bnx2i: Fix context mapping issue for architectures with PAGE_SIZE != 4096

Anirban Chakraborty (1):
      [SCSI] qla2xxx: Fix NULL ptr deref bug in fail path during queue create

Anton Blanchard (1):
      futex: Fix typo in FUTEX_WAIT/WAKE_BITSET_PRIVATE definitions

Arjan van de Ven (3):
      perf timechart: Add a power-only mode
      x86: Simplify bound checks in the MTRR code
      x86, timers: Check for pending timers after (device) interrupts

Arnaldo Carvalho de Melo (2):
      perf top: Add poll_idle to the skip list
      perf tools: elf_sym__is_function() should accept "zero" sized functions

Artem Bityutskiy (1):
      OMAP3: PM: introduce a new powerdomain walk helper

Aurelien Jarno (1):
      KVM: fix LAPIC timer period overflow

Avi Kivity (1):
      KVM: Prevent overflow in KVM_GET_SUPPORTED_CPUID

Barry Song (1):
      Blackfin: BF51x: add PTP MMR defines

Bart Van Assche (1):
      IB: Fix typo in udev rule documentation

Bartlomiej Zolnierkiewicz (5):
      pata_atp867x: fix it to not claim MWDMA support
      pata_atp867x: PIO support fixes
      pata_atp867x: add Power Management support
      sis5513: fix PIO setup for ATAPI devices
      Revert "Revert "ide: try to use PIO Mode 0 during probe if possible""

Ben Hutchings (2):
      net: Support inclusion of <linux/socket.h> before <sys/socket.h>
      nfs: Avoid overrun when copying client IP address string

Bernd Schmidt (1):
      ROMFS: fix length used with romfs_dev_strnlen() function

Borislav Petkov (9):
      initcalls: Add early_initcall() for modules
      x86: EDAC: carve out AMD MCE decoding logic
      amd64_edac: fix driver instance lookup table allocation
      amd64_edac: fix DRAM base and limit address extraction
      amd64_edac: fix interleave enable tests
      amd64_edac: fix K8 intlv_sel check
      amd64_edac: fix chip select handling
      amd64_edac: fix DRAM base and limit extraction
      amd64_edac: beef up DRAM error injection

Brian Rogers (1):
      drm/i915: Don't call intel_update_fbc from intel_crtc_cursor_set

Catalin Marinas (1):
      kmemleak: Check for NULL pointer returned by create_object()

Chris Mason (5):
      Btrfs: fix deadlock on async thread startup
      Btrfs: cleanup extent_clear_unlock_delalloc flags
      Btrfs: delay clearing EXTENT_DELALLOC for compressed extents
      Btrfs: fix uninit compiler warning in cow_file_range_nocow
      Btrfs: fix file clone ioctl for bookend extents

Chris Wilson (4):
      drm/i915: Record device minor rather than pointer in TRACE_EVENT
      drm/i915: batch submit seqno off-by-one.
      drm/i915: Enable irq to trace batch buffer completion.
      perf: Propagate term signal to child

Christian Borntraeger (4):
      KVM: s390: fix memsize >= 4G
      [S390] module: fix memory leak in s390 module loader
      [S390] Fix memory leak in /proc/cio_ignore
      [S390] Fix enabled udelay for short delays.

Christof Schmitt (6):
      [SCSI] sg: Free data buffers after calling blk_rq_unmap_user
      [SCSI] zfcp: correctly initialize unchained requests
      [SCSI] zfcp: Fix initial device and cfdc for delayed adapter allocation
      [SCSI] zfcp: Fix oops during shutdown of offline device
      [SCSI] zfcp: Fix lockdep warning when offlining device with offline chpid
      [SCSI] zfcp: Fix hang when offlining device with offline chpid

Christoph Hellwig (5):
      parisc: convert to asm-generic/hardirq.h
      sparc32: convert to asm-generic/hardirq.h
      xfs: implement ->dirty_inode to fix timestamp handling
      xfs: cleanup ->sync_fs
      xfs: stop calling filemap_fdatawait inside ->fsync

Chuck Ebbert (1):
      perf_events: Make ABI definitions available to userspace

Clemens Ladisch (1):
      sound: via82xx: move DXS volume controls to PCM interface

Daniel Walker (1):
      omap: iovmm: Add missing mutex_unlock

Darren Hart (1):
      futex: fix requeue_pi key imbalance

Dave Airlie (6):
      drm/radeon/kms: respect single crtc cards, only create one crtc. (v2)
      drm/fb: add setcmap and fix 8-bit support.
      drm/fb: add more correct 8/16/24/32 bpp fb support.
      drm/ttm: fix refcounting in ttm global code.
      drm/radeon: use list_for_each_entry instead of list_for_each
      drm/radeon/kms: fix vline register for second head.

Dave Chinner (3):
      xfs: fix xfs_quiesce_data
      xfs: mark inodes dirty before issuing I/O
      xfs: make sure xfs_sync_fsdata covers the log

David J. Wilder (1):
      RDMA/addr: Fix resolution of local IPv6 addresses

David Jeffery (1):
      [SCSI] st: fix possible memory use after free after MTSETBLK ioctl

David Miller (1):
      mm, perf_event: Make vmalloc_user() align base kernel virtual address to SHMLBA

David S. Miller (11):
      sparc: Support HW cache events.
      sparc: Support all ultra3 and ultra4 derivatives.
      sparc: Add Niagara2 HW cache event support.
      sparc: Niagara1 perf event support.
      sparc64: Add initial perf event conflict resolution and checks.
      sparc64: Increase vmalloc size to fix percpu regressions.
      sparc64: Add a basic conflict engine in preparation for multi-counter support.
      sparc64: Minor coding style fixups in perf code.
      sparc64: Fix comment typo in perf_event.c
      sparc64: Cache per-cpu %pcr register value in perf code.
      Revert "ide: try to use PIO Mode 0 during probe if possible"

David Vrabel (1):
      mmc: sdio: don't require CISTPL_VERS_1 to contain 4 strings

Dirk Hohndel (1):
      pata_ali: trivial fix of a very frequent spelling mistake

Dmitry Torokhov (2):
      Input: libps2 - fix dependancy on i8042
      Input: i8042 - print debug data when testing AUX IRQ delivery

Don Skidmore (2):
      ixgbe: add support for 82599 Combined Backplane
      ixgbe: add support for 82599 based X520 10G Dual KX4 Mezz card

Eero Nurkkala (1):
      NOHZ: update idle state also when NOHZ is inactive

Elina Pasheva (1):
      USB: serial: sierra driver version change to 1.3.8

Eric Dumazet (3):
      x86: Don't generate cmpxchg8b_emu if CONFIG_X86_CMPXCHG64=y
      pktgen: Fix multiqueue handling
      pktgen: restore nanosec delays

Eric Sandeen (1):
      fix readahead calculations in xfs_dir2_leaf_getdents()

Felix Beck (2):
      [S390] zcrypt: Fix sparse warning.
      [S390] zcrypt: Improve some comments

Frank Mori Hess (2):
      Staging: comedi: ni_pcimio: Added device id for pxi-6225.
      Staging: comedi: pcmcia irq fixes

Frederic Weisbecker (2):
      tracing: Check total refcount before releasing bufs in profile_enable failure
      tracing: Use free_percpu instead of kfree

Gerald Schaefer (1):
      [S390] Add EX_TABLE for addressing exception in usercopy functions.

Gergely Imreh (1):
      USB: usbtmc: fix timeout increase

Graf Yang (1):
      Blackfin: fix missed cache config renames

Greg Kroah-Hartman (4):
      Staging: comedi: serial2002: fix include build issue
      Staging: remove agnx driver
      Staging: remove cowloop driver
      Staging: comedi: fix build on arches that don't want comedi drivers

Greg Ungerer (1):
      m68knommu: fix rename of pt_regs offset defines breakage

H Hartley Sweeten (1):
      Input: rotary_encoder - fix relative axis support

Hannes Reinecke (1):
      [SCSI] Retry ADD_TO_MLQUEUE return value for EH commands

Heiko Carstens (6):
      [S390] Enable kmemleak on s390.
      [S390] Provide arch specific mdelay implementation.
      [S390] compat: fix truncate system call wrapper
      [S390] ftrace: drop nmi protection
      [S390] perf_counter: fix vdso detection
      [S390] 64-bit register support for 31-bit processes

Helge Deller (3):
      parisc: rename parisc's vmalloc_start to parisc_vmalloc_start
      parisc: Fix linker script breakage.
      agp: parisc-agp.c - use correct page_mask function

HighPoint Linux Team (1):
      [SCSI] hptiop: Add RR44xx adapter support

Hiroshi DOYU (1):
      omap: iovmm: Fix incorrect spelling

Hiroshi Shimamoto (1):
      trace: Fix missing assignment in trace_ctxwake_*

Huang Weiyi (1):
      m68knommu: remove duplicated #include

Hugh Dickins (1):
      ksm: more on default values

Ian Abbott (9):
      Staging: comedi: Corrected type of a printk argument in resize_async_buffer().
      Staging: comedi: jr3_pci: Initialize transf variable fully in jr3_pci_poll_subdevice().
      Staging: comedi: cb_pcidio: fix "section mismatch" error
      Staging: comedi: s526: Fix number of channels on DIO subdevice
      Staging: comedi: s526: Get rid of global variable 'cmReg'.
      Staging: comedi: s526: Take account of arch's byte order.
      Staging: comedi: s526: fixes for pulse generator
      Staging: comedi: ni_65xx.c: fix insn_bits shift calculation.
      Staging: comedi: ni_65xx.c: fix output inversion problem.

Ingo Molnar (1):
      x86: EDAC: MCE: Fix MCE decoding callback logic

Izik Eidus (3):
      KVM: MMU: dont hold pagecount reference for mapped sptes pages
      KVM: MMU: add SPTE_HOST_WRITEABLE flag to the shadow ptes
      KVM: add support for change_pte mmu notifiers

James Bottomley (1):
      parisc: add me to Maintainers

Jan Beulich (2):
      x86: Don't leak 64-bit kernel register values to 32-bit processes
      iSCSI/iBFT: use proper address translation

Jason Wessel (1):
      x86: earlyprintk: Fix regression to handle serial,ttySn as 1 arg

Jaswinder Singh Rajput (7):
      parisc: includecheck fix: signal.c
      x86, SLUB: Remove unused CONFIG FAST_CMPXCHG_LOCAL
      Blackfin: includecheck fix: mach-bf548, ezkit.c
      mm: includecheck fix: vmalloc.c
      fs: includecheck fix: proc, kcore.c
      video: includecheck fix: msm, mddi.c
      video: includecheck fix: da8xx-fb.c

Jayamohan Kallickal (3):
      [SCSI] be2iscsi: add 10Gbps iSCSI - BladeEngine 2 driver
      [SCSI] libiscsi: iscsi_session_setup to allow for private space
      [SCSI] be2iscsi: Moving to pci_pools v3

Jean Delvare (1):
      MAINTAINERS: Fix Riku Voipio's address

Jeff Mahoney (3):
      Staging: winbond: implement prepare_multicast and fix API usage
      Staging: iio: Don't build on s390
      Staging: rtl8192e: Add #include <linux/vmalloc.h>

Jerome Glisse (14):
      drm/radeon/kms: Convert RS400/RS480 to new init path & fix legacy VGA (V3)
      drm/radeon/kms: Convert R300 to new init path
      drm/radeon/kms: Convert R100 to new init path (V2)
      drm/radeon/kms: Convert RS690/RS740 to new init path (V2).
      drm/radeon/kms: Convert RS600 to new init path
      drm/radeon/kms: Remove old init path as no hw use it anymore
      drm/radeon/kms: Fix R600 write back buffer
      drm/radeon/kms: Fix R600/RV770 startup path & reset
      drm/radeon/kms: Fix R600/RV770 disable acceleration path
      drm/radeon/kms: R600/RV770 remove dead code and print message for wrong BIOS
      drm/radeon/kms: Fix irq handling on AVIVO hw
      drm/radeon/kms: Fix RS600/RV515/R520/RS690 IRQ
      drm/radeon/kms: Fallback to non AGP when acceleration fails to initialize (v2)
      drm/radeon/kms: Fix AGP support for R600/RV770 family (v2)

Jing Huang (1):
      [SCSI] bfa: Brocade BFA FC SCSI driver

Jiri Slaby (1):
      USB: usblcd, fix memory leak

Joerg Roedel (2):
      KVM: SVM: Fix tsc offset adjustment when running nested
      KVM: SVM: Handle tsc in svm_get_msr/svm_set_msr correctly

Johan Hovold (6):
      USB: ftdi_sio: remove tty->low_latency
      USB: ftdi_sio: remove unused rx_byte counter
      USB: ftdi_sio: clean up read completion handler
      USB: ftdi_sio: re-implement read processing
      USB: pl2303: fix error characters not being reported to ldisc
      USB: digi_acceleport: Fix broken unthrottle.

Johannes Berg (1):
      wext: let get_wireless_stats() sleep

John Stultz (1):
      Blackfin: convert to use arch_gettimeoffset()

John W. Linville (1):
      rndis_host: support ETHTOOL_GPERMADDR

John(Jung-Ik) Lee (1):
      pata_atp867x: clarifications in timings calculations and cable detection

Jon Hunter (1):
      OMAP3: PM: Prevent hang in prcm_interrupt_handler

Jonathan Cameron (1):
      ASoC: wm8940: Fix check on error code form snd_soc_codec_set_cache_io

Joris van Rantwijk (1):
      USB: Fix throttling in generic usbserial driver

Josef Bacik (4):
      Btrfs: fix possible softlockup in the allocator
      Btrfs: release delalloc reservations on extent item insertion
      Btrfs: async delalloc flushing under space pressure
      Btrfs: optimize fsync for the single writer case

Julia Lawall (1):
      parisc: correct use of SHF_ALLOC

Kashyap, Desai (9):
      [SCSI] mpt2sas: Update driver to MPI2 REV K headers.
      [SCSI] mpt2sas: Added mpi2_history.txt for MPI2 headers.
      [SCSI] mpt2sas: Copyright change to 2009.
      [SCSI] mpt2sas: Added SCSIIO, Internal and high priority memory pools to support multiple TM
      [SCSI] mpt2sas: Target Reset will be issued from Interrupt context.
      [SCSI] mpt2sas: Call init_completion on a per request basis.
      [SCSI] mpt2sas: Timeout occurred within the HANDSHAKE logic while waiting on firmware to ACK.
      [SCSI] mpt2sas: Support dev remove when phy status is MPI2_EVENT_SAS_TOPO_PHYSTATUS_VACANT
      [SCSI] mpt2sas: Bump version 02.100.03.00

Keith Mannthey (1):
      amd64_edac: simple fix to allow reporting of CECC errors

Ken Kawasaki (1):
      pcnet_cs: add cis of National Semicondoctor's multifunction pcmcia card

Kevin Hilman (1):
      OMAP3: PM: Enable GPIO module-level wakeups

Krzysztof Helt (1):
      ALSA: opl3: circular locking in the snd_opl3_note_on() and snd_opl3_note_off()

Kuninori Morimoto (3):
      sh: mach-ecovec24: Add TouchScreen support
      sh: mach-ecovec24: modify 1st MTD area to read only
      sh: mach-ecovec24: Document DS2 switch settings.

Kyle McMartin (7):
      parisc: tracehook_report_syscall
      parisc: tracehook_signal_handler
      parisc: add missing TI_TASK macro in syscall.S
      parisc: split syscall_trace into two halves
      parisc: stop using task->ptrace for {single,block}step flags
      parisc: add skeleton syscall.h
      parisc: HAVE_ARCH_TRACEHOOK

Lennart Sorensen (1):
      m68knommu: show KiB rather than pages in "Freeing initrd memory:" message

Linus Torvalds (2):
      x86: Optimize cmpxchg64() at build-time some more
      Linux 2.6.32-rc4

Lubomir Rintel (1):
      sh: Build fix: export __movmem

Luca Tettamanti (2):
      hwmon: (asus_atk0110) Refactor the code
      hwmon: (asus_atk0110) Enable the EC

Magnus Damm (2):
      usb: r8a66597-udc unaligned fifo fix
      sh: enable sleep state LEDs on Ecovec24

Marcelo Tosatti (1):
      KVM: VMX: flush TLB with INVEPT on cpu migration

Marcin Slusarz (1):
      ide: use printk_once

Marin Mitov (1):
      x86, pci: Correct spelling in a comment

Mark Brown (3):
      ASoC: Remove absent SYNC and TDM DAI format options from i.MX SSI
      ASoC: WM8350 capture PGA mutes are inverted
      hwmon: (s3c-hwmon) Disable build for S3C64xx

Markus Trippelsdorf (1):
      ahci: Add ifdef wrapper to ahci_gtf_filter_workaround

Martin K. Petersen (5):
      [SCSI] Deprecate SCSI_PROT_*_CONVERT operations
      [SCSI] sd: Detach DIF from block integrity infrastructure
      [SCSI] Fix protection scsi_data_buffer leak
      [SCSI] sd: Support disks formatted with DIF Type 2
      [SCSI] scsi_debug: Implement support for DIF Type 2

Martin Schwidefsky (2):
      [S390] fix build breakage with CONFIG_AIO=n
      [S390] pm: ignore time spend in suspended state

Matt Carlson (1):
      tg3: Fix phylib locking strategy

Matt Fleming (6):
      sh: Don't enable interrupts in the page fault path
      tracing: Fix infinite recursion in ftrace_update_pid_func()
      sh: Sprinkle __uses_jump_to_uncached
      sh: Plug PMB alloc memory leak
      sh: Try PMB mapping based on physical address, not mapping size
      sh: Don't allocate smaller sized mappings on every iteration

Michael Ernst (1):
      [S390] cio: channel path memory leak

Michael Hennerich (3):
      Input: ad7879 - pass up error codes from probe functions
      Blackfin: convert adv7393 resources to new i2c framework
      Blackfin: convert to GENERIC_HARDIRQS_NO__DO_IRQ

Michael Holzheu (1):
      [S390] hibernate: Use correct place for CPU address in lowcore

Michal Simek (2):
      microblaze: UMS is used only for MMU kernel
      microblaze: Clear sticky FSR register after saving it to func parametr

Mike Frysinger (7):
      Blackfin: asm/irq.h: pull in mach/anomaly.h for anomaly defines
      Blackfin: cplbinfo: drop d_path() hacks
      Blackfin: bf533-ezkit: convert to physmap/jedec_probe
      Blackfin: drop cs_change_per_word setting
      Blackfin: drop all simple-gpio board resources
      USB: musb: make HAVE_CLK support optional
      USB: isp1362: fix build warnings on 64-bit systems

Mimi Zohar (1):
      ima: ecryptfs fix imbalance message

Moger, Babu (1):
      [SCSI] scsi_dh_rdac: Fix for returning correct mode select cmd return info

Mulyadi Santosa (1):
      perf tools: Run generate-cmdlist.sh properly

Neil Horman (1):
      add maintainer for network drop monitor kernel service

Nick Cheng (1):
      [SCSI] mvsas: Support Areca SAS/SATA HBA, ARC-1300/1320

Oliver Neukum (7):
      USB: visor: fix trivial accounting bug in visor driver
      USB: small fix in error case of suspend in generic usbserial code
      USB: serial: fix race between unthrottle and completion handler in opticon
      USB: serial: fix race between unthrottle and completion handler in symbolserial
      USB: serial: fix assumption that throttle/unthrottle cannot sleep
      USB: serial: fix race between unthrottle and completion handler in visor
      USB: serial: no unnecessary GFP_ATOMIC in oti6858

Paul E. McKenney (10):
      rcu: Clean up code based on review feedback from Josh Triplett
      rcu: Clean up code based on review feedback from Josh Triplett, part 2
      rcu: Clean up code to address Ingo's checkpatch feedback
      rcu: Fix rcu_lock_map build failure on CONFIG_PROVE_LOCKING=y
      rcu: Clean up code based on review feedback from Josh Triplett, part 3
      rcu: Clean up code based on review feedback from Josh Triplett, part 4
      rcu: Replace the rcu_barrier enum with pointer to call_rcu*() function
      rcu: Move rcu_barrier() to rcutree
      rcu: Make hot-unplugged CPU relinquish its own RCU callbacks
      rcu: Place root rcu_node structure in separate lockdep class

Paul Menage (1):
      cgroups: update documentation of cgroups tasks and procs files

Paul Mundt (5):
      sh: Handle ioport_map() cases for >= P1SEG addresses.
      sh: Set the default I/O port base to P2SEG.
      sh: magicpanelr2 and dreamcast can use the generic I/O base.
      sh: Disable unaligned kernel access printks by default.
      kmemtrace: Fix up tracer registration

Paul Walmsley (2):
      OMAP3: PM: PRCM interrupt: check MPUGRPSEL register
      OMAP3: PM: PRCM interrupt: only handle selected PRCM interrupts

Pavel Hofman (1):
      ALSA: ICE1712/24 - Change the Multi Track Peak control (level meters) from MIXER to PCM type

Pekka Enberg (1):
      Staging: w35und: Fix ->beacon_int breakage

Peter Magdina (1):
      USB: option: Toshiba G450 device id

Peter Oberparleiter (3):
      [S390] cio: make disconnected handling consistent
      [S390] cio: make not operational handling consistent
      [S390] cio: allow setting boxed devices offline

Peter Ujfalusi (1):
      ASoC: Fix SND_SOC_DAPM_LINE handling

Peter Williams (1):
      sched: Set correct normal_prio and prio values in sched_fork()

Peter Zijlstra (2):
      perf_event: Provide vmalloc() based mmap() backing
      futex: Nullify robust lists after cleanup

Rajendra Nayak (1):
      omap: Lock DPLL5 at boot

Rajiv Andrade (1):
      TPM: fix pcrread

Rakib Mullick (1):
      hwmon: (sht15) Fix spurious section mismatch warning

Ralf Baechle (1):
      IRQ: Change __softirq_pending to unsigned int in asm-generic/hardirq.h.

Randy Dunlap (2):
      [SCSI] scsi_transport_fc: fix missing kernel-doc
      ecryptfs: depends on CRYPTO

Robert Hancock (2):
      ahci: display all AHCI 1.3 HBA capability flags (v2)
      ALSA: ice1724: increase SPDIF and independent stereo buffer sizes

Robert Noland (1):
      drm/r600: avoid assigning vb twice in blit code

Robin Getz (1):
      Blackfin: mass clean up of copyright/licensing info

Roel Kluin (2):
      drm/radeon: Fix setting of bits
      netxen: Fix Unlikely(x) > y

Roland Dreier (1):
      hrtimer: Remove overly verbose "switch to high res mode" message

Ron Mercer (3):
      qlge: Fix some bit definitions for reset register.
      qlge: Fix queueing of firmware handler in ISR.
      qlge: Fix lock/mutex warnings.

Ronnie Furuskog (1):
      USB: option: Patch for Huawei Mobile Broadband E270+ Modem

Samu Onkalo (1):
      lis3lv02d_spi: module unload didn't remove sysfs entry

Samuel Thibault (1):
      x86: Fix csum_ipv6_magic asm memory clobber

Sarah Sharp (5):
      USB: xhci: Stop debugging polling loop when HC dies.
      USB: xhci: Handle canceled URBs when HC dies.
      USB: xhci: Don't wait for a disable slot cmd when HC dies.
      USB: xhci: Fix dropping endpoints from the xHC schedule.
      USB: ehci: Fix isoc scheduling boundary checking.

Sebastian Frei (1):
      Input: wistron_btns - add DMI entry for Medion WIM2030 laptop

Sebastian Ott (1):
      [S390] 3270 console build fix

Serge E. Hallyn (1):
      Staging: p9auth: a few fixes

Sergey Pinaev (1):
      USB: storage: iRiver P7 UNUSUAL_DEV patch

Sergio Aguirre (1):
      omapfb: Condition mutex acquisition

Stefan Haberland (1):
      [S390] dasd: fix race condition in resume code

Stephen Boyd (1):
      connector: Fix incompatible pointer type warning

Stephen Hemminger (1):
      ipv4: arp_notify address list bug

Stephen Rothwell (1):
      sparc: using HZ needs an include of linux/param.h

Steve Wise (2):
      RDMA/iwcm: Don't call provider reject func with irqs disabled
      RDMA/cxgb3: Handle NULL inetdev pointer in iwch_query_port()

Steven Rostedt (3):
      tracing: fix transposed numbers of lock_depth and preempt_count
      ftrace: check for failure for all conversions
      tracing: user local buffer variable for trace branch tracer

Takashi Iwai (4):
      ALSA: hda - Fix invalid initializations for ALC861 auto mode
      ALSA: hda - Add a workaround for ASUS A7K
      ALSA: hda - Don't pick up invalid HP pins in alc_subsystem_id()
      ALSA: hda - Fix yet another auto-mic bug in ALC268

Tejun Heo (7):
      [SCSI] sr: consider the last written sector when determining media size
      ahci: disable 64bit DMA by default on SB600s
      libata: cosmetic updates
      libata: implement more acpi filtering options
      libata: make gtf_filter per-dev
      ahci: filter FPDMA non-zero offset enable for Aspire 3810T
      libata: fix incorrect link online check during probe

Tetsuo Handa (1):
      kmemleak: Use GFP_ATOMIC for early_alloc().

Thomas Chou (6):
      ethoc: fix typo to compute number of tx descriptors
      ethoc: fix buffer address mapping
      ethoc: align received packet to make IP header at word boundary
      ethoc: use system memory as buffer
      ethoc: limit the number of buffers to 128
      Blackfin: fix framebuffer mmap bug for nommu

Thomas Gleixner (2):
      futex: Fix locking imbalance
      futex: Move exit_pi_state() call to release_mm()

Thomas Gruber (1):
      Input: xpad - add BigBen Interactive XBOX 360 Controller

Tilman Schmidt (12):
      Documentation: expand isdn/INTERFACE.CAPI document
      isdn: accept CAPI Informational Info values as success
      isdn: avoid races in capidrv
      isdn: make capidrv module parameter "debugmode" writeable
      gigaset: fix reject/hangup handling
      gigaset: linearize skb
      gigaset: handle isoc frame errors more gracefully
      gigaset: announce if built with debugging
      gigaset: fix device ERROR response handling
      gigaset: improve error recovery
      gigaset: correct debugging output selection
      gigaset: add kerneldoc comments

Tim Abbott (1):
      parisc: Make THREAD_SIZE available to assembly files and linker scripts.

Tobias Klauser (1):
      USB: gadget: imx_udc: Use resource size

Tom Zanussi (3):
      perf trace: Remove unused code in builtin-trace.c
      perf trace: Update eval_flag() flags array to match interrupt.h
      tracing/syscalls: Use long for syscall ret format and field definitions

Tommi Rantala (2):
      omapfb: Blizzard: fix pointer to be const
      omapfb: Blizzard: constify register address tables

Tony Lindgren (1):
      omap: Fix incorrect 730 vs 850 detection

Trond Myklebust (5):
      NFS: Fix a default mount regression...
      NFS: Fix port and mountport display in /proc/self/mountinfo
      NFS: Fix port initialisation in nfs_remount()
      NFSv4: Fix the referral mount code
      NFSv4: Kill nfs4_renewd_prepare_shutdown()

Tyler Hicks (1):
      eCryptfs: Remove Kconfig NET dependency and select MD5

Uwe Kleine-König (1):
      Input: sparkspkr - move remove() functions to .devexit.text

Valentine Barshak (1):
      pasemi_mac: ethtool get settings fix

Vikram Pandita (1):
      OMAP3: PM: USBHOST: clear wakeup events on both hosts

Wu Fengguang (8):
      pagemap: export KPF_HWPOISON
      pagemap: document KPF_KSM and show it in page-types
      page-types: add GPL note
      page-types: introduce checked_open()
      page-types: make standalone pagemap/kpageflags read routines
      page-types: make voffset local variables
      page-types: introduce kpageflags_flags()
      page-types: add hwpoison/unpoison feature

Xiao Guangrong (2):
      perf_event: Fix event group handling in __perf_event_sched_*()
      perf_event: Clean up perf_event_init_task()

Yan, Zheng (2):
      Btrfs: remove negative dentry when deleting subvolumne
      Btrfs: optimize back reference update during btrfs_drop_snapshot

Yevgeny Petrilin (1):
      mlx4_core: Add 40GigE device ID

Yinghai Lu (1):
      pci: increase alignment to make more space for hidden code

Zhao Yakui (2):
      drm/i915: Multiply the refresh by 1000 in TV mode validatiion
      drm: Delete the DRM_DEBUG_KMS in drm_mode_cursor_ioctl

Zhenwen Xu (1):
      tracing: fix warning on kernel/trace/trace_branch.c andtrace_hw_branches.c

jolsa@redhat.com (1):
      tracing: correct module boundaries for ftrace_release

roel kluin (1):
      au1000_eth: Duplicate test of RX_OVERLEN bit in update_rx_stats()

ye janboe (1):
      omap: SRAM: flush the right address after memcpy in omap_sram_push

Éric Piel (1):
      USB: cp210x: Add support for the DW700 UART
