Return-Path: <linux-kernel-owner+w=401wt.eu-S1758587AbXGHXxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758587AbXGHXxT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 19:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752223AbXGHXxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 19:53:11 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40686 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752018AbXGHXxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 19:53:09 -0400
Date: Sun, 8 Jul 2007 16:52:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.22 released
Message-ID: <alpine.LFD.0.999.0707081639370.31544@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


It's out there now (or at least in the process of mirroring out - if you 
don't see everything, give it a bit of time).

Not a whole lot of changes since -rc7: some small architecture changes 
(ppc, mips, blackfin), and most of those are defconfig updates. Various 
driver fixes: new PCI ID's along with some ide, ata and networking fixes 
(for example - the magic wireless libertas ioctl's got removed, they may 
be re-added later, hopefully in a more generic form, but in the meantime 
this doesn't make a release with new interfaces that aren't universally 
liked).

And various random fixes for regressions and other buglets. Mostly really 
small "few-liners"..

The shortlog (appended) is fairly self-explanatory and the diffstat (at 
the very end) also gives a fairly good picture of where the changes are.

The full changelog since 2.6.21 also got uploaded, but quite frankly, I 
wonder if anybody uses those things? I've been uploading them for non-git 
users, but I have a suspicion that any people who want that kind of 
detail have long since learnt to use git, or are following the commit 
mailing lists or equivalent. 

So this is also a heads-up that I'm considering skipping the ChangeLog 
files in the future - the full release ones are so big as to not be very 
easily readable (the full ChangeLog from 2.6.21 is ove ra hundred thousand 
lines, and weighs in at 3.8MB for example), and you really can get much 
better per-subsystem logs from git.

Anybody? Should I make just the shortlogs available instead (I don't save 
those, but I post those for the later -rc's - usually the -rc1 and -rc2's 
are too big for the mailing list, but they are still a lot smaller and 
more readable than the *full* logs are)?

Or do people really want the full logs, and don't use git?

Let me know how you feel. And test the actual release out too, of course!

		Linus

---
Adrian Bunk (4):
      drivers/net/ns83820.c: fix a check-after-use
      [NET]: net/core/netevent.c should #include <net/netevent.h>
      include/linux/kallsyms.h must #include <linux/errno.h>
      DLM must depend on SYSFS

Alan Cox (4):
      ata_generic: Check the right register for the DMA enabled flags
      pata_pdc202xx_old: Correct cable detect logic
      pata_pcmcia: Switch to ata_sff_port_start
      ide: Fix a theoretical Ooops case

Albert Lee (3):
      libata: pata_pdc2027x PLL input clock fix
      libata: remove reading alt_status from ata_hsm_qc_complete()
      ide: pdc202xx_new PLL input clock fix

Alexander Graf (1):
      fix logic error in ipc compat semctl()

Andi Kleen (2):
      Revert HPET resource reservation
      Revert perfctr reservation to 2.6.21 state

Andres Salomon (1):
      GEODE: reboot fixup for geode machines with CS5536 boards

Andrew Morton (1):
      ide: ide_scan_pcibus(): check __pci_register_driver return value

Andrew Sharp (1):
      [MIPS] 64-bit TO_PHYS_MASK macro for RM9000 processors

Andrzej Zaborowski (1):
      [ARM] 4454/1: Use word accesses in Versatile PCI config reads

Atsushi Nemoto (1):
      [MIPS] Add whitelists for checksyscalls.sh

Bartlomiej Zolnierkiewicz (3):
      amd74xx: resume fix
      it821x: fix incorrect SWDMA mask
      qd65xx: fix PIO mode selection

Bjorn Helgaas (1):
      PNP SMCf010 quirk: work around Toshiba Portege 4000 ACPI issues

Chris Dearman (1):
      [MIPS] Fix timer/performance interrupt detection

Christian Krafft (1):
      [POWERPC] Fix PMI breakage in cbe_cbufreq driver

Christoph Lameter (2):
      SLUB: Make lockdep happy by not calling add_partial with interrupts enabled during bootstrap
      slub: remove useless EXPORT_SYMBOL

Chuck Ebbert (1):
      pata_ali: fix UDMA settings

Dan Williams (4):
      libertas: style fixes
      libertas: kill wlan_scan_process_results
      libertas: fix WPA associations by handling ENABLE_RSN correctly
      libertas: remove private ioctls

Dave Jones (1):
      Clean up E7520/7320/7525 quirk printk.

David Brownell (1):
      net/usb/cdc_ether minor sparse cleanup

David Gibson (1):
      [POWERPC] Disable old EMAC driver in arch/powerpc

David Woodhouse (4):
      [JFFS2] Fix readinode failure when read_dnode() detects CRC failure.
      Fix slab redzone alignment
      x86_64: fix headers_install
      Fix use-after-free oops in Bluetooth HID.

Dhananjay Phadke (1):
      RESEND [PATCH 3/3] NetXen: Graceful teardown of interface and hardware upon module unload

Dmitry Torokhov (4):
      Input: i8042 - add HP Pavilion ZT1000 to the MUX blacklist
      Input: atkbd - throttle LED switching
      Input: serio - take drv_mutex in serio_cleanup()
      Input: document some of keycodes

Florian Attenberger (1):
      sata_mv: PCI-ID for Adaptec 1430SA SATA Controller

Hartmut Birr (1):
      V4L/DVB (5822): Fix the return value in ttpci_budget_init()

Henrique de Moraes Holschuh (1):
      Input: add a new EV_SW SW_RADIO event, for radio switches on laptops

Jack Morgenstein (1):
      mlx4_core: Add new Mellanox device IDs

Jarek Poplawski (1):
      [NETPOLL]: Fixups for 'fix soft lockup when removing module'

Jason Wessel (1):
      i386: fix regression, endless loop in ptrace singlestep over an int80

Jeff Garzik (1):
      [libata] sata_nv: undo merge error

Jelle Foks (1):
      V4L/DVB (5816): Cx88-blackbird: fix vidioc_g_tuner never ending list of tuners

Jie Zhang (1):
      Blackfin arch: Add proper -mcpu option according to the cpu and silicon revision configuration

Jing Min Zhao (1):
      [NETFILTER]: nf_conntrack_h323: add checking of out-of-range on choices' index values

Johannes Berg (1):
      [NET] skbuff: remove export of static symbol

Kumar Gala (2):
      gianfar: Fix typo bug introduced by move to udp_hdr()
      [POWERPC] Update defconfigs

Kumba (1):
      [MIPS] Fix include wrapper symbol definitions in IP32 code.

Len Brown (1):
      ACPI: fix acpi_osi=!Linux

Linus Torvalds (4):
      Remove some unused variables
      Remove the blink driver
      Fix permission checking for the new utimensat() system call
      Linux 2.6.22

Loic Prylli (1):
      MTRR: Fix race causing set_mtrr to go into infinite loop

Maciej W. Rozycki (1):
      [MIPS] die(): Properly declare as non-returning

Maik Hampel (1):
      myri10ge: SET_NETDEV_DEV()

Marco Roeland (1):
      Blackfin arch: remove zero-sized include/asm-blackfin/macros.h

Masatake YAMATO (1):
      ide: never called printk statement in ide-taskfile.c::wait_drive_not_busy

Michael Ellerman (1):
      Fix elf_core_dump() when writing arch specific notes (spu coredumps)

Mike Frysinger (1):
      Blackfin arch: update board defconfig files

Oleg Nesterov (1):
      V4L/DVB (5818): CinergyT2: fix flush_workqueue() vs work->func() deadlock

Olof Johansson (1):
      [POWERPC] Uninline and export virq_to_hw() for the pasemi_mac driver

Patrick McHardy (1):
      3c589_cs: fix local_bh_enable warning

Peter Korsgaard (4):
      dm9601: HW header size shouldn't be included in packet length
      usbnet: Zero padding byte if there is tail room in skb
      Update MAINTAINERS for USB network devices
      dm9601: Return 0 from bind() on success

Peter Zijlstra (2):
      mm: fixup /proc/vmstat output
      mm: double mark_page_accessed() in read_cache_page_async()

Qi Yong (1):
      Input: atkbd - use printk_ratelimit for spurious ACK messages

Ralf Baechle (7):
      [MIPS] VSMP: Fix initialization ordering bug.
      [MIPS] AP/SP: Avoid triggering the 34K E125 performance issue
      [MIPS] Change libgcc-style functions from lib-y to obj-y
      [MIPS] SMTC: Fix cut'n'paste bug in Kconfig.debug
      [MIPS] RM7000: Enable ICACHE_REFILLS_WORKAROUND_WAR.
      [MIPS] Add macros to encode processor revisions.
      [MIPS] Fix scheduling latency issue on 24K, 34K and 74K cores

Ralph Campbell (1):
      IPoIB/cm: Partial error clean up unmaps wrong address

Randy Dunlap (1):
      scsi disk help file is not complete

Richard Purdie (1):
      [ARM] 4458/1: pxa: Fix CKEN usage and hence fix pxa suspend/resume

Robert Hancock (1):
      sata_nv: allow changing queue depth

Robin Getz (1):
      Blackfin arch: Fix up remaining printks with proper log levels

Russell King (2):
      [ARM] Fix non-page aligned boot time mappings
      [ARM] always allow dump_stack() to produce a backtrace

Sergei Shtylyov (2):
      hpt366: blacklist MAXTOR STM3320620A for UltraDMA/66
      hpt366: use correct enablebits for HPT36x

Stefan Richter (2):
      firewire: fix async reception on big endian machines
      firewire: add Kconfig help on building both stacks

Tejun Heo (3):
      sata_inic162x: disable LBA48 devices
      libata: add HTS541616J9SA00 to NCQ blacklist
      libata: fix assigned IRQ reporting

Thomas Gleixner (1):
      NTP: remove clock_was_set() call to prevent deadlock

Trent Piepho (1):
      V4L/DVB (5808): Bttv: fix v4l1 breaking the driver

Uwe Koziolek (2):
      libata: PATA-mode fixes for sis_sata
      sis5513: adding PCI-ID

Vivek Goyal (1):
      i386: es7000 build breakage fix

Vlad Yasevich (3):
      SCTP: Fix thinko in sctp_copy_laddrs()
      SCTP: Check to make sure file is valid before setting timeout
      SCTP: Add scope_id validation for link-local binds

Yoann Padioleau (1):
      potential compiler error, irqfunc caller sites update

Zach Brown (1):
      dio: remove bogus refcounting BUG_ON

dhananjay.phadke@gmail.com (2):
      RESEND [PATCH 1/3] NetXen: Fix issue of MSI not working correctly
      RESEND [PATCH 2/3] NetXen: Support per PCI-function interrupt mask registers

maximilian attems (2):
      starfire list alpha as 64 bit arch
      MAINTAINERS new kernel janitors ml

---
 MAINTAINERS                                  |   10 +-
 Makefile                                     |    2 +-
 arch/arm/kernel/traps.c                      |    2 -
 arch/arm/mach-pxa/pxa27x.c                   |    4 +-
 arch/arm/mach-versatile/pci.c                |    5 +-
 arch/arm/mm/mmu.c                            |    4 +-
 arch/blackfin/Kconfig                        |    6 +
 arch/blackfin/Makefile                       |   21 +
 arch/blackfin/configs/BF533-EZKIT_defconfig  |   12 +-
 arch/blackfin/configs/BF533-STAMP_defconfig  |   26 +-
 arch/blackfin/configs/BF537-STAMP_defconfig  |   26 +-
 arch/blackfin/configs/BF561-EZKIT_defconfig  |   12 +-
 arch/blackfin/configs/PNAV-10_defconfig      |   13 +-
 arch/blackfin/kernel/setup.c                 |   18 +-
 arch/blackfin/kernel/traps.c                 |    3 +-
 arch/i386/Kconfig                            |    4 +-
 arch/i386/kernel/acpi/boot.c                 |   21 -
 arch/i386/kernel/cpu/mtrr/main.c             |    4 +
 arch/i386/kernel/cpu/perfctr-watchdog.c      |   35 +-
 arch/i386/kernel/entry.S                     |    8 +-
 arch/i386/kernel/quirks.c                    |    5 +-
 arch/i386/kernel/reboot_fixups.c             |   13 +
 arch/i386/mach-es7000/es7000plat.c           |   48 ++
 arch/mips/Kconfig.debug                      |    2 +-
 arch/mips/kernel/cpu-probe.c                 |   15 +-
 arch/mips/kernel/smp-mt.c                    |    4 +-
 arch/mips/kernel/traps.c                     |    8 +-
 arch/mips/kernel/vpe.c                       |    4 -
 arch/mips/lib/Makefile                       |    2 +-
 arch/powerpc/configs/mpc7448_hpc2_defconfig  |  212 ++---
 arch/powerpc/configs/mpc8272_ads_defconfig   |  293 +++++---
 arch/powerpc/configs/mpc8313_rdb_defconfig   |  310 ++++----
 arch/powerpc/configs/mpc832x_mds_defconfig   |  176 ++---
 arch/powerpc/configs/mpc832x_rdb_defconfig   |  229 +++----
 arch/powerpc/configs/mpc834x_itx_defconfig   |  265 ++++----
 arch/powerpc/configs/mpc834x_itxgp_defconfig |  232 +++---
 arch/powerpc/configs/mpc834x_mds_defconfig   |  195 +++---
 arch/powerpc/configs/mpc836x_mds_defconfig   |  176 ++---
 arch/powerpc/configs/mpc8540_ads_defconfig   |  201 +++---
 arch/powerpc/configs/mpc8544_ds_defconfig    |  193 ++---
 arch/powerpc/configs/mpc8560_ads_defconfig   |  201 +++---
 arch/powerpc/configs/mpc8568mds_defconfig    |  191 ++---
 arch/powerpc/configs/mpc85xx_cds_defconfig   |  206 +++---
 arch/powerpc/configs/mpc8641_hpcn_defconfig  |  200 +++---
 arch/powerpc/configs/mpc866_ads_defconfig    |  213 +++---
 arch/powerpc/configs/mpc885_ads_defconfig    |  222 +++---
 arch/powerpc/kernel/irq.c                    |    6 +
 arch/powerpc/platforms/cell/cbe_cpufreq.c    |   15 +-
 drivers/acpi/osl.c                           |    4 +-
 drivers/ata/Kconfig                          |    5 +
 drivers/ata/ata_generic.c                    |    2 +-
 drivers/ata/libata-core.c                    |    9 +-
 drivers/ata/libata-sff.c                     |    5 +-
 drivers/ata/pata_ali.c                       |    8 +-
 drivers/ata/pata_cs5520.c                    |    5 +
 drivers/ata/pata_pcmcia.c                    |    2 +-
 drivers/ata/pata_pdc2027x.c                  |   11 +-
 drivers/ata/pata_pdc202xx_old.c              |    4 +-
 drivers/ata/pata_sis.c                       |   46 +-
 drivers/ata/sata_inic162x.c                  |    7 +
 drivers/ata/sata_mv.c                        |    3 +
 drivers/ata/sata_nv.c                        |    1 +
 drivers/ata/sata_sis.c                       |   39 +-
 drivers/ata/sis.h                            |    2 +-
 drivers/atm/firestream.c                     |    2 +-
 drivers/firewire/Kconfig                     |   65 +-
 drivers/firewire/fw-ohci.c                   |    6 +-
 drivers/ide/ide-probe.c                      |    4 +-
 drivers/ide/ide-taskfile.c                   |   12 +-
 drivers/ide/legacy/qd65xx.c                  |    3 +-
 drivers/ide/pci/amd74xx.c                    |    8 +-
 drivers/ide/pci/hpt366.c                     |   21 +-
 drivers/ide/pci/it821x.c                     |    3 +-
 drivers/ide/pci/pdc202xx_new.c               |   10 +-
 drivers/ide/pci/sis5513.c                    |    1 +
 drivers/ide/setup-pci.c                      |   10 +-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c      |    4 +-
 drivers/input/keyboard/atkbd.c               |   47 +-
 drivers/input/serio/i8042-x86ia64io.h        |   11 +
 drivers/input/serio/serio.c                  |    2 +
 drivers/media/dvb/cinergyT2/cinergyT2.c      |   66 +-
 drivers/media/dvb/ttpci/budget-core.c        |    2 +-
 drivers/media/video/bt8xx/bttv-driver.c      |   13 +-
 drivers/media/video/cx88/cx88-blackbird.c    |    2 +
 drivers/misc/Kconfig                         |    8 -
 drivers/misc/Makefile                        |    1 -
 drivers/misc/blink.c                         |   45 --
 drivers/net/Kconfig                          |    2 +-
 drivers/net/arm/am79c961a.c                  |    2 +-
 drivers/net/gianfar.c                        |    2 +-
 drivers/net/ixp2000/ixpdev.c                 |    2 +-
 drivers/net/mlx4/main.c                      |    2 +
 drivers/net/myri10ge/myri10ge.c              |    2 +
 drivers/net/netxen/netxen_nic.h              |  180 ++++-
 drivers/net/netxen/netxen_nic_hdr.h          |    2 +
 drivers/net/netxen/netxen_nic_hw.c           |   33 +-
 drivers/net/netxen/netxen_nic_init.c         |   51 +-
 drivers/net/netxen/netxen_nic_main.c         |  177 +++--
 drivers/net/netxen/netxen_nic_phan_reg.h     |   14 +
 drivers/net/ns83820.c                        |    4 +-
 drivers/net/pcmcia/3c589_cs.c                |    2 +-
 drivers/net/sb1250-mac.c                     |    2 +-
 drivers/net/starfire.c                       |    2 +-
 drivers/net/usb/cdc_ether.c                  |    8 +-
 drivers/net/usb/dm9601.c                     |   11 +-
 drivers/net/usb/usbnet.c                     |    9 +-
 drivers/net/wireless/libertas/Makefile       |    2 +-
 drivers/net/wireless/libertas/README         |  275 -------
 drivers/net/wireless/libertas/assoc.c        |   28 +-
 drivers/net/wireless/libertas/cmd.c          |   12 +-
 drivers/net/wireless/libertas/cmdresp.c      |   21 +
 drivers/net/wireless/libertas/hostcmd.h      |    2 +-
 drivers/net/wireless/libertas/ioctl.c        | 1081 --------------------------
 drivers/net/wireless/libertas/main.c         |    8 +-
 drivers/net/wireless/libertas/scan.c         |   51 +-
 drivers/net/wireless/libertas/wext.c         |  152 ----
 drivers/net/wireless/libertas/wext.h         |   45 +-
 drivers/pnp/quirks.c                         |   63 ++-
 drivers/scsi/Kconfig                         |    1 +
 drivers/usb/misc/uss720.c                    |    2 +-
 fs/binfmt_elf.c                              |    7 +-
 fs/direct-io.c                               |    2 +-
 fs/dlm/Kconfig                               |    2 +-
 fs/jffs2/readinode.c                         |   23 +-
 fs/utimes.c                                  |   13 +-
 include/asm-blackfin/processor.h             |    4 +
 include/asm-i386/mach-es7000/mach_apic.h     |    4 +
 include/asm-i386/mach-es7000/mach_mpparse.h  |    6 +
 include/asm-mips/addrspace.h                 |    1 +
 include/asm-mips/cpu.h                       |   11 +
 include/asm-mips/mach-ip32/dma-coherence.h   |    6 +-
 include/asm-mips/mipsregs.h                  |    2 +
 include/asm-mips/ptrace.h                    |    2 +-
 include/asm-mips/unistd.h                    |   16 +
 include/asm-mips/war.h                       |   18 +-
 include/asm-powerpc/irq.h                    |    5 +-
 include/linux/input.h                        |  143 ++--
 include/linux/kallsyms.h                     |    1 +
 include/linux/pci_ids.h                      |    1 +
 ipc/compat.c                                 |    2 +-
 kernel/time/ntp.c                            |    2 -
 mm/filemap.c                                 |    1 -
 mm/slab.c                                    |   32 +-
 mm/slub.c                                    |    9 +-
 mm/vmstat.c                                  |    2 +-
 net/bluetooth/hidp/core.c                    |   18 +-
 net/core/netevent.c                          |    1 +
 net/core/netpoll.c                           |    6 +-
 net/core/skbuff.c                            |    1 -
 net/netfilter/nf_conntrack_h323_asn1.c       |    4 +-
 net/sctp/ipv6.c                              |    4 +
 net/sctp/socket.c                            |   12 +-
 scripts/Makefile.headersinst                 |    2 +-
 sound/arm/pxa2xx-ac97.c                      |    2 +-
 sound/soc/pxa/pxa2xx-ac97.c                  |    2 +-
 155 files changed, 3071 insertions(+), 4118 deletions(-)
 delete mode 100644 drivers/misc/blink.c
 delete mode 100644 drivers/net/wireless/libertas/ioctl.c
 delete mode 100644 include/asm-blackfin/macros.h
