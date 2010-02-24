Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010Ab0BXUG0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 15:06:26 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33541 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757442Ab0BXUGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 15:06:20 -0500
Date: Wed, 24 Feb 2010 12:06:17 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.33 released
Message-ID: <alpine.LFD.2.00.1002241146140.4513@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Some final last-minute small regression fixes, but it's out there now.

The shortlog below is (obviously) just the things since the last -rc8, for 
a fuller log you can either download the full ChangeLog, or preferably do 
the git thing and look at whatever area you are interested in. Or wait for 
the kernelnewbies report.

The most noticeable features in 2.6.33 are likely the Nouveau and DRBD 
integration (and a _lot_ more people will notice the Nouveau part of 
that). And the Radeon KMS parts aren't considered experimental any more.  

Oh, and the AS IO scheduler is gone, since keeping it around and just 
causing confusion seemed to not be worth it any more. You're supposed to 
use CFQ instead.

Otherwise, I think this release cycle has been more about various random 
stuff and drivers, and not several whole new filesystems, for example. As 
usual, about two thirds of the changes are drivers (and half of that in 
staging). And the non-driver half is pretty evenly divided between arch 
updates and "the rest".

And as usual, I'll let things sit for a couple of days before I start 
seriously merging new stuff, but other than that normal calming down 
period, the merge window for 2.6.34 is now open.

		Linus

---
Abdoulaye Walsimou Gaye (1):
      ARM: 5950/1: ARM: Fix build error for arm1026ej-s processor

Adam Jackson (1):
      drm/edid: Fix interlaced detailed timings to be frame size, not field.

Ajit Khaparde (2):
      be2net: set proper value to version field in req hdr
      net: bug fix for vlan + gro issue

Al Viro (2):
      fix LOOKUP_FOLLOW on automount "symlinks"
      Switch proc/self to nd_set_link()

Alan Jenkins (1):
      Input: i8042 - fix KBC jam during hibernate

Alasdair G Kergon (1):
      dm: sysfs revert add empty release function to avoid debug warning

Alek Du (1):
      USB: ehci: phy low power mode bug fixing

Alex Chiang (3):
      ACPI: processor: add kernel command line support for early _PDC eval
      ACPI: processor: only evaluate _PDC once per processor
      ACPI: dock: properly initialize local struct dock_station in dock_add()

Alex Deucher (3):
      drm/radeon/kms/rs600: add connector quirk
      drm/radeon/kms: fix shared ddc detection
      drm/radeon/rv740: fix backend setup

Andreas Mohr (1):
      USB: ftdi_sio: add device IDs (several ELV, one Mindstorms NXT)

Anton Blanchard (2):
      perf: Fix hypervisor sample reporting
      e1000: Fix DMA mapping error handling on RX

Anton Vorontsov (4):
      powerpc/85xx: Fix oops during MSI driver probe on MPC85xxMDS boards
      kfifo: Make kfifo_initialized work after kfifo_free
      USB: FHCI: Fix build after kfifo rework
      kfifo: Don't use integer as NULL pointer

Arjan van de Ven (1):
      ACPI: fix High cpu temperature with 2.6.32

Atsushi Nemoto (1):
      tc35815: Remove a wrong netif_wake_queue() call which triggers BUG_ON

Ben Hutchings (3):
      V4L/DVB: cxusb: Select all required frontend and tuner modules
      sfc: Fix sign of efx_mcdi_poll_reboot() error in efx_mcdi_poll()
      sfc: SFE4002/SFN4112F: Widen temperature and voltage tolerances

Ben Skeggs (6):
      drm/nouveau: use mutex for vbios lock
      drm/nv50: make nv50_mem_vm_{bind,unbind} operate only on vram
      drm/nv50: more efficient clearing of gpu page table entries
      drm/nv50: improve vram page table construction
      drm/nv50: fix instmem binding on IGPs to point at stolen system memory
      drm/nv50: fix vram ptes on IGPs to point at stolen system memory

Benoit Papillault (1):
      mac80211: Fix probe request filtering in IBSS mode

Bhanu Prakash Gollapudi (1):
      [SCSI] libfcoe: Send port LKA every FIP_VN_KA_PERIOD secs.

Brian Haley (1):
      IPv6: better document max_addresses parameter

Brian Niebuhr (1):
      USB: gadget: fix EEM gadget CRC usage

Carlos Corbacho (1):
      acer-wmi: Respect current backlight level when loading

Carlos O'Donell (1):
      parisc: Set PCI CLS early in boot.

Christine Caulfield (1):
      Orphan DECnet

Chuck Ebbert (1):
      vfs: don't call ima_file_check() unconditionally in nfsd_open()

Chuck Lever (1):
      NFS: Too many GETATTR and ACCESS calls after direct I/O

Clemens Ladisch (1):
      firewire: ohci: retransmit isochronous transmit packets on cycle loss

Damian Lukowski (1):
      tcp: fix ICMP-RTO war

Dan Halperin (1):
      iwlwifi: set HT flags after channel in rxon

Darrick J. Wong (1):
      ACPI: Fix regression where _PPC is not read at boot even when ignore_ppc=0

Dave Airlie (3):
      drm/radeon/kms: make sure retry count increases.
      drm/radeon/kms: use udelay for short delays
      drm/radeon: bump the UMS driver version number to indicate rv740 fix

David Howells (1):
      CacheFiles: Fix a race in cachefiles_delete_object() vs rename

David S. Miller (4):
      sparc64: Tighten checks in kstack_valid().
      sparc64: Sync of_create_pci_dev() with drivers/pci/probe.c changes.
      sparc64: Fix sun4u execute bit check in TSB I-TLB load.
      sparc32: Fix struct stat uid/gid types.

Dick Hollenbeck (1):
      serial: 8250: add serial transmitter fully empty test

Don Skidmore (2):
      ixgbe: Fix - Do not allow Rx FC on 82598 at 1G due to errata
      ixgbe: fix WOL register setup for 82599

Eric W. Biederman (3):
      sysfs: sysfs_sd_setattr set iattrs unconditionally
      net: Fix sysctl restarts...
      net-sysfs: Use rtnl_trylock in wireless sysfs methods.

Francisco Jerez (3):
      drm/nouveau: Force TV encoder DPMS reinit after resume.
      drm/ttm: fix caching problem on non-PAT systems.
      drm/nouveau: Fix up pre-nv17 analog load detection.

Frederic Weisbecker (3):
      reiserfs: Fix softlockup while waiting on an inode
      hw-breakpoints: Accept breakpoints on NULL address
      hw-breakpoint: Keep track of dr7 local enable bits

Greg Kroah-Hartman (1):
      USB: usbfs: only copy the actual data received

Guennadi Liakhovetski (1):
      ARM: 5944/1: scsi: fix timer setup in fas216.c

H. Peter Anvin (1):
      mm: Make copy_from_user() in migrate.c statically predictable

Hauke Mehrtens (1):
      MIPS: BCM47xx: Fix 128MB RAM support

Hedi Berriche (1):
      [IA64] Fix broken sn2 build

Heiko Carstens (1):
      tracing/kprobes: Fix probe parsing

Herbert Xu (3):
      inet: Remove bogus IGMPv3 report handling
      ipcomp: Avoid duplicate calls to ipcomp_destroy
      xfrm: Fix xfrm_state_clone leak

Hugh Daschbach (2):
      [SCSI] libfc: Fix e_d_tov ns -> ms scaling factor in PLOGI response.
      [SCSI] libfc: Don't assume response request present.

Jean Delvare (1):
      V4L/DVB: bttv: Move I2C IR initialization

Jelle Martijn Kok (1):
      rtl8187: Add new device ID

Jens Axboe (1):
      Revert "block: improve queue_should_plug() by looking at IO depths"

Jens Rottmann (1):
      geode-mfgpt: restore previous behavior for selecting IRQ

Jerome Glisse (3):
      drm/radeon/kms: fix indirect buffer management V2
      drm/radeon/kms: fix bo's fence association
      drm/radeon/kms: free fence IB if it wasn't emited at IB free time

Johannes Berg (1):
      mac80211: fix deferred hardware scan requests

Jonathan Brassow (1):
      dm log: userspace fix overhead_size calcuations

Juuso Oikarinen (1):
      mac80211: fix handling of null-rate control in rate_control_get_rate

KAMEZAWA Hiroyuki (1):
      memcg: fix oom killing a child process in an other cgroup

Kirill Smelkov (1):
      perf top: Fix help text alignment

Kiyoshi Ueda (1):
      dm mpath: fix stall when requeueing io

Kristoffer Glembo (1):
      sparc: Fix incorrect comparison in of_bus_ambapp_match()

Kuninori Morimoto (1):
      soc-camera: mt9t112: modify exiting conditions from standby mode

Kyle McMartin (1):
      vgaarb: fix "target=default" passing

Lai Jiangshan (1):
      tracing: Fix circular dead lock in stack trace

Larry Finger (1):
      b43: Fix throughput regression

Laurent Pinchart (1):
      class: Free the class private data in class_release

Len Brown (2):
      ACPI: remove Asus P2B-DS from acpi=ht blacklist
      ACPI: fix "acpi=ht" boot option

Lennert Buytenhek (1):
      MAINTAINERS: update mv643xx_eth maintenance status

Linus Torvalds (2):
      USB: usbfs: properly clean up the as structure on error paths
      Linux 2.6.33

Linus Walleij (1):
      ARM: 5951/1: ARM: fix documentation of the PrimeCell bus

Mahesh Salgaonkar (1):
      perf: Make bp_len type to u64 generic across the arch

Marcin Slusarz (1):
      efifb: fix framebuffer handoff

Mark Brown (2):
      USB: r8a66597-udc: Prototype IS_ERR() and PTR_ERR()
      USB: s3c-hsotg: Export usb_gadget_register_driver()

Martin Fuzzey (1):
      V4L/DVB: Video : pwc : Fix regression in pwc_set_shutter_speed caused by bad 	constant => sizeof conversion.

Masami Hiramatsu (1):
      perf probe: Init struct probe_point and set counter correctly

Matt Turner (1):
      drm/radeon/kms/atom: use get_unaligned_le32() for ctx->ps

Matthew Garrett (1):
      Input: add KEY_RFKILL

Michael Buesch (1):
      ssb: Fix CONFIG_SSB_SDIOHOST typo

Michael Neuling (1):
      fs/exec.c: fix initial stack reservation

Michal Nazarewicz (1):
      USB: g_multi: fix CONFIG_USB_G_MULTI_RNDIS usage

Michal Simek (1):
      microblaze: Fix cache loop function for cache range

Mike Christie (1):
      [SCSI] iscsi_tcp regression: remove bogus warn on in write path

Mike Frysinger (1):
      [WATCHDOG] bfin: fix max timeout calculation

Mike Snitzer (1):
      dm snapshot: persistent annotate work_queue as on stack

Mikulas Patocka (1):
      dm raid1: fail writes if errors are not handled and log fails

Nikanth Karthikesan (1):
      dm stripe: avoid divide by zero with invalid stripe count

Oleg Nesterov (2):
      x86: set_personality_ia32() misses force_personality32
      x86: ELF_PLAT_INIT() shouldn't worry about TIF_IA32

Pallipadi, Venkatesh (1):
      ACPI: Be in TS_POLLING state during mwait based C-state entry

Paul Mundt (1):
      sh64: fix tracing of signals.

Paulius Zaleckas (1):
      MAINTAINERS: fix my e-mail and status for Gemini and FA526

Peter Tyser (1):
      powerpc/85xx: Fix SMP when "cpu-release-addr" is in lowmem

Peter Zijlstra (2):
      hrtimer, softirq: Fix hrtimer->softirq trampoline
      perf_events: Fix FORK events

Phil Dibowitz (1):
      USB: storage: Remove unneeded SC/PR from unusual_devs.h

Radek Liboska (1):
      USB: ftdi_sio: new device id for papouch AD4USB

Rafael J. Wysocki (1):
      i915 / PM: Fix hibernate regression caused by suspend/resume splitting

Ranjith Lohithakshan (1):
      omap: Remove DEBUG_FS dependency for mux name checking

Richard Farina (1):
      USB: serial: add usbid for dell wwan card to sierra.c

Richard Guenther (1):
      V4L/DVB: dvb: l64781.ko broken with gcc 4.5

Richard Kennedy (1):
      fs: inode - remove 8 bytes of padding on 64bits allowing 1 more objects/slab under slub

Rob Love (1):
      [SCSI] fcoe: Only rmmod fcoe.ko if there are no active connections

Roel Kluin (3):
      iwmc3200wifi: Test of wrong pointer after kzalloc in iwm_mlme_update_bss_table()
      thinkpad-acpi: wrong thermal attribute_group removed in thermal_exit()
      Gemini: wrong registers used to set reg_level in gpio_set_irq_type()

Roland McGrath (1):
      Revert "parisc: HAVE_ARCH_TRACEHOOK"

Roy Yin (1):
      Input: usbtouchscreen - extend coordinate range for Generaltouch devices

Russell King (2):
      ARM: Update mach-types
      ARM: allow alignment fault mode to be configured at kernel boot

Samu Onkalo (1):
      Input: polldev can cause crash in case when polling disabled

Santosh Shilimkar (1):
      ARM: 5938/1: ARM: L2: export outer_cache_fns

Shanyu Zhao (1):
      iwlwifi: fix AMSDU Rx after paged Rx patch

Shaohua Li (1):
      Btrfs: btrfs_mark_extent_written uses the wrong slot

Simon Kagstrom (3):
      via-velocity: Remove unused IRQ status parameter from rx_srv and tx_srv
      via-velocity: Take spinlock on set coalesce
      via-velocity: Fix races on shared interrupts

Stanislaw Gruszka (1):
      iwlwifi: sanity check before counting number of tfds can be free

Stefan Richter (1):
      firewire: net: fix panic in fwnet_write_complete

Steve Hodgson (1):
      sfc: Fix SFE4002 initialisation

Steven J. Magnani (1):
      microblaze: Fix out_le32() macro

Sujith (1):
      ath9k: Fix sequence numbers for PAE frames

Takahiro Yasui (1):
      dm raid1: fix null pointer dereference in suspend

Takashi Iwai (1):
      ALSA: hda - Correct ASUA blacklist for MSI brokenness

Tanaka Akira (1):
      USB: SIS USB2VGA DRIVER: support KAIREN's USB VGA adaptor USB20SVGA-MB-PLUS

Tejun Heo (1):
      idr: fix a critical misallocation bug, take#2

Tetsuo Handa (1):
      kernel/sys.c: fix missing rcu protection for sys_getpriority()

Thomas Hellstrom (4):
      drm: Fix a bug in the range manager.
      drm/ttm: Fix a bug occuring when validating a buffer object in a range.
      drm/vmwgfx: Use fb handover mechanism instead of stealth mode.
      drm/vmwgfx: Fix queries if no dma buffer thrashing is occuring.

Thomas Renninger (2):
      ACPI: Add NULL pointer check in acpi_bus_start
      ACPI: acpi_bus_{scan,bus,add}: return -ENODEV if no device was found

Tomas Henzl (1):
      [SCSI] megaraid_sas: fix for 32bit apps

Tony Luck (1):
      [IA64] preserve personality flag bits across exec

Torgny Johansson (1):
      cdc_ether: new PID for Ericsson C3607w to the whitelist (resubmit)

Valentin Longchamp (1):
      USB: otg Kconfig: let USB_OTG_UTILS select USB_ULPI option

Vasu Dev (1):
      [SCSI] libfc: call ddp setup for only FCP reads to avoid accessing junk fsp pointer

Wey-Yi Guy (2):
      iwlwifi: Fix to set correct ht configuration
      iwlwifi: error checking for number of tfds in queue

Yoichi Yuasa (1):
      MIPS: Highmem: Fix build error

Zhang Rui (1):
      ACPI, i915: blacklist Clevo M5x0N bad_lid state

stephen hemminger (1):
      ethtool: allow non-admin user to read GRO settings.
