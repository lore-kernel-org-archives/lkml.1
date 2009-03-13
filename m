Return-Path: <linux-kernel-owner+w=401wt.eu-S1754780AbZCMEMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbZCMEMy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 00:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750827AbZCMEMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 00:12:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54266 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750728AbZCMEMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 00:12:41 -0400
Date: Thu, 12 Mar 2009 21:11:50 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.29-rc8
Message-ID: <alpine.LFD.2.00.0903122102510.3940@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This -rc isn't any more interesting than most, although I have to say that 
personally, it was interesting to see that we have actually been hitting a 
Atom CPU errata, and it took some effort from people to hunt it down.  
That was interesting, if only because it's a pretty rare occurrence.

We have a workaround (although not necessarily the final one) for that in 
this -rc, along with a lot of other mostly tiny changes. There's some 
bigger stuff in blackfin (the bulk of which was removals, in the form of 
'drop untested and useless "generic" board file') and some MIPS defconfig 
updates.

The only other non-small patch should be the addition of the at91 IDE 
driver. Other than that it's all pretty small.

In fact, it seems to be stabilizing to the point where I'm hoping that 
we're approaching a final 2.6.29, and this might be the last -rc. We'll 
have to see.

		Linus

---
Adrian Hunter (1):
      mmc: fix data timeout for SEND_EXT_CSD

Alex Chiang (2):
      PCIe: AER: during disable, check subordinate before walking
      PCIe: portdrv: call pci_disable_device during remove

Alexander Duyck (1):
      PCI: Add PCI quirk to disable L0s ASPM state for 82575 and 82598

Alexey Dobriyan (3):
      [WATCHDOG] ks8695_wdt.c: 'CLOCK_TICK_RATE' undeclared
      xtensa: fix compilation somewhat
      devpts: remove graffiti

Alon Bar-Lev (1):
      Blackfin arch: cleanup bfin_sport.h header and export it to userspace

Andrew Klossner (1):
      hwmon: (f75375s) Remove unnecessary and confusing initialization

Atsushi Nemoto (2):
      mtd: physmap: fix NULL pointer dereference in error path
      MIPS: TXx9: update defconfigs

Bartlomiej Zolnierkiewicz (1):
      remove stale comment from <linux/hdreg.h>

Ben Dooks (1):
      mmc: s3cmci: fix s3c2410_dma_config() arguments.

Benjamin Herrenschmidt (2):
      hvc_console: Remove tty->low_latency on pseries backends
      radeonfb/aty128fb: Disable broken early resume hook for PowerBooks

Bernd Schmidt (1):
      Blackfin arch: fix bug - jump_to_zero test case failed on noMPU kernel

Brandon Ehle (1):
      sata_nv: fix module parameter description

Brian Haley (2):
      IPv6: add "disable" module parameter support to ipv6.ko
      SCTP: change sctp_ctl_sock_init() to try IPv4 if IPv6 fails

Brian Maly (1):
      x86: fix DMI on EFI

Chris Mason (1):
      Btrfs: fix spinlock assertions on UP systems

Chris Wilson (4):
      drm/i915: First recheck for an empty fence register.
      drm/i915: Check fence status on every pin.
      drm/i915: Check to see if we've pinned all available fences
      drm/i915: Protect active fences on i915

Christian Lamparter (1):
      p54: fix race condition in memory management

Christoph Hellwig (4):
      jsflash: stop defining MAJOR_NR
      xfs: prevent kernel crash due to corrupted inode log format
      xfs: prevent lockdep false positive in xfs_iget_cache_miss
      xfs: only issues a cache flush on unmount if barriers are enabled

Dan Williams (4):
      md: fix deadlock when stopping arrays
      I/OAT: fail self-test if callback test reaches timeout
      fsldma: fix off by one in dma_halt
      dmatest: fix use after free in dmatest_exit

Daniel Glöckner (1):
      x86, math-emu: fix init_fpu for task != current

Daniel Lezcano (1):
      netns: fix addrconf_ifdown kernel panic

Daniel Mack (2):
      drivers/w1/masters/w1-gpio.c: fix read_bit()
      ds2760_battery.c: fix division by zero

Darrick J. Wong (3):
      lm85: fix the version check that broke adt7468 probing
      lm85: add VRM10 support for adt7468 chip
      hwmon: (lm90) Document support for the MAX6648/6692 chips

Dave Jones (2):
      Revert "[CPUFREQ] Disable sysfs ui for p4-clockmod."
      [CPUFREQ] Add p4-clockmod sysfs-ui removal to feature-removal schedule.

David S. Miller (3):
      sparc64: Fix lost interrupts on sun4u.
      net: Fix missing dev->neigh_setup in register_netdevice().
      vlan: Fix vlan-in-vlan crashes.

Dhaval Giani (1):
      kernel/user.c: fix a memory leak when freeing up non-init usernamespaces users

Dmitry Torokhov (1):
      Input: serio - fix protocol number for TouchIT213

Enrik Berkhan (1):
      Blackfin arch: fix bug - The SPORT_HYS bit is not set for BF561 0.5

Eric Anholt (2):
      drm/i915: Fix bad \n in MTRR failure notice.
      drm/i915: fix 945 fence register writes for fence 8 and above.

Eric Dumazet (1):
      rcu: increment quiescent state counter in ksoftirqd()

Eric Sandeen (1):
      ext4: fix ext4_free_inode() vs. ext4_claim_inode() race

Eric Sesterhenn (1):
      I/OAT: list usage cleanup

Eric W. Biederman (3):
      netns: Fix icmp shutdown.
      tcp: Like icmp use register_pernet_subsys
      netns: Remove net_alive

FUJITA Tomonori (1):
      libata: fix dma_unmap_sg misuse

Faisal Latif (1):
      RDMA/nes: Don't allow userspace QPs to use STag zero

Friedrich Oslage (1):
      sunhme: Fix qfe parent detection.

Gilles Espinasse (1):
      kbuild: remove unused -r option for module-init-tool depmod

Graf Yang (2):
      Blackfin arch: Fix bug - make ksz8893m driver available when bfin_mac is enabled
      Blackfin arch: update default kernel config, select KSZ8893M driver for BF518

Grant Likely (1):
      powerpc/4xx: Enable SERIAL_OF support by default for Virtex platforms

Guennadi Liakhovetski (1):
      powerpc: fix linkstation and storcenter compilation breakage

Hannes Eder (1):
      ide: NULL noise: drivers/ide/ide-*.c

Heiko Carstens (1):
      Fix fixpoint divide exception in acct_update_integrals

Helge Bahmann (1):
      drm: fix double lock typo

Huang Ying (1):
      x86: EFI: Back efi_ioremap with init_memory_mapping instead of FIX_MAP

Ingo Molnar (1):
      x86: work around Fedora-11 x86-32 kernel failures on Intel Atom CPUs

Jarek Poplawski (1):
      pkt_sched: act_police: Fix a rate estimator test.

Jean Delvare (2):
      hwmon: (abituguru3) Fix I/O error handling
      hwmon: (it87) Properly decode -128 degrees C temperature

Jens Axboe (2):
      cciss: remove 30 second initial timeout on controller reset
      block: fix missing bio back/front segment size setting in blk_recount_segments()

Jeremy Higdon (1):
      [IA64] fix PCI DMA flag propagation on SN (Altix) with PICs

Jie Zhang (1):
      Blackfin arch: fix bug - gdb signull case make trunk kernel panic frequently

Jody McIntyre (1):
      trivial: fix bad links in the ext2 and ext3 documentation

Johannes Weiner (1):
      dmaengine: update kerneldoc

Josh Hunt (2):
      kbuild: fix mkspec to cleanup RPM_BUILD_ROOT
      kbuild: fix 'make rpm' when CONFIG_LOCALVERSION_AUTO=y and using SCM tree

Justin P. Mattock (1):
      kbuild: fix C libary confusion in unifdef.c due to getline()

KOSAKI Motohiro (1):
      memcg: use correct scan number at reclaim

Kris Shannon (1):
      Fix kernel NULL pointer dereference in xen-blkfront

Kristian Høgsberg (1):
      drm: Return EINVAL on duplicate objects in execbuffer object list

Kyle McMartin (1):
      i915: add newline to i915_gem_object_pin failure msg

Leann Ogasawara (1):
      x86: add Dell XPS710 reboot quirk

Li Zefan (1):
      vfs: add missing unlock in sget()

Linus Torvalds (2):
      bitmap: fix end condition in bitmap_find_free_region
      Linus 2.6.29-rc8

Lubomir Rintel (1):
      intel-agp: fix a panic with 1M of shared memory, no GTT entries

Luotao Fu (1):
      ipu_idmac: fix spinlock type

Maciej Sosnowski (6):
      I/OAT: add verification for proper APICID_TAG_MAP setting by BIOS
      I/OAT: do not set DCACTRL_CMPL_WRITE_ENABLE for I/OAT ver.3
      I/OAT: fail initialization on zero channels detection
      I/OAT: cancel watchdog before dma remove
      I/OAT: set tcp_dma_copybreak to 256k for I/OAT ver.3
      I/OAT: update driver version and copyright dates

Magnus Damm (1):
      video: deferred io cleanup fix for sh_mobile_lcdcfb

Mark Brown (1):
      mfd: add support for WM8351 revision B

Markus Metzger (2):
      x86, bts: remove bad warning
      x86, pebs: correct qualifier passed to ds_write_config() from ds_request_pebs()

Matt Carlson (1):
      tg3: Fix 5906 link problems

Meelis Roos (2):
      net: fix tokenring license
      tmspci: fix request_irq race

Michael Ellerman (1):
      powerpc/pseries: The RPA PCI hotplug driver depends on EEH

Michael Hennerich (6):
      Blackfin arch: Make IRQ_EPPIx_ERROR naming consistent
      Blackfin arch: Enable Write Back Cache on all Blackfin Boards
      Blackfin arch: PM_BFIN_WAKE_GP: update help
      Blackfin arch: Fix BUG - kernel fails to build in pm.c when allow wakeup fromi standby by GPIO
      Blackfin arch: fix bug - On bf548-ezkit, ethernet fails to work after wakeup from "mem"
      Blackfin arch: SPI_MMC is now mainlined MMC_SPI

Michael Kerrisk (1):
      MAINTAINERS: downgrade support for man-pages

Michael Spang (1):
      acer-wmi: fix regression in backlight detection

Mike Frysinger (10):
      Blackfin arch: drop untested and useless "generic" board file
      Blackfin arch: use common KGDB_TESTS rather than our own KGDB_TESTCASE
      Blackfin arch: fix compile failure when missing the anomaly definition
      Blackfin arch: update anomaly sheets to match latest public info
      Blackfin arch: make sure people do not set the kernel load address too high
      Blackfin arch: mark init_pda as __init as only __init funcs all it
      Blackfin arch: remove spurious dash when dcache is off
      Blackfin arch: add stubs for anomalies 447 and 448
      Blackfin arch: remove duplicated ANOMALY_05000448 ifdef check
      Blackfin arch: disable legacy /proc/scsi/ support by default

Nick Piggin (1):
      fs: new inode i_state corruption fix

Nobuhiro Iwamatsu (1):
      sh: Add media/soc_camera.h to board setup of Renesas AP325RXA

OGAWA Hirofumi (1):
      Fix _fat_bmap() locking

Oleg Nesterov (2):
      copy_process: fix CLONE_PARENT && parent_exec_id interaction
      pipe_rdwr_fasync: fix the error handling to prevent the leak/crash

Pablo Neira Ayuso (1):
      netlink: invert error code in netlink_set_err()

Pantelis Koukousoulas (1):
      drm: fix EDID parser problem with positive/negative hsync/vsync

Patrick McHardy (1):
      bonding: Fix device passed into ->ndo_neigh_setup().

Paul E. McKenney (2):
      idr: make idr_remove_all() do removal -before- free_layer()
      rcu: documentation 1Q09 update

Peter Korsgaard (1):
      dm9601: new vendor/product IDs

Phil Sutter (2):
      [WATCHDOG] rc32434_wdt: fix watchdog driver
      [WATCHDOG] rc32434_wdt: fix sections

Philippe Gerum (1):
      Blackfin arch:  Update adeos blackfin arch patch to 1.9-00

Phillip Lougher (3):
      Squashfs: Fix oops when reading fsfuzzer corrupted filesystems
      Squashfs: fix documentation typo, Cramfs filesystem limit is 256 MiB
      Squashfs: Valid filesystems are flagged as bad by the corrupted fs patch

Pierre Willenbrock (1):
      drm/i915: Don't restore palettes through VGA registers.

Prakash Punnoor (2):
      pci: don't disable too many HT MSI mapping
      pci: Fix typo in message while disabling HT MSI mapping

Ralf Baechle (2):
      MIPS: compat: Implement is_compat_task.
      MIPS: IP27: Enable RAID5 module

Randy Dunlap (1):
      menu: fix embedded menu snafu

Reinette Chatre (1):
      iwlwifi: fix error flow in iwl*_pci_probe

Renzo Davoli (1):
      UML on UML fixed: it did not start

Robert Hancock (1):
      libata: Don't trust current capacity values in identify words 57-58

Robin Getz (1):
      Blackfin arch: Random read/write errors are a bad thing

Roel Kluin (12):
      net: more timeouts that reach -1
      net pcmcia: worklimit reaches -1
      aoe: error printed 1 too early
      sungem: another error printed one too early
      sparc64: wait_event_interruptible_timeout may return -ERESTARTSYS
      iop-adma, mv_xor: fix mem leak on self-test setup failure
      Squashfs: frag_size should be signed, as it can hold an error result
      loop: don't increment p->offset with (size_t) -EINVAL
      [WATCHDOG] gef_wdt.c: fsl_get_sys_freq() failure not noticed
      ide: expiry() returns int, negative expiry() return values won't be noticed
      cfg80211: test before subtraction on unsigned
      mm: get_nid_for_pfn() returns int

Russell King (1):
      OMAP: enable smc911x support for LDP platform

Rusty Russell (4):
      lguest: fix crash 'unhandled trap 13 at <native_read_msr_safe>'
      lguest: fix for CONFIG_SPARSE_IRQ=y
      cpumask: tsk_cpumask for accessing the struct task_struct's cpus_allowed.
      cpumask: mm_cpumask for accessing the struct mm_struct's cpu_vm_mask.

Samuel CUELLA (1):
      i810: fix kernel crash fix when struct fb_var_screeninfo is supplied

Sergei Shtylyov (2):
      ide-iops: fix odd-length ATAPI PIO transfers
      ata: add CFA specific identify data words

Shinya Kuribayashi (1):
      MIPS: NEC VR5500 processor support fixup

Sonic Zhang (3):
      Blackfin arch: Disable NAND option by default
      Blackfin arch: fix bug - kgdb fails to continue after setting breakpoint on bf561-ezkit kernel with smp patch
      Blackfin arch: Fix bug - KGDB single step into the middle of a 4 bytes instruction on bf561 after soft bp is hit

Stanislaw Gruszka (3):
      ide: allow to wrap interrupt handler
      ide: add at91_ide driver
      AT91: initialize Compact Flash on AT91SAM9263 cpu

Stephen Hemminger (2):
      net: Avoid race between network down and sysfs
      ipv6: Fix sysctl unregistration deadlock

Steven King (2):
      m68knommu: m5206e build fix
      m68knommu: m528x build fix

Stuart Bennett (1):
      x86 mmiotrace: fix remove_kmmio_fault_pages()

Stuart Hayes (1):
      libata: change drive ready wait after hard reset to 5s

Takashi Iwai (2):
      ALSA: hda - Fix typos in slave controls in patch_sigmatel.c
      ALSA: hda - Fix headphone-detect regression with multiple HP jacks

Tejun Heo (3):
      libata: align ap->sector_buf
      libata: don't use on-stack sense buffer
      libata: make sure port is thawed when skipping resets

Tom Parker (1):
      Blackfin arch: fix bug - Error if one serial has hardware flow control and the other doesn't

Tony Breeds (1):
      powerpc: Run sbc610 USB fixup code only on the appropriate platform.

Vlad Yasevich (1):
      sctp: fix crash during module unload

Wei Yongjun (1):
      sctp: fix kernel panic with ERROR chunk containing too many error causes

Will Newton (1):
      mtd_dataflash: fix probing of AT45DB321C chips.

Wim Van Sebroeck (1):
      [WATCHDOG] orion5x_wdt.c: 'ORION5X_TCLK' undeclared

Wu Fengguang (1):
      proc: fix kflags to uflags copying in /proc/kpageflags

Xiaotian Feng (1):
      MIPS: Fix build of non-CONFIG_SYSVIPC version of sys_32_ipc

Xose Vazquez Perez (2):
      rt2x00 : more devices to rt2500usb.c
      rt2x00 : more devices to rt73usb.c

Yinghai Lu (1):
      x86/agp: tighten check to update amd nb aperture

akpm@linux-foundation.org (1):
      uml: fix WARNING: vmlinux: 'memcpy' exported twice

etienne (1):
      smack: fixes for unlabeled host support

peerchen (1):
      ahci: Add the Device IDs for MCP89 and remove IDs of MCP7B to/from ahci.c
