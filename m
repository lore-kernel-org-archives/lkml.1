Return-Path: <linux-kernel-owner+w=401wt.eu-S1759398AbYERWNB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759398AbYERWNB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 18:13:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755059AbYERWMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 18:12:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59288 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753470AbYERWMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 18:12:45 -0400
Date: Sun, 18 May 2008 15:12:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.26-rc3
Message-ID: <alpine.LFD.1.10.0805181440310.32253@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Another week, another -rc release.

This time around, we have 60+% of the changes in drivers, notably 
drives/video and drivers/media, with some infiniband, networking and usb 
lovin' to fill things out.

The rest is (as usual) mostly arch updates (I really should move 
"include/asm-xyz" to "arch/xyz/include" to make the nesting come out right 
- now you have to look at both include and arch to see what is 
architecture-dependent code), this time mostly mips, m68k and uml.

The dirstat looks like this:

   5.8% arch/m68k/configs/
   5.8% arch/m68k/
   3.4% arch/mips/au1000/common/
   6.2% arch/mips/au1000/
   6.9% arch/mips/
  17.8% arch/
  22.4% drivers/media/common/tuners/
  25.2% drivers/media/
   3.3% drivers/misc/sgi-xp/
   4.1% drivers/net/sfc/
   8.1% drivers/net/
  18.2% drivers/video/logo/
  18.4% drivers/video/
  62.7% drivers/
   3.2% include/asm-ia64/uv/
   3.3% include/asm-ia64/
   8.0% include/asm-mips/mach-au1x00/
  10.3% include/asm-mips/
  15.7% include/

and the Shortlog is appended for those people who want to get a better 
view of the details. As usual, git people can get all of it, and non-git 
people can check out the unabridged logs in the usual places.

One interesting (well, to me - perhaps not to most other people) landmark 
that is coming up is that we've now been using git for almost exactly as 
long as we used BitKeeper - just over three years. We started using BK in 
February 2002, with the final 2.6.12-rc2 release in early April 2005. And 
the first kernel git commit was two weeks later.

So because of that event, I looked at some of the statistics of the BK 
timeframe and the git timeframe. The most striking difference has nothing 
to do with git or BK (the switch-over timing was just the reason I decided 
to take a look), but with the fact that we're not just continuing to 
develop, but we're developing faster and with more people.

So during the three years 2002->2005, we had 63428 commits, attributed to 
1560 different authors (caveat: misspellings etc will mean that some 
people get counted more than ones). During the last three years, we've had 
96885 attributed to 4068 distinct authors (with the same caveat, 
obviously).

I didn't do a lot of per-commit statistics yet, but from the little I've 
done it also seems like we've gotten increasingly better at doing small 
commits (which is probably one of the reasons we have a larger number of 
them, but also why we have more authors - small commits is how people get 
into doing kernel development).

[ But part of it is also because we're better at authorship tracking: the 
  BK history has 6000+ patches attributed to Andrew, and a number of them
  have a "From: xyz" in them, but my statistics only looked at who got
  attributed in the SCM logs.  Our patch extraction tools have also gotten 
  better over the years.. ]

I'll see if I can make some interesting statistics about just how 
development has changed over the last three years, but no promises. The 
actual exact "same amount of time" time is coming up in another month or 
so.

		Linus

---
Adrian Bunk (6):
      [MIPS] unexport __kmap_atomic_to_page
      [MIPS] markeins: build fix
      V4L/DVB (7856): cx18/: possible cleanups
      V4L/DVB (7857): make itd1000_fre_values[] static const
      make ide-iops.c:SELECT_MASK() static
      [ARM] arm/kernel/arthur.c: add MODULE_LICENSE

Alan Cox (3):
      strip: Fix termios assumption
      cris: Fix compile failure due to typo in serial driver
      parisc: new termios definitions

Alan Stern (1):
      USB: create attributes before sending uevent

Alex Chiang (1):
      [IA64] allow user to force_pal_cache_flush

Andrew Morton (5):
      drivers/char/synclink_gt.c: don't return an uninitialised local
      x86: early_init_centaur(): use set_cpu_cap()
      V4L/DVB (7800): tuner_symbol_probe(): don't do symbol_put() if symbol_request() failed
      tty_check_change(): avoid taking tasklist_lock while holding tty->ctrl_lock
      net/irda/irnet/irnet_irda.c needs unaligned.h

Andy Fleming (3):
      gianfar: Fix a bug where the pointer never moves for dma_unmap...
      [POWERPC] 85xx: Add 8568 PHY workarounds to board code
      [POWERPC] 85xx: Fix some sparse warnings for 85xx MDS

Andy Walls (1):
      V4L/DVB (7891): cx18/ivtv: fix open() kernel oops

Aneesh Kumar K.V (1):
      ext4: Retry block allocation if new blocks are allocated from system zone.

Anton Vorontsov (4):
      [ALSA] soc - fsl_ssi.c fix "BUG: scheduling while atomic"
      [POWERPC] 86xx: mpc8610_hpcd: use ULI526X driver for on-board ethernet
      [POWERPC] 86xx: mpc8610_hpcd: add support for NOR and NAND flashes
      [POWERPC] 86xx: mpc8610_hpcd: fix second serial port

Auke Kok (1):
      New maintainer for Intel ethernet adapters

Avi Kivity (1):
      x86: fix crash on cpu hotplug on pat-incapable machines

Bartlomiej Zolnierkiewicz (6):
      alim15x3: trivial cleanup for ali_set_pio_mode()
      alim15x3: remove stale warning about ATI RS100 northbridge
      alim15x3: add "wdc_udma" module parameter
      alim15x3: remove WDC_ALI15X3 config option
      ide/Kconfig: couple of fixes
      cs5520: disable VDMA

Ben Dooks (1):
      DM9000: Use delayed work to update MII PHY state

Ben Hutchings (9):
      [netdrvr] sfc: Add TSO support
      [netdrvr] sfc: Add phy_flash_cfg module parameter and implementation
      [netdrvr] sfc: Removed bogus 'fall-thru' comments
      [netdrvr] sfc: Remove garbage from comment
      [netdrvr] sfc: Remove kernel-doc comments for removed members of struct efx_nic
      [netdrvr] sfc: Fix code formatting
      [netdrvr] sfc: Remove unused macro EFX_XAUI_RETRAIN_MAX
      [netdrvr] sfc: Increment rx_reset when reported as driver event
      [netdrvr] sfc: sfc: Add self-test support

Benjamin Herrenschmidt (1):
      [POWERPC] vmemmap fixes to use smaller pages

Bernhard Walle (1):
      [IA64] Don't reserve crashkernel memory > 4 GB

Bjorn Helgaas (1):
      PNP: set IRQ index in sysfs "set irq" interface

Björn Krombholz (1):
      PCI: enable nv_msi_ht_cap_quirk for ALi bridges

Brice Goglin (11):
      myri10ge: update firmware headers
      myri10ge: fix module parameter descriptions
      myri10ge: increase and fix handoff timeout
      myri10ge: properly align scratch buffers
      myri10ge: report FIBER in ethtool for XFP based NIC
      myri10ge: add barrier in myri10ge_send_cmd
      myri10ge: trivial formatting fix
      myri10ge: fix potential infinite loop in enable_ecrc
      myri10ge: move data structures into a single slice
      myri10ge: cleanup retrieving of firmware capabilities
      myri10ge: fix the number of interrupt slots

Christoph Hellwig (1):
      ufs: remove unneeded ufs_put_inode prototype

Cornelia Huck (4):
      [S390] Remove last traces of cio_msg=.
      [S390] dasd: Use const in busid functions.
      [S390] s390dbf: Use const char * for dbf name.
      [S390] tape: Use ccw_dev_id to build cdev_id.

Cyrill Gorcunov (7):
      [CIFS] cifs_find_tcp_session cleanup
      [MIPS] ELF handling - use SELFMAG instead of numeric constant
      x86: wakeup.lds.S - section ordering fix
      uml: use PAGE_SIZE in linker scripts
      init: don't lose initcall return values
      eCryptFS: fix imbalanced mutex locking
      initcalls: Fix m68k build and possible buffer overflow

Dan Williams (2):
      md: fix raid5 'repair' operations
      USB: option: add new Dell 5520 HSDPA variant

Darrick J. Wong (1):
      adt7473: minor documentation update

Dave Young (1):
      Driver core: struct class remove children list

David Brownell (5):
      USB: serial gadget: cleanup/reorg
      USB: serial gadget: remove needless data structure
      USB: serial gadget: simplify endpoint handling
      USB: serial gadget: descriptor cleanup
      USB: atmel_usba_udc fixes, mostly disconnect()

David S. Miller (10):
      sparc64: Work around memory probing bug in openfirmware.
      syncppp: Fix crashes.
      sparc: Fix mremap address range validation.
      lmb: Fix inconsistent alignment of size argument.
      lmb: Make lmb debugging more useful.
      net: Set LL_MAX_HEADER properly for wireless.
      mac80211: Use skb_header_cloned() on TX path.
      sparc64: Use a TS_RESTORE_SIGMASK
      sparc64: Fix lmb_reserve() args in find_ramdisk().
      sparc64: Update defconfig.

Dean Nelson (2):
      drivers/misc/sgi-xp: clean up return values
      drivers/misc/sgi-xp: replace partid_t with a short

Denis Cheng (1):
      mm/pdflush.c: merge the same code in two path

Dhaval Giani (1):
      cgroups: fix documentation

Divy Le Ray (2):
      cxgb3 - fix port up/down error path
      cxgb3 - fix EEH

Eduardo Valentin (1):
      ARM: OMAP: Keymap fix for palmte and palmz71

Emmanuel Grumbach (1):
      iwlwifi: Fix frequency in rx_status fill

Enrico Scholz (2):
      DM9000: Add __devinit and __devexit attributes to probe and remove
      DM9000: Update and fix driver debugging messages

Eric BENARD (1):
      spi: pxa2xx_spi clock resume bugfix

Eric Dumazet (2):
      oprofile: don't request cache line alignment for cpu_buffer
      per_cpu: fix DEFINE_PER_CPU_SHARED_ALIGNED for modules

Eric Leblond (1):
      netfilter: ctnetlink: dump conntrack ID in event messages

Eric Sesterhenn (1):
      Fix hfsplus oops on image without extents

Eric Van Hensbergen (4):
      9p: Documentation updates
      9p: propagate parse_option changes to client and transports
      9p: make cryptic unknown error from server less scary
      9p: fix error path during early mount

Eugeniy Meshcheryakov (1):
      USB: do not handle device 1410:5010 in 'option' driver

FUJITA Tomonori (1):
      [POWERPC] spufs: Fix compile error

Fernando Luis Vázquez Cao (1):
      Fix c67x00-ll-hpi compilation failure (bug #10627)

Filip Aben (1):
      USB: unusual_devs: Add support for GI 0401 SD-Card interface

Geert Uytterhoeven (19):
      fbdev: do not let CONFIG_FB_DEFERRED_IO default to y
      m68k: Convert access_ok() to an inline function
      m68k: Kill CONFIG_FB_DAFB
      m68k: FB_HP300 depends on DIO and doesnt need FB_CFB_FILLRECT
      m68k: Kill CONFIG_WHIPPET_SERIAL
      m68k vme_scc: avoid global namespace pollution
      m68k: Make gcc aware that BUG() does not return
      m68k: Correct jump if not running on HP300
      m68k: macide doesnt check for Mac
      m68k: dnfb doesnt check for Apollo
      m68k: Some network drivers do not check the platform
      m68k: Some input drivers do not check the platform
      m68k: Return -ENODEV if no device is found
      m68k: Q40/Q60 floppy support is broken
      m68k: export m68k_mmutype
      m68k: Prefix ISA type with ISA_TYPE_
      m68k: Correctly handle multi-ISA at runtime
      m68k: Update defconfigs
      m68k: Add multi_defconfig

Geoff Levand (1):
      memory_hotplug: check for walk_memory_resource() failure in online_pages()

Graf Yang (1):
      irda: Fix a misalign access issue. (v2)

Grant Likely (1):
      mpc5200_psc_spi: typo fix in header block

Greg Kroah-Hartman (3):
      USB: add new moto_modem driver for some Morotola phones
      USB: add association.h
      USB: add Telstra NextG CDMA id to option driver

Greg Ungerer (1):
      m68knommu: missing sections for linker script

Guennadi Liakhovetski (2):
      V4L/DVB (7810): soc_camera: mt9v022 and mt9m001 depend on I2C
      V4L/DVB (7859): mt9v022: fix a copy-paste error in comment

H. Peter Anvin (1):
      types: s390: fix #ifdef reversal in <asm-s390/types.h>

Hannes Hering (3):
      memory: Introduce exports for memory notifiers
      ehea: Add dependency to Kconfig
      ehea: Add DLPAR memory remove support

Hans Verkuil (8):
      V4L/DVB (7852): ivtv: prefix ivtv external functions with ivtv_
      V4L/DVB (7853): ivtv/cx18: fix compile warnings
      V4L/DVB (7854): cx18/ivtv: improve and fix out-of-memory handling
      V4L/DVB (7860a): Add MAINTAINERS for cx18
      V4L/DVB (7887): cx18: fix Compro H900 analog support.
      V4L/DVB (7888): cx18: minor card definition updates.
      V4L/DVB (7889): cx18: improve HVR-1600 detection.
      V4L/DVB (7890): cx18: removed bogus and confusing conditional

Hartmut Hackmann (2):
      V4L/DVB (7880): saa7134: remove explicit GPIO initialization
      V4L/DVB (7881): saa7134: fixed a compile warning in saa7134-core.c

Harvey Harrison (6):
      mmc: make one-bit signed bitfields unsigned
      usb: fix integer as NULL pointer warnings found by sparse
      lib: create common ascii hex array
      parisc: replace remaining __FUNCTION__ occurrences
      drivers/parisc: replace remaining __FUNCTION__ occurrences
      byteorder: don't directly include linux/byteorder/generic.h

Heiko Carstens (5):
      memory hotplug: memmap_init_zone called twice
      memory_hotplug: always initialize pageblock bitmap
      [S390] sparsemem vmemmap: initialize memmap.
      [S390] smp: __smp_call_function_map vs cpu_online_map fix.
      [S390] show_interrupts: prevent cpu hotplug when walking cpu_online_map.

Helge Deller (1):
      parisc: fix trivial section name warnings

Helmut Schaa (1):
      mac80211: fix association with some APs

Hidetoshi Seto (3):
      [IA64] fix interrupt masking for pending works on kernel leave
      [IA64] trivial cleanup for entry.S
      [IA64] trivial cleanup for perfmon.c

Hiroshi DOYU (2):
      ARM: OMAP: Fix Unbalanced enable for IRQ in omap mailbox
      ARM: OMAP: Add fuctional clock enabler for iva2

Huang Weiyi (1):
      [S390] blacklist.c: removed duplicated include

Huang, Xiaolan (1):
      [IA64] fix personality(PER_LINUX32) performance issue

Hugh Dickins (1):
      x86: fix app crashes after SMP resume

Högander Jouni (1):
      ARM: OMAP: Add PARENT_CONTROLS_CLOCK flag to dpll5_m2_ck

Iain McFarlane (1):
      USB: add Zoom Telephonics Model 3095F V.92 USB Mini External modem to cdc-acm

Ilpo Järvinen (2):
      tcp FRTO: Fix fallback to conventional recovery
      tcp FRTO: work-around inorder receivers

Ingo Molnar (6):
      x86: fix csum_partial() export
      V4L/DVB (7834): build fix for drivers/media/video/au0828
      V4L/DVB (7836): cinergyT2 build fix
      V4L/DVB (7858): video: build fix for drivers/media/video/mt9v022.c
      tty: fix BKL related leak and crash
      x86: remove mwait capability C-state check

Ishizaki Kou (1):
      [POWERPC] cell: Fix section mismatches in io-workarounds code

Ivo van Doorn (4):
      rt2x00: Don't use pskb_expand_head()
      rt2x00: Fix broken recover-on-error path
      rt2x00: Clean up error handling of PCI queue DMA allocation.
      mac80211: Don't encrypt beacons

Jack Steiner (2):
      [IA64] Add header files for SGI UV platform
      [IA64] machvec support for SGI UV platform

James Bottomley (5):
      [SCSI] gdth: fix timer handling
      [SCSI] gdth: fix Error: Driver 'gdth' is already registered, aborting...
      [SCSI] aha152x: fix init suspiciously returned 1, it should follow 0/-E convention
      [SCSI] aha152x: Fix oops on module removal
      x86: [VOYAGER] fix duplicate phys_cpu_present_map symbol

Jan Engelhardt (2):
      vt/fbcon: update scrl_erase_char after 256/512-glyph font switch
      vt/fbcon: fix background color on line feed

Jan Kara (5):
      quota: don't call sync_fs() from vfs_quota_off() when there's no quota turn off
      ext4: correct mount option parsing to detect when quota options can be changed
      ext4: Fix mount messages when quota disabled
      ext4: fix synchronization of quota files in journal=data mode
      ext4: fix typos in messages and comments (journalled -> journaled)

Jarkko Nikula (3):
      ARM: OMAP: DMA: Fix incorrect channel linking
      [ALSA] ASoC: Fix TLV320AIC3X mono line output interconnect
      [ALSA] ASoC: Fix wrong enum count for jack_function in N810 machine driver

Jay Cliburn (4):
      atl1: add PHY power save mode
      atl1: fix broken suspend and resume
      atl1: add shutdown callback
      atl1: bump version number

Jean Delvare (9):
      Fix misuses of bdevname()
      i2c: New co-maintainer
      i2c-nforce2: Disable the second SMBus channel on the DFI Lanparty NF4 Expert
      i2c: Clean up Blackfin BF527 I2C device declarations
      i2c: Switch pasemi to the new device/driver matching scheme
      i2c: Convert remaining new-style drivers to use module aliasing
      i2c: Kill the old driver matching scheme
      i2c-amd756: Fix functionality flags
      i2c/max6875: Really prevent 24RF08 corruption

Jeff Dike (13):
      uml: redo host capability detection and disabling
      uml: style fixes
      uml: hppfs fixes
      uml: move hppfs_kern.c to hppfs.c
      uml: tidy ptrace interface
      uml: fix build when SLOB is enabled
      uml: remove unused header
      uml: fix bad NTP interaction with clock
      uml: use __SPIN_LOCK_UNLOCKED
      uml: physical memory shouldn't include initial stack
      uml: random driver fixes
      uml: style fixes in the random driver
      uml: track and make up lost ticks

Jeff Garzik (1):
      [MIPS] msp_hwbutton.c: minor irq handler cleanups

Jeff Layton (2):
      [CIFS]  add local struct inode pointer to cifs_setattr
      [CIFS] when not using unix extensions, check for and set ATTR_READONLY on create and mkdir

Jens Rottmann (1):
      fix "lxfb: extend PLL table to support dotclocks below 25 MHz"

Jeremy Higdon (1):
      [SCSI] qla1280: Fix queue depth problem

Jeremy McNicoll (1):
      [POWERPC] 85xx: SBC8548 - Add flash support and HW Rev reporting

Jesse Brandeburg (1):
      sky2: fix simple define thinko

Jim Meyering (1):
      fs/9p/v9fs.c (v9fs_parse_options): Handle kstrdup and match_strdup failure. Now that this function can fail, return an int, diagnose other option-parsing failures, and adjust the sole caller: (v9fs_session_init): Handle kstrdup failure. Propagate any new v9fs_parse_options failure "up".

Jiri Olsa (1):
      uml: use DIV_ROUND_UP

Jiri Slaby (1):
      char: select fw_loader by moxa

Joakim Tjernlund (1):
      spi_mpc83xx: much improved driver

Johann Felix Soden (1):
      uml: fix errno return

Johannes Berg (4):
      mac80211: fix debugfs default key oops
      zd1211rw: fix potential use-after-free bug
      net: Allow netdevices to specify needed head/tailroom
      mac80211: assign needed_headroom/tailroom for netdevs

Johannes Weiner (1):
      parisc: remove redundant display of free swap space in show_mem()

John W. Linville (1):
      wavelan: avoid index past end of array if DEBUG_SHOW_UNUSED is defined

Jordan Crouse (1):
      Update Geode mailing list in MAINTAINERS

Josef 'Jeff' Sipek (2):
      9p: use struct mutex instead of struct semaphore
      9p: Correct fidpool creation failure in p9_client_create

Jouni Högander (2):
      ARM: OMAP: Fix 34xx to use correct shift values for gpio2-6 fclks
      ARM: OMAP: PRCM fixes to ssi clock handling

Julia Lawall (2):
      pppol2tp: Remove null pointer dereference.
      drivers/video/pnx4008: eliminate double free

KOSAKI Motohiro (2):
      make vmstat cpu-unplug safe
      memcg: fix possible panic when CONFIG_MM_OWNER=y

Kalle Jokiniemi (1):
      ARM: OMAP: Fixed comments on global PRM register usage

Kay Sievers (1):
      block: do_mounts - accept root=<non-existant partition>

Kenji Kaneshige (3):
      PCI ACPI: fix uninitialized variable in __pci_osc_support_set
      ACPI/PCI: handle multiple _OSC
      ACPI/PCI: another multiple _OSC memory leak fix

Kevin D. Kissell (2):
      [MIPS] Fixes necessary for non-SMP kernels and non-relocatable binaries
      [MIPS] MT: Functional fixes and a little reformatting of APRP support

Krzysztof Helt (2):
      tridentfb: remove misplaced enable_mmio()
      tridentfb: improve clock setting accuracy

Kyle McMartin (3):
      parisc: use conditional macro for 64-bit wide ops
      parisc: remove -traditional from assembler flags
      arch/parisc/kernel/perf_asm.S: build fix

Lennert Buytenhek (2):
      [ARM] 5034/1: fix arm{925,926,940,946} dma_flush_range() in WT mode
      [ARM] 5037/1: Orion: fix DNS323/Kurobox Pro PCI initialisation

Linus Torvalds (5):
      Fix up 'need_resched()' definition
      Make 'cond_resched()' nullification depend on PREEMPT_BKL
      Clean up 'print_fn_descriptor_symbol()' types
      Split up 'do_initcalls()' into two simpler functions
      Linux 2.6.26-rc3

Luis Carlos Cobo (2):
      mac80211: fix incorrect mesh header length
      mac80211: fix access to null skb

Luis R. Rodriguez (1):
      prism54: fix regression with missing carrier in AP-mode

Luke Browning (1):
      [POWERPC] spufs: Fix pointer reference in find_victim

Maciej W. Rozycki (4):
      rtc: rtc_time_to_tm: use unsigned arithmetic
      RTC/watchdog: M41T80: fix a potential use of unitialized data
      rtc: m41t80: include <linux/kernel.h> for printk()
      SWARM IDE: Fix up following changes to ide_hwif_t

Marcin Slusarz (2):
      usbtest: comment on why this code "expects" negative and positive errnos
      [S390] vmlogrdr: module initialization function should return negative errors

Mariusz Kozlowski (1):
      [ARM] fix parenthesis in include/asm-arm/arch-omap/control.h

Markus Armbruster (1):
      add match_strlcpy() us it to make v9fs make uname and remotename parsing more robust

Masakazu Mokuno (1):
      PS3: gelic: fix memory leak

Matheos Worku (1):
      niu: Determine the # of ports from the card's VPD data

Matthias Schwarzott (1):
      V4L/DVB (7861): mt312: Prefix functions only with mt312_, Add zl10313 to kconfig description

Mauro Carvalho Chehab (15):
      V4L/DVB (7801): saa7134: detach frontend, if tuner or Diseqc attach fails
      V4L/DVB (7802): tuner: Failures at tuner_attach were producing OOPS
      V4L/DVB (7804): tea5767: Fix error logic
      V4L/DVB (7805): saa7134: dvb_unregister_frontend() shouldn't be called, if not registered yet
      V4L/DVB (7806): em28xx: dvb_unregister_frontend() shouldn't be called, if not registered yet
      V4L/DVB (7807): cx88: Fix error handling, when dvb_attach() fails
      V4L/DVB (7813): Fix compilation, when V4L1_COMPAT is disabled
      V4L/DVB (7846): Re-creates VIDEO_TUNER
      V4L/DVB (7847): Simplifies Kconfig rules
      V4L/DVB (7848): Fix dependencies for tuner-xc2028 and em28xx-dvb
      V4L/DVB (7849): cx88: fix Kconfig depencencies for FW_LOADER
      V4L/DVB (7851): Fix FW_LOADER depencency at v4l/dvb
      V4L/DVB (7898): Fix VIDEO_MEDIA Kconfig logic
      V4L/DVB (7899): Fixes a few remaining Kbuild issues at common/tuners
      V4L/DVB (7900): pvrusb: Fix Kconfig if DVB=m V4L_core=y

Mel Gorman (1):
      parisc: fix DISCONTIGMEM compile breakage

Michael Abbott (1):
      [ARM] colibri: fix support for DM9000 ethernet device

Michael Ernst (1):
      [S390] cio: Remove CCW_CMD_SUSPEND_RECONN in front of CCW_CMD_SET_PGID.

Michael Krufky (16):
      V4L/DVB (7808): cx23885: fix kbuild dependencies
      V4L/DVB (7823): em28xx: add additional usb subids for Hauppauge HVR-950
      V4L/DVB (7827): cx23885: add missing subsystem ID for Hauppauge HVR-1200 OEM
      V4L/DVB (7828): cx23885: update model matrix for Hauppauge WinTV HVR-1200 & WinTV HVR-1700
      V4L/DVB (7829): cx23885: remove remaining references to dvb-pll
      V4L/DVB (7832): xc5000: MEDIA_TUNER_XC5000 must select FW_LOADER
      V4L/DVB (7837): tda18271: fix error handling in init and sleep paths
      V4L/DVB (7838): tda18271: fix error handling in tda18271c2_rf_cal_init path
      V4L/DVB (7839): tda18271: abort rf band calibration loop on errors
      V4L/DVB (7840): tda18271: make tda18271_set_standby_mode less verbose for basic debug
      V4L/DVB (7841): tda18271: fix error handling in tda18271_channel_configuration
      V4L/DVB (7842): tda18271: fix error handling in tda18271c2_rf_tracking_filters_correction
      V4L/DVB (7843): tda18271: fix error handling in tda18271c1_rf_tracking_filter_calibration
      V4L/DVB (7844): tda18271: add tda_fail macro to log error cases
      V4L/DVB (7893): xc5000: bug-fix: allow multiple devices in a single system
      V4L/DVB (7895): tveeprom: update Hauppauge analog audio and video decoders

Mike Christie (2):
      [SCSI] libiscsi regression in 2.6.25: fix nop timer handling
      [SCSI] libiscsi regression in 2.6.25: fix setting of recv timer

Mike Frysinger (1):
      asm-{alpha,h8300,um,v850,xtensa}/param.h: unbreak HZ for userspace

Miklos Szeredi (3):
      ecryptfs: clean up (un)lock_parent
      fuse: add flag to turn on big writes
      mm: fix infinite loop in filemap_fault

Mingming Cao (2):
      jbd: need to hold j_state_lock to updates to transaction t_state to T_COMMIT
      jbd2: update transaction t_state to T_COMMIT fix

Mirco Tischler (1):
      cgroups: fix compile warning

Nate Case (2):
      ipmi: support I/O resources in OF driver
      [POWERPC] Fix uninitialized variable bug in copy_{to|from}_user

Neil Brown (1):
      Remove blkdev warning triggered by using md

Nick Piggin (2):
      read_barrier_depends arch fixlets
      fix SMP data race in pagetable setup vs walking

Nicolas Ferre (2):
      atmel_lcdfb: fix pixclock divider calculation
      atmel_lcdfb: fix initialization of a pre-allocated framebuffer

Patrick McHardy (2):
      mac80211: mesh hwmp: fix kfree(skb)
      sctp: Fix use of uninitialized pointer

Paul Jackson (1):
      cpumask: remove bitmap_scnprintf_len and cpumask_scnprintf_len

Paul Mackerras (2):
      [POWERPC] Fix default cputable entries for e200 and e500 families
      [POWERPC] ppc: More compile fixes

Paul Walmsley (1):
      ARM: OMAP: Add calls to omap2_set_globals_*()

Pavel Emelyanov (6):
      Fix GFP_KERNEL allocation under read lock.
      Fix not checked kmalloc() result.
      Fix potential scheduling while atomic in mesh_path_add.
      IB/ipath: Make ipath_portdata work with struct pid * not pid_t
      cipso: Relax too much careful cipso hash function.
      ppp: Do not free not yet unregistered net device.

Pavel Roskin (1):
      mac80211: add missing newlines in printk()

Phil Dibowitz (1):
      USB: Fix unusual_devs.h ordering

Phil Oester (1):
      netfilter: xt_iprange: module aliases for xt_iprange

Philipp Zabel (1):
      [ALSA] ASoC: build fix for snd_soc_info_bool_ext

Pranith Kumar (1):
      x86: arch/x86/mm/pat.c - fix warning

Prarit Bhargava (1):
      [IA64] Properly unregister legacy interrupts

Ralf Baechle (5):
      [MIPS] Don't use max_pfn which is no longer initialized these days.
      [MIPS] IRIX: Handle do_brk() error return correctly.
      [MIPS] Initialize max_pfn again.
      [MIPS] Add empty argument parenthesis to GCC_IMM_ASM
      [MIPS] Get rid of __ilog2

Ralph Campbell (3):
      IB/ipath: Fix RC and UC error handling
      IB/ipath: Fix many locking issues when switching to error state
      IB/ipath: Fix RDMA read response sequence checking

Rami Rosen (1):
      net: Fix typo in net/core/sock.c.

Randy Dunlap (2):
      V4L/DVB (7835): multimedia/video: fix au0828 Kconfig
      USB: isp1760: fix printk format

Rene Herman (3):
      pnp: clean up pnp_fixup_device()
      pnp: add pnp_build_option() to the API
      pnp: add ISAPnP MPU option quirks

Robert Jarzmik (1):
      USB: pxa27x_udc: minor fixes

Robert P. J. Day (4):
      uml: fix CONFIG_RAW dependencies
      mn10300: replace deprecated "TOPDIR" with newer "srctree"
      [POWERPC] macintosh: Replace deprecated __initcall with device_initcall
      parisc: Remove ioctl.h content picked up from <asm-generic/ioctl.h>.

Robert Reif (2):
      sparc32: Fix build.
      sparc32: fix rtrap.S typo

Robert Schedel (1):
      V4L/DVB (7830): dvb_ca_en50221: Fix High CPU load in 'top' due to budget_av slot polling

Robin Getz (1):
      video/logo: add support for Blackfin/Linux logo for framebuffer console

Roel Kluin (1):
      [MIPS] ip27-timer: fix unsigned irq < 0

Roland Dreier (2):
      RDMA/nes: Fix up nes_lro_max_aggr module parameter
      IB/ipath: Change ipath_devdata.ipath_sdma_status to be unsigned long

Roland McGrath (1):
      x86: user_regset_view table fix for ia32 on 64-bit

Russell King (3):
      [ARM] export copy_page
      [ARM] pxa: fix pxafb build when cpufreq is enabled
      [ARM] pxa: spitz wants PXA27x UDC definitions

S.Çağlar Onur (1):
      arch/parisc/kernel/unaligned.c: use time_* macros

Sebastian Siewior (3):
      m68knommu: ColdFire add support for kernel preemption (missing chunk)
      usb: fix compile warning in isp1760
      m68knommu: add info about removing mcfserial

Segher Boessenkool (3):
      [POWERPC] ppc: Use ebony_defconfig for defconfig
      [POWERPC] ppc: Include <asm/cacheflush.h> in kernel/ppc_ksyms.c
      [POWERPC] ppc: Don't run prom_init_check for arch/ppc builds

Serge E. Hallyn (1):
      capabilities: add bounding set to /proc/self/status

Sergei Shtylyov (13):
      [MIPS] Alchemy: SMBus resource fix
      [MIPS] Alchemy common headers style cleanup
      [MIPS] Alchemy common code style cleanup
      [MIPS] Alchemy PCI code style cleanup
      [MIPS] DBAu1xx0 code style cleanup
      [MIPS] Pb1000 code style cleanup
      [MIPS] Pb1100 code style cleanup
      [MIPS] Pb1500 code style cleanup
      [MIPS] Pb1550 code style cleanup
      [MIPS] Pb1200/DBAu1200 code style cleanup
      [MIPS] MTX-1 code style cleanup
      [MIPS] XXS1500 code style cleanup
      [MIPS] Pb1000: bury the remnants of the PCI code

Shaohua Li (1):
      ACPI/PCI: handle multiple _OSC

Simon Holm Thøgersen (1):
      [IA64] Remove NULL pointer check for argument never passed as NULL.

Stefan Weinhuber (1):
      [S390] dasd: fix timeout handling in interrupt handler

Steve French (1):
      [CIFS] don't allow demultiplex thread to exit until kthread_stop is called

Steve Wise (1):
      RDMA/cxgb3: Wrap the software send queue pointer as needed on flush

Steven Rostedt (2):
      fix irq flags in mac80211 code
      9p: fix flags length in net

Steven Toth (17):
      V4L/DVB (7862): Add mxl5505s driver for MaxiLinear 5505 chipsets
      V4L/DVB (7864): mxl5005s: Cleanup #1
      V4L/DVB (7865): mxl5005s: Cleanup #2
      V4L/DVB (7866): mxl5005s: Cleanup #3
      V4L/DVB (7867): mxl5005s: Cleanup #4
      V4L/DVB (7868): mxl5005s: Cleanup #5
      V4L/DVB(7869): mxl5005s: Cleanup #6
      V4L/DVB (7870): mxl5005s: Basic digital support.
      V4L/DVB(7871): mxl5005s: Re-org code and update copyrights
      V4L/DVB(7872): mxl5005s: checkpatch.pl compliance
      V4L/DVB(7873): mxl5005s: Fix header includes.
      V4L/DVB(7874): mxl5005s: Fix function statics
      V4L/DVB(7875): mxl5005s: Remove redundant functions
      V4L/DVB(7876): mxl5005s: Remove incorrect copyright holders
      V4L/DVB(7877): mxl5005s: Ensure debug is off
      V4L/DVB(7878): mxl55005s: Makefile and Kconfig additions
      V4L/DVB(7879): Adding cx18 Support for mxl5005s

Takashi Iwai (2):
      x86/pci: fix broken ISA DMA
      x86/PCI: fix broken ISA DMA

Thiemo Seufer (2):
      [MIPS] fix warning message on SMP kernels
      [MIPS] Fix build failure in mips oprofile code

Thomas Bogendoerfer (1):
      [MIPS] Fix __fls for non-MIPS32/MIPS64 cpus

Thomas Gleixner (1):
      x86: disable mwait for AMD family 10H/11H CPUs

Thomas Kunze (1):
      [ARM] 5026/1: locomo: add .settype for gpio and several small fixes

Tiger Yang (1):
      ext3/4: fix uninitialized bs in ext3/4_xattr_set_handle()

Timur Tabi (1):
      [POWERPC] Add null pointer check to of_find_property

Tony Lindgren (2):
      ARM: OMAP: Update MMC header to fix compile
      ARM: OMAP: Warn on disabling clocks with no users

Valerie Clement (1):
      ext4: mballoc fix mb_normalize_request algorithm for 1KB block size filesystems

Venki Pallipadi (2):
      x86/PCI: X86_PAT & mprotect
      mprotect: prevent alteration of the PAT bits

Wei Yongjun (2):
      sctp: Do not enable peer IPv6 address support on PF_INET socket
      sctp: Add address type check while process paramaters of ASCONF chunk

Xiaofan Chen (1):
      USB: remove PICDEM FS USB demo (04d8:000c) device from ldusb

Zhang Wei (1):
      [POWERPC] 83xx: Enable DMA engine on the MPC8377 MDS board.

Zhu Yi (1):
      iwlwifi: fix compile error when CONFIG_MAC80211_DEBUGFS is not selected

andreoli@samba.ing.unimo.it (2):
      USB: Support for the ET502HS HDSPA modem
      USB: Support for the ET502HS HDSPA modem in option driver

mark gross (1):
      PCI: Make the intel-iommu_wait_op macro work when jiffies are not running

maximilian attems (1):
      [ALSA] emux midi synthesizer doesn't honor SOFT_PEDAL-release event

