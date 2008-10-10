Return-Path: <linux-kernel-owner+w=401wt.eu-S1762694AbYJJTAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762694AbYJJTAy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 15:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760554AbYJJTAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 15:00:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57357 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760262AbYJJTAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 15:00:13 -0400
Date: Fri, 10 Oct 2008 20:59:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull, take 2] x86 updates for v2.6.28, phase #9, sparse IRQ
	support
Message-ID: <20081010185912.GF21876@elte.hu>
References: <20081010001727.GA14132@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081010001727.GA14132@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.8
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.8 required=5.9 tests=DNS_FROM_SECURITYSAGE,FRT_LEVITRA autolearn=no SpamAssassin version=3.2.3
	1.8 FRT_LEVITRA            BODY: ReplaceTags: Levitra
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> Linus,
> 
> Please pull the latest x86-v28-for-linus-phase9 git tree from:
> 
> Sparse IRQ support - make NR_IRQS dynamic by turning it into nr_irqs, 
> an by creating irq descriptors in a sparse way.
> 
> Includes a number of dependent x86 topics: timers/hpet-percpu, IO-APIC 
> and local APIC code unification, UV support updates.
> 
> Has been cross-built on all architectures we could get crosscompilers 
> for:
> 
>   http://www.tglx.de/autoqa/index
> 
> It should be largely uneventful for sparse-irq unaware, non-x86 
> architectures.

please find updated pull request below. Relative to phase-N-1. Updates 
from today in this class of topics:

  b570868: x86: apic - unify APIC_DIVISOR

And i removed:

  eada62c: acpi/x86: introduce __apci_map_table, v4

[ Cc:-ed Yinghai for that - we can live without that patch (i.e. we at
  most get a leak warning) and can have that via acpi.git, correct? ]

	Ingo

--------------------->
Linus,

Please pull the latest x86-v28-for-linus-phase9-B git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-v28-for-linus-phase9-B


out-of-topic modifications in x86-v28-for-linus-phase9-B:
---------------------------------------------------------
arch/Kconfig                       # f9fd45f: x86: make HAVE_SPARSE_IRQ support
                                   # f2f61d1: generic: sparse irqs: use irq_des
                                   # f4e4080: x86: enable dyn_array support
arch/m68k/kernel/ints.c            # 3af7043: sparseirq: export nr_irqs on m68k
                                   # 9e89c54: irq: introduce nr_irqs
arch/s390/kernel/irq.c             # 3af7043: sparseirq: export nr_irqs on m68k
                                   # 9e89c54: irq: introduce nr_irqs
arch/sparc/kernel/irq.c            # 3af7043: sparseirq: export nr_irqs on m68k
                                   # 9e89c54: irq: introduce nr_irqs
drivers/char/hpet.c                # efe5f1f: drivers/char: use nr_irqs
drivers/char/random.c              # 0f8348b: x86: put timer_rand_state pointer
                                   # 7d95b2f: irqs: make irq_timer_state to use
                                   # efe5f1f: drivers/char: use nr_irqs
drivers/char/vr41xx_giu.c          # efe5f1f: drivers/char: use nr_irqs
drivers/gpio/gpiolib.c             # f2f61d1: generic: sparse irqs: use irq_des
drivers/mfd/asic3.c                # f2f61d1: generic: sparse irqs: use irq_des
drivers/mfd/htc-egpio.c            # f2f61d1: generic: sparse irqs: use irq_des
drivers/net/3c59x.c                # 11eb183: drivers/net: use nr_irqs
drivers/net/hamradio/baycom_ser_fdx.c# 11eb183: drivers/net: use nr_irqs
drivers/net/hamradio/scc.c         # 11eb183: drivers/net: use nr_irqs
drivers/net/wan/sbni.c             # 11eb183: drivers/net: use nr_irqs
drivers/parisc/dino.c              # f2f61d1: generic: sparse irqs: use irq_des
drivers/parisc/eisa.c              # f2f61d1: generic: sparse irqs: use irq_des
drivers/parisc/gsc.c               # f2f61d1: generic: sparse irqs: use irq_des
drivers/parisc/iosapic.c           # f2f61d1: generic: sparse irqs: use irq_des
drivers/parisc/superio.c           # f2f61d1: generic: sparse irqs: use irq_des
drivers/pci/dmar.c                 # 6a6ea11: x86/pci: fix dmar_tbl early_iorem
                                   # 0f48966: dmar: fix dmar_parse_dev() device
                                   # 2283240: dmar: use list_for_each_entry_saf
                                   # 3f1fdb3: dmar: initialize the return value
                                   # f12c73e: dmar: fix using early fixmap mapp
drivers/pci/htirq.c                # fac1ddf: irq: error missed ifndef CONFIG_H
                                   # daa86c2: irq: error missed ifndef CONFIG_H
                                   # 393b543: x86: use 28 bits irq NR for pci m
drivers/pci/intr_remapping.c       # 52f0dd2: sparseirq: fix intr-remap with dy
                                   # 0cd4568: x86: put irq_2_iommu pointer into
                                   # 7dd5896: irq: make irq2_iommu to use dyn_a
                                   # 09baa17: drivers/pci/ intr remapping: use 
drivers/pcmcia/at91_cf.c           # 32d730e: drivers/pcmcia: use nr_irqs
drivers/pcmcia/hd64465_ss.c        # f2f61d1: generic: sparse irqs: use irq_des
drivers/pcmcia/vrc4171_card.c      # 32d730e: drivers/pcmcia: use nr_irqs
drivers/rtc/rtc-vr41xx.c           # 437dff2: drivers/rtc: use nr_irqs
drivers/scsi/aha152x.c             # 400163a: drivers/scsi: use nr_irqs
drivers/scsi/qla2xxx/qla_def.h     # 9e40236: pci: change msi-x vector to 32bit
drivers/serial/68328serial.c       # d1c1152: serial, 8250: remove NR_IRQ usage
drivers/serial/8250.c              # 06d4e48: drivers/serial: use nr_irqs
                                   # d1c1152: serial, 8250: remove NR_IRQ usage
drivers/serial/amba-pl010.c        # 06d4e48: drivers/serial: use nr_irqs
drivers/serial/amba-pl011.c        # 06d4e48: drivers/serial: use nr_irqs
drivers/serial/cpm_uart/cpm_uart_core.c# 06d4e48: drivers/serial: use nr_irqs
drivers/serial/m32r_sio.c          # 06d4e48: drivers/serial: use nr_irqs
drivers/serial/serial_core.c       # 06d4e48: drivers/serial: use nr_irqs
drivers/serial/serial_lh7a40x.c    # 06d4e48: drivers/serial: use nr_irqs
drivers/serial/sh-sci.c            # 06d4e48: drivers/serial: use nr_irqs
drivers/serial/ucc_uart.c          # 06d4e48: drivers/serial: use nr_irqs
fs/proc/proc_misc.c                # 393b543: x86: use 28 bits irq NR for pci m
                                   # 9ac68c3: x86_64: make /proc/interrupts wor
                                   # 40643ff: irq, fs/proc: replace loop with n
                                   # fb6dc57: x86: move kstat_irqs from kstat t
                                   # eb2befe: fs/proc: use nr_irqs
include/asm-generic/vmlinux.lds.h  # 28c00bc: add per_cpu_dyn_array support
                                   # 565a0e8: generic: add dyn_array support
include/linux/dmar.h               # f12c73e: dmar: fix using early fixmap mapp
include/linux/init.h               # dac5f10: x86: alloc dyn_array all together
                                   # 28c00bc: add per_cpu_dyn_array support
                                   # 565a0e8: generic: add dyn_array support
include/linux/interrupt.h          # 40643ff: irq, fs/proc: replace loop with n
                                   # 9e89c54: irq: introduce nr_irqs
include/linux/irq.h                # 310e8db: sparseirq: move kstat_irqs from k
                                   # b07e51e: x86: remove irqbalance in kernel 
                                   # 393b543: x86: use 28 bits irq NR for pci m
                                   # 0cd4568: x86: put irq_2_iommu pointer into
                                   # 93dce19: irq: separate sparse_irqs from sp
                                   # 847f106: x86_64: rename irq_desc/irq_desc_
                                   # 8d1d05e: generic: add irq_desc in function
                                   # 7329b0c: irq: replace loop with nr_irqs wi
                                   # 7ef7c43: irq: add irq_desc_without_new
                                   # fb6dc57: x86: move kstat_irqs from kstat t
                                   # 0f8348b: x86: put timer_rand_state pointer
                                   # f2f61d1: generic: sparse irqs: use irq_des
                                   # 78c82c3: irq: make irq_desc to use dyn_arr
                                   # 8d00a6c: genirq: remove last NO_IDLE_HZ le
include/linux/kernel_stat.h        # 310e8db: sparseirq: move kstat_irqs from k
                                   # fb6dc57: x86: move kstat_irqs from kstat t
                                   # f909491: irq: make irqs in kernel stat use
include/linux/pci.h                # 9e40236: pci: change msi-x vector to 32bit
init/Makefile                      # 35aa85d: dyn_array: split dyn_array functi
init/dyn_array.c                   # a7616e5: dyn_array: use %pF instead of pri
                                   # 0bfd4d1: dyn_array: remove one panic
                                   # 00be105: dyn_array: fix typo
                                   # 28de6b7: dyn_array: don't break compiling 
                                   # 35aa85d: dyn_array: split dyn_array functi
kernel/irq/autoprobe.c             # ff2973b: irq: sparse irqs, fix IRQ auto-pr
                                   # f2f61d1: generic: sparse irqs: use irq_des
                                   # 9e89c54: irq: introduce nr_irqs
kernel/irq/chip.c                  # dcec2cc: irq: set_irq_chip() has redundant
                                   # 310e8db: sparseirq: move kstat_irqs from k
                                   # 847f106: x86_64: rename irq_desc/irq_desc_
                                   # 1928d43: irq: remove >= nr_irqs checking w
                                   # fb6dc57: x86: move kstat_irqs from kstat t
                                   # f2f61d1: generic: sparse irqs: use irq_des
                                   # 9e89c54: irq: introduce nr_irqs
kernel/irq/handle.c                # bcb7176: x86: fix typo in irq_desc array
                                   # 14a929b: fix warning: "x86: sparse_irq nee
                                   # 2806dc4: sparseirq: remove some debug prin
                                   # 310e8db: sparseirq: move kstat_irqs from k
                                   # a532e19: x86: sparse_irq needs spin_lock i
                                   # 95e9fdf: sparseirq: fix lockdep
                                   # 93dce19: irq: separate sparse_irqs from sp
                                   # 847f106: x86_64: rename irq_desc/irq_desc_
                                   # 8d1d05e: generic: add irq_desc in function
                                   # 7ef7c43: irq: add irq_desc_without_new
                                   # fb6dc57: x86: move kstat_irqs from kstat t
                                   # f2f61d1: generic: sparse irqs: use irq_des
                                   # 414ec26: irq: sparse irqs, export nr_irqs
                                   # 78c82c3: irq: make irq_desc to use dyn_arr
                                   # 9e89c54: irq: introduce nr_irqs
                                   # 8d00a6c: genirq: remove last NO_IDLE_HZ le
kernel/irq/internals.h             # 7329b0c: irq: replace loop with nr_irqs wi
kernel/irq/manage.c                # eefc5bb: x86: HPET_MSI change IRQ affinity
                                   # b07e51e: x86: remove irqbalance in kernel 
                                   # 847f106: x86_64: rename irq_desc/irq_desc_
                                   # 1928d43: irq: remove >= nr_irqs checking w
                                   # 7329b0c: irq: replace loop with nr_irqs wi
                                   # f2f61d1: generic: sparse irqs: use irq_des
                                   # 9e89c54: irq: introduce nr_irqs
kernel/irq/migration.c             # f2f61d1: generic: sparse irqs: use irq_des
kernel/irq/proc.c                  # 7329b0c: irq: replace loop with nr_irqs wi
                                   # f2f61d1: generic: sparse irqs: use irq_des
                                   # 9e89c54: irq: introduce nr_irqs
kernel/irq/resend.c                # f2f61d1: generic: sparse irqs: use irq_des
                                   # 9e89c54: irq: introduce nr_irqs
kernel/irq/spurious.c              # bbd243a: irq: fix irqpoll && sparseirq
                                   # f2f61d1: generic: sparse irqs: use irq_des
                                   # 9e89c54: irq: introduce nr_irqs
                                   # f84dbb9: genirq: enable polling for disabl

 Thanks,

	Ingo

------------------>
Alan Cox (1):
      serial, 8250: remove NR_IRQ usage

Alex Nixon (2):
      xen: fix memory access violation bug when CONFIG_HAVE_SPARSE_IRQ is enabled
      xen: Fix bug `do_IRQ: cannot handle IRQ -1 vector 0x6 cpu 1'

Alok Kataria (1):
      x86: VMI, initialize IRQ vector

Andrew Morton (1):
      fix warning: "x86: sparse_irq needs spin_lock in allocations"

Cyrill Gorcunov (20):
      x86: apic_64.c - setup_APIC_timer has to be __cpuinit function
      x86: apic - introduce get_physical_broadcast for 64bit
      x86: apic - unify setup_apicpmtimer
      x86: apic_64.c - add sanity check for spurious vector definition
      x86: apic - unify setup_local_APIC
      x86: apic_32.c should use __cpuinit section
      x86: apic - unify smp_apic_timer_interrupt
      x86: apic - unify smp_spurious/error_interrupt declaration
      x86: io-apic - use ARRAY_SIZE macro
      x86: io-apic - declare irq_cfg_lock for SPARSE_IRQ only
      x86: io-apic - code style cleaning for setup_IO_APIC_irqs
      x86: io-apic - do not use KERN_DEBUG marker too much
      x86: io-apic - get rid of __DO_ACTION macro
      x86: apic - lapic_setup_esr does not handle esr_disable - fix it
      x86: apic - skip writting ESR register if we dont have on
      x86: apic - fix unused vars warning in calibrate_APIC_clock
      x86: io-apic - do not use KERN_DEBUG marker too much, fix
      x86: io-apic - interrupt remapping fix
      x86: io-apic - interrupt remapping fix
      x86: apic - unify APIC_DIVISOR

Dean Nelson (3):
      irq: error missed ifndef CONFIG_HAVE_SPARSE_IRQ
      irq: set_irq_chip() has redundant call to irq_to_desc()
      x86, UV: add uv_setup_irq() and uv_teardown_irq() functions, v3

Eric W. Biederman (1):
      genirq: enable polling for disabled screaming irqs

H. Peter Anvin (1):
      dyn_array: don't break compiling for !CONFIG_SMP

Ingo Molnar (10):
      irq: sparse irqs, export nr_irqs
      irq: sparse irqs, fix #3
      irq: sparse irqs, fix IRQ auto-probe crash
      sparseirq: fix lockdep
      x86: make io_apic_32.c the same as io_apic_64.c
      warning: fix arch x86 kernel io_apic c
      sparseirq: export nr_irqs on m68k/sparc/s390
      x86: HPET_MSI Basic HPET_MSI setup code, cleanups
      x86, UV: add uv_setup_irq() and uv_teardown_irq() functions, v3, fix
      Revert "pci: fix BAR print out"

Jack Steiner (3):
      x86, uv: fix ordering of calls to uv_system_init & uv_cpu_init
      x86, uv: add early detection of UV system types
      x86, uv: fix for size of hub mappings

Russ Anderson (5):
      sysfs, x86, uv: Document files in /sys/firmware/sgi_uv/
      x86: Add UV EFI table entry v4
      x86: Add UV bios call infrastructure v4
      x86: Add UV partition call v4
      x86: Add sysfs entries for UV v4

Steven Noonan (1):
      x86: fix HPET compiler error when not using CONFIG_PCI_MSI

Suresh Siddha (3):
      sparseirq: fix intr-remap with dyn_array/nr_irqs changes]
      dmar: use list_for_each_entry_safe() in dmar_dev_scope_init()
      dmar: fix dmar_parse_dev() devices_cnt error condition check

Thomas Gleixner (1):
      genirq: remove last NO_IDLE_HZ leftovers

Venki Pallipadi (2):
      x86: using HPET in MSI mode and setting up per CPU HPET timers, fix
      hpet: clean up warning

Yinghai Lu (102):
      x86: add after_bootmem flag for 32bit
      x86: remove irq_vectors_limits
      generic: add dyn_array support
      add per_cpu_dyn_array support
      x86: alloc dyn_array all together
      x86: enable dyn_array support
      irq: introduce nr_irqs
      x86: use nr_irqs
      drivers/char: use nr_irqs
      drivers/net: use nr_irqs
      drivers/pci/ intr remapping: use nr_irqs
      drivers/pcmcia: use nr_irqs
      drivers/rtc: use nr_irqs
      drivers/scsi: use nr_irqs
      drivers/serial: use nr_irqs
      fs/proc: use nr_irqs
      drivers/xen: use nr_irqs
      irqs: make irq_timer_state to use dyn_array
      irq: make irq2_iommu to use dyn_array
      irq: make irq_desc to use dyn_array
      irq: make irqs in kernel stat use per_cpu_dyn_array
      x86: use dyn_array in io_apic_xx.c
      x86, irq: get nr_irqs from madt
      x86: remove nr_irq_vectors
      generic: sparse irqs: use irq_desc() together with dyn_array, instead of irq_desc[]
      x86: add irq_cfg in io_apic_64.c
      x86: put irq_2_pin pointer into irq_cfg
      x86: put timer_rand_state pointer into irq_desc
      x86: move kstat_irqs from kstat to irq_desc
      irq: add irq_desc_without_new
      irq: replace loop with nr_irqs with for_each_irq_desc
      irq, fs/proc: replace loop with nr_irqs for proc/stat
      x86, ioapic: replace loop with nr_irqs with for_each_irq_icfg
      irq: remove >= nr_irqs checking with config_have_sparse_irq
      generic: add irq_desc in function in parameter
      x86: check with without_new in show_interrupts
      x86_64: rename irq_desc/irq_desc_alloc
      irq: separate sparse_irqs from sparse_irqs_free
      x86_64: separate irq_cfgx from irq_cfgx_free
      x86_64: make /proc/interrupts work with dyn irq_desc
      x86: put irq_2_iommu pointer into irq_desc
      x86: use 28 bits irq NR for pci msi/msix and ht
      x86: remove irqbalance in kernel for 32 bit
      x86: add irq_cfg for 32bit
      x86: make 32bit use irq_cfg_alloc, etc
      x86: make 32bit to use irq_2_pin in irq_cfg
      x86: make 32 bit to use sparse_irq
      x86: make 32bit support per_cpu vector
      x86: add debug info for 32bit sparse_irq
      x86, io-apic: remove union about dest for log/phy
      x86: ordering functions in io_apic_32.c
      x86: ordering functions in io_apic_64.c
      x86: order variables in io_apic_xx.c
      x86: make headers files the same in io_apic_xx.c
      x86: make 64 handle sis_apic_bug like the 32 bit
      x86: remove ioapic_force
      x86: make io_apic_64.c and io_apic_32.c the same
      rename io_apic_64.c and io_apic_32.c to io_apic.c
      io_apic: make 32 bit have io_apic resource in /proc/iomem
      pci: change msi-x vector to 32bit
      x86: irq: interrupt array size should be NR_VECTORS
      x86: unify mask_IO_APIC_irq
      x86: unify ack_apic_edge
      x86: remove first_free_entry/pin_map_size
      x86: print local APIC of APs one by one
      x86: make HAVE_SPARSE_IRQ support selectable
      x86: probe nr_irqs even only mptable is used
      dyn_array: split dyn_array functions from init/main.c
      x86: sparse_irq needs spin_lock in allocations
      x86: fix 32-bit ioapic lockup with sparseirqs
      x86: fix probe_nr_irqs for xen
      x86: apic_xx.c order variables
      x86: use HAVE_X2APIC in apic_64.c
      x86: add hard_smp_prossor_id with MACRO in io_apic_xx.c
      x86: make apic_32/64.c more like
      x86: merge APIC_init_uniprocessor
      x86: copy detect_init_APIC to the other
      x86: merge header files in apic_xx.c
      x86: apic unify smp_spurious/error_interrupt
      x86: apic copy calibrate_APIC_clock to each other in apic_32/64.c
      x86: apic copy apic_64.c to apic_32.c
      x86: rename apic_32.c and apic_64.c to apic.c
      x86: let 64 bit to use 32 bit calibrate_apic_clock
      sparseirq: move kstat_irqs from kstat to irq_desc - fix
      x2apic: fix reserved APIC register accesses in print_local_APIC()
      dmar: fix using early fixmap mapping for DMAR table parsing
      dmar: initialize the return value in dmar_parse_dev()
      x86: print out if acpi want physical flat of all
      dyn_array: fix typo
      pci: fix BAR print out
      irq: error missed ifndef CONFIG_HAVE_SPARSE_IRQ, v2
      dyn_array: remove one panic
      x86: lapic address print out like io apic addr
      x86: print out apic id in hex format
      dyn_array: use %pF instead of print_fn_descriptor_symbol
      irq: fix irqpoll && sparseirq
      sparseirq: remove some debug print out
      x86/pci: fix dmar_tbl early_ioremap leak v2
      x86: fix typo in irq_desc array
      x86: irq no should not use hex in /proc/interrupts
      x86: print out irq nr for msi/ht, v3
      x86: sparse_irq: fix typo in debug print out

venkatesh.pallipadi@intel.com (4):
      x86: HPET_MSI change IRQ affinity in process context when it is disabled
      x86: HPET_MSI Refactor code in preparation for HPET_MSI
      x86: HPET_MSI Basic HPET_MSI setup code
      x86: HPET_MSI Initialise per-cpu HPET timers


 arch/Kconfig                                      |    3 +
 arch/m68k/kernel/ints.c                           |    3 +
 arch/s390/kernel/irq.c                            |    3 +
 arch/sparc/kernel/irq.c                           |    4 +
 arch/x86/Kconfig                                  |   20 +-
 arch/x86/configs/i386_defconfig                   |    1 -
 arch/x86/kernel/Makefile                          |    6 +-
 arch/x86/kernel/acpi/boot.c                       |    5 +-
 arch/x86/kernel/{apic_32.c => apic.c}             |  627 ++++-
 arch/x86/kernel/apic_64.c                         | 1848 -------------
 arch/x86/kernel/bios_uv.c                         |  137 +-
 arch/x86/kernel/cpu/amd.c                         |    2 +-
 arch/x86/kernel/cpu/intel.c                       |    2 +-
 arch/x86/kernel/efi.c                             |    4 +
 arch/x86/kernel/entry_32.S                        |    2 +-
 arch/x86/kernel/genapic_flat_64.c                 |    4 +-
 arch/x86/kernel/genx2apic_uv_x.c                  |   62 +-
 arch/x86/kernel/hpet.c                            |  453 +++-
 arch/x86/kernel/{io_apic_64.c => io_apic.c}       | 1689 ++++++++++---
 arch/x86/kernel/io_apic_32.c                      | 2908 ---------------------
 arch/x86/kernel/irq_32.c                          |   71 +-
 arch/x86/kernel/irq_64.c                          |   74 +-
 arch/x86/kernel/irqinit_32.c                      |   48 +-
 arch/x86/kernel/irqinit_64.c                      |   28 +-
 arch/x86/kernel/quirks.c                          |    3 -
 arch/x86/kernel/setup.c                           |    6 +
 arch/x86/kernel/setup_percpu.c                    |   19 +-
 arch/x86/kernel/smpboot.c                         |    6 +-
 arch/x86/kernel/uv_irq.c                          |   79 +
 arch/x86/kernel/uv_sysfs.c                        |   72 +
 arch/x86/kernel/visws_quirks.c                    |   32 +-
 arch/x86/kernel/vmiclock_32.c                     |    3 +
 arch/x86/kernel/vmlinux_32.lds.S                  |    1 +
 arch/x86/kernel/vmlinux_64.lds.S                  |    3 +
 arch/x86/lguest/boot.c                            |    2 +-
 arch/x86/mach-generic/bigsmp.c                    |    4 +
 arch/x86/mach-generic/es7000.c                    |   14 +
 arch/x86/mach-generic/numaq.c                     |   14 +
 arch/x86/mach-generic/summit.c                    |   14 +
 arch/x86/mach-voyager/voyager_smp.c               |    4 +-
 arch/x86/mm/init_32.c                             |    3 +
 arch/x86/mm/srat_64.c                             |    2 +-
 arch/x86/xen/irq.c                                |    2 -
 arch/x86/xen/spinlock.c                           |    2 +-
 drivers/char/hpet.c                               |    2 +-
 drivers/char/random.c                             |   72 +-
 drivers/char/vr41xx_giu.c                         |    2 +-
 drivers/gpio/gpiolib.c                            |    2 +-
 drivers/mfd/asic3.c                               |    4 +-
 drivers/mfd/htc-egpio.c                           |    2 +-
 drivers/net/3c59x.c                               |    4 +-
 drivers/net/hamradio/baycom_ser_fdx.c             |    4 +-
 drivers/net/hamradio/scc.c                        |    6 +-
 drivers/net/wan/sbni.c                            |    2 +-
 drivers/parisc/dino.c                             |    6 +-
 drivers/parisc/eisa.c                             |    4 +-
 drivers/parisc/gsc.c                              |   12 +-
 drivers/parisc/iosapic.c                          |    4 +-
 drivers/parisc/superio.c                          |    4 +-
 drivers/pci/dmar.c                                |   66 +-
 drivers/pci/htirq.c                               |   20 +-
 drivers/pci/intr_remapping.c                      |  221 ++-
 drivers/pcmcia/at91_cf.c                          |    2 +-
 drivers/pcmcia/hd64465_ss.c                       |   12 +-
 drivers/pcmcia/vrc4171_card.c                     |    2 +-
 drivers/rtc/rtc-vr41xx.c                          |    4 +-
 drivers/scsi/aha152x.c                            |    2 +-
 drivers/scsi/qla2xxx/qla_def.h                    |    2 +-
 drivers/serial/68328serial.c                      |   11 +-
 drivers/serial/8250.c                             |   69 +-
 drivers/serial/amba-pl010.c                       |    2 +-
 drivers/serial/amba-pl011.c                       |    2 +-
 drivers/serial/cpm_uart/cpm_uart_core.c           |    2 +-
 drivers/serial/m32r_sio.c                         |    4 +-
 drivers/serial/serial_core.c                      |    2 +-
 drivers/serial/serial_lh7a40x.c                   |    2 +-
 drivers/serial/sh-sci.c                           |    2 +-
 drivers/serial/ucc_uart.c                         |    2 +-
 drivers/xen/events.c                              |   20 +-
 fs/proc/proc_misc.c                               |   72 +-
 include/asm-generic/vmlinux.lds.h                 |   13 +
 include/asm-x86/apic.h                            |   16 +-
 include/asm-x86/bigsmp/apic.h                     |   15 +-
 include/asm-x86/efi.h                             |   13 +
 include/asm-x86/es7000/apic.h                     |    3 +-
 include/asm-x86/genapic_32.h                      |    2 +
 include/asm-x86/hpet.h                            |   21 +
 include/asm-x86/hw_irq.h                          |   13 +-
 include/asm-x86/io_apic.h                         |   24 +-
 include/asm-x86/irq_vectors.h                     |   24 +-
 include/asm-x86/mach-default/entry_arch.h         |    1 +
 include/asm-x86/mach-default/mach_apic.h          |   15 +-
 include/asm-x86/mach-generic/irq_vectors_limits.h |   14 -
 include/asm-x86/mach-generic/mach_apic.h          |    1 +
 include/asm-x86/numaq/apic.h                      |    2 -
 include/asm-x86/summit/apic.h                     |    1 -
 include/asm-x86/summit/irq_vectors_limits.h       |   14 -
 include/asm-x86/uv/bios.h                         |   94 +-
 include/asm-x86/uv/uv_irq.h                       |   36 +
 include/linux/dmar.h                              |    1 -
 include/linux/efi.h                               |    4 +
 include/linux/init.h                              |   44 +
 include/linux/interrupt.h                         |    7 +
 include/linux/irq.h                               |   89 +-
 include/linux/kernel_stat.h                       |   26 +-
 include/linux/pci.h                               |    2 +-
 init/Makefile                                     |    2 +-
 init/dyn_array.c                                  |  120 +
 init/main.c                                       |   11 +-
 kernel/irq/autoprobe.c                            |   30 +-
 kernel/irq/chip.c                                 |   99 +-
 kernel/irq/handle.c                               |  253 ++-
 kernel/irq/internals.h                            |    4 +-
 kernel/irq/manage.c                               |   68 +-
 kernel/irq/migration.c                            |   14 +-
 kernel/irq/proc.c                                 |   44 +-
 kernel/irq/resend.c                               |    6 +-
 kernel/irq/spurious.c                             |  154 +-
 118 files changed, 4368 insertions(+), 5872 deletions(-)
 rename arch/x86/kernel/{apic_32.c => apic.c} (79%)
 delete mode 100644 arch/x86/kernel/apic_64.c
 rename arch/x86/kernel/{io_apic_64.c => io_apic.c} (65%)
 delete mode 100644 arch/x86/kernel/io_apic_32.c
 create mode 100644 arch/x86/kernel/uv_irq.c
 create mode 100644 arch/x86/kernel/uv_sysfs.c
 delete mode 100644 include/asm-x86/mach-generic/irq_vectors_limits.h
 delete mode 100644 include/asm-x86/summit/irq_vectors_limits.h
 create mode 100644 include/asm-x86/uv/uv_irq.h
 create mode 100644 init/dyn_array.c

diff --git a/arch/Kconfig b/arch/Kconfig
index 0267bab..c8a7c2e 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -103,3 +103,6 @@ config HAVE_CLK
 	  The <linux/clk.h> calls support software clock gating and
 	  thus are a key power management tool on many systems.
 
+config HAVE_DYN_ARRAY
+	def_bool n
+
diff --git a/arch/m68k/kernel/ints.c b/arch/m68k/kernel/ints.c
index ded7dd2..8dd5591 100644
--- a/arch/m68k/kernel/ints.c
+++ b/arch/m68k/kernel/ints.c
@@ -46,6 +46,9 @@
 #include <asm/q40ints.h>
 #endif
 
+int nr_irqs = NR_IRQS;
+EXPORT_SYMBOL(nr_irqs);
+
 extern u32 auto_irqhandler_fixup[];
 extern u32 user_irqhandler_fixup[];
 extern u16 user_irqvec_fixup[];
diff --git a/arch/s390/kernel/irq.c b/arch/s390/kernel/irq.c
index e7c5bfb..3624c4a 100644
--- a/arch/s390/kernel/irq.c
+++ b/arch/s390/kernel/irq.c
@@ -17,6 +17,9 @@
 #include <linux/proc_fs.h>
 #include <linux/profile.h>
 
+int nr_irqs = NR_IRQS;
+EXPORT_SYMBOL(nr_irqs);
+
 /*
  * show_interrupts is needed by /proc/interrupts.
  */
diff --git a/arch/sparc/kernel/irq.c b/arch/sparc/kernel/irq.c
index 93e1d1c..4b99e3c 100644
--- a/arch/sparc/kernel/irq.c
+++ b/arch/sparc/kernel/irq.c
@@ -55,6 +55,10 @@
 #define SMP_NOP2
 #define SMP_NOP3
 #endif /* SMP */
+
+int nr_irqs = NR_IRQS;
+EXPORT_SYMBOL(nr_irqs);
+
 unsigned long __raw_local_irq_save(void)
 {
 	unsigned long retval;
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 44d4f21..b667150 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -32,6 +32,7 @@ config X86
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_GENERIC_DMA_COHERENT if X86_32
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
+	select HAVE_DYN_ARRAY
 
 config ARCH_DEFCONFIG
 	string
@@ -238,6 +239,17 @@ config SMP
 
 	  If you don't know what to do here, say N.
 
+config HAVE_SPARSE_IRQ
+	bool "Support sparse irq numbering"
+	depends on PCI_MSI || HT_IRQ
+	default y
+	help
+	  This enables support for sparse irq, esp for msi/msi-x. the irq
+	  number will be bus/dev/fn + 12bit. You may need if you have lots of
+	  cards supports msi-x installed.
+
+	  If you don't know what to do here, say Y.
+
 config X86_FIND_SMP_CONFIG
 	def_bool y
 	depends on X86_MPPARSE || X86_VOYAGER
@@ -1182,14 +1194,6 @@ config EFI
   	resultant kernel should continue to boot on existing non-EFI
   	platforms.
 
-config IRQBALANCE
-	def_bool y
-	prompt "Enable kernel irq balancing"
-	depends on X86_32 && SMP && X86_IO_APIC
-	help
-	  The default yes will allow the kernel to do irq load balancing.
-	  Saying no will keep the kernel from doing irq load balancing.
-
 config SECCOMP
 	def_bool y
 	prompt "Enable seccomp to safely compute untrusted bytecode"
diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
index 9269ef4..c54b710 100644
--- a/arch/x86/configs/i386_defconfig
+++ b/arch/x86/configs/i386_defconfig
@@ -287,7 +287,6 @@ CONFIG_MTRR=y
 # CONFIG_MTRR_SANITIZER is not set
 CONFIG_X86_PAT=y
 CONFIG_EFI=y
-# CONFIG_IRQBALANCE is not set
 CONFIG_SECCOMP=y
 # CONFIG_HZ_100 is not set
 # CONFIG_HZ_250 is not set
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index f6160cc..4dc47a3 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -61,8 +61,8 @@ obj-$(CONFIG_X86_32_SMP)	+= smpcommon.o
 obj-$(CONFIG_X86_64_SMP)	+= tsc_sync.o smpcommon.o
 obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline_$(BITS).o
 obj-$(CONFIG_X86_MPPARSE)	+= mpparse.o
-obj-$(CONFIG_X86_LOCAL_APIC)	+= apic_$(BITS).o nmi.o
-obj-$(CONFIG_X86_IO_APIC)	+= io_apic_$(BITS).o
+obj-$(CONFIG_X86_LOCAL_APIC)	+= apic.o nmi.o
+obj-$(CONFIG_X86_IO_APIC)	+= io_apic.o
 obj-$(CONFIG_X86_REBOOTFIXUPS)	+= reboot_fixups_32.o
 obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
 obj-$(CONFIG_KEXEC)		+= machine_kexec_$(BITS).o
@@ -104,7 +104,7 @@ obj-$(CONFIG_OLPC)		+= olpc.o
 # 64 bit specific files
 ifeq ($(CONFIG_X86_64),y)
         obj-y				+= genapic_64.o genapic_flat_64.o genx2apic_uv_x.o tlb_uv.o
-	obj-y				+= bios_uv.o
+	obj-y				+= bios_uv.o uv_irq.o uv_sysfs.o
         obj-y				+= genx2apic_cluster.o
         obj-y				+= genx2apic_phys.o
         obj-$(CONFIG_X86_PM_TIMER)	+= pmtimer_64.o
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 0f5b567..be320a5 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1238,9 +1238,10 @@ static int __init acpi_parse_madt_ioapic_entries(void)
 		return count;
 	}
 
+
 	count =
 	    acpi_table_parse_madt(ACPI_MADT_TYPE_INTERRUPT_OVERRIDE, acpi_parse_int_src_ovr,
-				  NR_IRQ_VECTORS);
+				  nr_irqs);
 	if (count < 0) {
 		printk(KERN_ERR PREFIX
 		       "Error parsing interrupt source overrides entry\n");
@@ -1260,7 +1261,7 @@ static int __init acpi_parse_madt_ioapic_entries(void)
 
 	count =
 	    acpi_table_parse_madt(ACPI_MADT_TYPE_NMI_SOURCE, acpi_parse_nmi_src,
-				  NR_IRQ_VECTORS);
+				  nr_irqs);
 	if (count < 0) {
 		printk(KERN_ERR PREFIX "Error parsing NMI SRC entry\n");
 		/* TBD: Cleanup to allow fallback to MPS */
diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic.c
similarity index 79%
rename from arch/x86/kernel/apic_32.c
rename to arch/x86/kernel/apic.c
index 21c831d..04a7f96 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic.c
@@ -23,11 +23,13 @@
 #include <linux/mc146818rtc.h>
 #include <linux/kernel_stat.h>
 #include <linux/sysdev.h>
+#include <linux/ioport.h>
 #include <linux/cpu.h>
 #include <linux/clockchips.h>
 #include <linux/acpi_pmtmr.h>
 #include <linux/module.h>
 #include <linux/dmi.h>
+#include <linux/dmar.h>
 
 #include <asm/atomic.h>
 #include <asm/smp.h>
@@ -36,8 +38,14 @@
 #include <asm/desc.h>
 #include <asm/arch_hooks.h>
 #include <asm/hpet.h>
+#include <asm/pgalloc.h>
 #include <asm/i8253.h>
 #include <asm/nmi.h>
+#include <asm/idle.h>
+#include <asm/proto.h>
+#include <asm/timex.h>
+#include <asm/apic.h>
+#include <asm/i8259.h>
 
 #include <mach_apic.h>
 #include <mach_apicdef.h>
@@ -50,16 +58,58 @@
 # error SPURIOUS_APIC_VECTOR definition error
 #endif
 
-unsigned long mp_lapic_addr;
-
+#ifdef CONFIG_X86_32
 /*
  * Knob to control our willingness to enable the local APIC.
  *
  * +1=force-enable
  */
 static int force_enable_local_apic;
-int disable_apic;
+/*
+ * APIC command line parameters
+ */
+static int __init parse_lapic(char *arg)
+{
+	force_enable_local_apic = 1;
+	return 0;
+}
+early_param("lapic", parse_lapic);
+/* Local APIC was disabled by the BIOS and enabled by the kernel */
+static int enabled_via_apicbase;
+
+#endif
+
+#ifdef CONFIG_X86_64
+static int apic_calibrate_pmtmr __initdata;
+static __init int setup_apicpmtimer(char *s)
+{
+	apic_calibrate_pmtmr = 1;
+	notsc_setup(NULL);
+	return 0;
+}
+__setup("apicpmtimer", setup_apicpmtimer);
+#endif
+
+#ifdef CONFIG_X86_64
+#define HAVE_X2APIC
+#endif
+
+#ifdef HAVE_X2APIC
+int x2apic;
+/* x2apic enabled before OS handover */
+int x2apic_preenabled;
+int disable_x2apic;
+static __init int setup_nox2apic(char *str)
+{
+	disable_x2apic = 1;
+	setup_clear_cpu_cap(X86_FEATURE_X2APIC);
+	return 0;
+}
+early_param("nox2apic", setup_nox2apic);
+#endif
 
+unsigned long mp_lapic_addr;
+int disable_apic;
 /* Disable local APIC timer from the kernel commandline or via dmi quirk */
 static int disable_apic_timer __cpuinitdata;
 /* Local APIC timer works in C2 */
@@ -110,9 +160,6 @@ static struct clock_event_device lapic_clockevent = {
 };
 static DEFINE_PER_CPU(struct clock_event_device, lapic_events);
 
-/* Local APIC was disabled by the BIOS and enabled by the kernel */
-static int enabled_via_apicbase;
-
 static unsigned long apic_phys;
 
 /*
@@ -202,6 +249,42 @@ static struct apic_ops xapic_ops = {
 struct apic_ops __read_mostly *apic_ops = &xapic_ops;
 EXPORT_SYMBOL_GPL(apic_ops);
 
+#ifdef HAVE_X2APIC
+static void x2apic_wait_icr_idle(void)
+{
+	/* no need to wait for icr idle in x2apic */
+	return;
+}
+
+static u32 safe_x2apic_wait_icr_idle(void)
+{
+	/* no need to wait for icr idle in x2apic */
+	return 0;
+}
+
+void x2apic_icr_write(u32 low, u32 id)
+{
+	wrmsrl(APIC_BASE_MSR + (APIC_ICR >> 4), ((__u64) id) << 32 | low);
+}
+
+u64 x2apic_icr_read(void)
+{
+	unsigned long val;
+
+	rdmsrl(APIC_BASE_MSR + (APIC_ICR >> 4), val);
+	return val;
+}
+
+static struct apic_ops x2apic_ops = {
+	.read = native_apic_msr_read,
+	.write = native_apic_msr_write,
+	.icr_read = x2apic_icr_read,
+	.icr_write = x2apic_icr_write,
+	.wait_icr_idle = x2apic_wait_icr_idle,
+	.safe_wait_icr_idle = safe_x2apic_wait_icr_idle,
+};
+#endif
+
 /**
  * enable_NMI_through_LVT0 - enable NMI through local vector table 0
  */
@@ -219,6 +302,7 @@ void __cpuinit enable_NMI_through_LVT0(void)
 	apic_write(APIC_LVT0, v);
 }
 
+#ifdef CONFIG_X86_32
 /**
  * get_physical_broadcast - Get number of physical broadcast IDs
  */
@@ -226,6 +310,7 @@ int get_physical_broadcast(void)
 {
 	return modern_apic() ? 0xff : 0xf;
 }
+#endif
 
 /**
  * lapic_get_maxlvt - get the maximum number of local vector table entries
@@ -247,11 +332,7 @@ int lapic_get_maxlvt(void)
  */
 
 /* Clock divisor */
-#ifdef CONFG_X86_64
-#define APIC_DIVISOR 1
-#else
 #define APIC_DIVISOR 16
-#endif
 
 /*
  * This function sets up the local APIC timer, with a timeout of
@@ -383,7 +464,7 @@ static void lapic_timer_broadcast(cpumask_t mask)
  * Setup the local APIC timer for this CPU. Copy the initilized values
  * of the boot CPU and register the clock event in the framework.
  */
-static void __devinit setup_APIC_timer(void)
+static void __cpuinit setup_APIC_timer(void)
 {
 	struct clock_event_device *levt = &__get_cpu_var(lapic_events);
 
@@ -453,14 +534,51 @@ static void __init lapic_cal_handler(struct clock_event_device *dev)
 	}
 }
 
+static int __init calibrate_by_pmtimer(long deltapm, long *delta)
+{
+	const long pm_100ms = PMTMR_TICKS_PER_SEC / 10;
+	const long pm_thresh = pm_100ms / 100;
+	unsigned long mult;
+	u64 res;
+
+#ifndef CONFIG_X86_PM_TIMER
+	return -1;
+#endif
+
+	apic_printk(APIC_VERBOSE, "... PM timer delta = %ld\n", deltapm);
+
+	/* Check, if the PM timer is available */
+	if (!deltapm)
+		return -1;
+
+	mult = clocksource_hz2mult(PMTMR_TICKS_PER_SEC, 22);
+
+	if (deltapm > (pm_100ms - pm_thresh) &&
+	    deltapm < (pm_100ms + pm_thresh)) {
+		apic_printk(APIC_VERBOSE, "... PM timer result ok\n");
+	} else {
+		res = (((u64)deltapm) *  mult) >> 22;
+		do_div(res, 1000000);
+		printk(KERN_WARNING "APIC calibration not consistent "
+			"with PM Timer: %ldms instead of 100ms\n",
+			(long)res);
+		/* Correct the lapic counter value */
+		res = (((u64)(*delta)) * pm_100ms);
+		do_div(res, deltapm);
+		printk(KERN_INFO "APIC delta adjusted to PM-Timer: "
+			"%lu (%ld)\n", (unsigned long)res, *delta);
+		*delta = (long)res;
+	}
+
+	return 0;
+}
+
 static int __init calibrate_APIC_clock(void)
 {
 	struct clock_event_device *levt = &__get_cpu_var(lapic_events);
-	const long pm_100ms = PMTMR_TICKS_PER_SEC/10;
-	const long pm_thresh = pm_100ms/100;
 	void (*real_handler)(struct clock_event_device *dev);
 	unsigned long deltaj;
-	long delta, deltapm;
+	long delta;
 	int pm_referenced = 0;
 
 	local_irq_disable();
@@ -470,10 +588,10 @@ static int __init calibrate_APIC_clock(void)
 	global_clock_event->event_handler = lapic_cal_handler;
 
 	/*
-	 * Setup the APIC counter to 1e9. There is no way the lapic
+	 * Setup the APIC counter to maximum. There is no way the lapic
 	 * can underflow in the 100ms detection time frame
 	 */
-	__setup_APIC_LVTT(1000000000, 0, 0);
+	__setup_APIC_LVTT(0xffffffff, 0, 0);
 
 	/* Let the interrupts run */
 	local_irq_enable();
@@ -490,34 +608,9 @@ static int __init calibrate_APIC_clock(void)
 	delta = lapic_cal_t1 - lapic_cal_t2;
 	apic_printk(APIC_VERBOSE, "... lapic delta = %ld\n", delta);
 
-	/* Check, if the PM timer is available */
-	deltapm = lapic_cal_pm2 - lapic_cal_pm1;
-	apic_printk(APIC_VERBOSE, "... PM timer delta = %ld\n", deltapm);
-
-	if (deltapm) {
-		unsigned long mult;
-		u64 res;
-
-		mult = clocksource_hz2mult(PMTMR_TICKS_PER_SEC, 22);
-
-		if (deltapm > (pm_100ms - pm_thresh) &&
-		    deltapm < (pm_100ms + pm_thresh)) {
-			apic_printk(APIC_VERBOSE, "... PM timer result ok\n");
-		} else {
-			res = (((u64) deltapm) *  mult) >> 22;
-			do_div(res, 1000000);
-			printk(KERN_WARNING "APIC calibration not consistent "
-			       "with PM Timer: %ldms instead of 100ms\n",
-			       (long)res);
-			/* Correct the lapic counter value */
-			res = (((u64) delta) * pm_100ms);
-			do_div(res, deltapm);
-			printk(KERN_INFO "APIC delta adjusted to PM-Timer: "
-			       "%lu (%ld)\n", (unsigned long) res, delta);
-			delta = (long) res;
-		}
-		pm_referenced = 1;
-	}
+	/* we trust the PM based calibration if possible */
+	pm_referenced = !calibrate_by_pmtimer(lapic_cal_pm2 - lapic_cal_pm1,
+					&delta);
 
 	/* Calculate the scaled math multiplication factor */
 	lapic_clockevent.mult = div_sc(delta, TICK_NSEC * LAPIC_CAL_LOOPS,
@@ -559,7 +652,10 @@ static int __init calibrate_APIC_clock(void)
 
 	levt->features &= ~CLOCK_EVT_FEAT_DUMMY;
 
-	/* We trust the pm timer based calibration */
+	/*
+	 * PM timer calibration failed or not turned on
+	 * so lets try APIC timer based calibration
+	 */
 	if (!pm_referenced) {
 		apic_printk(APIC_VERBOSE, "... verify APIC timer\n");
 
@@ -652,7 +748,7 @@ void __init setup_boot_APIC_clock(void)
 	setup_APIC_timer();
 }
 
-void __devinit setup_secondary_APIC_clock(void)
+void __cpuinit setup_secondary_APIC_clock(void)
 {
 	setup_APIC_timer();
 }
@@ -718,6 +814,9 @@ void smp_apic_timer_interrupt(struct pt_regs *regs)
 	 * Besides, if we don't timer interrupts ignore the global
 	 * interrupt lock, which is the WrongThing (tm) to do.
 	 */
+#ifdef CONFIG_X86_64
+	exit_idle();
+#endif
 	irq_enter();
 	local_apic_timer_interrupt();
 	irq_exit();
@@ -991,40 +1090,43 @@ void __init init_bsp_APIC(void)
 
 static void __cpuinit lapic_setup_esr(void)
 {
-	unsigned long oldvalue, value, maxlvt;
-	if (lapic_is_integrated() && !esr_disable) {
-		if (esr_disable) {
-			/*
-			 * Something untraceable is creating bad interrupts on
-			 * secondary quads ... for the moment, just leave the
-			 * ESR disabled - we can't do anything useful with the
-			 * errors anyway - mbligh
-			 */
-			printk(KERN_INFO "Leaving ESR disabled.\n");
-			return;
-		}
-		/* !82489DX */
-		maxlvt = lapic_get_maxlvt();
-		if (maxlvt > 3)		/* Due to the Pentium erratum 3AP. */
-			apic_write(APIC_ESR, 0);
-		oldvalue = apic_read(APIC_ESR);
+	unsigned int oldvalue, value, maxlvt;
+
+	if (!lapic_is_integrated()) {
+		printk(KERN_INFO "No ESR for 82489DX.\n");
+		return;
+	}
 
-		/* enables sending errors */
-		value = ERROR_APIC_VECTOR;
-		apic_write(APIC_LVTERR, value);
+	if (esr_disable) {
 		/*
-		 * spec says clear errors after enabling vector.
+		 * Something untraceable is creating bad interrupts on
+		 * secondary quads ... for the moment, just leave the
+		 * ESR disabled - we can't do anything useful with the
+		 * errors anyway - mbligh
 		 */
-		if (maxlvt > 3)
-			apic_write(APIC_ESR, 0);
-		value = apic_read(APIC_ESR);
-		if (value != oldvalue)
-			apic_printk(APIC_VERBOSE, "ESR value before enabling "
-				"vector: 0x%08lx  after: 0x%08lx\n",
-				oldvalue, value);
-	} else {
-		printk(KERN_INFO "No ESR for 82489DX.\n");
+		printk(KERN_INFO "Leaving ESR disabled.\n");
+		return;
 	}
+
+	maxlvt = lapic_get_maxlvt();
+	if (maxlvt > 3)		/* Due to the Pentium erratum 3AP. */
+		apic_write(APIC_ESR, 0);
+	oldvalue = apic_read(APIC_ESR);
+
+	/* enables sending errors */
+	value = ERROR_APIC_VECTOR;
+	apic_write(APIC_LVTERR, value);
+
+	/*
+	 * spec says clear errors after enabling vector.
+	 */
+	if (maxlvt > 3)
+		apic_write(APIC_ESR, 0);
+	value = apic_read(APIC_ESR);
+	if (value != oldvalue)
+		apic_printk(APIC_VERBOSE, "ESR value before enabling "
+			"vector: 0x%08x  after: 0x%08x\n",
+			oldvalue, value);
 }
 
 
@@ -1033,24 +1135,27 @@ static void __cpuinit lapic_setup_esr(void)
  */
 void __cpuinit setup_local_APIC(void)
 {
-	unsigned long value, integrated;
+	unsigned int value;
 	int i, j;
 
+#ifdef CONFIG_X86_32
 	/* Pound the ESR really hard over the head with a big hammer - mbligh */
-	if (esr_disable) {
+	if (lapic_is_integrated() && esr_disable) {
 		apic_write(APIC_ESR, 0);
 		apic_write(APIC_ESR, 0);
 		apic_write(APIC_ESR, 0);
 		apic_write(APIC_ESR, 0);
 	}
+#endif
 
-	integrated = lapic_is_integrated();
+	preempt_disable();
 
 	/*
 	 * Double-check whether this APIC is really registered.
+	 * This is meaningless in clustered apic mode, so we skip it.
 	 */
 	if (!apic_id_registered())
-		WARN_ON_ONCE(1);
+		BUG();
 
 	/*
 	 * Intel recommends to set DFR, LDR and TPR before enabling
@@ -1096,6 +1201,7 @@ void __cpuinit setup_local_APIC(void)
 	 */
 	value |= APIC_SPIV_APIC_ENABLED;
 
+#ifdef CONFIG_X86_32
 	/*
 	 * Some unknown Intel IO/APIC (or APIC) errata is biting us with
 	 * certain networking cards. If high frequency interrupts are
@@ -1116,8 +1222,13 @@ void __cpuinit setup_local_APIC(void)
 	 * See also the comment in end_level_ioapic_irq().  --macro
 	 */
 
-	/* Enable focus processor (bit==0) */
+	/*
+	 * - enable focus processor (bit==0)
+	 * - 64bit mode always use processor focus
+	 *   so no need to set it
+	 */
 	value &= ~APIC_SPIV_FOCUS_DISABLED;
+#endif
 
 	/*
 	 * Set spurious IRQ vector
@@ -1154,9 +1265,11 @@ void __cpuinit setup_local_APIC(void)
 		value = APIC_DM_NMI;
 	else
 		value = APIC_DM_NMI | APIC_LVT_MASKED;
-	if (!integrated)		/* 82489DX */
+	if (!lapic_is_integrated())		/* 82489DX */
 		value |= APIC_LVT_LEVEL_TRIGGER;
 	apic_write(APIC_LVT1, value);
+
+	preempt_enable();
 }
 
 void __cpuinit end_local_APIC_setup(void)
@@ -1177,6 +1290,153 @@ void __cpuinit end_local_APIC_setup(void)
 	apic_pm_activate();
 }
 
+#ifdef HAVE_X2APIC
+void check_x2apic(void)
+{
+	int msr, msr2;
+
+	rdmsr(MSR_IA32_APICBASE, msr, msr2);
+
+	if (msr & X2APIC_ENABLE) {
+		printk("x2apic enabled by BIOS, switching to x2apic ops\n");
+		x2apic_preenabled = x2apic = 1;
+		apic_ops = &x2apic_ops;
+	}
+}
+
+void enable_x2apic(void)
+{
+	int msr, msr2;
+
+	rdmsr(MSR_IA32_APICBASE, msr, msr2);
+	if (!(msr & X2APIC_ENABLE)) {
+		printk("Enabling x2apic\n");
+		wrmsr(MSR_IA32_APICBASE, msr | X2APIC_ENABLE, 0);
+	}
+}
+
+void enable_IR_x2apic(void)
+{
+#ifdef CONFIG_INTR_REMAP
+	int ret;
+	unsigned long flags;
+
+	if (!cpu_has_x2apic)
+		return;
+
+	if (!x2apic_preenabled && disable_x2apic) {
+		printk(KERN_INFO
+		       "Skipped enabling x2apic and Interrupt-remapping "
+		       "because of nox2apic\n");
+		return;
+	}
+
+	if (x2apic_preenabled && disable_x2apic)
+		panic("Bios already enabled x2apic, can't enforce nox2apic");
+
+	if (!x2apic_preenabled && skip_ioapic_setup) {
+		printk(KERN_INFO
+		       "Skipped enabling x2apic and Interrupt-remapping "
+		       "because of skipping io-apic setup\n");
+		return;
+	}
+
+	ret = dmar_table_init();
+	if (ret) {
+		printk(KERN_INFO
+		       "dmar_table_init() failed with %d:\n", ret);
+
+		if (x2apic_preenabled)
+			panic("x2apic enabled by bios. But IR enabling failed");
+		else
+			printk(KERN_INFO
+			       "Not enabling x2apic,Intr-remapping\n");
+		return;
+	}
+
+	local_irq_save(flags);
+	mask_8259A();
+
+	ret = save_mask_IO_APIC_setup();
+	if (ret) {
+		printk(KERN_INFO "Saving IO-APIC state failed: %d\n", ret);
+		goto end;
+	}
+
+	ret = enable_intr_remapping(1);
+
+	if (ret && x2apic_preenabled) {
+		local_irq_restore(flags);
+		panic("x2apic enabled by bios. But IR enabling failed");
+	}
+
+	if (ret)
+		goto end_restore;
+
+	if (!x2apic) {
+		x2apic = 1;
+		apic_ops = &x2apic_ops;
+		enable_x2apic();
+	}
+
+end_restore:
+	if (ret)
+		/*
+		 * IR enabling failed
+		 */
+		restore_IO_APIC_setup();
+	else
+		reinit_intr_remapped_IO_APIC(x2apic_preenabled);
+
+end:
+	unmask_8259A();
+	local_irq_restore(flags);
+
+	if (!ret) {
+		if (!x2apic_preenabled)
+			printk(KERN_INFO
+			       "Enabled x2apic and interrupt-remapping\n");
+		else
+			printk(KERN_INFO
+			       "Enabled Interrupt-remapping\n");
+	} else
+		printk(KERN_ERR
+		       "Failed to enable Interrupt-remapping and x2apic\n");
+#else
+	if (!cpu_has_x2apic)
+		return;
+
+	if (x2apic_preenabled)
+		panic("x2apic enabled prior OS handover,"
+		      " enable CONFIG_INTR_REMAP");
+
+	printk(KERN_INFO "Enable CONFIG_INTR_REMAP for enabling intr-remapping "
+	       " and x2apic\n");
+#endif
+
+	return;
+}
+#endif /* HAVE_X2APIC */
+
+#ifdef CONFIG_X86_64
+/*
+ * Detect and enable local APICs on non-SMP boards.
+ * Original code written by Keir Fraser.
+ * On AMD64 we trust the BIOS - if it says no APIC it is likely
+ * not correctly set up (usually the APIC timer won't work etc.)
+ */
+static int __init detect_init_APIC(void)
+{
+	if (!cpu_has_apic) {
+		printk(KERN_INFO "No local APIC present\n");
+		return -1;
+	}
+
+	mp_lapic_addr = APIC_DEFAULT_PHYS_BASE;
+	boot_cpu_physical_apicid = 0;
+	return 0;
+}
+#else
 /*
  * Detect and initialize APIC
  */
@@ -1255,12 +1515,46 @@ no_apic:
 	printk(KERN_INFO "No local APIC present or hardware disabled\n");
 	return -1;
 }
+#endif
+
+#ifdef CONFIG_X86_64
+void __init early_init_lapic_mapping(void)
+{
+	unsigned long phys_addr;
+
+	/*
+	 * If no local APIC can be found then go out
+	 * : it means there is no mpatable and MADT
+	 */
+	if (!smp_found_config)
+		return;
+
+	phys_addr = mp_lapic_addr;
+
+	set_fixmap_nocache(FIX_APIC_BASE, phys_addr);
+	apic_printk(APIC_VERBOSE, "mapped APIC to %16lx (%16lx)\n",
+		    APIC_BASE, phys_addr);
+
+	/*
+	 * Fetch the APIC ID of the BSP in case we have a
+	 * default configuration (or the MP table is broken).
+	 */
+	boot_cpu_physical_apicid = read_apic_id();
+}
+#endif
 
 /**
  * init_apic_mappings - initialize APIC mappings
  */
 void __init init_apic_mappings(void)
 {
+#ifdef HAVE_X2APIC
+	if (x2apic) {
+		boot_cpu_physical_apicid = read_apic_id();
+		return;
+	}
+#endif
+
 	/*
 	 * If no local APIC can be found then set up a fake all
 	 * zeroes page to simulate the local APIC and another
@@ -1273,8 +1567,8 @@ void __init init_apic_mappings(void)
 		apic_phys = mp_lapic_addr;
 
 	set_fixmap_nocache(FIX_APIC_BASE, apic_phys);
-	printk(KERN_DEBUG "mapped APIC to %08lx (%08lx)\n", APIC_BASE,
-	       apic_phys);
+	apic_printk(APIC_VERBOSE, "mapped APIC to %08lx (%08lx)\n",
+				APIC_BASE, apic_phys);
 
 	/*
 	 * Fetch the APIC ID of the BSP in case we have a
@@ -1282,18 +1576,27 @@ void __init init_apic_mappings(void)
 	 */
 	if (boot_cpu_physical_apicid == -1U)
 		boot_cpu_physical_apicid = read_apic_id();
-
 }
 
 /*
  * This initializes the IO-APIC and APIC hardware if this is
  * a UP kernel.
  */
-
 int apic_version[MAX_APICS];
 
 int __init APIC_init_uniprocessor(void)
 {
+#ifdef CONFIG_X86_64
+	if (disable_apic) {
+		printk(KERN_INFO "Apic disabled\n");
+		return -1;
+	}
+	if (!cpu_has_apic) {
+		disable_apic = 1;
+		printk(KERN_INFO "Apic disabled by BIOS\n");
+		return -1;
+	}
+#else
 	if (!smp_found_config && !cpu_has_apic)
 		return -1;
 
@@ -1302,39 +1605,68 @@ int __init APIC_init_uniprocessor(void)
 	 */
 	if (!cpu_has_apic &&
 	    APIC_INTEGRATED(apic_version[boot_cpu_physical_apicid])) {
-		printk(KERN_ERR "BIOS bug, local APIC #%d not detected!...\n",
+		printk(KERN_ERR "BIOS bug, local APIC 0x%x not detected!...\n",
 		       boot_cpu_physical_apicid);
 		clear_cpu_cap(&boot_cpu_data, X86_FEATURE_APIC);
 		return -1;
 	}
+#endif
 
-	verify_local_APIC();
+#ifdef HAVE_X2APIC
+	enable_IR_x2apic();
+#endif
+#ifdef CONFIG_X86_64
+	setup_apic_routing();
+#endif
 
+	verify_local_APIC();
 	connect_bsp_APIC();
 
+#ifdef CONFIG_X86_64
+	apic_write(APIC_ID, SET_APIC_ID(boot_cpu_physical_apicid));
+#else
 	/*
 	 * Hack: In case of kdump, after a crash, kernel might be booting
 	 * on a cpu with non-zero lapic id. But boot_cpu_physical_apicid
 	 * might be zero if read from MP tables. Get it from LAPIC.
 	 */
-#ifdef CONFIG_CRASH_DUMP
+# ifdef CONFIG_CRASH_DUMP
 	boot_cpu_physical_apicid = read_apic_id();
+# endif
 #endif
 	physid_set_mask_of_physid(boot_cpu_physical_apicid, &phys_cpu_present_map);
-
 	setup_local_APIC();
 
+#ifdef CONFIG_X86_64
+	/*
+	 * Now enable IO-APICs, actually call clear_IO_APIC
+	 * We need clear_IO_APIC before enabling vector on BP
+	 */
+	if (!skip_ioapic_setup && nr_ioapics)
+		enable_IO_APIC();
+#endif
+
 #ifdef CONFIG_X86_IO_APIC
 	if (!smp_found_config || skip_ioapic_setup || !nr_ioapics)
 #endif
 		localise_nmi_watchdog();
 	end_local_APIC_setup();
+
 #ifdef CONFIG_X86_IO_APIC
-	if (smp_found_config)
-		if (!skip_ioapic_setup && nr_ioapics)
-			setup_IO_APIC();
+	if (smp_found_config && !skip_ioapic_setup && nr_ioapics)
+		setup_IO_APIC();
+# ifdef CONFIG_X86_64
+	else
+		nr_ioapics = 0;
+# endif
 #endif
+
+#ifdef CONFIG_X86_64
+	setup_boot_APIC_clock();
+	check_nmi_watchdog();
+#else
 	setup_boot_clock();
+#endif
 
 	return 0;
 }
@@ -1348,8 +1680,11 @@ int __init APIC_init_uniprocessor(void)
  */
 void smp_spurious_interrupt(struct pt_regs *regs)
 {
-	unsigned long v;
+	u32 v;
 
+#ifdef CONFIG_X86_64
+	exit_idle();
+#endif
 	irq_enter();
 	/*
 	 * Check if this really is a spurious interrupt and ACK it
@@ -1360,10 +1695,14 @@ void smp_spurious_interrupt(struct pt_regs *regs)
 	if (v & (1 << (SPURIOUS_APIC_VECTOR & 0x1f)))
 		ack_APIC_irq();
 
+#ifdef CONFIG_X86_64
+	add_pda(irq_spurious_count, 1);
+#else
 	/* see sw-dev-man vol 3, chapter 7.4.13.5 */
 	printk(KERN_INFO "spurious APIC interrupt on CPU#%d, "
 	       "should never happen.\n", smp_processor_id());
 	__get_cpu_var(irq_stat).irq_spurious_count++;
+#endif
 	irq_exit();
 }
 
@@ -1372,8 +1711,11 @@ void smp_spurious_interrupt(struct pt_regs *regs)
  */
 void smp_error_interrupt(struct pt_regs *regs)
 {
-	unsigned long v, v1;
+	u32 v, v1;
 
+#ifdef CONFIG_X86_64
+	exit_idle();
+#endif
 	irq_enter();
 	/* First tickle the hardware, only then report what went on. -- REW */
 	v = apic_read(APIC_ESR);
@@ -1392,7 +1734,7 @@ void smp_error_interrupt(struct pt_regs *regs)
 	   6: Received illegal vector
 	   7: Illegal register address
 	*/
-	printk(KERN_DEBUG "APIC error on CPU%d: %02lx(%02lx)\n",
+	printk(KERN_DEBUG "APIC error on CPU%d: %02x(%02x)\n",
 		smp_processor_id(), v , v1);
 	irq_exit();
 }
@@ -1565,6 +1907,13 @@ void __cpuinit generic_processor_info(int apicid, int version)
 	cpu_set(cpu, cpu_present_map);
 }
 
+#ifdef CONFIG_X86_64
+int hard_smp_processor_id(void)
+{
+	return read_apic_id();
+}
+#endif
+
 /*
  * Power management
  */
@@ -1640,7 +1989,7 @@ static int lapic_resume(struct sys_device *dev)
 
 	local_irq_save(flags);
 
-#ifdef CONFIG_X86_64
+#ifdef HAVE_X2APIC
 	if (x2apic)
 		enable_x2apic();
 	else
@@ -1702,7 +2051,7 @@ static struct sys_device device_lapic = {
 	.cls	= &lapic_sysclass,
 };
 
-static void __devinit apic_pm_activate(void)
+static void __cpuinit apic_pm_activate(void)
 {
 	apic_pm_state.active = 1;
 }
@@ -1728,16 +2077,87 @@ static void apic_pm_activate(void) { }
 
 #endif	/* CONFIG_PM */
 
+#ifdef CONFIG_X86_64
 /*
- * APIC command line parameters
+ * apic_is_clustered_box() -- Check if we can expect good TSC
+ *
+ * Thus far, the major user of this is IBM's Summit2 series:
+ *
+ * Clustered boxes may have unsynced TSC problems if they are
+ * multi-chassis. Use available data to take a good guess.
+ * If in doubt, go HPET.
  */
-static int __init parse_lapic(char *arg)
+__cpuinit int apic_is_clustered_box(void)
 {
-	force_enable_local_apic = 1;
-	return 0;
+	int i, clusters, zeros;
+	unsigned id;
+	u16 *bios_cpu_apicid;
+	DECLARE_BITMAP(clustermap, NUM_APIC_CLUSTERS);
+
+	/*
+	 * there is not this kind of box with AMD CPU yet.
+	 * Some AMD box with quadcore cpu and 8 sockets apicid
+	 * will be [4, 0x23] or [8, 0x27] could be thought to
+	 * vsmp box still need checking...
+	 */
+	if ((boot_cpu_data.x86_vendor == X86_VENDOR_AMD) && !is_vsmp_box())
+		return 0;
+
+	bios_cpu_apicid = early_per_cpu_ptr(x86_bios_cpu_apicid);
+	bitmap_zero(clustermap, NUM_APIC_CLUSTERS);
+
+	for (i = 0; i < NR_CPUS; i++) {
+		/* are we being called early in kernel startup? */
+		if (bios_cpu_apicid) {
+			id = bios_cpu_apicid[i];
+		}
+		else if (i < nr_cpu_ids) {
+			if (cpu_present(i))
+				id = per_cpu(x86_bios_cpu_apicid, i);
+			else
+				continue;
+		}
+		else
+			break;
+
+		if (id != BAD_APICID)
+			__set_bit(APIC_CLUSTERID(id), clustermap);
+	}
+
+	/* Problem:  Partially populated chassis may not have CPUs in some of
+	 * the APIC clusters they have been allocated.  Only present CPUs have
+	 * x86_bios_cpu_apicid entries, thus causing zeroes in the bitmap.
+	 * Since clusters are allocated sequentially, count zeros only if
+	 * they are bounded by ones.
+	 */
+	clusters = 0;
+	zeros = 0;
+	for (i = 0; i < NUM_APIC_CLUSTERS; i++) {
+		if (test_bit(i, clustermap)) {
+			clusters += 1 + zeros;
+			zeros = 0;
+		} else
+			++zeros;
+	}
+
+	/* ScaleMP vSMPowered boxes have one cluster per board and TSCs are
+	 * not guaranteed to be synced between boards
+	 */
+	if (is_vsmp_box() && clusters > 1)
+		return 1;
+
+	/*
+	 * If clusters > 2, then should be multi-chassis.
+	 * May have to revisit this when multi-core + hyperthreaded CPUs come
+	 * out, but AFAIK this will work even for them.
+	 */
+	return (clusters > 2);
 }
-early_param("lapic", parse_lapic);
+#endif
 
+/*
+ * APIC command line parameters
+ */
 static int __init setup_disableapic(char *arg)
 {
 	disable_apic = 1;
@@ -1779,7 +2199,6 @@ static int __init apic_set_verbosity(char *arg)
 	if (!arg)  {
 #ifdef CONFIG_X86_64
 		skip_ioapic_setup = 0;
-		ioapic_force = 1;
 		return 0;
 #endif
 		return -EINVAL;
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
deleted file mode 100644
index 94ddb69..0000000
--- a/arch/x86/kernel/apic_64.c
+++ /dev/null
@@ -1,1848 +0,0 @@
-/*
- *	Local APIC handling, local APIC timers
- *
- *	(c) 1999, 2000 Ingo Molnar <mingo@redhat.com>
- *
- *	Fixes
- *	Maciej W. Rozycki	:	Bits for genuine 82489DX APICs;
- *					thanks to Eric Gilmore
- *					and Rolf G. Tews
- *					for testing these extensively.
- *	Maciej W. Rozycki	:	Various updates and fixes.
- *	Mikael Pettersson	:	Power Management for UP-APIC.
- *	Pavel Machek and
- *	Mikael Pettersson	:	PM converted to driver model.
- */
-
-#include <linux/init.h>
-
-#include <linux/mm.h>
-#include <linux/delay.h>
-#include <linux/bootmem.h>
-#include <linux/interrupt.h>
-#include <linux/mc146818rtc.h>
-#include <linux/kernel_stat.h>
-#include <linux/sysdev.h>
-#include <linux/ioport.h>
-#include <linux/clockchips.h>
-#include <linux/acpi_pmtmr.h>
-#include <linux/module.h>
-#include <linux/dmar.h>
-
-#include <asm/atomic.h>
-#include <asm/smp.h>
-#include <asm/mtrr.h>
-#include <asm/mpspec.h>
-#include <asm/hpet.h>
-#include <asm/pgalloc.h>
-#include <asm/nmi.h>
-#include <asm/idle.h>
-#include <asm/proto.h>
-#include <asm/timex.h>
-#include <asm/apic.h>
-#include <asm/i8259.h>
-
-#include <mach_ipi.h>
-#include <mach_apic.h>
-
-/* Disable local APIC timer from the kernel commandline or via dmi quirk */
-static int disable_apic_timer __cpuinitdata;
-static int apic_calibrate_pmtmr __initdata;
-int disable_apic;
-int disable_x2apic;
-int x2apic;
-
-/* x2apic enabled before OS handover */
-int x2apic_preenabled;
-
-/* Local APIC timer works in C2 */
-int local_apic_timer_c2_ok;
-EXPORT_SYMBOL_GPL(local_apic_timer_c2_ok);
-
-/*
- * Debug level, exported for io_apic.c
- */
-unsigned int apic_verbosity;
-
-/* Have we found an MP table */
-int smp_found_config;
-
-static struct resource lapic_resource = {
-	.name = "Local APIC",
-	.flags = IORESOURCE_MEM | IORESOURCE_BUSY,
-};
-
-static unsigned int calibration_result;
-
-static int lapic_next_event(unsigned long delta,
-			    struct clock_event_device *evt);
-static void lapic_timer_setup(enum clock_event_mode mode,
-			      struct clock_event_device *evt);
-static void lapic_timer_broadcast(cpumask_t mask);
-static void apic_pm_activate(void);
-
-/*
- * The local apic timer can be used for any function which is CPU local.
- */
-static struct clock_event_device lapic_clockevent = {
-	.name		= "lapic",
-	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT
-			| CLOCK_EVT_FEAT_C3STOP | CLOCK_EVT_FEAT_DUMMY,
-	.shift		= 32,
-	.set_mode	= lapic_timer_setup,
-	.set_next_event	= lapic_next_event,
-	.broadcast	= lapic_timer_broadcast,
-	.rating		= 100,
-	.irq		= -1,
-};
-static DEFINE_PER_CPU(struct clock_event_device, lapic_events);
-
-static unsigned long apic_phys;
-
-unsigned long mp_lapic_addr;
-
-/*
- * Get the LAPIC version
- */
-static inline int lapic_get_version(void)
-{
-	return GET_APIC_VERSION(apic_read(APIC_LVR));
-}
-
-/*
- * Check, if the APIC is integrated or a separate chip
- */
-static inline int lapic_is_integrated(void)
-{
-#ifdef CONFIG_X86_64
-	return 1;
-#else
-	return APIC_INTEGRATED(lapic_get_version());
-#endif
-}
-
-/*
- * Check, whether this is a modern or a first generation APIC
- */
-static int modern_apic(void)
-{
-	/* AMD systems use old APIC versions, so check the CPU */
-	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD &&
-	    boot_cpu_data.x86 >= 0xf)
-		return 1;
-	return lapic_get_version() >= 0x14;
-}
-
-/*
- * Paravirt kernels also might be using these below ops. So we still
- * use generic apic_read()/apic_write(), which might be pointing to different
- * ops in PARAVIRT case.
- */
-void xapic_wait_icr_idle(void)
-{
-	while (apic_read(APIC_ICR) & APIC_ICR_BUSY)
-		cpu_relax();
-}
-
-u32 safe_xapic_wait_icr_idle(void)
-{
-	u32 send_status;
-	int timeout;
-
-	timeout = 0;
-	do {
-		send_status = apic_read(APIC_ICR) & APIC_ICR_BUSY;
-		if (!send_status)
-			break;
-		udelay(100);
-	} while (timeout++ < 1000);
-
-	return send_status;
-}
-
-void xapic_icr_write(u32 low, u32 id)
-{
-	apic_write(APIC_ICR2, SET_APIC_DEST_FIELD(id));
-	apic_write(APIC_ICR, low);
-}
-
-u64 xapic_icr_read(void)
-{
-	u32 icr1, icr2;
-
-	icr2 = apic_read(APIC_ICR2);
-	icr1 = apic_read(APIC_ICR);
-
-	return icr1 | ((u64)icr2 << 32);
-}
-
-static struct apic_ops xapic_ops = {
-	.read = native_apic_mem_read,
-	.write = native_apic_mem_write,
-	.icr_read = xapic_icr_read,
-	.icr_write = xapic_icr_write,
-	.wait_icr_idle = xapic_wait_icr_idle,
-	.safe_wait_icr_idle = safe_xapic_wait_icr_idle,
-};
-
-struct apic_ops __read_mostly *apic_ops = &xapic_ops;
-EXPORT_SYMBOL_GPL(apic_ops);
-
-static void x2apic_wait_icr_idle(void)
-{
-	/* no need to wait for icr idle in x2apic */
-	return;
-}
-
-static u32 safe_x2apic_wait_icr_idle(void)
-{
-	/* no need to wait for icr idle in x2apic */
-	return 0;
-}
-
-void x2apic_icr_write(u32 low, u32 id)
-{
-	wrmsrl(APIC_BASE_MSR + (APIC_ICR >> 4), ((__u64) id) << 32 | low);
-}
-
-u64 x2apic_icr_read(void)
-{
-	unsigned long val;
-
-	rdmsrl(APIC_BASE_MSR + (APIC_ICR >> 4), val);
-	return val;
-}
-
-static struct apic_ops x2apic_ops = {
-	.read = native_apic_msr_read,
-	.write = native_apic_msr_write,
-	.icr_read = x2apic_icr_read,
-	.icr_write = x2apic_icr_write,
-	.wait_icr_idle = x2apic_wait_icr_idle,
-	.safe_wait_icr_idle = safe_x2apic_wait_icr_idle,
-};
-
-/**
- * enable_NMI_through_LVT0 - enable NMI through local vector table 0
- */
-void __cpuinit enable_NMI_through_LVT0(void)
-{
-	unsigned int v;
-
-	/* unmask and set to NMI */
-	v = APIC_DM_NMI;
-
-	/* Level triggered for 82489DX (32bit mode) */
-	if (!lapic_is_integrated())
-		v |= APIC_LVT_LEVEL_TRIGGER;
-
-	apic_write(APIC_LVT0, v);
-}
-
-/**
- * lapic_get_maxlvt - get the maximum number of local vector table entries
- */
-int lapic_get_maxlvt(void)
-{
-	unsigned int v;
-
-	v = apic_read(APIC_LVR);
-	/*
-	 * - we always have APIC integrated on 64bit mode
-	 * - 82489DXs do not report # of LVT entries
-	 */
-	return APIC_INTEGRATED(GET_APIC_VERSION(v)) ? GET_APIC_MAXLVT(v) : 2;
-}
-
-/*
- * Local APIC timer
- */
-
-/* Clock divisor */
-#ifdef CONFG_X86_64
-#define APIC_DIVISOR 1
-#else
-#define APIC_DIVISOR 16
-#endif
-
-/*
- * This function sets up the local APIC timer, with a timeout of
- * 'clocks' APIC bus clock. During calibration we actually call
- * this function twice on the boot CPU, once with a bogus timeout
- * value, second time for real. The other (noncalibrating) CPUs
- * call this function only once, with the real, calibrated value.
- *
- * We do reads before writes even if unnecessary, to get around the
- * P5 APIC double write bug.
- */
-static void __setup_APIC_LVTT(unsigned int clocks, int oneshot, int irqen)
-{
-	unsigned int lvtt_value, tmp_value;
-
-	lvtt_value = LOCAL_TIMER_VECTOR;
-	if (!oneshot)
-		lvtt_value |= APIC_LVT_TIMER_PERIODIC;
-	if (!lapic_is_integrated())
-		lvtt_value |= SET_APIC_TIMER_BASE(APIC_TIMER_BASE_DIV);
-
-	if (!irqen)
-		lvtt_value |= APIC_LVT_MASKED;
-
-	apic_write(APIC_LVTT, lvtt_value);
-
-	/*
-	 * Divide PICLK by 16
-	 */
-	tmp_value = apic_read(APIC_TDCR);
-	apic_write(APIC_TDCR,
-		(tmp_value & ~(APIC_TDR_DIV_1 | APIC_TDR_DIV_TMBASE)) |
-		APIC_TDR_DIV_16);
-
-	if (!oneshot)
-		apic_write(APIC_TMICT, clocks / APIC_DIVISOR);
-}
-
-/*
- * Setup extended LVT, AMD specific (K8, family 10h)
- *
- * Vector mappings are hard coded. On K8 only offset 0 (APIC500) and
- * MCE interrupts are supported. Thus MCE offset must be set to 0.
- *
- * If mask=1, the LVT entry does not generate interrupts while mask=0
- * enables the vector. See also the BKDGs.
- */
-
-#define APIC_EILVT_LVTOFF_MCE 0
-#define APIC_EILVT_LVTOFF_IBS 1
-
-static void setup_APIC_eilvt(u8 lvt_off, u8 vector, u8 msg_type, u8 mask)
-{
-	unsigned long reg = (lvt_off << 4) + APIC_EILVT0;
-	unsigned int  v   = (mask << 16) | (msg_type << 8) | vector;
-
-	apic_write(reg, v);
-}
-
-u8 setup_APIC_eilvt_mce(u8 vector, u8 msg_type, u8 mask)
-{
-	setup_APIC_eilvt(APIC_EILVT_LVTOFF_MCE, vector, msg_type, mask);
-	return APIC_EILVT_LVTOFF_MCE;
-}
-
-u8 setup_APIC_eilvt_ibs(u8 vector, u8 msg_type, u8 mask)
-{
-	setup_APIC_eilvt(APIC_EILVT_LVTOFF_IBS, vector, msg_type, mask);
-	return APIC_EILVT_LVTOFF_IBS;
-}
-EXPORT_SYMBOL_GPL(setup_APIC_eilvt_ibs);
-
-/*
- * Program the next event, relative to now
- */
-static int lapic_next_event(unsigned long delta,
-			    struct clock_event_device *evt)
-{
-	apic_write(APIC_TMICT, delta);
-	return 0;
-}
-
-/*
- * Setup the lapic timer in periodic or oneshot mode
- */
-static void lapic_timer_setup(enum clock_event_mode mode,
-			      struct clock_event_device *evt)
-{
-	unsigned long flags;
-	unsigned int v;
-
-	/* Lapic used as dummy for broadcast ? */
-	if (evt->features & CLOCK_EVT_FEAT_DUMMY)
-		return;
-
-	local_irq_save(flags);
-
-	switch (mode) {
-	case CLOCK_EVT_MODE_PERIODIC:
-	case CLOCK_EVT_MODE_ONESHOT:
-		__setup_APIC_LVTT(calibration_result,
-				  mode != CLOCK_EVT_MODE_PERIODIC, 1);
-		break;
-	case CLOCK_EVT_MODE_UNUSED:
-	case CLOCK_EVT_MODE_SHUTDOWN:
-		v = apic_read(APIC_LVTT);
-		v |= (APIC_LVT_MASKED | LOCAL_TIMER_VECTOR);
-		apic_write(APIC_LVTT, v);
-		break;
-	case CLOCK_EVT_MODE_RESUME:
-		/* Nothing to do here */
-		break;
-	}
-
-	local_irq_restore(flags);
-}
-
-/*
- * Local APIC timer broadcast function
- */
-static void lapic_timer_broadcast(cpumask_t mask)
-{
-#ifdef CONFIG_SMP
-	send_IPI_mask(mask, LOCAL_TIMER_VECTOR);
-#endif
-}
-
-/*
- * Setup the local APIC timer for this CPU. Copy the initilized values
- * of the boot CPU and register the clock event in the framework.
- */
-static void setup_APIC_timer(void)
-{
-	struct clock_event_device *levt = &__get_cpu_var(lapic_events);
-
-	memcpy(levt, &lapic_clockevent, sizeof(*levt));
-	levt->cpumask = cpumask_of_cpu(smp_processor_id());
-
-	clockevents_register_device(levt);
-}
-
-/*
- * In this function we calibrate APIC bus clocks to the external
- * timer. Unfortunately we cannot use jiffies and the timer irq
- * to calibrate, since some later bootup code depends on getting
- * the first irq? Ugh.
- *
- * We want to do the calibration only once since we
- * want to have local timer irqs syncron. CPUs connected
- * by the same APIC bus have the very same bus frequency.
- * And we want to have irqs off anyways, no accidental
- * APIC irq that way.
- */
-
-#define TICK_COUNT 100000000
-
-static int __init calibrate_APIC_clock(void)
-{
-	unsigned apic, apic_start;
-	unsigned long tsc, tsc_start;
-	int result;
-
-	local_irq_disable();
-
-	/*
-	 * Put whatever arbitrary (but long enough) timeout
-	 * value into the APIC clock, we just want to get the
-	 * counter running for calibration.
-	 *
-	 * No interrupt enable !
-	 */
-	__setup_APIC_LVTT(250000000, 0, 0);
-
-	apic_start = apic_read(APIC_TMCCT);
-#ifdef CONFIG_X86_PM_TIMER
-	if (apic_calibrate_pmtmr && pmtmr_ioport) {
-		pmtimer_wait(5000);  /* 5ms wait */
-		apic = apic_read(APIC_TMCCT);
-		result = (apic_start - apic) * 1000L / 5;
-	} else
-#endif
-	{
-		rdtscll(tsc_start);
-
-		do {
-			apic = apic_read(APIC_TMCCT);
-			rdtscll(tsc);
-		} while ((tsc - tsc_start) < TICK_COUNT &&
-				(apic_start - apic) < TICK_COUNT);
-
-		result = (apic_start - apic) * 1000L * tsc_khz /
-					(tsc - tsc_start);
-	}
-
-	local_irq_enable();
-
-	printk(KERN_DEBUG "APIC timer calibration result %d\n", result);
-
-	printk(KERN_INFO "Detected %d.%03d MHz APIC timer.\n",
-		result / 1000 / 1000, result / 1000 % 1000);
-
-	/* Calculate the scaled math multiplication factor */
-	lapic_clockevent.mult = div_sc(result, NSEC_PER_SEC,
-				       lapic_clockevent.shift);
-	lapic_clockevent.max_delta_ns =
-		clockevent_delta2ns(0x7FFFFF, &lapic_clockevent);
-	lapic_clockevent.min_delta_ns =
-		clockevent_delta2ns(0xF, &lapic_clockevent);
-
-	calibration_result = (result * APIC_DIVISOR) / HZ;
-
-	/*
-	 * Do a sanity check on the APIC calibration result
-	 */
-	if (calibration_result < (1000000 / HZ)) {
-		printk(KERN_WARNING
-			"APIC frequency too slow, disabling apic timer\n");
-		return -1;
-	}
-
-	return 0;
-}
-
-/*
- * Setup the boot APIC
- *
- * Calibrate and verify the result.
- */
-void __init setup_boot_APIC_clock(void)
-{
-	/*
-	 * The local apic timer can be disabled via the kernel
-	 * commandline or from the CPU detection code. Register the lapic
-	 * timer as a dummy clock event source on SMP systems, so the
-	 * broadcast mechanism is used. On UP systems simply ignore it.
-	 */
-	if (disable_apic_timer) {
-		printk(KERN_INFO "Disabling APIC timer\n");
-		/* No broadcast on UP ! */
-		if (num_possible_cpus() > 1) {
-			lapic_clockevent.mult = 1;
-			setup_APIC_timer();
-		}
-		return;
-	}
-
-	apic_printk(APIC_VERBOSE, "Using local APIC timer interrupts.\n"
-		    "calibrating APIC timer ...\n");
-
-	if (calibrate_APIC_clock()) {
-		/* No broadcast on UP ! */
-		if (num_possible_cpus() > 1)
-			setup_APIC_timer();
-		return;
-	}
-
-	/*
-	 * If nmi_watchdog is set to IO_APIC, we need the
-	 * PIT/HPET going.  Otherwise register lapic as a dummy
-	 * device.
-	 */
-	if (nmi_watchdog != NMI_IO_APIC)
-		lapic_clockevent.features &= ~CLOCK_EVT_FEAT_DUMMY;
-	else
-		printk(KERN_WARNING "APIC timer registered as dummy,"
-			" due to nmi_watchdog=%d!\n", nmi_watchdog);
-
-	/* Setup the lapic or request the broadcast */
-	setup_APIC_timer();
-}
-
-void __cpuinit setup_secondary_APIC_clock(void)
-{
-	setup_APIC_timer();
-}
-
-/*
- * The guts of the apic timer interrupt
- */
-static void local_apic_timer_interrupt(void)
-{
-	int cpu = smp_processor_id();
-	struct clock_event_device *evt = &per_cpu(lapic_events, cpu);
-
-	/*
-	 * Normally we should not be here till LAPIC has been initialized but
-	 * in some cases like kdump, its possible that there is a pending LAPIC
-	 * timer interrupt from previous kernel's context and is delivered in
-	 * new kernel the moment interrupts are enabled.
-	 *
-	 * Interrupts are enabled early and LAPIC is setup much later, hence
-	 * its possible that when we get here evt->event_handler is NULL.
-	 * Check for event_handler being NULL and discard the interrupt as
-	 * spurious.
-	 */
-	if (!evt->event_handler) {
-		printk(KERN_WARNING
-		       "Spurious LAPIC timer interrupt on cpu %d\n", cpu);
-		/* Switch it off */
-		lapic_timer_setup(CLOCK_EVT_MODE_SHUTDOWN, evt);
-		return;
-	}
-
-	/*
-	 * the NMI deadlock-detector uses this.
-	 */
-#ifdef CONFIG_X86_64
-	add_pda(apic_timer_irqs, 1);
-#else
-	per_cpu(irq_stat, cpu).apic_timer_irqs++;
-#endif
-
-	evt->event_handler(evt);
-}
-
-/*
- * Local APIC timer interrupt. This is the most natural way for doing
- * local interrupts, but local timer interrupts can be emulated by
- * broadcast interrupts too. [in case the hw doesn't support APIC timers]
- *
- * [ if a single-CPU system runs an SMP kernel then we call the local
- *   interrupt as well. Thus we cannot inline the local irq ... ]
- */
-void smp_apic_timer_interrupt(struct pt_regs *regs)
-{
-	struct pt_regs *old_regs = set_irq_regs(regs);
-
-	/*
-	 * NOTE! We'd better ACK the irq immediately,
-	 * because timer handling can be slow.
-	 */
-	ack_APIC_irq();
-	/*
-	 * update_process_times() expects us to have done irq_enter().
-	 * Besides, if we don't timer interrupts ignore the global
-	 * interrupt lock, which is the WrongThing (tm) to do.
-	 */
-	exit_idle();
-	irq_enter();
-	local_apic_timer_interrupt();
-	irq_exit();
-
-	set_irq_regs(old_regs);
-}
-
-int setup_profiling_timer(unsigned int multiplier)
-{
-	return -EINVAL;
-}
-
-
-/*
- * Local APIC start and shutdown
- */
-
-/**
- * clear_local_APIC - shutdown the local APIC
- *
- * This is called, when a CPU is disabled and before rebooting, so the state of
- * the local APIC has no dangling leftovers. Also used to cleanout any BIOS
- * leftovers during boot.
- */
-void clear_local_APIC(void)
-{
-	int maxlvt;
-	u32 v;
-
-	/* APIC hasn't been mapped yet */
-	if (!apic_phys)
-		return;
-
-	maxlvt = lapic_get_maxlvt();
-	/*
-	 * Masking an LVT entry can trigger a local APIC error
-	 * if the vector is zero. Mask LVTERR first to prevent this.
-	 */
-	if (maxlvt >= 3) {
-		v = ERROR_APIC_VECTOR; /* any non-zero vector will do */
-		apic_write(APIC_LVTERR, v | APIC_LVT_MASKED);
-	}
-	/*
-	 * Careful: we have to set masks only first to deassert
-	 * any level-triggered sources.
-	 */
-	v = apic_read(APIC_LVTT);
-	apic_write(APIC_LVTT, v | APIC_LVT_MASKED);
-	v = apic_read(APIC_LVT0);
-	apic_write(APIC_LVT0, v | APIC_LVT_MASKED);
-	v = apic_read(APIC_LVT1);
-	apic_write(APIC_LVT1, v | APIC_LVT_MASKED);
-	if (maxlvt >= 4) {
-		v = apic_read(APIC_LVTPC);
-		apic_write(APIC_LVTPC, v | APIC_LVT_MASKED);
-	}
-
-	/* lets not touch this if we didn't frob it */
-#if defined(CONFIG_X86_MCE_P4THERMAL) || defined(X86_MCE_INTEL)
-	if (maxlvt >= 5) {
-		v = apic_read(APIC_LVTTHMR);
-		apic_write(APIC_LVTTHMR, v | APIC_LVT_MASKED);
-	}
-#endif
-	/*
-	 * Clean APIC state for other OSs:
-	 */
-	apic_write(APIC_LVTT, APIC_LVT_MASKED);
-	apic_write(APIC_LVT0, APIC_LVT_MASKED);
-	apic_write(APIC_LVT1, APIC_LVT_MASKED);
-	if (maxlvt >= 3)
-		apic_write(APIC_LVTERR, APIC_LVT_MASKED);
-	if (maxlvt >= 4)
-		apic_write(APIC_LVTPC, APIC_LVT_MASKED);
-
-	/* Integrated APIC (!82489DX) ? */
-	if (lapic_is_integrated()) {
-		if (maxlvt > 3)
-			/* Clear ESR due to Pentium errata 3AP and 11AP */
-			apic_write(APIC_ESR, 0);
-		apic_read(APIC_ESR);
-	}
-}
-
-/**
- * disable_local_APIC - clear and disable the local APIC
- */
-void disable_local_APIC(void)
-{
-	unsigned int value;
-
-	clear_local_APIC();
-
-	/*
-	 * Disable APIC (implies clearing of registers
-	 * for 82489DX!).
-	 */
-	value = apic_read(APIC_SPIV);
-	value &= ~APIC_SPIV_APIC_ENABLED;
-	apic_write(APIC_SPIV, value);
-
-#ifdef CONFIG_X86_32
-	/*
-	 * When LAPIC was disabled by the BIOS and enabled by the kernel,
-	 * restore the disabled state.
-	 */
-	if (enabled_via_apicbase) {
-		unsigned int l, h;
-
-		rdmsr(MSR_IA32_APICBASE, l, h);
-		l &= ~MSR_IA32_APICBASE_ENABLE;
-		wrmsr(MSR_IA32_APICBASE, l, h);
-	}
-#endif
-}
-
-/*
- * If Linux enabled the LAPIC against the BIOS default disable it down before
- * re-entering the BIOS on shutdown.  Otherwise the BIOS may get confused and
- * not power-off.  Additionally clear all LVT entries before disable_local_APIC
- * for the case where Linux didn't enable the LAPIC.
- */
-void lapic_shutdown(void)
-{
-	unsigned long flags;
-
-	if (!cpu_has_apic)
-		return;
-
-	local_irq_save(flags);
-
-#ifdef CONFIG_X86_32
-	if (!enabled_via_apicbase)
-		clear_local_APIC();
-	else
-#endif
-		disable_local_APIC();
-
-
-	local_irq_restore(flags);
-}
-
-/*
- * This is to verify that we're looking at a real local APIC.
- * Check these against your board if the CPUs aren't getting
- * started for no apparent reason.
- */
-int __init verify_local_APIC(void)
-{
-	unsigned int reg0, reg1;
-
-	/*
-	 * The version register is read-only in a real APIC.
-	 */
-	reg0 = apic_read(APIC_LVR);
-	apic_printk(APIC_DEBUG, "Getting VERSION: %x\n", reg0);
-	apic_write(APIC_LVR, reg0 ^ APIC_LVR_MASK);
-	reg1 = apic_read(APIC_LVR);
-	apic_printk(APIC_DEBUG, "Getting VERSION: %x\n", reg1);
-
-	/*
-	 * The two version reads above should print the same
-	 * numbers.  If the second one is different, then we
-	 * poke at a non-APIC.
-	 */
-	if (reg1 != reg0)
-		return 0;
-
-	/*
-	 * Check if the version looks reasonably.
-	 */
-	reg1 = GET_APIC_VERSION(reg0);
-	if (reg1 == 0x00 || reg1 == 0xff)
-		return 0;
-	reg1 = lapic_get_maxlvt();
-	if (reg1 < 0x02 || reg1 == 0xff)
-		return 0;
-
-	/*
-	 * The ID register is read/write in a real APIC.
-	 */
-	reg0 = apic_read(APIC_ID);
-	apic_printk(APIC_DEBUG, "Getting ID: %x\n", reg0);
-	apic_write(APIC_ID, reg0 ^ APIC_ID_MASK);
-	reg1 = apic_read(APIC_ID);
-	apic_printk(APIC_DEBUG, "Getting ID: %x\n", reg1);
-	apic_write(APIC_ID, reg0);
-	if (reg1 != (reg0 ^ APIC_ID_MASK))
-		return 0;
-
-	/*
-	 * The next two are just to see if we have sane values.
-	 * They're only really relevant if we're in Virtual Wire
-	 * compatibility mode, but most boxes are anymore.
-	 */
-	reg0 = apic_read(APIC_LVT0);
-	apic_printk(APIC_DEBUG, "Getting LVT0: %x\n", reg0);
-	reg1 = apic_read(APIC_LVT1);
-	apic_printk(APIC_DEBUG, "Getting LVT1: %x\n", reg1);
-
-	return 1;
-}
-
-/**
- * sync_Arb_IDs - synchronize APIC bus arbitration IDs
- */
-void __init sync_Arb_IDs(void)
-{
-	/*
-	 * Unsupported on P4 - see Intel Dev. Manual Vol. 3, Ch. 8.6.1 And not
-	 * needed on AMD.
-	 */
-	if (modern_apic() || boot_cpu_data.x86_vendor == X86_VENDOR_AMD)
-		return;
-
-	/*
-	 * Wait for idle.
-	 */
-	apic_wait_icr_idle();
-
-	apic_printk(APIC_DEBUG, "Synchronizing Arb IDs.\n");
-	apic_write(APIC_ICR, APIC_DEST_ALLINC |
-			APIC_INT_LEVELTRIG | APIC_DM_INIT);
-}
-
-/*
- * An initial setup of the virtual wire mode.
- */
-void __init init_bsp_APIC(void)
-{
-	unsigned int value;
-
-	/*
-	 * Don't do the setup now if we have a SMP BIOS as the
-	 * through-I/O-APIC virtual wire mode might be active.
-	 */
-	if (smp_found_config || !cpu_has_apic)
-		return;
-
-	/*
-	 * Do not trust the local APIC being empty at bootup.
-	 */
-	clear_local_APIC();
-
-	/*
-	 * Enable APIC.
-	 */
-	value = apic_read(APIC_SPIV);
-	value &= ~APIC_VECTOR_MASK;
-	value |= APIC_SPIV_APIC_ENABLED;
-
-#ifdef CONFIG_X86_32
-	/* This bit is reserved on P4/Xeon and should be cleared */
-	if ((boot_cpu_data.x86_vendor == X86_VENDOR_INTEL) &&
-	    (boot_cpu_data.x86 == 15))
-		value &= ~APIC_SPIV_FOCUS_DISABLED;
-	else
-#endif
-		value |= APIC_SPIV_FOCUS_DISABLED;
-	value |= SPURIOUS_APIC_VECTOR;
-	apic_write(APIC_SPIV, value);
-
-	/*
-	 * Set up the virtual wire mode.
-	 */
-	apic_write(APIC_LVT0, APIC_DM_EXTINT);
-	value = APIC_DM_NMI;
-	if (!lapic_is_integrated())		/* 82489DX */
-		value |= APIC_LVT_LEVEL_TRIGGER;
-	apic_write(APIC_LVT1, value);
-}
-
-static void __cpuinit lapic_setup_esr(void)
-{
-	unsigned long oldvalue, value, maxlvt;
-	if (lapic_is_integrated() && !esr_disable) {
-		if (esr_disable) {
-			/*
-			 * Something untraceable is creating bad interrupts on
-			 * secondary quads ... for the moment, just leave the
-			 * ESR disabled - we can't do anything useful with the
-			 * errors anyway - mbligh
-			 */
-			printk(KERN_INFO "Leaving ESR disabled.\n");
-			return;
-		}
-		/* !82489DX */
-		maxlvt = lapic_get_maxlvt();
-		if (maxlvt > 3)		/* Due to the Pentium erratum 3AP. */
-			apic_write(APIC_ESR, 0);
-		oldvalue = apic_read(APIC_ESR);
-
-		/* enables sending errors */
-		value = ERROR_APIC_VECTOR;
-		apic_write(APIC_LVTERR, value);
-		/*
-		 * spec says clear errors after enabling vector.
-		 */
-		if (maxlvt > 3)
-			apic_write(APIC_ESR, 0);
-		value = apic_read(APIC_ESR);
-		if (value != oldvalue)
-			apic_printk(APIC_VERBOSE, "ESR value before enabling "
-				"vector: 0x%08lx  after: 0x%08lx\n",
-				oldvalue, value);
-	} else {
-		printk(KERN_INFO "No ESR for 82489DX.\n");
-	}
-}
-
-
-/**
- * setup_local_APIC - setup the local APIC
- */
-void __cpuinit setup_local_APIC(void)
-{
-	unsigned int value;
-	int i, j;
-
-	preempt_disable();
-	value = apic_read(APIC_LVR);
-
-	BUILD_BUG_ON((SPURIOUS_APIC_VECTOR & 0x0f) != 0x0f);
-
-	/*
-	 * Double-check whether this APIC is really registered.
-	 * This is meaningless in clustered apic mode, so we skip it.
-	 */
-	if (!apic_id_registered())
-		BUG();
-
-	/*
-	 * Intel recommends to set DFR, LDR and TPR before enabling
-	 * an APIC.  See e.g. "AP-388 82489DX User's Manual" (Intel
-	 * document number 292116).  So here it goes...
-	 */
-	init_apic_ldr();
-
-	/*
-	 * Set Task Priority to 'accept all'. We never change this
-	 * later on.
-	 */
-	value = apic_read(APIC_TASKPRI);
-	value &= ~APIC_TPRI_MASK;
-	apic_write(APIC_TASKPRI, value);
-
-	/*
-	 * After a crash, we no longer service the interrupts and a pending
-	 * interrupt from previous kernel might still have ISR bit set.
-	 *
-	 * Most probably by now CPU has serviced that pending interrupt and
-	 * it might not have done the ack_APIC_irq() because it thought,
-	 * interrupt came from i8259 as ExtInt. LAPIC did not get EOI so it
-	 * does not clear the ISR bit and cpu thinks it has already serivced
-	 * the interrupt. Hence a vector might get locked. It was noticed
-	 * for timer irq (vector 0x31). Issue an extra EOI to clear ISR.
-	 */
-	for (i = APIC_ISR_NR - 1; i >= 0; i--) {
-		value = apic_read(APIC_ISR + i*0x10);
-		for (j = 31; j >= 0; j--) {
-			if (value & (1<<j))
-				ack_APIC_irq();
-		}
-	}
-
-	/*
-	 * Now that we are all set up, enable the APIC
-	 */
-	value = apic_read(APIC_SPIV);
-	value &= ~APIC_VECTOR_MASK;
-	/*
-	 * Enable APIC
-	 */
-	value |= APIC_SPIV_APIC_ENABLED;
-
-	/* We always use processor focus */
-
-	/*
-	 * Set spurious IRQ vector
-	 */
-	value |= SPURIOUS_APIC_VECTOR;
-	apic_write(APIC_SPIV, value);
-
-	/*
-	 * Set up LVT0, LVT1:
-	 *
-	 * set up through-local-APIC on the BP's LINT0. This is not
-	 * strictly necessary in pure symmetric-IO mode, but sometimes
-	 * we delegate interrupts to the 8259A.
-	 */
-	/*
-	 * TODO: set up through-local-APIC from through-I/O-APIC? --macro
-	 */
-	value = apic_read(APIC_LVT0) & APIC_LVT_MASKED;
-	if (!smp_processor_id() && !value) {
-		value = APIC_DM_EXTINT;
-		apic_printk(APIC_VERBOSE, "enabled ExtINT on CPU#%d\n",
-			    smp_processor_id());
-	} else {
-		value = APIC_DM_EXTINT | APIC_LVT_MASKED;
-		apic_printk(APIC_VERBOSE, "masked ExtINT on CPU#%d\n",
-			    smp_processor_id());
-	}
-	apic_write(APIC_LVT0, value);
-
-	/*
-	 * only the BP should see the LINT1 NMI signal, obviously.
-	 */
-	if (!smp_processor_id())
-		value = APIC_DM_NMI;
-	else
-		value = APIC_DM_NMI | APIC_LVT_MASKED;
-	apic_write(APIC_LVT1, value);
-	preempt_enable();
-}
-
-void __cpuinit end_local_APIC_setup(void)
-{
-	lapic_setup_esr();
-
-#ifdef CONFIG_X86_32
-	{
-		unsigned int value;
-		/* Disable the local apic timer */
-		value = apic_read(APIC_LVTT);
-		value |= (APIC_LVT_MASKED | LOCAL_TIMER_VECTOR);
-		apic_write(APIC_LVTT, value);
-	}
-#endif
-
-	setup_apic_nmi_watchdog(NULL);
-	apic_pm_activate();
-}
-
-void check_x2apic(void)
-{
-	int msr, msr2;
-
-	rdmsr(MSR_IA32_APICBASE, msr, msr2);
-
-	if (msr & X2APIC_ENABLE) {
-		printk("x2apic enabled by BIOS, switching to x2apic ops\n");
-		x2apic_preenabled = x2apic = 1;
-		apic_ops = &x2apic_ops;
-	}
-}
-
-void enable_x2apic(void)
-{
-	int msr, msr2;
-
-	rdmsr(MSR_IA32_APICBASE, msr, msr2);
-	if (!(msr & X2APIC_ENABLE)) {
-		printk("Enabling x2apic\n");
-		wrmsr(MSR_IA32_APICBASE, msr | X2APIC_ENABLE, 0);
-	}
-}
-
-void enable_IR_x2apic(void)
-{
-#ifdef CONFIG_INTR_REMAP
-	int ret;
-	unsigned long flags;
-
-	if (!cpu_has_x2apic)
-		return;
-
-	if (!x2apic_preenabled && disable_x2apic) {
-		printk(KERN_INFO
-		       "Skipped enabling x2apic and Interrupt-remapping "
-		       "because of nox2apic\n");
-		return;
-	}
-
-	if (x2apic_preenabled && disable_x2apic)
-		panic("Bios already enabled x2apic, can't enforce nox2apic");
-
-	if (!x2apic_preenabled && skip_ioapic_setup) {
-		printk(KERN_INFO
-		       "Skipped enabling x2apic and Interrupt-remapping "
-		       "because of skipping io-apic setup\n");
-		return;
-	}
-
-	ret = dmar_table_init();
-	if (ret) {
-		printk(KERN_INFO
-		       "dmar_table_init() failed with %d:\n", ret);
-
-		if (x2apic_preenabled)
-			panic("x2apic enabled by bios. But IR enabling failed");
-		else
-			printk(KERN_INFO
-			       "Not enabling x2apic,Intr-remapping\n");
-		return;
-	}
-
-	local_irq_save(flags);
-	mask_8259A();
-	save_mask_IO_APIC_setup();
-
-	ret = enable_intr_remapping(1);
-
-	if (ret && x2apic_preenabled) {
-		local_irq_restore(flags);
-		panic("x2apic enabled by bios. But IR enabling failed");
-	}
-
-	if (ret)
-		goto end;
-
-	if (!x2apic) {
-		x2apic = 1;
-		apic_ops = &x2apic_ops;
-		enable_x2apic();
-	}
-end:
-	if (ret)
-		/*
-		 * IR enabling failed
-		 */
-		restore_IO_APIC_setup();
-	else
-		reinit_intr_remapped_IO_APIC(x2apic_preenabled);
-
-	unmask_8259A();
-	local_irq_restore(flags);
-
-	if (!ret) {
-		if (!x2apic_preenabled)
-			printk(KERN_INFO
-			       "Enabled x2apic and interrupt-remapping\n");
-		else
-			printk(KERN_INFO
-			       "Enabled Interrupt-remapping\n");
-	} else
-		printk(KERN_ERR
-		       "Failed to enable Interrupt-remapping and x2apic\n");
-#else
-	if (!cpu_has_x2apic)
-		return;
-
-	if (x2apic_preenabled)
-		panic("x2apic enabled prior OS handover,"
-		      " enable CONFIG_INTR_REMAP");
-
-	printk(KERN_INFO "Enable CONFIG_INTR_REMAP for enabling intr-remapping "
-	       " and x2apic\n");
-#endif
-
-	return;
-}
-
-/*
- * Detect and enable local APICs on non-SMP boards.
- * Original code written by Keir Fraser.
- * On AMD64 we trust the BIOS - if it says no APIC it is likely
- * not correctly set up (usually the APIC timer won't work etc.)
- */
-static int __init detect_init_APIC(void)
-{
-	if (!cpu_has_apic) {
-		printk(KERN_INFO "No local APIC present\n");
-		return -1;
-	}
-
-	mp_lapic_addr = APIC_DEFAULT_PHYS_BASE;
-	boot_cpu_physical_apicid = 0;
-	return 0;
-}
-
-void __init early_init_lapic_mapping(void)
-{
-	unsigned long phys_addr;
-
-	/*
-	 * If no local APIC can be found then go out
-	 * : it means there is no mpatable and MADT
-	 */
-	if (!smp_found_config)
-		return;
-
-	phys_addr = mp_lapic_addr;
-
-	set_fixmap_nocache(FIX_APIC_BASE, phys_addr);
-	apic_printk(APIC_VERBOSE, "mapped APIC to %16lx (%16lx)\n",
-		    APIC_BASE, phys_addr);
-
-	/*
-	 * Fetch the APIC ID of the BSP in case we have a
-	 * default configuration (or the MP table is broken).
-	 */
-	boot_cpu_physical_apicid = read_apic_id();
-}
-
-/**
- * init_apic_mappings - initialize APIC mappings
- */
-void __init init_apic_mappings(void)
-{
-	if (x2apic) {
-		boot_cpu_physical_apicid = read_apic_id();
-		return;
-	}
-
-	/*
-	 * If no local APIC can be found then set up a fake all
-	 * zeroes page to simulate the local APIC and another
-	 * one for the IO-APIC.
-	 */
-	if (!smp_found_config && detect_init_APIC()) {
-		apic_phys = (unsigned long) alloc_bootmem_pages(PAGE_SIZE);
-		apic_phys = __pa(apic_phys);
-	} else
-		apic_phys = mp_lapic_addr;
-
-	set_fixmap_nocache(FIX_APIC_BASE, apic_phys);
-	apic_printk(APIC_VERBOSE, "mapped APIC to %16lx (%16lx)\n",
-				APIC_BASE, apic_phys);
-
-	/*
-	 * Fetch the APIC ID of the BSP in case we have a
-	 * default configuration (or the MP table is broken).
-	 */
-	boot_cpu_physical_apicid = read_apic_id();
-}
-
-/*
- * This initializes the IO-APIC and APIC hardware if this is
- * a UP kernel.
- */
-int apic_version[MAX_APICS];
-
-int __init APIC_init_uniprocessor(void)
-{
-	if (disable_apic) {
-		printk(KERN_INFO "Apic disabled\n");
-		return -1;
-	}
-	if (!cpu_has_apic) {
-		disable_apic = 1;
-		printk(KERN_INFO "Apic disabled by BIOS\n");
-		return -1;
-	}
-
-	enable_IR_x2apic();
-	setup_apic_routing();
-
-	verify_local_APIC();
-
-	connect_bsp_APIC();
-
-	physid_set_mask_of_physid(boot_cpu_physical_apicid, &phys_cpu_present_map);
-	apic_write(APIC_ID, SET_APIC_ID(boot_cpu_physical_apicid));
-
-	setup_local_APIC();
-
-	/*
-	 * Now enable IO-APICs, actually call clear_IO_APIC
-	 * We need clear_IO_APIC before enabling vector on BP
-	 */
-	if (!skip_ioapic_setup && nr_ioapics)
-		enable_IO_APIC();
-
-	if (!smp_found_config || skip_ioapic_setup || !nr_ioapics)
-		localise_nmi_watchdog();
-	end_local_APIC_setup();
-
-	if (smp_found_config && !skip_ioapic_setup && nr_ioapics)
-		setup_IO_APIC();
-	else
-		nr_ioapics = 0;
-	setup_boot_APIC_clock();
-	check_nmi_watchdog();
-	return 0;
-}
-
-/*
- * Local APIC interrupts
- */
-
-/*
- * This interrupt should _never_ happen with our APIC/SMP architecture
- */
-asmlinkage void smp_spurious_interrupt(void)
-{
-	unsigned int v;
-	exit_idle();
-	irq_enter();
-	/*
-	 * Check if this really is a spurious interrupt and ACK it
-	 * if it is a vectored one.  Just in case...
-	 * Spurious interrupts should not be ACKed.
-	 */
-	v = apic_read(APIC_ISR + ((SPURIOUS_APIC_VECTOR & ~0x1f) >> 1));
-	if (v & (1 << (SPURIOUS_APIC_VECTOR & 0x1f)))
-		ack_APIC_irq();
-
-	add_pda(irq_spurious_count, 1);
-	irq_exit();
-}
-
-/*
- * This interrupt should never happen with our APIC/SMP architecture
- */
-asmlinkage void smp_error_interrupt(void)
-{
-	unsigned int v, v1;
-
-	exit_idle();
-	irq_enter();
-	/* First tickle the hardware, only then report what went on. -- REW */
-	v = apic_read(APIC_ESR);
-	apic_write(APIC_ESR, 0);
-	v1 = apic_read(APIC_ESR);
-	ack_APIC_irq();
-	atomic_inc(&irq_err_count);
-
-	/* Here is what the APIC error bits mean:
-	   0: Send CS error
-	   1: Receive CS error
-	   2: Send accept error
-	   3: Receive accept error
-	   4: Reserved
-	   5: Send illegal vector
-	   6: Received illegal vector
-	   7: Illegal register address
-	*/
-	printk(KERN_DEBUG "APIC error on CPU%d: %02x(%02x)\n",
-		smp_processor_id(), v , v1);
-	irq_exit();
-}
-
-/**
- * connect_bsp_APIC - attach the APIC to the interrupt system
- */
-void __init connect_bsp_APIC(void)
-{
-#ifdef CONFIG_X86_32
-	if (pic_mode) {
-		/*
-		 * Do not trust the local APIC being empty at bootup.
-		 */
-		clear_local_APIC();
-		/*
-		 * PIC mode, enable APIC mode in the IMCR, i.e.  connect BSP's
-		 * local APIC to INT and NMI lines.
-		 */
-		apic_printk(APIC_VERBOSE, "leaving PIC mode, "
-				"enabling APIC mode.\n");
-		outb(0x70, 0x22);
-		outb(0x01, 0x23);
-	}
-#endif
-	enable_apic_mode();
-}
-
-/**
- * disconnect_bsp_APIC - detach the APIC from the interrupt system
- * @virt_wire_setup:	indicates, whether virtual wire mode is selected
- *
- * Virtual wire mode is necessary to deliver legacy interrupts even when the
- * APIC is disabled.
- */
-void disconnect_bsp_APIC(int virt_wire_setup)
-{
-	unsigned int value;
-
-#ifdef CONFIG_X86_32
-	if (pic_mode) {
-		/*
-		 * Put the board back into PIC mode (has an effect only on
-		 * certain older boards).  Note that APIC interrupts, including
-		 * IPIs, won't work beyond this point!  The only exception are
-		 * INIT IPIs.
-		 */
-		apic_printk(APIC_VERBOSE, "disabling APIC mode, "
-				"entering PIC mode.\n");
-		outb(0x70, 0x22);
-		outb(0x00, 0x23);
-		return;
-	}
-#endif
-
-	/* Go back to Virtual Wire compatibility mode */
-
-	/* For the spurious interrupt use vector F, and enable it */
-	value = apic_read(APIC_SPIV);
-	value &= ~APIC_VECTOR_MASK;
-	value |= APIC_SPIV_APIC_ENABLED;
-	value |= 0xf;
-	apic_write(APIC_SPIV, value);
-
-	if (!virt_wire_setup) {
-		/*
-		 * For LVT0 make it edge triggered, active high,
-		 * external and enabled
-		 */
-		value = apic_read(APIC_LVT0);
-		value &= ~(APIC_MODE_MASK | APIC_SEND_PENDING |
-			APIC_INPUT_POLARITY | APIC_LVT_REMOTE_IRR |
-			APIC_LVT_LEVEL_TRIGGER | APIC_LVT_MASKED);
-		value |= APIC_LVT_REMOTE_IRR | APIC_SEND_PENDING;
-		value = SET_APIC_DELIVERY_MODE(value, APIC_MODE_EXTINT);
-		apic_write(APIC_LVT0, value);
-	} else {
-		/* Disable LVT0 */
-		apic_write(APIC_LVT0, APIC_LVT_MASKED);
-	}
-
-	/*
-	 * For LVT1 make it edge triggered, active high,
-	 * nmi and enabled
-	 */
-	value = apic_read(APIC_LVT1);
-	value &= ~(APIC_MODE_MASK | APIC_SEND_PENDING |
-			APIC_INPUT_POLARITY | APIC_LVT_REMOTE_IRR |
-			APIC_LVT_LEVEL_TRIGGER | APIC_LVT_MASKED);
-	value |= APIC_LVT_REMOTE_IRR | APIC_SEND_PENDING;
-	value = SET_APIC_DELIVERY_MODE(value, APIC_MODE_NMI);
-	apic_write(APIC_LVT1, value);
-}
-
-void __cpuinit generic_processor_info(int apicid, int version)
-{
-	int cpu;
-	cpumask_t tmp_map;
-
-	/*
-	 * Validate version
-	 */
-	if (version == 0x0) {
-		printk(KERN_WARNING "BIOS bug, APIC version is 0 for CPU#%d! "
-				"fixing up to 0x10. (tell your hw vendor)\n",
-				version);
-		version = 0x10;
-	}
-	apic_version[apicid] = version;
-
-	if (num_processors >= NR_CPUS) {
-		printk(KERN_WARNING "WARNING: NR_CPUS limit of %i reached."
-			"  Processor ignored.\n", NR_CPUS);
-		return;
-	}
-
-	num_processors++;
-	cpus_complement(tmp_map, cpu_present_map);
-	cpu = first_cpu(tmp_map);
-
-	physid_set(apicid, phys_cpu_present_map);
-	if (apicid == boot_cpu_physical_apicid) {
-		/*
-		 * x86_bios_cpu_apicid is required to have processors listed
-		 * in same order as logical cpu numbers. Hence the first
-		 * entry is BSP, and so on.
-		 */
-		cpu = 0;
-	}
-	if (apicid > max_physical_apicid)
-		max_physical_apicid = apicid;
-
-#ifdef CONFIG_X86_32
-	/*
-	 * Would be preferable to switch to bigsmp when CONFIG_HOTPLUG_CPU=y
-	 * but we need to work other dependencies like SMP_SUSPEND etc
-	 * before this can be done without some confusion.
-	 * if (CPU_HOTPLUG_ENABLED || num_processors > 8)
-	 *       - Ashok Raj <ashok.raj@intel.com>
-	 */
-	if (max_physical_apicid >= 8) {
-		switch (boot_cpu_data.x86_vendor) {
-		case X86_VENDOR_INTEL:
-			if (!APIC_XAPIC(version)) {
-				def_to_bigsmp = 0;
-				break;
-			}
-			/* If P4 and above fall through */
-		case X86_VENDOR_AMD:
-			def_to_bigsmp = 1;
-		}
-	}
-#endif
-
-#if defined(CONFIG_X86_SMP) || defined(CONFIG_X86_64)
-	/* are we being called early in kernel startup? */
-	if (early_per_cpu_ptr(x86_cpu_to_apicid)) {
-		u16 *cpu_to_apicid = early_per_cpu_ptr(x86_cpu_to_apicid);
-		u16 *bios_cpu_apicid = early_per_cpu_ptr(x86_bios_cpu_apicid);
-
-		cpu_to_apicid[cpu] = apicid;
-		bios_cpu_apicid[cpu] = apicid;
-	} else {
-		per_cpu(x86_cpu_to_apicid, cpu) = apicid;
-		per_cpu(x86_bios_cpu_apicid, cpu) = apicid;
-	}
-#endif
-
-	cpu_set(cpu, cpu_possible_map);
-	cpu_set(cpu, cpu_present_map);
-}
-
-int hard_smp_processor_id(void)
-{
-	return read_apic_id();
-}
-
-/*
- * Power management
- */
-#ifdef CONFIG_PM
-
-static struct {
-	/*
-	 * 'active' is true if the local APIC was enabled by us and
-	 * not the BIOS; this signifies that we are also responsible
-	 * for disabling it before entering apm/acpi suspend
-	 */
-	int active;
-	/* r/w apic fields */
-	unsigned int apic_id;
-	unsigned int apic_taskpri;
-	unsigned int apic_ldr;
-	unsigned int apic_dfr;
-	unsigned int apic_spiv;
-	unsigned int apic_lvtt;
-	unsigned int apic_lvtpc;
-	unsigned int apic_lvt0;
-	unsigned int apic_lvt1;
-	unsigned int apic_lvterr;
-	unsigned int apic_tmict;
-	unsigned int apic_tdcr;
-	unsigned int apic_thmr;
-} apic_pm_state;
-
-static int lapic_suspend(struct sys_device *dev, pm_message_t state)
-{
-	unsigned long flags;
-	int maxlvt;
-
-	if (!apic_pm_state.active)
-		return 0;
-
-	maxlvt = lapic_get_maxlvt();
-
-	apic_pm_state.apic_id = apic_read(APIC_ID);
-	apic_pm_state.apic_taskpri = apic_read(APIC_TASKPRI);
-	apic_pm_state.apic_ldr = apic_read(APIC_LDR);
-	apic_pm_state.apic_dfr = apic_read(APIC_DFR);
-	apic_pm_state.apic_spiv = apic_read(APIC_SPIV);
-	apic_pm_state.apic_lvtt = apic_read(APIC_LVTT);
-	if (maxlvt >= 4)
-		apic_pm_state.apic_lvtpc = apic_read(APIC_LVTPC);
-	apic_pm_state.apic_lvt0 = apic_read(APIC_LVT0);
-	apic_pm_state.apic_lvt1 = apic_read(APIC_LVT1);
-	apic_pm_state.apic_lvterr = apic_read(APIC_LVTERR);
-	apic_pm_state.apic_tmict = apic_read(APIC_TMICT);
-	apic_pm_state.apic_tdcr = apic_read(APIC_TDCR);
-#if defined(CONFIG_X86_MCE_P4THERMAL) || defined(CONFIG_X86_MCE_INTEL)
-	if (maxlvt >= 5)
-		apic_pm_state.apic_thmr = apic_read(APIC_LVTTHMR);
-#endif
-
-	local_irq_save(flags);
-	disable_local_APIC();
-	local_irq_restore(flags);
-	return 0;
-}
-
-static int lapic_resume(struct sys_device *dev)
-{
-	unsigned int l, h;
-	unsigned long flags;
-	int maxlvt;
-
-	if (!apic_pm_state.active)
-		return 0;
-
-	maxlvt = lapic_get_maxlvt();
-
-	local_irq_save(flags);
-
-#ifdef CONFIG_X86_64
-	if (x2apic)
-		enable_x2apic();
-	else
-#endif
-	{
-		/*
-		 * Make sure the APICBASE points to the right address
-		 *
-		 * FIXME! This will be wrong if we ever support suspend on
-		 * SMP! We'll need to do this as part of the CPU restore!
-		 */
-		rdmsr(MSR_IA32_APICBASE, l, h);
-		l &= ~MSR_IA32_APICBASE_BASE;
-		l |= MSR_IA32_APICBASE_ENABLE | mp_lapic_addr;
-		wrmsr(MSR_IA32_APICBASE, l, h);
-	}
-
-	apic_write(APIC_LVTERR, ERROR_APIC_VECTOR | APIC_LVT_MASKED);
-	apic_write(APIC_ID, apic_pm_state.apic_id);
-	apic_write(APIC_DFR, apic_pm_state.apic_dfr);
-	apic_write(APIC_LDR, apic_pm_state.apic_ldr);
-	apic_write(APIC_TASKPRI, apic_pm_state.apic_taskpri);
-	apic_write(APIC_SPIV, apic_pm_state.apic_spiv);
-	apic_write(APIC_LVT0, apic_pm_state.apic_lvt0);
-	apic_write(APIC_LVT1, apic_pm_state.apic_lvt1);
-#if defined(CONFIG_X86_MCE_P4THERMAL) || defined(CONFIG_X86_MCE_INTEL)
-	if (maxlvt >= 5)
-		apic_write(APIC_LVTTHMR, apic_pm_state.apic_thmr);
-#endif
-	if (maxlvt >= 4)
-		apic_write(APIC_LVTPC, apic_pm_state.apic_lvtpc);
-	apic_write(APIC_LVTT, apic_pm_state.apic_lvtt);
-	apic_write(APIC_TDCR, apic_pm_state.apic_tdcr);
-	apic_write(APIC_TMICT, apic_pm_state.apic_tmict);
-	apic_write(APIC_ESR, 0);
-	apic_read(APIC_ESR);
-	apic_write(APIC_LVTERR, apic_pm_state.apic_lvterr);
-	apic_write(APIC_ESR, 0);
-	apic_read(APIC_ESR);
-
-	local_irq_restore(flags);
-
-	return 0;
-}
-
-/*
- * This device has no shutdown method - fully functioning local APICs
- * are needed on every CPU up until machine_halt/restart/poweroff.
- */
-
-static struct sysdev_class lapic_sysclass = {
-	.name		= "lapic",
-	.resume		= lapic_resume,
-	.suspend	= lapic_suspend,
-};
-
-static struct sys_device device_lapic = {
-	.id	= 0,
-	.cls	= &lapic_sysclass,
-};
-
-static void __cpuinit apic_pm_activate(void)
-{
-	apic_pm_state.active = 1;
-}
-
-static int __init init_lapic_sysfs(void)
-{
-	int error;
-
-	if (!cpu_has_apic)
-		return 0;
-	/* XXX: remove suspend/resume procs if !apic_pm_state.active? */
-
-	error = sysdev_class_register(&lapic_sysclass);
-	if (!error)
-		error = sysdev_register(&device_lapic);
-	return error;
-}
-device_initcall(init_lapic_sysfs);
-
-#else	/* CONFIG_PM */
-
-static void apic_pm_activate(void) { }
-
-#endif	/* CONFIG_PM */
-
-/*
- * apic_is_clustered_box() -- Check if we can expect good TSC
- *
- * Thus far, the major user of this is IBM's Summit2 series:
- *
- * Clustered boxes may have unsynced TSC problems if they are
- * multi-chassis. Use available data to take a good guess.
- * If in doubt, go HPET.
- */
-__cpuinit int apic_is_clustered_box(void)
-{
-	int i, clusters, zeros;
-	unsigned id;
-	u16 *bios_cpu_apicid;
-	DECLARE_BITMAP(clustermap, NUM_APIC_CLUSTERS);
-
-	/*
-	 * there is not this kind of box with AMD CPU yet.
-	 * Some AMD box with quadcore cpu and 8 sockets apicid
-	 * will be [4, 0x23] or [8, 0x27] could be thought to
-	 * vsmp box still need checking...
-	 */
-	if ((boot_cpu_data.x86_vendor == X86_VENDOR_AMD) && !is_vsmp_box())
-		return 0;
-
-	bios_cpu_apicid = early_per_cpu_ptr(x86_bios_cpu_apicid);
-	bitmap_zero(clustermap, NUM_APIC_CLUSTERS);
-
-	for (i = 0; i < NR_CPUS; i++) {
-		/* are we being called early in kernel startup? */
-		if (bios_cpu_apicid) {
-			id = bios_cpu_apicid[i];
-		}
-		else if (i < nr_cpu_ids) {
-			if (cpu_present(i))
-				id = per_cpu(x86_bios_cpu_apicid, i);
-			else
-				continue;
-		}
-		else
-			break;
-
-		if (id != BAD_APICID)
-			__set_bit(APIC_CLUSTERID(id), clustermap);
-	}
-
-	/* Problem:  Partially populated chassis may not have CPUs in some of
-	 * the APIC clusters they have been allocated.  Only present CPUs have
-	 * x86_bios_cpu_apicid entries, thus causing zeroes in the bitmap.
-	 * Since clusters are allocated sequentially, count zeros only if
-	 * they are bounded by ones.
-	 */
-	clusters = 0;
-	zeros = 0;
-	for (i = 0; i < NUM_APIC_CLUSTERS; i++) {
-		if (test_bit(i, clustermap)) {
-			clusters += 1 + zeros;
-			zeros = 0;
-		} else
-			++zeros;
-	}
-
-	/* ScaleMP vSMPowered boxes have one cluster per board and TSCs are
-	 * not guaranteed to be synced between boards
-	 */
-	if (is_vsmp_box() && clusters > 1)
-		return 1;
-
-	/*
-	 * If clusters > 2, then should be multi-chassis.
-	 * May have to revisit this when multi-core + hyperthreaded CPUs come
-	 * out, but AFAIK this will work even for them.
-	 */
-	return (clusters > 2);
-}
-
-static __init int setup_nox2apic(char *str)
-{
-	disable_x2apic = 1;
-	clear_cpu_cap(&boot_cpu_data, X86_FEATURE_X2APIC);
-	return 0;
-}
-early_param("nox2apic", setup_nox2apic);
-
-
-/*
- * APIC command line parameters
- */
-static int __init setup_disableapic(char *arg)
-{
-	disable_apic = 1;
-	setup_clear_cpu_cap(X86_FEATURE_APIC);
-	return 0;
-}
-early_param("disableapic", setup_disableapic);
-
-/* same as disableapic, for compatibility */
-static int __init setup_nolapic(char *arg)
-{
-	return setup_disableapic(arg);
-}
-early_param("nolapic", setup_nolapic);
-
-static int __init parse_lapic_timer_c2_ok(char *arg)
-{
-	local_apic_timer_c2_ok = 1;
-	return 0;
-}
-early_param("lapic_timer_c2_ok", parse_lapic_timer_c2_ok);
-
-static int __init parse_disable_apic_timer(char *arg)
-{
-	disable_apic_timer = 1;
-	return 0;
-}
-early_param("noapictimer", parse_disable_apic_timer);
-
-static int __init parse_nolapic_timer(char *arg)
-{
-	disable_apic_timer = 1;
-	return 0;
-}
-early_param("nolapic_timer", parse_nolapic_timer);
-
-static __init int setup_apicpmtimer(char *s)
-{
-	apic_calibrate_pmtmr = 1;
-	notsc_setup(NULL);
-	return 0;
-}
-__setup("apicpmtimer", setup_apicpmtimer);
-
-static int __init apic_set_verbosity(char *arg)
-{
-	if (!arg)  {
-#ifdef CONFIG_X86_64
-		skip_ioapic_setup = 0;
-		ioapic_force = 1;
-		return 0;
-#endif
-		return -EINVAL;
-	}
-
-	if (strcmp("debug", arg) == 0)
-		apic_verbosity = APIC_DEBUG;
-	else if (strcmp("verbose", arg) == 0)
-		apic_verbosity = APIC_VERBOSE;
-	else {
-		printk(KERN_WARNING "APIC Verbosity level %s not recognised"
-			" use apic=verbose or apic=debug\n", arg);
-		return -EINVAL;
-	}
-
-	return 0;
-}
-early_param("apic", apic_set_verbosity);
-
-static int __init lapic_insert_resource(void)
-{
-	if (!apic_phys)
-		return -1;
-
-	/* Put local APIC into the resource map. */
-	lapic_resource.start = apic_phys;
-	lapic_resource.end = lapic_resource.start + PAGE_SIZE - 1;
-	insert_resource(&iomem_resource, &lapic_resource);
-
-	return 0;
-}
-
-/*
- * need call insert after e820_reserve_resources()
- * that is using request_resource
- */
-late_initcall(lapic_insert_resource);
diff --git a/arch/x86/kernel/bios_uv.c b/arch/x86/kernel/bios_uv.c
index fdd585f..f0dfe6f 100644
--- a/arch/x86/kernel/bios_uv.c
+++ b/arch/x86/kernel/bios_uv.c
@@ -1,8 +1,6 @@
 /*
  * BIOS run time interface routines.
  *
- *  Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
- *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
  *  the Free Software Foundation; either version 2 of the License, or
@@ -16,33 +14,128 @@
  *  You should have received a copy of the GNU General Public License
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ *
+ *  Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
+ *  Copyright (c) Russ Anderson
  */
 
+#include <linux/efi.h>
+#include <asm/efi.h>
+#include <linux/io.h>
 #include <asm/uv/bios.h>
+#include <asm/uv/uv_hub.h>
+
+struct uv_systab uv_systab;
 
-const char *
-x86_bios_strerror(long status)
+s64 uv_bios_call(enum uv_bios_cmd which, u64 a1, u64 a2, u64 a3, u64 a4, u64 a5)
 {
-	const char *str;
-	switch (status) {
-	case  0: str = "Call completed without error";	break;
-	case -1: str = "Not implemented";		break;
-	case -2: str = "Invalid argument";		break;
-	case -3: str = "Call completed with error";	break;
-	default: str = "Unknown BIOS status code";	break;
-	}
-	return str;
+	struct uv_systab *tab = &uv_systab;
+
+	if (!tab->function)
+		/*
+		 * BIOS does not support UV systab
+		 */
+		return BIOS_STATUS_UNIMPLEMENTED;
+
+	return efi_call6((void *)__va(tab->function),
+					(u64)which, a1, a2, a3, a4, a5);
 }
 
-long
-x86_bios_freq_base(unsigned long which, unsigned long *ticks_per_second,
-		   unsigned long *drift_info)
+s64 uv_bios_call_irqsave(enum uv_bios_cmd which, u64 a1, u64 a2, u64 a3,
+					u64 a4, u64 a5)
 {
-	struct uv_bios_retval isrv;
+	unsigned long bios_flags;
+	s64 ret;
 
-	BIOS_CALL(isrv, BIOS_FREQ_BASE, which, 0, 0, 0, 0, 0, 0);
-	*ticks_per_second = isrv.v0;
-	*drift_info = isrv.v1;
-	return isrv.status;
+	local_irq_save(bios_flags);
+	ret = uv_bios_call(which, a1, a2, a3, a4, a5);
+	local_irq_restore(bios_flags);
+
+	return ret;
 }
-EXPORT_SYMBOL_GPL(x86_bios_freq_base);
+
+s64 uv_bios_call_reentrant(enum uv_bios_cmd which, u64 a1, u64 a2, u64 a3,
+					u64 a4, u64 a5)
+{
+	s64 ret;
+
+	preempt_disable();
+	ret = uv_bios_call(which, a1, a2, a3, a4, a5);
+	preempt_enable();
+
+	return ret;
+}
+
+
+long sn_partition_id;
+EXPORT_SYMBOL_GPL(sn_partition_id);
+long uv_coherency_id;
+EXPORT_SYMBOL_GPL(uv_coherency_id);
+long uv_region_size;
+EXPORT_SYMBOL_GPL(uv_region_size);
+int uv_type;
+
+
+s64 uv_bios_get_sn_info(int fc, int *uvtype, long *partid, long *coher,
+		long *region)
+{
+	s64 ret;
+	u64 v0, v1;
+	union partition_info_u part;
+
+	ret = uv_bios_call_irqsave(UV_BIOS_GET_SN_INFO, fc,
+				(u64)(&v0), (u64)(&v1), 0, 0);
+	if (ret != BIOS_STATUS_SUCCESS)
+		return ret;
+
+	part.val = v0;
+	if (uvtype)
+		*uvtype = part.hub_version;
+	if (partid)
+		*partid = part.partition_id;
+	if (coher)
+		*coher = part.coherence_id;
+	if (region)
+		*region = part.region_size;
+	return ret;
+}
+
+
+s64 uv_bios_freq_base(u64 clock_type, u64 *ticks_per_second)
+{
+	return uv_bios_call(UV_BIOS_FREQ_BASE, clock_type,
+			   (u64)ticks_per_second, 0, 0, 0);
+}
+EXPORT_SYMBOL_GPL(uv_bios_freq_base);
+
+
+#ifdef CONFIG_EFI
+void uv_bios_init(void)
+{
+	struct uv_systab *tab;
+
+	if ((efi.uv_systab == EFI_INVALID_TABLE_ADDR) ||
+	    (efi.uv_systab == (unsigned long)NULL)) {
+		printk(KERN_CRIT "No EFI UV System Table.\n");
+		uv_systab.function = (unsigned long)NULL;
+		return;
+	}
+
+	tab = (struct uv_systab *)ioremap(efi.uv_systab,
+					sizeof(struct uv_systab));
+	if (strncmp(tab->signature, "UVST", 4) != 0)
+		printk(KERN_ERR "bad signature in UV system table!");
+
+	/*
+	 * Copy table to permanent spot for later use.
+	 */
+	memcpy(&uv_systab, tab, sizeof(struct uv_systab));
+	iounmap(tab);
+
+	printk(KERN_INFO "EFI UV System Table Revision %d\n", tab->revision);
+}
+#else	/* !CONFIG_EFI */
+
+void uv_bios_init(void) { }
+#endif
+
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 32e7352..8f1e31d 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -249,7 +249,7 @@ static void __cpuinit srat_detect_node(struct cpuinfo_x86 *c)
 	}
 	numa_set_node(cpu, node);
 
-	printk(KERN_INFO "CPU %d/%x -> Node %d\n", cpu, apicid, node);
+	printk(KERN_INFO "CPU %d/0x%x -> Node %d\n", cpu, apicid, node);
 #endif
 }
 
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 99468db..cce0b61 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -174,7 +174,7 @@ static void __cpuinit srat_detect_node(void)
 		node = first_node(node_online_map);
 	numa_set_node(cpu, node);
 
-	printk(KERN_INFO "CPU %d/%x -> Node %d\n", cpu, apicid, node);
+	printk(KERN_INFO "CPU %d/0x%x -> Node %d\n", cpu, apicid, node);
 #endif
 }
 
diff --git a/arch/x86/kernel/efi.c b/arch/x86/kernel/efi.c
index 945a31c..1119d24 100644
--- a/arch/x86/kernel/efi.c
+++ b/arch/x86/kernel/efi.c
@@ -367,6 +367,10 @@ void __init efi_init(void)
 			efi.smbios = config_tables[i].table;
 			printk(" SMBIOS=0x%lx ", config_tables[i].table);
 		} else if (!efi_guidcmp(config_tables[i].guid,
+					UV_SYSTEM_TABLE_GUID)) {
+			efi.uv_systab = config_tables[i].table;
+			printk(" UVsystab=0x%lx ", config_tables[i].table);
+		} else if (!efi_guidcmp(config_tables[i].guid,
 					HCDP_TABLE_GUID)) {
 			efi.hcdp = config_tables[i].table;
 			printk(" HCDP=0x%lx ", config_tables[i].table);
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index b21fbfa..4d82171 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -629,7 +629,7 @@ ENTRY(interrupt)
 ENTRY(irq_entries_start)
 	RING0_INT_FRAME
 vector=0
-.rept NR_IRQS
+.rept NR_VECTORS
 	ALIGN
  .if vector
 	CFI_ADJUST_CFA_OFFSET -4
diff --git a/arch/x86/kernel/genapic_flat_64.c b/arch/x86/kernel/genapic_flat_64.c
index 9eca5ba..2ec2de8 100644
--- a/arch/x86/kernel/genapic_flat_64.c
+++ b/arch/x86/kernel/genapic_flat_64.c
@@ -179,8 +179,10 @@ static int __init physflat_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 	 * is an example).
 	 */
 	if (acpi_gbl_FADT.header.revision > FADT2_REVISION_ID &&
-		(acpi_gbl_FADT.flags & ACPI_FADT_APIC_PHYSICAL))
+		(acpi_gbl_FADT.flags & ACPI_FADT_APIC_PHYSICAL)) {
+		printk(KERN_DEBUG "system APIC only can use physical flat");
 		return 1;
+	}
 #endif
 
 	return 0;
diff --git a/arch/x86/kernel/genx2apic_uv_x.c b/arch/x86/kernel/genx2apic_uv_x.c
index 7b0ff40..bfd5328 100644
--- a/arch/x86/kernel/genx2apic_uv_x.c
+++ b/arch/x86/kernel/genx2apic_uv_x.c
@@ -284,12 +284,13 @@ static __init void map_low_mmrs(void)
 
 enum map_type {map_wb, map_uc};
 
-static __init void map_high(char *id, unsigned long base, int shift, enum map_type map_type)
+static __init void map_high(char *id, unsigned long base, int shift,
+			    int max_pnode, enum map_type map_type)
 {
 	unsigned long bytes, paddr;
 
 	paddr = base << shift;
-	bytes = (1UL << shift);
+	bytes = (1UL << shift) * (max_pnode + 1);
 	printk(KERN_INFO "UV: Map %s_HI 0x%lx - 0x%lx\n", id, paddr,
 	       					paddr + bytes);
 	if (map_type == map_uc)
@@ -305,7 +306,7 @@ static __init void map_gru_high(int max_pnode)
 
 	gru.v = uv_read_local_mmr(UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR);
 	if (gru.s.enable)
-		map_high("GRU", gru.s.base, shift, map_wb);
+		map_high("GRU", gru.s.base, shift, max_pnode, map_wb);
 }
 
 static __init void map_config_high(int max_pnode)
@@ -315,7 +316,7 @@ static __init void map_config_high(int max_pnode)
 
 	cfg.v = uv_read_local_mmr(UVH_RH_GAM_CFG_OVERLAY_CONFIG_MMR);
 	if (cfg.s.enable)
-		map_high("CONFIG", cfg.s.base, shift, map_uc);
+		map_high("CONFIG", cfg.s.base, shift, max_pnode, map_uc);
 }
 
 static __init void map_mmr_high(int max_pnode)
@@ -325,7 +326,7 @@ static __init void map_mmr_high(int max_pnode)
 
 	mmr.v = uv_read_local_mmr(UVH_RH_GAM_MMR_OVERLAY_CONFIG_MMR);
 	if (mmr.s.enable)
-		map_high("MMR", mmr.s.base, shift, map_uc);
+		map_high("MMR", mmr.s.base, shift, max_pnode, map_uc);
 }
 
 static __init void map_mmioh_high(int max_pnode)
@@ -335,17 +336,17 @@ static __init void map_mmioh_high(int max_pnode)
 
 	mmioh.v = uv_read_local_mmr(UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR);
 	if (mmioh.s.enable)
-		map_high("MMIOH", mmioh.s.base, shift, map_uc);
+		map_high("MMIOH", mmioh.s.base, shift, max_pnode, map_uc);
 }
 
 static __init void uv_rtc_init(void)
 {
-	long status, ticks_per_sec, drift;
+	long status;
+	u64 ticks_per_sec;
 
-	status =
-	    x86_bios_freq_base(BIOS_FREQ_BASE_REALTIME_CLOCK, &ticks_per_sec,
-					&drift);
-	if (status != 0 || ticks_per_sec < 100000) {
+	status = uv_bios_freq_base(BIOS_FREQ_BASE_REALTIME_CLOCK,
+					&ticks_per_sec);
+	if (status != BIOS_STATUS_SUCCESS || ticks_per_sec < 100000) {
 		printk(KERN_WARNING
 			"unable to determine platform RTC clock frequency, "
 			"guessing.\n");
@@ -355,7 +356,22 @@ static __init void uv_rtc_init(void)
 		sn_rtc_cycles_per_second = ticks_per_sec;
 }
 
-static bool uv_system_inited;
+/*
+ * Called on each cpu to initialize the per_cpu UV data area.
+ * 	ZZZ hotplug not supported yet
+ */
+void __cpuinit uv_cpu_init(void)
+{
+	/* CPU 0 initilization will be done via uv_system_init. */
+	if (!uv_blade_info)
+		return;
+
+	uv_blade_info[uv_numa_blade_id()].nr_online_cpus++;
+
+	if (get_uv_system_type() == UV_NON_UNIQUE_APIC)
+		set_x2apic_extra_bits(uv_hub_info->pnode);
+}
+
 
 void __init uv_system_init(void)
 {
@@ -411,6 +427,9 @@ void __init uv_system_init(void)
 	gnode_upper = (((unsigned long)node_id.s.node_id) &
 		       ~((1 << n_val) - 1)) << m_val;
 
+	uv_bios_init();
+	uv_bios_get_sn_info(0, &uv_type, &sn_partition_id,
+			    &uv_coherency_id, &uv_region_size);
 	uv_rtc_init();
 
 	for_each_present_cpu(cpu) {
@@ -432,7 +451,7 @@ void __init uv_system_init(void)
 		uv_cpu_hub_info(cpu)->gpa_mask = (1 << (m_val + n_val)) - 1;
 		uv_cpu_hub_info(cpu)->gnode_upper = gnode_upper;
 		uv_cpu_hub_info(cpu)->global_mmr_base = mmr_base;
-		uv_cpu_hub_info(cpu)->coherency_domain_number = 0;/* ZZZ */
+		uv_cpu_hub_info(cpu)->coherency_domain_number = uv_coherency_id;
 		uv_node_to_blade[nid] = blade;
 		uv_cpu_to_blade[cpu] = blade;
 		max_pnode = max(pnode, max_pnode);
@@ -447,21 +466,6 @@ void __init uv_system_init(void)
 	map_mmr_high(max_pnode);
 	map_config_high(max_pnode);
 	map_mmioh_high(max_pnode);
-	uv_system_inited = true;
-}
 
-/*
- * Called on each cpu to initialize the per_cpu UV data area.
- * 	ZZZ hotplug not supported yet
- */
-void __cpuinit uv_cpu_init(void)
-{
-	BUG_ON(!uv_system_inited);
-
-	uv_blade_info[uv_numa_blade_id()].nr_online_cpus++;
-
-	if (get_uv_system_type() == UV_NON_UNIQUE_APIC)
-		set_x2apic_extra_bits(uv_hub_info->pnode);
+	uv_cpu_init();
 }
-
-
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index acf62fc..77017e8 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -1,29 +1,49 @@
 #include <linux/clocksource.h>
 #include <linux/clockchips.h>
+#include <linux/interrupt.h>
+#include <linux/sysdev.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
 #include <linux/hpet.h>
 #include <linux/init.h>
-#include <linux/sysdev.h>
+#include <linux/cpu.h>
 #include <linux/pm.h>
+#include <linux/io.h>
 
 #include <asm/fixmap.h>
-#include <asm/hpet.h>
 #include <asm/i8253.h>
-#include <asm/io.h>
+#include <asm/hpet.h>
 
-#define HPET_MASK	CLOCKSOURCE_MASK(32)
-#define HPET_SHIFT	22
+#define HPET_MASK			CLOCKSOURCE_MASK(32)
+#define HPET_SHIFT			22
 
 /* FSEC = 10^-15
    NSEC = 10^-9 */
-#define FSEC_PER_NSEC	1000000L
+#define FSEC_PER_NSEC			1000000L
+
+#define HPET_DEV_USED_BIT		2
+#define HPET_DEV_USED			(1 << HPET_DEV_USED_BIT)
+#define HPET_DEV_VALID			0x8
+#define HPET_DEV_FSB_CAP		0x1000
+#define HPET_DEV_PERI_CAP		0x2000
+
+#define EVT_TO_HPET_DEV(evt) container_of(evt, struct hpet_dev, evt)
 
 /*
  * HPET address is set in acpi/boot.c, when an ACPI entry exists
  */
-unsigned long hpet_address;
-static void __iomem *hpet_virt_address;
+unsigned long				hpet_address;
+unsigned long				hpet_num_timers;
+static void __iomem			*hpet_virt_address;
+
+struct hpet_dev {
+	struct clock_event_device	evt;
+	unsigned int			num;
+	int				cpu;
+	unsigned int			irq;
+	unsigned int			flags;
+	char				name[10];
+};
 
 unsigned long hpet_readl(unsigned long a)
 {
@@ -59,7 +79,7 @@ static inline void hpet_clear_mapping(void)
 static int boot_hpet_disable;
 int hpet_force_user;
 
-static int __init hpet_setup(char* str)
+static int __init hpet_setup(char *str)
 {
 	if (str) {
 		if (!strncmp("disable", str, 7))
@@ -80,7 +100,7 @@ __setup("nohpet", disable_hpet);
 
 static inline int is_hpet_capable(void)
 {
-	return (!boot_hpet_disable && hpet_address);
+	return !boot_hpet_disable && hpet_address;
 }
 
 /*
@@ -102,6 +122,9 @@ EXPORT_SYMBOL_GPL(is_hpet_enabled);
  * timer 0 and timer 1 in case of RTC emulation.
  */
 #ifdef CONFIG_HPET
+
+static void hpet_reserve_msi_timers(struct hpet_data *hd);
+
 static void hpet_reserve_platform_timers(unsigned long id)
 {
 	struct hpet __iomem *hpet = hpet_virt_address;
@@ -111,10 +134,10 @@ static void hpet_reserve_platform_timers(unsigned long id)
 
 	nrtimers = ((id & HPET_ID_NUMBER) >> HPET_ID_NUMBER_SHIFT) + 1;
 
-	memset(&hd, 0, sizeof (hd));
-	hd.hd_phys_address = hpet_address;
-	hd.hd_address = hpet;
-	hd.hd_nirqs = nrtimers;
+	memset(&hd, 0, sizeof(hd));
+	hd.hd_phys_address	= hpet_address;
+	hd.hd_address		= hpet;
+	hd.hd_nirqs		= nrtimers;
 	hpet_reserve_timer(&hd, 0);
 
 #ifdef CONFIG_HPET_EMULATE_RTC
@@ -130,10 +153,12 @@ static void hpet_reserve_platform_timers(unsigned long id)
 	hd.hd_irq[1] = HPET_LEGACY_RTC;
 
 	for (i = 2; i < nrtimers; timer++, i++) {
-		hd.hd_irq[i] = (readl(&timer->hpet_config) & Tn_INT_ROUTE_CNF_MASK) >>
-			Tn_INT_ROUTE_CNF_SHIFT;
+		hd.hd_irq[i] = (readl(&timer->hpet_config) &
+			Tn_INT_ROUTE_CNF_MASK) >> Tn_INT_ROUTE_CNF_SHIFT;
 	}
 
+	hpet_reserve_msi_timers(&hd);
+
 	hpet_alloc(&hd);
 
 }
@@ -227,60 +252,70 @@ static void hpet_legacy_clockevent_register(void)
 	printk(KERN_DEBUG "hpet clockevent registered\n");
 }
 
-static void hpet_legacy_set_mode(enum clock_event_mode mode,
-			  struct clock_event_device *evt)
+static int hpet_setup_msi_irq(unsigned int irq);
+
+static void hpet_set_mode(enum clock_event_mode mode,
+			  struct clock_event_device *evt, int timer)
 {
 	unsigned long cfg, cmp, now;
 	uint64_t delta;
 
-	switch(mode) {
+	switch (mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
-		delta = ((uint64_t)(NSEC_PER_SEC/HZ)) * hpet_clockevent.mult;
-		delta >>= hpet_clockevent.shift;
+		delta = ((uint64_t)(NSEC_PER_SEC/HZ)) * evt->mult;
+		delta >>= evt->shift;
 		now = hpet_readl(HPET_COUNTER);
 		cmp = now + (unsigned long) delta;
-		cfg = hpet_readl(HPET_T0_CFG);
+		cfg = hpet_readl(HPET_Tn_CFG(timer));
 		cfg |= HPET_TN_ENABLE | HPET_TN_PERIODIC |
 		       HPET_TN_SETVAL | HPET_TN_32BIT;
-		hpet_writel(cfg, HPET_T0_CFG);
+		hpet_writel(cfg, HPET_Tn_CFG(timer));
 		/*
 		 * The first write after writing TN_SETVAL to the
 		 * config register sets the counter value, the second
 		 * write sets the period.
 		 */
-		hpet_writel(cmp, HPET_T0_CMP);
+		hpet_writel(cmp, HPET_Tn_CMP(timer));
 		udelay(1);
-		hpet_writel((unsigned long) delta, HPET_T0_CMP);
+		hpet_writel((unsigned long) delta, HPET_Tn_CMP(timer));
 		break;
 
 	case CLOCK_EVT_MODE_ONESHOT:
-		cfg = hpet_readl(HPET_T0_CFG);
+		cfg = hpet_readl(HPET_Tn_CFG(timer));
 		cfg &= ~HPET_TN_PERIODIC;
 		cfg |= HPET_TN_ENABLE | HPET_TN_32BIT;
-		hpet_writel(cfg, HPET_T0_CFG);
+		hpet_writel(cfg, HPET_Tn_CFG(timer));
 		break;
 
 	case CLOCK_EVT_MODE_UNUSED:
 	case CLOCK_EVT_MODE_SHUTDOWN:
-		cfg = hpet_readl(HPET_T0_CFG);
+		cfg = hpet_readl(HPET_Tn_CFG(timer));
 		cfg &= ~HPET_TN_ENABLE;
-		hpet_writel(cfg, HPET_T0_CFG);
+		hpet_writel(cfg, HPET_Tn_CFG(timer));
 		break;
 
 	case CLOCK_EVT_MODE_RESUME:
-		hpet_enable_legacy_int();
+		if (timer == 0) {
+			hpet_enable_legacy_int();
+		} else {
+			struct hpet_dev *hdev = EVT_TO_HPET_DEV(evt);
+			hpet_setup_msi_irq(hdev->irq);
+			disable_irq(hdev->irq);
+			irq_set_affinity(hdev->irq, cpumask_of_cpu(hdev->cpu));
+			enable_irq(hdev->irq);
+		}
 		break;
 	}
 }
 
-static int hpet_legacy_next_event(unsigned long delta,
-				  struct clock_event_device *evt)
+static int hpet_next_event(unsigned long delta,
+			   struct clock_event_device *evt, int timer)
 {
 	u32 cnt;
 
 	cnt = hpet_readl(HPET_COUNTER);
 	cnt += (u32) delta;
-	hpet_writel(cnt, HPET_T0_CMP);
+	hpet_writel(cnt, HPET_Tn_CMP(timer));
 
 	/*
 	 * We need to read back the CMP register to make sure that
@@ -292,6 +327,347 @@ static int hpet_legacy_next_event(unsigned long delta,
 	return (s32)((u32)hpet_readl(HPET_COUNTER) - cnt) >= 0 ? -ETIME : 0;
 }
 
+static void hpet_legacy_set_mode(enum clock_event_mode mode,
+			struct clock_event_device *evt)
+{
+	hpet_set_mode(mode, evt, 0);
+}
+
+static int hpet_legacy_next_event(unsigned long delta,
+			struct clock_event_device *evt)
+{
+	return hpet_next_event(delta, evt, 0);
+}
+
+/*
+ * HPET MSI Support
+ */
+#ifdef CONFIG_PCI_MSI
+
+static DEFINE_PER_CPU(struct hpet_dev *, cpu_hpet_dev);
+static struct hpet_dev	*hpet_devs;
+
+void hpet_msi_unmask(unsigned int irq)
+{
+	struct hpet_dev *hdev = get_irq_data(irq);
+	unsigned long cfg;
+
+	/* unmask it */
+	cfg = hpet_readl(HPET_Tn_CFG(hdev->num));
+	cfg |= HPET_TN_FSB;
+	hpet_writel(cfg, HPET_Tn_CFG(hdev->num));
+}
+
+void hpet_msi_mask(unsigned int irq)
+{
+	unsigned long cfg;
+	struct hpet_dev *hdev = get_irq_data(irq);
+
+	/* mask it */
+	cfg = hpet_readl(HPET_Tn_CFG(hdev->num));
+	cfg &= ~HPET_TN_FSB;
+	hpet_writel(cfg, HPET_Tn_CFG(hdev->num));
+}
+
+void hpet_msi_write(unsigned int irq, struct msi_msg *msg)
+{
+	struct hpet_dev *hdev = get_irq_data(irq);
+
+	hpet_writel(msg->data, HPET_Tn_ROUTE(hdev->num));
+	hpet_writel(msg->address_lo, HPET_Tn_ROUTE(hdev->num) + 4);
+}
+
+void hpet_msi_read(unsigned int irq, struct msi_msg *msg)
+{
+	struct hpet_dev *hdev = get_irq_data(irq);
+
+	msg->data = hpet_readl(HPET_Tn_ROUTE(hdev->num));
+	msg->address_lo = hpet_readl(HPET_Tn_ROUTE(hdev->num) + 4);
+	msg->address_hi = 0;
+}
+
+static void hpet_msi_set_mode(enum clock_event_mode mode,
+				struct clock_event_device *evt)
+{
+	struct hpet_dev *hdev = EVT_TO_HPET_DEV(evt);
+	hpet_set_mode(mode, evt, hdev->num);
+}
+
+static int hpet_msi_next_event(unsigned long delta,
+				struct clock_event_device *evt)
+{
+	struct hpet_dev *hdev = EVT_TO_HPET_DEV(evt);
+	return hpet_next_event(delta, evt, hdev->num);
+}
+
+static int hpet_setup_msi_irq(unsigned int irq)
+{
+	if (arch_setup_hpet_msi(irq)) {
+		destroy_irq(irq);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int hpet_assign_irq(struct hpet_dev *dev)
+{
+	unsigned int irq;
+
+	irq = create_irq();
+	if (!irq)
+		return -EINVAL;
+
+	set_irq_data(irq, dev);
+
+	if (hpet_setup_msi_irq(irq))
+		return -EINVAL;
+
+	dev->irq = irq;
+	return 0;
+}
+
+static irqreturn_t hpet_interrupt_handler(int irq, void *data)
+{
+	struct hpet_dev *dev = (struct hpet_dev *)data;
+	struct clock_event_device *hevt = &dev->evt;
+
+	if (!hevt->event_handler) {
+		printk(KERN_INFO "Spurious HPET timer interrupt on HPET timer %d\n",
+				dev->num);
+		return IRQ_HANDLED;
+	}
+
+	hevt->event_handler(hevt);
+	return IRQ_HANDLED;
+}
+
+static int hpet_setup_irq(struct hpet_dev *dev)
+{
+
+	if (request_irq(dev->irq, hpet_interrupt_handler,
+			IRQF_SHARED|IRQF_NOBALANCING, dev->name, dev))
+		return -1;
+
+	disable_irq(dev->irq);
+	irq_set_affinity(dev->irq, cpumask_of_cpu(dev->cpu));
+	enable_irq(dev->irq);
+
+	printk(KERN_DEBUG "hpet: %s irq %d for MSI\n",
+			 dev->name, dev->irq);
+
+	return 0;
+}
+
+/* This should be called in specific @cpu */
+static void init_one_hpet_msi_clockevent(struct hpet_dev *hdev, int cpu)
+{
+	struct clock_event_device *evt = &hdev->evt;
+	uint64_t hpet_freq;
+
+	WARN_ON(cpu != smp_processor_id());
+	if (!(hdev->flags & HPET_DEV_VALID))
+		return;
+
+	if (hpet_setup_msi_irq(hdev->irq))
+		return;
+
+	hdev->cpu = cpu;
+	per_cpu(cpu_hpet_dev, cpu) = hdev;
+	evt->name = hdev->name;
+	hpet_setup_irq(hdev);
+	evt->irq = hdev->irq;
+
+	evt->rating = 110;
+	evt->features = CLOCK_EVT_FEAT_ONESHOT;
+	if (hdev->flags & HPET_DEV_PERI_CAP)
+		evt->features |= CLOCK_EVT_FEAT_PERIODIC;
+
+	evt->set_mode = hpet_msi_set_mode;
+	evt->set_next_event = hpet_msi_next_event;
+	evt->shift = 32;
+
+	/*
+	 * The period is a femto seconds value. We need to calculate the
+	 * scaled math multiplication factor for nanosecond to hpet tick
+	 * conversion.
+	 */
+	hpet_freq = 1000000000000000ULL;
+	do_div(hpet_freq, hpet_period);
+	evt->mult = div_sc((unsigned long) hpet_freq,
+				      NSEC_PER_SEC, evt->shift);
+	/* Calculate the max delta */
+	evt->max_delta_ns = clockevent_delta2ns(0x7FFFFFFF, evt);
+	/* 5 usec minimum reprogramming delta. */
+	evt->min_delta_ns = 5000;
+
+	evt->cpumask = cpumask_of_cpu(hdev->cpu);
+	clockevents_register_device(evt);
+}
+
+#ifdef CONFIG_HPET
+/* Reserve at least one timer for userspace (/dev/hpet) */
+#define RESERVE_TIMERS 1
+#else
+#define RESERVE_TIMERS 0
+#endif
+
+static void hpet_msi_capability_lookup(unsigned int start_timer)
+{
+	unsigned int id;
+	unsigned int num_timers;
+	unsigned int num_timers_used = 0;
+	int i;
+
+	id = hpet_readl(HPET_ID);
+
+	num_timers = ((id & HPET_ID_NUMBER) >> HPET_ID_NUMBER_SHIFT);
+	num_timers++; /* Value read out starts from 0 */
+
+	hpet_devs = kzalloc(sizeof(struct hpet_dev) * num_timers, GFP_KERNEL);
+	if (!hpet_devs)
+		return;
+
+	hpet_num_timers = num_timers;
+
+	for (i = start_timer; i < num_timers - RESERVE_TIMERS; i++) {
+		struct hpet_dev *hdev = &hpet_devs[num_timers_used];
+		unsigned long cfg = hpet_readl(HPET_Tn_CFG(i));
+
+		/* Only consider HPET timer with MSI support */
+		if (!(cfg & HPET_TN_FSB_CAP))
+			continue;
+
+		hdev->flags = 0;
+		if (cfg & HPET_TN_PERIODIC_CAP)
+			hdev->flags |= HPET_DEV_PERI_CAP;
+		hdev->num = i;
+
+		sprintf(hdev->name, "hpet%d", i);
+		if (hpet_assign_irq(hdev))
+			continue;
+
+		hdev->flags |= HPET_DEV_FSB_CAP;
+		hdev->flags |= HPET_DEV_VALID;
+		num_timers_used++;
+		if (num_timers_used == num_possible_cpus())
+			break;
+	}
+
+	printk(KERN_INFO "HPET: %d timers in total, %d timers will be used for per-cpu timer\n",
+		num_timers, num_timers_used);
+}
+
+#ifdef CONFIG_HPET
+static void hpet_reserve_msi_timers(struct hpet_data *hd)
+{
+	int i;
+
+	if (!hpet_devs)
+		return;
+
+	for (i = 0; i < hpet_num_timers; i++) {
+		struct hpet_dev *hdev = &hpet_devs[i];
+
+		if (!(hdev->flags & HPET_DEV_VALID))
+			continue;
+
+		hd->hd_irq[hdev->num] = hdev->irq;
+		hpet_reserve_timer(hd, hdev->num);
+	}
+}
+#endif
+
+static struct hpet_dev *hpet_get_unused_timer(void)
+{
+	int i;
+
+	if (!hpet_devs)
+		return NULL;
+
+	for (i = 0; i < hpet_num_timers; i++) {
+		struct hpet_dev *hdev = &hpet_devs[i];
+
+		if (!(hdev->flags & HPET_DEV_VALID))
+			continue;
+		if (test_and_set_bit(HPET_DEV_USED_BIT,
+			(unsigned long *)&hdev->flags))
+			continue;
+		return hdev;
+	}
+	return NULL;
+}
+
+struct hpet_work_struct {
+	struct delayed_work work;
+	struct completion complete;
+};
+
+static void hpet_work(struct work_struct *w)
+{
+	struct hpet_dev *hdev;
+	int cpu = smp_processor_id();
+	struct hpet_work_struct *hpet_work;
+
+	hpet_work = container_of(w, struct hpet_work_struct, work.work);
+
+	hdev = hpet_get_unused_timer();
+	if (hdev)
+		init_one_hpet_msi_clockevent(hdev, cpu);
+
+	complete(&hpet_work->complete);
+}
+
+static int hpet_cpuhp_notify(struct notifier_block *n,
+		unsigned long action, void *hcpu)
+{
+	unsigned long cpu = (unsigned long)hcpu;
+	struct hpet_work_struct work;
+	struct hpet_dev *hdev = per_cpu(cpu_hpet_dev, cpu);
+
+	switch (action & 0xf) {
+	case CPU_ONLINE:
+		INIT_DELAYED_WORK(&work.work, hpet_work);
+		init_completion(&work.complete);
+		/* FIXME: add schedule_work_on() */
+		schedule_delayed_work_on(cpu, &work.work, 0);
+		wait_for_completion(&work.complete);
+		break;
+	case CPU_DEAD:
+		if (hdev) {
+			free_irq(hdev->irq, hdev);
+			hdev->flags &= ~HPET_DEV_USED;
+			per_cpu(cpu_hpet_dev, cpu) = NULL;
+		}
+		break;
+	}
+	return NOTIFY_OK;
+}
+#else
+
+static int hpet_setup_msi_irq(unsigned int irq)
+{
+	return 0;
+}
+static void hpet_msi_capability_lookup(unsigned int start_timer)
+{
+	return;
+}
+
+#ifdef CONFIG_HPET
+static void hpet_reserve_msi_timers(struct hpet_data *hd)
+{
+	return;
+}
+#endif
+
+static int hpet_cpuhp_notify(struct notifier_block *n,
+		unsigned long action, void *hcpu)
+{
+	return NOTIFY_OK;
+}
+
+#endif
+
 /*
  * Clock source related code
  */
@@ -427,8 +803,10 @@ int __init hpet_enable(void)
 
 	if (id & HPET_ID_LEGSUP) {
 		hpet_legacy_clockevent_register();
+		hpet_msi_capability_lookup(2);
 		return 1;
 	}
+	hpet_msi_capability_lookup(0);
 	return 0;
 
 out_nohpet:
@@ -445,6 +823,8 @@ out_nohpet:
  */
 static __init int hpet_late_init(void)
 {
+	int cpu;
+
 	if (boot_hpet_disable)
 		return -ENODEV;
 
@@ -460,6 +840,13 @@ static __init int hpet_late_init(void)
 
 	hpet_reserve_platform_timers(hpet_readl(HPET_ID));
 
+	for_each_online_cpu(cpu) {
+		hpet_cpuhp_notify(NULL, CPU_ONLINE, (void *)(long)cpu);
+	}
+
+	/* This notifier should be called after workqueue is ready */
+	hotcpu_notifier(hpet_cpuhp_notify, -20);
+
 	return 0;
 }
 fs_initcall(hpet_late_init);
diff --git a/arch/x86/kernel/io_apic_64.c b/arch/x86/kernel/io_apic.c
similarity index 65%
rename from arch/x86/kernel/io_apic_64.c
rename to arch/x86/kernel/io_apic.c
index a1bec29..f959acb 100644
--- a/arch/x86/kernel/io_apic_64.c
+++ b/arch/x86/kernel/io_apic.c
@@ -27,17 +27,21 @@
 #include <linux/sched.h>
 #include <linux/pci.h>
 #include <linux/mc146818rtc.h>
+#include <linux/compiler.h>
 #include <linux/acpi.h>
+#include <linux/module.h>
 #include <linux/sysdev.h>
 #include <linux/msi.h>
 #include <linux/htirq.h>
-#include <linux/dmar.h>
-#include <linux/jiffies.h>
+#include <linux/freezer.h>
+#include <linux/kthread.h>
+#include <linux/jiffies.h>	/* time_after() */
 #ifdef CONFIG_ACPI
 #include <acpi/acpi_bus.h>
 #endif
 #include <linux/bootmem.h>
 #include <linux/dmar.h>
+#include <linux/hpet.h>
 
 #include <asm/idle.h>
 #include <asm/io.h>
@@ -46,18 +50,71 @@
 #include <asm/proto.h>
 #include <asm/acpi.h>
 #include <asm/dma.h>
+#include <asm/timer.h>
 #include <asm/i8259.h>
 #include <asm/nmi.h>
 #include <asm/msidef.h>
 #include <asm/hypertransport.h>
+#include <asm/setup.h>
 #include <asm/irq_remapping.h>
+#include <asm/hpet.h>
+#include <asm/uv/uv_hub.h>
+#include <asm/uv/uv_irq.h>
 
 #include <mach_ipi.h>
 #include <mach_apic.h>
+#include <mach_apicdef.h>
 
 #define __apicdebuginit(type) static type __init
 
+/*
+ *      Is the SiS APIC rmw bug present ?
+ *      -1 = don't know, 0 = no, 1 = yes
+ */
+int sis_apic_bug = -1;
+
+static DEFINE_SPINLOCK(ioapic_lock);
+static DEFINE_SPINLOCK(vector_lock);
+
+/*
+ * # of IRQ routing registers
+ */
+int nr_ioapic_registers[MAX_IO_APICS];
+
+/* I/O APIC entries */
+struct mp_config_ioapic mp_ioapics[MAX_IO_APICS];
+int nr_ioapics;
+
+/* MP IRQ source entries */
+struct mp_config_intsrc mp_irqs[MAX_IRQ_SOURCES];
+
+/* # of MP IRQ source entries */
+int mp_irq_entries;
+
+#if defined (CONFIG_MCA) || defined (CONFIG_EISA)
+int mp_bus_id_to_type[MAX_MP_BUSSES];
+#endif
+
+DECLARE_BITMAP(mp_bus_not_pci, MAX_MP_BUSSES);
+
+int skip_ioapic_setup;
+
+static int __init parse_noapic(char *str)
+{
+	/* disable IO-APIC */
+	disable_ioapic_setup();
+	return 0;
+}
+early_param("noapic", parse_noapic);
+
+struct irq_cfg;
+struct irq_pin_list;
 struct irq_cfg {
+	unsigned int irq;
+#ifdef CONFIG_HAVE_SPARSE_IRQ
+	struct irq_cfg *next;
+#endif
+	struct irq_pin_list *irq_2_pin;
 	cpumask_t domain;
 	cpumask_t old_domain;
 	unsigned move_cleanup_count;
@@ -66,72 +123,184 @@ struct irq_cfg {
 };
 
 /* irq_cfg is indexed by the sum of all RTEs in all I/O APICs. */
-static struct irq_cfg irq_cfg[NR_IRQS] __read_mostly = {
-	[0]  = { .domain = CPU_MASK_ALL, .vector = IRQ0_VECTOR,  },
-	[1]  = { .domain = CPU_MASK_ALL, .vector = IRQ1_VECTOR,  },
-	[2]  = { .domain = CPU_MASK_ALL, .vector = IRQ2_VECTOR,  },
-	[3]  = { .domain = CPU_MASK_ALL, .vector = IRQ3_VECTOR,  },
-	[4]  = { .domain = CPU_MASK_ALL, .vector = IRQ4_VECTOR,  },
-	[5]  = { .domain = CPU_MASK_ALL, .vector = IRQ5_VECTOR,  },
-	[6]  = { .domain = CPU_MASK_ALL, .vector = IRQ6_VECTOR,  },
-	[7]  = { .domain = CPU_MASK_ALL, .vector = IRQ7_VECTOR,  },
-	[8]  = { .domain = CPU_MASK_ALL, .vector = IRQ8_VECTOR,  },
-	[9]  = { .domain = CPU_MASK_ALL, .vector = IRQ9_VECTOR,  },
-	[10] = { .domain = CPU_MASK_ALL, .vector = IRQ10_VECTOR, },
-	[11] = { .domain = CPU_MASK_ALL, .vector = IRQ11_VECTOR, },
-	[12] = { .domain = CPU_MASK_ALL, .vector = IRQ12_VECTOR, },
-	[13] = { .domain = CPU_MASK_ALL, .vector = IRQ13_VECTOR, },
-	[14] = { .domain = CPU_MASK_ALL, .vector = IRQ14_VECTOR, },
-	[15] = { .domain = CPU_MASK_ALL, .vector = IRQ15_VECTOR, },
+static struct irq_cfg irq_cfg_legacy[] __initdata = {
+	[0]  = { .irq =  0, .domain = CPU_MASK_ALL, .vector = IRQ0_VECTOR,  },
+	[1]  = { .irq =  1, .domain = CPU_MASK_ALL, .vector = IRQ1_VECTOR,  },
+	[2]  = { .irq =  2, .domain = CPU_MASK_ALL, .vector = IRQ2_VECTOR,  },
+	[3]  = { .irq =  3, .domain = CPU_MASK_ALL, .vector = IRQ3_VECTOR,  },
+	[4]  = { .irq =  4, .domain = CPU_MASK_ALL, .vector = IRQ4_VECTOR,  },
+	[5]  = { .irq =  5, .domain = CPU_MASK_ALL, .vector = IRQ5_VECTOR,  },
+	[6]  = { .irq =  6, .domain = CPU_MASK_ALL, .vector = IRQ6_VECTOR,  },
+	[7]  = { .irq =  7, .domain = CPU_MASK_ALL, .vector = IRQ7_VECTOR,  },
+	[8]  = { .irq =  8, .domain = CPU_MASK_ALL, .vector = IRQ8_VECTOR,  },
+	[9]  = { .irq =  9, .domain = CPU_MASK_ALL, .vector = IRQ9_VECTOR,  },
+	[10] = { .irq = 10, .domain = CPU_MASK_ALL, .vector = IRQ10_VECTOR, },
+	[11] = { .irq = 11, .domain = CPU_MASK_ALL, .vector = IRQ11_VECTOR, },
+	[12] = { .irq = 12, .domain = CPU_MASK_ALL, .vector = IRQ12_VECTOR, },
+	[13] = { .irq = 13, .domain = CPU_MASK_ALL, .vector = IRQ13_VECTOR, },
+	[14] = { .irq = 14, .domain = CPU_MASK_ALL, .vector = IRQ14_VECTOR, },
+	[15] = { .irq = 15, .domain = CPU_MASK_ALL, .vector = IRQ15_VECTOR, },
 };
 
-static int assign_irq_vector(int irq, cpumask_t mask);
+static struct irq_cfg irq_cfg_init = { .irq =  -1U, };
+
+static void init_one_irq_cfg(struct irq_cfg *cfg)
+{
+	memcpy(cfg, &irq_cfg_init, sizeof(struct irq_cfg));
+}
+
+static struct irq_cfg *irq_cfgx;
 
-int first_system_vector = 0xfe;
+#ifdef CONFIG_HAVE_SPARSE_IRQ
+/*
+ * Protect the irq_cfgx_free freelist:
+ */
+static DEFINE_SPINLOCK(irq_cfg_lock);
 
-char system_vectors[NR_VECTORS] = { [0 ... NR_VECTORS-1] = SYS_VECTOR_FREE};
+static struct irq_cfg *irq_cfgx_free;
+#endif
 
-int sis_apic_bug; /* not actually supported, dummy for compile */
+static void __init init_work(void *data)
+{
+	struct dyn_array *da = data;
+	struct irq_cfg *cfg;
+	int legacy_count;
+	int i;
 
-static int no_timer_check;
+	cfg = *da->name;
 
-static int disable_timer_pin_1 __initdata;
+	memcpy(cfg, irq_cfg_legacy, sizeof(irq_cfg_legacy));
 
-int timer_through_8259 __initdata;
+	legacy_count = ARRAY_SIZE(irq_cfg_legacy);
+	for (i = legacy_count; i < *da->nr; i++)
+		init_one_irq_cfg(&cfg[i]);
 
-/* Where if anywhere is the i8259 connect in external int mode */
-static struct { int pin, apic; } ioapic_i8259 = { -1, -1 };
+#ifdef CONFIG_HAVE_SPARSE_IRQ
+	for (i = 1; i < *da->nr; i++)
+		cfg[i-1].next = &cfg[i];
 
-static DEFINE_SPINLOCK(ioapic_lock);
-static DEFINE_SPINLOCK(vector_lock);
+	irq_cfgx_free = &irq_cfgx[legacy_count];
+	irq_cfgx[legacy_count - 1].next = NULL;
+#endif
+}
 
-/*
- * # of IRQ routing registers
- */
-int nr_ioapic_registers[MAX_IO_APICS];
+#ifdef CONFIG_HAVE_SPARSE_IRQ
+/* need to be biger than size of irq_cfg_legacy */
+static int nr_irq_cfg = 32;
 
-/* I/O APIC RTE contents at the OS boot up */
-struct IO_APIC_route_entry *early_ioapic_entries[MAX_IO_APICS];
+static int __init parse_nr_irq_cfg(char *arg)
+{
+	if (arg) {
+		nr_irq_cfg = simple_strtoul(arg, NULL, 0);
+		if (nr_irq_cfg < 32)
+			nr_irq_cfg = 32;
+	}
+	return 0;
+}
 
-/* I/O APIC entries */
-struct mp_config_ioapic mp_ioapics[MAX_IO_APICS];
-int nr_ioapics;
+early_param("nr_irq_cfg", parse_nr_irq_cfg);
 
-/* MP IRQ source entries */
-struct mp_config_intsrc mp_irqs[MAX_IRQ_SOURCES];
+#define for_each_irq_cfg(irqX, cfg)           \
+        for (cfg = irq_cfgx, irqX = cfg->irq; cfg; cfg = cfg->next, irqX = cfg ? cfg->irq : -1U)
 
-/* # of MP IRQ source entries */
-int mp_irq_entries;
 
-DECLARE_BITMAP(mp_bus_not_pci, MAX_MP_BUSSES);
+DEFINE_DYN_ARRAY(irq_cfgx, sizeof(struct irq_cfg), nr_irq_cfg, PAGE_SIZE, init_work);
 
-/*
- * Rough estimation of how many shared IRQs there are, can
- * be changed anytime.
- */
-#define MAX_PLUS_SHARED_IRQS NR_IRQS
-#define PIN_MAP_SIZE (MAX_PLUS_SHARED_IRQS + NR_IRQS)
+static struct irq_cfg *irq_cfg(unsigned int irq)
+{
+	struct irq_cfg *cfg;
+
+	cfg = irq_cfgx;
+	while (cfg) {
+		if (cfg->irq == irq)
+			return cfg;
+
+		cfg = cfg->next;
+	}
+
+	return NULL;
+}
+
+static struct irq_cfg *irq_cfg_alloc(unsigned int irq)
+{
+	struct irq_cfg *cfg, *cfg_pri;
+	unsigned long flags;
+	int count = 0;
+	int i;
+
+	cfg_pri = cfg = irq_cfgx;
+	while (cfg) {
+		if (cfg->irq == irq)
+			return cfg;
+
+		cfg_pri = cfg;
+		cfg = cfg->next;
+		count++;
+	}
+
+	spin_lock_irqsave(&irq_cfg_lock, flags);
+	if (!irq_cfgx_free) {
+		unsigned long phys;
+		unsigned long total_bytes;
+		/*
+		 *  we run out of pre-allocate ones, allocate more
+		 */
+		printk(KERN_DEBUG "try to get more irq_cfg %d\n", nr_irq_cfg);
+
+		total_bytes = sizeof(struct irq_cfg) * nr_irq_cfg;
+		if (after_bootmem)
+			cfg = kzalloc(total_bytes, GFP_ATOMIC);
+		else
+			cfg = __alloc_bootmem_nopanic(total_bytes, PAGE_SIZE, 0);
 
+		if (!cfg)
+			panic("please boot with nr_irq_cfg= %d\n", count * 2);
+
+		phys = __pa(cfg);
+		printk(KERN_DEBUG "irq_cfg ==> [%#lx - %#lx]\n", phys, phys + total_bytes);
+
+		for (i = 0; i < nr_irq_cfg; i++)
+			init_one_irq_cfg(&cfg[i]);
+
+		for (i = 1; i < nr_irq_cfg; i++)
+			cfg[i-1].next = &cfg[i];
+
+		irq_cfgx_free = cfg;
+	}
+
+	cfg = irq_cfgx_free;
+	irq_cfgx_free = irq_cfgx_free->next;
+	cfg->next = NULL;
+	if (cfg_pri)
+		cfg_pri->next = cfg;
+	else
+		irq_cfgx = cfg;
+	cfg->irq = irq;
+
+	spin_unlock_irqrestore(&irq_cfg_lock, flags);
+
+	return cfg;
+}
+#else
+
+#define for_each_irq_cfg(irq, cfg)		\
+	for (irq = 0, cfg = &irq_cfgx[irq]; irq < nr_irqs; irq++, cfg = &irq_cfgx[irq])
+
+DEFINE_DYN_ARRAY(irq_cfgx, sizeof(struct irq_cfg), nr_irqs, PAGE_SIZE, init_work);
+
+struct irq_cfg *irq_cfg(unsigned int irq)
+{
+        if (irq < nr_irqs)
+                return &irq_cfgx[irq];
+
+        return NULL;
+}
+struct irq_cfg *irq_cfg_alloc(unsigned int irq)
+{
+        return irq_cfg(irq);
+}
+
+#endif
 /*
  * This is performance-critical, we want to do it O(1)
  *
@@ -139,9 +308,66 @@ DECLARE_BITMAP(mp_bus_not_pci, MAX_MP_BUSSES);
  * between pins and IRQs.
  */
 
-static struct irq_pin_list {
-	short apic, pin, next;
-} irq_2_pin[PIN_MAP_SIZE];
+struct irq_pin_list {
+	int apic, pin;
+	struct irq_pin_list *next;
+};
+
+static struct irq_pin_list *irq_2_pin_head;
+/* fill one page ? */
+static int nr_irq_2_pin = 0x100;
+static struct irq_pin_list *irq_2_pin_ptr;
+static void __init irq_2_pin_init_work(void *data)
+{
+	struct dyn_array *da = data;
+	struct irq_pin_list *pin;
+	int i;
+
+	pin = *da->name;
+
+	for (i = 1; i < *da->nr; i++)
+		pin[i-1].next = &pin[i];
+
+	irq_2_pin_ptr = &pin[0];
+}
+DEFINE_DYN_ARRAY(irq_2_pin_head, sizeof(struct irq_pin_list), nr_irq_2_pin, PAGE_SIZE, irq_2_pin_init_work);
+
+static struct irq_pin_list *get_one_free_irq_2_pin(void)
+{
+	struct irq_pin_list *pin;
+	int i;
+
+	pin = irq_2_pin_ptr;
+
+	if (pin) {
+		irq_2_pin_ptr = pin->next;
+		pin->next = NULL;
+		return pin;
+	}
+
+	/*
+	 *  we run out of pre-allocate ones, allocate more
+	 */
+	printk(KERN_DEBUG "try to get more irq_2_pin %d\n", nr_irq_2_pin);
+
+	if (after_bootmem)
+		pin = kzalloc(sizeof(struct irq_pin_list)*nr_irq_2_pin,
+				 GFP_ATOMIC);
+	else
+		pin = __alloc_bootmem_nopanic(sizeof(struct irq_pin_list) *
+				nr_irq_2_pin, PAGE_SIZE, 0);
+
+	if (!pin)
+		panic("can not get more irq_2_pin\n");
+
+	for (i = 1; i < nr_irq_2_pin; i++)
+		pin[i-1].next = &pin[i];
+
+	irq_2_pin_ptr = pin->next;
+	pin->next = NULL;
+
+	return pin;
+}
 
 struct io_apic {
 	unsigned int index;
@@ -172,10 +398,14 @@ static inline void io_apic_write(unsigned int apic, unsigned int reg, unsigned i
 /*
  * Re-write a value: to be used for read-modify-write
  * cycles where the read already set up the index register.
+ *
+ * Older SiS APIC requires we rewrite the index register
  */
-static inline void io_apic_modify(unsigned int apic, unsigned int value)
+static inline void io_apic_modify(unsigned int apic, unsigned int reg, unsigned int value)
 {
 	struct io_apic __iomem *io_apic = io_apic_base(apic);
+        if (sis_apic_bug)
+                writel(reg, &io_apic->index);
 	writel(value, &io_apic->data);
 }
 
@@ -183,16 +413,17 @@ static bool io_apic_level_ack_pending(unsigned int irq)
 {
 	struct irq_pin_list *entry;
 	unsigned long flags;
+	struct irq_cfg *cfg = irq_cfg(irq);
 
 	spin_lock_irqsave(&ioapic_lock, flags);
-	entry = irq_2_pin + irq;
+	entry = cfg->irq_2_pin;
 	for (;;) {
 		unsigned int reg;
 		int pin;
 
-		pin = entry->pin;
-		if (pin == -1)
+		if (!entry)
 			break;
+		pin = entry->pin;
 		reg = io_apic_read(entry->apic, 0x10 + pin*2);
 		/* Is the remote IRR bit set? */
 		if (reg & IO_APIC_REDIR_REMOTE_IRR) {
@@ -201,45 +432,13 @@ static bool io_apic_level_ack_pending(unsigned int irq)
 		}
 		if (!entry->next)
 			break;
-		entry = irq_2_pin + entry->next;
+		entry = entry->next;
 	}
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 
 	return false;
 }
 
-/*
- * Synchronize the IO-APIC and the CPU by doing
- * a dummy read from the IO-APIC
- */
-static inline void io_apic_sync(unsigned int apic)
-{
-	struct io_apic __iomem *io_apic = io_apic_base(apic);
-	readl(&io_apic->data);
-}
-
-#define __DO_ACTION(R, ACTION, FINAL)					\
-									\
-{									\
-	int pin;							\
-	struct irq_pin_list *entry = irq_2_pin + irq;			\
-									\
-	BUG_ON(irq >= NR_IRQS);						\
-	for (;;) {							\
-		unsigned int reg;					\
-		pin = entry->pin;					\
-		if (pin == -1)						\
-			break;						\
-		reg = io_apic_read(entry->apic, 0x10 + R + pin*2);	\
-		reg ACTION;						\
-		io_apic_modify(entry->apic, reg);			\
-		FINAL;							\
-		if (!entry->next)					\
-			break;						\
-		entry = irq_2_pin + entry->next;			\
-	}								\
-}
-
 union entry_union {
 	struct { u32 w1, w2; };
 	struct IO_APIC_route_entry entry;
@@ -299,59 +498,71 @@ static void ioapic_mask_entry(int apic, int pin)
 static void __target_IO_APIC_irq(unsigned int irq, unsigned int dest, u8 vector)
 {
 	int apic, pin;
-	struct irq_pin_list *entry = irq_2_pin + irq;
+	struct irq_cfg *cfg;
+	struct irq_pin_list *entry;
 
-	BUG_ON(irq >= NR_IRQS);
+	cfg = irq_cfg(irq);
+	entry = cfg->irq_2_pin;
 	for (;;) {
 		unsigned int reg;
+
+		if (!entry)
+			break;
+
 		apic = entry->apic;
 		pin = entry->pin;
-		if (pin == -1)
-			break;
+#ifdef CONFIG_INTR_REMAP
 		/*
 		 * With interrupt-remapping, destination information comes
 		 * from interrupt-remapping table entry.
 		 */
 		if (!irq_remapped(irq))
 			io_apic_write(apic, 0x11 + pin*2, dest);
+#else
+		io_apic_write(apic, 0x11 + pin*2, dest);
+#endif
 		reg = io_apic_read(apic, 0x10 + pin*2);
 		reg &= ~IO_APIC_REDIR_VECTOR_MASK;
 		reg |= vector;
-		io_apic_modify(apic, reg);
+		io_apic_modify(apic, 0x10 + pin*2, reg);
 		if (!entry->next)
 			break;
-		entry = irq_2_pin + entry->next;
+		entry = entry->next;
 	}
 }
 
+static int assign_irq_vector(int irq, cpumask_t mask);
+
 static void set_ioapic_affinity_irq(unsigned int irq, cpumask_t mask)
 {
-	struct irq_cfg *cfg = irq_cfg + irq;
+	struct irq_cfg *cfg;
 	unsigned long flags;
 	unsigned int dest;
 	cpumask_t tmp;
+	struct irq_desc *desc;
 
 	cpus_and(tmp, mask, cpu_online_map);
 	if (cpus_empty(tmp))
 		return;
 
+	cfg = irq_cfg(irq);
 	if (assign_irq_vector(irq, mask))
 		return;
 
 	cpus_and(tmp, cfg->domain, mask);
 	dest = cpu_mask_to_apicid(tmp);
-
 	/*
 	 * Only the high 8 bits are valid.
 	 */
 	dest = SET_APIC_LOGICAL_ID(dest);
 
+	desc = irq_to_desc(irq);
 	spin_lock_irqsave(&ioapic_lock, flags);
 	__target_IO_APIC_irq(irq, dest, cfg->vector);
-	irq_desc[irq].affinity = mask;
+	desc->affinity = mask;
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 }
-#endif
+#endif /* CONFIG_SMP */
 
 /*
  * The common case is 1:1 IRQ<->pin mappings. Sometimes there are
@@ -360,19 +571,30 @@ static void set_ioapic_affinity_irq(unsigned int irq, cpumask_t mask)
  */
 static void add_pin_to_irq(unsigned int irq, int apic, int pin)
 {
-	static int first_free_entry = NR_IRQS;
-	struct irq_pin_list *entry = irq_2_pin + irq;
+	struct irq_cfg *cfg;
+	struct irq_pin_list *entry;
 
-	BUG_ON(irq >= NR_IRQS);
-	while (entry->next)
-		entry = irq_2_pin + entry->next;
+	/* first time to refer irq_cfg, so with new */
+	cfg = irq_cfg_alloc(irq);
+	entry = cfg->irq_2_pin;
+	if (!entry) {
+		entry = get_one_free_irq_2_pin();
+		cfg->irq_2_pin = entry;
+		entry->apic = apic;
+		entry->pin = pin;
+		return;
+	}
 
-	if (entry->pin != -1) {
-		entry->next = first_free_entry;
-		entry = irq_2_pin + entry->next;
-		if (++first_free_entry >= PIN_MAP_SIZE)
-			panic("io_apic.c: ran out of irq_2_pin entries!");
+	while (entry->next) {
+		/* not again, please */
+		if (entry->apic == apic && entry->pin == pin)
+			return;
+
+		entry = entry->next;
 	}
+
+	entry->next = get_one_free_irq_2_pin();
+	entry = entry->next;
 	entry->apic = apic;
 	entry->pin = pin;
 }
@@ -384,30 +606,86 @@ static void __init replace_pin_at_irq(unsigned int irq,
 				      int oldapic, int oldpin,
 				      int newapic, int newpin)
 {
-	struct irq_pin_list *entry = irq_2_pin + irq;
+	struct irq_cfg *cfg = irq_cfg(irq);
+	struct irq_pin_list *entry = cfg->irq_2_pin;
+	int replaced = 0;
 
-	while (1) {
+	while (entry) {
 		if (entry->apic == oldapic && entry->pin == oldpin) {
 			entry->apic = newapic;
 			entry->pin = newpin;
-		}
-		if (!entry->next)
+			replaced = 1;
+			/* every one is different, right? */
 			break;
-		entry = irq_2_pin + entry->next;
+		}
+		entry = entry->next;
 	}
+
+	/* why? call replace before add? */
+	if (!replaced)
+		add_pin_to_irq(irq, newapic, newpin);
 }
 
+static inline void io_apic_modify_irq(unsigned int irq,
+				int mask_and, int mask_or,
+				void (*final)(struct irq_pin_list *entry))
+{
+	int pin;
+	struct irq_cfg *cfg;
+	struct irq_pin_list *entry;
 
-#define DO_ACTION(name,R,ACTION, FINAL)					\
-									\
-	static void name##_IO_APIC_irq (unsigned int irq)		\
-	__DO_ACTION(R, ACTION, FINAL)
+	cfg = irq_cfg(irq);
+	for (entry = cfg->irq_2_pin; entry != NULL; entry = entry->next) {
+		unsigned int reg;
+		pin = entry->pin;
+		reg = io_apic_read(entry->apic, 0x10 + pin * 2);
+		reg &= mask_and;
+		reg |= mask_or;
+		io_apic_modify(entry->apic, 0x10 + pin * 2, reg);
+		if (final)
+			final(entry);
+	}
+}
 
-/* mask = 1 */
-DO_ACTION(__mask,	0, |= IO_APIC_REDIR_MASKED, io_apic_sync(entry->apic))
+static void __unmask_IO_APIC_irq(unsigned int irq)
+{
+	io_apic_modify_irq(irq, ~IO_APIC_REDIR_MASKED, 0, NULL);
+}
 
-/* mask = 0 */
-DO_ACTION(__unmask,	0, &= ~IO_APIC_REDIR_MASKED, )
+#ifdef CONFIG_X86_64
+void io_apic_sync(struct irq_pin_list *entry)
+{
+	/*
+	 * Synchronize the IO-APIC and the CPU by doing
+	 * a dummy read from the IO-APIC
+	 */
+	struct io_apic __iomem *io_apic;
+	io_apic = io_apic_base(entry->apic);
+	readl(&io_apic->data);
+}
+
+static void __mask_IO_APIC_irq(unsigned int irq)
+{
+	io_apic_modify_irq(irq, ~0, IO_APIC_REDIR_MASKED, &io_apic_sync);
+}
+#else /* CONFIG_X86_32 */
+static void __mask_IO_APIC_irq(unsigned int irq)
+{
+	io_apic_modify_irq(irq, ~0, IO_APIC_REDIR_MASKED, NULL);
+}
+
+static void __mask_and_edge_IO_APIC_irq(unsigned int irq)
+{
+	io_apic_modify_irq(irq, ~IO_APIC_REDIR_LEVEL_TRIGGER,
+			IO_APIC_REDIR_MASKED, NULL);
+}
+
+static void __unmask_and_level_IO_APIC_irq(unsigned int irq)
+{
+	io_apic_modify_irq(irq, ~IO_APIC_REDIR_MASKED,
+			IO_APIC_REDIR_LEVEL_TRIGGER, NULL);
+}
+#endif /* CONFIG_X86_32 */
 
 static void mask_IO_APIC_irq (unsigned int irq)
 {
@@ -450,6 +728,68 @@ static void clear_IO_APIC (void)
 			clear_IO_APIC_pin(apic, pin);
 }
 
+#if !defined(CONFIG_SMP) && defined(CONFIG_X86_32)
+void send_IPI_self(int vector)
+{
+	unsigned int cfg;
+
+	/*
+	 * Wait for idle.
+	 */
+	apic_wait_icr_idle();
+	cfg = APIC_DM_FIXED | APIC_DEST_SELF | vector | APIC_DEST_LOGICAL;
+	/*
+	 * Send the IPI. The write to APIC_ICR fires this off.
+	 */
+	apic_write(APIC_ICR, cfg);
+}
+#endif /* !CONFIG_SMP && CONFIG_X86_32*/
+
+#ifdef CONFIG_X86_32
+/*
+ * support for broken MP BIOSs, enables hand-redirection of PIRQ0-7 to
+ * specific CPU-side IRQs.
+ */
+
+#define MAX_PIRQS 8
+static int pirq_entries [MAX_PIRQS];
+static int pirqs_enabled;
+
+static int __init ioapic_pirq_setup(char *str)
+{
+	int i, max;
+	int ints[MAX_PIRQS+1];
+
+	get_options(str, ARRAY_SIZE(ints), ints);
+
+	for (i = 0; i < MAX_PIRQS; i++)
+		pirq_entries[i] = -1;
+
+	pirqs_enabled = 1;
+	apic_printk(APIC_VERBOSE, KERN_INFO
+			"PIRQ redirection, working around broken MP-BIOS.\n");
+	max = MAX_PIRQS;
+	if (ints[0] < MAX_PIRQS)
+		max = ints[0];
+
+	for (i = 0; i < max; i++) {
+		apic_printk(APIC_VERBOSE, KERN_DEBUG
+				"... PIRQ%d -> IRQ %d\n", i, ints[i+1]);
+		/*
+		 * PIRQs are mapped upside down, usually.
+		 */
+		pirq_entries[MAX_PIRQS-i-1] = ints[i+1];
+	}
+	return 1;
+}
+
+__setup("pirq=", ioapic_pirq_setup);
+#endif /* CONFIG_X86_32 */
+
+#ifdef CONFIG_INTR_REMAP
+/* I/O APIC RTE contents at the OS boot up */
+static struct IO_APIC_route_entry *early_ioapic_entries[MAX_IO_APICS];
+
 /*
  * Saves and masks all the unmasked IO-APIC RTE's
  */
@@ -474,7 +814,7 @@ int save_mask_IO_APIC_setup(void)
 			kzalloc(sizeof(struct IO_APIC_route_entry) *
 				nr_ioapic_registers[apic], GFP_KERNEL);
 		if (!early_ioapic_entries[apic])
-			return -ENOMEM;
+			goto nomem;
 	}
 
 	for (apic = 0; apic < nr_ioapics; apic++)
@@ -488,17 +828,31 @@ int save_mask_IO_APIC_setup(void)
 				ioapic_write_entry(apic, pin, entry);
 			}
 		}
+
 	return 0;
+
+nomem:
+	while (apic >= 0)
+		kfree(early_ioapic_entries[apic--]);
+	memset(early_ioapic_entries, 0,
+		ARRAY_SIZE(early_ioapic_entries));
+
+	return -ENOMEM;
 }
 
 void restore_IO_APIC_setup(void)
 {
 	int apic, pin;
 
-	for (apic = 0; apic < nr_ioapics; apic++)
+	for (apic = 0; apic < nr_ioapics; apic++) {
+		if (!early_ioapic_entries[apic])
+			break;
 		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++)
 			ioapic_write_entry(apic, pin,
 					   early_ioapic_entries[apic][pin]);
+		kfree(early_ioapic_entries[apic]);
+		early_ioapic_entries[apic] = NULL;
+	}
 }
 
 void reinit_intr_remapped_IO_APIC(int intr_remapping)
@@ -512,25 +866,7 @@ void reinit_intr_remapped_IO_APIC(int intr_remapping)
 	 */
 	restore_IO_APIC_setup();
 }
-
-int skip_ioapic_setup;
-int ioapic_force;
-
-static int __init parse_noapic(char *str)
-{
-	disable_ioapic_setup();
-	return 0;
-}
-early_param("noapic", parse_noapic);
-
-/* Actually the next is obsolete, but keep it for paranoid reasons -AK */
-static int __init disable_timer_pin_setup(char *arg)
-{
-	disable_timer_pin_1 = 1;
-	return 1;
-}
-__setup("disable_timer_pin_1", disable_timer_pin_setup);
-
+#endif
 
 /*
  * Find the IRQ entry number of a certain pin.
@@ -634,22 +970,54 @@ int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin)
 				best_guess = irq;
 		}
 	}
-	BUG_ON(best_guess >= NR_IRQS);
 	return best_guess;
 }
 
+EXPORT_SYMBOL(IO_APIC_get_PCI_irq_vector);
+
+#if defined(CONFIG_EISA) || defined(CONFIG_MCA)
+/*
+ * EISA Edge/Level control register, ELCR
+ */
+static int EISA_ELCR(unsigned int irq)
+{
+	if (irq < 16) {
+		unsigned int port = 0x4d0 + (irq >> 3);
+		return (inb(port) >> (irq & 7)) & 1;
+	}
+	apic_printk(APIC_VERBOSE, KERN_INFO
+			"Broken MPtable reports ISA irq %d\n", irq);
+	return 0;
+}
+
+#endif
+
 /* ISA interrupts are always polarity zero edge triggered,
  * when listed as conforming in the MP table. */
 
 #define default_ISA_trigger(idx)	(0)
 #define default_ISA_polarity(idx)	(0)
 
+/* EISA interrupts are always polarity zero and can be edge or level
+ * trigger depending on the ELCR value.  If an interrupt is listed as
+ * EISA conforming in the MP table, that means its trigger type must
+ * be read in from the ELCR */
+
+#define default_EISA_trigger(idx)	(EISA_ELCR(mp_irqs[idx].mp_srcbusirq))
+#define default_EISA_polarity(idx)	default_ISA_polarity(idx)
+
 /* PCI interrupts are always polarity one level triggered,
  * when listed as conforming in the MP table. */
 
 #define default_PCI_trigger(idx)	(1)
 #define default_PCI_polarity(idx)	(1)
 
+/* MCA interrupts are always polarity zero level triggered,
+ * when listed as conforming in the MP table. */
+
+#define default_MCA_trigger(idx)	(1)
+#define default_MCA_polarity(idx)	default_ISA_polarity(idx)
+
 static int MPBIOS_polarity(int idx)
 {
 	int bus = mp_irqs[idx].mp_srcbus;
@@ -707,6 +1075,36 @@ static int MPBIOS_trigger(int idx)
 				trigger = default_ISA_trigger(idx);
 			else
 				trigger = default_PCI_trigger(idx);
+#if defined(CONFIG_EISA) || defined(CONFIG_MCA)
+			switch (mp_bus_id_to_type[bus]) {
+				case MP_BUS_ISA: /* ISA pin */
+				{
+					/* set before the switch */
+					break;
+				}
+				case MP_BUS_EISA: /* EISA pin */
+				{
+					trigger = default_EISA_trigger(idx);
+					break;
+				}
+				case MP_BUS_PCI: /* PCI pin */
+				{
+					/* set before the switch */
+					break;
+				}
+				case MP_BUS_MCA: /* MCA pin */
+				{
+					trigger = default_MCA_trigger(idx);
+					break;
+				}
+				default:
+				{
+					printk(KERN_WARNING "broken BIOS!!\n");
+					trigger = 1;
+					break;
+				}
+			}
+#endif
 			break;
 		case 1: /* edge */
 		{
@@ -744,6 +1142,7 @@ static inline int irq_trigger(int idx)
 	return MPBIOS_trigger(idx);
 }
 
+int (*ioapic_renumber_irq)(int ioapic, int irq);
 static int pin_2_irq(int idx, int apic, int pin)
 {
 	int irq, i;
@@ -765,8 +1164,32 @@ static int pin_2_irq(int idx, int apic, int pin)
 		while (i < apic)
 			irq += nr_ioapic_registers[i++];
 		irq += pin;
+                /*
+                 * For MPS mode, so far only needed by ES7000 platform
+                 */
+                if (ioapic_renumber_irq)
+                        irq = ioapic_renumber_irq(apic, irq);
+	}
+
+#ifdef CONFIG_X86_32
+	/*
+	 * PCI IRQ command line redirection. Yes, limits are hardcoded.
+	 */
+	if ((pin >= 16) && (pin <= 23)) {
+		if (pirq_entries[pin-16] != -1) {
+			if (!pirq_entries[pin-16]) {
+				apic_printk(APIC_VERBOSE, KERN_DEBUG
+						"disabling PIRQ%d\n", pin-16);
+			} else {
+				irq = pirq_entries[pin-16];
+				apic_printk(APIC_VERBOSE, KERN_DEBUG
+						"using PIRQ%d -> IRQ %d\n",
+						pin-16, irq);
+			}
+		}
 	}
-	BUG_ON(irq >= NR_IRQS);
+#endif
+
 	return irq;
 }
 
@@ -801,8 +1224,7 @@ static int __assign_irq_vector(int irq, cpumask_t mask)
 	int cpu;
 	struct irq_cfg *cfg;
 
-	BUG_ON((unsigned)irq >= NR_IRQS);
-	cfg = &irq_cfg[irq];
+	cfg = irq_cfg(irq);
 
 	/* Only try and allocate irqs on cpus that are present */
 	cpus_and(mask, mask, cpu_online_map);
@@ -837,8 +1259,13 @@ next:
 		}
 		if (unlikely(current_vector == vector))
 			continue;
+#ifdef CONFIG_X86_64
 		if (vector == IA32_SYSCALL_VECTOR)
 			goto next;
+#else
+		if (vector == SYSCALL_VECTOR)
+			goto next;
+#endif
 		for_each_cpu_mask_nr(new_cpu, new_mask)
 			if (per_cpu(vector_irq, new_cpu)[vector] != -1)
 				goto next;
@@ -875,8 +1302,7 @@ static void __clear_irq_vector(int irq)
 	cpumask_t mask;
 	int cpu, vector;
 
-	BUG_ON((unsigned)irq >= NR_IRQS);
-	cfg = &irq_cfg[irq];
+	cfg = irq_cfg(irq);
 	BUG_ON(!cfg->vector);
 
 	vector = cfg->vector;
@@ -893,12 +1319,13 @@ void __setup_vector_irq(int cpu)
 	/* Initialize vector_irq on a new cpu */
 	/* This function must be called with vector_lock held */
 	int irq, vector;
+	struct irq_cfg *cfg;
 
 	/* Mark the inuse vectors */
-	for (irq = 0; irq < NR_IRQS; ++irq) {
-		if (!cpu_isset(cpu, irq_cfg[irq].domain))
+	for_each_irq_cfg(irq, cfg) {
+		if (!cpu_isset(cpu, cfg->domain))
 			continue;
-		vector = irq_cfg[irq].vector;
+		vector = cfg->vector;
 		per_cpu(vector_irq, cpu)[vector] = irq;
 	}
 	/* Mark the free vectors */
@@ -906,7 +1333,9 @@ void __setup_vector_irq(int cpu)
 		irq = per_cpu(vector_irq, cpu)[vector];
 		if (irq < 0)
 			continue;
-		if (!cpu_isset(cpu, irq_cfg[irq].domain))
+
+		cfg = irq_cfg(irq);
+		if (!cpu_isset(cpu, cfg->domain))
 			per_cpu(vector_irq, cpu)[vector] = -1;
 	}
 }
@@ -916,16 +1345,53 @@ static struct irq_chip ioapic_chip;
 static struct irq_chip ir_ioapic_chip;
 #endif
 
+#define IOAPIC_AUTO     -1
+#define IOAPIC_EDGE     0
+#define IOAPIC_LEVEL    1
+
+#ifdef CONFIG_X86_32
+static inline int IO_APIC_irq_trigger(int irq)
+{
+        int apic, idx, pin;
+
+        for (apic = 0; apic < nr_ioapics; apic++) {
+                for (pin = 0; pin < nr_ioapic_registers[apic]; pin++) {
+                        idx = find_irq_entry(apic, pin, mp_INT);
+                        if ((idx != -1) && (irq == pin_2_irq(idx, apic, pin)))
+                                return irq_trigger(idx);
+                }
+        }
+        /*
+         * nonexistent IRQs are edge default
+         */
+        return 0;
+}
+#else
+static inline int IO_APIC_irq_trigger(int irq)
+{
+	return 1;
+}
+#endif
+
 static void ioapic_register_intr(int irq, unsigned long trigger)
 {
-	if (trigger)
-		irq_desc[irq].status |= IRQ_LEVEL;
+	struct irq_desc *desc;
+
+	/* first time to use this irq_desc */
+	if (irq < 16)
+		desc = irq_to_desc(irq);
 	else
-		irq_desc[irq].status &= ~IRQ_LEVEL;
+		desc = irq_to_desc_alloc(irq);
+
+	if ((trigger == IOAPIC_AUTO && IO_APIC_irq_trigger(irq)) ||
+	    trigger == IOAPIC_LEVEL)
+		desc->status |= IRQ_LEVEL;
+	else
+		desc->status &= ~IRQ_LEVEL;
 
 #ifdef CONFIG_INTR_REMAP
 	if (irq_remapped(irq)) {
-		irq_desc[irq].status |= IRQ_MOVE_PCNTXT;
+		desc->status |= IRQ_MOVE_PCNTXT;
 		if (trigger)
 			set_irq_chip_and_handler_name(irq, &ir_ioapic_chip,
 						      handle_fasteoi_irq,
@@ -936,7 +1402,8 @@ static void ioapic_register_intr(int irq, unsigned long trigger)
 		return;
 	}
 #endif
-	if (trigger)
+	if ((trigger == IOAPIC_AUTO && IO_APIC_irq_trigger(irq)) ||
+	    trigger == IOAPIC_LEVEL)
 		set_irq_chip_and_handler_name(irq, &ioapic_chip,
 					      handle_fasteoi_irq,
 					      "fasteoi");
@@ -1009,13 +1476,15 @@ static int setup_ioapic_entry(int apic, int irq,
 static void setup_IO_APIC_irq(int apic, int pin, unsigned int irq,
 			      int trigger, int polarity)
 {
-	struct irq_cfg *cfg = irq_cfg + irq;
+	struct irq_cfg *cfg;
 	struct IO_APIC_route_entry entry;
 	cpumask_t mask;
 
 	if (!IO_APIC_IRQ(irq))
 		return;
 
+	cfg = irq_cfg(irq);
+
 	mask = TARGET_CPUS;
 	if (assign_irq_vector(irq, mask))
 		return;
@@ -1047,37 +1516,49 @@ static void setup_IO_APIC_irq(int apic, int pin, unsigned int irq,
 
 static void __init setup_IO_APIC_irqs(void)
 {
-	int apic, pin, idx, irq, first_notcon = 1;
+	int apic, pin, idx, irq;
+	int notcon = 0;
 
 	apic_printk(APIC_VERBOSE, KERN_DEBUG "init IO_APIC IRQs\n");
 
 	for (apic = 0; apic < nr_ioapics; apic++) {
-	for (pin = 0; pin < nr_ioapic_registers[apic]; pin++) {
-
-		idx = find_irq_entry(apic,pin,mp_INT);
-		if (idx == -1) {
-			if (first_notcon) {
-				apic_printk(APIC_VERBOSE, KERN_DEBUG " IO-APIC (apicid-pin) %d-%d", mp_ioapics[apic].mp_apicid, pin);
-				first_notcon = 0;
-			} else
-				apic_printk(APIC_VERBOSE, ", %d-%d", mp_ioapics[apic].mp_apicid, pin);
-			continue;
-		}
-		if (!first_notcon) {
-			apic_printk(APIC_VERBOSE, " not connected.\n");
-			first_notcon = 1;
-		}
+		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++) {
 
-		irq = pin_2_irq(idx, apic, pin);
-		add_pin_to_irq(irq, apic, pin);
+			idx = find_irq_entry(apic, pin, mp_INT);
+			if (idx == -1) {
+				if (!notcon) {
+					notcon = 1;
+					apic_printk(APIC_VERBOSE,
+						KERN_DEBUG " %d-%d",
+						mp_ioapics[apic].mp_apicid,
+						pin);
+				} else
+					apic_printk(APIC_VERBOSE, " %d-%d",
+						mp_ioapics[apic].mp_apicid,
+						pin);
+				continue;
+			}
+			if (notcon) {
+				apic_printk(APIC_VERBOSE,
+					" (apicid-pin) not connected\n");
+				notcon = 0;
+			}
 
-		setup_IO_APIC_irq(apic, pin, irq,
-				  irq_trigger(idx), irq_polarity(idx));
-	}
+			irq = pin_2_irq(idx, apic, pin);
+#ifdef CONFIG_X86_32
+			if (multi_timer_check(apic, irq))
+				continue;
+#endif
+			add_pin_to_irq(irq, apic, pin);
+
+			setup_IO_APIC_irq(apic, pin, irq,
+					irq_trigger(idx), irq_polarity(idx));
+		}
 	}
 
-	if (!first_notcon)
-		apic_printk(APIC_VERBOSE, " not connected.\n");
+	if (notcon)
+		apic_printk(APIC_VERBOSE,
+			" (apicid-pin) not connected\n");
 }
 
 /*
@@ -1088,8 +1569,10 @@ static void __init setup_timer_IRQ0_pin(unsigned int apic, unsigned int pin,
 {
 	struct IO_APIC_route_entry entry;
 
+#ifdef CONFIG_INTR_REMAP
 	if (intr_remapping_enabled)
 		return;
+#endif
 
 	memset(&entry, 0, sizeof(entry));
 
@@ -1124,7 +1607,10 @@ __apicdebuginit(void) print_IO_APIC(void)
 	union IO_APIC_reg_00 reg_00;
 	union IO_APIC_reg_01 reg_01;
 	union IO_APIC_reg_02 reg_02;
+	union IO_APIC_reg_03 reg_03;
 	unsigned long flags;
+	struct irq_cfg *cfg;
+	unsigned int irq;
 
 	if (apic_verbosity == APIC_QUIET)
 		return;
@@ -1147,12 +1633,16 @@ __apicdebuginit(void) print_IO_APIC(void)
 	reg_01.raw = io_apic_read(apic, 1);
 	if (reg_01.bits.version >= 0x10)
 		reg_02.raw = io_apic_read(apic, 2);
+        if (reg_01.bits.version >= 0x20)
+                reg_03.raw = io_apic_read(apic, 3);
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 
 	printk("\n");
 	printk(KERN_DEBUG "IO APIC #%d......\n", mp_ioapics[apic].mp_apicid);
 	printk(KERN_DEBUG ".... register #00: %08X\n", reg_00.raw);
 	printk(KERN_DEBUG ".......    : physical APIC id: %02X\n", reg_00.bits.ID);
+	printk(KERN_DEBUG ".......    : Delivery Type: %X\n", reg_00.bits.delivery_type);
+	printk(KERN_DEBUG ".......    : LTS          : %X\n", reg_00.bits.LTS);
 
 	printk(KERN_DEBUG ".... register #01: %08X\n", *(int *)&reg_01);
 	printk(KERN_DEBUG ".......     : max redirection entries: %04X\n", reg_01.bits.entries);
@@ -1160,11 +1650,27 @@ __apicdebuginit(void) print_IO_APIC(void)
 	printk(KERN_DEBUG ".......     : PRQ implemented: %X\n", reg_01.bits.PRQ);
 	printk(KERN_DEBUG ".......     : IO APIC version: %04X\n", reg_01.bits.version);
 
-	if (reg_01.bits.version >= 0x10) {
+	/*
+	 * Some Intel chipsets with IO APIC VERSION of 0x1? don't have reg_02,
+	 * but the value of reg_02 is read as the previous read register
+	 * value, so ignore it if reg_02 == reg_01.
+	 */
+	if (reg_01.bits.version >= 0x10 && reg_02.raw != reg_01.raw) {
 		printk(KERN_DEBUG ".... register #02: %08X\n", reg_02.raw);
 		printk(KERN_DEBUG ".......     : arbitration: %02X\n", reg_02.bits.arbitration);
 	}
 
+	/*
+	 * Some Intel chipsets with IO APIC VERSION of 0x2? don't have reg_02
+	 * or reg_03, but the value of reg_0[23] is read as the previous read
+	 * register value, so ignore it if reg_03 == reg_0[12].
+	 */
+	if (reg_01.bits.version >= 0x20 && reg_03.raw != reg_02.raw &&
+	    reg_03.raw != reg_01.raw) {
+		printk(KERN_DEBUG ".... register #03: %08X\n", reg_03.raw);
+		printk(KERN_DEBUG ".......     : Boot DT    : %X\n", reg_03.bits.boot_DT);
+	}
+
 	printk(KERN_DEBUG ".... IRQ redirection table:\n");
 
 	printk(KERN_DEBUG " NR Dst Mask Trig IRR Pol"
@@ -1193,16 +1699,16 @@ __apicdebuginit(void) print_IO_APIC(void)
 	}
 	}
 	printk(KERN_DEBUG "IRQ to pin mappings:\n");
-	for (i = 0; i < NR_IRQS; i++) {
-		struct irq_pin_list *entry = irq_2_pin + i;
-		if (entry->pin < 0)
+	for_each_irq_cfg(irq, cfg) {
+		struct irq_pin_list *entry = cfg->irq_2_pin;
+		if (!entry)
 			continue;
-		printk(KERN_DEBUG "IRQ%d ", i);
+		printk(KERN_DEBUG "IRQ%d ", irq);
 		for (;;) {
 			printk("-> %d:%d", entry->apic, entry->pin);
 			if (!entry->next)
 				break;
-			entry = irq_2_pin + entry->next;
+			entry = entry->next;
 		}
 		printk("\n");
 	}
@@ -1236,7 +1742,7 @@ __apicdebuginit(void) print_APIC_bitfield(int base)
 __apicdebuginit(void) print_local_APIC(void *dummy)
 {
 	unsigned int v, ver, maxlvt;
-	unsigned long icr;
+	u64 icr;
 
 	if (apic_verbosity == APIC_QUIET)
 		return;
@@ -1253,20 +1759,31 @@ __apicdebuginit(void) print_local_APIC(void *dummy)
 	v = apic_read(APIC_TASKPRI);
 	printk(KERN_DEBUG "... APIC TASKPRI: %08x (%02x)\n", v, v & APIC_TPRI_MASK);
 
-	v = apic_read(APIC_ARBPRI);
-	printk(KERN_DEBUG "... APIC ARBPRI: %08x (%02x)\n", v,
-		v & APIC_ARBPRI_MASK);
-	v = apic_read(APIC_PROCPRI);
-	printk(KERN_DEBUG "... APIC PROCPRI: %08x\n", v);
+	if (APIC_INTEGRATED(ver)) {                     /* !82489DX */
+		if (!APIC_XAPIC(ver)) {
+			v = apic_read(APIC_ARBPRI);
+			printk(KERN_DEBUG "... APIC ARBPRI: %08x (%02x)\n", v,
+			       v & APIC_ARBPRI_MASK);
+		}
+		v = apic_read(APIC_PROCPRI);
+		printk(KERN_DEBUG "... APIC PROCPRI: %08x\n", v);
+	}
+
+	/*
+	 * Remote read supported only in the 82489DX and local APIC for
+	 * Pentium processors.
+	 */
+	if (!APIC_INTEGRATED(ver) || maxlvt == 3) {
+		v = apic_read(APIC_RRR);
+		printk(KERN_DEBUG "... APIC RRR: %08x\n", v);
+	}
 
-	v = apic_read(APIC_EOI);
-	printk(KERN_DEBUG "... APIC EOI: %08x\n", v);
-	v = apic_read(APIC_RRR);
-	printk(KERN_DEBUG "... APIC RRR: %08x\n", v);
 	v = apic_read(APIC_LDR);
 	printk(KERN_DEBUG "... APIC LDR: %08x\n", v);
-	v = apic_read(APIC_DFR);
-	printk(KERN_DEBUG "... APIC DFR: %08x\n", v);
+	if (!x2apic_enabled()) {
+		v = apic_read(APIC_DFR);
+		printk(KERN_DEBUG "... APIC DFR: %08x\n", v);
+	}
 	v = apic_read(APIC_SPIV);
 	printk(KERN_DEBUG "... APIC SPIV: %08x\n", v);
 
@@ -1277,12 +1794,17 @@ __apicdebuginit(void) print_local_APIC(void *dummy)
 	printk(KERN_DEBUG "... APIC IRR field:\n");
 	print_APIC_bitfield(APIC_IRR);
 
-	v = apic_read(APIC_ESR);
-	printk(KERN_DEBUG "... APIC ESR: %08x\n", v);
+	if (APIC_INTEGRATED(ver)) {             /* !82489DX */
+		if (maxlvt > 3)         /* Due to the Pentium erratum 3AP. */
+			apic_write(APIC_ESR, 0);
+
+		v = apic_read(APIC_ESR);
+		printk(KERN_DEBUG "... APIC ESR: %08x\n", v);
+	}
 
 	icr = apic_icr_read();
-	printk(KERN_DEBUG "... APIC ICR: %08x\n", icr);
-	printk(KERN_DEBUG "... APIC ICR2: %08x\n", icr >> 32);
+	printk(KERN_DEBUG "... APIC ICR: %08x\n", (u32)icr);
+	printk(KERN_DEBUG "... APIC ICR2: %08x\n", (u32)(icr >> 32));
 
 	v = apic_read(APIC_LVTT);
 	printk(KERN_DEBUG "... APIC LVTT: %08x\n", v);
@@ -1312,7 +1834,12 @@ __apicdebuginit(void) print_local_APIC(void *dummy)
 
 __apicdebuginit(void) print_all_local_APICs(void)
 {
-	on_each_cpu(print_local_APIC, NULL, 1);
+	int cpu;
+
+	preempt_disable();
+	for_each_online_cpu(cpu)
+		smp_call_function_single(cpu, print_local_APIC, NULL, 1);
+	preempt_enable();
 }
 
 __apicdebuginit(void) print_PIC(void)
@@ -1359,17 +1886,22 @@ __apicdebuginit(int) print_all_ICs(void)
 fs_initcall(print_all_ICs);
 
 
+/* Where if anywhere is the i8259 connect in external int mode */
+static struct { int pin, apic; } ioapic_i8259 = { -1, -1 };
+
 void __init enable_IO_APIC(void)
 {
 	union IO_APIC_reg_01 reg_01;
 	int i8259_apic, i8259_pin;
-	int i, apic;
+	int apic;
 	unsigned long flags;
 
-	for (i = 0; i < PIN_MAP_SIZE; i++) {
-		irq_2_pin[i].pin = -1;
-		irq_2_pin[i].next = 0;
-	}
+#ifdef CONFIG_X86_32
+	int i;
+	if (!pirqs_enabled)
+		for (i = 0; i < MAX_PIRQS; i++)
+			pirq_entries[i] = -1;
+#endif
 
 	/*
 	 * The number of IO-APIC IRQ registers (== #pins):
@@ -1399,6 +1931,10 @@ void __init enable_IO_APIC(void)
 	}
  found_i8259:
 	/* Look to see what if the MP table has reported the ExtINT */
+	/* If we could not find the appropriate pin by looking at the ioapic
+	 * the i8259 probably is not connected the ioapic but give the
+	 * mptable a chance anyway.
+	 */
 	i8259_pin  = find_isa_irq_pin(0, mp_ExtINT);
 	i8259_apic = find_isa_irq_apic(0, mp_ExtINT);
 	/* Trust the MP table if nothing is setup in the hardware */
@@ -1458,6 +1994,133 @@ void disable_IO_APIC(void)
 	disconnect_bsp_APIC(ioapic_i8259.pin != -1);
 }
 
+#ifdef CONFIG_X86_32
+/*
+ * function to set the IO-APIC physical IDs based on the
+ * values stored in the MPC table.
+ *
+ * by Matt Domsch <Matt_Domsch@dell.com>  Tue Dec 21 12:25:05 CST 1999
+ */
+
+static void __init setup_ioapic_ids_from_mpc(void)
+{
+	union IO_APIC_reg_00 reg_00;
+	physid_mask_t phys_id_present_map;
+	int apic;
+	int i;
+	unsigned char old_id;
+	unsigned long flags;
+
+	if (x86_quirks->setup_ioapic_ids && x86_quirks->setup_ioapic_ids())
+		return;
+
+	/*
+	 * Don't check I/O APIC IDs for xAPIC systems.  They have
+	 * no meaning without the serial APIC bus.
+	 */
+	if (!(boot_cpu_data.x86_vendor == X86_VENDOR_INTEL)
+		|| APIC_XAPIC(apic_version[boot_cpu_physical_apicid]))
+		return;
+	/*
+	 * This is broken; anything with a real cpu count has to
+	 * circumvent this idiocy regardless.
+	 */
+	phys_id_present_map = ioapic_phys_id_map(phys_cpu_present_map);
+
+	/*
+	 * Set the IOAPIC ID to the value stored in the MPC table.
+	 */
+	for (apic = 0; apic < nr_ioapics; apic++) {
+
+		/* Read the register 0 value */
+		spin_lock_irqsave(&ioapic_lock, flags);
+		reg_00.raw = io_apic_read(apic, 0);
+		spin_unlock_irqrestore(&ioapic_lock, flags);
+
+		old_id = mp_ioapics[apic].mp_apicid;
+
+		if (mp_ioapics[apic].mp_apicid >= get_physical_broadcast()) {
+			printk(KERN_ERR "BIOS bug, IO-APIC#%d ID is %d in the MPC table!...\n",
+				apic, mp_ioapics[apic].mp_apicid);
+			printk(KERN_ERR "... fixing up to %d. (tell your hw vendor)\n",
+				reg_00.bits.ID);
+			mp_ioapics[apic].mp_apicid = reg_00.bits.ID;
+		}
+
+		/*
+		 * Sanity check, is the ID really free? Every APIC in a
+		 * system must have a unique ID or we get lots of nice
+		 * 'stuck on smp_invalidate_needed IPI wait' messages.
+		 */
+		if (check_apicid_used(phys_id_present_map,
+					mp_ioapics[apic].mp_apicid)) {
+			printk(KERN_ERR "BIOS bug, IO-APIC#%d ID %d is already used!...\n",
+				apic, mp_ioapics[apic].mp_apicid);
+			for (i = 0; i < get_physical_broadcast(); i++)
+				if (!physid_isset(i, phys_id_present_map))
+					break;
+			if (i >= get_physical_broadcast())
+				panic("Max APIC ID exceeded!\n");
+			printk(KERN_ERR "... fixing up to %d. (tell your hw vendor)\n",
+				i);
+			physid_set(i, phys_id_present_map);
+			mp_ioapics[apic].mp_apicid = i;
+		} else {
+			physid_mask_t tmp;
+			tmp = apicid_to_cpu_present(mp_ioapics[apic].mp_apicid);
+			apic_printk(APIC_VERBOSE, "Setting %d in the "
+					"phys_id_present_map\n",
+					mp_ioapics[apic].mp_apicid);
+			physids_or(phys_id_present_map, phys_id_present_map, tmp);
+		}
+
+
+		/*
+		 * We need to adjust the IRQ routing table
+		 * if the ID changed.
+		 */
+		if (old_id != mp_ioapics[apic].mp_apicid)
+			for (i = 0; i < mp_irq_entries; i++)
+				if (mp_irqs[i].mp_dstapic == old_id)
+					mp_irqs[i].mp_dstapic
+						= mp_ioapics[apic].mp_apicid;
+
+		/*
+		 * Read the right value from the MPC table and
+		 * write it into the ID register.
+		 */
+		apic_printk(APIC_VERBOSE, KERN_INFO
+			"...changing IO-APIC physical APIC ID to %d ...",
+			mp_ioapics[apic].mp_apicid);
+
+		reg_00.bits.ID = mp_ioapics[apic].mp_apicid;
+		spin_lock_irqsave(&ioapic_lock, flags);
+		io_apic_write(apic, 0, reg_00.raw);
+		spin_unlock_irqrestore(&ioapic_lock, flags);
+
+		/*
+		 * Sanity check
+		 */
+		spin_lock_irqsave(&ioapic_lock, flags);
+		reg_00.raw = io_apic_read(apic, 0);
+		spin_unlock_irqrestore(&ioapic_lock, flags);
+		if (reg_00.bits.ID != mp_ioapics[apic].mp_apicid)
+			printk("could not set ID!\n");
+		else
+			apic_printk(APIC_VERBOSE, " ok.\n");
+	}
+}
+#endif
+
+int no_timer_check __initdata;
+
+static int __init notimercheck(char *s)
+{
+	no_timer_check = 1;
+	return 1;
+}
+__setup("no_timer_check", notimercheck);
+
 /*
  * There is a nasty bug in some older SMP boards, their mptable lies
  * about the timer IRQ. We do the following to work around the situation:
@@ -1471,6 +2134,9 @@ static int __init timer_irq_works(void)
 	unsigned long t1 = jiffies;
 	unsigned long flags;
 
+	if (no_timer_check)
+		return 1;
+
 	local_save_flags(flags);
 	local_irq_enable();
 	/* Let ten ticks pass... */
@@ -1531,9 +2197,11 @@ static unsigned int startup_ioapic_irq(unsigned int irq)
 	return was_pending;
 }
 
+#ifdef CONFIG_X86_64
 static int ioapic_retrigger_irq(unsigned int irq)
 {
-	struct irq_cfg *cfg = &irq_cfg[irq];
+
+	struct irq_cfg *cfg = irq_cfg(irq);
 	unsigned long flags;
 
 	spin_lock_irqsave(&vector_lock, flags);
@@ -1542,6 +2210,14 @@ static int ioapic_retrigger_irq(unsigned int irq)
 
 	return 1;
 }
+#else
+static int ioapic_retrigger_irq(unsigned int irq)
+{
+        send_IPI_self(irq_cfg(irq)->vector);
+
+        return 1;
+}
+#endif
 
 /*
  * Level and edge triggered IO-APIC interrupts need different handling,
@@ -1580,11 +2256,11 @@ static DECLARE_DELAYED_WORK(ir_migration_work, ir_irq_migration);
  */
 static void migrate_ioapic_irq(int irq, cpumask_t mask)
 {
-	struct irq_cfg *cfg = irq_cfg + irq;
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_cfg *cfg;
+	struct irq_desc *desc;
 	cpumask_t tmp, cleanup_mask;
 	struct irte irte;
-	int modify_ioapic_rte = desc->status & IRQ_LEVEL;
+	int modify_ioapic_rte;
 	unsigned int dest;
 	unsigned long flags;
 
@@ -1598,9 +2274,12 @@ static void migrate_ioapic_irq(int irq, cpumask_t mask)
 	if (assign_irq_vector(irq, mask))
 		return;
 
+	cfg = irq_cfg(irq);
 	cpus_and(tmp, cfg->domain, mask);
 	dest = cpu_mask_to_apicid(tmp);
 
+	desc = irq_to_desc(irq);
+	modify_ioapic_rte = desc->status & IRQ_LEVEL;
 	if (modify_ioapic_rte) {
 		spin_lock_irqsave(&ioapic_lock, flags);
 		__target_IO_APIC_irq(irq, dest, cfg->vector);
@@ -1622,12 +2301,13 @@ static void migrate_ioapic_irq(int irq, cpumask_t mask)
 		cfg->move_in_progress = 0;
 	}
 
-	irq_desc[irq].affinity = mask;
+	desc->affinity = mask;
 }
 
 static int migrate_irq_remapped_level(int irq)
 {
 	int ret = -1;
+	struct irq_desc *desc = irq_to_desc(irq);
 
 	mask_IO_APIC_irq(irq);
 
@@ -1643,11 +2323,11 @@ static int migrate_irq_remapped_level(int irq)
 	}
 
 	/* everthing is clear. we have right of way */
-	migrate_ioapic_irq(irq, irq_desc[irq].pending_mask);
+	migrate_ioapic_irq(irq, desc->pending_mask);
 
 	ret = 0;
-	irq_desc[irq].status &= ~IRQ_MOVE_PENDING;
-	cpus_clear(irq_desc[irq].pending_mask);
+	desc->status &= ~IRQ_MOVE_PENDING;
+	cpus_clear(desc->pending_mask);
 
 unmask:
 	unmask_IO_APIC_irq(irq);
@@ -1656,10 +2336,10 @@ unmask:
 
 static void ir_irq_migration(struct work_struct *work)
 {
-	int irq;
+	unsigned int irq;
+	struct irq_desc *desc;
 
-	for (irq = 0; irq < NR_IRQS; irq++) {
-		struct irq_desc *desc = irq_desc + irq;
+	for_each_irq_desc(irq, desc) {
 		if (desc->status & IRQ_MOVE_PENDING) {
 			unsigned long flags;
 
@@ -1671,8 +2351,7 @@ static void ir_irq_migration(struct work_struct *work)
 				continue;
 			}
 
-			desc->chip->set_affinity(irq,
-					         irq_desc[irq].pending_mask);
+			desc->chip->set_affinity(irq, desc->pending_mask);
 			spin_unlock_irqrestore(&desc->lock, flags);
 		}
 	}
@@ -1683,9 +2362,11 @@ static void ir_irq_migration(struct work_struct *work)
  */
 static void set_ir_ioapic_affinity_irq(unsigned int irq, cpumask_t mask)
 {
-	if (irq_desc[irq].status & IRQ_LEVEL) {
-		irq_desc[irq].status |= IRQ_MOVE_PENDING;
-		irq_desc[irq].pending_mask = mask;
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	if (desc->status & IRQ_LEVEL) {
+		desc->status |= IRQ_MOVE_PENDING;
+		desc->pending_mask = mask;
 		migrate_irq_remapped_level(irq);
 		return;
 	}
@@ -1698,7 +2379,9 @@ asmlinkage void smp_irq_move_cleanup_interrupt(void)
 {
 	unsigned vector, me;
 	ack_APIC_irq();
+#ifdef CONFIG_X86_64
 	exit_idle();
+#endif
 	irq_enter();
 
 	me = smp_processor_id();
@@ -1707,11 +2390,12 @@ asmlinkage void smp_irq_move_cleanup_interrupt(void)
 		struct irq_desc *desc;
 		struct irq_cfg *cfg;
 		irq = __get_cpu_var(vector_irq)[vector];
-		if (irq >= NR_IRQS)
+
+		desc = irq_to_desc(irq);
+		if (!desc)
 			continue;
 
-		desc = irq_desc + irq;
-		cfg = irq_cfg + irq;
+		cfg = irq_cfg(irq);
 		spin_lock(&desc->lock);
 		if (!cfg->move_cleanup_count)
 			goto unlock;
@@ -1730,7 +2414,7 @@ unlock:
 
 static void irq_complete_move(unsigned int irq)
 {
-	struct irq_cfg *cfg = irq_cfg + irq;
+	struct irq_cfg *cfg = irq_cfg(irq);
 	unsigned vector, me;
 
 	if (likely(!cfg->move_in_progress))
@@ -1769,19 +2453,52 @@ static void ack_apic_edge(unsigned int irq)
 	ack_APIC_irq();
 }
 
+#ifdef CONFIG_X86_32
+atomic_t irq_mis_count;
+#endif
+
 static void ack_apic_level(unsigned int irq)
 {
+#ifdef CONFIG_X86_32
+	unsigned long v;
+	int i;
+#endif
 	int do_unmask_irq = 0;
 
 	irq_complete_move(irq);
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 	/* If we are moving the irq we need to mask it */
-	if (unlikely(irq_desc[irq].status & IRQ_MOVE_PENDING)) {
+	if (unlikely(irq_to_desc(irq)->status & IRQ_MOVE_PENDING)) {
 		do_unmask_irq = 1;
 		mask_IO_APIC_irq(irq);
 	}
 #endif
 
+#ifdef CONFIG_X86_32
+	/*
+	* It appears there is an erratum which affects at least version 0x11
+	* of I/O APIC (that's the 82093AA and cores integrated into various
+	* chipsets).  Under certain conditions a level-triggered interrupt is
+	* erroneously delivered as edge-triggered one but the respective IRR
+	* bit gets set nevertheless.  As a result the I/O unit expects an EOI
+	* message but it will never arrive and further interrupts are blocked
+	* from the source.  The exact reason is so far unknown, but the
+	* phenomenon was observed when two consecutive interrupt requests
+	* from a given source get delivered to the same CPU and the source is
+	* temporarily disabled in between.
+	*
+	* A workaround is to simulate an EOI message manually.  We achieve it
+	* by setting the trigger mode to edge and then to level when the edge
+	* trigger mode gets detected in the TMR of a local APIC for a
+	* level-triggered interrupt.  We mask the source for the time of the
+	* operation to prevent an edge-triggered interrupt escaping meanwhile.
+	* The idea is from Manfred Spraul.  --macro
+	*/
+	i = irq_cfg(irq)->vector;
+
+	v = apic_read(APIC_TMR + ((i & ~0x1f) >> 1));
+#endif
+
 	/*
 	 * We must acknowledge the irq before we move it or the acknowledge will
 	 * not propagate properly.
@@ -1820,6 +2537,16 @@ static void ack_apic_level(unsigned int irq)
 			move_masked_irq(irq);
 		unmask_IO_APIC_irq(irq);
 	}
+
+#ifdef CONFIG_X86_32
+	if (!(v & (1 << (i & 0x1f)))) {
+		atomic_inc(&irq_mis_count);
+		spin_lock(&ioapic_lock);
+		__mask_and_edge_IO_APIC_irq(irq);
+		__unmask_and_level_IO_APIC_irq(irq);
+		spin_unlock(&ioapic_lock);
+	}
+#endif
 }
 
 static struct irq_chip ioapic_chip __read_mostly = {
@@ -1853,6 +2580,8 @@ static struct irq_chip ir_ioapic_chip __read_mostly = {
 static inline void init_IO_APIC_traps(void)
 {
 	int irq;
+	struct irq_desc *desc;
+	struct irq_cfg *cfg;
 
 	/*
 	 * NOTE! The local APIC isn't very good at handling
@@ -1865,8 +2594,8 @@ static inline void init_IO_APIC_traps(void)
 	 * Also, we've got to be careful not to trash gate
 	 * 0x80, because int 0x80 is hm, kind of importantish. ;)
 	 */
-	for (irq = 0; irq < NR_IRQS ; irq++) {
-		if (IO_APIC_IRQ(irq) && !irq_cfg[irq].vector) {
+	for_each_irq_cfg(irq, cfg) {
+		if (IO_APIC_IRQ(irq) && !cfg->vector) {
 			/*
 			 * Hmm.. We don't have an entry for this,
 			 * so default to an old-fashioned 8259
@@ -1874,27 +2603,33 @@ static inline void init_IO_APIC_traps(void)
 			 */
 			if (irq < 16)
 				make_8259A_irq(irq);
-			else
+			else {
+				desc = irq_to_desc(irq);
 				/* Strange. Oh, well.. */
-				irq_desc[irq].chip = &no_irq_chip;
+				desc->chip = &no_irq_chip;
+			}
 		}
 	}
 }
 
-static void unmask_lapic_irq(unsigned int irq)
+/*
+ * The local APIC irq-chip implementation:
+ */
+
+static void mask_lapic_irq(unsigned int irq)
 {
 	unsigned long v;
 
 	v = apic_read(APIC_LVT0);
-	apic_write(APIC_LVT0, v & ~APIC_LVT_MASKED);
+	apic_write(APIC_LVT0, v | APIC_LVT_MASKED);
 }
 
-static void mask_lapic_irq(unsigned int irq)
+static void unmask_lapic_irq(unsigned int irq)
 {
 	unsigned long v;
 
 	v = apic_read(APIC_LVT0);
-	apic_write(APIC_LVT0, v | APIC_LVT_MASKED);
+	apic_write(APIC_LVT0, v & ~APIC_LVT_MASKED);
 }
 
 static void ack_lapic_irq (unsigned int irq)
@@ -1911,7 +2646,10 @@ static struct irq_chip lapic_chip __read_mostly = {
 
 static void lapic_register_intr(int irq)
 {
-	irq_desc[irq].status &= ~IRQ_LEVEL;
+	struct irq_desc *desc;
+
+	desc = irq_to_desc(irq);
+	desc->status &= ~IRQ_LEVEL;
 	set_irq_chip_and_handler_name(irq, &lapic_chip, handle_edge_irq,
 				      "edge");
 }
@@ -1919,19 +2657,19 @@ static void lapic_register_intr(int irq)
 static void __init setup_nmi(void)
 {
 	/*
- 	 * Dirty trick to enable the NMI watchdog ...
+	 * Dirty trick to enable the NMI watchdog ...
 	 * We put the 8259A master into AEOI mode and
 	 * unmask on all local APICs LVT0 as NMI.
 	 *
 	 * The idea to use the 8259A in AEOI mode ('8259A Virtual Wire')
 	 * is from Maciej W. Rozycki - so we do not have to EOI from
 	 * the NMI handler or the timer interrupt.
-	 */ 
-	printk(KERN_INFO "activating NMI Watchdog ...");
+	 */
+	apic_printk(APIC_VERBOSE, KERN_INFO "activating NMI Watchdog ...");
 
 	enable_NMI_through_LVT0();
 
-	printk(" done.\n");
+	apic_printk(APIC_VERBOSE, " done.\n");
 }
 
 /*
@@ -1948,12 +2686,17 @@ static inline void __init unlock_ExtINT_logic(void)
 	unsigned char save_control, save_freq_select;
 
 	pin  = find_isa_irq_pin(8, mp_INT);
+	if (pin == -1) {
+		WARN_ON_ONCE(1);
+		return;
+	}
 	apic = find_isa_irq_apic(8, mp_INT);
-	if (pin == -1)
+	if (apic == -1) {
+		WARN_ON_ONCE(1);
 		return;
+	}
 
 	entry0 = ioapic_read_entry(apic, pin);
-
 	clear_IO_APIC_pin(apic, pin);
 
 	memset(&entry1, 0, sizeof(entry1));
@@ -1988,23 +2731,38 @@ static inline void __init unlock_ExtINT_logic(void)
 	ioapic_write_entry(apic, pin, entry0);
 }
 
+static int disable_timer_pin_1 __initdata;
+/* Actually the next is obsolete, but keep it for paranoid reasons -AK */
+static int __init disable_timer_pin_setup(char *arg)
+{
+	disable_timer_pin_1 = 1;
+	return 0;
+}
+early_param("disable_timer_pin_1", disable_timer_pin_setup);
+
+int timer_through_8259 __initdata;
+
 /*
  * This code may look a bit paranoid, but it's supposed to cooperate with
  * a wide range of boards and BIOS bugs.  Fortunately only the timer IRQ
  * is so screwy.  Thanks to Brian Perkins for testing/hacking this beast
  * fanatically on his truly buggy board.
  *
- * FIXME: really need to revamp this for modern platforms only.
+ * FIXME: really need to revamp this for all platforms.
  */
 static inline void __init check_timer(void)
 {
-	struct irq_cfg *cfg = irq_cfg + 0;
+	struct irq_cfg *cfg = irq_cfg(0);
 	int apic1, pin1, apic2, pin2;
 	unsigned long flags;
+	unsigned int ver;
 	int no_pin1 = 0;
 
 	local_irq_save(flags);
 
+        ver = apic_read(APIC_LVR);
+        ver = GET_APIC_VERSION(ver);
+
 	/*
 	 * get/set the timer IRQ vector:
 	 */
@@ -2013,10 +2771,18 @@ static inline void __init check_timer(void)
 
 	/*
 	 * As IRQ0 is to be enabled in the 8259A, the virtual
-	 * wire has to be disabled in the local APIC.
+	 * wire has to be disabled in the local APIC.  Also
+	 * timer interrupts need to be acknowledged manually in
+	 * the 8259A for the i82489DX when using the NMI
+	 * watchdog as that APIC treats NMIs as level-triggered.
+	 * The AEOI mode will finish them in the 8259A
+	 * automatically.
 	 */
 	apic_write(APIC_LVT0, APIC_LVT_MASKED | APIC_DM_EXTINT);
 	init_8259A(1);
+#ifdef CONFIG_X86_32
+	timer_ack = (nmi_watchdog == NMI_IO_APIC && !APIC_INTEGRATED(ver));
+#endif
 
 	pin1  = find_isa_irq_pin(0, mp_INT);
 	apic1 = find_isa_irq_apic(0, mp_INT);
@@ -2035,8 +2801,10 @@ static inline void __init check_timer(void)
 	 * 8259A.
 	 */
 	if (pin1 == -1) {
+#ifdef CONFIG_INTR_REMAP
 		if (intr_remapping_enabled)
 			panic("BIOS bug: timer not connected to IO-APIC");
+#endif
 		pin1 = pin2;
 		apic1 = apic2;
 		no_pin1 = 1;
@@ -2054,7 +2822,7 @@ static inline void __init check_timer(void)
 			setup_timer_IRQ0_pin(apic1, pin1, cfg->vector);
 		}
 		unmask_IO_APIC_irq(0);
-		if (!no_timer_check && timer_irq_works()) {
+		if (timer_irq_works()) {
 			if (nmi_watchdog == NMI_IO_APIC) {
 				setup_nmi();
 				enable_8259A_irq(0);
@@ -2063,8 +2831,10 @@ static inline void __init check_timer(void)
 				clear_IO_APIC_pin(0, pin1);
 			goto out;
 		}
+#ifdef CONFIG_INTR_REMAP
 		if (intr_remapping_enabled)
 			panic("timer doesn't work through Interrupt-remapped IO-APIC");
+#endif
 		clear_IO_APIC_pin(apic1, pin1);
 		if (!no_pin1)
 			apic_printk(APIC_QUIET, KERN_ERR "..MP-BIOS bug: "
@@ -2104,6 +2874,9 @@ static inline void __init check_timer(void)
 			    "through the IO-APIC - disabling NMI Watchdog!\n");
 		nmi_watchdog = NMI_NONE;
 	}
+#ifdef CONFIG_X86_32
+	timer_ack = 0;
+#endif
 
 	apic_printk(APIC_QUIET, KERN_INFO
 		    "...trying to set up timer as Virtual Wire IRQ...\n");
@@ -2140,13 +2913,6 @@ out:
 	local_irq_restore(flags);
 }
 
-static int __init notimercheck(char *s)
-{
-	no_timer_check = 1;
-	return 1;
-}
-__setup("no_timer_check", notimercheck);
-
 /*
  * Traditionally ISA IRQ2 is the cascade IRQ, and is not available
  * to devices.  However there may be an I/O APIC pin available for
@@ -2164,25 +2930,49 @@ __setup("no_timer_check", notimercheck);
  * the I/O APIC in all cases now.  No actual device should request
  * it anyway.  --macro
  */
-#define PIC_IRQS	(1<<2)
+#define PIC_IRQS	(1 << PIC_CASCADE_IR)
 
 void __init setup_IO_APIC(void)
 {
 
+#ifdef CONFIG_X86_32
+	enable_IO_APIC();
+#else
 	/*
 	 * calling enable_IO_APIC() is moved to setup_local_APIC for BP
 	 */
+#endif
 
 	io_apic_irqs = ~PIC_IRQS;
 
 	apic_printk(APIC_VERBOSE, "ENABLING IO-APIC IRQs\n");
-
+        /*
+         * Set up IO-APIC IRQ routing.
+         */
+#ifdef CONFIG_X86_32
+        if (!acpi_ioapic)
+                setup_ioapic_ids_from_mpc();
+#endif
 	sync_Arb_IDs();
 	setup_IO_APIC_irqs();
 	init_IO_APIC_traps();
 	check_timer();
 }
 
+/*
+ *      Called after all the initialization is done. If we didnt find any
+ *      APIC bugs then we can allow the modify fast path
+ */
+
+static int __init io_apic_bug_finalize(void)
+{
+        if (sis_apic_bug == -1)
+                sis_apic_bug = 0;
+        return 0;
+}
+
+late_initcall(io_apic_bug_finalize);
+
 struct sysfs_ioapic_data {
 	struct sys_device dev;
 	struct IO_APIC_route_entry entry[0];
@@ -2270,32 +3060,53 @@ device_initcall(ioapic_init_sysfs);
 /*
  * Dynamic irq allocate and deallocation
  */
-int create_irq(void)
+unsigned int create_irq_nr(unsigned int irq_want)
 {
 	/* Allocate an unused irq */
-	int irq;
-	int new;
+	unsigned int irq;
+	unsigned int new;
 	unsigned long flags;
+	struct irq_cfg *cfg_new;
+
+#ifndef CONFIG_HAVE_SPARSE_IRQ
+	irq_want = nr_irqs - 1;
+#endif
 
-	irq = -ENOSPC;
+	irq = 0;
 	spin_lock_irqsave(&vector_lock, flags);
-	for (new = (NR_IRQS - 1); new >= 0; new--) {
+	for (new = irq_want; new > 0; new--) {
 		if (platform_legacy_irq(new))
 			continue;
-		if (irq_cfg[new].vector != 0)
+		cfg_new = irq_cfg(new);
+		if (cfg_new && cfg_new->vector != 0)
 			continue;
+		/* check if need to create one */
+		if (!cfg_new)
+			cfg_new = irq_cfg_alloc(new);
 		if (__assign_irq_vector(new, TARGET_CPUS) == 0)
 			irq = new;
 		break;
 	}
 	spin_unlock_irqrestore(&vector_lock, flags);
 
-	if (irq >= 0) {
+	if (irq > 0) {
 		dynamic_irq_init(irq);
 	}
 	return irq;
 }
 
+int create_irq(void)
+{
+	int irq;
+
+	irq = create_irq_nr(nr_irqs - 1);
+
+	if (irq == 0)
+		irq = -1;
+
+	return irq;
+}
+
 void destroy_irq(unsigned int irq)
 {
 	unsigned long flags;
@@ -2316,7 +3127,7 @@ void destroy_irq(unsigned int irq)
 #ifdef CONFIG_PCI_MSI
 static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq, struct msi_msg *msg)
 {
-	struct irq_cfg *cfg = irq_cfg + irq;
+	struct irq_cfg *cfg;
 	int err;
 	unsigned dest;
 	cpumask_t tmp;
@@ -2326,6 +3137,7 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq, struct msi_ms
 	if (err)
 		return err;
 
+	cfg = irq_cfg(irq);
 	cpus_and(tmp, cfg->domain, tmp);
 	dest = cpu_mask_to_apicid(tmp);
 
@@ -2383,10 +3195,11 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq, struct msi_ms
 #ifdef CONFIG_SMP
 static void set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
 {
-	struct irq_cfg *cfg = irq_cfg + irq;
+	struct irq_cfg *cfg;
 	struct msi_msg msg;
 	unsigned int dest;
 	cpumask_t tmp;
+	struct irq_desc *desc;
 
 	cpus_and(tmp, mask, cpu_online_map);
 	if (cpus_empty(tmp))
@@ -2395,6 +3208,7 @@ static void set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
 	if (assign_irq_vector(irq, mask))
 		return;
 
+	cfg = irq_cfg(irq);
 	cpus_and(tmp, cfg->domain, mask);
 	dest = cpu_mask_to_apicid(tmp);
 
@@ -2406,7 +3220,8 @@ static void set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
 	write_msi_msg(irq, &msg);
-	irq_desc[irq].affinity = mask;
+	desc = irq_to_desc(irq);
+	desc->affinity = mask;
 }
 
 #ifdef CONFIG_INTR_REMAP
@@ -2416,10 +3231,11 @@ static void set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
  */
 static void ir_set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
 {
-	struct irq_cfg *cfg = irq_cfg + irq;
+	struct irq_cfg *cfg;
 	unsigned int dest;
 	cpumask_t tmp, cleanup_mask;
 	struct irte irte;
+	struct irq_desc *desc;
 
 	cpus_and(tmp, mask, cpu_online_map);
 	if (cpus_empty(tmp))
@@ -2431,6 +3247,7 @@ static void ir_set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
 	if (assign_irq_vector(irq, mask))
 		return;
 
+	cfg = irq_cfg(irq);
 	cpus_and(tmp, cfg->domain, mask);
 	dest = cpu_mask_to_apicid(tmp);
 
@@ -2454,7 +3271,8 @@ static void ir_set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
 		cfg->move_in_progress = 0;
 	}
 
-	irq_desc[irq].affinity = mask;
+	desc = irq_to_desc(irq);
+	desc->affinity = mask;
 }
 #endif
 #endif /* CONFIG_SMP */
@@ -2528,7 +3346,7 @@ static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc, int irq)
 
 #ifdef CONFIG_INTR_REMAP
 	if (irq_remapped(irq)) {
-		struct irq_desc *desc = irq_desc + irq;
+		struct irq_desc *desc = irq_to_desc(irq);
 		/*
 		 * irq migration in process context
 		 */
@@ -2538,16 +3356,34 @@ static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc, int irq)
 #endif
 		set_irq_chip_and_handler_name(irq, &msi_chip, handle_edge_irq, "edge");
 
+	dev_printk(KERN_DEBUG, &dev->dev, "irq %d for MSI/MSI-X\n", irq);
+
 	return 0;
 }
 
+static unsigned int build_irq_for_pci_dev(struct pci_dev *dev)
+{
+	unsigned int irq;
+
+	irq = dev->bus->number;
+	irq <<= 8;
+	irq |= dev->devfn;
+	irq <<= 12;
+
+	return irq;
+}
+
 int arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc)
 {
-	int irq, ret;
+	unsigned int irq;
+	int ret;
+	unsigned int irq_want;
 
-	irq = create_irq();
-	if (irq < 0)
-		return irq;
+	irq_want = build_irq_for_pci_dev(dev) + 0x100;
+
+	irq = create_irq_nr(irq_want);
+	if (irq == 0)
+		return -1;
 
 #ifdef CONFIG_INTR_REMAP
 	if (!intr_remapping_enabled)
@@ -2574,18 +3410,22 @@ error:
 
 int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 {
-	int irq, ret, sub_handle;
+	unsigned int irq;
+	int ret, sub_handle;
 	struct msi_desc *desc;
+	unsigned int irq_want;
+
 #ifdef CONFIG_INTR_REMAP
 	struct intel_iommu *iommu = 0;
 	int index = 0;
 #endif
 
+	irq_want = build_irq_for_pci_dev(dev) + 0x100;
 	sub_handle = 0;
 	list_for_each_entry(desc, &dev->msi_list, list) {
-		irq = create_irq();
-		if (irq < 0)
-			return irq;
+		irq = create_irq_nr(irq_want--);
+		if (irq == 0)
+			return -1;
 #ifdef CONFIG_INTR_REMAP
 		if (!intr_remapping_enabled)
 			goto no_ir;
@@ -2636,10 +3476,11 @@ void arch_teardown_msi_irq(unsigned int irq)
 #ifdef CONFIG_SMP
 static void dmar_msi_set_affinity(unsigned int irq, cpumask_t mask)
 {
-	struct irq_cfg *cfg = irq_cfg + irq;
+	struct irq_cfg *cfg;
 	struct msi_msg msg;
 	unsigned int dest;
 	cpumask_t tmp;
+	struct irq_desc *desc;
 
 	cpus_and(tmp, mask, cpu_online_map);
 	if (cpus_empty(tmp))
@@ -2648,6 +3489,7 @@ static void dmar_msi_set_affinity(unsigned int irq, cpumask_t mask)
 	if (assign_irq_vector(irq, mask))
 		return;
 
+	cfg = irq_cfg(irq);
 	cpus_and(tmp, cfg->domain, mask);
 	dest = cpu_mask_to_apicid(tmp);
 
@@ -2659,7 +3501,8 @@ static void dmar_msi_set_affinity(unsigned int irq, cpumask_t mask)
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
 	dmar_msi_write(irq, &msg);
-	irq_desc[irq].affinity = mask;
+	desc = irq_to_desc(irq);
+	desc->affinity = mask;
 }
 #endif /* CONFIG_SMP */
 
@@ -2689,6 +3532,69 @@ int arch_setup_dmar_msi(unsigned int irq)
 }
 #endif
 
+#ifdef CONFIG_HPET_TIMER
+
+#ifdef CONFIG_SMP
+static void hpet_msi_set_affinity(unsigned int irq, cpumask_t mask)
+{
+	struct irq_cfg *cfg;
+	struct irq_desc *desc;
+	struct msi_msg msg;
+	unsigned int dest;
+	cpumask_t tmp;
+
+	cpus_and(tmp, mask, cpu_online_map);
+	if (cpus_empty(tmp))
+		return;
+
+	if (assign_irq_vector(irq, mask))
+		return;
+
+	cfg = irq_cfg(irq);
+	cpus_and(tmp, cfg->domain, mask);
+	dest = cpu_mask_to_apicid(tmp);
+
+	hpet_msi_read(irq, &msg);
+
+	msg.data &= ~MSI_DATA_VECTOR_MASK;
+	msg.data |= MSI_DATA_VECTOR(cfg->vector);
+	msg.address_lo &= ~MSI_ADDR_DEST_ID_MASK;
+	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
+
+	hpet_msi_write(irq, &msg);
+	desc = irq_to_desc(irq);
+	desc->affinity = mask;
+}
+#endif /* CONFIG_SMP */
+
+struct irq_chip hpet_msi_type = {
+	.name = "HPET_MSI",
+	.unmask = hpet_msi_unmask,
+	.mask = hpet_msi_mask,
+	.ack = ack_apic_edge,
+#ifdef CONFIG_SMP
+	.set_affinity = hpet_msi_set_affinity,
+#endif
+	.retrigger = ioapic_retrigger_irq,
+};
+
+int arch_setup_hpet_msi(unsigned int irq)
+{
+	int ret;
+	struct msi_msg msg;
+
+	ret = msi_compose_msg(NULL, irq, &msg);
+	if (ret < 0)
+		return ret;
+
+	hpet_msi_write(irq, &msg);
+	set_irq_chip_and_handler_name(irq, &hpet_msi_type, handle_edge_irq,
+		"edge");
+
+	return 0;
+}
+#endif
+
 #endif /* CONFIG_PCI_MSI */
 /*
  * Hypertransport interrupt support
@@ -2713,9 +3619,10 @@ static void target_ht_irq(unsigned int irq, unsigned int dest, u8 vector)
 
 static void set_ht_irq_affinity(unsigned int irq, cpumask_t mask)
 {
-	struct irq_cfg *cfg = irq_cfg + irq;
+	struct irq_cfg *cfg;
 	unsigned int dest;
 	cpumask_t tmp;
+	struct irq_desc *desc;
 
 	cpus_and(tmp, mask, cpu_online_map);
 	if (cpus_empty(tmp))
@@ -2724,11 +3631,13 @@ static void set_ht_irq_affinity(unsigned int irq, cpumask_t mask)
 	if (assign_irq_vector(irq, mask))
 		return;
 
+	cfg = irq_cfg(irq);
 	cpus_and(tmp, cfg->domain, mask);
 	dest = cpu_mask_to_apicid(tmp);
 
 	target_ht_irq(irq, dest, cfg->vector);
-	irq_desc[irq].affinity = mask;
+	desc = irq_to_desc(irq);
+	desc->affinity = mask;
 }
 #endif
 
@@ -2745,7 +3654,7 @@ static struct irq_chip ht_irq_chip = {
 
 int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
 {
-	struct irq_cfg *cfg = irq_cfg + irq;
+	struct irq_cfg *cfg;
 	int err;
 	cpumask_t tmp;
 
@@ -2755,6 +3664,7 @@ int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
 		struct ht_irq_msg msg;
 		unsigned dest;
 
+		cfg = irq_cfg(irq);
 		cpus_and(tmp, cfg->domain, tmp);
 		dest = cpu_mask_to_apicid(tmp);
 
@@ -2777,20 +3687,196 @@ int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
 
 		set_irq_chip_and_handler_name(irq, &ht_irq_chip,
 					      handle_edge_irq, "edge");
+
+		dev_printk(KERN_DEBUG, &dev->dev, "irq %d for HT\n", irq);
 	}
 	return err;
 }
 #endif /* CONFIG_HT_IRQ */
 
+#ifdef CONFIG_X86_64
+/*
+ * Re-target the irq to the specified CPU and enable the specified MMR located
+ * on the specified blade to allow the sending of MSIs to the specified CPU.
+ */
+int arch_enable_uv_irq(char *irq_name, unsigned int irq, int cpu, int mmr_blade,
+		       unsigned long mmr_offset)
+{
+	const cpumask_t *eligible_cpu = get_cpu_mask(cpu);
+	struct irq_cfg *cfg;
+	int mmr_pnode;
+	unsigned long mmr_value;
+	struct uv_IO_APIC_route_entry *entry;
+	unsigned long flags;
+	int err;
+
+	err = assign_irq_vector(irq, *eligible_cpu);
+	if (err != 0)
+		return err;
+
+	spin_lock_irqsave(&vector_lock, flags);
+	set_irq_chip_and_handler_name(irq, &uv_irq_chip, handle_percpu_irq,
+				      irq_name);
+	spin_unlock_irqrestore(&vector_lock, flags);
+
+	cfg = irq_cfg(irq);
+
+	mmr_value = 0;
+	entry = (struct uv_IO_APIC_route_entry *)&mmr_value;
+	BUG_ON(sizeof(struct uv_IO_APIC_route_entry) != sizeof(unsigned long));
+
+	entry->vector = cfg->vector;
+	entry->delivery_mode = INT_DELIVERY_MODE;
+	entry->dest_mode = INT_DEST_MODE;
+	entry->polarity = 0;
+	entry->trigger = 0;
+	entry->mask = 0;
+	entry->dest = cpu_mask_to_apicid(*eligible_cpu);
+
+	mmr_pnode = uv_blade_to_pnode(mmr_blade);
+	uv_write_global_mmr64(mmr_pnode, mmr_offset, mmr_value);
+
+	return irq;
+}
+
+/*
+ * Disable the specified MMR located on the specified blade so that MSIs are
+ * longer allowed to be sent.
+ */
+void arch_disable_uv_irq(int mmr_blade, unsigned long mmr_offset)
+{
+	unsigned long mmr_value;
+	struct uv_IO_APIC_route_entry *entry;
+	int mmr_pnode;
+
+	mmr_value = 0;
+	entry = (struct uv_IO_APIC_route_entry *)&mmr_value;
+	BUG_ON(sizeof(struct uv_IO_APIC_route_entry) != sizeof(unsigned long));
+
+	entry->mask = 1;
+
+	mmr_pnode = uv_blade_to_pnode(mmr_blade);
+	uv_write_global_mmr64(mmr_pnode, mmr_offset, mmr_value);
+}
+#endif /* CONFIG_X86_64 */
+
+int __init io_apic_get_redir_entries (int ioapic)
+{
+	union IO_APIC_reg_01	reg_01;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ioapic_lock, flags);
+	reg_01.raw = io_apic_read(ioapic, 1);
+	spin_unlock_irqrestore(&ioapic_lock, flags);
+
+	return reg_01.bits.entries;
+}
+
+int __init probe_nr_irqs(void)
+{
+	int idx;
+	int nr = 0;
+#ifndef CONFIG_XEN
+	int nr_min = 32;
+#else
+	int nr_min = NR_IRQS;
+#endif
+
+	for (idx = 0; idx < nr_ioapics; idx++)
+		nr += io_apic_get_redir_entries(idx) + 1;
+
+	/* double it for hotplug and msi and nmi */
+	nr <<= 1;
+
+	/* something wrong ? */
+	if (nr < nr_min)
+		nr = nr_min;
+
+	return nr;
+}
+
 /* --------------------------------------------------------------------------
                           ACPI-based IOAPIC Configuration
    -------------------------------------------------------------------------- */
 
 #ifdef CONFIG_ACPI
 
-#define IO_APIC_MAX_ID		0xFE
+#ifdef CONFIG_X86_32
+int __init io_apic_get_unique_id(int ioapic, int apic_id)
+{
+	union IO_APIC_reg_00 reg_00;
+	static physid_mask_t apic_id_map = PHYSID_MASK_NONE;
+	physid_mask_t tmp;
+	unsigned long flags;
+	int i = 0;
 
-int __init io_apic_get_redir_entries (int ioapic)
+	/*
+	 * The P4 platform supports up to 256 APIC IDs on two separate APIC
+	 * buses (one for LAPICs, one for IOAPICs), where predecessors only
+	 * supports up to 16 on one shared APIC bus.
+	 *
+	 * TBD: Expand LAPIC/IOAPIC support on P4-class systems to take full
+	 *      advantage of new APIC bus architecture.
+	 */
+
+	if (physids_empty(apic_id_map))
+		apic_id_map = ioapic_phys_id_map(phys_cpu_present_map);
+
+	spin_lock_irqsave(&ioapic_lock, flags);
+	reg_00.raw = io_apic_read(ioapic, 0);
+	spin_unlock_irqrestore(&ioapic_lock, flags);
+
+	if (apic_id >= get_physical_broadcast()) {
+		printk(KERN_WARNING "IOAPIC[%d]: Invalid apic_id %d, trying "
+			"%d\n", ioapic, apic_id, reg_00.bits.ID);
+		apic_id = reg_00.bits.ID;
+	}
+
+	/*
+	 * Every APIC in a system must have a unique ID or we get lots of nice
+	 * 'stuck on smp_invalidate_needed IPI wait' messages.
+	 */
+	if (check_apicid_used(apic_id_map, apic_id)) {
+
+		for (i = 0; i < get_physical_broadcast(); i++) {
+			if (!check_apicid_used(apic_id_map, i))
+				break;
+		}
+
+		if (i == get_physical_broadcast())
+			panic("Max apic_id exceeded!\n");
+
+		printk(KERN_WARNING "IOAPIC[%d]: apic_id %d already used, "
+			"trying %d\n", ioapic, apic_id, i);
+
+		apic_id = i;
+	}
+
+	tmp = apicid_to_cpu_present(apic_id);
+	physids_or(apic_id_map, apic_id_map, tmp);
+
+	if (reg_00.bits.ID != apic_id) {
+		reg_00.bits.ID = apic_id;
+
+		spin_lock_irqsave(&ioapic_lock, flags);
+		io_apic_write(ioapic, 0, reg_00.raw);
+		reg_00.raw = io_apic_read(ioapic, 0);
+		spin_unlock_irqrestore(&ioapic_lock, flags);
+
+		/* Sanity check */
+		if (reg_00.bits.ID != apic_id) {
+			printk("IOAPIC[%d]: Unable to change apic_id!\n", ioapic);
+			return -1;
+		}
+	}
+
+	apic_printk(APIC_VERBOSE, KERN_INFO
+			"IOAPIC[%d]: Assigned apic_id %d\n", ioapic, apic_id);
+
+	return apic_id;
+}
+
+int __init io_apic_get_version(int ioapic)
 {
 	union IO_APIC_reg_01	reg_01;
 	unsigned long flags;
@@ -2799,9 +3885,9 @@ int __init io_apic_get_redir_entries (int ioapic)
 	reg_01.raw = io_apic_read(ioapic, 1);
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 
-	return reg_01.bits.entries;
+	return reg_01.bits.version;
 }
-
+#endif
 
 int io_apic_set_pci_routing (int ioapic, int pin, int irq, int triggering, int polarity)
 {
@@ -2853,6 +3939,7 @@ int acpi_get_override_irq(int bus_irq, int *trigger, int *polarity)
 void __init setup_ioapic_dest(void)
 {
 	int pin, ioapic, irq, irq_entry;
+	struct irq_cfg *cfg;
 
 	if (skip_ioapic_setup == 1)
 		return;
@@ -2868,7 +3955,8 @@ void __init setup_ioapic_dest(void)
 			 * when you have too many devices, because at that time only boot
 			 * cpu is online.
 			 */
-			if (!irq_cfg[irq].vector)
+			cfg = irq_cfg(irq);
+			if (!cfg->vector)
 				setup_IO_APIC_irq(ioapic, pin, irq,
 						  irq_trigger(irq_entry),
 						  irq_polarity(irq_entry));
@@ -2923,21 +4011,35 @@ static struct resource * __init ioapic_setup_resources(void)
 void __init ioapic_init_mappings(void)
 {
 	unsigned long ioapic_phys, idx = FIX_IO_APIC_BASE_0;
-	struct resource *ioapic_res;
 	int i;
+	struct resource *ioapic_res;
 
 	ioapic_res = ioapic_setup_resources();
 	for (i = 0; i < nr_ioapics; i++) {
 		if (smp_found_config) {
 			ioapic_phys = mp_ioapics[i].mp_apicaddr;
+#ifdef CONFIG_X86_32
+                        if (!ioapic_phys) {
+                                printk(KERN_ERR
+                                       "WARNING: bogus zero IO-APIC "
+                                       "address found in MPTABLE, "
+                                       "disabling IO/APIC support!\n");
+                                smp_found_config = 0;
+                                skip_ioapic_setup = 1;
+                                goto fake_ioapic_page;
+                        }
+#endif
 		} else {
+#ifdef CONFIG_X86_32
+fake_ioapic_page:
+#endif
 			ioapic_phys = (unsigned long)
 				alloc_bootmem_pages(PAGE_SIZE);
 			ioapic_phys = __pa(ioapic_phys);
 		}
 		set_fixmap_nocache(idx, ioapic_phys);
 		apic_printk(APIC_VERBOSE,
-			    "mapped IOAPIC to %016lx (%016lx)\n",
+			    "mapped IOAPIC to %08lx (%08lx)\n",
 			    __fix_to_virt(idx), ioapic_phys);
 		idx++;
 
@@ -2971,4 +4073,3 @@ static int __init ioapic_insert_resources(void)
 /* Insert the IO APIC resources after PCI initialization has occured to handle
  * IO APICS that are mapped in on a BAR in PCI space. */
 late_initcall(ioapic_insert_resources);
-
diff --git a/arch/x86/kernel/io_apic_32.c b/arch/x86/kernel/io_apic_32.c
deleted file mode 100644
index e710289..0000000
--- a/arch/x86/kernel/io_apic_32.c
+++ /dev/null
@@ -1,2908 +0,0 @@
-/*
- *	Intel IO-APIC support for multi-Pentium hosts.
- *
- *	Copyright (C) 1997, 1998, 1999, 2000 Ingo Molnar, Hajnalka Szabo
- *
- *	Many thanks to Stig Venaas for trying out countless experimental
- *	patches and reporting/debugging problems patiently!
- *
- *	(c) 1999, Multiple IO-APIC support, developed by
- *	Ken-ichi Yaku <yaku@css1.kbnes.nec.co.jp> and
- *      Hidemi Kishimoto <kisimoto@css1.kbnes.nec.co.jp>,
- *	further tested and cleaned up by Zach Brown <zab@redhat.com>
- *	and Ingo Molnar <mingo@redhat.com>
- *
- *	Fixes
- *	Maciej W. Rozycki	:	Bits for genuine 82489DX APICs;
- *					thanks to Eric Gilmore
- *					and Rolf G. Tews
- *					for testing these extensively
- *	Paul Diefenbaugh	:	Added full ACPI support
- */
-
-#include <linux/mm.h>
-#include <linux/interrupt.h>
-#include <linux/init.h>
-#include <linux/delay.h>
-#include <linux/sched.h>
-#include <linux/bootmem.h>
-#include <linux/mc146818rtc.h>
-#include <linux/compiler.h>
-#include <linux/acpi.h>
-#include <linux/module.h>
-#include <linux/sysdev.h>
-#include <linux/pci.h>
-#include <linux/msi.h>
-#include <linux/htirq.h>
-#include <linux/freezer.h>
-#include <linux/kthread.h>
-#include <linux/jiffies.h>	/* time_after() */
-
-#include <asm/io.h>
-#include <asm/smp.h>
-#include <asm/desc.h>
-#include <asm/timer.h>
-#include <asm/i8259.h>
-#include <asm/nmi.h>
-#include <asm/msidef.h>
-#include <asm/hypertransport.h>
-#include <asm/setup.h>
-
-#include <mach_apic.h>
-#include <mach_apicdef.h>
-
-#define __apicdebuginit(type) static type __init
-
-int (*ioapic_renumber_irq)(int ioapic, int irq);
-atomic_t irq_mis_count;
-
-/* Where if anywhere is the i8259 connect in external int mode */
-static struct { int pin, apic; } ioapic_i8259 = { -1, -1 };
-
-static DEFINE_SPINLOCK(ioapic_lock);
-DEFINE_SPINLOCK(vector_lock);
-
-int timer_through_8259 __initdata;
-
-/*
- *	Is the SiS APIC rmw bug present ?
- *	-1 = don't know, 0 = no, 1 = yes
- */
-int sis_apic_bug = -1;
-
-/*
- * # of IRQ routing registers
- */
-int nr_ioapic_registers[MAX_IO_APICS];
-
-/* I/O APIC entries */
-struct mp_config_ioapic mp_ioapics[MAX_IO_APICS];
-int nr_ioapics;
-
-/* MP IRQ source entries */
-struct mp_config_intsrc mp_irqs[MAX_IRQ_SOURCES];
-
-/* # of MP IRQ source entries */
-int mp_irq_entries;
-
-#if defined (CONFIG_MCA) || defined (CONFIG_EISA)
-int mp_bus_id_to_type[MAX_MP_BUSSES];
-#endif
-
-DECLARE_BITMAP(mp_bus_not_pci, MAX_MP_BUSSES);
-
-static int disable_timer_pin_1 __initdata;
-
-/*
- * Rough estimation of how many shared IRQs there are, can
- * be changed anytime.
- */
-#define MAX_PLUS_SHARED_IRQS NR_IRQS
-#define PIN_MAP_SIZE (MAX_PLUS_SHARED_IRQS + NR_IRQS)
-
-/*
- * This is performance-critical, we want to do it O(1)
- *
- * the indexing order of this array favors 1:1 mappings
- * between pins and IRQs.
- */
-
-static struct irq_pin_list {
-	int apic, pin, next;
-} irq_2_pin[PIN_MAP_SIZE];
-
-struct io_apic {
-	unsigned int index;
-	unsigned int unused[3];
-	unsigned int data;
-};
-
-static __attribute_const__ struct io_apic __iomem *io_apic_base(int idx)
-{
-	return (void __iomem *) __fix_to_virt(FIX_IO_APIC_BASE_0 + idx)
-		+ (mp_ioapics[idx].mp_apicaddr & ~PAGE_MASK);
-}
-
-static inline unsigned int io_apic_read(unsigned int apic, unsigned int reg)
-{
-	struct io_apic __iomem *io_apic = io_apic_base(apic);
-	writel(reg, &io_apic->index);
-	return readl(&io_apic->data);
-}
-
-static inline void io_apic_write(unsigned int apic, unsigned int reg, unsigned int value)
-{
-	struct io_apic __iomem *io_apic = io_apic_base(apic);
-	writel(reg, &io_apic->index);
-	writel(value, &io_apic->data);
-}
-
-/*
- * Re-write a value: to be used for read-modify-write
- * cycles where the read already set up the index register.
- *
- * Older SiS APIC requires we rewrite the index register
- */
-static inline void io_apic_modify(unsigned int apic, unsigned int reg, unsigned int value)
-{
-	volatile struct io_apic __iomem *io_apic = io_apic_base(apic);
-	if (sis_apic_bug)
-		writel(reg, &io_apic->index);
-	writel(value, &io_apic->data);
-}
-
-union entry_union {
-	struct { u32 w1, w2; };
-	struct IO_APIC_route_entry entry;
-};
-
-static struct IO_APIC_route_entry ioapic_read_entry(int apic, int pin)
-{
-	union entry_union eu;
-	unsigned long flags;
-	spin_lock_irqsave(&ioapic_lock, flags);
-	eu.w1 = io_apic_read(apic, 0x10 + 2 * pin);
-	eu.w2 = io_apic_read(apic, 0x11 + 2 * pin);
-	spin_unlock_irqrestore(&ioapic_lock, flags);
-	return eu.entry;
-}
-
-/*
- * When we write a new IO APIC routing entry, we need to write the high
- * word first! If the mask bit in the low word is clear, we will enable
- * the interrupt, and we need to make sure the entry is fully populated
- * before that happens.
- */
-static void
-__ioapic_write_entry(int apic, int pin, struct IO_APIC_route_entry e)
-{
-	union entry_union eu;
-	eu.entry = e;
-	io_apic_write(apic, 0x11 + 2*pin, eu.w2);
-	io_apic_write(apic, 0x10 + 2*pin, eu.w1);
-}
-
-static void ioapic_write_entry(int apic, int pin, struct IO_APIC_route_entry e)
-{
-	unsigned long flags;
-	spin_lock_irqsave(&ioapic_lock, flags);
-	__ioapic_write_entry(apic, pin, e);
-	spin_unlock_irqrestore(&ioapic_lock, flags);
-}
-
-/*
- * When we mask an IO APIC routing entry, we need to write the low
- * word first, in order to set the mask bit before we change the
- * high bits!
- */
-static void ioapic_mask_entry(int apic, int pin)
-{
-	unsigned long flags;
-	union entry_union eu = { .entry.mask = 1 };
-
-	spin_lock_irqsave(&ioapic_lock, flags);
-	io_apic_write(apic, 0x10 + 2*pin, eu.w1);
-	io_apic_write(apic, 0x11 + 2*pin, eu.w2);
-	spin_unlock_irqrestore(&ioapic_lock, flags);
-}
-
-/*
- * The common case is 1:1 IRQ<->pin mappings. Sometimes there are
- * shared ISA-space IRQs, so we have to support them. We are super
- * fast in the common case, and fast for shared ISA-space IRQs.
- */
-static void add_pin_to_irq(unsigned int irq, int apic, int pin)
-{
-	static int first_free_entry = NR_IRQS;
-	struct irq_pin_list *entry = irq_2_pin + irq;
-
-	while (entry->next)
-		entry = irq_2_pin + entry->next;
-
-	if (entry->pin != -1) {
-		entry->next = first_free_entry;
-		entry = irq_2_pin + entry->next;
-		if (++first_free_entry >= PIN_MAP_SIZE)
-			panic("io_apic.c: whoops");
-	}
-	entry->apic = apic;
-	entry->pin = pin;
-}
-
-/*
- * Reroute an IRQ to a different pin.
- */
-static void __init replace_pin_at_irq(unsigned int irq,
-				      int oldapic, int oldpin,
-				      int newapic, int newpin)
-{
-	struct irq_pin_list *entry = irq_2_pin + irq;
-
-	while (1) {
-		if (entry->apic == oldapic && entry->pin == oldpin) {
-			entry->apic = newapic;
-			entry->pin = newpin;
-		}
-		if (!entry->next)
-			break;
-		entry = irq_2_pin + entry->next;
-	}
-}
-
-static void __modify_IO_APIC_irq(unsigned int irq, unsigned long enable, unsigned long disable)
-{
-	struct irq_pin_list *entry = irq_2_pin + irq;
-	unsigned int pin, reg;
-
-	for (;;) {
-		pin = entry->pin;
-		if (pin == -1)
-			break;
-		reg = io_apic_read(entry->apic, 0x10 + pin*2);
-		reg &= ~disable;
-		reg |= enable;
-		io_apic_modify(entry->apic, 0x10 + pin*2, reg);
-		if (!entry->next)
-			break;
-		entry = irq_2_pin + entry->next;
-	}
-}
-
-/* mask = 1 */
-static void __mask_IO_APIC_irq(unsigned int irq)
-{
-	__modify_IO_APIC_irq(irq, IO_APIC_REDIR_MASKED, 0);
-}
-
-/* mask = 0 */
-static void __unmask_IO_APIC_irq(unsigned int irq)
-{
-	__modify_IO_APIC_irq(irq, 0, IO_APIC_REDIR_MASKED);
-}
-
-/* mask = 1, trigger = 0 */
-static void __mask_and_edge_IO_APIC_irq(unsigned int irq)
-{
-	__modify_IO_APIC_irq(irq, IO_APIC_REDIR_MASKED,
-				IO_APIC_REDIR_LEVEL_TRIGGER);
-}
-
-/* mask = 0, trigger = 1 */
-static void __unmask_and_level_IO_APIC_irq(unsigned int irq)
-{
-	__modify_IO_APIC_irq(irq, IO_APIC_REDIR_LEVEL_TRIGGER,
-				IO_APIC_REDIR_MASKED);
-}
-
-static void mask_IO_APIC_irq(unsigned int irq)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&ioapic_lock, flags);
-	__mask_IO_APIC_irq(irq);
-	spin_unlock_irqrestore(&ioapic_lock, flags);
-}
-
-static void unmask_IO_APIC_irq(unsigned int irq)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&ioapic_lock, flags);
-	__unmask_IO_APIC_irq(irq);
-	spin_unlock_irqrestore(&ioapic_lock, flags);
-}
-
-static void clear_IO_APIC_pin(unsigned int apic, unsigned int pin)
-{
-	struct IO_APIC_route_entry entry;
-
-	/* Check delivery_mode to be sure we're not clearing an SMI pin */
-	entry = ioapic_read_entry(apic, pin);
-	if (entry.delivery_mode == dest_SMI)
-		return;
-
-	/*
-	 * Disable it in the IO-APIC irq-routing table:
-	 */
-	ioapic_mask_entry(apic, pin);
-}
-
-static void clear_IO_APIC(void)
-{
-	int apic, pin;
-
-	for (apic = 0; apic < nr_ioapics; apic++)
-		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++)
-			clear_IO_APIC_pin(apic, pin);
-}
-
-#ifdef CONFIG_SMP
-static void set_ioapic_affinity_irq(unsigned int irq, cpumask_t cpumask)
-{
-	unsigned long flags;
-	int pin;
-	struct irq_pin_list *entry = irq_2_pin + irq;
-	unsigned int apicid_value;
-	cpumask_t tmp;
-
-	cpus_and(tmp, cpumask, cpu_online_map);
-	if (cpus_empty(tmp))
-		tmp = TARGET_CPUS;
-
-	cpus_and(cpumask, tmp, CPU_MASK_ALL);
-
-	apicid_value = cpu_mask_to_apicid(cpumask);
-	/* Prepare to do the io_apic_write */
-	apicid_value = apicid_value << 24;
-	spin_lock_irqsave(&ioapic_lock, flags);
-	for (;;) {
-		pin = entry->pin;
-		if (pin == -1)
-			break;
-		io_apic_write(entry->apic, 0x10 + 1 + pin*2, apicid_value);
-		if (!entry->next)
-			break;
-		entry = irq_2_pin + entry->next;
-	}
-	irq_desc[irq].affinity = cpumask;
-	spin_unlock_irqrestore(&ioapic_lock, flags);
-}
-
-#if defined(CONFIG_IRQBALANCE)
-# include <asm/processor.h>	/* kernel_thread() */
-# include <linux/kernel_stat.h>	/* kstat */
-# include <linux/slab.h>		/* kmalloc() */
-# include <linux/timer.h>
-
-#define IRQBALANCE_CHECK_ARCH -999
-#define MAX_BALANCED_IRQ_INTERVAL	(5*HZ)
-#define MIN_BALANCED_IRQ_INTERVAL	(HZ/2)
-#define BALANCED_IRQ_MORE_DELTA		(HZ/10)
-#define BALANCED_IRQ_LESS_DELTA		(HZ)
-
-static int irqbalance_disabled __read_mostly = IRQBALANCE_CHECK_ARCH;
-static int physical_balance __read_mostly;
-static long balanced_irq_interval __read_mostly = MAX_BALANCED_IRQ_INTERVAL;
-
-static struct irq_cpu_info {
-	unsigned long *last_irq;
-	unsigned long *irq_delta;
-	unsigned long irq;
-} irq_cpu_data[NR_CPUS];
-
-#define CPU_IRQ(cpu)		(irq_cpu_data[cpu].irq)
-#define LAST_CPU_IRQ(cpu, irq)   (irq_cpu_data[cpu].last_irq[irq])
-#define IRQ_DELTA(cpu, irq) 	(irq_cpu_data[cpu].irq_delta[irq])
-
-#define IDLE_ENOUGH(cpu,now) \
-	(idle_cpu(cpu) && ((now) - per_cpu(irq_stat, (cpu)).idle_timestamp > 1))
-
-#define IRQ_ALLOWED(cpu, allowed_mask)	cpu_isset(cpu, allowed_mask)
-
-#define CPU_TO_PACKAGEINDEX(i) (first_cpu(per_cpu(cpu_sibling_map, i)))
-
-static cpumask_t balance_irq_affinity[NR_IRQS] = {
-	[0 ... NR_IRQS-1] = CPU_MASK_ALL
-};
-
-void set_balance_irq_affinity(unsigned int irq, cpumask_t mask)
-{
-	balance_irq_affinity[irq] = mask;
-}
-
-static unsigned long move(int curr_cpu, cpumask_t allowed_mask,
-			unsigned long now, int direction)
-{
-	int search_idle = 1;
-	int cpu = curr_cpu;
-
-	goto inside;
-
-	do {
-		if (unlikely(cpu == curr_cpu))
-			search_idle = 0;
-inside:
-		if (direction == 1) {
-			cpu++;
-			if (cpu >= NR_CPUS)
-				cpu = 0;
-		} else {
-			cpu--;
-			if (cpu == -1)
-				cpu = NR_CPUS-1;
-		}
-	} while (!cpu_online(cpu) || !IRQ_ALLOWED(cpu, allowed_mask) ||
-			(search_idle && !IDLE_ENOUGH(cpu, now)));
-
-	return cpu;
-}
-
-static inline void balance_irq(int cpu, int irq)
-{
-	unsigned long now = jiffies;
-	cpumask_t allowed_mask;
-	unsigned int new_cpu;
-
-	if (irqbalance_disabled)
-		return;
-
-	cpus_and(allowed_mask, cpu_online_map, balance_irq_affinity[irq]);
-	new_cpu = move(cpu, allowed_mask, now, 1);
-	if (cpu != new_cpu)
-		set_pending_irq(irq, cpumask_of_cpu(new_cpu));
-}
-
-static inline void rotate_irqs_among_cpus(unsigned long useful_load_threshold)
-{
-	int i, j;
-
-	for_each_online_cpu(i) {
-		for (j = 0; j < NR_IRQS; j++) {
-			if (!irq_desc[j].action)
-				continue;
-			/* Is it a significant load ?  */
-			if (IRQ_DELTA(CPU_TO_PACKAGEINDEX(i), j) <
-						useful_load_threshold)
-				continue;
-			balance_irq(i, j);
-		}
-	}
-	balanced_irq_interval = max((long)MIN_BALANCED_IRQ_INTERVAL,
-		balanced_irq_interval - BALANCED_IRQ_LESS_DELTA);
-	return;
-}
-
-static void do_irq_balance(void)
-{
-	int i, j;
-	unsigned long max_cpu_irq = 0, min_cpu_irq = (~0);
-	unsigned long move_this_load = 0;
-	int max_loaded = 0, min_loaded = 0;
-	int load;
-	unsigned long useful_load_threshold = balanced_irq_interval + 10;
-	int selected_irq;
-	int tmp_loaded, first_attempt = 1;
-	unsigned long tmp_cpu_irq;
-	unsigned long imbalance = 0;
-	cpumask_t allowed_mask, target_cpu_mask, tmp;
-
-	for_each_possible_cpu(i) {
-		int package_index;
-		CPU_IRQ(i) = 0;
-		if (!cpu_online(i))
-			continue;
-		package_index = CPU_TO_PACKAGEINDEX(i);
-		for (j = 0; j < NR_IRQS; j++) {
-			unsigned long value_now, delta;
-			/* Is this an active IRQ or balancing disabled ? */
-			if (!irq_desc[j].action || irq_balancing_disabled(j))
-				continue;
-			if (package_index == i)
-				IRQ_DELTA(package_index, j) = 0;
-			/* Determine the total count per processor per IRQ */
-			value_now = (unsigned long) kstat_cpu(i).irqs[j];
-
-			/* Determine the activity per processor per IRQ */
-			delta = value_now - LAST_CPU_IRQ(i, j);
-
-			/* Update last_cpu_irq[][] for the next time */
-			LAST_CPU_IRQ(i, j) = value_now;
-
-			/* Ignore IRQs whose rate is less than the clock */
-			if (delta < useful_load_threshold)
-				continue;
-			/* update the load for the processor or package total */
-			IRQ_DELTA(package_index, j) += delta;
-
-			/* Keep track of the higher numbered sibling as well */
-			if (i != package_index)
-				CPU_IRQ(i) += delta;
-			/*
-			 * We have sibling A and sibling B in the package
-			 *
-			 * cpu_irq[A] = load for cpu A + load for cpu B
-			 * cpu_irq[B] = load for cpu B
-			 */
-			CPU_IRQ(package_index) += delta;
-		}
-	}
-	/* Find the least loaded processor package */
-	for_each_online_cpu(i) {
-		if (i != CPU_TO_PACKAGEINDEX(i))
-			continue;
-		if (min_cpu_irq > CPU_IRQ(i)) {
-			min_cpu_irq = CPU_IRQ(i);
-			min_loaded = i;
-		}
-	}
-	max_cpu_irq = ULONG_MAX;
-
-tryanothercpu:
-	/*
-	 * Look for heaviest loaded processor.
-	 * We may come back to get the next heaviest loaded processor.
-	 * Skip processors with trivial loads.
-	 */
-	tmp_cpu_irq = 0;
-	tmp_loaded = -1;
-	for_each_online_cpu(i) {
-		if (i != CPU_TO_PACKAGEINDEX(i))
-			continue;
-		if (max_cpu_irq <= CPU_IRQ(i))
-			continue;
-		if (tmp_cpu_irq < CPU_IRQ(i)) {
-			tmp_cpu_irq = CPU_IRQ(i);
-			tmp_loaded = i;
-		}
-	}
-
-	if (tmp_loaded == -1) {
-	 /*
-	  * In the case of small number of heavy interrupt sources,
-	  * loading some of the cpus too much. We use Ingo's original
-	  * approach to rotate them around.
-	  */
-		if (!first_attempt && imbalance >= useful_load_threshold) {
-			rotate_irqs_among_cpus(useful_load_threshold);
-			return;
-		}
-		goto not_worth_the_effort;
-	}
-
-	first_attempt = 0;		/* heaviest search */
-	max_cpu_irq = tmp_cpu_irq;	/* load */
-	max_loaded = tmp_loaded;	/* processor */
-	imbalance = (max_cpu_irq - min_cpu_irq) / 2;
-
-	/*
-	 * if imbalance is less than approx 10% of max load, then
-	 * observe diminishing returns action. - quit
-	 */
-	if (imbalance < (max_cpu_irq >> 3))
-		goto not_worth_the_effort;
-
-tryanotherirq:
-	/* if we select an IRQ to move that can't go where we want, then
-	 * see if there is another one to try.
-	 */
-	move_this_load = 0;
-	selected_irq = -1;
-	for (j = 0; j < NR_IRQS; j++) {
-		/* Is this an active IRQ? */
-		if (!irq_desc[j].action)
-			continue;
-		if (imbalance <= IRQ_DELTA(max_loaded, j))
-			continue;
-		/* Try to find the IRQ that is closest to the imbalance
-		 * without going over.
-		 */
-		if (move_this_load < IRQ_DELTA(max_loaded, j)) {
-			move_this_load = IRQ_DELTA(max_loaded, j);
-			selected_irq = j;
-		}
-	}
-	if (selected_irq == -1)
-		goto tryanothercpu;
-
-	imbalance = move_this_load;
-
-	/* For physical_balance case, we accumulated both load
-	 * values in the one of the siblings cpu_irq[],
-	 * to use the same code for physical and logical processors
-	 * as much as possible.
-	 *
-	 * NOTE: the cpu_irq[] array holds the sum of the load for
-	 * sibling A and sibling B in the slot for the lowest numbered
-	 * sibling (A), _AND_ the load for sibling B in the slot for
-	 * the higher numbered sibling.
-	 *
-	 * We seek the least loaded sibling by making the comparison
-	 * (A+B)/2 vs B
-	 */
-	load = CPU_IRQ(min_loaded) >> 1;
-	for_each_cpu_mask(j, per_cpu(cpu_sibling_map, min_loaded)) {
-		if (load > CPU_IRQ(j)) {
-			/* This won't change cpu_sibling_map[min_loaded] */
-			load = CPU_IRQ(j);
-			min_loaded = j;
-		}
-	}
-
-	cpus_and(allowed_mask,
-		cpu_online_map,
-		balance_irq_affinity[selected_irq]);
-	target_cpu_mask = cpumask_of_cpu(min_loaded);
-	cpus_and(tmp, target_cpu_mask, allowed_mask);
-
-	if (!cpus_empty(tmp)) {
-		/* mark for change destination */
-		set_pending_irq(selected_irq, cpumask_of_cpu(min_loaded));
-
-		/* Since we made a change, come back sooner to
-		 * check for more variation.
-		 */
-		balanced_irq_interval = max((long)MIN_BALANCED_IRQ_INTERVAL,
-			balanced_irq_interval - BALANCED_IRQ_LESS_DELTA);
-		return;
-	}
-	goto tryanotherirq;
-
-not_worth_the_effort:
-	/*
-	 * if we did not find an IRQ to move, then adjust the time interval
-	 * upward
-	 */
-	balanced_irq_interval = min((long)MAX_BALANCED_IRQ_INTERVAL,
-		balanced_irq_interval + BALANCED_IRQ_MORE_DELTA);
-	return;
-}
-
-static int balanced_irq(void *unused)
-{
-	int i;
-	unsigned long prev_balance_time = jiffies;
-	long time_remaining = balanced_irq_interval;
-
-	/* push everything to CPU 0 to give us a starting point.  */
-	for (i = 0 ; i < NR_IRQS ; i++) {
-		irq_desc[i].pending_mask = cpumask_of_cpu(0);
-		set_pending_irq(i, cpumask_of_cpu(0));
-	}
-
-	set_freezable();
-	for ( ; ; ) {
-		time_remaining = schedule_timeout_interruptible(time_remaining);
-		try_to_freeze();
-		if (time_after(jiffies,
-				prev_balance_time+balanced_irq_interval)) {
-			preempt_disable();
-			do_irq_balance();
-			prev_balance_time = jiffies;
-			time_remaining = balanced_irq_interval;
-			preempt_enable();
-		}
-	}
-	return 0;
-}
-
-static int __init balanced_irq_init(void)
-{
-	int i;
-	struct cpuinfo_x86 *c;
-	cpumask_t tmp;
-
-	cpus_shift_right(tmp, cpu_online_map, 2);
-	c = &boot_cpu_data;
-	/* When not overwritten by the command line ask subarchitecture. */
-	if (irqbalance_disabled == IRQBALANCE_CHECK_ARCH)
-		irqbalance_disabled = NO_BALANCE_IRQ;
-	if (irqbalance_disabled)
-		return 0;
-
-	 /* disable irqbalance completely if there is only one processor online */
-	if (num_online_cpus() < 2) {
-		irqbalance_disabled = 1;
-		return 0;
-	}
-	/*
-	 * Enable physical balance only if more than 1 physical processor
-	 * is present
-	 */
-	if (smp_num_siblings > 1 && !cpus_empty(tmp))
-		physical_balance = 1;
-
-	for_each_online_cpu(i) {
-		irq_cpu_data[i].irq_delta = kzalloc(sizeof(unsigned long) * NR_IRQS, GFP_KERNEL);
-		irq_cpu_data[i].last_irq = kzalloc(sizeof(unsigned long) * NR_IRQS, GFP_KERNEL);
-		if (irq_cpu_data[i].irq_delta == NULL || irq_cpu_data[i].last_irq == NULL) {
-			printk(KERN_ERR "balanced_irq_init: out of memory");
-			goto failed;
-		}
-	}
-
-	printk(KERN_INFO "Starting balanced_irq\n");
-	if (!IS_ERR(kthread_run(balanced_irq, NULL, "kirqd")))
-		return 0;
-	printk(KERN_ERR "balanced_irq_init: failed to spawn balanced_irq");
-failed:
-	for_each_possible_cpu(i) {
-		kfree(irq_cpu_data[i].irq_delta);
-		irq_cpu_data[i].irq_delta = NULL;
-		kfree(irq_cpu_data[i].last_irq);
-		irq_cpu_data[i].last_irq = NULL;
-	}
-	return 0;
-}
-
-int __devinit irqbalance_disable(char *str)
-{
-	irqbalance_disabled = 1;
-	return 1;
-}
-
-__setup("noirqbalance", irqbalance_disable);
-
-late_initcall(balanced_irq_init);
-#endif /* CONFIG_IRQBALANCE */
-#endif /* CONFIG_SMP */
-
-#ifndef CONFIG_SMP
-void send_IPI_self(int vector)
-{
-	unsigned int cfg;
-
-	/*
-	 * Wait for idle.
-	 */
-	apic_wait_icr_idle();
-	cfg = APIC_DM_FIXED | APIC_DEST_SELF | vector | APIC_DEST_LOGICAL;
-	/*
-	 * Send the IPI. The write to APIC_ICR fires this off.
-	 */
-	apic_write(APIC_ICR, cfg);
-}
-#endif /* !CONFIG_SMP */
-
-
-/*
- * support for broken MP BIOSs, enables hand-redirection of PIRQ0-7 to
- * specific CPU-side IRQs.
- */
-
-#define MAX_PIRQS 8
-static int pirq_entries [MAX_PIRQS];
-static int pirqs_enabled;
-int skip_ioapic_setup;
-
-static int __init ioapic_pirq_setup(char *str)
-{
-	int i, max;
-	int ints[MAX_PIRQS+1];
-
-	get_options(str, ARRAY_SIZE(ints), ints);
-
-	for (i = 0; i < MAX_PIRQS; i++)
-		pirq_entries[i] = -1;
-
-	pirqs_enabled = 1;
-	apic_printk(APIC_VERBOSE, KERN_INFO
-			"PIRQ redirection, working around broken MP-BIOS.\n");
-	max = MAX_PIRQS;
-	if (ints[0] < MAX_PIRQS)
-		max = ints[0];
-
-	for (i = 0; i < max; i++) {
-		apic_printk(APIC_VERBOSE, KERN_DEBUG
-				"... PIRQ%d -> IRQ %d\n", i, ints[i+1]);
-		/*
-		 * PIRQs are mapped upside down, usually.
-		 */
-		pirq_entries[MAX_PIRQS-i-1] = ints[i+1];
-	}
-	return 1;
-}
-
-__setup("pirq=", ioapic_pirq_setup);
-
-/*
- * Find the IRQ entry number of a certain pin.
- */
-static int find_irq_entry(int apic, int pin, int type)
-{
-	int i;
-
-	for (i = 0; i < mp_irq_entries; i++)
-		if (mp_irqs[i].mp_irqtype == type &&
-		    (mp_irqs[i].mp_dstapic == mp_ioapics[apic].mp_apicid ||
-		     mp_irqs[i].mp_dstapic == MP_APIC_ALL) &&
-		    mp_irqs[i].mp_dstirq == pin)
-			return i;
-
-	return -1;
-}
-
-/*
- * Find the pin to which IRQ[irq] (ISA) is connected
- */
-static int __init find_isa_irq_pin(int irq, int type)
-{
-	int i;
-
-	for (i = 0; i < mp_irq_entries; i++) {
-		int lbus = mp_irqs[i].mp_srcbus;
-
-		if (test_bit(lbus, mp_bus_not_pci) &&
-		    (mp_irqs[i].mp_irqtype == type) &&
-		    (mp_irqs[i].mp_srcbusirq == irq))
-
-			return mp_irqs[i].mp_dstirq;
-	}
-	return -1;
-}
-
-static int __init find_isa_irq_apic(int irq, int type)
-{
-	int i;
-
-	for (i = 0; i < mp_irq_entries; i++) {
-		int lbus = mp_irqs[i].mp_srcbus;
-
-		if (test_bit(lbus, mp_bus_not_pci) &&
-		    (mp_irqs[i].mp_irqtype == type) &&
-		    (mp_irqs[i].mp_srcbusirq == irq))
-			break;
-	}
-	if (i < mp_irq_entries) {
-		int apic;
-		for (apic = 0; apic < nr_ioapics; apic++) {
-			if (mp_ioapics[apic].mp_apicid == mp_irqs[i].mp_dstapic)
-				return apic;
-		}
-	}
-
-	return -1;
-}
-
-/*
- * Find a specific PCI IRQ entry.
- * Not an __init, possibly needed by modules
- */
-static int pin_2_irq(int idx, int apic, int pin);
-
-int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin)
-{
-	int apic, i, best_guess = -1;
-
-	apic_printk(APIC_DEBUG, "querying PCI -> IRQ mapping bus:%d, "
-		"slot:%d, pin:%d.\n", bus, slot, pin);
-	if (test_bit(bus, mp_bus_not_pci)) {
-		printk(KERN_WARNING "PCI BIOS passed nonexistent PCI bus %d!\n", bus);
-		return -1;
-	}
-	for (i = 0; i < mp_irq_entries; i++) {
-		int lbus = mp_irqs[i].mp_srcbus;
-
-		for (apic = 0; apic < nr_ioapics; apic++)
-			if (mp_ioapics[apic].mp_apicid == mp_irqs[i].mp_dstapic ||
-			    mp_irqs[i].mp_dstapic == MP_APIC_ALL)
-				break;
-
-		if (!test_bit(lbus, mp_bus_not_pci) &&
-		    !mp_irqs[i].mp_irqtype &&
-		    (bus == lbus) &&
-		    (slot == ((mp_irqs[i].mp_srcbusirq >> 2) & 0x1f))) {
-			int irq = pin_2_irq(i, apic, mp_irqs[i].mp_dstirq);
-
-			if (!(apic || IO_APIC_IRQ(irq)))
-				continue;
-
-			if (pin == (mp_irqs[i].mp_srcbusirq & 3))
-				return irq;
-			/*
-			 * Use the first all-but-pin matching entry as a
-			 * best-guess fuzzy result for broken mptables.
-			 */
-			if (best_guess < 0)
-				best_guess = irq;
-		}
-	}
-	return best_guess;
-}
-EXPORT_SYMBOL(IO_APIC_get_PCI_irq_vector);
-
-/*
- * This function currently is only a helper for the i386 smp boot process where
- * we need to reprogram the ioredtbls to cater for the cpus which have come online
- * so mask in all cases should simply be TARGET_CPUS
- */
-#ifdef CONFIG_SMP
-void __init setup_ioapic_dest(void)
-{
-	int pin, ioapic, irq, irq_entry;
-
-	if (skip_ioapic_setup == 1)
-		return;
-
-	for (ioapic = 0; ioapic < nr_ioapics; ioapic++) {
-		for (pin = 0; pin < nr_ioapic_registers[ioapic]; pin++) {
-			irq_entry = find_irq_entry(ioapic, pin, mp_INT);
-			if (irq_entry == -1)
-				continue;
-			irq = pin_2_irq(irq_entry, ioapic, pin);
-			set_ioapic_affinity_irq(irq, TARGET_CPUS);
-		}
-
-	}
-}
-#endif
-
-#if defined(CONFIG_EISA) || defined(CONFIG_MCA)
-/*
- * EISA Edge/Level control register, ELCR
- */
-static int EISA_ELCR(unsigned int irq)
-{
-	if (irq < 16) {
-		unsigned int port = 0x4d0 + (irq >> 3);
-		return (inb(port) >> (irq & 7)) & 1;
-	}
-	apic_printk(APIC_VERBOSE, KERN_INFO
-			"Broken MPtable reports ISA irq %d\n", irq);
-	return 0;
-}
-#endif
-
-/* ISA interrupts are always polarity zero edge triggered,
- * when listed as conforming in the MP table. */
-
-#define default_ISA_trigger(idx)	(0)
-#define default_ISA_polarity(idx)	(0)
-
-/* EISA interrupts are always polarity zero and can be edge or level
- * trigger depending on the ELCR value.  If an interrupt is listed as
- * EISA conforming in the MP table, that means its trigger type must
- * be read in from the ELCR */
-
-#define default_EISA_trigger(idx)	(EISA_ELCR(mp_irqs[idx].mp_srcbusirq))
-#define default_EISA_polarity(idx)	default_ISA_polarity(idx)
-
-/* PCI interrupts are always polarity one level triggered,
- * when listed as conforming in the MP table. */
-
-#define default_PCI_trigger(idx)	(1)
-#define default_PCI_polarity(idx)	(1)
-
-/* MCA interrupts are always polarity zero level triggered,
- * when listed as conforming in the MP table. */
-
-#define default_MCA_trigger(idx)	(1)
-#define default_MCA_polarity(idx)	default_ISA_polarity(idx)
-
-static int MPBIOS_polarity(int idx)
-{
-	int bus = mp_irqs[idx].mp_srcbus;
-	int polarity;
-
-	/*
-	 * Determine IRQ line polarity (high active or low active):
-	 */
-	switch (mp_irqs[idx].mp_irqflag & 3) {
-	case 0: /* conforms, ie. bus-type dependent polarity */
-	{
-		polarity = test_bit(bus, mp_bus_not_pci)?
-			default_ISA_polarity(idx):
-			default_PCI_polarity(idx);
-		break;
-	}
-	case 1: /* high active */
-	{
-		polarity = 0;
-		break;
-	}
-	case 2: /* reserved */
-	{
-		printk(KERN_WARNING "broken BIOS!!\n");
-		polarity = 1;
-		break;
-	}
-	case 3: /* low active */
-	{
-		polarity = 1;
-		break;
-	}
-	default: /* invalid */
-	{
-		printk(KERN_WARNING "broken BIOS!!\n");
-		polarity = 1;
-		break;
-	}
-	}
-	return polarity;
-}
-
-static int MPBIOS_trigger(int idx)
-{
-	int bus = mp_irqs[idx].mp_srcbus;
-	int trigger;
-
-	/*
-	 * Determine IRQ trigger mode (edge or level sensitive):
-	 */
-	switch ((mp_irqs[idx].mp_irqflag>>2) & 3) {
-	case 0: /* conforms, ie. bus-type dependent */
-	{
-		trigger = test_bit(bus, mp_bus_not_pci)?
-				default_ISA_trigger(idx):
-				default_PCI_trigger(idx);
-#if defined(CONFIG_EISA) || defined(CONFIG_MCA)
-		switch (mp_bus_id_to_type[bus]) {
-		case MP_BUS_ISA: /* ISA pin */
-		{
-			/* set before the switch */
-			break;
-		}
-		case MP_BUS_EISA: /* EISA pin */
-		{
-			trigger = default_EISA_trigger(idx);
-			break;
-		}
-		case MP_BUS_PCI: /* PCI pin */
-		{
-			/* set before the switch */
-			break;
-		}
-		case MP_BUS_MCA: /* MCA pin */
-		{
-			trigger = default_MCA_trigger(idx);
-			break;
-		}
-		default:
-		{
-			printk(KERN_WARNING "broken BIOS!!\n");
-			trigger = 1;
-			break;
-		}
-	}
-#endif
-		break;
-	}
-	case 1: /* edge */
-	{
-		trigger = 0;
-		break;
-	}
-	case 2: /* reserved */
-	{
-		printk(KERN_WARNING "broken BIOS!!\n");
-		trigger = 1;
-		break;
-	}
-	case 3: /* level */
-	{
-		trigger = 1;
-		break;
-	}
-	default: /* invalid */
-	{
-		printk(KERN_WARNING "broken BIOS!!\n");
-		trigger = 0;
-		break;
-	}
-	}
-	return trigger;
-}
-
-static inline int irq_polarity(int idx)
-{
-	return MPBIOS_polarity(idx);
-}
-
-static inline int irq_trigger(int idx)
-{
-	return MPBIOS_trigger(idx);
-}
-
-static int pin_2_irq(int idx, int apic, int pin)
-{
-	int irq, i;
-	int bus = mp_irqs[idx].mp_srcbus;
-
-	/*
-	 * Debugging check, we are in big trouble if this message pops up!
-	 */
-	if (mp_irqs[idx].mp_dstirq != pin)
-		printk(KERN_ERR "broken BIOS or MPTABLE parser, ayiee!!\n");
-
-	if (test_bit(bus, mp_bus_not_pci))
-		irq = mp_irqs[idx].mp_srcbusirq;
-	else {
-		/*
-		 * PCI IRQs are mapped in order
-		 */
-		i = irq = 0;
-		while (i < apic)
-			irq += nr_ioapic_registers[i++];
-		irq += pin;
-
-		/*
-		 * For MPS mode, so far only needed by ES7000 platform
-		 */
-		if (ioapic_renumber_irq)
-			irq = ioapic_renumber_irq(apic, irq);
-	}
-
-	/*
-	 * PCI IRQ command line redirection. Yes, limits are hardcoded.
-	 */
-	if ((pin >= 16) && (pin <= 23)) {
-		if (pirq_entries[pin-16] != -1) {
-			if (!pirq_entries[pin-16]) {
-				apic_printk(APIC_VERBOSE, KERN_DEBUG
-						"disabling PIRQ%d\n", pin-16);
-			} else {
-				irq = pirq_entries[pin-16];
-				apic_printk(APIC_VERBOSE, KERN_DEBUG
-						"using PIRQ%d -> IRQ %d\n",
-						pin-16, irq);
-			}
-		}
-	}
-	return irq;
-}
-
-static inline int IO_APIC_irq_trigger(int irq)
-{
-	int apic, idx, pin;
-
-	for (apic = 0; apic < nr_ioapics; apic++) {
-		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++) {
-			idx = find_irq_entry(apic, pin, mp_INT);
-			if ((idx != -1) && (irq == pin_2_irq(idx, apic, pin)))
-				return irq_trigger(idx);
-		}
-	}
-	/*
-	 * nonexistent IRQs are edge default
-	 */
-	return 0;
-}
-
-/* irq_vectors is indexed by the sum of all RTEs in all I/O APICs. */
-static u8 irq_vector[NR_IRQ_VECTORS] __read_mostly = { FIRST_DEVICE_VECTOR , 0 };
-
-static int __assign_irq_vector(int irq)
-{
-	static int current_vector = FIRST_DEVICE_VECTOR, current_offset;
-	int vector, offset;
-
-	BUG_ON((unsigned)irq >= NR_IRQ_VECTORS);
-
-	if (irq_vector[irq] > 0)
-		return irq_vector[irq];
-
-	vector = current_vector;
-	offset = current_offset;
-next:
-	vector += 8;
-	if (vector >= first_system_vector) {
-		offset = (offset + 1) % 8;
-		vector = FIRST_DEVICE_VECTOR + offset;
-	}
-	if (vector == current_vector)
-		return -ENOSPC;
-	if (test_and_set_bit(vector, used_vectors))
-		goto next;
-
-	current_vector = vector;
-	current_offset = offset;
-	irq_vector[irq] = vector;
-
-	return vector;
-}
-
-static int assign_irq_vector(int irq)
-{
-	unsigned long flags;
-	int vector;
-
-	spin_lock_irqsave(&vector_lock, flags);
-	vector = __assign_irq_vector(irq);
-	spin_unlock_irqrestore(&vector_lock, flags);
-
-	return vector;
-}
-
-static struct irq_chip ioapic_chip;
-
-#define IOAPIC_AUTO	-1
-#define IOAPIC_EDGE	0
-#define IOAPIC_LEVEL	1
-
-static void ioapic_register_intr(int irq, int vector, unsigned long trigger)
-{
-	if ((trigger == IOAPIC_AUTO && IO_APIC_irq_trigger(irq)) ||
-	    trigger == IOAPIC_LEVEL) {
-		irq_desc[irq].status |= IRQ_LEVEL;
-		set_irq_chip_and_handler_name(irq, &ioapic_chip,
-					 handle_fasteoi_irq, "fasteoi");
-	} else {
-		irq_desc[irq].status &= ~IRQ_LEVEL;
-		set_irq_chip_and_handler_name(irq, &ioapic_chip,
-					 handle_edge_irq, "edge");
-	}
-	set_intr_gate(vector, interrupt[irq]);
-}
-
-static void __init setup_IO_APIC_irqs(void)
-{
-	struct IO_APIC_route_entry entry;
-	int apic, pin, idx, irq, first_notcon = 1, vector;
-
-	apic_printk(APIC_VERBOSE, KERN_DEBUG "init IO_APIC IRQs\n");
-
-	for (apic = 0; apic < nr_ioapics; apic++) {
-	for (pin = 0; pin < nr_ioapic_registers[apic]; pin++) {
-
-		/*
-		 * add it to the IO-APIC irq-routing table:
-		 */
-		memset(&entry, 0, sizeof(entry));
-
-		entry.delivery_mode = INT_DELIVERY_MODE;
-		entry.dest_mode = INT_DEST_MODE;
-		entry.mask = 0;				/* enable IRQ */
-		entry.dest.logical.logical_dest =
-					cpu_mask_to_apicid(TARGET_CPUS);
-
-		idx = find_irq_entry(apic, pin, mp_INT);
-		if (idx == -1) {
-			if (first_notcon) {
-				apic_printk(APIC_VERBOSE, KERN_DEBUG
-						" IO-APIC (apicid-pin) %d-%d",
-						mp_ioapics[apic].mp_apicid,
-						pin);
-				first_notcon = 0;
-			} else
-				apic_printk(APIC_VERBOSE, ", %d-%d",
-					mp_ioapics[apic].mp_apicid, pin);
-			continue;
-		}
-
-		if (!first_notcon) {
-			apic_printk(APIC_VERBOSE, " not connected.\n");
-			first_notcon = 1;
-		}
-
-		entry.trigger = irq_trigger(idx);
-		entry.polarity = irq_polarity(idx);
-
-		if (irq_trigger(idx)) {
-			entry.trigger = 1;
-			entry.mask = 1;
-		}
-
-		irq = pin_2_irq(idx, apic, pin);
-		/*
-		 * skip adding the timer int on secondary nodes, which causes
-		 * a small but painful rift in the time-space continuum
-		 */
-		if (multi_timer_check(apic, irq))
-			continue;
-		else
-			add_pin_to_irq(irq, apic, pin);
-
-		if (!apic && !IO_APIC_IRQ(irq))
-			continue;
-
-		if (IO_APIC_IRQ(irq)) {
-			vector = assign_irq_vector(irq);
-			entry.vector = vector;
-			ioapic_register_intr(irq, vector, IOAPIC_AUTO);
-
-			if (!apic && (irq < 16))
-				disable_8259A_irq(irq);
-		}
-		ioapic_write_entry(apic, pin, entry);
-	}
-	}
-
-	if (!first_notcon)
-		apic_printk(APIC_VERBOSE, " not connected.\n");
-}
-
-/*
- * Set up the timer pin, possibly with the 8259A-master behind.
- */
-static void __init setup_timer_IRQ0_pin(unsigned int apic, unsigned int pin,
-					int vector)
-{
-	struct IO_APIC_route_entry entry;
-
-	memset(&entry, 0, sizeof(entry));
-
-	/*
-	 * We use logical delivery to get the timer IRQ
-	 * to the first CPU.
-	 */
-	entry.dest_mode = INT_DEST_MODE;
-	entry.mask = 1;					/* mask IRQ now */
-	entry.dest.logical.logical_dest = cpu_mask_to_apicid(TARGET_CPUS);
-	entry.delivery_mode = INT_DELIVERY_MODE;
-	entry.polarity = 0;
-	entry.trigger = 0;
-	entry.vector = vector;
-
-	/*
-	 * The timer IRQ doesn't have to know that behind the
-	 * scene we may have a 8259A-master in AEOI mode ...
-	 */
-	ioapic_register_intr(0, vector, IOAPIC_EDGE);
-
-	/*
-	 * Add it to the IO-APIC irq-routing table:
-	 */
-	ioapic_write_entry(apic, pin, entry);
-}
-
-
-__apicdebuginit(void) print_IO_APIC(void)
-{
-	int apic, i;
-	union IO_APIC_reg_00 reg_00;
-	union IO_APIC_reg_01 reg_01;
-	union IO_APIC_reg_02 reg_02;
-	union IO_APIC_reg_03 reg_03;
-	unsigned long flags;
-
-	if (apic_verbosity == APIC_QUIET)
-		return;
-
-	printk(KERN_DEBUG "number of MP IRQ sources: %d.\n", mp_irq_entries);
-	for (i = 0; i < nr_ioapics; i++)
-		printk(KERN_DEBUG "number of IO-APIC #%d registers: %d.\n",
-		       mp_ioapics[i].mp_apicid, nr_ioapic_registers[i]);
-
-	/*
-	 * We are a bit conservative about what we expect.  We have to
-	 * know about every hardware change ASAP.
-	 */
-	printk(KERN_INFO "testing the IO APIC.......................\n");
-
-	for (apic = 0; apic < nr_ioapics; apic++) {
-
-	spin_lock_irqsave(&ioapic_lock, flags);
-	reg_00.raw = io_apic_read(apic, 0);
-	reg_01.raw = io_apic_read(apic, 1);
-	if (reg_01.bits.version >= 0x10)
-		reg_02.raw = io_apic_read(apic, 2);
-	if (reg_01.bits.version >= 0x20)
-		reg_03.raw = io_apic_read(apic, 3);
-	spin_unlock_irqrestore(&ioapic_lock, flags);
-
-	printk(KERN_DEBUG "IO APIC #%d......\n", mp_ioapics[apic].mp_apicid);
-	printk(KERN_DEBUG ".... register #00: %08X\n", reg_00.raw);
-	printk(KERN_DEBUG ".......    : physical APIC id: %02X\n", reg_00.bits.ID);
-	printk(KERN_DEBUG ".......    : Delivery Type: %X\n", reg_00.bits.delivery_type);
-	printk(KERN_DEBUG ".......    : LTS          : %X\n", reg_00.bits.LTS);
-
-	printk(KERN_DEBUG ".... register #01: %08X\n", reg_01.raw);
-	printk(KERN_DEBUG ".......     : max redirection entries: %04X\n", reg_01.bits.entries);
-
-	printk(KERN_DEBUG ".......     : PRQ implemented: %X\n", reg_01.bits.PRQ);
-	printk(KERN_DEBUG ".......     : IO APIC version: %04X\n", reg_01.bits.version);
-
-	/*
-	 * Some Intel chipsets with IO APIC VERSION of 0x1? don't have reg_02,
-	 * but the value of reg_02 is read as the previous read register
-	 * value, so ignore it if reg_02 == reg_01.
-	 */
-	if (reg_01.bits.version >= 0x10 && reg_02.raw != reg_01.raw) {
-		printk(KERN_DEBUG ".... register #02: %08X\n", reg_02.raw);
-		printk(KERN_DEBUG ".......     : arbitration: %02X\n", reg_02.bits.arbitration);
-	}
-
-	/*
-	 * Some Intel chipsets with IO APIC VERSION of 0x2? don't have reg_02
-	 * or reg_03, but the value of reg_0[23] is read as the previous read
-	 * register value, so ignore it if reg_03 == reg_0[12].
-	 */
-	if (reg_01.bits.version >= 0x20 && reg_03.raw != reg_02.raw &&
-	    reg_03.raw != reg_01.raw) {
-		printk(KERN_DEBUG ".... register #03: %08X\n", reg_03.raw);
-		printk(KERN_DEBUG ".......     : Boot DT    : %X\n", reg_03.bits.boot_DT);
-	}
-
-	printk(KERN_DEBUG ".... IRQ redirection table:\n");
-
-	printk(KERN_DEBUG " NR Log Phy Mask Trig IRR Pol"
-			  " Stat Dest Deli Vect:   \n");
-
-	for (i = 0; i <= reg_01.bits.entries; i++) {
-		struct IO_APIC_route_entry entry;
-
-		entry = ioapic_read_entry(apic, i);
-
-		printk(KERN_DEBUG " %02x %03X %02X  ",
-			i,
-			entry.dest.logical.logical_dest,
-			entry.dest.physical.physical_dest
-		);
-
-		printk("%1d    %1d    %1d   %1d   %1d    %1d    %1d    %02X\n",
-			entry.mask,
-			entry.trigger,
-			entry.irr,
-			entry.polarity,
-			entry.delivery_status,
-			entry.dest_mode,
-			entry.delivery_mode,
-			entry.vector
-		);
-	}
-	}
-	printk(KERN_DEBUG "IRQ to pin mappings:\n");
-	for (i = 0; i < NR_IRQS; i++) {
-		struct irq_pin_list *entry = irq_2_pin + i;
-		if (entry->pin < 0)
-			continue;
-		printk(KERN_DEBUG "IRQ%d ", i);
-		for (;;) {
-			printk("-> %d:%d", entry->apic, entry->pin);
-			if (!entry->next)
-				break;
-			entry = irq_2_pin + entry->next;
-		}
-		printk("\n");
-	}
-
-	printk(KERN_INFO ".................................... done.\n");
-
-	return;
-}
-
-__apicdebuginit(void) print_APIC_bitfield(int base)
-{
-	unsigned int v;
-	int i, j;
-
-	if (apic_verbosity == APIC_QUIET)
-		return;
-
-	printk(KERN_DEBUG "0123456789abcdef0123456789abcdef\n" KERN_DEBUG);
-	for (i = 0; i < 8; i++) {
-		v = apic_read(base + i*0x10);
-		for (j = 0; j < 32; j++) {
-			if (v & (1<<j))
-				printk("1");
-			else
-				printk("0");
-		}
-		printk("\n");
-	}
-}
-
-__apicdebuginit(void) print_local_APIC(void *dummy)
-{
-	unsigned int v, ver, maxlvt;
-	u64 icr;
-
-	if (apic_verbosity == APIC_QUIET)
-		return;
-
-	printk("\n" KERN_DEBUG "printing local APIC contents on CPU#%d/%d:\n",
-		smp_processor_id(), hard_smp_processor_id());
-	v = apic_read(APIC_ID);
-	printk(KERN_INFO "... APIC ID:      %08x (%01x)\n", v,
-			GET_APIC_ID(v));
-	v = apic_read(APIC_LVR);
-	printk(KERN_INFO "... APIC VERSION: %08x\n", v);
-	ver = GET_APIC_VERSION(v);
-	maxlvt = lapic_get_maxlvt();
-
-	v = apic_read(APIC_TASKPRI);
-	printk(KERN_DEBUG "... APIC TASKPRI: %08x (%02x)\n", v, v & APIC_TPRI_MASK);
-
-	if (APIC_INTEGRATED(ver)) {			/* !82489DX */
-		v = apic_read(APIC_ARBPRI);
-		printk(KERN_DEBUG "... APIC ARBPRI: %08x (%02x)\n", v,
-			v & APIC_ARBPRI_MASK);
-		v = apic_read(APIC_PROCPRI);
-		printk(KERN_DEBUG "... APIC PROCPRI: %08x\n", v);
-	}
-
-	v = apic_read(APIC_EOI);
-	printk(KERN_DEBUG "... APIC EOI: %08x\n", v);
-	v = apic_read(APIC_RRR);
-	printk(KERN_DEBUG "... APIC RRR: %08x\n", v);
-	v = apic_read(APIC_LDR);
-	printk(KERN_DEBUG "... APIC LDR: %08x\n", v);
-	v = apic_read(APIC_DFR);
-	printk(KERN_DEBUG "... APIC DFR: %08x\n", v);
-	v = apic_read(APIC_SPIV);
-	printk(KERN_DEBUG "... APIC SPIV: %08x\n", v);
-
-	printk(KERN_DEBUG "... APIC ISR field:\n");
-	print_APIC_bitfield(APIC_ISR);
-	printk(KERN_DEBUG "... APIC TMR field:\n");
-	print_APIC_bitfield(APIC_TMR);
-	printk(KERN_DEBUG "... APIC IRR field:\n");
-	print_APIC_bitfield(APIC_IRR);
-
-	if (APIC_INTEGRATED(ver)) {		/* !82489DX */
-		if (maxlvt > 3)		/* Due to the Pentium erratum 3AP. */
-			apic_write(APIC_ESR, 0);
-		v = apic_read(APIC_ESR);
-		printk(KERN_DEBUG "... APIC ESR: %08x\n", v);
-	}
-
-	icr = apic_icr_read();
-	printk(KERN_DEBUG "... APIC ICR: %08x\n", icr);
-	printk(KERN_DEBUG "... APIC ICR2: %08x\n", icr >> 32);
-
-	v = apic_read(APIC_LVTT);
-	printk(KERN_DEBUG "... APIC LVTT: %08x\n", v);
-
-	if (maxlvt > 3) {                       /* PC is LVT#4. */
-		v = apic_read(APIC_LVTPC);
-		printk(KERN_DEBUG "... APIC LVTPC: %08x\n", v);
-	}
-	v = apic_read(APIC_LVT0);
-	printk(KERN_DEBUG "... APIC LVT0: %08x\n", v);
-	v = apic_read(APIC_LVT1);
-	printk(KERN_DEBUG "... APIC LVT1: %08x\n", v);
-
-	if (maxlvt > 2) {			/* ERR is LVT#3. */
-		v = apic_read(APIC_LVTERR);
-		printk(KERN_DEBUG "... APIC LVTERR: %08x\n", v);
-	}
-
-	v = apic_read(APIC_TMICT);
-	printk(KERN_DEBUG "... APIC TMICT: %08x\n", v);
-	v = apic_read(APIC_TMCCT);
-	printk(KERN_DEBUG "... APIC TMCCT: %08x\n", v);
-	v = apic_read(APIC_TDCR);
-	printk(KERN_DEBUG "... APIC TDCR: %08x\n", v);
-	printk("\n");
-}
-
-__apicdebuginit(void) print_all_local_APICs(void)
-{
-	on_each_cpu(print_local_APIC, NULL, 1);
-}
-
-__apicdebuginit(void) print_PIC(void)
-{
-	unsigned int v;
-	unsigned long flags;
-
-	if (apic_verbosity == APIC_QUIET)
-		return;
-
-	printk(KERN_DEBUG "\nprinting PIC contents\n");
-
-	spin_lock_irqsave(&i8259A_lock, flags);
-
-	v = inb(0xa1) << 8 | inb(0x21);
-	printk(KERN_DEBUG "... PIC  IMR: %04x\n", v);
-
-	v = inb(0xa0) << 8 | inb(0x20);
-	printk(KERN_DEBUG "... PIC  IRR: %04x\n", v);
-
-	outb(0x0b, 0xa0);
-	outb(0x0b, 0x20);
-	v = inb(0xa0) << 8 | inb(0x20);
-	outb(0x0a, 0xa0);
-	outb(0x0a, 0x20);
-
-	spin_unlock_irqrestore(&i8259A_lock, flags);
-
-	printk(KERN_DEBUG "... PIC  ISR: %04x\n", v);
-
-	v = inb(0x4d1) << 8 | inb(0x4d0);
-	printk(KERN_DEBUG "... PIC ELCR: %04x\n", v);
-}
-
-__apicdebuginit(int) print_all_ICs(void)
-{
-	print_PIC();
-	print_all_local_APICs();
-	print_IO_APIC();
-
-	return 0;
-}
-
-fs_initcall(print_all_ICs);
-
-
-static void __init enable_IO_APIC(void)
-{
-	union IO_APIC_reg_01 reg_01;
-	int i8259_apic, i8259_pin;
-	int i, apic;
-	unsigned long flags;
-
-	for (i = 0; i < PIN_MAP_SIZE; i++) {
-		irq_2_pin[i].pin = -1;
-		irq_2_pin[i].next = 0;
-	}
-	if (!pirqs_enabled)
-		for (i = 0; i < MAX_PIRQS; i++)
-			pirq_entries[i] = -1;
-
-	/*
-	 * The number of IO-APIC IRQ registers (== #pins):
-	 */
-	for (apic = 0; apic < nr_ioapics; apic++) {
-		spin_lock_irqsave(&ioapic_lock, flags);
-		reg_01.raw = io_apic_read(apic, 1);
-		spin_unlock_irqrestore(&ioapic_lock, flags);
-		nr_ioapic_registers[apic] = reg_01.bits.entries+1;
-	}
-	for (apic = 0; apic < nr_ioapics; apic++) {
-		int pin;
-		/* See if any of the pins is in ExtINT mode */
-		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++) {
-			struct IO_APIC_route_entry entry;
-			entry = ioapic_read_entry(apic, pin);
-
-
-			/* If the interrupt line is enabled and in ExtInt mode
-			 * I have found the pin where the i8259 is connected.
-			 */
-			if ((entry.mask == 0) && (entry.delivery_mode == dest_ExtINT)) {
-				ioapic_i8259.apic = apic;
-				ioapic_i8259.pin  = pin;
-				goto found_i8259;
-			}
-		}
-	}
- found_i8259:
-	/* Look to see what if the MP table has reported the ExtINT */
-	/* If we could not find the appropriate pin by looking at the ioapic
-	 * the i8259 probably is not connected the ioapic but give the
-	 * mptable a chance anyway.
-	 */
-	i8259_pin  = find_isa_irq_pin(0, mp_ExtINT);
-	i8259_apic = find_isa_irq_apic(0, mp_ExtINT);
-	/* Trust the MP table if nothing is setup in the hardware */
-	if ((ioapic_i8259.pin == -1) && (i8259_pin >= 0)) {
-		printk(KERN_WARNING "ExtINT not setup in hardware but reported by MP table\n");
-		ioapic_i8259.pin  = i8259_pin;
-		ioapic_i8259.apic = i8259_apic;
-	}
-	/* Complain if the MP table and the hardware disagree */
-	if (((ioapic_i8259.apic != i8259_apic) || (ioapic_i8259.pin != i8259_pin)) &&
-		(i8259_pin >= 0) && (ioapic_i8259.pin >= 0))
-	{
-		printk(KERN_WARNING "ExtINT in hardware and MP table differ\n");
-	}
-
-	/*
-	 * Do not trust the IO-APIC being empty at bootup
-	 */
-	clear_IO_APIC();
-}
-
-/*
- * Not an __init, needed by the reboot code
- */
-void disable_IO_APIC(void)
-{
-	/*
-	 * Clear the IO-APIC before rebooting:
-	 */
-	clear_IO_APIC();
-
-	/*
-	 * If the i8259 is routed through an IOAPIC
-	 * Put that IOAPIC in virtual wire mode
-	 * so legacy interrupts can be delivered.
-	 */
-	if (ioapic_i8259.pin != -1) {
-		struct IO_APIC_route_entry entry;
-
-		memset(&entry, 0, sizeof(entry));
-		entry.mask            = 0; /* Enabled */
-		entry.trigger         = 0; /* Edge */
-		entry.irr             = 0;
-		entry.polarity        = 0; /* High */
-		entry.delivery_status = 0;
-		entry.dest_mode       = 0; /* Physical */
-		entry.delivery_mode   = dest_ExtINT; /* ExtInt */
-		entry.vector          = 0;
-		entry.dest.physical.physical_dest = read_apic_id();
-
-		/*
-		 * Add it to the IO-APIC irq-routing table:
-		 */
-		ioapic_write_entry(ioapic_i8259.apic, ioapic_i8259.pin, entry);
-	}
-	disconnect_bsp_APIC(ioapic_i8259.pin != -1);
-}
-
-/*
- * function to set the IO-APIC physical IDs based on the
- * values stored in the MPC table.
- *
- * by Matt Domsch <Matt_Domsch@dell.com>  Tue Dec 21 12:25:05 CST 1999
- */
-
-static void __init setup_ioapic_ids_from_mpc(void)
-{
-	union IO_APIC_reg_00 reg_00;
-	physid_mask_t phys_id_present_map;
-	int apic;
-	int i;
-	unsigned char old_id;
-	unsigned long flags;
-
-	if (x86_quirks->setup_ioapic_ids && x86_quirks->setup_ioapic_ids())
-		return;
-
-	/*
-	 * Don't check I/O APIC IDs for xAPIC systems.  They have
-	 * no meaning without the serial APIC bus.
-	 */
-	if (!(boot_cpu_data.x86_vendor == X86_VENDOR_INTEL)
-		|| APIC_XAPIC(apic_version[boot_cpu_physical_apicid]))
-		return;
-	/*
-	 * This is broken; anything with a real cpu count has to
-	 * circumvent this idiocy regardless.
-	 */
-	phys_id_present_map = ioapic_phys_id_map(phys_cpu_present_map);
-
-	/*
-	 * Set the IOAPIC ID to the value stored in the MPC table.
-	 */
-	for (apic = 0; apic < nr_ioapics; apic++) {
-
-		/* Read the register 0 value */
-		spin_lock_irqsave(&ioapic_lock, flags);
-		reg_00.raw = io_apic_read(apic, 0);
-		spin_unlock_irqrestore(&ioapic_lock, flags);
-
-		old_id = mp_ioapics[apic].mp_apicid;
-
-		if (mp_ioapics[apic].mp_apicid >= get_physical_broadcast()) {
-			printk(KERN_ERR "BIOS bug, IO-APIC#%d ID is %d in the MPC table!...\n",
-				apic, mp_ioapics[apic].mp_apicid);
-			printk(KERN_ERR "... fixing up to %d. (tell your hw vendor)\n",
-				reg_00.bits.ID);
-			mp_ioapics[apic].mp_apicid = reg_00.bits.ID;
-		}
-
-		/*
-		 * Sanity check, is the ID really free? Every APIC in a
-		 * system must have a unique ID or we get lots of nice
-		 * 'stuck on smp_invalidate_needed IPI wait' messages.
-		 */
-		if (check_apicid_used(phys_id_present_map,
-					mp_ioapics[apic].mp_apicid)) {
-			printk(KERN_ERR "BIOS bug, IO-APIC#%d ID %d is already used!...\n",
-				apic, mp_ioapics[apic].mp_apicid);
-			for (i = 0; i < get_physical_broadcast(); i++)
-				if (!physid_isset(i, phys_id_present_map))
-					break;
-			if (i >= get_physical_broadcast())
-				panic("Max APIC ID exceeded!\n");
-			printk(KERN_ERR "... fixing up to %d. (tell your hw vendor)\n",
-				i);
-			physid_set(i, phys_id_present_map);
-			mp_ioapics[apic].mp_apicid = i;
-		} else {
-			physid_mask_t tmp;
-			tmp = apicid_to_cpu_present(mp_ioapics[apic].mp_apicid);
-			apic_printk(APIC_VERBOSE, "Setting %d in the "
-					"phys_id_present_map\n",
-					mp_ioapics[apic].mp_apicid);
-			physids_or(phys_id_present_map, phys_id_present_map, tmp);
-		}
-
-
-		/*
-		 * We need to adjust the IRQ routing table
-		 * if the ID changed.
-		 */
-		if (old_id != mp_ioapics[apic].mp_apicid)
-			for (i = 0; i < mp_irq_entries; i++)
-				if (mp_irqs[i].mp_dstapic == old_id)
-					mp_irqs[i].mp_dstapic
-						= mp_ioapics[apic].mp_apicid;
-
-		/*
-		 * Read the right value from the MPC table and
-		 * write it into the ID register.
-		 */
-		apic_printk(APIC_VERBOSE, KERN_INFO
-			"...changing IO-APIC physical APIC ID to %d ...",
-			mp_ioapics[apic].mp_apicid);
-
-		reg_00.bits.ID = mp_ioapics[apic].mp_apicid;
-		spin_lock_irqsave(&ioapic_lock, flags);
-		io_apic_write(apic, 0, reg_00.raw);
-		spin_unlock_irqrestore(&ioapic_lock, flags);
-
-		/*
-		 * Sanity check
-		 */
-		spin_lock_irqsave(&ioapic_lock, flags);
-		reg_00.raw = io_apic_read(apic, 0);
-		spin_unlock_irqrestore(&ioapic_lock, flags);
-		if (reg_00.bits.ID != mp_ioapics[apic].mp_apicid)
-			printk("could not set ID!\n");
-		else
-			apic_printk(APIC_VERBOSE, " ok.\n");
-	}
-}
-
-int no_timer_check __initdata;
-
-static int __init notimercheck(char *s)
-{
-	no_timer_check = 1;
-	return 1;
-}
-__setup("no_timer_check", notimercheck);
-
-/*
- * There is a nasty bug in some older SMP boards, their mptable lies
- * about the timer IRQ. We do the following to work around the situation:
- *
- *	- timer IRQ defaults to IO-APIC IRQ
- *	- if this function detects that timer IRQs are defunct, then we fall
- *	  back to ISA timer IRQs
- */
-static int __init timer_irq_works(void)
-{
-	unsigned long t1 = jiffies;
-	unsigned long flags;
-
-	if (no_timer_check)
-		return 1;
-
-	local_save_flags(flags);
-	local_irq_enable();
-	/* Let ten ticks pass... */
-	mdelay((10 * 1000) / HZ);
-	local_irq_restore(flags);
-
-	/*
-	 * Expect a few ticks at least, to be sure some possible
-	 * glue logic does not lock up after one or two first
-	 * ticks in a non-ExtINT mode.  Also the local APIC
-	 * might have cached one ExtINT interrupt.  Finally, at
-	 * least one tick may be lost due to delays.
-	 */
-	if (time_after(jiffies, t1 + 4))
-		return 1;
-
-	return 0;
-}
-
-/*
- * In the SMP+IOAPIC case it might happen that there are an unspecified
- * number of pending IRQ events unhandled. These cases are very rare,
- * so we 'resend' these IRQs via IPIs, to the same CPU. It's much
- * better to do it this way as thus we do not have to be aware of
- * 'pending' interrupts in the IRQ path, except at this point.
- */
-/*
- * Edge triggered needs to resend any interrupt
- * that was delayed but this is now handled in the device
- * independent code.
- */
-
-/*
- * Startup quirk:
- *
- * Starting up a edge-triggered IO-APIC interrupt is
- * nasty - we need to make sure that we get the edge.
- * If it is already asserted for some reason, we need
- * return 1 to indicate that is was pending.
- *
- * This is not complete - we should be able to fake
- * an edge even if it isn't on the 8259A...
- *
- * (We do this for level-triggered IRQs too - it cannot hurt.)
- */
-static unsigned int startup_ioapic_irq(unsigned int irq)
-{
-	int was_pending = 0;
-	unsigned long flags;
-
-	spin_lock_irqsave(&ioapic_lock, flags);
-	if (irq < 16) {
-		disable_8259A_irq(irq);
-		if (i8259A_irq_pending(irq))
-			was_pending = 1;
-	}
-	__unmask_IO_APIC_irq(irq);
-	spin_unlock_irqrestore(&ioapic_lock, flags);
-
-	return was_pending;
-}
-
-static void ack_ioapic_irq(unsigned int irq)
-{
-	move_native_irq(irq);
-	ack_APIC_irq();
-}
-
-static void ack_ioapic_quirk_irq(unsigned int irq)
-{
-	unsigned long v;
-	int i;
-
-	move_native_irq(irq);
-/*
- * It appears there is an erratum which affects at least version 0x11
- * of I/O APIC (that's the 82093AA and cores integrated into various
- * chipsets).  Under certain conditions a level-triggered interrupt is
- * erroneously delivered as edge-triggered one but the respective IRR
- * bit gets set nevertheless.  As a result the I/O unit expects an EOI
- * message but it will never arrive and further interrupts are blocked
- * from the source.  The exact reason is so far unknown, but the
- * phenomenon was observed when two consecutive interrupt requests
- * from a given source get delivered to the same CPU and the source is
- * temporarily disabled in between.
- *
- * A workaround is to simulate an EOI message manually.  We achieve it
- * by setting the trigger mode to edge and then to level when the edge
- * trigger mode gets detected in the TMR of a local APIC for a
- * level-triggered interrupt.  We mask the source for the time of the
- * operation to prevent an edge-triggered interrupt escaping meanwhile.
- * The idea is from Manfred Spraul.  --macro
- */
-	i = irq_vector[irq];
-
-	v = apic_read(APIC_TMR + ((i & ~0x1f) >> 1));
-
-	ack_APIC_irq();
-
-	if (!(v & (1 << (i & 0x1f)))) {
-		atomic_inc(&irq_mis_count);
-		spin_lock(&ioapic_lock);
-		__mask_and_edge_IO_APIC_irq(irq);
-		__unmask_and_level_IO_APIC_irq(irq);
-		spin_unlock(&ioapic_lock);
-	}
-}
-
-static int ioapic_retrigger_irq(unsigned int irq)
-{
-	send_IPI_self(irq_vector[irq]);
-
-	return 1;
-}
-
-static struct irq_chip ioapic_chip __read_mostly = {
-	.name 		= "IO-APIC",
-	.startup 	= startup_ioapic_irq,
-	.mask	 	= mask_IO_APIC_irq,
-	.unmask	 	= unmask_IO_APIC_irq,
-	.ack 		= ack_ioapic_irq,
-	.eoi 		= ack_ioapic_quirk_irq,
-#ifdef CONFIG_SMP
-	.set_affinity 	= set_ioapic_affinity_irq,
-#endif
-	.retrigger	= ioapic_retrigger_irq,
-};
-
-
-static inline void init_IO_APIC_traps(void)
-{
-	int irq;
-
-	/*
-	 * NOTE! The local APIC isn't very good at handling
-	 * multiple interrupts at the same interrupt level.
-	 * As the interrupt level is determined by taking the
-	 * vector number and shifting that right by 4, we
-	 * want to spread these out a bit so that they don't
-	 * all fall in the same interrupt level.
-	 *
-	 * Also, we've got to be careful not to trash gate
-	 * 0x80, because int 0x80 is hm, kind of importantish. ;)
-	 */
-	for (irq = 0; irq < NR_IRQS ; irq++) {
-		if (IO_APIC_IRQ(irq) && !irq_vector[irq]) {
-			/*
-			 * Hmm.. We don't have an entry for this,
-			 * so default to an old-fashioned 8259
-			 * interrupt if we can..
-			 */
-			if (irq < 16)
-				make_8259A_irq(irq);
-			else
-				/* Strange. Oh, well.. */
-				irq_desc[irq].chip = &no_irq_chip;
-		}
-	}
-}
-
-/*
- * The local APIC irq-chip implementation:
- */
-
-static void ack_lapic_irq(unsigned int irq)
-{
-	ack_APIC_irq();
-}
-
-static void mask_lapic_irq(unsigned int irq)
-{
-	unsigned long v;
-
-	v = apic_read(APIC_LVT0);
-	apic_write(APIC_LVT0, v | APIC_LVT_MASKED);
-}
-
-static void unmask_lapic_irq(unsigned int irq)
-{
-	unsigned long v;
-
-	v = apic_read(APIC_LVT0);
-	apic_write(APIC_LVT0, v & ~APIC_LVT_MASKED);
-}
-
-static struct irq_chip lapic_chip __read_mostly = {
-	.name		= "local-APIC",
-	.mask		= mask_lapic_irq,
-	.unmask		= unmask_lapic_irq,
-	.ack		= ack_lapic_irq,
-};
-
-static void lapic_register_intr(int irq, int vector)
-{
-	irq_desc[irq].status &= ~IRQ_LEVEL;
-	set_irq_chip_and_handler_name(irq, &lapic_chip, handle_edge_irq,
-				      "edge");
-	set_intr_gate(vector, interrupt[irq]);
-}
-
-static void __init setup_nmi(void)
-{
-	/*
-	 * Dirty trick to enable the NMI watchdog ...
-	 * We put the 8259A master into AEOI mode and
-	 * unmask on all local APICs LVT0 as NMI.
-	 *
-	 * The idea to use the 8259A in AEOI mode ('8259A Virtual Wire')
-	 * is from Maciej W. Rozycki - so we do not have to EOI from
-	 * the NMI handler or the timer interrupt.
-	 */
-	apic_printk(APIC_VERBOSE, KERN_INFO "activating NMI Watchdog ...");
-
-	enable_NMI_through_LVT0();
-
-	apic_printk(APIC_VERBOSE, " done.\n");
-}
-
-/*
- * This looks a bit hackish but it's about the only one way of sending
- * a few INTA cycles to 8259As and any associated glue logic.  ICR does
- * not support the ExtINT mode, unfortunately.  We need to send these
- * cycles as some i82489DX-based boards have glue logic that keeps the
- * 8259A interrupt line asserted until INTA.  --macro
- */
-static inline void __init unlock_ExtINT_logic(void)
-{
-	int apic, pin, i;
-	struct IO_APIC_route_entry entry0, entry1;
-	unsigned char save_control, save_freq_select;
-
-	pin  = find_isa_irq_pin(8, mp_INT);
-	if (pin == -1) {
-		WARN_ON_ONCE(1);
-		return;
-	}
-	apic = find_isa_irq_apic(8, mp_INT);
-	if (apic == -1) {
-		WARN_ON_ONCE(1);
-		return;
-	}
-
-	entry0 = ioapic_read_entry(apic, pin);
-	clear_IO_APIC_pin(apic, pin);
-
-	memset(&entry1, 0, sizeof(entry1));
-
-	entry1.dest_mode = 0;			/* physical delivery */
-	entry1.mask = 0;			/* unmask IRQ now */
-	entry1.dest.physical.physical_dest = hard_smp_processor_id();
-	entry1.delivery_mode = dest_ExtINT;
-	entry1.polarity = entry0.polarity;
-	entry1.trigger = 0;
-	entry1.vector = 0;
-
-	ioapic_write_entry(apic, pin, entry1);
-
-	save_control = CMOS_READ(RTC_CONTROL);
-	save_freq_select = CMOS_READ(RTC_FREQ_SELECT);
-	CMOS_WRITE((save_freq_select & ~RTC_RATE_SELECT) | 0x6,
-		   RTC_FREQ_SELECT);
-	CMOS_WRITE(save_control | RTC_PIE, RTC_CONTROL);
-
-	i = 100;
-	while (i-- > 0) {
-		mdelay(10);
-		if ((CMOS_READ(RTC_INTR_FLAGS) & RTC_PF) == RTC_PF)
-			i -= 10;
-	}
-
-	CMOS_WRITE(save_control, RTC_CONTROL);
-	CMOS_WRITE(save_freq_select, RTC_FREQ_SELECT);
-	clear_IO_APIC_pin(apic, pin);
-
-	ioapic_write_entry(apic, pin, entry0);
-}
-
-/*
- * This code may look a bit paranoid, but it's supposed to cooperate with
- * a wide range of boards and BIOS bugs.  Fortunately only the timer IRQ
- * is so screwy.  Thanks to Brian Perkins for testing/hacking this beast
- * fanatically on his truly buggy board.
- */
-static inline void __init check_timer(void)
-{
-	int apic1, pin1, apic2, pin2;
-	int no_pin1 = 0;
-	int vector;
-	unsigned int ver;
-	unsigned long flags;
-
-	local_irq_save(flags);
-
-	ver = apic_read(APIC_LVR);
-	ver = GET_APIC_VERSION(ver);
-
-	/*
-	 * get/set the timer IRQ vector:
-	 */
-	disable_8259A_irq(0);
-	vector = assign_irq_vector(0);
-	set_intr_gate(vector, interrupt[0]);
-
-	/*
-	 * As IRQ0 is to be enabled in the 8259A, the virtual
-	 * wire has to be disabled in the local APIC.  Also
-	 * timer interrupts need to be acknowledged manually in
-	 * the 8259A for the i82489DX when using the NMI
-	 * watchdog as that APIC treats NMIs as level-triggered.
-	 * The AEOI mode will finish them in the 8259A
-	 * automatically.
-	 */
-	apic_write(APIC_LVT0, APIC_LVT_MASKED | APIC_DM_EXTINT);
-	init_8259A(1);
-	timer_ack = (nmi_watchdog == NMI_IO_APIC && !APIC_INTEGRATED(ver));
-
-	pin1  = find_isa_irq_pin(0, mp_INT);
-	apic1 = find_isa_irq_apic(0, mp_INT);
-	pin2  = ioapic_i8259.pin;
-	apic2 = ioapic_i8259.apic;
-
-	apic_printk(APIC_QUIET, KERN_INFO "..TIMER: vector=0x%02X "
-		    "apic1=%d pin1=%d apic2=%d pin2=%d\n",
-		    vector, apic1, pin1, apic2, pin2);
-
-	/*
-	 * Some BIOS writers are clueless and report the ExtINTA
-	 * I/O APIC input from the cascaded 8259A as the timer
-	 * interrupt input.  So just in case, if only one pin
-	 * was found above, try it both directly and through the
-	 * 8259A.
-	 */
-	if (pin1 == -1) {
-		pin1 = pin2;
-		apic1 = apic2;
-		no_pin1 = 1;
-	} else if (pin2 == -1) {
-		pin2 = pin1;
-		apic2 = apic1;
-	}
-
-	if (pin1 != -1) {
-		/*
-		 * Ok, does IRQ0 through the IOAPIC work?
-		 */
-		if (no_pin1) {
-			add_pin_to_irq(0, apic1, pin1);
-			setup_timer_IRQ0_pin(apic1, pin1, vector);
-		}
-		unmask_IO_APIC_irq(0);
-		if (timer_irq_works()) {
-			if (nmi_watchdog == NMI_IO_APIC) {
-				setup_nmi();
-				enable_8259A_irq(0);
-			}
-			if (disable_timer_pin_1 > 0)
-				clear_IO_APIC_pin(0, pin1);
-			goto out;
-		}
-		clear_IO_APIC_pin(apic1, pin1);
-		if (!no_pin1)
-			apic_printk(APIC_QUIET, KERN_ERR "..MP-BIOS bug: "
-				    "8254 timer not connected to IO-APIC\n");
-
-		apic_printk(APIC_QUIET, KERN_INFO "...trying to set up timer "
-			    "(IRQ0) through the 8259A ...\n");
-		apic_printk(APIC_QUIET, KERN_INFO
-			    "..... (found apic %d pin %d) ...\n", apic2, pin2);
-		/*
-		 * legacy devices should be connected to IO APIC #0
-		 */
-		replace_pin_at_irq(0, apic1, pin1, apic2, pin2);
-		setup_timer_IRQ0_pin(apic2, pin2, vector);
-		unmask_IO_APIC_irq(0);
-		enable_8259A_irq(0);
-		if (timer_irq_works()) {
-			apic_printk(APIC_QUIET, KERN_INFO "....... works.\n");
-			timer_through_8259 = 1;
-			if (nmi_watchdog == NMI_IO_APIC) {
-				disable_8259A_irq(0);
-				setup_nmi();
-				enable_8259A_irq(0);
-			}
-			goto out;
-		}
-		/*
-		 * Cleanup, just in case ...
-		 */
-		disable_8259A_irq(0);
-		clear_IO_APIC_pin(apic2, pin2);
-		apic_printk(APIC_QUIET, KERN_INFO "....... failed.\n");
-	}
-
-	if (nmi_watchdog == NMI_IO_APIC) {
-		apic_printk(APIC_QUIET, KERN_WARNING "timer doesn't work "
-			    "through the IO-APIC - disabling NMI Watchdog!\n");
-		nmi_watchdog = NMI_NONE;
-	}
-	timer_ack = 0;
-
-	apic_printk(APIC_QUIET, KERN_INFO
-		    "...trying to set up timer as Virtual Wire IRQ...\n");
-
-	lapic_register_intr(0, vector);
-	apic_write(APIC_LVT0, APIC_DM_FIXED | vector);	/* Fixed mode */
-	enable_8259A_irq(0);
-
-	if (timer_irq_works()) {
-		apic_printk(APIC_QUIET, KERN_INFO "..... works.\n");
-		goto out;
-	}
-	disable_8259A_irq(0);
-	apic_write(APIC_LVT0, APIC_LVT_MASKED | APIC_DM_FIXED | vector);
-	apic_printk(APIC_QUIET, KERN_INFO "..... failed.\n");
-
-	apic_printk(APIC_QUIET, KERN_INFO
-		    "...trying to set up timer as ExtINT IRQ...\n");
-
-	init_8259A(0);
-	make_8259A_irq(0);
-	apic_write(APIC_LVT0, APIC_DM_EXTINT);
-
-	unlock_ExtINT_logic();
-
-	if (timer_irq_works()) {
-		apic_printk(APIC_QUIET, KERN_INFO "..... works.\n");
-		goto out;
-	}
-	apic_printk(APIC_QUIET, KERN_INFO "..... failed :(.\n");
-	panic("IO-APIC + timer doesn't work!  Boot with apic=debug and send a "
-		"report.  Then try booting with the 'noapic' option.\n");
-out:
-	local_irq_restore(flags);
-}
-
-/*
- * Traditionally ISA IRQ2 is the cascade IRQ, and is not available
- * to devices.  However there may be an I/O APIC pin available for
- * this interrupt regardless.  The pin may be left unconnected, but
- * typically it will be reused as an ExtINT cascade interrupt for
- * the master 8259A.  In the MPS case such a pin will normally be
- * reported as an ExtINT interrupt in the MP table.  With ACPI
- * there is no provision for ExtINT interrupts, and in the absence
- * of an override it would be treated as an ordinary ISA I/O APIC
- * interrupt, that is edge-triggered and unmasked by default.  We
- * used to do this, but it caused problems on some systems because
- * of the NMI watchdog and sometimes IRQ0 of the 8254 timer using
- * the same ExtINT cascade interrupt to drive the local APIC of the
- * bootstrap processor.  Therefore we refrain from routing IRQ2 to
- * the I/O APIC in all cases now.  No actual device should request
- * it anyway.  --macro
- */
-#define PIC_IRQS	(1 << PIC_CASCADE_IR)
-
-void __init setup_IO_APIC(void)
-{
-	int i;
-
-	/* Reserve all the system vectors. */
-	for (i = first_system_vector; i < NR_VECTORS; i++)
-		set_bit(i, used_vectors);
-
-	enable_IO_APIC();
-
-	io_apic_irqs = ~PIC_IRQS;
-
-	printk("ENABLING IO-APIC IRQs\n");
-
-	/*
-	 * Set up IO-APIC IRQ routing.
-	 */
-	if (!acpi_ioapic)
-		setup_ioapic_ids_from_mpc();
-	sync_Arb_IDs();
-	setup_IO_APIC_irqs();
-	init_IO_APIC_traps();
-	check_timer();
-}
-
-/*
- *	Called after all the initialization is done. If we didnt find any
- *	APIC bugs then we can allow the modify fast path
- */
-
-static int __init io_apic_bug_finalize(void)
-{
-	if (sis_apic_bug == -1)
-		sis_apic_bug = 0;
-	return 0;
-}
-
-late_initcall(io_apic_bug_finalize);
-
-struct sysfs_ioapic_data {
-	struct sys_device dev;
-	struct IO_APIC_route_entry entry[0];
-};
-static struct sysfs_ioapic_data *mp_ioapic_data[MAX_IO_APICS];
-
-static int ioapic_suspend(struct sys_device *dev, pm_message_t state)
-{
-	struct IO_APIC_route_entry *entry;
-	struct sysfs_ioapic_data *data;
-	int i;
-
-	data = container_of(dev, struct sysfs_ioapic_data, dev);
-	entry = data->entry;
-	for (i = 0; i < nr_ioapic_registers[dev->id]; i++)
-		entry[i] = ioapic_read_entry(dev->id, i);
-
-	return 0;
-}
-
-static int ioapic_resume(struct sys_device *dev)
-{
-	struct IO_APIC_route_entry *entry;
-	struct sysfs_ioapic_data *data;
-	unsigned long flags;
-	union IO_APIC_reg_00 reg_00;
-	int i;
-
-	data = container_of(dev, struct sysfs_ioapic_data, dev);
-	entry = data->entry;
-
-	spin_lock_irqsave(&ioapic_lock, flags);
-	reg_00.raw = io_apic_read(dev->id, 0);
-	if (reg_00.bits.ID != mp_ioapics[dev->id].mp_apicid) {
-		reg_00.bits.ID = mp_ioapics[dev->id].mp_apicid;
-		io_apic_write(dev->id, 0, reg_00.raw);
-	}
-	spin_unlock_irqrestore(&ioapic_lock, flags);
-	for (i = 0; i < nr_ioapic_registers[dev->id]; i++)
-		ioapic_write_entry(dev->id, i, entry[i]);
-
-	return 0;
-}
-
-static struct sysdev_class ioapic_sysdev_class = {
-	.name = "ioapic",
-	.suspend = ioapic_suspend,
-	.resume = ioapic_resume,
-};
-
-static int __init ioapic_init_sysfs(void)
-{
-	struct sys_device *dev;
-	int i, size, error = 0;
-
-	error = sysdev_class_register(&ioapic_sysdev_class);
-	if (error)
-		return error;
-
-	for (i = 0; i < nr_ioapics; i++) {
-		size = sizeof(struct sys_device) + nr_ioapic_registers[i]
-			* sizeof(struct IO_APIC_route_entry);
-		mp_ioapic_data[i] = kzalloc(size, GFP_KERNEL);
-		if (!mp_ioapic_data[i]) {
-			printk(KERN_ERR "Can't suspend/resume IOAPIC %d\n", i);
-			continue;
-		}
-		dev = &mp_ioapic_data[i]->dev;
-		dev->id = i;
-		dev->cls = &ioapic_sysdev_class;
-		error = sysdev_register(dev);
-		if (error) {
-			kfree(mp_ioapic_data[i]);
-			mp_ioapic_data[i] = NULL;
-			printk(KERN_ERR "Can't suspend/resume IOAPIC %d\n", i);
-			continue;
-		}
-	}
-
-	return 0;
-}
-
-device_initcall(ioapic_init_sysfs);
-
-/*
- * Dynamic irq allocate and deallocation
- */
-int create_irq(void)
-{
-	/* Allocate an unused irq */
-	int irq, new, vector = 0;
-	unsigned long flags;
-
-	irq = -ENOSPC;
-	spin_lock_irqsave(&vector_lock, flags);
-	for (new = (NR_IRQS - 1); new >= 0; new--) {
-		if (platform_legacy_irq(new))
-			continue;
-		if (irq_vector[new] != 0)
-			continue;
-		vector = __assign_irq_vector(new);
-		if (likely(vector > 0))
-			irq = new;
-		break;
-	}
-	spin_unlock_irqrestore(&vector_lock, flags);
-
-	if (irq >= 0) {
-		set_intr_gate(vector, interrupt[irq]);
-		dynamic_irq_init(irq);
-	}
-	return irq;
-}
-
-void destroy_irq(unsigned int irq)
-{
-	unsigned long flags;
-
-	dynamic_irq_cleanup(irq);
-
-	spin_lock_irqsave(&vector_lock, flags);
-	clear_bit(irq_vector[irq], used_vectors);
-	irq_vector[irq] = 0;
-	spin_unlock_irqrestore(&vector_lock, flags);
-}
-
-/*
- * MSI message composition
- */
-#ifdef CONFIG_PCI_MSI
-static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq, struct msi_msg *msg)
-{
-	int vector;
-	unsigned dest;
-
-	vector = assign_irq_vector(irq);
-	if (vector >= 0) {
-		dest = cpu_mask_to_apicid(TARGET_CPUS);
-
-		msg->address_hi = MSI_ADDR_BASE_HI;
-		msg->address_lo =
-			MSI_ADDR_BASE_LO |
-			((INT_DEST_MODE == 0) ?
-MSI_ADDR_DEST_MODE_PHYSICAL:
-				MSI_ADDR_DEST_MODE_LOGICAL) |
-			((INT_DELIVERY_MODE != dest_LowestPrio) ?
-				MSI_ADDR_REDIRECTION_CPU:
-				MSI_ADDR_REDIRECTION_LOWPRI) |
-			MSI_ADDR_DEST_ID(dest);
-
-		msg->data =
-			MSI_DATA_TRIGGER_EDGE |
-			MSI_DATA_LEVEL_ASSERT |
-			((INT_DELIVERY_MODE != dest_LowestPrio) ?
-MSI_DATA_DELIVERY_FIXED:
-				MSI_DATA_DELIVERY_LOWPRI) |
-			MSI_DATA_VECTOR(vector);
-	}
-	return vector;
-}
-
-#ifdef CONFIG_SMP
-static void set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
-{
-	struct msi_msg msg;
-	unsigned int dest;
-	cpumask_t tmp;
-	int vector;
-
-	cpus_and(tmp, mask, cpu_online_map);
-	if (cpus_empty(tmp))
-		tmp = TARGET_CPUS;
-
-	vector = assign_irq_vector(irq);
-	if (vector < 0)
-		return;
-
-	dest = cpu_mask_to_apicid(mask);
-
-	read_msi_msg(irq, &msg);
-
-	msg.data &= ~MSI_DATA_VECTOR_MASK;
-	msg.data |= MSI_DATA_VECTOR(vector);
-	msg.address_lo &= ~MSI_ADDR_DEST_ID_MASK;
-	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
-
-	write_msi_msg(irq, &msg);
-	irq_desc[irq].affinity = mask;
-}
-#endif /* CONFIG_SMP */
-
-/*
- * IRQ Chip for MSI PCI/PCI-X/PCI-Express Devices,
- * which implement the MSI or MSI-X Capability Structure.
- */
-static struct irq_chip msi_chip = {
-	.name		= "PCI-MSI",
-	.unmask		= unmask_msi_irq,
-	.mask		= mask_msi_irq,
-	.ack		= ack_ioapic_irq,
-#ifdef CONFIG_SMP
-	.set_affinity	= set_msi_irq_affinity,
-#endif
-	.retrigger	= ioapic_retrigger_irq,
-};
-
-int arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc)
-{
-	struct msi_msg msg;
-	int irq, ret;
-	irq = create_irq();
-	if (irq < 0)
-		return irq;
-
-	ret = msi_compose_msg(dev, irq, &msg);
-	if (ret < 0) {
-		destroy_irq(irq);
-		return ret;
-	}
-
-	set_irq_msi(irq, desc);
-	write_msi_msg(irq, &msg);
-
-	set_irq_chip_and_handler_name(irq, &msi_chip, handle_edge_irq,
-				      "edge");
-
-	return 0;
-}
-
-void arch_teardown_msi_irq(unsigned int irq)
-{
-	destroy_irq(irq);
-}
-
-#endif /* CONFIG_PCI_MSI */
-
-/*
- * Hypertransport interrupt support
- */
-#ifdef CONFIG_HT_IRQ
-
-#ifdef CONFIG_SMP
-
-static void target_ht_irq(unsigned int irq, unsigned int dest)
-{
-	struct ht_irq_msg msg;
-	fetch_ht_irq_msg(irq, &msg);
-
-	msg.address_lo &= ~(HT_IRQ_LOW_DEST_ID_MASK);
-	msg.address_hi &= ~(HT_IRQ_HIGH_DEST_ID_MASK);
-
-	msg.address_lo |= HT_IRQ_LOW_DEST_ID(dest);
-	msg.address_hi |= HT_IRQ_HIGH_DEST_ID(dest);
-
-	write_ht_irq_msg(irq, &msg);
-}
-
-static void set_ht_irq_affinity(unsigned int irq, cpumask_t mask)
-{
-	unsigned int dest;
-	cpumask_t tmp;
-
-	cpus_and(tmp, mask, cpu_online_map);
-	if (cpus_empty(tmp))
-		tmp = TARGET_CPUS;
-
-	cpus_and(mask, tmp, CPU_MASK_ALL);
-
-	dest = cpu_mask_to_apicid(mask);
-
-	target_ht_irq(irq, dest);
-	irq_desc[irq].affinity = mask;
-}
-#endif
-
-static struct irq_chip ht_irq_chip = {
-	.name		= "PCI-HT",
-	.mask		= mask_ht_irq,
-	.unmask		= unmask_ht_irq,
-	.ack		= ack_ioapic_irq,
-#ifdef CONFIG_SMP
-	.set_affinity	= set_ht_irq_affinity,
-#endif
-	.retrigger	= ioapic_retrigger_irq,
-};
-
-int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
-{
-	int vector;
-
-	vector = assign_irq_vector(irq);
-	if (vector >= 0) {
-		struct ht_irq_msg msg;
-		unsigned dest;
-		cpumask_t tmp;
-
-		cpus_clear(tmp);
-		cpu_set(vector >> 8, tmp);
-		dest = cpu_mask_to_apicid(tmp);
-
-		msg.address_hi = HT_IRQ_HIGH_DEST_ID(dest);
-
-		msg.address_lo =
-			HT_IRQ_LOW_BASE |
-			HT_IRQ_LOW_DEST_ID(dest) |
-			HT_IRQ_LOW_VECTOR(vector) |
-			((INT_DEST_MODE == 0) ?
-				HT_IRQ_LOW_DM_PHYSICAL :
-				HT_IRQ_LOW_DM_LOGICAL) |
-			HT_IRQ_LOW_RQEOI_EDGE |
-			((INT_DELIVERY_MODE != dest_LowestPrio) ?
-				HT_IRQ_LOW_MT_FIXED :
-				HT_IRQ_LOW_MT_ARBITRATED) |
-			HT_IRQ_LOW_IRQ_MASKED;
-
-		write_ht_irq_msg(irq, &msg);
-
-		set_irq_chip_and_handler_name(irq, &ht_irq_chip,
-					      handle_edge_irq, "edge");
-	}
-	return vector;
-}
-#endif /* CONFIG_HT_IRQ */
-
-/* --------------------------------------------------------------------------
-			ACPI-based IOAPIC Configuration
-   -------------------------------------------------------------------------- */
-
-#ifdef CONFIG_ACPI
-
-int __init io_apic_get_unique_id(int ioapic, int apic_id)
-{
-	union IO_APIC_reg_00 reg_00;
-	static physid_mask_t apic_id_map = PHYSID_MASK_NONE;
-	physid_mask_t tmp;
-	unsigned long flags;
-	int i = 0;
-
-	/*
-	 * The P4 platform supports up to 256 APIC IDs on two separate APIC
-	 * buses (one for LAPICs, one for IOAPICs), where predecessors only
-	 * supports up to 16 on one shared APIC bus.
-	 *
-	 * TBD: Expand LAPIC/IOAPIC support on P4-class systems to take full
-	 *      advantage of new APIC bus architecture.
-	 */
-
-	if (physids_empty(apic_id_map))
-		apic_id_map = ioapic_phys_id_map(phys_cpu_present_map);
-
-	spin_lock_irqsave(&ioapic_lock, flags);
-	reg_00.raw = io_apic_read(ioapic, 0);
-	spin_unlock_irqrestore(&ioapic_lock, flags);
-
-	if (apic_id >= get_physical_broadcast()) {
-		printk(KERN_WARNING "IOAPIC[%d]: Invalid apic_id %d, trying "
-			"%d\n", ioapic, apic_id, reg_00.bits.ID);
-		apic_id = reg_00.bits.ID;
-	}
-
-	/*
-	 * Every APIC in a system must have a unique ID or we get lots of nice
-	 * 'stuck on smp_invalidate_needed IPI wait' messages.
-	 */
-	if (check_apicid_used(apic_id_map, apic_id)) {
-
-		for (i = 0; i < get_physical_broadcast(); i++) {
-			if (!check_apicid_used(apic_id_map, i))
-				break;
-		}
-
-		if (i == get_physical_broadcast())
-			panic("Max apic_id exceeded!\n");
-
-		printk(KERN_WARNING "IOAPIC[%d]: apic_id %d already used, "
-			"trying %d\n", ioapic, apic_id, i);
-
-		apic_id = i;
-	}
-
-	tmp = apicid_to_cpu_present(apic_id);
-	physids_or(apic_id_map, apic_id_map, tmp);
-
-	if (reg_00.bits.ID != apic_id) {
-		reg_00.bits.ID = apic_id;
-
-		spin_lock_irqsave(&ioapic_lock, flags);
-		io_apic_write(ioapic, 0, reg_00.raw);
-		reg_00.raw = io_apic_read(ioapic, 0);
-		spin_unlock_irqrestore(&ioapic_lock, flags);
-
-		/* Sanity check */
-		if (reg_00.bits.ID != apic_id) {
-			printk("IOAPIC[%d]: Unable to change apic_id!\n", ioapic);
-			return -1;
-		}
-	}
-
-	apic_printk(APIC_VERBOSE, KERN_INFO
-			"IOAPIC[%d]: Assigned apic_id %d\n", ioapic, apic_id);
-
-	return apic_id;
-}
-
-
-int __init io_apic_get_version(int ioapic)
-{
-	union IO_APIC_reg_01	reg_01;
-	unsigned long flags;
-
-	spin_lock_irqsave(&ioapic_lock, flags);
-	reg_01.raw = io_apic_read(ioapic, 1);
-	spin_unlock_irqrestore(&ioapic_lock, flags);
-
-	return reg_01.bits.version;
-}
-
-
-int __init io_apic_get_redir_entries(int ioapic)
-{
-	union IO_APIC_reg_01	reg_01;
-	unsigned long flags;
-
-	spin_lock_irqsave(&ioapic_lock, flags);
-	reg_01.raw = io_apic_read(ioapic, 1);
-	spin_unlock_irqrestore(&ioapic_lock, flags);
-
-	return reg_01.bits.entries;
-}
-
-
-int io_apic_set_pci_routing(int ioapic, int pin, int irq, int edge_level, int active_high_low)
-{
-	struct IO_APIC_route_entry entry;
-
-	if (!IO_APIC_IRQ(irq)) {
-		printk(KERN_ERR "IOAPIC[%d]: Invalid reference to IRQ 0\n",
-			ioapic);
-		return -EINVAL;
-	}
-
-	/*
-	 * Generate a PCI IRQ routing entry and program the IOAPIC accordingly.
-	 * Note that we mask (disable) IRQs now -- these get enabled when the
-	 * corresponding device driver registers for this IRQ.
-	 */
-
-	memset(&entry, 0, sizeof(entry));
-
-	entry.delivery_mode = INT_DELIVERY_MODE;
-	entry.dest_mode = INT_DEST_MODE;
-	entry.dest.logical.logical_dest = cpu_mask_to_apicid(TARGET_CPUS);
-	entry.trigger = edge_level;
-	entry.polarity = active_high_low;
-	entry.mask  = 1;
-
-	/*
-	 * IRQs < 16 are already in the irq_2_pin[] map
-	 */
-	if (irq >= 16)
-		add_pin_to_irq(irq, ioapic, pin);
-
-	entry.vector = assign_irq_vector(irq);
-
-	apic_printk(APIC_DEBUG, KERN_DEBUG "IOAPIC[%d]: Set PCI routing entry "
-		"(%d-%d -> 0x%x -> IRQ %d Mode:%i Active:%i)\n", ioapic,
-		mp_ioapics[ioapic].mp_apicid, pin, entry.vector, irq,
-		edge_level, active_high_low);
-
-	ioapic_register_intr(irq, entry.vector, edge_level);
-
-	if (!ioapic && (irq < 16))
-		disable_8259A_irq(irq);
-
-	ioapic_write_entry(ioapic, pin, entry);
-
-	return 0;
-}
-
-int acpi_get_override_irq(int bus_irq, int *trigger, int *polarity)
-{
-	int i;
-
-	if (skip_ioapic_setup)
-		return -1;
-
-	for (i = 0; i < mp_irq_entries; i++)
-		if (mp_irqs[i].mp_irqtype == mp_INT &&
-		    mp_irqs[i].mp_srcbusirq == bus_irq)
-			break;
-	if (i >= mp_irq_entries)
-		return -1;
-
-	*trigger = irq_trigger(i);
-	*polarity = irq_polarity(i);
-	return 0;
-}
-
-#endif /* CONFIG_ACPI */
-
-static int __init parse_disable_timer_pin_1(char *arg)
-{
-	disable_timer_pin_1 = 1;
-	return 0;
-}
-early_param("disable_timer_pin_1", parse_disable_timer_pin_1);
-
-static int __init parse_enable_timer_pin_1(char *arg)
-{
-	disable_timer_pin_1 = -1;
-	return 0;
-}
-early_param("enable_timer_pin_1", parse_enable_timer_pin_1);
-
-static int __init parse_noapic(char *arg)
-{
-	/* disable IO-APIC */
-	disable_ioapic_setup();
-	return 0;
-}
-early_param("noapic", parse_noapic);
-
-void __init ioapic_init_mappings(void)
-{
-	unsigned long ioapic_phys, idx = FIX_IO_APIC_BASE_0;
-	int i;
-
-	for (i = 0; i < nr_ioapics; i++) {
-		if (smp_found_config) {
-			ioapic_phys = mp_ioapics[i].mp_apicaddr;
-			if (!ioapic_phys) {
-				printk(KERN_ERR
-				       "WARNING: bogus zero IO-APIC "
-				       "address found in MPTABLE, "
-				       "disabling IO/APIC support!\n");
-				smp_found_config = 0;
-				skip_ioapic_setup = 1;
-				goto fake_ioapic_page;
-			}
-		} else {
-fake_ioapic_page:
-			ioapic_phys = (unsigned long)
-				      alloc_bootmem_pages(PAGE_SIZE);
-			ioapic_phys = __pa(ioapic_phys);
-		}
-		set_fixmap_nocache(idx, ioapic_phys);
-		printk(KERN_DEBUG "mapped IOAPIC to %08lx (%08lx)\n",
-		       __fix_to_virt(idx), ioapic_phys);
-		idx++;
-	}
-}
-
diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index b71e02d..001772f 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -223,20 +223,25 @@ unsigned int do_IRQ(struct pt_regs *regs)
 {
 	struct pt_regs *old_regs;
 	/* high bit used in ret_from_ code */
-	int overflow, irq = ~regs->orig_ax;
-	struct irq_desc *desc = irq_desc + irq;
+	int overflow;
+	unsigned vector = ~regs->orig_ax;
+	struct irq_desc *desc;
+	unsigned irq;
 
-	if (unlikely((unsigned)irq >= NR_IRQS)) {
-		printk(KERN_EMERG "%s: cannot handle IRQ %d\n",
-					__func__, irq);
-		BUG();
-	}
 
 	old_regs = set_irq_regs(regs);
 	irq_enter();
+	irq = __get_cpu_var(vector_irq)[vector];
 
 	overflow = check_stack_overflow();
 
+	desc = irq_to_desc(irq);
+	if (unlikely(!desc)) {
+		printk(KERN_EMERG "%s: cannot handle IRQ %d vector %#x cpu %d\n",
+					__func__, irq, vector, smp_processor_id());
+		BUG();
+	}
+
 	if (!execute_on_irq_stack(overflow, desc, irq)) {
 		if (unlikely(overflow))
 			print_stack_overflow();
@@ -263,6 +268,24 @@ int show_interrupts(struct seq_file *p, void *v)
 	int i = *(loff_t *) v, j;
 	struct irqaction * action;
 	unsigned long flags;
+	unsigned int entries;
+	struct irq_desc *desc = NULL;
+	int tail = 0;
+
+#ifdef CONFIG_HAVE_SPARSE_IRQ
+	desc = (struct irq_desc *)v;
+	entries = -1U;
+	i = desc->irq;
+	if (!desc->next)
+		tail = 1;
+#else
+	entries = nr_irqs - 1;
+	i = *(loff_t *) v;
+	if (i == nr_irqs)
+		tail = 1;
+	else
+		desc = irq_to_desc(i);
+#endif
 
 	if (i == 0) {
 		seq_printf(p, "           ");
@@ -271,28 +294,28 @@ int show_interrupts(struct seq_file *p, void *v)
 		seq_putc(p, '\n');
 	}
 
-	if (i < NR_IRQS) {
+	if (i <= entries) {
 		unsigned any_count = 0;
 
-		spin_lock_irqsave(&irq_desc[i].lock, flags);
+		spin_lock_irqsave(&desc->lock, flags);
 #ifndef CONFIG_SMP
 		any_count = kstat_irqs(i);
 #else
 		for_each_online_cpu(j)
-			any_count |= kstat_cpu(j).irqs[i];
+			any_count |= kstat_irqs_cpu(i, j);
 #endif
-		action = irq_desc[i].action;
+		action = desc->action;
 		if (!action && !any_count)
 			goto skip;
-		seq_printf(p, "%3d: ",i);
+		seq_printf(p, "%3d: ", i);
 #ifndef CONFIG_SMP
 		seq_printf(p, "%10u ", kstat_irqs(i));
 #else
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
+			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
 #endif
-		seq_printf(p, " %8s", irq_desc[i].chip->name);
-		seq_printf(p, "-%-8s", irq_desc[i].name);
+		seq_printf(p, " %8s", desc->chip->name);
+		seq_printf(p, "-%-8s", desc->name);
 
 		if (action) {
 			seq_printf(p, "  %s", action->name);
@@ -302,8 +325,10 @@ int show_interrupts(struct seq_file *p, void *v)
 
 		seq_putc(p, '\n');
 skip:
-		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
-	} else if (i == NR_IRQS) {
+		spin_unlock_irqrestore(&desc->lock, flags);
+	}
+
+	if (tail) {
 		seq_printf(p, "NMI: ");
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", nmi_count(j));
@@ -395,20 +420,22 @@ void fixup_irqs(cpumask_t map)
 {
 	unsigned int irq;
 	static int warned;
+	struct irq_desc *desc;
 
-	for (irq = 0; irq < NR_IRQS; irq++) {
+	for_each_irq_desc(irq, desc) {
 		cpumask_t mask;
+
 		if (irq == 2)
 			continue;
 
-		cpus_and(mask, irq_desc[irq].affinity, map);
+		cpus_and(mask, desc->affinity, map);
 		if (any_online_cpu(mask) == NR_CPUS) {
 			printk("Breaking affinity for irq %i\n", irq);
 			mask = map;
 		}
-		if (irq_desc[irq].chip->set_affinity)
-			irq_desc[irq].chip->set_affinity(irq, mask);
-		else if (irq_desc[irq].action && !(warned++))
+		if (desc->chip->set_affinity)
+			desc->chip->set_affinity(irq, mask);
+		else if (desc->action && !(warned++))
 			printk("Cannot set affinity for irq %i\n", irq);
 	}
 
diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
index f065fe9..ec26610 100644
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -70,9 +70,27 @@ static inline void stack_overflow_check(struct pt_regs *regs)
 
 int show_interrupts(struct seq_file *p, void *v)
 {
-	int i = *(loff_t *) v, j;
+	int i, j;
 	struct irqaction * action;
 	unsigned long flags;
+	unsigned int entries;
+	struct irq_desc *desc = NULL;
+	int tail = 0;
+
+#ifdef CONFIG_HAVE_SPARSE_IRQ
+	desc = (struct irq_desc *)v;
+	entries = -1U;
+	i = desc->irq;
+	if (!desc->next)
+		tail = 1;
+#else
+	entries = nr_irqs - 1;
+	i = *(loff_t *) v;
+	if (i == nr_irqs)
+		tail = 1;
+	else
+		desc = irq_to_desc(i);
+#endif
 
 	if (i == 0) {
 		seq_printf(p, "           ");
@@ -81,28 +99,28 @@ int show_interrupts(struct seq_file *p, void *v)
 		seq_putc(p, '\n');
 	}
 
-	if (i < NR_IRQS) {
+	if (i <= entries) {
 		unsigned any_count = 0;
 
-		spin_lock_irqsave(&irq_desc[i].lock, flags);
+		spin_lock_irqsave(&desc->lock, flags);
 #ifndef CONFIG_SMP
 		any_count = kstat_irqs(i);
 #else
 		for_each_online_cpu(j)
-			any_count |= kstat_cpu(j).irqs[i];
+			any_count |= kstat_irqs_cpu(i, j);
 #endif
-		action = irq_desc[i].action;
+		action = desc->action;
 		if (!action && !any_count)
 			goto skip;
-		seq_printf(p, "%3d: ",i);
+		seq_printf(p, "%3d: ", i);
 #ifndef CONFIG_SMP
 		seq_printf(p, "%10u ", kstat_irqs(i));
 #else
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
+			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
 #endif
-		seq_printf(p, " %8s", irq_desc[i].chip->name);
-		seq_printf(p, "-%-8s", irq_desc[i].name);
+		seq_printf(p, " %8s", desc->chip->name);
+		seq_printf(p, "-%-8s", desc->name);
 
 		if (action) {
 			seq_printf(p, "  %s", action->name);
@@ -111,8 +129,10 @@ int show_interrupts(struct seq_file *p, void *v)
 		}
 		seq_putc(p, '\n');
 skip:
-		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
-	} else if (i == NR_IRQS) {
+		spin_unlock_irqrestore(&desc->lock, flags);
+	}
+
+	if (tail) {
 		seq_printf(p, "NMI: ");
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", cpu_pda(j)->__nmi_count);
@@ -151,6 +171,7 @@ skip:
 		seq_printf(p, "  Spurious interrupts\n");
 		seq_printf(p, "ERR: %10u\n", atomic_read(&irq_err_count));
 	}
+
 	return 0;
 }
 
@@ -188,6 +209,7 @@ u64 arch_irq_stat(void)
 asmlinkage unsigned int do_IRQ(struct pt_regs *regs)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
+	struct irq_desc *desc;
 
 	/* high bit used in ret_from_ code  */
 	unsigned vector = ~regs->orig_ax;
@@ -201,8 +223,9 @@ asmlinkage unsigned int do_IRQ(struct pt_regs *regs)
 	stack_overflow_check(regs);
 #endif
 
-	if (likely(irq < NR_IRQS))
-		generic_handle_irq(irq);
+	desc = irq_to_desc(irq);
+	if (likely(desc))
+		generic_handle_irq_desc(irq, desc);
 	else {
 		if (!disable_apic)
 			ack_APIC_irq();
@@ -223,8 +246,9 @@ void fixup_irqs(cpumask_t map)
 {
 	unsigned int irq;
 	static int warned;
+	struct irq_desc *desc;
 
-	for (irq = 0; irq < NR_IRQS; irq++) {
+	for_each_irq_desc(irq, desc) {
 		cpumask_t mask;
 		int break_affinity = 0;
 		int set_affinity = 1;
@@ -233,32 +257,32 @@ void fixup_irqs(cpumask_t map)
 			continue;
 
 		/* interrupt's are disabled at this point */
-		spin_lock(&irq_desc[irq].lock);
+		spin_lock(&desc->lock);
 
 		if (!irq_has_action(irq) ||
-		    cpus_equal(irq_desc[irq].affinity, map)) {
-			spin_unlock(&irq_desc[irq].lock);
+		    cpus_equal(desc->affinity, map)) {
+			spin_unlock(&desc->lock);
 			continue;
 		}
 
-		cpus_and(mask, irq_desc[irq].affinity, map);
+		cpus_and(mask, desc->affinity, map);
 		if (cpus_empty(mask)) {
 			break_affinity = 1;
 			mask = map;
 		}
 
-		if (irq_desc[irq].chip->mask)
-			irq_desc[irq].chip->mask(irq);
+		if (desc->chip->mask)
+			desc->chip->mask(irq);
 
-		if (irq_desc[irq].chip->set_affinity)
-			irq_desc[irq].chip->set_affinity(irq, mask);
+		if (desc->chip->set_affinity)
+			desc->chip->set_affinity(irq, mask);
 		else if (!(warned++))
 			set_affinity = 0;
 
-		if (irq_desc[irq].chip->unmask)
-			irq_desc[irq].chip->unmask(irq);
+		if (desc->chip->unmask)
+			desc->chip->unmask(irq);
 
-		spin_unlock(&irq_desc[irq].lock);
+		spin_unlock(&desc->lock);
 
 		if (break_affinity && set_affinity)
 			printk("Broke affinity for irq %i\n", irq);
diff --git a/arch/x86/kernel/irqinit_32.c b/arch/x86/kernel/irqinit_32.c
index 9200a1e..9092103 100644
--- a/arch/x86/kernel/irqinit_32.c
+++ b/arch/x86/kernel/irqinit_32.c
@@ -69,6 +69,13 @@ void __init init_ISA_irqs (void)
 	 * 16 old-style INTA-cycle interrupts:
 	 */
 	for (i = 0; i < 16; i++) {
+		/* first time call this irq_desc */
+		struct irq_desc *desc = irq_to_desc_alloc(i);
+
+		desc->status = IRQ_DISABLED;
+		desc->action = NULL;
+		desc->depth = 1;
+
 		set_irq_chip_and_handler_name(i, &i8259A_chip,
 					      handle_level_irq, "XT");
 	}
@@ -83,6 +90,27 @@ static struct irqaction irq2 = {
 	.name = "cascade",
 };
 
+DEFINE_PER_CPU(vector_irq_t, vector_irq) = {
+	[0 ... IRQ0_VECTOR - 1] = -1,
+	[IRQ0_VECTOR] = 0,
+	[IRQ1_VECTOR] = 1,
+	[IRQ2_VECTOR] = 2,
+	[IRQ3_VECTOR] = 3,
+	[IRQ4_VECTOR] = 4,
+	[IRQ5_VECTOR] = 5,
+	[IRQ6_VECTOR] = 6,
+	[IRQ7_VECTOR] = 7,
+	[IRQ8_VECTOR] = 8,
+	[IRQ9_VECTOR] = 9,
+	[IRQ10_VECTOR] = 10,
+	[IRQ11_VECTOR] = 11,
+	[IRQ12_VECTOR] = 12,
+	[IRQ13_VECTOR] = 13,
+	[IRQ14_VECTOR] = 14,
+	[IRQ15_VECTOR] = 15,
+	[IRQ15_VECTOR + 1 ... NR_VECTORS - 1] = -1
+};
+
 /* Overridden in paravirt.c */
 void init_IRQ(void) __attribute__((weak, alias("native_init_IRQ")));
 
@@ -98,22 +126,14 @@ void __init native_init_IRQ(void)
 	 * us. (some of these will be overridden and become
 	 * 'special' SMP interrupts)
 	 */
-	for (i = 0; i < (NR_VECTORS - FIRST_EXTERNAL_VECTOR); i++) {
-		int vector = FIRST_EXTERNAL_VECTOR + i;
-		if (i >= NR_IRQS)
-			break;
+	for (i =  FIRST_EXTERNAL_VECTOR; i < NR_VECTORS; i++) {
 		/* SYSCALL_VECTOR was reserved in trap_init. */
-		if (!test_bit(vector, used_vectors))
-			set_intr_gate(vector, interrupt[i]);
+		if (i != SYSCALL_VECTOR)
+			set_intr_gate(i, interrupt[i]);
 	}
 
-#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_SMP)
-	/*
-	 * IRQ0 must be given a fixed assignment and initialized,
-	 * because it's used before the IO-APIC is set up.
-	 */
-	set_intr_gate(FIRST_DEVICE_VECTOR, interrupt[0]);
 
+#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_SMP)
 	/*
 	 * The reschedule interrupt is a CPU-to-CPU reschedule-helper
 	 * IPI, driven by wakeup.
@@ -128,6 +148,9 @@ void __init native_init_IRQ(void)
 
 	/* IPI for single call function */
 	set_intr_gate(CALL_FUNCTION_SINGLE_VECTOR, call_function_single_interrupt);
+
+	/* Low priority IPI to cleanup after moving an irq */
+	set_intr_gate(IRQ_MOVE_CLEANUP_VECTOR, irq_move_cleanup_interrupt);
 #endif
 
 #ifdef CONFIG_X86_LOCAL_APIC
@@ -161,3 +184,4 @@ void __init native_init_IRQ(void)
 
 	irq_ctx_init(smp_processor_id());
 }
+
diff --git a/arch/x86/kernel/irqinit_64.c b/arch/x86/kernel/irqinit_64.c
index 1f26fd9..2f4d009 100644
--- a/arch/x86/kernel/irqinit_64.c
+++ b/arch/x86/kernel/irqinit_64.c
@@ -142,23 +142,19 @@ static void __init init_ISA_irqs (void)
 	init_bsp_APIC();
 	init_8259A(0);
 
-	for (i = 0; i < NR_IRQS; i++) {
-		irq_desc[i].status = IRQ_DISABLED;
-		irq_desc[i].action = NULL;
-		irq_desc[i].depth = 1;
-
-		if (i < 16) {
-			/*
-			 * 16 old-style INTA-cycle interrupts:
-			 */
-			set_irq_chip_and_handler_name(i, &i8259A_chip,
+	for (i = 0; i < 16; i++) {
+		/* first time call this irq_desc */
+		struct irq_desc *desc = irq_to_desc_alloc(i);
+
+		desc->status = IRQ_DISABLED;
+		desc->action = NULL;
+		desc->depth = 1;
+
+		/*
+		 * 16 old-style INTA-cycle interrupts:
+		 */
+		set_irq_chip_and_handler_name(i, &i8259A_chip,
 						      handle_level_irq, "XT");
-		} else {
-			/*
-			 * 'high' PCI IRQs filled in on demand
-			 */
-			irq_desc[i].chip = &no_irq_chip;
-		}
 	}
 }
 
diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index f6a11b9..67465ed 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -35,9 +35,6 @@ static void __devinit quirk_intel_irqbalance(struct pci_dev *dev)
 	if (!(word & (1 << 13))) {
 		dev_info(&dev->dev, "Intel E7520/7320/7525 detected; "
 			"disabling irq balancing and affinity\n");
-#ifdef CONFIG_IRQBALANCE
-		irqbalance_disable("");
-#endif
 		noirqdebug_setup("");
 #ifdef CONFIG_PROC_FS
 		no_irq_affinity = 1;
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 09ee73a..e3599a4 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -808,6 +808,8 @@ void __init setup_arch(char **cmdline_p)
 	 */
 	acpi_boot_table_init();
 
+	early_acpi_boot_init();
+
 #ifdef CONFIG_ACPI_NUMA
 	/*
 	 * Parse SRAT to discover nodes.
@@ -875,6 +877,7 @@ void __init setup_arch(char **cmdline_p)
 #endif
 
 	prefill_possible_map();
+
 #ifdef CONFIG_X86_64
 	init_cpu_to_node();
 #endif
@@ -882,6 +885,9 @@ void __init setup_arch(char **cmdline_p)
 	init_apic_mappings();
 	ioapic_init_mappings();
 
+	/* need to wait for io_apic is mapped */
+	nr_irqs = probe_nr_irqs();
+
 	kvm_guest_init();
 
 	e820_reserve_resources();
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 0e67f72..2b7dab6 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -140,25 +140,31 @@ static void __init setup_cpu_pda_map(void)
  */
 void __init setup_per_cpu_areas(void)
 {
-	ssize_t size = PERCPU_ENOUGH_ROOM;
+	ssize_t size, old_size, da_size;
 	char *ptr;
 	int cpu;
+	unsigned long align = 1;
 
 	/* Setup cpu_pda map */
 	setup_cpu_pda_map();
 
 	/* Copy section for each CPU (we discard the original) */
-	size = PERCPU_ENOUGH_ROOM;
+	old_size = PERCPU_ENOUGH_ROOM;
+	da_size = per_cpu_dyn_array_size(&align);
+	align = max_t(unsigned long, PAGE_SIZE, align);
+	size = roundup(old_size + da_size, align);
 	printk(KERN_INFO "PERCPU: Allocating %zd bytes of per cpu data\n",
 			  size);
 
 	for_each_possible_cpu(cpu) {
 #ifndef CONFIG_NEED_MULTIPLE_NODES
-		ptr = alloc_bootmem_pages(size);
+		ptr = __alloc_bootmem(size, align,
+				 __pa(MAX_DMA_ADDRESS));
 #else
 		int node = early_cpu_to_node(cpu);
 		if (!node_online(node) || !NODE_DATA(node)) {
-			ptr = alloc_bootmem_pages(size);
+			ptr = __alloc_bootmem(size, align,
+					 __pa(MAX_DMA_ADDRESS));
 			printk(KERN_INFO
 			       "cpu %d has no node %d or node-local memory\n",
 				cpu, node);
@@ -167,7 +173,8 @@ void __init setup_per_cpu_areas(void)
 					 cpu, __pa(ptr));
 		}
 		else {
-			ptr = alloc_bootmem_pages_node(NODE_DATA(node), size);
+			ptr = __alloc_bootmem_node(NODE_DATA(node), size, align,
+							__pa(MAX_DMA_ADDRESS));
 			if (ptr)
 				printk(KERN_DEBUG "per cpu data for cpu%d on node%d at %016lx\n",
 					 cpu, node, __pa(ptr));
@@ -176,6 +183,8 @@ void __init setup_per_cpu_areas(void)
 		per_cpu_offset(cpu) = ptr - __per_cpu_start;
 		memcpy(ptr, __per_cpu_start, __per_cpu_end - __per_cpu_start);
 
+		per_cpu_alloc_dyn_array(cpu, ptr + old_size);
+
 	}
 
 	printk(KERN_DEBUG "NR_CPUS: %d, nr_cpu_ids: %d, nr_node_ids %d\n",
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index d6a4d95..b58e7ac 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -542,10 +542,10 @@ static inline void __inquire_remote_apic(int apicid)
 	int timeout;
 	u32 status;
 
-	printk(KERN_INFO "Inquiring remote APIC #%d...\n", apicid);
+	printk(KERN_INFO "Inquiring remote APIC 0x%x...\n", apicid);
 
 	for (i = 0; i < ARRAY_SIZE(regs); i++) {
-		printk(KERN_INFO "... APIC #%d %s: ", apicid, names[i]);
+		printk(KERN_INFO "... APIC 0x%x %s: ", apicid, names[i]);
 
 		/*
 		 * Wait for idle.
@@ -873,7 +873,7 @@ do_rest:
 	start_ip = setup_trampoline();
 
 	/* So we see what's up   */
-	printk(KERN_INFO "Booting processor %d/%d ip %lx\n",
+	printk(KERN_INFO "Booting processor %d APIC 0x%x ip 0x%lx\n",
 			  cpu, apicid, start_ip);
 
 	/*
diff --git a/arch/x86/kernel/uv_irq.c b/arch/x86/kernel/uv_irq.c
new file mode 100644
index 0000000..aeef529
--- /dev/null
+++ b/arch/x86/kernel/uv_irq.c
@@ -0,0 +1,79 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * SGI UV IRQ functions
+ *
+ * Copyright (C) 2008 Silicon Graphics, Inc. All rights reserved.
+ */
+
+#include <linux/module.h>
+#include <linux/irq.h>
+
+#include <asm/apic.h>
+#include <asm/uv/uv_irq.h>
+
+static void uv_noop(unsigned int irq)
+{
+}
+
+static unsigned int uv_noop_ret(unsigned int irq)
+{
+	return 0;
+}
+
+static void uv_ack_apic(unsigned int irq)
+{
+	ack_APIC_irq();
+}
+
+struct irq_chip uv_irq_chip = {
+	.name		= "UV-CORE",
+	.startup	= uv_noop_ret,
+	.shutdown	= uv_noop,
+	.enable		= uv_noop,
+	.disable	= uv_noop,
+	.ack		= uv_noop,
+	.mask		= uv_noop,
+	.unmask		= uv_noop,
+	.eoi		= uv_ack_apic,
+	.end		= uv_noop,
+};
+
+/*
+ * Set up a mapping of an available irq and vector, and enable the specified
+ * MMR that defines the MSI that is to be sent to the specified CPU when an
+ * interrupt is raised.
+ */
+int uv_setup_irq(char *irq_name, int cpu, int mmr_blade,
+		 unsigned long mmr_offset)
+{
+	int irq;
+	int ret;
+
+	irq = create_irq();
+	if (irq <= 0)
+		return -EBUSY;
+
+	ret = arch_enable_uv_irq(irq_name, irq, cpu, mmr_blade, mmr_offset);
+	if (ret != irq)
+		destroy_irq(irq);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(uv_setup_irq);
+
+/*
+ * Tear down a mapping of an irq and vector, and disable the specified MMR that
+ * defined the MSI that was to be sent to the specified CPU when an interrupt
+ * was raised.
+ *
+ * Set mmr_blade and mmr_offset to what was passed in on uv_setup_irq().
+ */
+void uv_teardown_irq(unsigned int irq, int mmr_blade, unsigned long mmr_offset)
+{
+	arch_disable_uv_irq(mmr_blade, mmr_offset);
+	destroy_irq(irq);
+}
+EXPORT_SYMBOL_GPL(uv_teardown_irq);
diff --git a/arch/x86/kernel/uv_sysfs.c b/arch/x86/kernel/uv_sysfs.c
new file mode 100644
index 0000000..67f9b9d
--- /dev/null
+++ b/arch/x86/kernel/uv_sysfs.c
@@ -0,0 +1,72 @@
+/*
+ * This file supports the /sys/firmware/sgi_uv interfaces for SGI UV.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ *
+ *  Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
+ *  Copyright (c) Russ Anderson
+ */
+
+#include <linux/sysdev.h>
+#include <asm/uv/bios.h>
+
+struct kobject *sgi_uv_kobj;
+
+static ssize_t partition_id_show(struct kobject *kobj,
+			struct kobj_attribute *attr, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%ld\n", sn_partition_id);
+}
+
+static ssize_t coherence_id_show(struct kobject *kobj,
+			struct kobj_attribute *attr, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%ld\n", partition_coherence_id());
+}
+
+static struct kobj_attribute partition_id_attr =
+	__ATTR(partition_id, S_IRUGO, partition_id_show, NULL);
+
+static struct kobj_attribute coherence_id_attr =
+	__ATTR(coherence_id, S_IRUGO, coherence_id_show, NULL);
+
+
+static int __init sgi_uv_sysfs_init(void)
+{
+	unsigned long ret;
+
+	if (!sgi_uv_kobj)
+		sgi_uv_kobj = kobject_create_and_add("sgi_uv", firmware_kobj);
+	if (!sgi_uv_kobj) {
+		printk(KERN_WARNING "kobject_create_and_add sgi_uv failed \n");
+		return -EINVAL;
+	}
+
+	ret = sysfs_create_file(sgi_uv_kobj, &partition_id_attr.attr);
+	if (ret) {
+		printk(KERN_WARNING "sysfs_create_file partition_id failed \n");
+		return ret;
+	}
+
+	ret = sysfs_create_file(sgi_uv_kobj, &coherence_id_attr.attr);
+	if (ret) {
+		printk(KERN_WARNING "sysfs_create_file coherence_id failed \n");
+		return ret;
+	}
+
+	return 0;
+}
+
+device_initcall(sgi_uv_sysfs_init);
diff --git a/arch/x86/kernel/visws_quirks.c b/arch/x86/kernel/visws_quirks.c
index 61a97e6..817aa55 100644
--- a/arch/x86/kernel/visws_quirks.c
+++ b/arch/x86/kernel/visws_quirks.c
@@ -484,10 +484,11 @@ static void disable_cobalt_irq(unsigned int irq)
 static unsigned int startup_cobalt_irq(unsigned int irq)
 {
 	unsigned long flags;
+	struct irq_desc *desc = irq_to_desc(irq);
 
 	spin_lock_irqsave(&cobalt_lock, flags);
-	if ((irq_desc[irq].status & (IRQ_DISABLED | IRQ_INPROGRESS | IRQ_WAITING)))
-		irq_desc[irq].status &= ~(IRQ_DISABLED | IRQ_INPROGRESS | IRQ_WAITING);
+	if ((desc->status & (IRQ_DISABLED | IRQ_INPROGRESS | IRQ_WAITING)))
+		desc->status &= ~(IRQ_DISABLED | IRQ_INPROGRESS | IRQ_WAITING);
 	enable_cobalt_irq(irq);
 	spin_unlock_irqrestore(&cobalt_lock, flags);
 	return 0;
@@ -506,9 +507,10 @@ static void ack_cobalt_irq(unsigned int irq)
 static void end_cobalt_irq(unsigned int irq)
 {
 	unsigned long flags;
+	struct irq_desc *desc = irq_to_desc(irq);
 
 	spin_lock_irqsave(&cobalt_lock, flags);
-	if (!(irq_desc[irq].status & (IRQ_DISABLED | IRQ_INPROGRESS)))
+	if (!(desc->status & (IRQ_DISABLED | IRQ_INPROGRESS)))
 		enable_cobalt_irq(irq);
 	spin_unlock_irqrestore(&cobalt_lock, flags);
 }
@@ -626,12 +628,12 @@ static irqreturn_t piix4_master_intr(int irq, void *dev_id)
 
 	spin_unlock_irqrestore(&i8259A_lock, flags);
 
-	desc = irq_desc + realirq;
+	desc = irq_to_desc(realirq);
 
 	/*
 	 * handle this 'virtual interrupt' as a Cobalt one now.
 	 */
-	kstat_cpu(smp_processor_id()).irqs[realirq]++;
+	kstat_irqs_this_cpu(desc)++;
 
 	if (likely(desc->action != NULL))
 		handle_IRQ_event(realirq, desc->action);
@@ -662,27 +664,29 @@ void init_VISWS_APIC_irqs(void)
 	int i;
 
 	for (i = 0; i < CO_IRQ_APIC0 + CO_APIC_LAST + 1; i++) {
-		irq_desc[i].status = IRQ_DISABLED;
-		irq_desc[i].action = 0;
-		irq_desc[i].depth = 1;
+		struct irq_desc *desc = irq_to_desc(i);
+
+		desc->status = IRQ_DISABLED;
+		desc->action = 0;
+		desc->depth = 1;
 
 		if (i == 0) {
-			irq_desc[i].chip = &cobalt_irq_type;
+			desc->chip = &cobalt_irq_type;
 		}
 		else if (i == CO_IRQ_IDE0) {
-			irq_desc[i].chip = &cobalt_irq_type;
+			desc->chip = &cobalt_irq_type;
 		}
 		else if (i == CO_IRQ_IDE1) {
-			irq_desc[i].chip = &cobalt_irq_type;
+			desc->chip = &cobalt_irq_type;
 		}
 		else if (i == CO_IRQ_8259) {
-			irq_desc[i].chip = &piix4_master_irq_type;
+			desc->chip = &piix4_master_irq_type;
 		}
 		else if (i < CO_IRQ_APIC0) {
-			irq_desc[i].chip = &piix4_virtual_irq_type;
+			desc->chip = &piix4_virtual_irq_type;
 		}
 		else if (IS_CO_APIC(i)) {
-			irq_desc[i].chip = &cobalt_irq_type;
+			desc->chip = &cobalt_irq_type;
 		}
 	}
 
diff --git a/arch/x86/kernel/vmiclock_32.c b/arch/x86/kernel/vmiclock_32.c
index 6953859..254ee07 100644
--- a/arch/x86/kernel/vmiclock_32.c
+++ b/arch/x86/kernel/vmiclock_32.c
@@ -235,11 +235,14 @@ static void __devinit vmi_time_init_clockevent(void)
 
 void __init vmi_time_init(void)
 {
+	unsigned int cpu;
 	/* Disable PIT: BIOSes start PIT CH0 with 18.2hz peridic. */
 	outb_pit(0x3a, PIT_MODE); /* binary, mode 5, LSB/MSB, ch 0 */
 
 	vmi_time_init_clockevent();
 	setup_irq(0, &vmi_clock_action);
+	for_each_possible_cpu(cpu)
+		per_cpu(vector_irq, cpu)[vmi_get_timer_vector()] = 0;
 }
 
 #ifdef CONFIG_X86_LOCAL_APIC
diff --git a/arch/x86/kernel/vmlinux_32.lds.S b/arch/x86/kernel/vmlinux_32.lds.S
index a9b8560..c36007a 100644
--- a/arch/x86/kernel/vmlinux_32.lds.S
+++ b/arch/x86/kernel/vmlinux_32.lds.S
@@ -145,6 +145,7 @@ SECTIONS
 	*(.x86_cpu_dev.init)
 	__x86_cpu_dev_end = .;
   }
+  DYN_ARRAY_INIT(8)
   SECURITY_INIT
   . = ALIGN(4);
   .altinstructions : AT(ADDR(.altinstructions) - LOAD_OFFSET) {
diff --git a/arch/x86/kernel/vmlinux_64.lds.S b/arch/x86/kernel/vmlinux_64.lds.S
index 46e0544..30973db 100644
--- a/arch/x86/kernel/vmlinux_64.lds.S
+++ b/arch/x86/kernel/vmlinux_64.lds.S
@@ -173,6 +173,9 @@ SECTIONS
 	*(.x86_cpu_dev.init)
   }
   __x86_cpu_dev_end = .;
+
+  DYN_ARRAY_INIT(8)
+
   SECURITY_INIT
 
   . = ALIGN(8);
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index 65f0b8a..48ee4f9 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -582,7 +582,7 @@ static void __init lguest_init_IRQ(void)
 	for (i = 0; i < LGUEST_IRQS; i++) {
 		int vector = FIRST_EXTERNAL_VECTOR + i;
 		if (vector != SYSCALL_VECTOR) {
-			set_intr_gate(vector, interrupt[i]);
+			set_intr_gate(vector, interrupt[vector]);
 			set_irq_chip_and_handler_name(i, &lguest_irq_controller,
 						      handle_level_irq,
 						      "level");
diff --git a/arch/x86/mach-generic/bigsmp.c b/arch/x86/mach-generic/bigsmp.c
index df37fc9..3c3b471 100644
--- a/arch/x86/mach-generic/bigsmp.c
+++ b/arch/x86/mach-generic/bigsmp.c
@@ -41,6 +41,10 @@ static const struct dmi_system_id bigsmp_dmi_table[] = {
 	 { }
 };
 
+static cpumask_t vector_allocation_domain(int cpu)
+{
+        return cpumask_of_cpu(cpu);
+}
 
 static int probe_bigsmp(void)
 {
diff --git a/arch/x86/mach-generic/es7000.c b/arch/x86/mach-generic/es7000.c
index 6513d41..28459ca 100644
--- a/arch/x86/mach-generic/es7000.c
+++ b/arch/x86/mach-generic/es7000.c
@@ -75,4 +75,18 @@ static int __init acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 }
 #endif
 
+static cpumask_t vector_allocation_domain(int cpu)
+{
+	/* Careful. Some cpus do not strictly honor the set of cpus
+	 * specified in the interrupt destination when using lowest
+	 * priority interrupt delivery mode.
+	 *
+	 * In particular there was a hyperthreading cpu observed to
+	 * deliver interrupts to the wrong hyperthread when only one
+	 * hyperthread was specified in the interrupt desitination.
+	 */
+	cpumask_t domain = { { [0] = APIC_ALL_CPUS, } };
+	return domain;
+}
+
 struct genapic __initdata_refok apic_es7000 = APIC_INIT("es7000", probe_es7000);
diff --git a/arch/x86/mach-generic/numaq.c b/arch/x86/mach-generic/numaq.c
index 8cf5839..71a309b 100644
--- a/arch/x86/mach-generic/numaq.c
+++ b/arch/x86/mach-generic/numaq.c
@@ -38,4 +38,18 @@ static int acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 	return 0;
 }
 
+static cpumask_t vector_allocation_domain(int cpu)
+{
+	/* Careful. Some cpus do not strictly honor the set of cpus
+	 * specified in the interrupt destination when using lowest
+	 * priority interrupt delivery mode.
+	 *
+	 * In particular there was a hyperthreading cpu observed to
+	 * deliver interrupts to the wrong hyperthread when only one
+	 * hyperthread was specified in the interrupt desitination.
+	 */
+	cpumask_t domain = { { [0] = APIC_ALL_CPUS, } };
+	return domain;
+}
+
 struct genapic apic_numaq = APIC_INIT("NUMAQ", probe_numaq);
diff --git a/arch/x86/mach-generic/summit.c b/arch/x86/mach-generic/summit.c
index 6ad6b67..6272b5e 100644
--- a/arch/x86/mach-generic/summit.c
+++ b/arch/x86/mach-generic/summit.c
@@ -23,4 +23,18 @@ static int probe_summit(void)
 	return 0;
 }
 
+static cpumask_t vector_allocation_domain(int cpu)
+{
+	/* Careful. Some cpus do not strictly honor the set of cpus
+	 * specified in the interrupt destination when using lowest
+	 * priority interrupt delivery mode.
+	 *
+	 * In particular there was a hyperthreading cpu observed to
+	 * deliver interrupts to the wrong hyperthread when only one
+	 * hyperthread was specified in the interrupt desitination.
+	 */
+	cpumask_t domain = { { [0] = APIC_ALL_CPUS, } };
+	return domain;
+}
+
 struct genapic apic_summit = APIC_INIT("summit", probe_summit);
diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
index ee0fba0..ace91f0 100644
--- a/arch/x86/mach-voyager/voyager_smp.c
+++ b/arch/x86/mach-voyager/voyager_smp.c
@@ -1481,7 +1481,7 @@ static void disable_local_vic_irq(unsigned int irq)
  * the interrupt off to another CPU */
 static void before_handle_vic_irq(unsigned int irq)
 {
-	irq_desc_t *desc = irq_desc + irq;
+	irq_desc_t *desc = irq_to_desc(irq);
 	__u8 cpu = smp_processor_id();
 
 	_raw_spin_lock(&vic_irq_lock);
@@ -1516,7 +1516,7 @@ static void before_handle_vic_irq(unsigned int irq)
 /* Finish the VIC interrupt: basically mask */
 static void after_handle_vic_irq(unsigned int irq)
 {
-	irq_desc_t *desc = irq_desc + irq;
+	irq_desc_t *desc = irq_to_desc(irq);
 
 	_raw_spin_lock(&vic_irq_lock);
 	{
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index c67d78d..d3fc121 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -65,6 +65,7 @@ static unsigned long __meminitdata table_end;
 static unsigned long __meminitdata table_top;
 
 static int __initdata after_init_bootmem;
+int after_bootmem;
 
 static __init void *alloc_low_page(unsigned long *phys)
 {
@@ -985,6 +986,8 @@ void __init mem_init(void)
 
 	set_highmem_pages_init();
 
+	after_bootmem = 1;
+
 	codesize =  (unsigned long) &_etext - (unsigned long) &_text;
 	datasize =  (unsigned long) &_edata - (unsigned long) &_etext;
 	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index 1b4763e..51c0a2f 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -138,7 +138,7 @@ acpi_numa_processor_affinity_init(struct acpi_srat_cpu_affinity *pa)
 		return;
 	}
 
-	if (is_uv_system())
+	if (get_uv_system_type() >= UV_X2APIC)
 		apic_id = (pa->apic_id << 8) | pa->local_sapic_eid;
 	else
 		apic_id = pa->apic_id;
diff --git a/arch/x86/xen/irq.c b/arch/x86/xen/irq.c
index 28b85ab..bb04260 100644
--- a/arch/x86/xen/irq.c
+++ b/arch/x86/xen/irq.c
@@ -21,7 +21,6 @@ void xen_force_evtchn_callback(void)
 
 static void __init __xen_init_IRQ(void)
 {
-#ifdef CONFIG_X86_64
 	int i;
 
 	/* Create identity vector->irq map */
@@ -31,7 +30,6 @@ static void __init __xen_init_IRQ(void)
 		for_each_possible_cpu(cpu)
 			per_cpu(vector_irq, cpu)[i] = i;
 	}
-#endif	/* CONFIG_X86_64 */
 
 	xen_init_IRQ();
 }
diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index dd71e3a..bb6bc72 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -241,7 +241,7 @@ static noinline int xen_spin_lock_slow(struct raw_spinlock *lock, bool irq_enabl
 		ADD_STATS(taken_slow_spurious, !xen_test_irq_pending(irq));
 	} while (!xen_test_irq_pending(irq)); /* check for spurious wakeups */
 
-	kstat_this_cpu.irqs[irq]++;
+	kstat_irqs_this_cpu(irq_to_desc(irq))++;
 
 out:
 	raw_local_irq_restore(flags);
diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index f3cfb4c..408f5f9 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -219,7 +219,7 @@ static void hpet_timer_set_irq(struct hpet_dev *devp)
 	for (irq = find_first_bit(&v, HPET_MAX_IRQ); irq < HPET_MAX_IRQ;
 		irq = find_next_bit(&v, HPET_MAX_IRQ, 1 + irq)) {
 
-		if (irq >= NR_IRQS) {
+		if (irq >= nr_irqs) {
 			irq = HPET_MAX_IRQ;
 			break;
 		}
diff --git a/drivers/char/random.c b/drivers/char/random.c
index 7ce1ac4..a3c8b95 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -558,8 +558,59 @@ struct timer_rand_state {
 	unsigned dont_count_entropy:1;
 };
 
-static struct timer_rand_state input_timer_state;
+#ifndef CONFIG_HAVE_SPARSE_IRQ
+
+#ifdef CONFIG_HAVE_DYN_ARRAY
+static struct timer_rand_state **irq_timer_state;
+DEFINE_DYN_ARRAY(irq_timer_state, sizeof(struct timer_rand_state *), nr_irqs, PAGE_SIZE, NULL);
+#else
 static struct timer_rand_state *irq_timer_state[NR_IRQS];
+#endif
+
+static struct timer_rand_state *get_timer_rand_state(unsigned int irq)
+{
+	if (irq >= nr_irqs)
+		return NULL;
+
+	return irq_timer_state[irq];
+}
+
+static void set_timer_rand_state(unsigned int irq, struct timer_rand_state *state)
+{
+	if (irq >= nr_irqs)
+		return;
+
+	irq_timer_state[irq] = state;
+}
+
+#else
+
+static struct timer_rand_state *get_timer_rand_state(unsigned int irq)
+{
+	struct irq_desc *desc;
+
+	desc = irq_to_desc(irq);
+
+	if (!desc)
+		return NULL;
+
+	return desc->timer_rand_state;
+}
+
+static void set_timer_rand_state(unsigned int irq, struct timer_rand_state *state)
+{
+	struct irq_desc *desc;
+
+	desc = irq_to_desc(irq);
+
+	if (!desc)
+		return;
+
+	desc->timer_rand_state = state;
+}
+#endif
+
+static struct timer_rand_state input_timer_state;
 
 /*
  * This function adds entropy to the entropy "pool" by using timing
@@ -648,11 +699,15 @@ EXPORT_SYMBOL_GPL(add_input_randomness);
 
 void add_interrupt_randomness(int irq)
 {
-	if (irq >= NR_IRQS || irq_timer_state[irq] == NULL)
+	struct timer_rand_state *state;
+
+	state = get_timer_rand_state(irq);
+
+	if (state == NULL)
 		return;
 
 	DEBUG_ENT("irq event %d\n", irq);
-	add_timer_randomness(irq_timer_state[irq], 0x100 + irq);
+	add_timer_randomness(state, 0x100 + irq);
 }
 
 #ifdef CONFIG_BLOCK
@@ -912,7 +967,14 @@ void rand_initialize_irq(int irq)
 {
 	struct timer_rand_state *state;
 
-	if (irq >= NR_IRQS || irq_timer_state[irq])
+#ifndef CONFIG_HAVE_SPARSE_IRQ
+	if (irq >= nr_irqs)
+		return;
+#endif
+
+	state = get_timer_rand_state(irq);
+
+	if (state)
 		return;
 
 	/*
@@ -921,7 +983,7 @@ void rand_initialize_irq(int irq)
 	 */
 	state = kzalloc(sizeof(struct timer_rand_state), GFP_KERNEL);
 	if (state)
-		irq_timer_state[irq] = state;
+		set_timer_rand_state(irq, state);
 }
 
 #ifdef CONFIG_BLOCK
diff --git a/drivers/char/vr41xx_giu.c b/drivers/char/vr41xx_giu.c
index ffe9b4e..54c8372 100644
--- a/drivers/char/vr41xx_giu.c
+++ b/drivers/char/vr41xx_giu.c
@@ -641,7 +641,7 @@ static int __devinit giu_probe(struct platform_device *dev)
 	}
 
 	irq = platform_get_irq(dev, 0);
-	if (irq < 0 || irq >= NR_IRQS)
+	if (irq < 0 || irq >= nr_irqs)
 		return -EBUSY;
 
 	return cascade_irq(irq, giu_get_irq);
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 8d29405..572d372 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1058,7 +1058,7 @@ static void gpiolib_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 
 		if (!is_out) {
 			int		irq = gpio_to_irq(gpio);
-			struct irq_desc	*desc = irq_desc + irq;
+			struct irq_desc	*desc = irq_to_desc(irq);
 
 			/* This races with request_irq(), set_irq_type(),
 			 * and set_irq_wake() ... but those are "rare".
diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
index ba5aa20..e4c0db4 100644
--- a/drivers/mfd/asic3.c
+++ b/drivers/mfd/asic3.c
@@ -123,7 +123,7 @@ static void asic3_irq_demux(unsigned int irq, struct irq_desc *desc)
 					irqnr = asic->irq_base +
 						(ASIC3_GPIOS_PER_BANK * bank)
 						+ i;
-					desc = irq_desc + irqnr;
+					desc = irq_to_desc(irqnr);
 					desc->handle_irq(irqnr, desc);
 					if (asic->irq_bothedge[bank] & bit)
 						asic3_irq_flip_edge(asic, base,
@@ -136,7 +136,7 @@ static void asic3_irq_demux(unsigned int irq, struct irq_desc *desc)
 		for (i = ASIC3_NUM_GPIOS; i < ASIC3_NR_IRQS; i++) {
 			/* They start at bit 4 and go up */
 			if (status & (1 << (i - ASIC3_NUM_GPIOS + 4))) {
-				desc = irq_desc + asic->irq_base + i;
+				desc = irq_to_desc(asic->irq_base + i);
 				desc->handle_irq(asic->irq_base + i,
 						 desc);
 			}
diff --git a/drivers/mfd/htc-egpio.c b/drivers/mfd/htc-egpio.c
index 6be4317..ad3379f 100644
--- a/drivers/mfd/htc-egpio.c
+++ b/drivers/mfd/htc-egpio.c
@@ -112,7 +112,7 @@ static void egpio_handler(unsigned int irq, struct irq_desc *desc)
 		/* Run irq handler */
 		pr_debug("got IRQ %d\n", irqpin);
 		irq = ei->irq_start + irqpin;
-		desc = &irq_desc[irq];
+		desc = irq_to_desc(irq);
 		desc->handle_irq(irq, desc);
 	}
 }
diff --git a/drivers/net/3c59x.c b/drivers/net/3c59x.c
index 491ee16..9ba295d 100644
--- a/drivers/net/3c59x.c
+++ b/drivers/net/3c59x.c
@@ -90,7 +90,7 @@ static int vortex_debug = 1;
 #include <linux/eisa.h>
 #include <linux/bitops.h>
 #include <linux/jiffies.h>
-#include <asm/irq.h>			/* For NR_IRQS only. */
+#include <asm/irq.h>			/* For nr_irqs only. */
 #include <asm/io.h>
 #include <asm/uaccess.h>
 
@@ -1221,7 +1221,7 @@ static int __devinit vortex_probe1(struct device *gendev,
 	if (print_info)
 		printk(", IRQ %d\n", dev->irq);
 	/* Tell them about an invalid IRQ. */
-	if (dev->irq <= 0 || dev->irq >= NR_IRQS)
+	if (dev->irq <= 0 || dev->irq >= nr_irqs)
 		printk(KERN_WARNING " *** Warning: IRQ %d is unlikely to work! ***\n",
 			   dev->irq);
 
diff --git a/drivers/net/hamradio/baycom_ser_fdx.c b/drivers/net/hamradio/baycom_ser_fdx.c
index 17ac697..b6a816e 100644
--- a/drivers/net/hamradio/baycom_ser_fdx.c
+++ b/drivers/net/hamradio/baycom_ser_fdx.c
@@ -416,10 +416,10 @@ static int ser12_open(struct net_device *dev)
 	if (!dev || !bc)
 		return -ENXIO;
 	if (!dev->base_addr || dev->base_addr > 0xffff-SER12_EXTENT ||
-	    dev->irq < 2 || dev->irq > NR_IRQS) {
+	    dev->irq < 2 || dev->irq > nr_irqs) {
 		printk(KERN_INFO "baycom_ser_fdx: invalid portnumber (max %u) "
 				"or irq (2 <= irq <= %d)\n",
-				0xffff-SER12_EXTENT, NR_IRQS);
+				0xffff-SER12_EXTENT, nr_irqs);
 		return -ENXIO;
 	}
 	if (bc->baud < 300 || bc->baud > 4800) {
diff --git a/drivers/net/hamradio/scc.c b/drivers/net/hamradio/scc.c
index 45ae9d1..c17e39b 100644
--- a/drivers/net/hamradio/scc.c
+++ b/drivers/net/hamradio/scc.c
@@ -1465,7 +1465,7 @@ static void z8530_init(void)
 	printk(KERN_INFO "Init Z8530 driver: %u channels, IRQ", Nchips*2);
 	
 	flag=" ";
-	for (k = 0; k < NR_IRQS; k++)
+	for (k = 0; k < nr_irqs; k++)
 		if (Ivec[k].used) 
 		{
 			printk("%s%d", flag, k);
@@ -1728,7 +1728,7 @@ static int scc_net_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 
 			if (hwcfg.irq == 2) hwcfg.irq = 9;
 
-			if (hwcfg.irq < 0 || hwcfg.irq >= NR_IRQS)
+			if (hwcfg.irq < 0 || hwcfg.irq >= nr_irqs)
 				return -EINVAL;
 				
 			if (!Ivec[hwcfg.irq].used && hwcfg.irq)
@@ -2148,7 +2148,7 @@ static void __exit scc_cleanup_driver(void)
 		}
 		
 	/* To unload the port must be closed so no real IRQ pending */
-	for (k=0; k < NR_IRQS ; k++)
+	for (k = 0; k < nr_irqs ; k++)
 		if (Ivec[k].used) free_irq(k, NULL);
 		
 	local_irq_enable();
diff --git a/drivers/net/wan/sbni.c b/drivers/net/wan/sbni.c
index 6596cd0..bc91f03 100644
--- a/drivers/net/wan/sbni.c
+++ b/drivers/net/wan/sbni.c
@@ -318,7 +318,7 @@ sbni_pci_probe( struct net_device  *dev )
 				continue;
 		}
 
-		if( pci_irq_line <= 0  ||  pci_irq_line >= NR_IRQS )
+		if (pci_irq_line <= 0 || pci_irq_line >= nr_irqs)
 			printk( KERN_WARNING "  WARNING: The PCI BIOS assigned "
 				"this PCI card to IRQ %d, which is unlikely "
 				"to work!.\n"
diff --git a/drivers/parisc/dino.c b/drivers/parisc/dino.c
index fd56128..3bc54b3 100644
--- a/drivers/parisc/dino.c
+++ b/drivers/parisc/dino.c
@@ -298,7 +298,8 @@ struct pci_port_ops dino_port_ops = {
 
 static void dino_disable_irq(unsigned int irq)
 {
-	struct dino_device *dino_dev = irq_desc[irq].chip_data;
+	struct irq_desc *desc = irq_to_desc(irq);
+	struct dino_device *dino_dev = desc->chip_data;
 	int local_irq = gsc_find_local_irq(irq, dino_dev->global_irq, DINO_LOCAL_IRQS);
 
 	DBG(KERN_WARNING "%s(0x%p, %d)\n", __func__, dino_dev, irq);
@@ -310,7 +311,8 @@ static void dino_disable_irq(unsigned int irq)
 
 static void dino_enable_irq(unsigned int irq)
 {
-	struct dino_device *dino_dev = irq_desc[irq].chip_data;
+	struct irq_desc *desc = irq_to_desc(irq);
+	struct dino_device *dino_dev = desc->chip_data;
 	int local_irq = gsc_find_local_irq(irq, dino_dev->global_irq, DINO_LOCAL_IRQS);
 	u32 tmp;
 
diff --git a/drivers/parisc/eisa.c b/drivers/parisc/eisa.c
index 771cef5..7891db5 100644
--- a/drivers/parisc/eisa.c
+++ b/drivers/parisc/eisa.c
@@ -346,10 +346,10 @@ static int __init eisa_probe(struct parisc_device *dev)
 	}
 	
 	/* Reserve IRQ2 */
-	irq_desc[2].action = &irq2_action;
+	irq_to_desc(2)->action = &irq2_action;
 	
 	for (i = 0; i < 16; i++) {
-		irq_desc[i].chip = &eisa_interrupt_type;
+		irq_to_desc(i)->chip = &eisa_interrupt_type;
 	}
 	
 	EISA_bus = 1;
diff --git a/drivers/parisc/gsc.c b/drivers/parisc/gsc.c
index f7d088b..e76db9e 100644
--- a/drivers/parisc/gsc.c
+++ b/drivers/parisc/gsc.c
@@ -108,7 +108,8 @@ int gsc_find_local_irq(unsigned int irq, int *global_irqs, int limit)
 
 static void gsc_asic_disable_irq(unsigned int irq)
 {
-	struct gsc_asic *irq_dev = irq_desc[irq].chip_data;
+	struct irq_desc *desc = irq_to_desc(irq);
+	struct gsc_asic *irq_dev = desc->chip_data;
 	int local_irq = gsc_find_local_irq(irq, irq_dev->global_irq, 32);
 	u32 imr;
 
@@ -123,7 +124,8 @@ static void gsc_asic_disable_irq(unsigned int irq)
 
 static void gsc_asic_enable_irq(unsigned int irq)
 {
-	struct gsc_asic *irq_dev = irq_desc[irq].chip_data;
+	struct irq_desc *desc = irq_to_desc(irq);
+	struct gsc_asic *irq_dev = desc->chip_data;
 	int local_irq = gsc_find_local_irq(irq, irq_dev->global_irq, 32);
 	u32 imr;
 
@@ -159,12 +161,14 @@ static struct hw_interrupt_type gsc_asic_interrupt_type = {
 int gsc_assign_irq(struct hw_interrupt_type *type, void *data)
 {
 	static int irq = GSC_IRQ_BASE;
+	struct irq_desc *desc;
 
 	if (irq > GSC_IRQ_MAX)
 		return NO_IRQ;
 
-	irq_desc[irq].chip = type;
-	irq_desc[irq].chip_data = data;
+	desc = irq_to_desc(irq);
+	desc->chip = type;
+	desc->chip_data = data;
 	return irq++;
 }
 
diff --git a/drivers/parisc/iosapic.c b/drivers/parisc/iosapic.c
index 6fb3f79..7beffca 100644
--- a/drivers/parisc/iosapic.c
+++ b/drivers/parisc/iosapic.c
@@ -619,7 +619,9 @@ iosapic_set_irt_data( struct vector_info *vi, u32 *dp0, u32 *dp1)
 
 static struct vector_info *iosapic_get_vector(unsigned int irq)
 {
-	return irq_desc[irq].chip_data;
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	return desc->chip_data;
 }
 
 static void iosapic_disable_irq(unsigned int irq)
diff --git a/drivers/parisc/superio.c b/drivers/parisc/superio.c
index 1e8d2d1..1e93c83 100644
--- a/drivers/parisc/superio.c
+++ b/drivers/parisc/superio.c
@@ -363,7 +363,9 @@ int superio_fixup_irq(struct pci_dev *pcidev)
 #endif
 
 	for (i = 0; i < 16; i++) {
-		irq_desc[i].chip = &superio_interrupt_type;
+		struct irq_desc *desc = irq_to_desc(i);
+
+		desc->chip = &superio_interrupt_type;
 	}
 
 	/*
diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index bd2c016..f16adfe 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -42,6 +42,7 @@
 LIST_HEAD(dmar_drhd_units);
 
 static struct acpi_table_header * __initdata dmar_tbl;
+static acpi_size __initdata dmar_tbl_size;
 
 static void __init dmar_register_drhd_unit(struct dmar_drhd_unit *drhd)
 {
@@ -193,7 +194,7 @@ dmar_parse_dev(struct dmar_drhd_unit *dmaru)
 {
 	struct acpi_dmar_hardware_unit *drhd;
 	static int include_all;
-	int ret;
+	int ret = 0;
 
 	drhd = (struct acpi_dmar_hardware_unit *) dmaru->hdr;
 
@@ -212,7 +213,7 @@ dmar_parse_dev(struct dmar_drhd_unit *dmaru)
 		include_all = 1;
 	}
 
-	if (ret || (dmaru->devices_cnt == 0 && !dmaru->include_all)) {
+	if (ret) {
 		list_del(&dmaru->list);
 		kfree(dmaru);
 	}
@@ -289,6 +290,25 @@ dmar_table_print_dmar_entry(struct acpi_dmar_header *header)
 	}
 }
 
+/**
+ * dmar_table_detect - checks to see if the platform supports DMAR devices
+ */
+static int __init dmar_table_detect(void)
+{
+	acpi_status status = AE_OK;
+
+	/* if we could find DMAR table, then there are DMAR devices */
+	status = acpi_get_table_with_size(ACPI_SIG_DMAR, 0,
+				(struct acpi_table_header **)&dmar_tbl,
+				&dmar_tbl_size);
+
+	if (ACPI_SUCCESS(status) && !dmar_tbl) {
+		printk (KERN_WARNING PREFIX "Unable to map DMAR\n");
+		status = AE_NOT_FOUND;
+	}
+
+	return (ACPI_SUCCESS(status) ? 1 : 0);
+}
 
 /**
  * parse_dmar_table - parses the DMA reporting table
@@ -300,6 +320,12 @@ parse_dmar_table(void)
 	struct acpi_dmar_header *entry_header;
 	int ret = 0;
 
+	/*
+	 * Do it again, earlier dmar_tbl mapping could be mapped with
+	 * fixed map.
+	 */
+	dmar_table_detect();
+
 	dmar = (struct acpi_table_dmar *)dmar_tbl;
 	if (!dmar)
 		return -ENODEV;
@@ -373,10 +399,10 @@ dmar_find_matched_drhd_unit(struct pci_dev *dev)
 
 int __init dmar_dev_scope_init(void)
 {
-	struct dmar_drhd_unit *drhd;
+	struct dmar_drhd_unit *drhd, *drhd_n;
 	int ret = -ENODEV;
 
-	for_each_drhd_unit(drhd) {
+	list_for_each_entry_safe(drhd, drhd_n, &dmar_drhd_units, list) {
 		ret = dmar_parse_dev(drhd);
 		if (ret)
 			return ret;
@@ -384,8 +410,8 @@ int __init dmar_dev_scope_init(void)
 
 #ifdef CONFIG_DMAR
 	{
-		struct dmar_rmrr_unit *rmrr;
-		for_each_rmrr_units(rmrr) {
+		struct dmar_rmrr_unit *rmrr, *rmrr_n;
+		list_for_each_entry_safe(rmrr, rmrr_n, &dmar_rmrr_units, list) {
 			ret = rmrr_parse_dev(rmrr);
 			if (ret)
 				return ret;
@@ -430,30 +456,11 @@ int __init dmar_table_init(void)
 	return 0;
 }
 
-/**
- * early_dmar_detect - checks to see if the platform supports DMAR devices
- */
-int __init early_dmar_detect(void)
-{
-	acpi_status status = AE_OK;
-
-	/* if we could find DMAR table, then there are DMAR devices */
-	status = acpi_get_table(ACPI_SIG_DMAR, 0,
-				(struct acpi_table_header **)&dmar_tbl);
-
-	if (ACPI_SUCCESS(status) && !dmar_tbl) {
-		printk (KERN_WARNING PREFIX "Unable to map DMAR\n");
-		status = AE_NOT_FOUND;
-	}
-
-	return (ACPI_SUCCESS(status) ? 1 : 0);
-}
-
 void __init detect_intel_iommu(void)
 {
 	int ret;
 
-	ret = early_dmar_detect();
+	ret = dmar_table_detect();
 
 #ifdef CONFIG_DMAR
 	{
@@ -479,14 +486,19 @@ void __init detect_intel_iommu(void)
 			       " x2apic support\n");
 
 			dmar_disabled = 1;
-			return;
+			goto end;
 		}
 
 		if (ret && !no_iommu && !iommu_detected && !swiotlb &&
 		    !dmar_disabled)
 			iommu_detected = 1;
 	}
+end:
 #endif
+	if (dmar_tbl)
+		early_acpi_os_unmap_memory(dmar_tbl, dmar_tbl_size);
+
+	dmar_tbl = NULL;
 }
 
 
diff --git a/drivers/pci/htirq.c b/drivers/pci/htirq.c
index 279c940..9e4929a 100644
--- a/drivers/pci/htirq.c
+++ b/drivers/pci/htirq.c
@@ -82,6 +82,18 @@ void unmask_ht_irq(unsigned int irq)
 	write_ht_irq_msg(irq, &msg);
 }
 
+static unsigned int build_irq_for_pci_dev(struct pci_dev *dev)
+{
+	unsigned int irq;
+
+	irq = dev->bus->number;
+	irq <<= 8;
+	irq |= dev->devfn;
+	irq <<= 12;
+
+	return irq;
+}
+
 /**
  * __ht_create_irq - create an irq and attach it to a device.
  * @dev: The hypertransport device to find the irq capability on.
@@ -98,6 +110,7 @@ int __ht_create_irq(struct pci_dev *dev, int idx, ht_irq_update_t *update)
 	int max_irq;
 	int pos;
 	int irq;
+	unsigned int irq_want;
 
 	pos = pci_find_ht_capability(dev, HT_CAPTYPE_IRQ);
 	if (!pos)
@@ -125,8 +138,13 @@ int __ht_create_irq(struct pci_dev *dev, int idx, ht_irq_update_t *update)
 	cfg->msg.address_lo = 0xffffffff;
 	cfg->msg.address_hi = 0xffffffff;
 
+	irq_want= build_irq_for_pci_dev(dev);
+#ifdef CONFIG_HAVE_SPARSE_IRQ
+	irq = create_irq_nr(irq_want + idx);
+#else
 	irq = create_irq();
-	if (irq < 0) {
+#endif
+	if (irq <= 0) {
 		kfree(cfg);
 		return -EBUSY;
 	}
diff --git a/drivers/pci/intr_remapping.c b/drivers/pci/intr_remapping.c
index bb642cc..2dcf973 100644
--- a/drivers/pci/intr_remapping.c
+++ b/drivers/pci/intr_remapping.c
@@ -1,3 +1,4 @@
+#include <linux/interrupt.h>
 #include <linux/dmar.h>
 #include <linux/spinlock.h>
 #include <linux/jiffies.h>
@@ -11,41 +12,144 @@ static struct ioapic_scope ir_ioapic[MAX_IO_APICS];
 static int ir_ioapic_num;
 int intr_remapping_enabled;
 
-static struct {
+struct irq_2_iommu {
 	struct intel_iommu *iommu;
 	u16 irte_index;
 	u16 sub_handle;
 	u8  irte_mask;
-} irq_2_iommu[NR_IRQS];
+};
+
+#ifdef CONFIG_HAVE_SPARSE_IRQ
+static struct irq_2_iommu *irq_2_iommuX;
+/* fill one page ? */
+static int nr_irq_2_iommu = 0x100;
+static int irq_2_iommu_index;
+DEFINE_DYN_ARRAY(irq_2_iommuX, sizeof(struct irq_2_iommu), nr_irq_2_iommu, PAGE_SIZE, NULL);
+
+extern void *__alloc_bootmem_nopanic(unsigned long size,
+				     unsigned long align,
+				     unsigned long goal);
+
+static struct irq_2_iommu *get_one_free_irq_2_iommu(int not_used)
+{
+	struct irq_2_iommu *iommu;
+	unsigned long total_bytes;
+
+	if (irq_2_iommu_index >= nr_irq_2_iommu) {
+		/*
+		 *  we run out of pre-allocate ones, allocate more
+		 */
+		printk(KERN_DEBUG "try to get more irq_2_iommu %d\n", nr_irq_2_iommu);
+
+		total_bytes = sizeof(struct irq_2_iommu)*nr_irq_2_iommu;
+
+		if (after_bootmem)
+			iommu = kzalloc(total_bytes, GFP_ATOMIC);
+		else
+			iommu = __alloc_bootmem_nopanic(total_bytes, PAGE_SIZE, 0);
+
+		if (!iommu)
+			panic("can not get more irq_2_iommu\n");
+
+		irq_2_iommuX = iommu;
+		irq_2_iommu_index = 0;
+	}
+
+	iommu = &irq_2_iommuX[irq_2_iommu_index];
+	irq_2_iommu_index++;
+	return iommu;
+}
+
+static struct irq_2_iommu *irq_2_iommu(unsigned int irq)
+{
+	struct irq_desc *desc;
+
+	desc = irq_to_desc(irq);
+
+	BUG_ON(!desc);
+
+	return desc->irq_2_iommu;
+}
+
+static struct irq_2_iommu *irq_2_iommu_alloc(unsigned int irq)
+{
+	struct irq_desc *desc;
+	struct irq_2_iommu *irq_iommu;
+
+	/*
+	 * alloc irq desc if not allocated already.
+	 */
+	desc = irq_to_desc_alloc(irq);
+
+	irq_iommu = desc->irq_2_iommu;
+
+	if (!irq_iommu)
+		desc->irq_2_iommu = get_one_free_irq_2_iommu(irq);
+
+	return desc->irq_2_iommu;
+}
+
+#else /* !CONFIG_HAVE_SPARSE_IRQ */
+
+#ifdef CONFIG_HAVE_DYN_ARRAY
+static struct irq_2_iommu *irq_2_iommuX;
+DEFINE_DYN_ARRAY(irq_2_iommuX, sizeof(struct irq_2_iommu), nr_irqs, PAGE_SIZE, NULL);
+#else
+static struct irq_2_iommu irq_2_iommuX[NR_IRQS];
+#endif
+
+static struct irq_2_iommu *irq_2_iommu(unsigned int irq)
+{
+	if (irq < nr_irqs)
+		return &irq_2_iommuX[irq];
+
+	return NULL;
+}
+static struct irq_2_iommu *irq_2_iommu_alloc(unsigned int irq)
+{
+	return irq_2_iommu(irq);
+}
+#endif
 
 static DEFINE_SPINLOCK(irq_2_ir_lock);
 
-int irq_remapped(int irq)
+static struct irq_2_iommu *valid_irq_2_iommu(unsigned int irq)
 {
-	if (irq > NR_IRQS)
-		return 0;
+	struct irq_2_iommu *irq_iommu;
+
+	irq_iommu = irq_2_iommu(irq);
+
+	if (!irq_iommu)
+		return NULL;
 
-	if (!irq_2_iommu[irq].iommu)
-		return 0;
+	if (!irq_iommu->iommu)
+		return NULL;
 
-	return 1;
+	return irq_iommu;
+}
+
+int irq_remapped(int irq)
+{
+	return valid_irq_2_iommu(irq) != NULL;
 }
 
 int get_irte(int irq, struct irte *entry)
 {
 	int index;
+	struct irq_2_iommu *irq_iommu;
 
-	if (!entry || irq > NR_IRQS)
+	if (!entry)
 		return -1;
 
 	spin_lock(&irq_2_ir_lock);
-	if (!irq_2_iommu[irq].iommu) {
+	irq_iommu = valid_irq_2_iommu(irq);
+	if (!irq_iommu) {
 		spin_unlock(&irq_2_ir_lock);
 		return -1;
 	}
 
-	index = irq_2_iommu[irq].irte_index + irq_2_iommu[irq].sub_handle;
-	*entry = *(irq_2_iommu[irq].iommu->ir_table->base + index);
+	index = irq_iommu->irte_index + irq_iommu->sub_handle;
+	*entry = *(irq_iommu->iommu->ir_table->base + index);
 
 	spin_unlock(&irq_2_ir_lock);
 	return 0;
@@ -54,6 +158,7 @@ int get_irte(int irq, struct irte *entry)
 int alloc_irte(struct intel_iommu *iommu, int irq, u16 count)
 {
 	struct ir_table *table = iommu->ir_table;
+	struct irq_2_iommu *irq_iommu;
 	u16 index, start_index;
 	unsigned int mask = 0;
 	int i;
@@ -61,6 +166,12 @@ int alloc_irte(struct intel_iommu *iommu, int irq, u16 count)
 	if (!count)
 		return -1;
 
+#ifndef	CONFIG_HAVE_SPARSE_IRQ
+	/* protect irq_2_iommu_alloc later */
+	if (irq >= nr_irqs)
+		return -1;
+#endif
+
 	/*
 	 * start the IRTE search from index 0.
 	 */
@@ -100,10 +211,11 @@ int alloc_irte(struct intel_iommu *iommu, int irq, u16 count)
 	for (i = index; i < index + count; i++)
 		table->base[i].present = 1;
 
-	irq_2_iommu[irq].iommu = iommu;
-	irq_2_iommu[irq].irte_index =  index;
-	irq_2_iommu[irq].sub_handle = 0;
-	irq_2_iommu[irq].irte_mask = mask;
+	irq_iommu = irq_2_iommu_alloc(irq);
+	irq_iommu->iommu = iommu;
+	irq_iommu->irte_index =  index;
+	irq_iommu->sub_handle = 0;
+	irq_iommu->irte_mask = mask;
 
 	spin_unlock(&irq_2_ir_lock);
 
@@ -124,31 +236,33 @@ static void qi_flush_iec(struct intel_iommu *iommu, int index, int mask)
 int map_irq_to_irte_handle(int irq, u16 *sub_handle)
 {
 	int index;
+	struct irq_2_iommu *irq_iommu;
 
 	spin_lock(&irq_2_ir_lock);
-	if (irq >= NR_IRQS || !irq_2_iommu[irq].iommu) {
+	irq_iommu = valid_irq_2_iommu(irq);
+	if (!irq_iommu) {
 		spin_unlock(&irq_2_ir_lock);
 		return -1;
 	}
 
-	*sub_handle = irq_2_iommu[irq].sub_handle;
-	index = irq_2_iommu[irq].irte_index;
+	*sub_handle = irq_iommu->sub_handle;
+	index = irq_iommu->irte_index;
 	spin_unlock(&irq_2_ir_lock);
 	return index;
 }
 
 int set_irte_irq(int irq, struct intel_iommu *iommu, u16 index, u16 subhandle)
 {
+	struct irq_2_iommu *irq_iommu;
+
 	spin_lock(&irq_2_ir_lock);
-	if (irq >= NR_IRQS || irq_2_iommu[irq].iommu) {
-		spin_unlock(&irq_2_ir_lock);
-		return -1;
-	}
 
-	irq_2_iommu[irq].iommu = iommu;
-	irq_2_iommu[irq].irte_index = index;
-	irq_2_iommu[irq].sub_handle = subhandle;
-	irq_2_iommu[irq].irte_mask = 0;
+	irq_iommu = irq_2_iommu_alloc(irq);
+
+	irq_iommu->iommu = iommu;
+	irq_iommu->irte_index = index;
+	irq_iommu->sub_handle = subhandle;
+	irq_iommu->irte_mask = 0;
 
 	spin_unlock(&irq_2_ir_lock);
 
@@ -157,16 +271,19 @@ int set_irte_irq(int irq, struct intel_iommu *iommu, u16 index, u16 subhandle)
 
 int clear_irte_irq(int irq, struct intel_iommu *iommu, u16 index)
 {
+	struct irq_2_iommu *irq_iommu;
+
 	spin_lock(&irq_2_ir_lock);
-	if (irq >= NR_IRQS || !irq_2_iommu[irq].iommu) {
+	irq_iommu = valid_irq_2_iommu(irq);
+	if (!irq_iommu) {
 		spin_unlock(&irq_2_ir_lock);
 		return -1;
 	}
 
-	irq_2_iommu[irq].iommu = NULL;
-	irq_2_iommu[irq].irte_index = 0;
-	irq_2_iommu[irq].sub_handle = 0;
-	irq_2_iommu[irq].irte_mask = 0;
+	irq_iommu->iommu = NULL;
+	irq_iommu->irte_index = 0;
+	irq_iommu->sub_handle = 0;
+	irq_2_iommu(irq)->irte_mask = 0;
 
 	spin_unlock(&irq_2_ir_lock);
 
@@ -178,16 +295,18 @@ int modify_irte(int irq, struct irte *irte_modified)
 	int index;
 	struct irte *irte;
 	struct intel_iommu *iommu;
+	struct irq_2_iommu *irq_iommu;
 
 	spin_lock(&irq_2_ir_lock);
-	if (irq >= NR_IRQS || !irq_2_iommu[irq].iommu) {
+	irq_iommu = valid_irq_2_iommu(irq);
+	if (!irq_iommu) {
 		spin_unlock(&irq_2_ir_lock);
 		return -1;
 	}
 
-	iommu = irq_2_iommu[irq].iommu;
+	iommu = irq_iommu->iommu;
 
-	index = irq_2_iommu[irq].irte_index + irq_2_iommu[irq].sub_handle;
+	index = irq_iommu->irte_index + irq_iommu->sub_handle;
 	irte = &iommu->ir_table->base[index];
 
 	set_64bit((unsigned long *)irte, irte_modified->low | (1 << 1));
@@ -203,18 +322,20 @@ int flush_irte(int irq)
 {
 	int index;
 	struct intel_iommu *iommu;
+	struct irq_2_iommu *irq_iommu;
 
 	spin_lock(&irq_2_ir_lock);
-	if (irq >= NR_IRQS || !irq_2_iommu[irq].iommu) {
+	irq_iommu = valid_irq_2_iommu(irq);
+	if (!irq_iommu) {
 		spin_unlock(&irq_2_ir_lock);
 		return -1;
 	}
 
-	iommu = irq_2_iommu[irq].iommu;
+	iommu = irq_iommu->iommu;
 
-	index = irq_2_iommu[irq].irte_index + irq_2_iommu[irq].sub_handle;
+	index = irq_iommu->irte_index + irq_iommu->sub_handle;
 
-	qi_flush_iec(iommu, index, irq_2_iommu[irq].irte_mask);
+	qi_flush_iec(iommu, index, irq_iommu->irte_mask);
 	spin_unlock(&irq_2_ir_lock);
 
 	return 0;
@@ -246,28 +367,30 @@ int free_irte(int irq)
 	int index, i;
 	struct irte *irte;
 	struct intel_iommu *iommu;
+	struct irq_2_iommu *irq_iommu;
 
 	spin_lock(&irq_2_ir_lock);
-	if (irq >= NR_IRQS || !irq_2_iommu[irq].iommu) {
+	irq_iommu = valid_irq_2_iommu(irq);
+	if (!irq_iommu) {
 		spin_unlock(&irq_2_ir_lock);
 		return -1;
 	}
 
-	iommu = irq_2_iommu[irq].iommu;
+	iommu = irq_iommu->iommu;
 
-	index = irq_2_iommu[irq].irte_index + irq_2_iommu[irq].sub_handle;
+	index = irq_iommu->irte_index + irq_iommu->sub_handle;
 	irte = &iommu->ir_table->base[index];
 
-	if (!irq_2_iommu[irq].sub_handle) {
-		for (i = 0; i < (1 << irq_2_iommu[irq].irte_mask); i++)
+	if (!irq_iommu->sub_handle) {
+		for (i = 0; i < (1 << irq_iommu->irte_mask); i++)
 			set_64bit((unsigned long *)irte, 0);
-		qi_flush_iec(iommu, index, irq_2_iommu[irq].irte_mask);
+		qi_flush_iec(iommu, index, irq_iommu->irte_mask);
 	}
 
-	irq_2_iommu[irq].iommu = NULL;
-	irq_2_iommu[irq].irte_index = 0;
-	irq_2_iommu[irq].sub_handle = 0;
-	irq_2_iommu[irq].irte_mask = 0;
+	irq_iommu->iommu = NULL;
+	irq_iommu->irte_index = 0;
+	irq_iommu->sub_handle = 0;
+	irq_iommu->irte_mask = 0;
 
 	spin_unlock(&irq_2_ir_lock);
 
diff --git a/drivers/pcmcia/at91_cf.c b/drivers/pcmcia/at91_cf.c
index a0ffb8e..9e1140f 100644
--- a/drivers/pcmcia/at91_cf.c
+++ b/drivers/pcmcia/at91_cf.c
@@ -273,7 +273,7 @@ static int __init at91_cf_probe(struct platform_device *pdev)
 			goto fail0d;
 		cf->socket.pci_irq = board->irq_pin;
 	} else
-		cf->socket.pci_irq = NR_IRQS + 1;
+		cf->socket.pci_irq = nr_irqs + 1;
 
 	/* pcmcia layer only remaps "real" memory not iospace */
 	cf->socket.io_offset = (unsigned long)
diff --git a/drivers/pcmcia/hd64465_ss.c b/drivers/pcmcia/hd64465_ss.c
index fb2bc1f..6626b34 100644
--- a/drivers/pcmcia/hd64465_ss.c
+++ b/drivers/pcmcia/hd64465_ss.c
@@ -234,15 +234,18 @@ static struct hw_interrupt_type hd64465_ss_irq_type = {
  */
 static void hs_map_irq(hs_socket_t *sp, unsigned int irq)
 {
+	struct irq_desc *desc;
+
     	DPRINTK("hs_map_irq(sock=%d irq=%d)\n", sp->number, irq);
 	
 	if (irq >= HS_NUM_MAPPED_IRQS)
 	    return;
 
+	desc = irq_to_desc(irq);
     	hs_mapped_irq[irq].sock = sp;
 	/* insert ourselves as the irq controller */
-	hs_mapped_irq[irq].old_handler = irq_desc[irq].chip;
-	irq_desc[irq].chip = &hd64465_ss_irq_type;
+	hs_mapped_irq[irq].old_handler = desc->chip;
+	desc->chip = &hd64465_ss_irq_type;
 }
 
 
@@ -251,13 +254,16 @@ static void hs_map_irq(hs_socket_t *sp, unsigned int irq)
  */
 static void hs_unmap_irq(hs_socket_t *sp, unsigned int irq)
 {
+	struct irq_desc *desc;
+
     	DPRINTK("hs_unmap_irq(sock=%d irq=%d)\n", sp->number, irq);
 	
 	if (irq >= HS_NUM_MAPPED_IRQS)
 	    return;
 		
+	desc = irq_to_desc(irq);
 	/* restore the original irq controller */
-	irq_desc[irq].chip = hs_mapped_irq[irq].old_handler;
+	desc->chip = hs_mapped_irq[irq].old_handler;
 }
 
 /*============================================================*/
diff --git a/drivers/pcmcia/vrc4171_card.c b/drivers/pcmcia/vrc4171_card.c
index eee2f1c..b2c4124 100644
--- a/drivers/pcmcia/vrc4171_card.c
+++ b/drivers/pcmcia/vrc4171_card.c
@@ -639,7 +639,7 @@ static int __devinit vrc4171_card_setup(char *options)
 		int irq;
 		options += 4;
 		irq = simple_strtoul(options, &options, 0);
-		if (irq >= 0 && irq < NR_IRQS)
+		if (irq >= 0 && irq < nr_irqs)
 			vrc4171_irq = irq;
 
 		if (*options != ',')
diff --git a/drivers/rtc/rtc-vr41xx.c b/drivers/rtc/rtc-vr41xx.c
index 884b635..834dcc6 100644
--- a/drivers/rtc/rtc-vr41xx.c
+++ b/drivers/rtc/rtc-vr41xx.c
@@ -360,7 +360,7 @@ static int __devinit rtc_probe(struct platform_device *pdev)
 	spin_unlock_irq(&rtc_lock);
 
 	aie_irq = platform_get_irq(pdev, 0);
-	if (aie_irq < 0 || aie_irq >= NR_IRQS) {
+	if (aie_irq < 0 || aie_irq >= nr_irqs) {
 		retval = -EBUSY;
 		goto err_device_unregister;
 	}
@@ -371,7 +371,7 @@ static int __devinit rtc_probe(struct platform_device *pdev)
 		goto err_device_unregister;
 
 	pie_irq = platform_get_irq(pdev, 1);
-	if (pie_irq < 0 || pie_irq >= NR_IRQS)
+	if (pie_irq < 0 || pie_irq >= nr_irqs)
 		goto err_free_irq;
 
 	retval = request_irq(pie_irq, rtclong1_interrupt, IRQF_DISABLED,
diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index b5a868d..1e5478a 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -337,7 +337,7 @@ CMD_INC_RESID(struct scsi_cmnd *cmd, int inc)
 #else
 #define IRQ_MIN 9
 #if defined(__PPC)
-#define IRQ_MAX (NR_IRQS-1)
+#define IRQ_MAX (nr_irqs-1)
 #else
 #define IRQ_MAX 12
 #endif
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 94a720e..7f41e49 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2109,7 +2109,7 @@ struct scsi_qla_host;
 
 struct qla_msix_entry {
 	int have_irq;
-	uint16_t msix_vector;
+	uint32_t msix_vector;
 	uint16_t msix_entry;
 };
 
diff --git a/drivers/serial/68328serial.c b/drivers/serial/68328serial.c
index 381b12a..d935b2d 100644
--- a/drivers/serial/68328serial.c
+++ b/drivers/serial/68328serial.c
@@ -66,7 +66,6 @@
 #endif
 
 static struct m68k_serial m68k_soft[NR_PORTS];
-struct m68k_serial *IRQ_ports[NR_IRQS];
 
 static unsigned int uart_irqs[NR_PORTS] = UART_IRQ_DEFNS;
 
@@ -375,15 +374,11 @@ clear_and_return:
  */
 irqreturn_t rs_interrupt(int irq, void *dev_id)
 {
-	struct m68k_serial * info;
+	struct m68k_serial *info = dev_id;
 	m68328_uart *uart;
 	unsigned short rx;
 	unsigned short tx;
 
-	info = IRQ_ports[irq];
-	if(!info)
-	    return IRQ_NONE;
-
 	uart = &uart_addr[info->line];
 	rx = uart->urx.w;
 
@@ -1383,8 +1378,6 @@ rs68328_init(void)
 		   info->port, info->irq);
 	    printk(" is a builtin MC68328 UART\n");
 	    
-	    IRQ_ports[info->irq] = info;	/* waste of space */
-
 #ifdef CONFIG_M68VZ328
 		if (i > 0 )
 			PJSEL &= 0xCF;  /* PSW enable second port output */
@@ -1393,7 +1386,7 @@ rs68328_init(void)
 	    if (request_irq(uart_irqs[i],
 			    rs_interrupt,
 			    IRQF_DISABLED,
-			    "M68328_UART", NULL))
+			    "M68328_UART", info))
                 panic("Unable to attach 68328 serial interrupt\n");
 	}
 	local_irq_restore(flags);
diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 9ccc563..356c2a2 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -145,11 +145,15 @@ struct uart_8250_port {
 };
 
 struct irq_info {
-	spinlock_t		lock;
+	struct			hlist_node node;
+	int			irq;
+	spinlock_t		lock;	/* Protects list not the hash */
 	struct list_head	*head;
 };
 
-static struct irq_info irq_lists[NR_IRQS];
+#define NR_IRQ_HASH		32	/* Can be adjusted later */
+static struct hlist_head irq_lists[NR_IRQ_HASH];
+static DEFINE_MUTEX(hash_mutex);	/* Used to walk the hash */
 
 /*
  * Here we define the default xmit fifo size used for each type of UART.
@@ -1535,15 +1539,43 @@ static void serial_do_unlink(struct irq_info *i, struct uart_8250_port *up)
 		BUG_ON(i->head != &up->list);
 		i->head = NULL;
 	}
-
 	spin_unlock_irq(&i->lock);
+	/* List empty so throw away the hash node */
+	if (i->head == NULL) {
+		hlist_del(&i->node);
+		kfree(i);
+	}
 }
 
 static int serial_link_irq_chain(struct uart_8250_port *up)
 {
-	struct irq_info *i = irq_lists + up->port.irq;
+	struct hlist_head *h;
+	struct hlist_node *n;
+	struct irq_info *i;
 	int ret, irq_flags = up->port.flags & UPF_SHARE_IRQ ? IRQF_SHARED : 0;
 
+	mutex_lock(&hash_mutex);
+
+	h = &irq_lists[up->port.irq % NR_IRQ_HASH];
+
+	hlist_for_each(n, h) {
+		i = hlist_entry(n, struct irq_info, node);
+		if (i->irq == up->port.irq)
+			break;
+	}
+
+	if (n == NULL) {
+		i = kzalloc(sizeof(struct irq_info), GFP_KERNEL);
+		if (i == NULL) {
+			mutex_unlock(&hash_mutex);
+			return -ENOMEM;
+		}
+		spin_lock_init(&i->lock);
+		i->irq = up->port.irq;
+		hlist_add_head(&i->node, h);
+	}
+	mutex_unlock(&hash_mutex);
+
 	spin_lock_irq(&i->lock);
 
 	if (i->head) {
@@ -1567,14 +1599,28 @@ static int serial_link_irq_chain(struct uart_8250_port *up)
 
 static void serial_unlink_irq_chain(struct uart_8250_port *up)
 {
-	struct irq_info *i = irq_lists + up->port.irq;
+	struct irq_info *i;
+	struct hlist_node *n;
+	struct hlist_head *h;
 
+	mutex_lock(&hash_mutex);
+
+	h = &irq_lists[up->port.irq % NR_IRQ_HASH];
+
+	hlist_for_each(n, h) {
+		i = hlist_entry(n, struct irq_info, node);
+		if (i->irq == up->port.irq)
+			break;
+	}
+
+	BUG_ON(n == NULL);
 	BUG_ON(i->head == NULL);
 
 	if (list_empty(i->head))
 		free_irq(up->port.irq, i);
 
 	serial_do_unlink(i, up);
+	mutex_unlock(&hash_mutex);
 }
 
 /* Base timer interval for polling */
@@ -2428,7 +2474,7 @@ static void serial8250_config_port(struct uart_port *port, int flags)
 static int
 serial8250_verify_port(struct uart_port *port, struct serial_struct *ser)
 {
-	if (ser->irq >= NR_IRQS || ser->irq < 0 ||
+	if (ser->irq >= nr_irqs || ser->irq < 0 ||
 	    ser->baud_base < 9600 || ser->type < PORT_UNKNOWN ||
 	    ser->type >= ARRAY_SIZE(uart_config) || ser->type == PORT_CIRRUS ||
 	    ser->type == PORT_STARTECH)
@@ -2950,7 +2996,7 @@ EXPORT_SYMBOL(serial8250_unregister_port);
 
 static int __init serial8250_init(void)
 {
-	int ret, i;
+	int ret;
 
 	if (nr_uarts > UART_NR)
 		nr_uarts = UART_NR;
@@ -2959,9 +3005,6 @@ static int __init serial8250_init(void)
 		"%d ports, IRQ sharing %sabled\n", nr_uarts,
 		share_irqs ? "en" : "dis");
 
-	for (i = 0; i < NR_IRQS; i++)
-		spin_lock_init(&irq_lists[i].lock);
-
 	ret = uart_register_driver(&serial8250_reg);
 	if (ret)
 		goto out;
@@ -2984,11 +3027,11 @@ static int __init serial8250_init(void)
 		goto out;
 
 	platform_device_del(serial8250_isa_devs);
- put_dev:
+put_dev:
 	platform_device_put(serial8250_isa_devs);
- unreg_uart_drv:
+unreg_uart_drv:
 	uart_unregister_driver(&serial8250_reg);
- out:
+out:
 	return ret;
 }
 
diff --git a/drivers/serial/amba-pl010.c b/drivers/serial/amba-pl010.c
index 90b56c2..7156268 100644
--- a/drivers/serial/amba-pl010.c
+++ b/drivers/serial/amba-pl010.c
@@ -512,7 +512,7 @@ static int pl010_verify_port(struct uart_port *port, struct serial_struct *ser)
 	int ret = 0;
 	if (ser->type != PORT_UNKNOWN && ser->type != PORT_AMBA)
 		ret = -EINVAL;
-	if (ser->irq < 0 || ser->irq >= NR_IRQS)
+	if (ser->irq < 0 || ser->irq >= nr_irqs)
 		ret = -EINVAL;
 	if (ser->baud_base < 9600)
 		ret = -EINVAL;
diff --git a/drivers/serial/amba-pl011.c b/drivers/serial/amba-pl011.c
index 9d08f27..b718004 100644
--- a/drivers/serial/amba-pl011.c
+++ b/drivers/serial/amba-pl011.c
@@ -572,7 +572,7 @@ static int pl010_verify_port(struct uart_port *port, struct serial_struct *ser)
 	int ret = 0;
 	if (ser->type != PORT_UNKNOWN && ser->type != PORT_AMBA)
 		ret = -EINVAL;
-	if (ser->irq < 0 || ser->irq >= NR_IRQS)
+	if (ser->irq < 0 || ser->irq >= nr_irqs)
 		ret = -EINVAL;
 	if (ser->baud_base < 9600)
 		ret = -EINVAL;
diff --git a/drivers/serial/cpm_uart/cpm_uart_core.c b/drivers/serial/cpm_uart/cpm_uart_core.c
index 25efca5..e54574c 100644
--- a/drivers/serial/cpm_uart/cpm_uart_core.c
+++ b/drivers/serial/cpm_uart/cpm_uart_core.c
@@ -623,7 +623,7 @@ static int cpm_uart_verify_port(struct uart_port *port,
 
 	if (ser->type != PORT_UNKNOWN && ser->type != PORT_CPM)
 		ret = -EINVAL;
-	if (ser->irq < 0 || ser->irq >= NR_IRQS)
+	if (ser->irq < 0 || ser->irq >= nr_irqs)
 		ret = -EINVAL;
 	if (ser->baud_base < 9600)
 		ret = -EINVAL;
diff --git a/drivers/serial/m32r_sio.c b/drivers/serial/m32r_sio.c
index 23d0305..611c97a 100644
--- a/drivers/serial/m32r_sio.c
+++ b/drivers/serial/m32r_sio.c
@@ -922,7 +922,7 @@ static void m32r_sio_config_port(struct uart_port *port, int flags)
 static int
 m32r_sio_verify_port(struct uart_port *port, struct serial_struct *ser)
 {
-	if (ser->irq >= NR_IRQS || ser->irq < 0 ||
+	if (ser->irq >= nr_irqs || ser->irq < 0 ||
 	    ser->baud_base < 9600 || ser->type < PORT_UNKNOWN ||
 	    ser->type >= ARRAY_SIZE(uart_config))
 		return -EINVAL;
@@ -1162,7 +1162,7 @@ static int __init m32r_sio_init(void)
 
 	printk(KERN_INFO "Serial: M32R SIO driver\n");
 
-	for (i = 0; i < NR_IRQS; i++)
+	for (i = 0; i < nr_irqs; i++)
 		spin_lock_init(&irq_lists[i].lock);
 
 	ret = uart_register_driver(&m32r_sio_reg);
diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index f977c98..effd0bd 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -741,7 +741,7 @@ static int uart_set_info(struct uart_state *state,
 	if (port->ops->verify_port)
 		retval = port->ops->verify_port(port, &new_serial);
 
-	if ((new_serial.irq >= NR_IRQS) || (new_serial.irq < 0) ||
+	if ((new_serial.irq >= nr_irqs) || (new_serial.irq < 0) ||
 	    (new_serial.baud_base < 9600))
 		retval = -EINVAL;
 
diff --git a/drivers/serial/serial_lh7a40x.c b/drivers/serial/serial_lh7a40x.c
index cb49a5a..61dc8b3 100644
--- a/drivers/serial/serial_lh7a40x.c
+++ b/drivers/serial/serial_lh7a40x.c
@@ -460,7 +460,7 @@ static int lh7a40xuart_verify_port (struct uart_port* port,
 
 	if (ser->type != PORT_UNKNOWN && ser->type != PORT_LH7A40X)
 		ret = -EINVAL;
-	if (ser->irq < 0 || ser->irq >= NR_IRQS)
+	if (ser->irq < 0 || ser->irq >= nr_irqs)
 		ret = -EINVAL;
 	if (ser->baud_base < 9600) /* *** FIXME: is this true? */
 		ret = -EINVAL;
diff --git a/drivers/serial/sh-sci.c b/drivers/serial/sh-sci.c
index 3df2aae..667b4b8 100644
--- a/drivers/serial/sh-sci.c
+++ b/drivers/serial/sh-sci.c
@@ -1157,7 +1157,7 @@ static int sci_verify_port(struct uart_port *port, struct serial_struct *ser)
 {
 	struct sci_port *s = &sci_ports[port->line];
 
-	if (ser->irq != s->irqs[SCIx_TXI_IRQ] || ser->irq > NR_IRQS)
+	if (ser->irq != s->irqs[SCIx_TXI_IRQ] || ser->irq > nr_irqs)
 		return -EINVAL;
 	if (ser->baud_base < 2400)
 		/* No paper tape reader for Mitch.. */
diff --git a/drivers/serial/ucc_uart.c b/drivers/serial/ucc_uart.c
index 5c5d18d..503f0b9 100644
--- a/drivers/serial/ucc_uart.c
+++ b/drivers/serial/ucc_uart.c
@@ -1066,7 +1066,7 @@ static int qe_uart_verify_port(struct uart_port *port,
 	if (ser->type != PORT_UNKNOWN && ser->type != PORT_CPM)
 		return -EINVAL;
 
-	if (ser->irq < 0 || ser->irq >= NR_IRQS)
+	if (ser->irq < 0 || ser->irq >= nr_irqs)
 		return -EINVAL;
 
 	if (ser->baud_base < 9600)
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index c3290bc..e6d47e8 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -125,7 +125,7 @@ static void bind_evtchn_to_cpu(unsigned int chn, unsigned int cpu)
 
 	BUG_ON(irq == -1);
 #ifdef CONFIG_SMP
-	irq_desc[irq].affinity = cpumask_of_cpu(cpu);
+	irq_to_desc(irq)->affinity = cpumask_of_cpu(cpu);
 #endif
 
 	__clear_bit(chn, cpu_evtchn_mask[cpu_evtchn[chn]]);
@@ -139,8 +139,12 @@ static void init_evtchn_cpu_bindings(void)
 #ifdef CONFIG_SMP
 	int i;
 	/* By default all event channels notify CPU#0. */
-	for (i = 0; i < NR_IRQS; i++)
-		irq_desc[i].affinity = cpumask_of_cpu(0);
+	for (i = 0; i < nr_irqs; i++) {
+		struct irq_desc *desc = irq_to_desc(i);
+		if (!desc)
+			continue;
+		desc->affinity = cpumask_of_cpu(0);
+	}
 #endif
 
 	memset(cpu_evtchn, 0, sizeof(cpu_evtchn));
@@ -229,12 +233,12 @@ static int find_unbound_irq(void)
 	int irq;
 
 	/* Only allocate from dynirq range */
-	for (irq = 0; irq < NR_IRQS; irq++)
+	for (irq = 0; irq < nr_irqs; irq++)
 		if (irq_bindcount[irq] == 0)
 			break;
 
-	if (irq == NR_IRQS)
-		panic("No available IRQ to bind to: increase NR_IRQS!\n");
+	if (irq == nr_irqs)
+		panic("No available IRQ to bind to: increase nr_irqs!\n");
 
 	return irq;
 }
@@ -790,7 +794,7 @@ void xen_irq_resume(void)
 		mask_evtchn(evtchn);
 
 	/* No IRQ <-> event-channel mappings. */
-	for (irq = 0; irq < NR_IRQS; irq++)
+	for (irq = 0; irq < nr_irqs; irq++)
 		irq_info[irq].evtchn = 0; /* zap event-channel binding */
 
 	for (evtchn = 0; evtchn < NR_EVENT_CHANNELS; evtchn++)
@@ -822,7 +826,7 @@ void __init xen_init_IRQ(void)
 		mask_evtchn(i);
 
 	/* Dynamic IRQ space is currently unbound. Zero the refcnts. */
-	for (i = 0; i < NR_IRQS; i++)
+	for (i = 0; i < nr_irqs; i++)
 		irq_bindcount[i] = 0;
 
 	irq_ctx_init(smp_processor_id());
diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index 29e20c6..10f6eae 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -30,6 +30,7 @@
 #include <linux/mm.h>
 #include <linux/mmzone.h>
 #include <linux/pagemap.h>
+#include <linux/irq.h>
 #include <linux/interrupt.h>
 #include <linux/swap.h>
 #include <linux/slab.h>
@@ -502,17 +503,16 @@ static const struct file_operations proc_vmalloc_operations = {
 
 static int show_stat(struct seq_file *p, void *v)
 {
-	int i;
+	int i, j;
 	unsigned long jif;
 	cputime64_t user, nice, system, idle, iowait, irq, softirq, steal;
 	cputime64_t guest;
 	u64 sum = 0;
 	struct timespec boottime;
-	unsigned int *per_irq_sum;
-
-	per_irq_sum = kzalloc(sizeof(unsigned int)*NR_IRQS, GFP_KERNEL);
-	if (!per_irq_sum)
-		return -ENOMEM;
+	unsigned int per_irq_sum;
+#ifdef CONFIG_GENERIC_HARDIRQS
+	struct irq_desc *desc;
+#endif
 
 	user = nice = system = idle = iowait =
 		irq = softirq = steal = cputime64_zero;
@@ -521,8 +521,6 @@ static int show_stat(struct seq_file *p, void *v)
 	jif = boottime.tv_sec;
 
 	for_each_possible_cpu(i) {
-		int j;
-
 		user = cputime64_add(user, kstat_cpu(i).cpustat.user);
 		nice = cputime64_add(nice, kstat_cpu(i).cpustat.nice);
 		system = cputime64_add(system, kstat_cpu(i).cpustat.system);
@@ -532,10 +530,12 @@ static int show_stat(struct seq_file *p, void *v)
 		softirq = cputime64_add(softirq, kstat_cpu(i).cpustat.softirq);
 		steal = cputime64_add(steal, kstat_cpu(i).cpustat.steal);
 		guest = cputime64_add(guest, kstat_cpu(i).cpustat.guest);
-		for (j = 0; j < NR_IRQS; j++) {
-			unsigned int temp = kstat_cpu(i).irqs[j];
+		for_each_irq_desc(j, desc)
+		{
+			unsigned int temp;
+
+			temp = kstat_irqs_cpu(j, i);
 			sum += temp;
-			per_irq_sum[j] += temp;
 		}
 		sum += arch_irq_stat_cpu(i);
 	}
@@ -578,8 +578,23 @@ static int show_stat(struct seq_file *p, void *v)
 	}
 	seq_printf(p, "intr %llu", (unsigned long long)sum);
 
-	for (i = 0; i < NR_IRQS; i++)
-		seq_printf(p, " %u", per_irq_sum[i]);
+	/* sum again ? it could be updated? */
+	for_each_irq_desc(j, desc)
+	{
+		per_irq_sum = 0;
+		for_each_possible_cpu(i) {
+			unsigned int temp;
+
+			temp = kstat_irqs_cpu(j, i);
+			per_irq_sum += temp;
+		}
+
+#ifdef CONFIG_HAVE_SPARSE_IRQ
+		seq_printf(p, " %#x:%u", j, per_irq_sum);
+#else
+		seq_printf(p, " %u", per_irq_sum);
+#endif
+	}
 
 	seq_printf(p,
 		"\nctxt %llu\n"
@@ -593,7 +608,6 @@ static int show_stat(struct seq_file *p, void *v)
 		nr_running(),
 		nr_iowait());
 
-	kfree(per_irq_sum);
 	return 0;
 }
 
@@ -632,15 +646,36 @@ static const struct file_operations proc_stat_operations = {
  */
 static void *int_seq_start(struct seq_file *f, loff_t *pos)
 {
-	return (*pos <= NR_IRQS) ? pos : NULL;
+#ifdef CONFIG_HAVE_SPARSE_IRQ
+	struct irq_desc *desc;
+	int irq;
+	int count = *pos;
+
+	for_each_irq_desc(irq, desc) {
+		if (count-- == 0)
+			return desc;
+	}
+
+	return NULL;
+#else
+	return (*pos <= nr_irqs) ? pos : NULL;
+#endif
 }
 
+
 static void *int_seq_next(struct seq_file *f, void *v, loff_t *pos)
 {
+#ifdef CONFIG_HAVE_SPARSE_IRQ
+	struct irq_desc *desc;
+
+	desc = ((struct irq_desc *)v)->next;
 	(*pos)++;
-	if (*pos > NR_IRQS)
-		return NULL;
-	return pos;
+
+	return desc;
+#else
+	(*pos)++;
+	return (*pos <= nr_irqs) ? pos : NULL;
+#endif
 }
 
 static void int_seq_stop(struct seq_file *f, void *v)
@@ -648,7 +683,6 @@ static void int_seq_stop(struct seq_file *f, void *v)
 	/* Nothing to do */
 }
 
-
 static const struct seq_operations int_seq_ops = {
 	.start = int_seq_start,
 	.next  = int_seq_next,
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 7440a0d..c68eda9 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -210,6 +210,19 @@
  * All archs are supposed to use RO_DATA() */
 #define RODATA RO_DATA(4096)
 
+#define DYN_ARRAY_INIT(align)							\
+	. = ALIGN((align));						\
+	.dyn_array.init : AT(ADDR(.dyn_array.init) - LOAD_OFFSET) {	\
+		VMLINUX_SYMBOL(__dyn_array_start) = .;			\
+		*(.dyn_array.init)					\
+		VMLINUX_SYMBOL(__dyn_array_end) = .;			\
+	}								\
+	. = ALIGN((align));						\
+	.per_cpu_dyn_array.init : AT(ADDR(.per_cpu_dyn_array.init) - LOAD_OFFSET) {	\
+		VMLINUX_SYMBOL(__per_cpu_dyn_array_start) = .;		\
+		*(.per_cpu_dyn_array.init)				\
+		VMLINUX_SYMBOL(__per_cpu_dyn_array_end) = .;		\
+	}
 #define SECURITY_INIT							\
 	.security_initcall.init : AT(ADDR(.security_initcall.init) - LOAD_OFFSET) { \
 		VMLINUX_SYMBOL(__security_initcall_start) = .;		\
diff --git a/include/asm-x86/apic.h b/include/asm-x86/apic.h
index d76a083..ef1d72d 100644
--- a/include/asm-x86/apic.h
+++ b/include/asm-x86/apic.h
@@ -40,8 +40,6 @@ extern void generic_apic_probe(void);
 extern unsigned int apic_verbosity;
 extern int local_apic_timer_c2_ok;
 
-extern int ioapic_force;
-
 extern int disable_apic;
 /*
  * Basic functions accessing APICs.
@@ -100,6 +98,20 @@ extern void check_x2apic(void);
 extern void enable_x2apic(void);
 extern void enable_IR_x2apic(void);
 extern void x2apic_icr_write(u32 low, u32 id);
+static inline int x2apic_enabled(void)
+{
+	int msr, msr2;
+
+	if (!cpu_has_x2apic)
+		return 0;
+
+	rdmsr(MSR_IA32_APICBASE, msr, msr2);
+	if (msr & X2APIC_ENABLE)
+		return 1;
+	return 0;
+}
+#else
+#define x2apic_enabled()	0
 #endif
 
 struct apic_ops {
diff --git a/include/asm-x86/bigsmp/apic.h b/include/asm-x86/bigsmp/apic.h
index 0a9cd7c..1d9543b 100644
--- a/include/asm-x86/bigsmp/apic.h
+++ b/include/asm-x86/bigsmp/apic.h
@@ -9,22 +9,17 @@ static inline int apic_id_registered(void)
 	return (1);
 }
 
-/* Round robin the irqs amoung the online cpus */
 static inline cpumask_t target_cpus(void)
 {
-	static unsigned long cpu = NR_CPUS;
-	do {
-		if (cpu >= NR_CPUS)
-			cpu = first_cpu(cpu_online_map);
-		else
-			cpu = next_cpu(cpu, cpu_online_map);
-	} while (cpu >= NR_CPUS);
-	return cpumask_of_cpu(cpu);
+#ifdef CONFIG_SMP
+        return cpu_online_map;
+#else
+        return cpumask_of_cpu(0);
+#endif
 }
 
 #undef APIC_DEST_LOGICAL
 #define APIC_DEST_LOGICAL	0
-#define TARGET_CPUS		(target_cpus())
 #define APIC_DFR_VALUE		(APIC_DFR_FLAT)
 #define INT_DELIVERY_MODE	(dest_Fixed)
 #define INT_DEST_MODE		(0)    /* phys delivery to target proc */
diff --git a/include/asm-x86/efi.h b/include/asm-x86/efi.h
index ed2de22..313438e 100644
--- a/include/asm-x86/efi.h
+++ b/include/asm-x86/efi.h
@@ -94,4 +94,17 @@ extern void efi_reserve_early(void);
 extern void efi_call_phys_prelog(void);
 extern void efi_call_phys_epilog(void);
 
+#ifndef CONFIG_EFI
+/*
+ * IF EFI is not configured, have the EFI calls return -ENOSYS.
+ */
+#define efi_call0(_f)					(-ENOSYS)
+#define efi_call1(_f, _a1)				(-ENOSYS)
+#define efi_call2(_f, _a1, _a2)				(-ENOSYS)
+#define efi_call3(_f, _a1, _a2, _a3)			(-ENOSYS)
+#define efi_call4(_f, _a1, _a2, _a3, _a4)		(-ENOSYS)
+#define efi_call5(_f, _a1, _a2, _a3, _a4, _a5)		(-ENOSYS)
+#define efi_call6(_f, _a1, _a2, _a3, _a4, _a5, _a6)	(-ENOSYS)
+#endif /* CONFIG_EFI */
+
 #endif /* ASM_X86__EFI_H */
diff --git a/include/asm-x86/es7000/apic.h b/include/asm-x86/es7000/apic.h
index bd2c44d..750afad 100644
--- a/include/asm-x86/es7000/apic.h
+++ b/include/asm-x86/es7000/apic.h
@@ -17,7 +17,6 @@ static inline cpumask_t target_cpus(void)
 	return cpumask_of_cpu(smp_processor_id());
 #endif
 }
-#define TARGET_CPUS	(target_cpus())
 
 #if defined CONFIG_ES7000_CLUSTERED_APIC
 #define APIC_DFR_VALUE		(APIC_DFR_CLUSTER)
@@ -81,7 +80,7 @@ static inline void setup_apic_routing(void)
 	int apic = per_cpu(x86_bios_cpu_apicid, smp_processor_id());
 	printk("Enabling APIC mode:  %s.  Using %d I/O APICs, target cpus %lx\n",
 		(apic_version[apic] == 0x14) ?
-		"Physical Cluster" : "Logical Cluster", nr_ioapics, cpus_addr(TARGET_CPUS)[0]);
+		"Physical Cluster" : "Logical Cluster", nr_ioapics, cpus_addr(target_cpus())[0]);
 }
 
 static inline int multi_timer_check(int apic, int irq)
diff --git a/include/asm-x86/genapic_32.h b/include/asm-x86/genapic_32.h
index 34280f0..6fe4f81 100644
--- a/include/asm-x86/genapic_32.h
+++ b/include/asm-x86/genapic_32.h
@@ -57,6 +57,7 @@ struct genapic {
 	unsigned (*get_apic_id)(unsigned long x);
 	unsigned long apic_id_mask;
 	unsigned int (*cpu_mask_to_apicid)(cpumask_t cpumask);
+	cpumask_t (*vector_allocation_domain)(int cpu);
 
 #ifdef CONFIG_SMP
 	/* ipi */
@@ -104,6 +105,7 @@ struct genapic {
 	APICFUNC(get_apic_id)				\
 	.apic_id_mask = APIC_ID_MASK,			\
 	APICFUNC(cpu_mask_to_apicid)			\
+	APICFUNC(vector_allocation_domain)			\
 	APICFUNC(acpi_madt_oem_check)			\
 	IPIFUNC(send_IPI_mask)				\
 	IPIFUNC(send_IPI_allbutself)			\
diff --git a/include/asm-x86/hpet.h b/include/asm-x86/hpet.h
index cbbbb6d..58b273f 100644
--- a/include/asm-x86/hpet.h
+++ b/include/asm-x86/hpet.h
@@ -1,6 +1,8 @@
 #ifndef ASM_X86__HPET_H
 #define ASM_X86__HPET_H
 
+#include <linux/msi.h>
+
 #ifdef CONFIG_HPET_TIMER
 
 #define HPET_MMAP_SIZE		1024
@@ -10,6 +12,11 @@
 #define HPET_CFG		0x010
 #define HPET_STATUS		0x020
 #define HPET_COUNTER		0x0f0
+
+#define HPET_Tn_CFG(n)		(0x100 + 0x20 * n)
+#define HPET_Tn_CMP(n)		(0x108 + 0x20 * n)
+#define HPET_Tn_ROUTE(n)	(0x110 + 0x20 * n)
+
 #define HPET_T0_CFG		0x100
 #define HPET_T0_CMP		0x108
 #define HPET_T0_ROUTE		0x110
@@ -65,6 +72,20 @@ extern void hpet_disable(void);
 extern unsigned long hpet_readl(unsigned long a);
 extern void force_hpet_resume(void);
 
+extern void hpet_msi_unmask(unsigned int irq);
+extern void hpet_msi_mask(unsigned int irq);
+extern void hpet_msi_write(unsigned int irq, struct msi_msg *msg);
+extern void hpet_msi_read(unsigned int irq, struct msi_msg *msg);
+
+#ifdef CONFIG_PCI_MSI
+extern int arch_setup_hpet_msi(unsigned int irq);
+#else
+static inline int arch_setup_hpet_msi(unsigned int irq)
+{
+	return -EINVAL;
+}
+#endif
+
 #ifdef CONFIG_HPET_EMULATE_RTC
 
 #include <linux/interrupt.h>
diff --git a/include/asm-x86/hw_irq.h b/include/asm-x86/hw_irq.h
index 50f6e03..749d042 100644
--- a/include/asm-x86/hw_irq.h
+++ b/include/asm-x86/hw_irq.h
@@ -96,13 +96,8 @@ extern asmlinkage void qic_call_function_interrupt(void);
 
 /* SMP */
 extern void smp_apic_timer_interrupt(struct pt_regs *);
-#ifdef CONFIG_X86_32
 extern void smp_spurious_interrupt(struct pt_regs *);
 extern void smp_error_interrupt(struct pt_regs *);
-#else
-extern asmlinkage void smp_spurious_interrupt(void);
-extern asmlinkage void smp_error_interrupt(void);
-#endif
 #ifdef CONFIG_X86_SMP
 extern void smp_reschedule_interrupt(struct pt_regs *);
 extern void smp_call_function_interrupt(struct pt_regs *);
@@ -115,13 +110,13 @@ extern asmlinkage void smp_invalidate_interrupt(struct pt_regs *);
 #endif
 
 #ifdef CONFIG_X86_32
-extern void (*const interrupt[NR_IRQS])(void);
-#else
+extern void (*const interrupt[NR_VECTORS])(void);
+#endif
+
 typedef int vector_irq_t[NR_VECTORS];
 DECLARE_PER_CPU(vector_irq_t, vector_irq);
-#endif
 
-#if defined(CONFIG_X86_IO_APIC) && defined(CONFIG_X86_64)
+#ifdef CONFIG_X86_IO_APIC
 extern void lock_vector_lock(void);
 extern void unlock_vector_lock(void);
 extern void __setup_vector_irq(int cpu);
diff --git a/include/asm-x86/io_apic.h b/include/asm-x86/io_apic.h
index 8ec68a5..d35cbd7 100644
--- a/include/asm-x86/io_apic.h
+++ b/include/asm-x86/io_apic.h
@@ -4,6 +4,7 @@
 #include <linux/types.h>
 #include <asm/mpspec.h>
 #include <asm/apicdef.h>
+#include <asm/irq_vectors.h>
 
 /*
  * Intel IO-APIC support for SMP and UP systems.
@@ -87,24 +88,8 @@ struct IO_APIC_route_entry {
 		mask		:  1,	/* 0: enabled, 1: disabled */
 		__reserved_2	: 15;
 
-#ifdef CONFIG_X86_32
-	union {
-		struct {
-			__u32	__reserved_1	: 24,
-				physical_dest	:  4,
-				__reserved_2	:  4;
-		} physical;
-
-		struct {
-			__u32	__reserved_1	: 24,
-				logical_dest	:  8;
-		} logical;
-	} dest;
-#else
 	__u32	__reserved_3	: 24,
 		dest		:  8;
-#endif
-
 } __attribute__ ((packed));
 
 struct IR_IO_APIC_route_entry {
@@ -203,10 +188,17 @@ extern void restore_IO_APIC_setup(void);
 extern void reinit_intr_remapped_IO_APIC(int);
 #endif
 
+extern int probe_nr_irqs(void);
+
 #else  /* !CONFIG_X86_IO_APIC */
 #define io_apic_assign_pci_irqs 0
 static const int timer_through_8259 = 0;
 static inline void ioapic_init_mappings(void) { }
+
+static inline int probe_nr_irqs(void)
+{
+	return NR_IRQS;
+}
 #endif
 
 #endif /* ASM_X86__IO_APIC_H */
diff --git a/include/asm-x86/irq_vectors.h b/include/asm-x86/irq_vectors.h
index c5d2d76..a8d065d 100644
--- a/include/asm-x86/irq_vectors.h
+++ b/include/asm-x86/irq_vectors.h
@@ -19,19 +19,14 @@
 
 /*
  * Reserve the lowest usable priority level 0x20 - 0x2f for triggering
- * cleanup after irq migration on 64 bit.
+ * cleanup after irq migration.
  */
 #define IRQ_MOVE_CLEANUP_VECTOR	FIRST_EXTERNAL_VECTOR
 
 /*
- * Vectors 0x20-0x2f are used for ISA interrupts on 32 bit.
- * Vectors 0x30-0x3f are used for ISA interrupts on 64 bit.
+ * Vectors 0x30-0x3f are used for ISA interrupts.
  */
-#ifdef CONFIG_X86_32
-#define IRQ0_VECTOR		(FIRST_EXTERNAL_VECTOR)
-#else
 #define IRQ0_VECTOR		(FIRST_EXTERNAL_VECTOR + 0x10)
-#endif
 #define IRQ1_VECTOR		(IRQ0_VECTOR + 1)
 #define IRQ2_VECTOR		(IRQ0_VECTOR + 2)
 #define IRQ3_VECTOR		(IRQ0_VECTOR + 3)
@@ -96,11 +91,7 @@
  * start at 0x31(0x41) to spread out vectors evenly between priority
  * levels. (0x80 is the syscall vector)
  */
-#ifdef CONFIG_X86_32
-# define FIRST_DEVICE_VECTOR	0x31
-#else
-# define FIRST_DEVICE_VECTOR	(IRQ15_VECTOR + 2)
-#endif
+#define FIRST_DEVICE_VECTOR	(IRQ15_VECTOR + 2)
 
 #define NR_VECTORS		256
 
@@ -116,7 +107,6 @@
 # else
 #  define NR_IRQS (NR_VECTORS + (32 * MAX_IO_APICS))
 # endif
-# define NR_IRQ_VECTORS NR_IRQS
 
 #elif !defined(CONFIG_X86_VOYAGER)
 
@@ -124,23 +114,15 @@
 
 #  define NR_IRQS		224
 
-#  if (224 >= 32 * NR_CPUS)
-#   define NR_IRQ_VECTORS	NR_IRQS
-#  else
-#   define NR_IRQ_VECTORS	(32 * NR_CPUS)
-#  endif
-
 # else /* IO_APIC || PARAVIRT */
 
 #  define NR_IRQS		16
-#  define NR_IRQ_VECTORS	NR_IRQS
 
 # endif
 
 #else /* !VISWS && !VOYAGER */
 
 # define NR_IRQS		224
-# define NR_IRQ_VECTORS		NR_IRQS
 
 #endif /* VISWS */
 
diff --git a/include/asm-x86/mach-default/entry_arch.h b/include/asm-x86/mach-default/entry_arch.h
index 9283b60..6b1add8 100644
--- a/include/asm-x86/mach-default/entry_arch.h
+++ b/include/asm-x86/mach-default/entry_arch.h
@@ -14,6 +14,7 @@ BUILD_INTERRUPT(reschedule_interrupt,RESCHEDULE_VECTOR)
 BUILD_INTERRUPT(invalidate_interrupt,INVALIDATE_TLB_VECTOR)
 BUILD_INTERRUPT(call_function_interrupt,CALL_FUNCTION_VECTOR)
 BUILD_INTERRUPT(call_function_single_interrupt,CALL_FUNCTION_SINGLE_VECTOR)
+BUILD_INTERRUPT(irq_move_cleanup_interrupt,IRQ_MOVE_CLEANUP_VECTOR)
 #endif
 
 /*
diff --git a/include/asm-x86/mach-default/mach_apic.h b/include/asm-x86/mach-default/mach_apic.h
index 2a330a4..3c66f2c 100644
--- a/include/asm-x86/mach-default/mach_apic.h
+++ b/include/asm-x86/mach-default/mach_apic.h
@@ -85,6 +85,20 @@ static inline int apicid_to_node(int logical_apicid)
 	return 0;
 #endif
 }
+
+static inline cpumask_t vector_allocation_domain(int cpu)
+{
+        /* Careful. Some cpus do not strictly honor the set of cpus
+         * specified in the interrupt destination when using lowest
+         * priority interrupt delivery mode.
+         *
+         * In particular there was a hyperthreading cpu observed to
+         * deliver interrupts to the wrong hyperthread when only one
+         * hyperthread was specified in the interrupt desitination.
+         */
+        cpumask_t domain = { { [0] = APIC_ALL_CPUS, } };
+        return domain;
+}
 #endif
 
 static inline unsigned long check_apicid_used(physid_mask_t bitmap, int apicid)
@@ -138,6 +152,5 @@ static inline int check_phys_apicid_present(int boot_cpu_physical_apicid)
 static inline void enable_apic_mode(void)
 {
 }
-
 #endif /* CONFIG_X86_LOCAL_APIC */
 #endif /* ASM_X86__MACH_DEFAULT__MACH_APIC_H */
diff --git a/include/asm-x86/mach-generic/irq_vectors_limits.h b/include/asm-x86/mach-generic/irq_vectors_limits.h
deleted file mode 100644
index f7870e1..0000000
--- a/include/asm-x86/mach-generic/irq_vectors_limits.h
+++ /dev/null
@@ -1,14 +0,0 @@
-#ifndef ASM_X86__MACH_GENERIC__IRQ_VECTORS_LIMITS_H
-#define ASM_X86__MACH_GENERIC__IRQ_VECTORS_LIMITS_H
-
-/*
- * For Summit or generic (i.e. installer) kernels, we have lots of I/O APICs,
- * even with uni-proc kernels, so use a big array.
- *
- * This value should be the same in both the generic and summit subarches.
- * Change one, change 'em both.
- */
-#define NR_IRQS	224
-#define NR_IRQ_VECTORS	1024
-
-#endif /* ASM_X86__MACH_GENERIC__IRQ_VECTORS_LIMITS_H */
diff --git a/include/asm-x86/mach-generic/mach_apic.h b/include/asm-x86/mach-generic/mach_apic.h
index 5d010c6..5085b52 100644
--- a/include/asm-x86/mach-generic/mach_apic.h
+++ b/include/asm-x86/mach-generic/mach_apic.h
@@ -24,6 +24,7 @@
 #define check_phys_apicid_present (genapic->check_phys_apicid_present)
 #define check_apicid_used (genapic->check_apicid_used)
 #define cpu_mask_to_apicid (genapic->cpu_mask_to_apicid)
+#define vector_allocation_domain (genapic->vector_allocation_domain)
 #define enable_apic_mode (genapic->enable_apic_mode)
 #define phys_pkg_id (genapic->phys_pkg_id)
 
diff --git a/include/asm-x86/numaq/apic.h b/include/asm-x86/numaq/apic.h
index a8344ba..0bf2a06 100644
--- a/include/asm-x86/numaq/apic.h
+++ b/include/asm-x86/numaq/apic.h
@@ -12,8 +12,6 @@ static inline cpumask_t target_cpus(void)
 	return CPU_MASK_ALL;
 }
 
-#define TARGET_CPUS (target_cpus())
-
 #define NO_BALANCE_IRQ (1)
 #define esr_disable (1)
 
diff --git a/include/asm-x86/summit/apic.h b/include/asm-x86/summit/apic.h
index c5b2e4b..0f68037 100644
--- a/include/asm-x86/summit/apic.h
+++ b/include/asm-x86/summit/apic.h
@@ -22,7 +22,6 @@ static inline cpumask_t target_cpus(void)
 	 */
 	return cpumask_of_cpu(0);
 }
-#define TARGET_CPUS	(target_cpus())
 
 #define INT_DELIVERY_MODE (dest_LowestPrio)
 #define INT_DEST_MODE 1     /* logical delivery broadcast to all procs */
diff --git a/include/asm-x86/summit/irq_vectors_limits.h b/include/asm-x86/summit/irq_vectors_limits.h
deleted file mode 100644
index 890ce3f..0000000
--- a/include/asm-x86/summit/irq_vectors_limits.h
+++ /dev/null
@@ -1,14 +0,0 @@
-#ifndef _ASM_IRQ_VECTORS_LIMITS_H
-#define _ASM_IRQ_VECTORS_LIMITS_H
-
-/*
- * For Summit or generic (i.e. installer) kernels, we have lots of I/O APICs,
- * even with uni-proc kernels, so use a big array.
- *
- * This value should be the same in both the generic and summit subarches.
- * Change one, change 'em both.
- */
-#define NR_IRQS	224
-#define NR_IRQ_VECTORS	1024
-
-#endif /* _ASM_IRQ_VECTORS_LIMITS_H */
diff --git a/include/asm-x86/uv/bios.h b/include/asm-x86/uv/bios.h
index 7cd6d7e..215f196 100644
--- a/include/asm-x86/uv/bios.h
+++ b/include/asm-x86/uv/bios.h
@@ -2,9 +2,7 @@
 #define ASM_X86__UV__BIOS_H
 
 /*
- * BIOS layer definitions.
- *
- *  Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
+ * UV BIOS layer definitions.
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -19,50 +17,78 @@
  *  You should have received a copy of the GNU General Public License
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ *
+ *  Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
+ *  Copyright (c) Russ Anderson
  */
 
 #include <linux/rtc.h>
 
-#define BIOS_FREQ_BASE			0x01000001
+/*
+ * Values for the BIOS calls.  It is passed as the first * argument in the
+ * BIOS call.  Passing any other value in the first argument will result
+ * in a BIOS_STATUS_UNIMPLEMENTED return status.
+ */
+enum uv_bios_cmd {
+	UV_BIOS_COMMON,
+	UV_BIOS_GET_SN_INFO,
+	UV_BIOS_FREQ_BASE
+};
 
+/*
+ * Status values returned from a BIOS call.
+ */
 enum {
-	BIOS_FREQ_BASE_PLATFORM = 0,
-	BIOS_FREQ_BASE_INTERVAL_TIMER = 1,
-	BIOS_FREQ_BASE_REALTIME_CLOCK = 2
+	BIOS_STATUS_SUCCESS		=  0,
+	BIOS_STATUS_UNIMPLEMENTED	= -ENOSYS,
+	BIOS_STATUS_EINVAL		= -EINVAL,
+	BIOS_STATUS_UNAVAIL		= -EBUSY
 };
 
-# define BIOS_CALL(result, a0, a1, a2, a3, a4, a5, a6, a7)		\
-	do {								\
-		/* XXX - the real call goes here */			\
-		result.status = BIOS_STATUS_UNIMPLEMENTED;		\
-		isrv.v0 = 0;						\
-		isrv.v1 = 0;						\
-	} while (0)
+/*
+ * The UV system table describes specific firmware
+ * capabilities available to the Linux kernel at runtime.
+ */
+struct uv_systab {
+	char signature[4];	/* must be "UVST" */
+	u32 revision;		/* distinguish different firmware revs */
+	u64 function;		/* BIOS runtime callback function ptr */
+};
 
 enum {
-	BIOS_STATUS_SUCCESS		=  0,
-	BIOS_STATUS_UNIMPLEMENTED	= -1,
-	BIOS_STATUS_EINVAL		= -2,
-	BIOS_STATUS_ERROR		= -3
+	BIOS_FREQ_BASE_PLATFORM = 0,
+	BIOS_FREQ_BASE_INTERVAL_TIMER = 1,
+	BIOS_FREQ_BASE_REALTIME_CLOCK = 2
 };
 
-struct uv_bios_retval {
-	/*
-	 * A zero status value indicates call completed without error.
-	 * A negative status value indicates reason of call failure.
-	 * A positive status value indicates success but an
-	 * informational value should be printed (e.g., "reboot for
-	 * change to take effect").
-	 */
-	s64 status;
-	u64 v0;
-	u64 v1;
-	u64 v2;
+union partition_info_u {
+	u64	val;
+	struct {
+		u64	hub_version	:  8,
+			partition_id	: 16,
+			coherence_id	: 16,
+			region_size	: 24;
+	};
 };
 
-extern long
-x86_bios_freq_base(unsigned long which, unsigned long *ticks_per_second,
-		   unsigned long *drift_info);
-extern const char *x86_bios_strerror(long status);
+/*
+ * bios calls have 6 parameters
+ */
+extern s64 uv_bios_call(enum uv_bios_cmd, u64, u64, u64, u64, u64);
+extern s64 uv_bios_call_irqsave(enum uv_bios_cmd, u64, u64, u64, u64, u64);
+extern s64 uv_bios_call_reentrant(enum uv_bios_cmd, u64, u64, u64, u64, u64);
+
+extern s64 uv_bios_get_sn_info(int, int *, long *, long *, long *);
+extern s64 uv_bios_freq_base(u64, u64 *);
+
+extern void uv_bios_init(void);
+
+extern int uv_type;
+extern long sn_partition_id;
+extern long uv_coherency_id;
+extern long uv_region_size;
+#define partition_coherence_id()	(uv_coherency_id)
+
+extern struct kobject *sgi_uv_kobj;	/* /sys/firmware/sgi_uv */
 
 #endif /* ASM_X86__UV__BIOS_H */
diff --git a/include/asm-x86/uv/uv_irq.h b/include/asm-x86/uv/uv_irq.h
new file mode 100644
index 0000000..8bf5f32
--- /dev/null
+++ b/include/asm-x86/uv/uv_irq.h
@@ -0,0 +1,36 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * SGI UV IRQ definitions
+ *
+ * Copyright (C) 2008 Silicon Graphics, Inc. All rights reserved.
+ */
+
+#ifndef ASM_X86__UV__UV_IRQ_H
+#define ASM_X86__UV__UV_IRQ_H
+
+/* If a generic version of this structure gets defined, eliminate this one. */
+struct uv_IO_APIC_route_entry {
+	__u64	vector		:  8,
+		delivery_mode	:  3,
+		dest_mode	:  1,
+		delivery_status	:  1,
+		polarity	:  1,
+		__reserved_1	:  1,
+		trigger		:  1,
+		mask		:  1,
+		__reserved_2	: 15,
+		dest		: 32;
+};
+
+extern struct irq_chip uv_irq_chip;
+
+extern int arch_enable_uv_irq(char *, unsigned int, int, int, unsigned long);
+extern void arch_disable_uv_irq(int, unsigned long);
+
+extern int uv_setup_irq(char *, int, int, unsigned long);
+extern void uv_teardown_irq(unsigned int, int, unsigned long);
+
+#endif /* ASM_X86__UV__UV_IRQ_H */
diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index c360c55..f1984fc 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -45,7 +45,6 @@ extern struct list_head dmar_drhd_units;
 	list_for_each_entry(drhd, &dmar_drhd_units, list)
 
 extern int dmar_table_init(void);
-extern int early_dmar_detect(void);
 extern int dmar_dev_scope_init(void);
 
 /* Intel IOMMU detection */
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 807373d..bb66feb 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -208,6 +208,9 @@ typedef efi_status_t efi_set_virtual_address_map_t (unsigned long memory_map_siz
 #define EFI_GLOBAL_VARIABLE_GUID \
     EFI_GUID(  0x8be4df61, 0x93ca, 0x11d2, 0xaa, 0x0d, 0x00, 0xe0, 0x98, 0x03, 0x2b, 0x8c )
 
+#define UV_SYSTEM_TABLE_GUID \
+    EFI_GUID(  0x3b13a7d4, 0x633e, 0x11dd, 0x93, 0xec, 0xda, 0x25, 0x56, 0xd8, 0x95, 0x93 )
+
 typedef struct {
 	efi_guid_t guid;
 	unsigned long table;
@@ -255,6 +258,7 @@ extern struct efi {
 	unsigned long boot_info;	/* boot info table */
 	unsigned long hcdp;		/* HCDP table */
 	unsigned long uga;		/* UGA table */
+	unsigned long uv_systab;	/* UV system table */
 	efi_get_time_t *get_time;
 	efi_set_time_t *set_time;
 	efi_get_wakeup_time_t *get_wakeup_time;
diff --git a/include/linux/init.h b/include/linux/init.h
index 93538b6..59fbb4a 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -246,6 +246,50 @@ struct obs_kernel_param {
 
 /* Relies on boot_command_line being set */
 void __init parse_early_param(void);
+
+struct dyn_array {
+	void **name;
+	unsigned long size;
+	unsigned int *nr;
+	unsigned long align;
+	void (*init_work)(void *);
+};
+extern struct dyn_array *__dyn_array_start[], *__dyn_array_end[];
+extern struct dyn_array *__per_cpu_dyn_array_start[], *__per_cpu_dyn_array_end[];
+
+#define DEFINE_DYN_ARRAY_ADDR(nameX, addrX, sizeX, nrX, alignX, init_workX) \
+		static struct dyn_array __dyn_array_##nameX __initdata = \
+		{	.name = (void **)&(nameX),\
+			.size = sizeX,\
+			.nr   = &(nrX),\
+			.align = alignX,\
+			.init_work = init_workX,\
+		}; \
+		static struct dyn_array *__dyn_array_ptr_##nameX __used \
+		__attribute__((__section__(".dyn_array.init"))) = \
+			&__dyn_array_##nameX
+
+#define DEFINE_DYN_ARRAY(nameX, sizeX, nrX, alignX, init_workX) \
+	DEFINE_DYN_ARRAY_ADDR(nameX, nameX, sizeX, nrX, alignX, init_workX)
+
+#define DEFINE_PER_CPU_DYN_ARRAY_ADDR(nameX, addrX, sizeX, nrX, alignX, init_workX) \
+		static struct dyn_array __per_cpu_dyn_array_##nameX __initdata = \
+		{	.name = (void **)&(addrX),\
+			.size = sizeX,\
+			.nr   = &(nrX),\
+			.align = alignX,\
+			.init_work = init_workX,\
+		}; \
+		static struct dyn_array *__per_cpu_dyn_array_ptr_##nameX __used \
+		__attribute__((__section__(".per_cpu_dyn_array.init"))) = \
+			&__per_cpu_dyn_array_##nameX
+
+#define DEFINE_PER_CPU_DYN_ARRAY(nameX, sizeX, nrX, alignX, init_workX) \
+	DEFINE_PER_CPU_DYN_ARRAY_ADDR(nameX, nameX, nrX, alignX, init_workX)
+
+extern void pre_alloc_dyn_array(void);
+extern unsigned long per_cpu_dyn_array_size(unsigned long *align);
+extern void per_cpu_alloc_dyn_array(int cpu, char *ptr);
 #endif /* __ASSEMBLY__ */
 
 /**
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 58ff4e7..d4039a0 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -15,6 +15,13 @@
 #include <asm/ptrace.h>
 #include <asm/system.h>
 
+extern int nr_irqs;
+
+#ifndef CONFIG_GENERIC_HARDIRQS
+#define for_each_irq_desc(irq, desc)		\
+	for (irq = 0; irq < nr_irqs; irq++)
+#endif
+
 /*
  * These correspond to the IORESOURCE_IRQ_* defines in
  * linux/ioport.h to select the interrupt line behaviour.  When
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 8d9411b..93fe9a9 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -127,6 +127,8 @@ struct irq_chip {
 	const char	*typename;
 };
 
+struct timer_rand_state;
+struct irq_2_iommu;
 /**
  * struct irq_desc - interrupt descriptor
  *
@@ -152,6 +154,17 @@ struct irq_chip {
  * @name:		flow handler name for /proc/interrupts output
  */
 struct irq_desc {
+	unsigned int		irq;
+#ifdef CONFIG_HAVE_SPARSE_IRQ
+	struct irq_desc		*next;
+	struct timer_rand_state *timer_rand_state;
+#endif
+#ifdef CONFIG_HAVE_DYN_ARRAY
+	unsigned int            *kstat_irqs;
+#endif
+#if defined(CONFIG_INTR_REMAP) && defined(CONFIG_HAVE_SPARSE_IRQ)
+       struct irq_2_iommu      *irq_2_iommu;
+#endif
 	irq_flow_handler_t	handle_irq;
 	struct irq_chip		*chip;
 	struct msi_desc		*msi_desc;
@@ -170,7 +183,7 @@ struct irq_desc {
 	cpumask_t		affinity;
 	unsigned int		cpu;
 #endif
-#if defined(CONFIG_GENERIC_PENDING_IRQ) || defined(CONFIG_IRQBALANCE)
+#ifdef CONFIG_GENERIC_PENDING_IRQ
 	cpumask_t		pending_mask;
 #endif
 #ifdef CONFIG_PROC_FS
@@ -179,7 +192,35 @@ struct irq_desc {
 	const char		*name;
 } ____cacheline_internodealigned_in_smp;
 
+extern struct irq_desc *irq_to_desc(unsigned int irq);
+extern struct irq_desc *irq_to_desc_alloc(unsigned int irq);
+
+#ifndef CONFIG_HAVE_SPARSE_IRQ
+
+#ifndef CONFIG_HAVE_DYN_ARRAY
+/* could be removed if we get rid of all irq_desc reference */
 extern struct irq_desc irq_desc[NR_IRQS];
+#else
+extern struct irq_desc *irq_desc;
+#endif
+
+#ifdef CONFIG_GENERIC_HARDIRQS
+#define for_each_irq_desc(irq, desc)		\
+	for (irq = 0, desc = irq_desc; irq < nr_irqs; irq++, desc = &irq_desc[irq])
+#endif
+
+#else
+
+extern struct irq_desc *sparse_irqs;
+#define for_each_irq_desc(irqX, desc)		\
+	for (desc = sparse_irqs, irqX = desc->irq; desc; desc = desc->next, irqX = desc ? desc->irq : -1U)
+
+#endif
+
+#ifdef CONFIG_HAVE_DYN_ARRAY
+#define kstat_irqs_this_cpu(DESC) \
+	((DESC)->kstat_irqs[smp_processor_id()])
+#endif
 
 /*
  * Migration helpers for obsolete names, they will go away:
@@ -198,19 +239,15 @@ extern int setup_irq(unsigned int irq, struct irqaction *new);
 
 #ifdef CONFIG_GENERIC_HARDIRQS
 
-#ifndef handle_dynamic_tick
-# define handle_dynamic_tick(a)		do { } while (0)
-#endif
-
 #ifdef CONFIG_SMP
 
-#if defined(CONFIG_GENERIC_PENDING_IRQ) || defined(CONFIG_IRQBALANCE)
+#ifdef CONFIG_GENERIC_PENDING_IRQ
 
 void set_pending_irq(unsigned int irq, cpumask_t mask);
 void move_native_irq(int irq);
 void move_masked_irq(int irq);
 
-#else /* CONFIG_GENERIC_PENDING_IRQ || CONFIG_IRQBALANCE */
+#else /* CONFIG_GENERIC_PENDING_IRQ */
 
 static inline void move_irq(int irq)
 {
@@ -237,19 +274,14 @@ static inline void set_pending_irq(unsigned int irq, cpumask_t mask)
 
 #endif /* CONFIG_SMP */
 
-#ifdef CONFIG_IRQBALANCE
-extern void set_balance_irq_affinity(unsigned int irq, cpumask_t mask);
-#else
-static inline void set_balance_irq_affinity(unsigned int irq, cpumask_t mask)
-{
-}
-#endif
-
 extern int no_irq_affinity;
 
 static inline int irq_balancing_disabled(unsigned int irq)
 {
-	return irq_desc[irq].status & IRQ_NO_BALANCING_MASK;
+	struct irq_desc *desc;
+
+	desc = irq_to_desc(irq);
+	return desc->status & IRQ_NO_BALANCING_MASK;
 }
 
 /* Handle irq action chains: */
@@ -279,10 +311,8 @@ extern unsigned int __do_IRQ(unsigned int irq);
  * irqchip-style controller then we call the ->handle_irq() handler,
  * and it calls __do_IRQ() if it's attached to an irqtype-style controller.
  */
-static inline void generic_handle_irq(unsigned int irq)
+static inline void generic_handle_irq_desc(unsigned int irq, struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_desc + irq;
-
 #ifdef CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ
 	desc->handle_irq(irq, desc);
 #else
@@ -293,6 +323,11 @@ static inline void generic_handle_irq(unsigned int irq)
 #endif
 }
 
+static inline void generic_handle_irq(unsigned int irq)
+{
+	generic_handle_irq_desc(irq, irq_to_desc(irq));
+}
+
 /* Handling of unhandled and spurious interrupts: */
 extern void note_interrupt(unsigned int irq, struct irq_desc *desc,
 			   int action_ret);
@@ -325,7 +360,10 @@ __set_irq_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
 static inline void __set_irq_handler_unlocked(int irq,
 					      irq_flow_handler_t handler)
 {
-	irq_desc[irq].handle_irq = handler;
+	struct irq_desc *desc;
+
+	desc = irq_to_desc(irq);
+	desc->handle_irq = handler;
 }
 
 /*
@@ -353,13 +391,14 @@ extern void set_irq_noprobe(unsigned int irq);
 extern void set_irq_probe(unsigned int irq);
 
 /* Handle dynamic irq creation and destruction */
+extern unsigned int create_irq_nr(unsigned int irq_want);
 extern int create_irq(void);
 extern void destroy_irq(unsigned int irq);
 
 /* Test to see if a driver has successfully requested an irq */
 static inline int irq_has_action(unsigned int irq)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc = irq_to_desc(irq);
 	return desc->action != NULL;
 }
 
@@ -374,10 +413,10 @@ extern int set_irq_chip_data(unsigned int irq, void *data);
 extern int set_irq_type(unsigned int irq, unsigned int type);
 extern int set_irq_msi(unsigned int irq, struct msi_desc *entry);
 
-#define get_irq_chip(irq)	(irq_desc[irq].chip)
-#define get_irq_chip_data(irq)	(irq_desc[irq].chip_data)
-#define get_irq_data(irq)	(irq_desc[irq].handler_data)
-#define get_irq_msi(irq)	(irq_desc[irq].msi_desc)
+#define get_irq_chip(irq)	(irq_to_desc(irq)->chip)
+#define get_irq_chip_data(irq)	(irq_to_desc(irq)->chip_data)
+#define get_irq_data(irq)	(irq_to_desc(irq)->handler_data)
+#define get_irq_msi(irq)	(irq_to_desc(irq)->msi_desc)
 
 #endif /* CONFIG_GENERIC_HARDIRQS */
 
diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index cf9f40a..21249d8 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -28,7 +28,9 @@ struct cpu_usage_stat {
 
 struct kernel_stat {
 	struct cpu_usage_stat	cpustat;
-	unsigned int irqs[NR_IRQS];
+#ifndef CONFIG_HAVE_DYN_ARRAY
+       unsigned int irqs[NR_IRQS];
+#endif
 };
 
 DECLARE_PER_CPU(struct kernel_stat, kstat);
@@ -39,15 +41,31 @@ DECLARE_PER_CPU(struct kernel_stat, kstat);
 
 extern unsigned long long nr_context_switches(void);
 
+#ifndef CONFIG_HAVE_DYN_ARRAY
+#define kstat_irqs_this_cpu(irq) \
+	(kstat_this_cpu.irqs[irq])
+#endif
+
+
+#ifndef CONFIG_HAVE_DYN_ARRAY
+static inline unsigned int kstat_irqs_cpu(unsigned int irq, int cpu)
+{
+       return kstat_cpu(cpu).irqs[irq];
+}
+#else
+extern unsigned int kstat_irqs_cpu(unsigned int irq, int cpu);
+#endif
+
 /*
  * Number of interrupts per specific IRQ source, since bootup
  */
-static inline int kstat_irqs(int irq)
+static inline unsigned int kstat_irqs(unsigned int irq)
 {
-	int cpu, sum = 0;
+	unsigned int sum = 0;
+	int cpu;
 
 	for_each_possible_cpu(cpu)
-		sum += kstat_cpu(cpu).irqs[irq];
+		sum += kstat_irqs_cpu(irq, cpu);
 
 	return sum;
 }
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 98dc624..1f8db24 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -723,7 +723,7 @@ enum pci_dma_burst_strategy {
 };
 
 struct msix_entry {
-	u16 	vector;	/* kernel uses to write allocated vector */
+	u32	vector;	/* kernel uses to write allocated vector */
 	u16	entry;	/* driver uses to specify entry, OS writes */
 };
 
diff --git a/init/Makefile b/init/Makefile
index 4a243df..dc5eeca 100644
--- a/init/Makefile
+++ b/init/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the linux kernel.
 #
 
-obj-y                          := main.o version.o mounts.o
+obj-y                          := main.o dyn_array.o version.o mounts.o
 ifneq ($(CONFIG_BLK_DEV_INITRD),y)
 obj-y                          += noinitramfs.o
 else
diff --git a/init/dyn_array.c b/init/dyn_array.c
new file mode 100644
index 0000000..c8d5e2a
--- /dev/null
+++ b/init/dyn_array.c
@@ -0,0 +1,120 @@
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/kallsyms.h>
+#include <linux/init.h>
+#include <linux/bootmem.h>
+#include <linux/irq.h>
+
+void __init pre_alloc_dyn_array(void)
+{
+#ifdef CONFIG_HAVE_DYN_ARRAY
+	unsigned long total_size = 0, size, phys;
+	unsigned long max_align = 1;
+	struct dyn_array **daa;
+	char *ptr;
+
+	/* get the total size at first */
+	for (daa = __dyn_array_start ; daa < __dyn_array_end; daa++) {
+		struct dyn_array *da = *daa;
+
+		printk(KERN_DEBUG "dyn_array %pF size:%#lx nr:%d align:%#lx\n",
+			da->name, da->size, *da->nr, da->align);
+		size = da->size * (*da->nr);
+		total_size += roundup(size, da->align);
+		if (da->align > max_align)
+			max_align = da->align;
+	}
+	if (total_size)
+		printk(KERN_DEBUG "dyn_array total_size: %#lx\n",
+			 total_size);
+	else
+		return;
+
+	/* allocate them all together */
+	max_align = max_t(unsigned long, max_align, PAGE_SIZE);
+	ptr = __alloc_bootmem(total_size, max_align, 0);
+	phys = virt_to_phys(ptr);
+
+	for (daa = __dyn_array_start ; daa < __dyn_array_end; daa++) {
+		struct dyn_array *da = *daa;
+
+		size = da->size * (*da->nr);
+		phys = roundup(phys, da->align);
+		printk(KERN_DEBUG "dyn_array %pF ==> [%#lx - %#lx]\n",
+			da->name, phys, phys + size);
+		*da->name = phys_to_virt(phys);
+
+		phys += size;
+
+		if (da->init_work)
+			da->init_work(da);
+	}
+#else
+#ifdef CONFIG_GENERIC_HARDIRQS
+	unsigned int i;
+
+	for (i = 0; i < NR_IRQS; i++)
+		irq_desc[i].irq = i;
+#endif
+#endif
+}
+
+unsigned long __init per_cpu_dyn_array_size(unsigned long *align)
+{
+	unsigned long total_size = 0;
+#ifdef CONFIG_HAVE_DYN_ARRAY
+	unsigned long size;
+	struct dyn_array **daa;
+	unsigned max_align = 1;
+
+	for (daa = __per_cpu_dyn_array_start ; daa < __per_cpu_dyn_array_end; daa++) {
+		struct dyn_array *da = *daa;
+
+		printk(KERN_DEBUG "per_cpu_dyn_array %pF size:%#lx nr:%d align:%#lx\n",
+			da->name, da->size, *da->nr, da->align);
+		size = da->size * (*da->nr);
+		total_size += roundup(size, da->align);
+		if (da->align > max_align)
+			max_align = da->align;
+	}
+	if (total_size) {
+		printk(KERN_DEBUG "per_cpu_dyn_array total_size: %#lx\n",
+			 total_size);
+		*align = max_align;
+	}
+#endif
+	return total_size;
+}
+
+#ifdef CONFIG_SMP
+void __init per_cpu_alloc_dyn_array(int cpu, char *ptr)
+{
+#ifdef CONFIG_HAVE_DYN_ARRAY
+	unsigned long size, phys;
+	struct dyn_array **daa;
+	unsigned long addr;
+	void **array;
+
+	phys = virt_to_phys(ptr);
+	for (daa = __per_cpu_dyn_array_start ; daa < __per_cpu_dyn_array_end; daa++) {
+		struct dyn_array *da = *daa;
+
+		size = da->size * (*da->nr);
+		phys = roundup(phys, da->align);
+		printk(KERN_DEBUG "per_cpu_dyn_array %pF ==> [%#lx - %#lx]\n",
+			da->name, phys, phys + size);
+
+		addr = (unsigned long)da->name;
+		addr += per_cpu_offset(cpu);
+		array = (void **)addr;
+		*array = phys_to_virt(phys);
+		*da->name = *array; /* so init_work could use it directly */
+
+		phys += size;
+
+		if (da->init_work)
+			da->init_work(da);
+	}
+#endif
+}
+#endif
diff --git a/init/main.c b/init/main.c
index 3820323..78d2bd3 100644
--- a/init/main.c
+++ b/init/main.c
@@ -391,17 +391,23 @@ EXPORT_SYMBOL(__per_cpu_offset);
 
 static void __init setup_per_cpu_areas(void)
 {
-	unsigned long size, i;
+	unsigned long size, i, old_size;
 	char *ptr;
 	unsigned long nr_possible_cpus = num_possible_cpus();
+	unsigned long align = 1;
+	unsigned da_size;
 
 	/* Copy section for each CPU (we discard the original) */
-	size = ALIGN(PERCPU_ENOUGH_ROOM, PAGE_SIZE);
+	old_size = PERCPU_ENOUGH_ROOM;
+	da_size = per_cpu_dyn_array_size(&align);
+	align = max_t(unsigned long, PAGE_SIZE, align);
+	size = ALIGN(old_size + da_size, align);
 	ptr = alloc_bootmem_pages(size * nr_possible_cpus);
 
 	for_each_possible_cpu(i) {
 		__per_cpu_offset[i] = ptr - __per_cpu_start;
 		memcpy(ptr, __per_cpu_start, __per_cpu_end - __per_cpu_start);
+		per_cpu_alloc_dyn_array(i, ptr + old_size);
 		ptr += size;
 	}
 }
@@ -567,6 +573,7 @@ asmlinkage void __init start_kernel(void)
 	printk(KERN_NOTICE);
 	printk(linux_banner);
 	setup_arch(&command_line);
+	pre_alloc_dyn_array();
 	mm_init_owner(&init_mm, &init_task);
 	setup_command_line(command_line);
 	unwind_setup();
diff --git a/kernel/irq/autoprobe.c b/kernel/irq/autoprobe.c
index 533068c..b3a5549 100644
--- a/kernel/irq/autoprobe.c
+++ b/kernel/irq/autoprobe.c
@@ -38,8 +38,10 @@ unsigned long probe_irq_on(void)
 	 * something may have generated an irq long ago and we want to
 	 * flush such a longstanding irq before considering it as spurious.
 	 */
-	for (i = NR_IRQS-1; i > 0; i--) {
-		desc = irq_desc + i;
+	for (i = nr_irqs-1; i > 0; i--) {
+		desc = irq_to_desc(i);
+		if (!desc)
+			continue;
 
 		spin_lock_irq(&desc->lock);
 		if (!desc->action && !(desc->status & IRQ_NOPROBE)) {
@@ -68,8 +70,10 @@ unsigned long probe_irq_on(void)
 	 * (we must startup again here because if a longstanding irq
 	 * happened in the previous stage, it may have masked itself)
 	 */
-	for (i = NR_IRQS-1; i > 0; i--) {
-		desc = irq_desc + i;
+	for (i = nr_irqs-1; i > 0; i--) {
+		desc = irq_to_desc(i);
+		if (!desc)
+			continue;
 
 		spin_lock_irq(&desc->lock);
 		if (!desc->action && !(desc->status & IRQ_NOPROBE)) {
@@ -89,10 +93,12 @@ unsigned long probe_irq_on(void)
 	 * Now filter out any obviously spurious interrupts
 	 */
 	mask = 0;
-	for (i = 0; i < NR_IRQS; i++) {
+	for (i = 0; i < nr_irqs; i++) {
 		unsigned int status;
 
-		desc = irq_desc + i;
+		desc = irq_to_desc(i);
+		if (!desc)
+			continue;
 		spin_lock_irq(&desc->lock);
 		status = desc->status;
 
@@ -130,10 +136,12 @@ unsigned int probe_irq_mask(unsigned long val)
 	int i;
 
 	mask = 0;
-	for (i = 0; i < NR_IRQS; i++) {
-		struct irq_desc *desc = irq_desc + i;
+	for (i = 0; i < nr_irqs; i++) {
+		struct irq_desc *desc = irq_to_desc(i);
 		unsigned int status;
 
+		if (!desc)
+			continue;
 		spin_lock_irq(&desc->lock);
 		status = desc->status;
 
@@ -173,10 +181,12 @@ int probe_irq_off(unsigned long val)
 {
 	int i, irq_found = 0, nr_irqs = 0;
 
-	for (i = 0; i < NR_IRQS; i++) {
-		struct irq_desc *desc = irq_desc + i;
+	for (i = 0; i < nr_irqs; i++) {
+		struct irq_desc *desc = irq_to_desc(i);
 		unsigned int status;
 
+		if (!desc)
+			continue;
 		spin_lock_irq(&desc->lock);
 		status = desc->status;
 
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 3cd441e..5a3f73e 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -27,13 +27,14 @@ void dynamic_irq_init(unsigned int irq)
 	struct irq_desc *desc;
 	unsigned long flags;
 
-	if (irq >= NR_IRQS) {
+	/* first time to use this irq_desc */
+	desc = irq_to_desc_alloc(irq);
+	if (!desc) {
 		WARN(1, KERN_ERR "Trying to initialize invalid IRQ%d\n", irq);
 		return;
 	}
 
 	/* Ensure we don't have left over values from a previous use of this irq */
-	desc = irq_desc + irq;
 	spin_lock_irqsave(&desc->lock, flags);
 	desc->status = IRQ_DISABLED;
 	desc->chip = &no_irq_chip;
@@ -60,12 +61,12 @@ void dynamic_irq_cleanup(unsigned int irq)
 	struct irq_desc *desc;
 	unsigned long flags;
 
-	if (irq >= NR_IRQS) {
+	desc = irq_to_desc(irq);
+	if (!desc) {
 		WARN(1, KERN_ERR "Trying to cleanup invalid IRQ%d\n", irq);
 		return;
 	}
 
-	desc = irq_desc + irq;
 	spin_lock_irqsave(&desc->lock, flags);
 	if (desc->action) {
 		spin_unlock_irqrestore(&desc->lock, flags);
@@ -92,7 +93,8 @@ int set_irq_chip(unsigned int irq, struct irq_chip *chip)
 	struct irq_desc *desc;
 	unsigned long flags;
 
-	if (irq >= NR_IRQS) {
+	desc = irq_to_desc(irq);
+	if (!desc) {
 		WARN(1, KERN_ERR "Trying to install chip for IRQ%d\n", irq);
 		return -EINVAL;
 	}
@@ -100,7 +102,6 @@ int set_irq_chip(unsigned int irq, struct irq_chip *chip)
 	if (!chip)
 		chip = &no_irq_chip;
 
-	desc = irq_desc + irq;
 	spin_lock_irqsave(&desc->lock, flags);
 	irq_chip_set_defaults(chip);
 	desc->chip = chip;
@@ -121,12 +122,12 @@ int set_irq_type(unsigned int irq, unsigned int type)
 	unsigned long flags;
 	int ret = -ENXIO;
 
-	if (irq >= NR_IRQS) {
+	desc = irq_to_desc(irq);
+	if (!desc) {
 		printk(KERN_ERR "Trying to set irq type for IRQ%d\n", irq);
 		return -ENODEV;
 	}
 
-	desc = irq_desc + irq;
 	if (desc->chip->set_type) {
 		spin_lock_irqsave(&desc->lock, flags);
 		ret = desc->chip->set_type(irq, type);
@@ -148,13 +149,13 @@ int set_irq_data(unsigned int irq, void *data)
 	struct irq_desc *desc;
 	unsigned long flags;
 
-	if (irq >= NR_IRQS) {
+	desc = irq_to_desc(irq);
+	if (!desc) {
 		printk(KERN_ERR
 		       "Trying to install controller data for IRQ%d\n", irq);
 		return -EINVAL;
 	}
 
-	desc = irq_desc + irq;
 	spin_lock_irqsave(&desc->lock, flags);
 	desc->handler_data = data;
 	spin_unlock_irqrestore(&desc->lock, flags);
@@ -174,12 +175,13 @@ int set_irq_msi(unsigned int irq, struct msi_desc *entry)
 	struct irq_desc *desc;
 	unsigned long flags;
 
-	if (irq >= NR_IRQS) {
+	desc = irq_to_desc(irq);
+	if (!desc) {
 		printk(KERN_ERR
 		       "Trying to install msi data for IRQ%d\n", irq);
 		return -EINVAL;
 	}
-	desc = irq_desc + irq;
+
 	spin_lock_irqsave(&desc->lock, flags);
 	desc->msi_desc = entry;
 	if (entry)
@@ -197,10 +199,17 @@ int set_irq_msi(unsigned int irq, struct msi_desc *entry)
  */
 int set_irq_chip_data(unsigned int irq, void *data)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc;
 	unsigned long flags;
 
-	if (irq >= NR_IRQS || !desc->chip) {
+	desc = irq_to_desc(irq);
+	if (!desc) {
+		printk(KERN_ERR
+		       "Trying to install chip data for IRQ%d\n", irq);
+		return -EINVAL;
+	}
+
+	if (!desc->chip) {
 		printk(KERN_ERR "BUG: bad set_irq_chip_data(IRQ#%d)\n", irq);
 		return -EINVAL;
 	}
@@ -218,8 +227,9 @@ EXPORT_SYMBOL(set_irq_chip_data);
  */
 static void default_enable(unsigned int irq)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc;
 
+	desc = irq_to_desc(irq);
 	desc->chip->unmask(irq);
 	desc->status &= ~IRQ_MASKED;
 }
@@ -236,7 +246,10 @@ static void default_disable(unsigned int irq)
  */
 static unsigned int default_startup(unsigned int irq)
 {
-	irq_desc[irq].chip->enable(irq);
+	struct irq_desc *desc;
+
+	desc = irq_to_desc(irq);
+	desc->chip->enable(irq);
 
 	return 0;
 }
@@ -246,8 +259,9 @@ static unsigned int default_startup(unsigned int irq)
  */
 static void default_shutdown(unsigned int irq)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc;
 
+	desc = irq_to_desc(irq);
 	desc->chip->mask(irq);
 	desc->status |= IRQ_MASKED;
 }
@@ -305,14 +319,17 @@ handle_simple_irq(unsigned int irq, struct irq_desc *desc)
 {
 	struct irqaction *action;
 	irqreturn_t action_ret;
-	const unsigned int cpu = smp_processor_id();
 
 	spin_lock(&desc->lock);
 
 	if (unlikely(desc->status & IRQ_INPROGRESS))
 		goto out_unlock;
 	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
-	kstat_cpu(cpu).irqs[irq]++;
+#ifdef CONFIG_HAVE_DYN_ARRAY
+	kstat_irqs_this_cpu(desc)++;
+#else
+	kstat_irqs_this_cpu(irq)++;
+#endif
 
 	action = desc->action;
 	if (unlikely(!action || (desc->status & IRQ_DISABLED)))
@@ -344,7 +361,6 @@ out_unlock:
 void
 handle_level_irq(unsigned int irq, struct irq_desc *desc)
 {
-	unsigned int cpu = smp_processor_id();
 	struct irqaction *action;
 	irqreturn_t action_ret;
 
@@ -354,7 +370,11 @@ handle_level_irq(unsigned int irq, struct irq_desc *desc)
 	if (unlikely(desc->status & IRQ_INPROGRESS))
 		goto out_unlock;
 	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
-	kstat_cpu(cpu).irqs[irq]++;
+#ifdef CONFIG_HAVE_DYN_ARRAY
+	kstat_irqs_this_cpu(desc)++;
+#else
+	kstat_irqs_this_cpu(irq)++;
+#endif
 
 	/*
 	 * If its disabled or no action available
@@ -392,7 +412,6 @@ out_unlock:
 void
 handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc)
 {
-	unsigned int cpu = smp_processor_id();
 	struct irqaction *action;
 	irqreturn_t action_ret;
 
@@ -402,7 +421,11 @@ handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc)
 		goto out;
 
 	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
-	kstat_cpu(cpu).irqs[irq]++;
+#ifdef CONFIG_HAVE_DYN_ARRAY
+	kstat_irqs_this_cpu(desc)++;
+#else
+	kstat_irqs_this_cpu(irq)++;
+#endif
 
 	/*
 	 * If its disabled or no action available
@@ -451,8 +474,6 @@ out:
 void
 handle_edge_irq(unsigned int irq, struct irq_desc *desc)
 {
-	const unsigned int cpu = smp_processor_id();
-
 	spin_lock(&desc->lock);
 
 	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
@@ -468,8 +489,11 @@ handle_edge_irq(unsigned int irq, struct irq_desc *desc)
 		mask_ack_irq(desc, irq);
 		goto out_unlock;
 	}
-
-	kstat_cpu(cpu).irqs[irq]++;
+#ifdef CONFIG_HAVE_DYN_ARRAY
+	kstat_irqs_this_cpu(desc)++;
+#else
+	kstat_irqs_this_cpu(irq)++;
+#endif
 
 	/* Start handling the irq */
 	desc->chip->ack(irq);
@@ -524,7 +548,11 @@ handle_percpu_irq(unsigned int irq, struct irq_desc *desc)
 {
 	irqreturn_t action_ret;
 
-	kstat_this_cpu.irqs[irq]++;
+#ifdef CONFIG_HAVE_DYN_ARRAY
+	kstat_irqs_this_cpu(desc)++;
+#else
+	kstat_irqs_this_cpu(irq)++;
+#endif
 
 	if (desc->chip->ack)
 		desc->chip->ack(irq);
@@ -544,14 +572,13 @@ __set_irq_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
 	struct irq_desc *desc;
 	unsigned long flags;
 
-	if (irq >= NR_IRQS) {
+	desc = irq_to_desc(irq);
+	if (!desc) {
 		printk(KERN_ERR
 		       "Trying to install type control for IRQ%d\n", irq);
 		return;
 	}
 
-	desc = irq_desc + irq;
-
 	if (!handle)
 		handle = handle_bad_irq;
 	else if (desc->chip == &no_irq_chip) {
@@ -609,14 +636,13 @@ void __init set_irq_noprobe(unsigned int irq)
 	struct irq_desc *desc;
 	unsigned long flags;
 
-	if (irq >= NR_IRQS) {
+	desc = irq_to_desc(irq);
+	if (!desc) {
 		printk(KERN_ERR "Trying to mark IRQ%d non-probeable\n", irq);
 
 		return;
 	}
 
-	desc = irq_desc + irq;
-
 	spin_lock_irqsave(&desc->lock, flags);
 	desc->status |= IRQ_NOPROBE;
 	spin_unlock_irqrestore(&desc->lock, flags);
@@ -627,14 +653,13 @@ void __init set_irq_probe(unsigned int irq)
 	struct irq_desc *desc;
 	unsigned long flags;
 
-	if (irq >= NR_IRQS) {
+	desc = irq_to_desc(irq);
+	if (!desc) {
 		printk(KERN_ERR "Trying to mark IRQ%d probeable\n", irq);
 
 		return;
 	}
 
-	desc = irq_desc + irq;
-
 	spin_lock_irqsave(&desc->lock, flags);
 	desc->status &= ~IRQ_NOPROBE;
 	spin_unlock_irqrestore(&desc->lock, flags);
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 5fa6198..fb6bdb6 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -18,6 +18,11 @@
 
 #include "internals.h"
 
+/*
+ * lockdep: we want to handle all irq_desc locks as a single lock-class:
+ */
+static struct lock_class_key irq_desc_lock_class;
+
 /**
  * handle_bad_irq - handle spurious and unhandled irqs
  * @irq:       the interrupt number
@@ -29,7 +34,11 @@ void
 handle_bad_irq(unsigned int irq, struct irq_desc *desc)
 {
 	print_irq_desc(irq, desc);
-	kstat_this_cpu.irqs[irq]++;
+#ifdef CONFIG_HAVE_DYN_ARRAY
+	kstat_irqs_this_cpu(desc)++;
+#else
+	kstat_irqs_this_cpu(irq)++;
+#endif
 	ack_bad_irq(irq);
 }
 
@@ -47,6 +56,197 @@ handle_bad_irq(unsigned int irq, struct irq_desc *desc)
  *
  * Controller mappings for all interrupt sources:
  */
+int nr_irqs = NR_IRQS;
+EXPORT_SYMBOL_GPL(nr_irqs);
+
+#ifdef CONFIG_HAVE_DYN_ARRAY
+static struct irq_desc irq_desc_init = {
+	.irq = -1U,
+	.status = IRQ_DISABLED,
+	.chip = &no_irq_chip,
+	.handle_irq = handle_bad_irq,
+	.depth = 1,
+	.lock = __SPIN_LOCK_UNLOCKED(irq_desc_init.lock),
+#ifdef CONFIG_SMP
+	.affinity = CPU_MASK_ALL
+#endif
+};
+
+
+static void init_one_irq_desc(struct irq_desc *desc)
+{
+	memcpy(desc, &irq_desc_init, sizeof(struct irq_desc));
+	lockdep_set_class(&desc->lock, &irq_desc_lock_class);
+}
+
+extern int after_bootmem;
+extern void *__alloc_bootmem_nopanic(unsigned long size,
+			     unsigned long align,
+			     unsigned long goal);
+
+static void init_kstat_irqs(struct irq_desc *desc, int nr_desc, int nr)
+{
+	unsigned long bytes, total_bytes;
+	char *ptr;
+	int i;
+	unsigned long phys;
+
+	/* Compute how many bytes we need per irq and allocate them */
+	bytes = nr * sizeof(unsigned int);
+	total_bytes = bytes * nr_desc;
+	if (after_bootmem)
+		ptr = kzalloc(total_bytes, GFP_ATOMIC);
+	else
+		ptr = __alloc_bootmem_nopanic(total_bytes, PAGE_SIZE, 0);
+
+	if (!ptr)
+		panic(" can not allocate kstat_irqs\n");
+
+	phys = __pa(ptr);
+	printk(KERN_DEBUG "kstat_irqs ==> [%#lx - %#lx]\n", phys, phys + total_bytes);
+
+	for (i = 0; i < nr_desc; i++) {
+		desc[i].kstat_irqs = (unsigned int *)ptr;
+		ptr += bytes;
+	}
+}
+
+#ifdef CONFIG_HAVE_SPARSE_IRQ
+/*
+ * Protect the sparse_irqs_free freelist:
+ */
+static DEFINE_SPINLOCK(sparse_irq_lock);
+static struct irq_desc *sparse_irqs_free;
+struct irq_desc *sparse_irqs;
+#endif
+
+static void __init init_work(void *data)
+{
+	struct dyn_array *da = data;
+	int i;
+	struct  irq_desc *desc;
+
+	desc = *da->name;
+
+	for (i = 0; i < *da->nr; i++) {
+		init_one_irq_desc(&desc[i]);
+#ifndef CONFIG_HAVE_SPARSE_IRQ
+		desc[i].irq = i;
+#endif
+	}
+
+	/* init kstat_irqs, nr_cpu_ids is ready already */
+	init_kstat_irqs(desc, *da->nr, nr_cpu_ids);
+
+#ifdef CONFIG_HAVE_SPARSE_IRQ
+	for (i = 1; i < *da->nr; i++)
+		desc[i-1].next = &desc[i];
+
+	sparse_irqs_free = sparse_irqs;
+	sparse_irqs = NULL;
+#endif
+}
+
+#ifdef CONFIG_HAVE_SPARSE_IRQ
+static int nr_irq_desc = 32;
+
+static int __init parse_nr_irq_desc(char *arg)
+{
+	if (arg)
+		nr_irq_desc = simple_strtoul(arg, NULL, 0);
+	return 0;
+}
+
+early_param("nr_irq_desc", parse_nr_irq_desc);
+
+DEFINE_DYN_ARRAY(sparse_irqs, sizeof(struct irq_desc), nr_irq_desc, PAGE_SIZE, init_work);
+
+struct irq_desc *irq_to_desc(unsigned int irq)
+{
+	struct irq_desc *desc;
+
+	desc = sparse_irqs;
+	while (desc) {
+		if (desc->irq == irq)
+			return desc;
+
+		desc = desc->next;
+	}
+	return NULL;
+}
+
+struct irq_desc *irq_to_desc_alloc(unsigned int irq)
+{
+	struct irq_desc *desc, *desc_pri;
+	unsigned long flags;
+	int count = 0;
+	int i;
+
+	desc_pri = desc = sparse_irqs;
+	while (desc) {
+		if (desc->irq == irq)
+			return desc;
+
+		desc_pri = desc;
+		desc = desc->next;
+		count++;
+	}
+
+	spin_lock_irqsave(&sparse_irq_lock, flags);
+	/*
+	 *  we run out of pre-allocate ones, allocate more
+	 */
+	if (!sparse_irqs_free) {
+		unsigned long phys;
+		unsigned long total_bytes;
+
+		printk(KERN_DEBUG "try to get more irq_desc %d\n", nr_irq_desc);
+
+		total_bytes = sizeof(struct irq_desc) * nr_irq_desc;
+		if (after_bootmem)
+			desc = kzalloc(total_bytes, GFP_ATOMIC);
+		else
+			desc = __alloc_bootmem_nopanic(total_bytes, PAGE_SIZE, 0);
+
+		if (!desc)
+			panic("please boot with nr_irq_desc= %d\n", count * 2);
+
+		phys = __pa(desc);
+		printk(KERN_DEBUG "irq_desc ==> [%#lx - %#lx]\n", phys, phys + total_bytes);
+
+		for (i = 0; i < nr_irq_desc; i++)
+			init_one_irq_desc(&desc[i]);
+
+		for (i = 1; i < nr_irq_desc; i++)
+			desc[i-1].next = &desc[i];
+
+		/* init kstat_irqs, nr_cpu_ids is ready already */
+		init_kstat_irqs(desc, nr_irq_desc, nr_cpu_ids);
+
+		sparse_irqs_free = desc;
+	}
+
+	desc = sparse_irqs_free;
+	sparse_irqs_free = sparse_irqs_free->next;
+	desc->next = NULL;
+	if (desc_pri)
+		desc_pri->next = desc;
+	else
+		sparse_irqs = desc;
+	desc->irq = irq;
+
+	spin_unlock_irqrestore(&sparse_irq_lock, flags);
+
+	return desc;
+}
+#else
+struct irq_desc *irq_desc;
+DEFINE_DYN_ARRAY(irq_desc, sizeof(struct irq_desc), nr_irqs, PAGE_SIZE, init_work);
+
+#endif
+
+#else
+
 struct irq_desc irq_desc[NR_IRQS] __cacheline_aligned_in_smp = {
 	[0 ... NR_IRQS-1] = {
 		.status = IRQ_DISABLED,
@@ -60,13 +260,32 @@ struct irq_desc irq_desc[NR_IRQS] __cacheline_aligned_in_smp = {
 	}
 };
 
+#endif
+
+#ifndef CONFIG_HAVE_SPARSE_IRQ
+struct irq_desc *irq_to_desc(unsigned int irq)
+{
+	if (irq < nr_irqs)
+		return &irq_desc[irq];
+
+	return NULL;
+}
+struct irq_desc *irq_to_desc_alloc(unsigned int irq)
+{
+	return irq_to_desc(irq);
+}
+#endif
+
 /*
  * What should we do if we get a hw irq event on an illegal vector?
  * Each architecture has to answer this themself.
  */
 static void ack_bad(unsigned int irq)
 {
-	print_irq_desc(irq, irq_desc + irq);
+	struct irq_desc *desc;
+
+	desc = irq_to_desc(irq);
+	print_irq_desc(irq, desc);
 	ack_bad_irq(irq);
 }
 
@@ -131,8 +350,6 @@ irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
 	irqreturn_t ret, retval = IRQ_NONE;
 	unsigned int status = 0;
 
-	handle_dynamic_tick(action);
-
 	if (!(action->flags & IRQF_DISABLED))
 		local_irq_enable_in_hardirq();
 
@@ -165,11 +382,15 @@ irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
  */
 unsigned int __do_IRQ(unsigned int irq)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc = irq_to_desc(irq);
 	struct irqaction *action;
 	unsigned int status;
 
-	kstat_this_cpu.irqs[irq]++;
+#ifdef CONFIG_HAVE_DYN_ARRAY
+	kstat_irqs_this_cpu(desc)++;
+#else
+	kstat_irqs_this_cpu(irq)++;
+#endif
 	if (CHECK_IRQ_PER_CPU(desc->status)) {
 		irqreturn_t action_ret;
 
@@ -256,19 +477,25 @@ out:
 }
 #endif
 
-#ifdef CONFIG_TRACE_IRQFLAGS
-
-/*
- * lockdep: we want to handle all irq_desc locks as a single lock-class:
- */
-static struct lock_class_key irq_desc_lock_class;
 
+#ifdef CONFIG_TRACE_IRQFLAGS
 void early_init_irq_lock_class(void)
 {
+#ifndef CONFIG_HAVE_DYN_ARRAY
 	int i;
 
-	for (i = 0; i < NR_IRQS; i++)
+	for (i = 0; i < nr_irqs; i++)
 		lockdep_set_class(&irq_desc[i].lock, &irq_desc_lock_class);
+#endif
 }
+#endif
 
+#ifdef CONFIG_HAVE_DYN_ARRAY
+unsigned int kstat_irqs_cpu(unsigned int irq, int cpu)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	return desc->kstat_irqs[cpu];
+}
 #endif
+EXPORT_SYMBOL(kstat_irqs_cpu);
+
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index 08a849a..605e88c 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -11,11 +11,11 @@ extern void irq_chip_set_defaults(struct irq_chip *chip);
 extern void compat_irq_chip_set_default_handler(struct irq_desc *desc);
 
 #ifdef CONFIG_PROC_FS
-extern void register_irq_proc(unsigned int irq);
+extern void register_irq_proc(unsigned int irq, struct irq_desc *desc);
 extern void register_handler_proc(unsigned int irq, struct irqaction *action);
 extern void unregister_handler_proc(unsigned int irq, struct irqaction *action);
 #else
-static inline void register_irq_proc(unsigned int irq) { }
+static inline void register_irq_proc(unsigned int irq, struct irq_desc *desc) { }
 static inline void register_handler_proc(unsigned int irq,
 					 struct irqaction *action) { }
 static inline void unregister_handler_proc(unsigned int irq,
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 60c49e3..3fcb9cd 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -31,10 +31,10 @@ cpumask_t irq_default_affinity = CPU_MASK_ALL;
  */
 void synchronize_irq(unsigned int irq)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned int status;
 
-	if (irq >= NR_IRQS)
+	if (!desc)
 		return;
 
 	do {
@@ -64,7 +64,7 @@ EXPORT_SYMBOL(synchronize_irq);
  */
 int irq_can_set_affinity(unsigned int irq)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc = irq_to_desc(irq);
 
 	if (CHECK_IRQ_PER_CPU(desc->status) || !desc->chip ||
 	    !desc->chip->set_affinity)
@@ -81,18 +81,17 @@ int irq_can_set_affinity(unsigned int irq)
  */
 int irq_set_affinity(unsigned int irq, cpumask_t cpumask)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc = irq_to_desc(irq);
 
 	if (!desc->chip->set_affinity)
 		return -EINVAL;
 
-	set_balance_irq_affinity(irq, cpumask);
-
 #ifdef CONFIG_GENERIC_PENDING_IRQ
-	if (desc->status & IRQ_MOVE_PCNTXT) {
+	if (desc->status & IRQ_MOVE_PCNTXT || desc->status & IRQ_DISABLED) {
 		unsigned long flags;
 
 		spin_lock_irqsave(&desc->lock, flags);
+		desc->affinity = cpumask;
 		desc->chip->set_affinity(irq, cpumask);
 		spin_unlock_irqrestore(&desc->lock, flags);
 	} else
@@ -111,16 +110,17 @@ int irq_set_affinity(unsigned int irq, cpumask_t cpumask)
 int irq_select_affinity(unsigned int irq)
 {
 	cpumask_t mask;
+	struct irq_desc *desc;
 
 	if (!irq_can_set_affinity(irq))
 		return 0;
 
 	cpus_and(mask, cpu_online_map, irq_default_affinity);
 
-	irq_desc[irq].affinity = mask;
-	irq_desc[irq].chip->set_affinity(irq, mask);
+	desc = irq_to_desc(irq);
+	desc->affinity = mask;
+	desc->chip->set_affinity(irq, mask);
 
-	set_balance_irq_affinity(irq, mask);
 	return 0;
 }
 #endif
@@ -140,10 +140,11 @@ int irq_select_affinity(unsigned int irq)
  */
 void disable_irq_nosync(unsigned int irq)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc;
 	unsigned long flags;
 
-	if (irq >= NR_IRQS)
+	desc = irq_to_desc(irq);
+	if (!desc)
 		return;
 
 	spin_lock_irqsave(&desc->lock, flags);
@@ -169,9 +170,10 @@ EXPORT_SYMBOL(disable_irq_nosync);
  */
 void disable_irq(unsigned int irq)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc;
 
-	if (irq >= NR_IRQS)
+	desc = irq_to_desc(irq);
+	if (!desc)
 		return;
 
 	disable_irq_nosync(irq);
@@ -211,10 +213,11 @@ static void __enable_irq(struct irq_desc *desc, unsigned int irq)
  */
 void enable_irq(unsigned int irq)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc;
 	unsigned long flags;
 
-	if (irq >= NR_IRQS)
+	desc = irq_to_desc(irq);
+	if (!desc)
 		return;
 
 	spin_lock_irqsave(&desc->lock, flags);
@@ -225,7 +228,7 @@ EXPORT_SYMBOL(enable_irq);
 
 int set_irq_wake_real(unsigned int irq, unsigned int on)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc = irq_to_desc(irq);
 	int ret = -ENXIO;
 
 	if (desc->chip->set_wake)
@@ -248,7 +251,7 @@ int set_irq_wake_real(unsigned int irq, unsigned int on)
  */
 int set_irq_wake(unsigned int irq, unsigned int on)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long flags;
 	int ret = 0;
 
@@ -288,12 +291,17 @@ EXPORT_SYMBOL(set_irq_wake);
  */
 int can_request_irq(unsigned int irq, unsigned long irqflags)
 {
+	struct irq_desc *desc;
 	struct irqaction *action;
 
-	if (irq >= NR_IRQS || irq_desc[irq].status & IRQ_NOREQUEST)
+	desc = irq_to_desc(irq);
+	if (!desc)
 		return 0;
 
-	action = irq_desc[irq].action;
+	if (desc->status & IRQ_NOREQUEST)
+		return 0;
+
+	action = desc->action;
 	if (action)
 		if (irqflags & action->flags & IRQF_SHARED)
 			action = NULL;
@@ -343,14 +351,15 @@ static int __irq_set_trigger(struct irq_chip *chip, unsigned int irq,
  */
 int setup_irq(unsigned int irq, struct irqaction *new)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc;
 	struct irqaction *old, **p;
 	const char *old_name = NULL;
 	unsigned long flags;
 	int shared = 0;
 	int ret;
 
-	if (irq >= NR_IRQS)
+	desc = irq_to_desc(irq);
+	if (!desc)
 		return -EINVAL;
 
 	if (desc->chip == &no_irq_chip)
@@ -464,7 +473,7 @@ int setup_irq(unsigned int irq, struct irqaction *new)
 	spin_unlock_irqrestore(&desc->lock, flags);
 
 	new->irq = irq;
-	register_irq_proc(irq);
+	register_irq_proc(irq, desc);
 	new->dir = NULL;
 	register_handler_proc(irq, new);
 
@@ -504,10 +513,11 @@ void free_irq(unsigned int irq, void *dev_id)
 	unsigned long flags;
 
 	WARN_ON(in_interrupt());
-	if (irq >= NR_IRQS)
+
+	desc = irq_to_desc(irq);
+	if (!desc)
 		return;
 
-	desc = irq_desc + irq;
 	spin_lock_irqsave(&desc->lock, flags);
 	p = &desc->action;
 	for (;;) {
@@ -603,6 +613,7 @@ int request_irq(unsigned int irq, irq_handler_t handler,
 {
 	struct irqaction *action;
 	int retval;
+	struct irq_desc *desc;
 
 #ifdef CONFIG_LOCKDEP
 	/*
@@ -618,9 +629,12 @@ int request_irq(unsigned int irq, irq_handler_t handler,
 	 */
 	if ((irqflags & IRQF_SHARED) && !dev_id)
 		return -EINVAL;
-	if (irq >= NR_IRQS)
+
+	desc = irq_to_desc(irq);
+	if (!desc)
 		return -EINVAL;
-	if (irq_desc[irq].status & IRQ_NOREQUEST)
+
+	if (desc->status & IRQ_NOREQUEST)
 		return -EINVAL;
 	if (!handler)
 		return -EINVAL;
diff --git a/kernel/irq/migration.c b/kernel/irq/migration.c
index 77b7acc..90b920d 100644
--- a/kernel/irq/migration.c
+++ b/kernel/irq/migration.c
@@ -3,18 +3,18 @@
 
 void set_pending_irq(unsigned int irq, cpumask_t mask)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long flags;
 
 	spin_lock_irqsave(&desc->lock, flags);
 	desc->status |= IRQ_MOVE_PENDING;
-	irq_desc[irq].pending_mask = mask;
+	desc->pending_mask = mask;
 	spin_unlock_irqrestore(&desc->lock, flags);
 }
 
 void move_masked_irq(int irq)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc = irq_to_desc(irq);
 	cpumask_t tmp;
 
 	if (likely(!(desc->status & IRQ_MOVE_PENDING)))
@@ -30,7 +30,7 @@ void move_masked_irq(int irq)
 
 	desc->status &= ~IRQ_MOVE_PENDING;
 
-	if (unlikely(cpus_empty(irq_desc[irq].pending_mask)))
+	if (unlikely(cpus_empty(desc->pending_mask)))
 		return;
 
 	if (!desc->chip->set_affinity)
@@ -38,7 +38,7 @@ void move_masked_irq(int irq)
 
 	assert_spin_locked(&desc->lock);
 
-	cpus_and(tmp, irq_desc[irq].pending_mask, cpu_online_map);
+	cpus_and(tmp, desc->pending_mask, cpu_online_map);
 
 	/*
 	 * If there was a valid mask to work with, please
@@ -55,12 +55,12 @@ void move_masked_irq(int irq)
 	if (likely(!cpus_empty(tmp))) {
 		desc->chip->set_affinity(irq,tmp);
 	}
-	cpus_clear(irq_desc[irq].pending_mask);
+	cpus_clear(desc->pending_mask);
 }
 
 void move_native_irq(int irq)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc = irq_to_desc(irq);
 
 	if (likely(!(desc->status & IRQ_MOVE_PENDING)))
 		return;
diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index a09dd29..bc0993d 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -19,7 +19,7 @@ static struct proc_dir_entry *root_irq_dir;
 
 static int irq_affinity_proc_show(struct seq_file *m, void *v)
 {
-	struct irq_desc *desc = irq_desc + (long)m->private;
+	struct irq_desc *desc = irq_to_desc((long)m->private);
 	cpumask_t *mask = &desc->affinity;
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
@@ -43,7 +43,7 @@ static ssize_t irq_affinity_proc_write(struct file *file,
 	cpumask_t new_value;
 	int err;
 
-	if (!irq_desc[irq].chip->set_affinity || no_irq_affinity ||
+	if (!irq_to_desc(irq)->chip->set_affinity || no_irq_affinity ||
 	    irq_balancing_disabled(irq))
 		return -EIO;
 
@@ -132,20 +132,20 @@ static const struct file_operations default_affinity_proc_fops = {
 static int irq_spurious_read(char *page, char **start, off_t off,
 				  int count, int *eof, void *data)
 {
-	struct irq_desc *d = &irq_desc[(long) data];
+	struct irq_desc *desc = irq_to_desc((long) data);
 	return sprintf(page, "count %u\n"
 			     "unhandled %u\n"
 			     "last_unhandled %u ms\n",
-			d->irq_count,
-			d->irqs_unhandled,
-			jiffies_to_msecs(d->last_unhandled));
+			desc->irq_count,
+			desc->irqs_unhandled,
+			jiffies_to_msecs(desc->last_unhandled));
 }
 
 #define MAX_NAMELEN 128
 
 static int name_unique(unsigned int irq, struct irqaction *new_action)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc = irq_to_desc(irq);
 	struct irqaction *action;
 	unsigned long flags;
 	int ret = 1;
@@ -165,8 +165,9 @@ static int name_unique(unsigned int irq, struct irqaction *new_action)
 void register_handler_proc(unsigned int irq, struct irqaction *action)
 {
 	char name [MAX_NAMELEN];
+	struct irq_desc *desc = irq_to_desc(irq);
 
-	if (!irq_desc[irq].dir || action->dir || !action->name ||
+	if (!desc->dir || action->dir || !action->name ||
 					!name_unique(irq, action))
 		return;
 
@@ -174,36 +175,34 @@ void register_handler_proc(unsigned int irq, struct irqaction *action)
 	snprintf(name, MAX_NAMELEN, "%s", action->name);
 
 	/* create /proc/irq/1234/handler/ */
-	action->dir = proc_mkdir(name, irq_desc[irq].dir);
+	action->dir = proc_mkdir(name, desc->dir);
 }
 
 #undef MAX_NAMELEN
 
 #define MAX_NAMELEN 10
 
-void register_irq_proc(unsigned int irq)
+void register_irq_proc(unsigned int irq, struct irq_desc *desc)
 {
 	char name [MAX_NAMELEN];
 	struct proc_dir_entry *entry;
 
-	if (!root_irq_dir ||
-		(irq_desc[irq].chip == &no_irq_chip) ||
-			irq_desc[irq].dir)
+	if (!root_irq_dir || (desc->chip == &no_irq_chip) || desc->dir)
 		return;
 
 	memset(name, 0, MAX_NAMELEN);
 	sprintf(name, "%d", irq);
 
 	/* create /proc/irq/1234 */
-	irq_desc[irq].dir = proc_mkdir(name, root_irq_dir);
+	desc->dir = proc_mkdir(name, root_irq_dir);
 
 #ifdef CONFIG_SMP
 	/* create /proc/irq/<irq>/smp_affinity */
-	proc_create_data("smp_affinity", 0600, irq_desc[irq].dir,
+	proc_create_data("smp_affinity", 0600, desc->dir,
 			 &irq_affinity_proc_fops, (void *)(long)irq);
 #endif
 
-	entry = create_proc_entry("spurious", 0444, irq_desc[irq].dir);
+	entry = create_proc_entry("spurious", 0444, desc->dir);
 	if (entry) {
 		entry->data = (void *)(long)irq;
 		entry->read_proc = irq_spurious_read;
@@ -214,8 +213,10 @@ void register_irq_proc(unsigned int irq)
 
 void unregister_handler_proc(unsigned int irq, struct irqaction *action)
 {
-	if (action->dir)
-		remove_proc_entry(action->dir->name, irq_desc[irq].dir);
+	if (action->dir) {
+		struct irq_desc *desc = irq_to_desc(irq);
+		remove_proc_entry(action->dir->name, desc->dir);
+	}
 }
 
 void register_default_affinity_proc(void)
@@ -228,7 +229,8 @@ void register_default_affinity_proc(void)
 
 void init_irq_proc(void)
 {
-	int i;
+	unsigned int irq;
+	struct irq_desc *desc;
 
 	/* create /proc/irq */
 	root_irq_dir = proc_mkdir("irq", NULL);
@@ -240,7 +242,7 @@ void init_irq_proc(void)
 	/*
 	 * Create entries for all existing IRQs.
 	 */
-	for (i = 0; i < NR_IRQS; i++)
-		register_irq_proc(i);
+	for_each_irq_desc(irq, desc)
+		register_irq_proc(irq, desc);
 }
 
diff --git a/kernel/irq/resend.c b/kernel/irq/resend.c
index a804679..89c7117 100644
--- a/kernel/irq/resend.c
+++ b/kernel/irq/resend.c
@@ -33,10 +33,10 @@ static void resend_irqs(unsigned long arg)
 	struct irq_desc *desc;
 	int irq;
 
-	while (!bitmap_empty(irqs_resend, NR_IRQS)) {
-		irq = find_first_bit(irqs_resend, NR_IRQS);
+	while (!bitmap_empty(irqs_resend, nr_irqs)) {
+		irq = find_first_bit(irqs_resend, nr_irqs);
 		clear_bit(irq, irqs_resend);
-		desc = irq_desc + irq;
+		desc = irq_to_desc(irq);
 		local_irq_disable();
 		desc->handle_irq(irq, desc);
 		local_irq_enable();
diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index c66d3f1..ec5a4be 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -12,83 +12,123 @@
 #include <linux/kallsyms.h>
 #include <linux/interrupt.h>
 #include <linux/moduleparam.h>
+#include <linux/timer.h>
 
 static int irqfixup __read_mostly;
 
+#define POLL_SPURIOUS_IRQ_INTERVAL (HZ/10)
+static void poll_spurious_irqs(unsigned long dummy);
+static DEFINE_TIMER(poll_spurious_irq_timer, poll_spurious_irqs, 0, 0);
+
 /*
  * Recovery handler for misrouted interrupts.
  */
-static int misrouted_irq(int irq)
+static int try_one_irq(int irq, struct irq_desc *desc)
 {
-	int i;
+	struct irqaction *action;
 	int ok = 0;
 	int work = 0;	/* Did we do work for a real IRQ */
 
-	for (i = 1; i < NR_IRQS; i++) {
-		struct irq_desc *desc = irq_desc + i;
-		struct irqaction *action;
-
-		if (i == irq)	/* Already tried */
-			continue;
-
-		spin_lock(&desc->lock);
-		/* Already running on another processor */
-		if (desc->status & IRQ_INPROGRESS) {
-			/*
-			 * Already running: If it is shared get the other
-			 * CPU to go looking for our mystery interrupt too
-			 */
-			if (desc->action && (desc->action->flags & IRQF_SHARED))
-				desc->status |= IRQ_PENDING;
-			spin_unlock(&desc->lock);
-			continue;
-		}
-		/* Honour the normal IRQ locking */
-		desc->status |= IRQ_INPROGRESS;
-		action = desc->action;
+	spin_lock(&desc->lock);
+	/* Already running on another processor */
+	if (desc->status & IRQ_INPROGRESS) {
+		/*
+		 * Already running: If it is shared get the other
+		 * CPU to go looking for our mystery interrupt too
+		 */
+		if (desc->action && (desc->action->flags & IRQF_SHARED))
+			desc->status |= IRQ_PENDING;
 		spin_unlock(&desc->lock);
+		return ok;
+	}
+	/* Honour the normal IRQ locking */
+	desc->status |= IRQ_INPROGRESS;
+	action = desc->action;
+	spin_unlock(&desc->lock);
 
-		while (action) {
-			/* Only shared IRQ handlers are safe to call */
-			if (action->flags & IRQF_SHARED) {
-				if (action->handler(i, action->dev_id) ==
-						IRQ_HANDLED)
-					ok = 1;
-			}
-			action = action->next;
+	while (action) {
+		/* Only shared IRQ handlers are safe to call */
+		if (action->flags & IRQF_SHARED) {
+			if (action->handler(irq, action->dev_id) ==
+				IRQ_HANDLED)
+				ok = 1;
 		}
-		local_irq_disable();
-		/* Now clean up the flags */
-		spin_lock(&desc->lock);
-		action = desc->action;
+		action = action->next;
+	}
+	local_irq_disable();
+	/* Now clean up the flags */
+	spin_lock(&desc->lock);
+	action = desc->action;
 
+	/*
+	 * While we were looking for a fixup someone queued a real
+	 * IRQ clashing with our walk:
+	 */
+	while ((desc->status & IRQ_PENDING) && action) {
 		/*
-		 * While we were looking for a fixup someone queued a real
-		 * IRQ clashing with our walk:
-		 */
-		while ((desc->status & IRQ_PENDING) && action) {
-			/*
-			 * Perform real IRQ processing for the IRQ we deferred
-			 */
-			work = 1;
-			spin_unlock(&desc->lock);
-			handle_IRQ_event(i, action);
-			spin_lock(&desc->lock);
-			desc->status &= ~IRQ_PENDING;
-		}
-		desc->status &= ~IRQ_INPROGRESS;
-		/*
-		 * If we did actual work for the real IRQ line we must let the
-		 * IRQ controller clean up too
+		 * Perform real IRQ processing for the IRQ we deferred
 		 */
-		if (work && desc->chip && desc->chip->end)
-			desc->chip->end(i);
+		work = 1;
 		spin_unlock(&desc->lock);
+		handle_IRQ_event(irq, action);
+		spin_lock(&desc->lock);
+		desc->status &= ~IRQ_PENDING;
+	}
+	desc->status &= ~IRQ_INPROGRESS;
+	/*
+	 * If we did actual work for the real IRQ line we must let the
+	 * IRQ controller clean up too
+	 */
+	if (work && desc->chip && desc->chip->end)
+		desc->chip->end(irq);
+	spin_unlock(&desc->lock);
+
+	return ok;
+}
+
+static int misrouted_irq(int irq)
+{
+	int i;
+	int ok = 0;
+	struct irq_desc *desc;
+
+	for_each_irq_desc(i, desc) {
+		if (!i)
+			 continue;
+
+		if (i == irq)	/* Already tried */
+			continue;
+
+		if (try_one_irq(i, desc))
+			ok = 1;
 	}
 	/* So the caller can adjust the irq error counts */
 	return ok;
 }
 
+static void poll_spurious_irqs(unsigned long dummy)
+{
+	int i;
+	struct irq_desc *desc;
+
+	for_each_irq_desc(i, desc) {
+		unsigned int status;
+
+		if (!i)
+			 continue;
+
+		/* Racy but it doesn't matter */
+		status = desc->status;
+		barrier();
+		if (!(status & IRQ_SPURIOUS_DISABLED))
+			continue;
+
+		try_one_irq(i, desc);
+	}
+
+	mod_timer(&poll_spurious_irq_timer, jiffies + POLL_SPURIOUS_IRQ_INTERVAL);
+}
+
 /*
  * If 99,900 of the previous 100,000 interrupts have not been handled
  * then assume that the IRQ is stuck in some manner. Drop a diagnostic
@@ -212,6 +252,8 @@ void note_interrupt(unsigned int irq, struct irq_desc *desc,
 		desc->status |= IRQ_DISABLED | IRQ_SPURIOUS_DISABLED;
 		desc->depth++;
 		desc->chip->disable(irq);
+
+		mod_timer(&poll_spurious_irq_timer, jiffies + POLL_SPURIOUS_IRQ_INTERVAL);
 	}
 	desc->irqs_unhandled = 0;
 }
@@ -241,7 +283,7 @@ static int __init irqfixup_setup(char *str)
 
 __setup("irqfixup", irqfixup_setup);
 module_param(irqfixup, int, 0644);
-MODULE_PARM_DESC("irqfixup", "0: No fixup, 1: irqfixup mode 2: irqpoll mode");
+MODULE_PARM_DESC("irqfixup", "0: No fixup, 1: irqfixup mode, 2: irqpoll mode");
 
 static int __init irqpoll_setup(char *str)
 {
