Return-Path: <linux-kernel-owner+w=401wt.eu-S1754707Ab0AFCsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab0AFCsN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 21:48:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754290Ab0AFCsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 21:48:11 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43713 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751191Ab0AFCsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 21:48:10 -0500
Date: Tue, 5 Jan 2010 18:48:06 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.33-rc3
Message-ID: <alpine.LFD.2.00.1001051838410.3630@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It's been quiet due to the holidays, so -rc3 is reasonably small despite 
being a few days over the normal one-week mark. And most of the changes 
are pretty trivial, although both ext4 and reiserfs had some trouble in 
-rc2, hopefully all fixed now.

The bulk of the patches are some SH defconfig updates (40%), but ignoring 
those we have the normal "half drivers, half everything else" pattern. On 
the driver front, the perhaps most notable change is not so much a code 
change, but the small change of marking the "new" firewire stack as being 
the recommended one.

Wireless drivers, regular network drivers, filesystems, input layer..

And here's to hoping one reason it's been quiet is that it's actually been 
fairly stable. Give it a try,

		Linus

---
Alan Cox (2):
      i2o: propogate the BKL down into the ioctl method
      tosh: Use non bkl ioctl

Alexander Duyck (4):
      igb: do not force pcs link when in KX mode
      igb: do not force retry count to 1 on 82580 phy
      igb: correctly offset 82575 flow control watermarks by 16 bytes
      igb: check both function bits in status register in wol exception

Alexander Graf (1):
      KVM: powerpc: Fix mtsrin in book3s_64 mmu

Andrew Morton (3):
      aoe: switch to the new bio_flush_dcache_pages() interface
      ext4: fix unsigned long long printk warning in super.c
      jbd2: don't use __GFP_NOFAIL in journal_init_common()

Andrey Borzenkov (1):
      orinoco: fix GFP_KERNEL in orinoco_set_key with interrupts disabled

Aneesh Kumar K.V (1):
      ext4: Ensure zeroout blocks have no dirty metadata

Anton Vorontsov (3):
      ucc_geth: Fix empty TX queue processing
      ucc_geth: Fix netdev watchdog triggering on link changes
      ucc_geth: Don't needlessly change MAC settings in adjust_link()

Arnaldo Carvalho de Melo (3):
      perf diff: Fix usage array, it must end with a NULL entry
      perf record: We should fork only if a program was specified to run
      perf tools: Add missing header files to LIB_H Makefile variable

Arnaud Patard (2):
      ARM: S3C24XX: touchscreen device definition
      ARM: S3C24XX: touchscreen device definition

Ben Dooks (3):
      ARM: mach-osiris: add NAND_SCAN_SILENT_NODEV to optional devices
      ARM: mach-bast: add NAND_SCAN_SILENT_NODEV to optional devices
      ARM: S3C: Fix NAND device registration by s3c_nand_set_platdata().

Ben Hutchings (3):
      sfc: Include XGXS in XMAC link status check except in XGMII loopback
      sfc: QT2025C: Add error message for suspected bad SFP+ cables
      sfc: Disable TX descriptor prefetch watchdog

Benjamin Herrenschmidt (2):
      PCI/cardbus: Add a fixup hook and fix powerpc
      ps3_gelic_wireless: Fix build failure due to missing WEXT_PRIV

Benoit Papillault (1):
      ath9k: Last fix for TX software padding.

Bob Copeland (1):
      ath5k: fix SWI calibration interrupt storm

Carlos Corbacho (1):
      ACPI: WMI: Survive BIOS with duplicate GUIDs

Clemens Ladisch (1):
      firewire: fix use of multiple AV/C devices, allow multiple FCP listeners

Csaba Henk (1):
      PCI: Handle case when no pci device can provide cache line size hint

Daisuke HATAYAMA (1):
      binfmt_elf_fdpic: Fix build breakage introduced by coredump changes.

Dan Carpenter (2):
      bond_3ad.c avoid possible null deref
      wl1271_cmd.c: cleanup char => u8

Dan Williams (4):
      ioat3: fix p-disabled q-continuation
      async_tx: expand async raid6 test to cover ioatdma corner case
      ioat2,3: put channel hardware in known state at init
      md: make recovery started by do_md_run() visible via sync_action

Daniel Drake (1):
      Fix MAC address access in 3c507, ibmlana, pcnet32 and libertas

Daniel Mack (1):
      Libertas: fix buffer overflow in lbs_get_essid()

David Howells (1):
      ext4: Don't ask about supporting ext2/3 in ext4 if ext4 is not configured

David S. Miller (3):
      bbc_envctrl: Clean up properly if kthread_run() fails.
      sparc64: Fix NMI programming when perf events are active.
      sparc64: Fix Niagara2 perf event handling.

Denis Kirjanov (1):
      vxge: use DMA_BIT_MASK instead of plain values.

Detlef Riekenberg (1):
      vgaarbiter: fix a typo in the vgaarbiter Documentation

Dexuan Cui (3):
      PCI: support device-specific reset methods
      PCI: add Intel USB specific reset method
      PCI: add Intel 82599 Virtual Function specific reset method

Dmitry Torokhov (8):
      Input: speed up suspend/shutdown for PS/2 mice and keyboards
      Input: serio - do not mark kseriod freezable anymore
      Input: ff-memless - another fix for signed to unsigned overflow
      Input: iforce - fix oops on device disconnect
      Input: matrix-keypad - handle cases when GPIOs can't be wakeup sources
      Input: lifebook - add CONFIG_DMI dependency
      dell-wmi - fix condition to abort driver loading
      Input: iforce - wait for command completion when closing the device

Don Skidmore (1):
      ixgbe: fix Need to call pci_save_state after pci_restore_state

Emese Revfy (1):
      drbd: Constify struct file_operations

Eric Sandeen (2):
      fs-writeback: Add helper function to start writeback if idle
      ext4: flush delalloc blocks when space is low

Eric W. Biederman (1):
      sysfs: Add lockdep annotations for the sysfs active reference

FUJITA Tomonori (2):
      block: remove Documentation/block/as-iosched.txt
      x86/agp: Fix agp_amd64_init() initialization with CONFIG_GART_IOMMU enabled

Fang Wenqi (1):
      ext4: Update documentation to correct the inode_readahead_blks option name

Felipe Balbi (2):
      Input: twl4030_keypad - switch to using threaded IRQ
      Input: twl4030-pwrbutton - switch to using threaded IRQ

Felix Fietkau (2):
      mac80211: fix ibss join with fixed-bssid
      ath9k: fix missed error codes in the tx status check

Frederic Weisbecker (14):
      reiserfs: Fix possible recursive lock
      reiserfs: Fix reiserfs lock and journal lock inversion dependency
      reiserfs: Fix reiserfs lock <-> inode mutex dependency inversion
      reiserfs: Fix remaining in-reclaim-fs <-> reclaim-fs-on locking inversion
      perf: Pass appropriate frame pointer to dump_trace()
      reiserfs: Fix reiserfs lock <-> i_xattr_sem dependency inversion
      reiserfs: Warn on lock relax if taken recursively
      reiserfs: Fix reiserfs lock <-> i_mutex dependency inversion on xattr
      reiserfs: Relax reiserfs lock while freeing the journal
      reiserfs: Relax lock before open xattr dir in reiserfs_xattr_set_handle()
      reiserfs: Fix unwanted recursive reiserfs lock in reiserfs_unlink()
      reiserfs: Fix journal mutex <-> inode mutex lock inversion
      reiserfs: Safely acquire i_mutex from reiserfs_for_each_xattr
      reiserfs: Safely acquire i_mutex from xattr_rmdir

Gertjan van Wingerde (5):
      rt2x00: Fix rt2800usb detection in rt2800lib.
      mac80211: Add define for TX headroom reserved by mac80211 itself.
      rt2x00: Disable powersaving for rt61pci and rt2800pci.
      rt2x00: Fix calculation of rt2800 iveiv entry offset.
      rt2x00: Add USB ID for Linksys WUSB 600N rev 2.

Guennadi Liakhovetski (3):
      sh: fix DMA driver's descriptor chaining and cookie assignment
      ASoC: fix params_rate() macro use in several codecs
      ALSA: Fix indentation in pcm_native.c

Gui Jianfeng (1):
      block: blk_rq_err_sectors cleanup

H Hartley Sweeten (3):
      drivers/block/mg_disk.c: use resource_size()
      Documentation: fix ioremap return type
      DocBook: fix ioremap return type

H. Peter Anvin (1):
      x86, compress: Force i386 instructions for the decompressor

Heiko Carstens (2):
      KVM: get rid of kvm_create_vm() unused label warning on s390
      kprobes: Fix distinct type warning

Henrique de Moraes Holschuh (5):
      thinkpad-acpi: don't take the first ALSA slot by default
      thinkpad-acpi: don't fail to load the entire module due to ALSA problems
      thinkpad-acpi: make volume subdriver optional
      thinkpad-acpi: update volume subdriver documentation
      thinkpad-acpi: improve Kconfig help text

Herbert Xu (1):
      hwrng: core - Fix double unlock in rng_dev_read

Huang Weiyi (3):
      ext4: remove unused #include <linux/version.h>
      drbd: remove duplicated #include
      drbd: remove unused #include <linux/version.h>

Hugh Dickins (1):
      mm: move sys_mmap_pgoff from util.c

Ingo Molnar (2):
      ACPI: fix ACPI=n allmodconfig build
      dma-debug: Fix bug causing build warning

Jamal Hadi Salim (1):
      net: restore ip source validation

James Bottomley (1):
      libsrp: fix compile failure

Jan Glauber (1):
      [S390] qdio: convert global statistics to per-device stats

Jan Kiszka (1):
      KVM: x86: Extend KVM_SET_VCPU_EVENTS with selective updates

Jarek Poplawski (1):
      net/via-rhine: Fix scheduling while atomic bugs

Jari Vanhala (2):
      Input: ff-memless - start playing FF effects immediately
      Input: ff-memless - add notion of direction to for rumble effects

Jaswinder Singh Rajput (1):
      writeback: add missing kernel-doc notation

Jeff Layton (1):
      cifs: NULL out tcon, pSesInfo, and srvTcp pointers when chasing DFS referrals

Jiri Slaby (4):
      PCI: fix section mismatch on update_res()
      SECURITY: selinux, fix update_rlimit_cpu parameter
      resource: move kernel function inside __KERNEL__
      resource: add helpers for fetching rlimits

Jiro SEKIBA (1):
      nilfs2: trivial coding style fix

Joerg Roedel (1):
      x86/amd-iommu: Fix initialization failure panic

Johannes Berg (7):
      iwlwifi: fix EEPROM/OTP reading endian annotations and a bug
      iwlwifi: fix more eeprom endian bugs
      mac80211: fix peer HT capabilities
      mac80211: fix WMM AP settings application
      wireless: remove remaining qual code
      cfg80211: fix race between deauth and assoc response
      cfg80211: fix error path in cfg80211_wext_siwscan

John Fastabend (1):
      pktgen: ndo_start_xmit can return NET_XMIT_xxx values

John Kacur (1):
      sony_pi: Remove the BKL from open and ioctl

John W. Linville (1):
      Revert "b43: Enforce DMA descriptor memory constraints"

Julia Lawall (5):
      drivers/net/wireless: Correct code taking the size of a pointer
      drivers/block/DAC960.c: use DAC960_V2_Controller
      drivers/dma: drop unnecesary memset
      drivers/dma: Correct use after free
      ext4: Eliminate potential double free on error path

Kuninori Morimoto (1):
      ASoC: fsi-ak4642: Remove ak4642_add_i2c_device

Kusanagi Kouichi (1):
      Documentation: Rename Documentation/DMA-mapping.txt

Lai Jiangshan (3):
      tracing/kprobe: Show sign of fields in trace_kprobe format files
      tracing/syscalls: Fix typo in SYSCALL_DEFINE0
      tracing: Fix sign fields in ftrace_define_fields_##call()

Len Brown (4):
      dell-wmi: sys_init_module: 'dell_wmi'->init suspiciously returned 21, it should     follow 0/-E convention
      ACPI: hp-wmi, msi-wmi: clarify that wmi_install_notify_handler() returns an acpi_status
      dell-wmi, hp-wmi, msi-wmi: check wmi_get_event_data() return value
      dell-wmi: sys_init_module: 'dell_wmi'->init suspiciously returned 21, it should follow 0/-E convention

Li Zefan (4):
      ksym_tracer: Fix to make the tracer work
      ksym_tracer: Fix to allow writing newline to ksym_trace_filter
      ksym_tracer: Fix race when incrementing count
      ksym_tracer: Remove trace_stat

Linus Torvalds (3):
      pci: avoid compiler warning in quirks.c
      twl4030-irq.c: fix compiler warning due to raw-spinlock conversion
      Linux 2.6.33-rc3

Luis R. Rodriguez (4):
      ath9k: wake hardware for interface IBSS/AP/Mesh removal
      ath9k: wake hardware during AMPDU TX actions
      mac80211: fix race with suspend and dynamic_ps_disable_work
      mac80211: fix propagation of failed hardware reconfigurations

Manuel Lauss (1):
      ASoC: fixup oops in generic AC97 codec glue

Marcelo Tosatti (2):
      KVM: MMU: remove prefault from invlpg handler
      KVM: LAPIC: make sure IRR bitmap is scanned after vm load

Martin K. Petersen (2):
      block: Fix topology stacking for data and discard alignment
      block: Fix incorrect alignment offset reporting and update documentation

Martin Schwidefsky (1):
      [S390] Update default configuration.

Masami Hiramatsu (1):
      x86: Fix objdump version check in chkobjdump.awk for different formats.

Masanari Iida (1):
      ALSA: Fix a typo in Procfile.txt

Matthew Slattery (3):
      sfc: QT2025C: Work around PHY bug
      sfc: QT2025C: Switch into self-configure mode when not in loopback
      sfc: QT2025C: Work around PHY firmware initialisation bug

Michael Chan (1):
      bnx2x: Initialize cnic status block during chip reset

Mike Travis (2):
      x86: SGI UV: Fix writes to led registers on remote uv hubs
      x86_64 SGI UV: Fix writes to led registers on remote uv hubs.

Neil Turton (1):
      sfc: Fix DMA mapping cleanup in case of an error in TSO

NeilBrown (4):
      md: Fix unfortunate interaction with evms
      md: fix small irregularity with start_ro module parameter
      md: remove unnecessary code from do_md_run
      md: allow a resync that is waiting for other resync to complete, to be aborted.

Nicolas Ferre (1):
      dma: at_hdmac: correct incompatible type for argument 1 of 'spin_lock_bh'

OGAWA Hirofumi (1):
      block: Honor the gfp_mask for alloc_page() in blkdev_issue_discard()

Paul Mundt (4):
      sh: Only provide a PCLK definition for legacy CPG CPUs.
      sh: Disable PMB for SH4AL-DSP CPUs.
      sh: Don't default enable PMB support.
      sh: update defconfigs.

Paul Rolland (2):
      wmi: check find_guid() return value to prevent oops
      wmi: check find_guid() return value to prevent oops

Pekka Enberg (3):
      x86: Use KERN_DEFAULT log-level in __show_regs()
      x86, kmemcheck: Use KERN_WARNING for error reporting
      SLAB: Fix lockdep annotation breakage

Peter Huewe (1):
      ALSA: sound/arm: Fix build failure caused by missing struct aaci definition

Peter Zijlstra (1):
      perf: Fix NULL deref in inheritance code

Rafael J. Wysocki (2):
      PCI/PM: Propagate wake-up enable for PCIe devices too
      PCI: Fix build if quirks are not enabled

Rakib Mullick (1):
      Input: wistron - fix test for CONFIG_PM

Ralf Baechle (1):
      NET: XFRM: Fix spelling of neighbour.

Randy Dunlap (4):
      Documentation: Update mmiotrace.txt
      Documentation: Update tracepoint-analysis.txt
      Documentation: Update ftrace-design.txt
      tracing: Kconfig spelling fixes and cleanups

Reinette Chatre (4):
      iwlwifi: power up all devices for EEPROM read
      iwl3945: disable power save
      iwlwifi: initialize spinlock before use
      iwlwifi: fix 40MHz operation setting on cards that do not allow it

René Bolldorf (1):
      Input: psmouse - fix compile warning in hgpk module

Richard Kennedy (1):
      ext4: return correct wbc.nr_to_write in ext4_da_writepages

Robert P. J. Day (1):
      [S390] Have param.h simply include <asm-generic/param.h>.

Roel Kluin (4):
      drbd: fix test of unsigned in _drbd_fault_random()
      drbd: Fix test of unsigned in _drbd_fault_random()
      iwmc3200wifi: Fix test of unsigned in iwm_ntf_stop_resume_tx()
      wl1251: timeout one too soon in wl1251_boot_run_firmware()

Rolf Eike Beer (1):
      kfifo: Fix typo in comment

Rusty Russell (2):
      lguest: fix bug in setting guest GDT entry
      Revert "x86: Side-step lguest problem by only building cmpxchg8b_emu for pre-Pentium"

Ryusuke Konishi (1):
      nilfs2: update mailing list address

Samuel Ortiz (1):
      libertas: Remove carrier signaling from the scan code

Sandeep Gopalpet (1):
      gianfar: Fix gianfar select_queue bogosity

Sarveshwar Bandi (3):
      be2net: Bug fix to avoid soft lockup in loopback test.
      be2net: Bug fix to config NIC appropriately before loopback test
      be2net: Bug fix to return correct values in ethtool get_settings.

Serge E. Hallyn (1):
      generic_permission: MAY_OPEN is not write access

Shaohua Li (1):
      cfq-iosched: don't regard requests with long distance as close

Shaun Ruffell (1):
      dma-debug: Do not add notifier when dma debugging is disabled.

Sheng Yang (1):
      KVM: Fix possible circular locking in kvm_vm_ioctl_assign_device()

Stefan Assmann (2):
      PCI: change PCI nomenclature in drivers/pci/ (comment changes)
      PCI: change PCI nomenclature in drivers/pci/ (non-comment changes)

Stefan Richter (4):
      firewire: cdev: fix another memory leak in an error path
      firewire: ohci: always use packet-per-buffer mode for isochronous reception
      firewire, ieee1394: update MAINTAINERS entries
      firewire, ieee1394: update Kconfig help

Steve French (1):
      [CIFS] Enable mmap on forcedirectio mounts

Steve Hodgson (1):
      sfc: Move PHY software state initialisation from init() into probe()

Steven Rostedt (1):
      tracing: Fix setting tracer specific options

Sujith (4):
      ath9k: Fix bug in assigning sequence number
      ath9k: Fix TX queue draining
      ath9k: Stop ANI when doing a reset
      ath9k: fix suspend by waking device prior to stop

Surbhi Palande (1):
      ext4: replace BUG() with return -EIO in ext4_ext_get_blocks

Takashi Iwai (4):
      ALSA: hda - Disable tigger at pin-sensing on AD codecs
      ALSA: hda - use snd_hda_jack_detect() again in patch_sigmatel.c
      ALSA: hda - Don't cache beep controls
      ALSA: hda - Fix Oops at reloading beep devices

Tao Ma (1):
      ocfs2: Handle O_DIRECT when writing to a refcounted cluster.

Theodore Ts'o (5):
      ext4: add module aliases for ext2 and ext3
      ext4, jbd2: Add barriers for file systems with exernal journals
      ext4: Patch up how we claim metadata blocks for quota purposes
      ext4: Fix accounting of reserved metadata blocks
      ext4: Calculate metadata requirements more accurately

Tim Blechmann (1):
      perf: Rename perf_event_hw_event in design document

Tobias Klauser (3):
      nilfs2: Storage class should be before const qualifier
      ath9k: Storage class should be before const qualifier
      iwlwifi: Storage class should be before const qualifier

Tony Luck (1):
      KVM: ia64: fix build breakage due to host spinlock change

Vitaliy Gusev (1):
      tun: use tun_sk instead container_of

Vivek Goyal (3):
      cfq-iosched: Remove the check for same cfq group from allow_merge
      cfq-iosched: Get rid of nr_groups
      cfq-iosched: Remove prio_change logic for workload selection

Wenji Huang (1):
      perf kmem: Fix statistics typo

Wey-Yi Guy (1):
      iwlwifi: fix syslog message for event log dump size

Williams, Mitch A (1):
      igbvf: Make igbvf error message more informative

Wu Fengguang (1):
      ALSA: hda - HDMI sticky stream tag support

Zhang Rui (3):
      ACPI video: no warning message if "acpi_backlight=vendor" is used
      ACPI video: correct error-handling code
      ACPI: introduce kernel parameter acpi_sleep=sci_force_enable

Zhu Yi (3):
      iwlwifi: allocated rx page accounting cleanup
      iwl3945: fix panic in iwl3945 driver
      iwmc3200wifi: fix array out-of-boundary access

akpm@linux-foundation.org (1):
      drivers/net/wireless/iwlwifi/iwl-tx.c: fix gcc-3.4.5 warning
