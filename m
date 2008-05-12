Return-Path: <linux-kernel-owner+w=401wt.eu-S1753888AbYELO4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888AbYELO4i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 10:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752174AbYELO42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 10:56:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58477 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752098AbYELO4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 10:56:24 -0400
Date: Mon, 12 May 2008 07:55:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.26-rc2
Message-ID: <alpine.LFD.1.10.0805120731480.3188@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


About 45% architecture updates (counting the include files too), about 30% 
drivers, and about 25% odds-and-ends. The odds-and-ends are mainly 
Documentation, filesystems (mostly cifs) and core kernel (scheduler 
updates etc).

The dirstat and shortlog is appended, because while not exactly tiny it 
should still fit easily in the lkml size limits. And if you read the 
shortlog and get the feeling that most of it is pretty boring small 
details, you'd be right. There is little exciting there.

A fairly small part of it, but quite possibly the most noticeable one, is 
how the semaphore changes impacted the BKL (the old "big kernel lock" that 
is still used for some legacy code, for you non-core people out there), 
which in the past had different versions ("regular", "preemptable").

A few months ago we dropped the regular BKL version, but in 2.6.25-rc1 we 
then had performance (and then correctness) issues with the interaction 
between the semaphore implementation and the preemptable BKL, so we're 
back to the old regular version for now.

Let's see if anybody notices. It looks likely that some latency issues 
have regressed since (cond_resched()), and we'll need to see what we can 
do about that whole thing.

			Linus

---
   3.2% Documentation/scheduler/
   5.1% Documentation/
   3.4% arch/arm/
   6.1% arch/blackfin/mach-common/
   7.2% arch/blackfin/
   3.3% arch/powerpc/
   7.5% arch/sh/boards/mpc1211/
   7.9% arch/sh/boards/
   3.0% arch/sh/kernel/
  11.2% arch/sh/
   3.7% arch/x86/
  35.3% arch/
   8.4% drivers/ata/
   3.3% drivers/infiniband/hw/ipath/
   5.0% drivers/infiniband/hw/
   5.2% drivers/infiniband/
   8.3% drivers/net/
   3.1% drivers/s390/cio/
   3.2% drivers/s390/
  30.3% drivers/
   4.6% fs/cifs/
   5.8% fs/
   8.1% include/asm-sh/mpc1211/
   8.4% include/asm-sh/
  12.2% include/
   7.6% kernel/


Adrian Bunk (10):
      udf: fs/udf/partition.c:udf_get_pblock() mustn't be inline
      x86: make start_secondary() static
      x86: make additional_cpus static
      x86: video/fbdev.c: add MODULE_LICENSE
      kconfig-language.txt: remove bogus hint
      fix asm-alpha/types.h breakage
      fix asm-mips/types.h syntax error
      sparc64: remove online_page()
      iwlwifi: make IWLWIFI a tristate
      sh: remove the broken SH_MPC1211 support

Al Viro (1):
      fix SMP ordering hole in fcntl_setlk()

Alan Cox (2):
      pata_atiixp: Don't disable
      cxgb3: Use CAP_SYS_RAWIO for firmware

Alek Du (1):
      libata: Add Intel SCH PATA driver

Alexey Dobriyan (1):
      [ARM] lubbock: fix compilation

Allan Stephens (1):
      tipc: Increase buffer header to support worst-case device

Andrea Arcangeli (1):
      KVM: avoid fx_init() schedule in atomic

Andres Salomon (2):
      x86: GEODE: cache results from geode_has_vsa2() and uninline
      x86: geode: define geode_has_vsa2() even if CONFIG_MGEODE_LX is not set

Andrew Morton (3):
      sched: add debug checks to idle functions
      sx.c: fix printk warnings on sparc32
      drivers/scsi/dpt_i2o.c: fix build on alpha

Andy Fleming (3):
      gianfar: Fix a locking bug in gianfar's sysfs code
      phylib: Fix some sparse warnings
      ucc_geth: Fix a bunch of sparse warnings

Anton Vorontsov (2):
      uli526x: initialize the hardware prior to requesting interrupts
      uli526x: fix endianness issues in the setup frame

Auke Kok (1):
      [MAINTAINERS] New maintainer for Intel ethernet adapters

Avi Kivity (2):
      KVM: x86 emulator: disable writeback on lmsw
      KVM: MMU: Allow more than PAGES_PER_HPAGE write protections per large page

Bartlomiej Zolnierkiewicz (1):
      ide: IDE_HFLAG_SERIALIZE_DMA bugfix

Ben (1):
      x86: remove dell reboot dmi quirk board name match

Ben Hutchings (1):
      net: Added ASSERT_RTNL() to dev_open() and dev_close().

Benjamin Herrenschmidt (5):
      slub: fix atomic usage in any_slab_objects()
      [POWERPC] Make default cputable entries reflect selected CPU family
      [POWERPC] Fix bogus paca->_current initialization
      [POWERPC] Document when printk is useable
      [POWERPC] Initialize lockdep earlier

Bernd Schmidt (5):
      [Blackfin] arch: fix bug -  breaking the atomic sections code.
      [Blackfin] arch: In the double fault handler, set up the PT_RETI slot
      [Blackfin] arch: Delete unused (copied from m68k) entries in asm-offsets.c.
      [Blackfin] arch: disable single stepping when delivering a signal
      [Blackfin] arch: fix gdb testing regression

Bernhard Beck (1):
      usb-serial: Add ThinkOptics WavIT

Bruce Allan (1):
      e1000e: Add support for BM PHYs on ICH9

Bruce Robson (1):
      [netdrvr] eexpress: IPv6 fails - multicast problems

Bryan Wu (2):
      task_nommu: fix compile failing bug because of spilt file.h
      [Blackfin] arch: add twi_lcd and twi_keypad i2c board info to bf527-ezkit

Chris Wright (1):
      dccp: return -EINVAL on invalid feature length

Christian Borntraeger (1):
      [S390] s390-kvm: leave sie context on work. Removes preemption requirement

Christian Ehrhardt (2):
      KVM: ppc: deliver INTERRUPT_FP_UNAVAIL to the guest
      [POWERPC] 4xx: Fix PCI mem in sequoia DTS

Christoph Hellwig (6):
      [POWERPC] spufs: spu_create should send inotify IM_CREATE event
      kill ->put_inode
      [POWERPC] spufs: don't requeue victim contex in find_victim if it's not in spu_run
      [POWERPC] spufs: lockdep annotations for spufs_dir_close
      cris: kill sys_pipe implementation
      m32r: use generic sys_pipe

Cyrill Gorcunov (2):
      x86: vdso ELF handling - use SELFMAG instead of numeric constant
      x86: relocs ELF handling - use SELFMAG instead of numeric constant

Daniel Walker (3):
      [POWERPC] macintosh: therm_pm72: driver_lock semaphore to mutex
      [POWERPC] macintosh: windfarm_smu_sat: semaphore to mutex
      [POWERPC] macintosh: ADB driver: adb_handler_sem semaphore to mutex

Dave Olson (2):
      IB/ipath: Fix bug that can leave sends disabled after freeze recovery
      IB/ipath: Need to always request and handle PIO avail interrupts

David Brownell (1):
      i2c: Improve smbus-protocol documentation

David Howells (1):
      MN10300: Make cpu_relax() invoke barrier()

David Milburn (1):
      i2c-piix4: Increase the intitial delay for the ServerWorks CSB5

David S. Miller (15):
      Revert "[SPARC64]: Wrap SMP IPIs with irq_enter()/irq_exit()."
      lapbeth: Release ->ethdev when unregistering device.
      niu: Fix probing regression for maramba on-board chips.
      sbus: Fix bpp driver build.
      sparc64: use compat_sys_utimes instead of home-grown local copy.
      Revert "atm: Do not free already unregistered net device."
      usb: Sparc build fix, make USB_ISP1760_OF depend on PPC_OF
      sparc64: Fix initrd regression.
      sparc: Fix mmap VA span checking.
      sparc: Fix fork/clone/vfork system call restart.
      sparc: Fix SA_ONSTACK signal handling.
      sit: Add missing kfree_skb() on pskb_may_pull() failure.
      sparc32: Don't twiddle PT_DTRACE in exec.
      sparc: Fix ptrace() detach.
      sparc: Fix debugger syscall restart interactions.

David Simner (1):
      sched: fix sched_info_switch not being called according to documentation

Davide Rizzo (3):
      [ALSA] soc - fix s3c2410 PCM breakage
      [ALSA] soc - fix S3C2410 i2s programming error
      [ARM] 4882/2: Correction for S3C2410 clkout generation

Denis V. Lunev (1):
      [POWERPC] Assign PDE->data before gluing PDE into /proc tree

Dmitry Baryshkov (1):
      [ARM] 5033/1: Unbreak corgi_ssp by registering ssp drivers earlier.

Don Fry (1):
      pcnet32: delete non NAPI code from driver.

Eli Cohen (1):
      IB/ipoib: Fix transmit queue stalling forever

Emil Medve (1):
      [POWERPC] devres: Add devm_ioremap_prot()

Eric Sesterhenn (1):
      Removal of FUTEX_FD

Finn Thain (1):
      m68k: remove old mac_esp cruft

Geert Uytterhoeven (4):
      m68k: Fix falconide `data_adr' typo
      m68k: serial167 missing return value in cy_put_char()
      m68k: drivers/input/serio/hp_sdc.c needs <linux/semaphore.h>
      CONFIG_SCSI_MAC_ESP needs CONFIG_SCSI_SPI_ATTRS

Glauber Costa (1):
      x86: KVM geust: make setup_secondary_clock definition dependent on local apic

Grace Pan (1):
      [Blackfin] arch: Set spi flash partition on bf527 as like bf548.

Gregory Haskins (2):
      sched: fix RT task-wakeup logic
      sched: fix SCHED_FAIR wake-idle logic error

Guennadi Liakhovetski (1):
      [ARM] 5028/1: pxafb: fix broken "backward compatibility way" in framebuffer

Gunnar Larisch (1):
      3c980-TX needs EXTRA_PREAMBLE

Harvey Harrison (5):
      kgdb: trivial sparse fixes in kgdb test-suite
      kgdb: fix signedness mixmatches, add statics, add declaration to header
      sched: make rt_sched_class, idle_sched_class static
      sched: add statics, don't return void expressions
      misc: fix integer as NULL pointer warnings

Heiko Carstens (4):
      clocksource: Fix permissions for available_clocksource
      clocksource: allow read access to available/current_clocksource
      sched: fix missing locking in sched_domains code
      [S390] tty3270: fix put_char fail/success conversion.

Helge Wagner (1):
      x86: restrict keyboard io ports reservation to make ipmi driver work

Herbert Xu (1):
      [CRYPTO] hmac: Avoid calling virt_to_page on key

Hollis Blanchard (1):
      KVM: ppc: Handle guest idle by emulating MSR[WE] writes

Huang Weiyi (3):
      fs/proc/task_mmu.c: remove duplicated include files
      Remove duplicated include in net/sunrpc/svc.c
      [POWERPC] Remove duplicate #include

Hugh Dickins (1):
      x86: fix PAE pmd_bad bootup warning

Igor Mammedov (2):
      [CIFS] fixed compatibility issue with samba refferal request
      [CIFS] Fixed build warning in is_ip

Ilpo Järvinen (1):
      tcp FRTO: SACK variant is errorneously used with NewReno

Ingo Molnar (12):
      uml: fix gcc problem
      x86: es7000 build fix
      sysfs: build fix
      irda: fix !PNP support in drivers/net/irda/nsc-ircc.c
      irda: fix !PNP support for drivers/net/irda/smsc-ircc2.c
      sched: remove old sched doc
      sched: make clock sync tunable by architecture code
      sched: fix cpu clock
      sched, x86: add HAVE_UNSTABLE_SCHED_CLOCK
      semaphore: fix
      Fix drivers/media build for modular builds
      x86: rdc: leds build/config fix

Izik Eidus (1):
      KVM: x86: task switch: fix wrong bit setting for the busy flag

J.H.M. Dassen (Ray) (1):
      net/ipv4: correct RFC 1122 section reference in comment

Jacek Luczak (1):
      [ALSA] Revert migration to alc_set_pin_output() in alc861_auto_set_output_and_unmute()

Jamal Hadi Salim (2):
      net_cls_act: Make act_simple use of netlink policy.
      net_cls_act: act_simple dont ignore realloc code

Jan Engelhardt (1):
      kgdb: kconfig fix xconfig/menuconfig element

Jan Kara (1):
      udf: Fix memory corruption when fs mounted with noadinicb option

Jan Kiszka (1):
      KVM: Avoid spurious execeptions after setting registers

Jarek Poplawski (1):
      sch_htb: remove from event queue in htb_parent_to_leaf()

Jason Wessel (1):
      kgdb: 1000 loops for the single step test in kgdbts

Jay Vosburgh (2):
      bonding: fix error unwind in bonding_store_bonds
      bonding: fix enslavement error unwinds

Jean Delvare (5):
      modpost: i2c aliases need no trailing wildcard
      i2c-piix4: Blacklist two mainboards
      i2c: Improve the functionality documentation
      i2c: Match dummy devices by type
      i2c: Convert some more new-style drivers to use module aliasing

Jeff Garzik (2):
      fix warning in drivers/net/appletalk/cops.c
      [libata] revert new check-ready Status register logic

Jens Axboe (9):
      block: sysfs store function needs to grab queue_lock and use queue_flag_*()
      block: adjust tagging function queue bit locking
      cfq-iosched: fix RCU race in the cfq io_context destructor handling
      block: get rid of likely/unlikely predictions in merge logic
      block: optimize generic_unplug_device()
      cfq-iosched: make io priorities inherit CPU scheduling class as well as nice
      block: avoid duplicate calls to get_part() in disk stat code
      block: use unitialized_var() in bio_alloc_bioset()
      Revert "relay: fix splice problem"

Jeremy Kerr (6):
      [POWERPC] cell: Fix lost interrupts due to fasteoi handler
      [POWERPC] spufs: don't touch suspend bits when purging DMA queue
      [POWERPC] spufs: fix save of mfc_cntl register
      [POWERPC] spufs: fix post-stopped update of MFC_CNTL register
      [POWERPC] spufs: update master runcntl with context lock held
      [POWERPC] spufs: don't acquire state_mutex interruptible while performing callback

Joakim Tjernlund (1):
      ucc_geth: Don't use RX clock as TX clock.

Jochen Friedrich (1):
      [POWERPC] Fix of_i2c include for module compilation

Johann Felix Soden (1):
      [ALSA] pcsp: Fix build with CONFIG_PM=n

Johannes Berg (1):
      net: Fix useless comment reference loop.

John Gregor (1):
      IB/ipath: Fix SDMA error recovery in absence of link status change

Jon Smirl (1):
      i2c-mpc: Compare to NO_IRQ instead of zero

Kok, Auke (1):
      e1000e: don't return half-read eeprom on error

Lennert Buytenhek (8):
      mv643xx_eth: get rid of static variables, allow multiple instances
      mv643xx_eth: mbus decode window support
      mv643xx_eth: configurable t_clk
      mv643xx_eth: shorten shared platform driver name
      mv643xx_eth: inter-mv643xx SMI port sharing
      [ARM] Orion: use mv643xx_eth driver mbus window handling
      [ARM] Orion: pass proper t_clk into mv643xx_eth
      [ARM] Orion: clean up addr-map.c after window setting code purge

Linus Torvalds (10):
      Make forced module loading optional
      VFS: fix unused variable warning
      Revert "uml: fix gcc problem"
      Revert "PCI: remove default PCI expansion ROM memory allocation"
      Move ACCESS_ONCE() to <linux/compiler.h>
      Make <asm-x86/spinlock.h> use ACCESS_ONCE()
      Revert "semaphore: fix"
      BKL: revert back to the old spinlock implementation
      Add new 'cond_resched_bkl()' helper function
      Linux 2.6.26-rc2

Linus Walleij (1):
      [ARM] 5024/1: Fix some minor clk issues in the MMCI PL18x driver

Luke Browning (4):
      [POWERPC] spufs: set SPU_CONTEXT_SWITCH_PENDING before synchronising SPU irqs
      [POWERPC] spufs: try to route SPU interrupts to local node
      [POWERPC] spufs: fix concurrent delivery of class 0 & 1 exceptions
      [POWERPC] spufs: handle faults while the context switch pending flag is set

Maciej W. Rozycki (2):
      i2c-sibyte: Correct a comment about frequency
      i2c-sibyte: Mark i2c_sibyte_add_bus() as static

Magnus Damm (16):
      sh: update smc91x platform data for MigoR
      sh: update smc91x platform data for se7722
      sh: fix sh7705 interrupt vector typo
      sh: add kernel bss resource
      sh: add memory resources to /proc/iomem
      sh: use sci_out() for early printk
      sh: drain and wait for early printk
      sh: reset hardware from early printk
      sh-sci: improve sh7722 support
      sh-sci: sh7722 lacks scsptr registers
      sh-sci: avoid writing to nonexistent registers
      sh: unify external irq pin code for sh3
      sh: add interrupt ack code to sh3
      sh: clean up sh7710 and sh7720 intc tables
      sh: no high level trigger on some sh3 cpus
      sh: intc register modify fix

Marcelo Tosatti (1):
      KVM: PIT: support mode 4

Marcin Slusarz (1):
      xfrm: convert empty xfrm_audit_* macros to functions

Mark Brown (1):
      [ALSA] soc - at91-pcm - Fix line wrapping

Mark Lord (13):
      sata_mv more cosmetic changes
      sata_mv pci features
      sata_mv wait for empty+idle
      sata_mv new mv_qc_defer method
      sata_mv errata workaround for sata25 part 1
      sata_mv rearrange mv_config_fbs
      sata_mv NCQ and SError fixes for mv_err_intr
      sata_mv fix mv_host_intr bug for hc_irq_cause
      sata_mv new mv_port_intr function
      libata: export ata_eh_analyze_ncq_error
      sata_mv delayed eh handling
      sata_mv NCQ-EH for FIS-based switching
      sata_mv use hweight16() for bit counting (V2)

Martin Schwidefsky (3):
      [S390] s390: Optimize user and work TIF check
      [S390] s390mach compile warning
      [S390] guest page hinting light

Mathieu Desnoyers (1):
      sh: remove -traditional.

Mattia Dongili (1):
      usb/asix: add Buffalo LUA-U2-GT 10/100/1000

Meihui Fan (1):
      [Blackfin] arch: fix bug - Remove module will not free L1 memory used

Miao Xie (1):
      sched: fair-group: fix a Div0 error of the fair group scheduler

Michael Albaugh (2):
      IB/ipath: Only warn about prototype chip during init
      IB/ipath: Fix count of packets received by kernel

Michael Ernst (2):
      [S390] cio: Remove cio_msg kernel parameter.
      [S390] cio: Fix parsing mechanism for blacklisted devices.

Michael Hennerich (7):
      [Blackfin] arch: Cleanup Kconfig, fix comment and make sure we exclude CCLK=SCLK for some configurations
      [Blackfin] arch: Equalize include files: Add VR_CTL masks
      [Blackfin] arch: Functional power management support: Add CPU and platform voltage scaling support
      [Blackfin] arch: Add physmap partition for BF527-EZkit
      [Blackfin] arch: Fix BUG - spi flash on bf527 ezkit would fail at mount
      [Blackfin] arch: add EBIU supporting for BF54x EZKIT SMSC LAN911x/LAN921x families embedded ethernet driver
      [Blackfin] arch: remove useless IRQ_SW_INT defines

Mike Frysinger (5):
      [Blackfin] arch: fix wrong header name in comment
      [Blackfin] arch: protect linux/usb/isp1362.h include until the driver gets mainlined
      [Blackfin] arch: protect linux/usb/musb.h include until the driver gets mainlined
      Blackfin Serial Driver: macro away the IER differences between processors
      Blackfin Serial Driver: abstract away DLAB differences into header

Mike Galbraith (2):
      sched: fix debugging
      sched: fix weight calculations

Miklos Szeredi (1):
      vfs: splice remove_suid() cleanup

Nate Case (1):
      [POWERPC] Remove leftover printk in isa-bridge.c

OGAWA Hirofumi (1):
      Fix bogus warning in sysdev_driver_register()

Oliver Hartkopp (2):
      hrtimer: remove duplicate helper function
      can: Fix can_send() handling on dev_queue_xmit() failures

Oren Duer (1):
      mlx4_core: Support creation of FMRs with pages smaller than 4K

Parag Warudkar (1):
      sched: default to n for GROUP_SCHED and FAIR_GROUP_SCHED

Patrick McHardy (3):
      macvlan: Fix memleak on device removal/crash on module removal
      netfilter: nf_conntrack_sip: restrict RTP expect flushing on error to last request
      netfilter: Kconfig: default DCCP/SCTP conntrack support to the protocol config values

Patrik Sevallius (1):
      [ALSA] soc at91 minor bug fixes

Paul Menage (1):
      Fix cpuset sched_relax_domain_level control file

Paul Mundt (17):
      sh: sh-bios depends on SUPERH32.
      sh64: fixups for xtime_lock seqlock conversion.
      sh64: Fixup the nommu build.
      sh64: Fix up compile warning in event tracer.
      sh: kexec and kdump depend on SUPERH32.
      sh64: Setup I/D-TLB defaults in SH-5 probe path.
      mtd: solutionengine flash map depends on solution engine mach group.
      sh64: Some symbol exports to make the allmodconfig happier.
      sh64: export onchip_remap/unmap() too.
      sh: Enable use of the clk fwk on SH-5.
      input: i8042: sh64 IRQ definitions depend on cayman board.
      sh: intc_sh5 depends on cayman board for IRQ priority table.
      sh: rts7751r2d: Kill off unneeded ifdefs.
      sh: r7780rp: Kill off unneded ifdefs for irq setup.
      rtc: rtc-sh: Fixup for 64-bit resources.
      sh: Stub in cpu_to_node() and friends for NUMA build.
      sh: update smc91x platform data for se7206.

Paulius Zaleckas (1):
      3c59x: use netstats in net_device structure

Pavel Emelyanov (8):
      bridge: Net device leak in br_add_bridge().
      bridge: Consolidate error paths in br_add_bridge().
      mac80211: Do not free net device after it is unregistered.
      atm: Do not free already unregistered net device.
      atm: Bad locking on br2684_devs modifications.
      bonding: Do not call free_netdev for already registered device.
      bonding: Deadlock between bonding_store_bonds and bond_destroy_sysfs.
      netns: Fix arbitrary net_device-s corruptions on net_ns stop.

Peter Zijlstra (4):
      sched: fix normalized sleeper
      sched: optimize calc_delta_mine()
      sched: fix hrtick_start_fair and CPU-Hotplug
      sched: add optional support for CONFIG_HAVE_UNSTABLE_SCHED_CLOCK

Ralph Campbell (2):
      IB/ipath: Only increment SSN if WQE is put on send queue
      IB/ipath: Return the correct opcode for RDMA WRITE with immediate

Randy Dunlap (2):
      x86: fix setup printk format warning
      docbook: fix bio missing parameter

Rasmus Rohde (1):
      udf: Make udf exportable

Robert Jarzmik (3):
      [ARM] 5027/1: Fixed random memory corruption on pxa suspend cycle.
      [ARM] 5031/1: Indentation correction in cpu-pxa.c.
      [ARM] 5032/1: Added cpufreq support for pxa27x CPU

Robert Reif (3):
      sparc: tcx.c remove unnecessary function
      sparc video: make blank use proper constant
      sparc video: remove open boot prom code

Roel Kluin (1):
      SH: catch negative denormal_subf1() retval in denormal_add()

Roland Dreier (3):
      IB/mlx4: Fix off-by-one errors in calls to mlx4_ib_free_cq_buf()
      RDMA/cxgb3: Don't add PBL memory to gen_pool in chunks
      RDMA/cxgb3: Fix severe limit on userspace memory registration size

Roland McGrath (1):
      [S390] compat ptrace cleanup

Roman Zippel (2):
      m68k: Handle 68040 bus faults
      fix reservation discarding in affs

Russell King (1):
      [ARM] pxa: Fix RCSR handling

Rusty Russell (4):
      x86: fix up bootparam.h for userspace inclusion
      module: put modversions in vermagic
      module: be more picky about allowing missing module versions
      module: don't ignore vermagic string if module doesn't have modversions

Ryan Mallon (1):
      [ARM] 5023/1: Fix broken gpio interrupts on ep93xx

Sam Ravnborg (3):
      x86: fix section mismatch in pci_scan_bus
      kbuild, suspend, x86: fix rebuild of wakeup.bin
      kconfig: fix MAC OS X warnings in menuconfig

Samuel Thibault (2):
      Kconfig: improved help for CONFIG_ACCESSIBILITY
      vt: fix canonical input in UTF-8 mode

Satoru SATOH (2):
      ip: Make use of the inline function dst_metric_locked()
      ip: Use inline function dst_metric() instead of direct access to dst->metric[]

Scott Wood (1):
      fs_enet: Fix a memory leak in fs_enet_mdio_probe

Sheng Yang (8):
      KVM: VMX: EPT Feature Detection
      KVM: MMU: Move some definitions to a header file
      KVM: Add kvm_x86_ops get_tdp_level()
      KVM: MMU: Add EPT support
      KVM: MMU: Remove #ifdef CONFIG_X86_64 to support 4 level EPT
      KVM: Export necessary function for EPT
      KVM: VMX: Prepare an identity page table for EPT in real mode
      KVM: VMX: Enable EPT feature for KVM

Simon Holm Thøgersen (1):
      x86: revert commit 709f744 ("x86: bitops asm constraint fixes")

Stas Sergeev (1):
      pcspkr: fix dependancies

Stefan Roese (2):
      [POWERPC] 4xx: Fix problem with new TLB storage attibute fields on 440x6 core
      [POWERPC] 4xx: Add endpoint support to 4xx PCIe driver

Stefan Roscher (2):
      IB/ehca: Fix function return types
      IB/ehca: Wait for async events to finish before destroying QP

Stephen Rothwell (1):
      dev_name introduction fall out fix

Steve French (10):
      [CIFS] Update cifs version number
      [CIFS] Fix spelling mistake
      [CIFS] Adds to dns_resolver checking if the server name is an IP addr and skipping upcall in this case.
      [CIFS] Fix statfs formatting
      [CIFS] convert usage of implicit booleans to bool
      [CIFS] Remove duplicate call to mode_to_acl
      [CIFS] fix typo
      [CIFS] Remove over-indented code in find_unc().
      [CIFS] cleanup cifsd completion
      [CIFS] fix build warning

Steve Glendinning (1):
      sh: Fix DMAC base address for SH7709S

Steve Wise (3):
      RDMA/cxgb3: QP flush fixes
      RDMA/cxgb3: Silently ignore close reply after abort.
      RDMA/cxgb3: Bump up the MPA connection setup timeout.

Steven Rostedt (4):
      fix irq flags in mac80211 code
      fix irq flags in saa7134
      fix irq flags in rtc-ds1511
      fix irq flags for iuu_phoenix.c

Suresh Siddha (1):
      x86: fix fpu restore from sig return

Takashi Iwai (3):
      [ALSA] hda - Support IDT 92HD206 codec
      [ALSA] fm801 - Fix kconfig dependency mess of fm801-tea575x
      [ALSA] ac97 - Add a workaround for broken quirk for VT1617A codec

Tejun Heo (12):
      libata: improve post-reset device ready test
      ata_piix: verify SIDPR access before enabling it
      sata_inic162x: misc clean ups
      sata_inic162x: add / update constants
      sata_inic162x: update TF read handling
      sata_inic162x: use IDMA for ATA_PROT_DMA
      sata_inic162x: kill now unused bmdma related stuff
      sata_inic162x: use IDMA for non DMA ATA commands
      sata_inic162x: use IDMA for ATAPI commands
      sata_inic162x: kill now unused SFF related stuff
      sata_inic162x: add cardbus support
      sata_inic162x: update intro comment, up the version and drop EXPERIMENTAL

Tetsuo Handa (1):
      serial: access after NULL check in uart_flush_buffer()

Thomas Gleixner (5):
      x86: undo visws/numaq build changes
      x86: olpc build fix
      x86: revert geode config dependency
      x86: cleanup PAT cpu validation
      x86: revert printk format warning change which is for linux-next

Ulrich Drepper (3):
      unified (weak) sys_pipe implementation
      tiny mq_open optimization
      sys_pipe(): fix file descriptor leaks

Uwe Kleine-König (3):
      ns9xxx: fix handle_prio_irq to unmask irqs with lower priority
      ns9xxx: check for irq lockups
      ns9xxx: fix sparse warning

Vaidyanathan Srinivasan (1):
      x86: sysfs cpu?/topology is empty in 2.6.25 (32-bit Intel system)

Vitja Makarov (1):
      [Blackfin] arch: Support for CPU_FREQ and NOHZ

WANG Cong (1):
      uml: fix inconsistence due to tty_operation change

Yinghai Lu (4):
      x86/pci: remove flag in pci_cfg_space_size_ext
      x86/pci: add pci=skip_isa_align command lines.
      x86 PCI: call dmi_check_pciprobe()
      x86: remove spew print out about bus to node mapping

grzegorz.chwesewicz@chilan.com (1):
      kgdb: minor documentation fixes

