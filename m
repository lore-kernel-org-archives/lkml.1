Return-Path: <linux-kernel-owner+w=401wt.eu-S1755528AbYJJARx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbYJJARx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 20:17:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753375AbYJJARn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 20:17:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50938 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303AbYJJARm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 20:17:42 -0400
Date: Fri, 10 Oct 2008 02:17:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 updates for v2.6.28, phase #9, sparse IRQ support
Message-ID: <20081010001727.GA14132@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-v28-for-linus-phase9 git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-v28-for-linus-phase9

Sparse IRQ support - make NR_IRQS dynamic by turning it into nr_irqs, an 
by creating irq descriptors in a sparse way.

Includes a number of dependent x86 topics: timers/hpet-percpu, IO-APIC 
and local APIC code unification, UV support updates.

Has been cross-built on all architectures we could get crosscompilers 
for:

  http://www.tglx.de/autoqa/index

It should be largely uneventful for sparse-irq unaware, non-x86 
architectures.

out-of-topic modifications in x86-v28-for-linus-phase9:
-------------------------------------------------------
arch/Kconfig                       # f9fd45f: x86: make HAVE_SPARSE_IRQ support
                                   # f2f61d1: generic: sparse irqs: use irq_des
                                   # f4e4080: x86: enable dyn_array support
arch/ia64/kernel/acpi.c            # eada62c: acpi/x86: introduce __apci_map_ta
arch/m68k/kernel/ints.c            # 3af7043: sparseirq: export nr_irqs on m68k
                                   # 9e89c54: irq: introduce nr_irqs
arch/s390/kernel/irq.c             # 3af7043: sparseirq: export nr_irqs on m68k
                                   # 9e89c54: irq: introduce nr_irqs
arch/sparc/kernel/irq.c            # 3af7043: sparseirq: export nr_irqs on m68k
                                   # 9e89c54: irq: introduce nr_irqs
drivers/acpi/osl.c                 # eada62c: acpi/x86: introduce __apci_map_ta
drivers/acpi/tables.c              # eada62c: acpi/x86: introduce __apci_map_ta
drivers/acpi/tables/tbxface.c      # eada62c: acpi/x86: introduce __apci_map_ta
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
include/acpi/acpiosxf.h            # eada62c: acpi/x86: introduce __apci_map_ta
include/acpi/acpixf.h              # eada62c: acpi/x86: introduce __apci_map_ta
include/asm-generic/vmlinux.lds.h  # 28c00bc: add per_cpu_dyn_array support
                                   # 565a0e8: generic: add dyn_array support
include/linux/acpi.h               # eada62c: acpi/x86: introduce __apci_map_ta
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

Cyrill Gorcunov (19):
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
      acpi/x86: introduce __apci_map_table, v4

venkatesh.pallipadi@intel.com (4):
      x86: HPET_MSI change IRQ affinity in process context when it is disabled
      x86: HPET_MSI Refactor code in preparation for HPET_MSI
      x86: HPET_MSI Basic HPET_MSI setup code
      x86: HPET_MSI Initialise per-cpu HPET timers


 arch/Kconfig                                      |    3 +
 arch/ia64/kernel/acpi.c                           |    4 +
 arch/m68k/kernel/ints.c                           |    3 +
 arch/s390/kernel/irq.c                            |    3 +
 arch/sparc/kernel/irq.c                           |    4 +
 arch/x86/Kconfig                                  |   20 +-
 arch/x86/configs/i386_defconfig                   |    1 -
 arch/x86/kernel/Makefile                          |    6 +-
 arch/x86/kernel/acpi/boot.c                       |   20 +-
 arch/x86/kernel/{apic_32.c => apic.c}             |  619 ++++-
 arch/x86/kernel/apic_64.c                         | 1848 -------------
 arch/x86/kernel/bios_uv.c                         |  137 +-
 arch/x86/kernel/cpu/amd.c                         |    2 +-
 arch/x86/kernel/cpu/intel.c                       |    2 +-
 arch/x86/kernel/early-quirks.c                    |    4 +-
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
 drivers/acpi/osl.c                                |   11 +-
 drivers/acpi/tables.c                             |   20 +-
 drivers/acpi/tables/tbxface.c                     |   17 +-
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
 include/acpi/acpiosxf.h                           |    1 +
 include/acpi/acpixf.h                             |    4 +
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
 include/linux/acpi.h                              |    1 +
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
 126 files changed, 4423 insertions(+), 5886 deletions(-)
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

