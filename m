Return-Path: <linux-kernel-owner+w=401wt.eu-S1755366Ab0AUXpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366Ab0AUXpI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 18:45:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755356Ab0AUXpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 18:45:07 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60785 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755355Ab0AUXpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 18:45:01 -0500
Date: Thu, 21 Jan 2010 15:44:26 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.33-rc5
Message-ID: <alpine.LFD.2.00.1001211535360.13231@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hmm. I don't think there is anything earth-shaking here, although the i915 
KMS changes might be noticeable. Notably if you have eDP ("embedded 
DisplayPort" - I think mainly a feature you'd find on a new imac), in 
which case it now hopefully works, but more commonly if you saw the 
flickering on your laptop panel due to LVDS downclocking (which saves 
power, but is now disabled by default until that thing is resolved).

And there's a new DVB "Mantis" driver there.

Other than that, it's a lot of random fixes, mostly small. And some 
defconfig updates, mostly huge and totally boring.

		Linus

---
Abhijeet Kolekar (1):
      iwlwifi: disable tx on beacon update notification

Adam Jackson (1):
      Input: evdev - be less aggressive about sending SIGIO notifies

Al Viro (12):
      fix autofs/afs/etc. magic mountpoint breakage
      Kill 9p readlink()
      hppfs: handle ->put_link()
      Unrot uml mconsole a bit
      Fix ACC_MODE() for real
      Fix the -ESTALE handling in do_filp_open()
      Fix configfs leak
      may_umount() needs namespace_sem
      attach_recursive_mnt() needs to hold vfsmount_lock over set_mnt_shared()
      mnt_flags fixes in do_remount()
      CIFS shouldn't make mountpoints shrinkable
      do_add_mount() should sanitize mnt_flags

Alan Cox (4):
      x86: mce.h: Fix warning in header checks
      nozomi: quick fix for the close/close bug
      serial: Fix crash if the minimum rate of the device is > 9600 baud
      Staging: et131x: Fix 2.6.33rc1 regression in et131x

Alan Jenkins (1):
      eeepc-laptop: disable cpu speed control on EeePC 701

Alan Stern (4):
      USB: fix bitmask merge error
      USB: EHCI: fix handling of unusual interrupt intervals
      USB: EHCI & UHCI: fix race between root-hub suspend and port resume
      USB: add missing delay during remote wakeup

Alberto Panizzo (1):
      mfd: Unlock mc13783 before subsystems initialisation, at probe time.

Alex Chiang (1):
      ACPI: processor: restrict early _PDC to opt-in platforms

Alex Deucher (3):
      drm/radeon/kms: fix up LVDS handling on macs (v2)
      drm/radeon/kms/r6xx+: make irq handler less verbose
      drm/radeon/kms/rv100: reject modes > 135 Mhz on DVI (v2)

Alex Murray (1):
      ALSA: hda - Improved MacBook (Pro) 5,1 / 5,2 support

Alexander Beregalov (1):
      USB: FHCI: avoid NULL pointer dereference

Alexander Duyck (1):
      ixgbe: Do not attempt to perform interrupts in netpoll when down

Alexey Starikovskiy (3):
      ACPI: EC: Accelerate query execution
      ACPI: SBS: Move SBS HC callback to faster Notify queue
      ACPI: EC: Add wait for irq storm

Andi Kleen (5):
      kfifo: use void * pointers for user buffers
      kfifo: sanitize *_user error handling
      kfifo: add kfifo_out_peek
      kfifo: add kfifo_initialized
      kfifo: document everywhere that size has to be power of two

Anton Blanchard (3):
      alpha: cpumask_of_node() should handle -1 as a node
      powerpc/pseries: Fix xics interrupt affinity
      powerpc: cpumask_of_node() should handle -1 as a node

Anton Vorontsov (1):
      powerpc/swsusp_32: Fix TLB invalidation

Arjan van de Ven (1):
      perf timechart: Use tid not pid for COMM change

Arnaldo Carvalho de Melo (2):
      perf tools: Move QUIET_STDERR def to before first use
      perf tools: Check if /dev/null can be used as the -o gcc argument

Atsushi Nemoto (1):
      compat_ioctl: Supress "unknown cmd" message on serial /dev/console

Ben Dooks (1):
      ARM: MINI2440: Fixup __initdata usage

Ben Hutchings (2):
      sfc: Fix polling for slow MCDI operations
      sfc: Fix conditions for MDIO self-test

Benjamin Herrenschmidt (2):
      zlib: Fix build of powerpc boot wrapper
      serial/pmac_zilog: Workaround problem due to interrupt on closed port

Benoit Papillault (1):
      zd1211rw: Fix multicast filtering.

Bruce Allan (2):
      e1000e: MDIO slow mode should always be done for 82577
      e1000e: workaround link issues on busy hub in half duplex on 82577/82578

Chen Gong (1):
      acpi_pad: fix error checks

Chris Mason (1):
      Btrfs: deal with NULL acl sent to btrfs_set_acl

Christian Schuerer-Waldheim (1):
      HID: add device IDs for new model of Apple Wireless Keyboard

Colin Tuckley (1):
      USB: Fix level of isp1760 Reloading ptd error message

Corentin Chary (3):
      eeepc-laptop: dmi blacklist to disable pci hotplug code
      eeepc-laptop: add hotplug_disable parameter
      eeepc-laptop: disable wireless hotplug for 1201N

Cyrill Gorcunov (1):
      x86: kernel_thread() -- initialize SS to a known state

Daisuke Nishimura (1):
      memcg: ensure list is empty at rmdir

Dan Carpenter (5):
      iwl: off by one bug
      iwlwifi: silence buffer overflow warning
      V4L/DVB (13955): cx25821: fix double unlock in medusa_video_init()
      mfd: WM8350 off by one bug
      ecryptfs: use after free

Daniel Drake (1):
      Input: psmouse - fix Synaptics detection when protocol is disabled

Darren Jenkins (1):
      ACPI: power_meter: remove double kfree()

Dave Airlie (2):
      drm/radeon/kms: only evict to GTT if CP is ready
      drm: fix crtc no modes printf + typo

Dave Chinner (7):
      xfs: reclaim inodes under a write lock
      xfs: Avoid inodes in reclaim when flushing from inode cache
      xfs: reclaim all inodes by background tree walks
      xfs: Remove inode iolock held check during allocation
      xfs: fix stale inode flush avoidance
      xfs: fix missing error check in xfs_rtfree_range
      xfs: xfs_swap_extents needs to handle dynamic fork offsets

Dave Young (1):
      drm: change drm set mode messages as DRM_DEBUG

David Howells (6):
      nommu: fix SYSV SHM for NOMMU
      nommu: struct vm_region's vm_usage count need not be atomic
      nommu: remove a superfluous check of vm_region::vm_usage
      nommu: don't need get_unmapped_area() for NOMMU
      nommu: fix race between ramfs truncation and shared mmap
      nommu: fix shared mmap after truncate shrinkage problems

David John (1):
      smp_call_function_any(): pass the node value to cpumask_of_node()

David S. Miller (1):
      ipv6: skb_dst() can be NULL in ipv6_hop_jumbo().

David Sharp (1):
      ring-buffer: Wrap a list.next reference with rb_list_head()

David Woodhouse (1):
      V4L/DVB (13716): [Mantis] Bug: incorrect byte swap

Divyesh Shah (1):
      cfq-iosched: Respect ioprio_class when preempting

Dmitri Belimov (1):
      V4L/DVB (13966): DVB-T regression fix for saa7134 cards

Dmitry Torokhov (5):
      Input: atkbd - fix canceling event_work in disconnect
      Input: xbox - do not use GFP_KERNEL under spinlock
      Input: add compat support for sysfs and /proc capabilities output
      eeepc-laptop: switch to using sparse keymap library
      sony-laptop - fix using of uninitialized variable

Dominik Geyer (1):
      ath9k: Fix Kconfig depends for ATH9K_DEBUGFS

Elliott Sales de Andrade (1):
      Input: i8042 - add Dritek quirk for Acer Aspire 5610.

Erez Zadok (5):
      ecryptfs: initialize private persistent file before dereferencing pointer
      ecryptfs: don't ignore return value from lock_rename
      ecryptfs: remove unnecessary d_drop calls in ecryptfs_link
      ecryptfs: pass matching flags to interpose as defined and used there
      ecryptfs: fix interpose/interpolate typos in comments

Eric Anholt (1):
      drm/i915: Remove chatty execbuf failure message.

Eric Paris (2):
      inotify: do not reuse watch descriptors
      inotify: only warn once for inotify problems

Eric W. Biederman (1):
      Input: serio - fix potential deadlock when unbinding drivers

Erik Andren (1):
      V4L/DVB (13880): gspca - m5602-s5k4aa: Add vflip quirk for the Amilo Xi 2428

Erik Andrén (1):
      V4L/DVB (13882): gspca - stv06xx-vv6410: Ensure register STV_SCAN_RATE is zero

Erik-Jan Post (2):
      viafb: do modesetting after updating variables
      viafb: fix acceleration for some chips

Eugeni Dodonov (1):
      Staging: asus_oled: fix oops in 2.6.32.2

FUJITA Tomonori (2):
      x86/agp: Fix agp_amd64_init and agp_amd64_cleanup
      powerpc/pseries: Fix dlpar compile warning without CONFIG_PROC_DEVICETREE

Felix Fietkau (2):
      mac80211: add missing sanity checks for action frames
      mac80211: fix queue selection for data frames on monitor interfaces

Florian Tobias Schandinat (1):
      viafb: fix LCD hardware cursor regression

Frederic Weisbecker (1):
      perf: Stop stack frame walking off kernel addresses boundaries

Gertjan van Wingerde (2):
      rt2x00: Fix LED configuration setting for rt2800.
      rt2x00: Properly request tx headroom for alignment operations.

Grant Likely (1):
      powerpc/5200: update defconfigs

Greg Kroah-Hartman (4):
      Revert "sysdev: fix prototype for memory_sysdev_class show/store functions"
      tty: fix race in tty_fasync
      Staging: hv: fix smp problems in the hyperv core code
      USB: add speed values for USB 3.0 and wireless controllers

H Hartley Sweeten (1):
      ACPI: Remove unnecessary cast.

Hans Verkuil (1):
      MAINTAINERS: Andy Walls is the new ivtv maintainer

Hans de Goede (1):
      feature-removal-schedule: Add v4l1 drivers obsoleted by gspca sub drivers

Heiko Carstens (16):
      [S390] dasd: add missing compat ptr conversion
      [S390] cio: add missing compat ptr conversion
      [S390] vmcp: add missing compat ptr conversion
      [S390] fs3270: add missing compat ptr conversion
      [S390] smp: setup smp_processor_id early
      [S390] smp: remove volatile type quilifier from __cpu_logical_map
      [S390] tape_block: remove ioctl function
      [S390] Move __cpu_logical_map to smp.c
      [S390] bug: implement arch specific __WARN macro
      [S390] mmap: add missing compat_ptr conversion to both mmap compat syscalls
      [S390] dasd: add proper compat pointer conversion for symmetrix ioctl
      [S390] con3215: remove empty ioctl function
      [S390] unwire sys_recvmmsg again
      [S390] zcrypt: add sanity check before copy_from_user()
      [S390] tape_char: add missing compat_ptr conversion
      driver-core: fix devtmpfs crash on s390

Henrik Rydberg (1):
      Input: bcm5974 - report ABS_MT events

Hui Zhu (1):
      markup_oops.pl: fix error with x86

Ian Campbell (2):
      xen: fix hang on suspend.
      x86: xen: 64-bit kernel RPL should be 0

Ian Molton (1):
      mfd: tmio_mmc hardware abstraction for CNF area

Jack Steiner (1):
      x86, uv: Add function retrieving node controller revision number

Jan Engelhardt (1):
      btrfs: fix missing last-entry in readdir(3)

Jan Kiszka (1):
      tracing/x86: Derive arch from bits argument in recordmcount.pl

Jean-Francois Moine (4):
      V4L/DVB (13816): gspca - main: Set the current frame pointer when first qbuf.
      V4L/DVB (13622): gspca - ov534: Fix a compilation warning.
      V4L/DVB (13875): gspca - vc032x: Fix a possible crash with the vc0321 bridge.
      V4L/DVB (13900): gspca - sunplus: Fix bridge exchanges.

Jeff Mahoney (1):
      virtio: fix section mismatch warnings

Jesse Barnes (1):
      drm/i915: disable LVDS downclock by default

Jiri Slaby (4):
      [S390] use helpers for rlimits
      powerpc: Use helpers for rlimits
      MAINTAINERS: ivtv-devel is moderated
      Btrfs, fix memory leaks in error paths

Joakim Tjernlund (2):
      powerpc/8xx: Always pin kernel instruction TLB
      powerpc/8xx: Fix user space TLB walk in dcbX fixup

Johan Hovold (1):
      usb: serial: fix memory leak in generic driver

Johannes Berg (3):
      mac80211: fix skb buffering issue
      mac80211: fix endian error
      cfg80211: fix refcount imbalance when wext is disabled

Johannes Thoma (2):
      drbd: Kconfig fix
      drbd: Don't go into StandAlone mode when authentification failes because of network error

John Stultz (1):
      m68knommu: fix invalid flags on coldfire pit clocksource

John W. Linville (2):
      mac80211: fix-up build breakage in 2.6.33
      Revert "mac80211: replace netif_tx_{start,stop,wake}_all_queues"

Jonathan Nieder (1):
      kbuild: really fix bzImage build with non-bash sh

Josef Bacik (2):
      Btrfs: fix regression in orphan cleanup
      Btrfs: fix possible panic on unmount

Julia Lawall (3):
      drivers/block/drbd: Correct NULL test
      drivers/block/drbd/drbd_receiver.c: correct NULL test
      ecryptfs: Eliminate useless code

KOSAKI Motohiro (3):
      futexes: Remove rw parameter from get_futex_key()
      vmscan: kswapd: don't retry balance_pgdat() if all zones are unreclaimable
      page allocator: update NR_FREE_PAGES only when necessary

Kamalesh Babulal (1):
      powerpc/hvc: Driver build breaks with !HVC_CONSOLE

Kazuhisa Ichikawa (1):
      mm/page_alloc: fix the range check for backward merging

Kirill Afonshin (1):
      block: removed unused as_io_context

Kumar Gala (1):
      powerpc: 2.6.33 update of defconfigs for embedded 6xx/7xxx, 8xx, 8xxx

Kunal Gangakhedkar (1):
      ALSA: hda - Fix mute led GPIO on HP dv-series notebooks

Kuninori Morimoto (1):
      sh: ms7724: Correct sh-eth EEPROM polling timeout.

Lars Ellenberg (1):
      drbd: check on CONFIG_LBDAF, not LBD

Laurent Pinchart (3):
      V4L/DVB (13826): uvcvideo: Fix controls blacklisting
      V4L/DVB (13829): uvcvideo: Fix alternate setting selection in isochronous mode
      V4L/DVB (13831): uvcvideo: Fix oops caused by a race condition in buffer dequeuing

Len Brown (4):
      x86, ACPI: delete acpi_boot_table_init() return value
      ACPI: enable C2 and Turbo-mode on Nehalem notebooks on A/C
      ACPI: allow C3 > 1000usec
      ACPI: delete acpi_processor_power_verify_c2()

Lennert Buytenhek (2):
      mwl8k: fix configure_filter() memory leak on error
      mac80211: fix queue selection for packets injected via monitor interface

Li Zefan (7):
      ftrace: Fix MATCH_END_ONLY function filter
      tracing/filters: Fix MATCH_FRONT_ONLY filter matching
      tracing/filters: Fix MATCH_END_ONLY filter matching
      lib: Introduce strnstr()
      tracing/filters: Fix MATCH_MIDDLE_ONLY filter matching
      tracing/filters: Fix MATCH_FULL filter matching for PTR_STRING
      tracing/filters: Add comment for match callbacks

Linus Torvalds (2):
      fasync: split 'fasync_helper()' into separate add/remove functions
      Linux 2.6.33-rc5

Lothar Wassmann (2):
      USB: isp1362: better 64bit printf warning fixes
      USB: isp1362: fix build failure on ARM systems via irq_flags cleanup

Luca Barbieri (1):
      hw-breakpoints, perf: Fix broken mmiotrace due to dr6 by reference change

Luis R. Rodriguez (2):
      ath5k: Fix eeprom checksum check for custom sized eeproms
      cfg80211: fix syntax error on user regulatory hints

Magnus Horlin (1):
      V4L/DVB (13748): [Mantis/VP-2040] Add support for VP-2040 (TDA10023 frontend based)

Manu Abraham (101):
      V4L/DVB (13699): [Mantis, MB86A16] Initial checkin: Mantis, MB86A16
      V4L/DVB (13700): [MB86A16] Need a bit of settling time
      V4L/DVB (13701): [MB86A16] Reduce Carrier Recovery range to 3Mhz
      V4L/DVB (13702): [MB86A16] need to wait a bit more than the computed time for a Factor of safety
      V4L/DVB (13703): [MB86A16] Fix wrong message printed out
      V4L/DVB (13704): [MB86A16] FIX: Don't loop again, if we have SYNC
      V4L/DVB (13705): [Mantis] FIX: Do not return IRQ_HANDLED in the unlikely case
      V4L/DVB (13706): [MB86A16] Overhaul
      V4L/DVB (13707): [Mantis] Whitespace cleanup
      V4L/DVB (13708): [Mantis] Remove some dead code
      V4L/DVB (13709): [Mantis/VP-1034] Switch 13/18v for the VP-1034 properly
      V4L/DVB (13710): [Mantis] FIX: Use swfilter (188/204) accordingly
      V4L/DVB (13712): [Mantis] Add locking for concurrent access
      V4L/DVB (13714): [MB86A16] FIX/Code simplification: use hwconfig->ts_size instead of ts_size
      V4L/DVB (13715): [Mantis] Kernel I2C changes: use PCI parent device
      V4L/DVB (13717): [MB86A16] Statistics Updates
      V4L/DVB (13719): [Mantis/VP-2033] Initial test switch to the tda10021, from the cu1216
      V4L/DVB (13720): [Mantis/Terratec Cinergy C] Add support for the Terratec Cinergy C PCI
      V4L/DVB (13721): [Mantis] Bug! Before bailing out, Unlock
      V4L/DVB (13722): [Mantis] Revert 13560
      V4L/DVB (13723): [Mantis/VP-2040, Terratec Cinergy C] Add support for the Cinergy C, VP-2040 clone
      V4L/DVB (13724): [Mantis/VP-1041] Initial support for Mantis VP-1041
      V4L/DVB (13725): [Mantis/VP-1041] Revert to old register initialization parameters, for now.
      V4L/DVB (13726): [Mantis/Skystar HD2] Add support for the Technisat Skystar HD2
      V4L/DVB (13727): [Mantis/VP-1041] Bugfix: Sigh! Don't look for the STOP bit
      V4L/DVB (13728): [Mantis] Add in some Host Interface definitions
      V4L/DVB (13729): [Mantis] Add in a license header
      V4L/DVB (13730): [Mantis] Add in some UART definitions
      V4L/DVB (13731): [Mantis] Add in a license header
      V4L/DVB (13732): [Mantis] Add in some Link Layer definitions
      V4L/DVB (13733): [Mantis] Start with the PCMCIA interface
      V4L/DVB (13734): [Mantis] Initial go at an Event Manager
      V4L/DVB (13735): [Mantis] Implement the Event Manager tasklet
      V4L/DVB (13736): [Mantis] Implement CAM Plug IN and Unplug events
      V4L/DVB (13737): [Mantis] Register the CA device, dummy functions for now
      V4L/DVB (13738): [Mantis] Enable IRQ0 events
      V4L/DVB (13739): [Mantis] Event Manager: Handle Masked events only
      V4L/DVB (13740): [Mantis] Schedule the work instead of handling the task directly
      V4L/DVB (13741): [Mantis] Implement HIF Mem Read/Write operations
      V4L/DVB (13742): [Mantis] Implement PCMCIA I/O Rd/Wr operations
      V4L/DVB (13743): [Mantis CA] Use DVB_CA Tuple parser
      V4L/DVB (13744): [Mantis CA] Use Module status to signal Slot events
      V4L/DVB (13745): [Mantis CA] Add some debug statements
      V4L/DVB (13746): [Mantis CA] Bug: Remove duplicated symbol
      V4L/DVB (13749): [Mantis CA] CA_SLAVE: Do not change Slave Configuration setup
      V4L/DVB (13750): [Mantis] GPIO_CONTROL: Cache a given GPIO Bit Setup for a given event
      V4L/DVB (13751): [Mantis] GPIO_CONTROL: Do not toggle GPIO CW's on HIF operations
      V4L/DVB (13752): [Mantis CA] CAM_CONTROL: All CAM control operations now handled by the worker thread
      V4L/DVB (13753): [Mantis CA] SLOT_CONTROL: Implement Slot RESET
      V4L/DVB (13754): [Mantis] CAM_CONTROL: Implement TS control
      V4L/DVB (13755): [Mantis CA] CAM_CONTROL: Use appropriate flags
      V4L/DVB (13756): [Mantis CA] CAM_CONTROL: Use CAMCHANGE_IRQ events
      V4L/DVB (13757): [Mantis CA] CAM_CONTROL: Use FRDA_IRQ Events
      V4L/DVB (13758): [Mantis CA] CAM_CONTROL: Use CAMREADY_IRQ event
      V4L/DVB (13759): [Mantis] HIF I/O: Use the LSB octet only
      V4L/DVB (13761): [Mantis] HIF I/O: Temporary workaround, use SBUF_OPDONE flag instead
      V4L/DVB (13762): [Mantis CA] CA_MODULE: Look for the module status on driver unload as well
      V4L/DVB (13763): [Mantis] HIF I/O: trim delays a bit appropriately
      V4L/DVB (13764): [Mantis CA] SLOT: Add some debug status
      V4L/DVB (13765): [Mantis] HIF I/O: Add some debug statements
      V4L/DVB (13767): [Mantis/VP-1041] Bug: Add in missing Master clock settings
      V4L/DVB (13768): [Mantis] Enable WRACK
      V4L/DVB (13769): [Mantis] Smart Buffer Burst Read Ready cannot flag FR/DA Irq
      V4L/DVB (13770): [Mantis] Bug Do not trigger FR/DA IRQ from SBUF OPDONE
      V4L/DVB (13771): [Mantis] Reset Flags at the earliest possible
      V4L/DVB (13772): [Mantis] Do not enable Common Memory Access
      V4L/DVB (13773): [Mantis] Enable all interrupts
      V4L/DVB (13775): [Mantis] Remove unnecessary job queues
      V4L/DVB (13776): [Mantis] Use a simple timeout instead, interruptible
      V4L/DVB (13777): [Mantis] Use a Write wait queue for Write events
      V4L/DVB (13778): [Mantis] Wr ACK is already handled in the fast path,
      V4L/DVB (13779): [Mantis] Missing wakeup for write queue
      V4L/DVB (13781): [Mantis CA] Bug: Fix wrong usage of HIFRDWRN
      V4L/DVB (13782): [Mantis] Temporarily disable FRDA irq
      V4L/DVB (13784): [Mantis] Use PCI API instead of hardcoded length
      V4L/DVB (13785): [Mantis] Do not disable IRQ's while being invoked
      V4L/DVB (13786): [Mantis] Bug: HIF bits already shifted ..
      V4L/DVB (13787): [Mantis] Fix build
      V4L/DVB (13788): [Mantis CA] use a lock for the relevant CI Read/Write operations
      V4L/DVB (13789): [Mantis CA] Initialize the mutex
      V4L/DVB (13790): [Mantis] Relocate queue initialization
      V4L/DVB (13794): [Mantis/VP-3028] Initial go at Serial interface implementation, add support for VP-3028
      V4L/DVB (13795): [Mantis/Hopper] Code overhaul, add Hopper devices into the PCI ID list
      V4L/DVB (13796): [Mantis] Add missing file in previous commit
      V4L/DVB (13797): [Mantis/Hopper/TDA665x] Large overhaul,
      V4L/DVB (13798): [Mantis] Enable power for all cards, use byte mode only on relevant devices
      V4L/DVB (13799): [Mantis] Unregister frontend
      V4L/DVB (13800): [Mantis] I2C optimization. Required delay is much lesser than 1mS.
      V4L/DVB (13801): [MB86A16] Use the search callback
      V4L/DVB (13802): [Mantis/Hopper] Fix all build related warnings
      V4L/DVB (13803): Remove unused dependency on CU1216
      V4L/DVB (13804): Remove unused I2C Adapter ID
      V4L/DVB (13805): Fix: Unregister the frontend before detaching
      V4L/DVB (13806): Register and Initialize Remote control
      V4L/DVB (13807): Fix: Free device in the device registration failure case
      V4L/DVB (13809): Fix Checkpatch violations
      V4L/DVB (13810): [MB86A16] Use DVB_* macros
      V4L/DVB (13811): [MB86A16] Update Copyright header
      V4L/DVB (13812): [Mantis/Hopper] Update Copyright header
      V4L/DVB (13808): [Mantis/Hopper] Build update for Mantis/Hopper based cards
      V4L/DVB (13851): Fix Input dependency for Mantis

Mark Brown (4):
      ARM: SMDK6410: Specify no GPIO for B_PWR_5V regulator
      revert "drivers/video/s3c-fb.c: fix clock setting for Samsung SoC Framebuffer"
      mfd: Correct WM835x ISINK ramp time defines
      mfd: WM835x GPIO direction register is not locked

Marko Ristola (2):
      V4L/DVB (13711): [Mantis] FIX: Do nor toggle GPIF status
      V4L/DVB (13718): [Mantis] Use gpio_set_bits to turn OFF the bits as well

Marko Viitamaki (1):
      V4L/DVB (13783): [Mantis/Technisat Cablestar HD2] Add support for the Technisat Cablestar HD2

Markus Pietrek (1):
      serial: sh-sci: using correct fifo size for SCIF and SCIFA ports.

Martin K. Petersen (4):
      block: Correct handling of bottom device misaligment
      block: Fix discard alignment calculation and printing
      block: bdev_stack_limits wrapper
      DM: Fix device mapper topology stacking

Martin Schwidefsky (4):
      [S390] fix loading of PER control registers for utrace.
      [S390] clear TIF_SINGLE_STEP for new process.
      [S390] duplicate SIGTRAP on signal delivery.
      [S390] remove superfluous TIF_USEDFPU bit

Matt Carlson (5):
      tg3: Fix std prod ring nicaddr for 5787 and 57765
      tg3: Fix std rx prod ring handling
      tg3: Add reliable serdes detection for 5717 A0
      tg3: Disable 5717 serdes and B0 support
      tg3: Update copyright and driver version

Matt Turner (1):
      alpha: add myself as a maintainer, and drop mention of 2.4

Matthew Garrett (1):
      serial: 8250_pnp: use wildcard for serial Wacom tablets

Mauro Carvalho Chehab (5):
      V4L/DVB (13834): dib8000: fix compilation if !DVB_DIB8000
      V4L/DVB (13858): ir-keytable: use the right header
      V4L/DVB(13808a): mantis: convert it to the new ir-core register/unregister functions
      V4L/DVB (13808b): mantis: replace DMA_nnBIT_MASK to DMA_BIT_MASK(32)
      V4L/DVB(13824a): mantis: Fix __devexit bad annotations

Michael Ellerman (1):
      powerpc/iseries: Initialise on-stack completion

Michael Krufky (2):
      V4L/DVB (13887): tda8290: add autodetection support for TDA8295c2
      V4L/DVB (13934): tda8290: Fix FM radio easy programming standard selection for TDA8295

Michal Marek (1):
      Makefile: do not override LC_CTYPE

Michal Simek (5):
      microblaze: Wire up recvmmsg syscall
      microblaze: Enable accept4 syscall
      microblaze: Add PT_ macros for special purpose regs
      microblaze: Add missing double apostrophe in Kconfig
      microblaze: pci_controller->arch_data really is a struct device_node *

Michel Dänzer (1):
      drm/radeon/kms: Fix crash getting TV info with no BIOS.

Miguel Aguilar (1):
      Input: davinci_keyscan - add device_enable method to platform data

Mike Frysinger (1):
      modpost: fix segfault in sym_is() with prefixed arches

Mike Galbraith (1):
      sched: Fix vmark regression on big machines

Mike Travis (1):
      x86: SGI UV: Fix mapping of MMIO registers

Ming Lei (1):
      ath9k: fix ito64

Márton Németh (4):
      powerpc/macintosh: Make Open Firmware device id constant
      i2c-ali1563: Remove sparse warnings
      acpi: make ACPI device id constant
      V4L/DVB (13941): rj54n1cb0c: remove compiler warning

NISHIMOTO Hiroki (1):
      sh: mach-ecovec24: Add motion sensor driver support.

Nathan Fontenot (2):
      powerpc: Move /proc/ppc64 to /proc/powerpc update
      powerpc: Move cpu hotplug driver lock from pseries to powerpc

Nemeth Marton (1):
      V4L/DVB (13820): lgdt3305: make one-bit bitfields unsigned

Niklas Edmundsson (2):
      V4L/DVB (13791): [TDA10021] Do not claim TDA10023
      V4L/DVB (13792): [Mantis/VP-2033] Do not claim TDA10023

OGAWA Hirofumi (2):
      vfs: Fix vmtruncate() regression
      ecryptfs: Fix refcnt leak on ecryptfs_follow_link() error path

Octavian Purdila (1):
      net: fix build erros with CONFIG_BUG=n, CONFIG_GENERIC_BUG=n

Oliver Neukum (1):
      USB: Don't use GFP_KERNEL while we cannot reset a storage device

Paul Mundt (2):
      sh: unwire sys_recvmmsg.
      sh64: wire up sys_accept4.

Pavel Machek (1):
      serial: serial_cs: oxsemi quirk breaks resume

Pavel Roskin (1):
      rt2x00: use correct headroom for transmission

Pekka Enberg (2):
      perf kmem: Increase "Hit" column length
      perf kmem: Print usage help for unknown commands

Peter Tyser (1):
      powerpc: Use scripts/mkuboot.sh instead of 'mkimage'

Peter Zijlstra (3):
      perf: Fix perf_event_do_pending() fallback callsite
      perf: Honour event state for aux stream data
      perf: Change the is_software_event() definition

Petr ¦tetiar (1):
      HID: blacklist ET&T TC5UH touchscreen controller

Philipp Reisner (5):
      drbd: Use drbd_crypto_is_hash() instead of an open coded check
      drbd: Fix for a race between IO and a detach operation [Bugz 262]
      drbd: Silenced an assert that could triggered after changing write ordering method
      drbd: Allow online resizing of DRBD devices while peer not reachable (needs to be explicitly forced)
      drbd: The kernel code is now equivalent to out of tree release 8.3.7

Ping (1):
      serial/8250_pnp: add a new Fujitsu Wacom Tablet PC device

Przemo Firszt (2):
      HID: fix pad button definition in hid-wacom
      HID: wacom: Add BTN_TOOL_FINGER for pad button reporting

Rabin Vincent (1):
      ARM: 5883/1: Revert "disable NX support for OABI-supporting kernels"

Rafael J. Wysocki (1):
      drm/i915: Fix resume regression on MSI Wind U100 w/o KMS

Rakib Mullick (1):
      ACPI: Fix unused variable warning in sbs.c

Ramax Lo (1):
      ARM: S3C: NAND: Check the existence of nr_map before copying

Randy Dunlap (1):
      tty.h: make tty_port_get() static inline

Robert Schedel (1):
      HID: Support 171 byte variant of Samsung USB IR receiver

Roel Kluin (5):
      Input: gf2k - fix &&/|| confusion in gf2k_connect()
      amd64_edac: Ensure index stays within bounds in amd64_get_scrub_rate
      i2c: Test off by one in {piix4,vt596}_transaction()
      V4L/DVB (13868): gspca - sn9c20x: Fix test of unsigned.
      serial: imx: bit &/| confusion

Roland Dreier (1):
      kernel.h: add BUILD_BUG_ON_NOT_POWER_OF_2()

Russ Anderson (1):
      x86, uv: Ensure hub revision set for all ACPI modes.

Russell King (1):
      ARM: fix badly placed mach/plat entries in Kconfig & Makefile

Ryan May (1):
      USB: fix usbstorage for 2770:915d delivers no FAT

Sarah Sharp (1):
      USB: Fix duplicate sysfs problem after device reset.

Seth Heasley (1):
      [WATCHDOG] iTCO_wdt: Add Intel Cougar Point and PCH DeviceIDs

Shannon Nelson (1):
      ixgbe: update copyright dates

Sigmund Augdal (6):
      V4L/DVB (13713): [MB86A16] Fix: Initialize SNR/STATUS
      V4L/DVB (13747): [Mantis] Bug Fix!: Use Register Address rather than register field
      V4L/DVB (13760): [Mantis CA] CA_MODULE: Look for module status on driver load
      V4L/DVB (13766): [Mantis] Bug: Fix wrong exit condition
      V4L/DVB (13774): [Mantis] Remove redundant wait for Burst Reads, wakeup the HIF event
      V4L/DVB (13780): [Mantis] HIF I/O: Enable Interrupts for Read

Stanislav Brabec (1):
      serial-core: resume serial hardware with no_console_suspend

Stefan Roese (1):
      powerpc: Fix decrementer setup on 1GHz boards

Stefani Seibold (2):
      kfifo: fix kfifo_out_locked race bug
      USB: serial: fix USB serial fix kfifo_len locking

Stephane Eranian (1):
      perf: x86: Add support for the ANY bit

Stephen Hemminger (1):
      genhd: overlapping variable definition

Steven Rostedt (1):
      ring-buffer: Add rb_list_head() wrapper around new reader page next field

Suresh Siddha (2):
      x86, apic: use physical mode for IBM summit platforms
      x86, apic: use logical flat for systems with <= 8 logical cpus

Tai-hwa Liang (2):
      Input: pmouse - move Sentelic probe down the list
      Input: sentelic - fix left/right horizontal scroll mapping

Takashi Iwai (4):
      ALSA: hda - Fix Toshiba NB20x quirk entry
      ALSA: hda - Fix missing capture mixer for ALC861/660 codecs
      ALSA: hda - Fix capture on Sony VAIO with single input
      ALSA: Remove warning message for invalid OSS minor ranges

Tamas Vincze (1):
      edac: i5000_edac critical fix panic out of bounds

Tejun Heo (1):
      libata: retry FS IOs even if it has failed with AC_ERR_INVALID

Thadeu Lima de Souza Cascardo (2):
      ALSA: use subsys_initcall for sound core instead of module_init
      i2c: Do not use device name after device_unregister

Thiago Farina (1):
      fs/bio.c: fix shadows sparse warning

Tobias Klauser (1):
      i2c-core: Storage class should be before const qualifier

Tony Lindgren (5):
      ARM: 5882/1: ARM: Fix uncompress code compile for different defines of flush(void)
      ARM: 5884/1: arm: Fix DCC console for v7
      ARM: 5885/1: arm: Flush TLB entries in setup_mm_for_reboot()
      ARM: 5886/1: arm: Fix cpu_proc_fin() for proc-v7.S and make kexec work
      ARM: 5888/1: arm: Update comments in cacheflush.h and remove unnecessary V6 and V7 comments

Tony Luck (1):
      ACPI: Fix section mismatch error for acpi_early_processor_set_pdc()

Tyler Hicks (3):
      eCryptfs: Use notify_change for truncating lower inodes
      eCryptfs: Add getattr function
      eCryptfs: Remove mmap from directory operations

Uri Yosef (1):
      ARM: MINI2440: Fix crash on boot due to improper __initdata qualifier

Uwe Kleine-König (2):
      V4L/DVB mx1_camera: don't check platform_get_irq's return value against zero
      V4L/DVB sh_mobile_ceu: don't check platform_get_irq's return value against zero

Wolfram Sang (1):
      i2c/pca: Don't use *_interruptible

Wu Fengguang (2):
      memory-hotplug: add 0x prefix to HEX block_size_bytes
      sysdev: fix prototype for memory_sysdev_class show/store functions

Xiaotian Feng (1):
      ACPI: don't cond_resched if irq is disabled

Yan, Zheng (2):
      Btrfs: align offsets for btrfs_ordered_update_i_size
      Btrfs: Fix race in btrfs_mark_extent_written

Yong Zhang (1):
      sched: Reassign prev and switch_count when reacquire_kernel_lock() fail

Yongseok Koh (1):
      vmalloc: remove BUG_ON due to racy counting of VM_LAZY_FREE

Zhang Rui (1):
      ACPI video: Prune dupe video devices, unless "video.allow_duplicates"

Zhao Yakui (8):
      drm/i915: Add HP nx9020/SamsungSX20S to ACPI LID quirk list
      drm/i915: Use find_pll function to calculate DPLL setting for LVDS downclock
      drm/i915: Fix Ironlake M/N/P ranges to match the spec
      drm/i915: Don't use the child device parsed from VBT to setup HDMI/DP
      drm/i915: Read the response after issuing DDC bus switch command
      drm/i915: try another possible DDC bus for the SDVO device with multiple outputs
      drm/i915: Fix the incorrect cursor A bit definition in DSPFW2 register
      ACPI: Advertise to BIOS in _OSC: _OST on _PPC changes

Zhenyu Wang (6):
      drm/i915: disable TV hotplug status check
      drm/i915: Don't wait interruptible for possible plane buffer flush
      drm/i915: parse eDP panel color depth from VBT block
      drm/i915: fix pixel color depth setting on eDP
      drm/i915: fix eDP pipe mask
      drm/i915: enable 36bit physical address for hardware status page

Zhu Yi (1):
      iwlwifi: fix iwl_queue_used bug when read_ptr == write_ptr

Zou Nan hai (1):
      drm/i915: remove loop in Ironlake interrupt handler
