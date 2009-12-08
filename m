Return-Path: <linux-kernel-owner+w=401wt.eu-S965908AbZLHTdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965908AbZLHTdR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 14:33:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965896AbZLHTdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 14:33:14 -0500
Received: from kroah.org ([198.145.64.141]:58238 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965868AbZLHTc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 14:32:57 -0500
Date: Tue, 8 Dec 2009 11:32:36 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.31.7
Message-ID: <20091208193236.GC20016@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.31.7 kernel.  All users of the
2.6.31 kernel series are very strongly encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.31.6 and 2.6.31.7

The updated 2.6.31.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.31.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.31.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                                  |    2 
 arch/x86/kernel/acpi/processor.c          |    3 
 drivers/dca/dca-core.c                    |   51 ++++++++++-----
 drivers/hwmon/it87.c                      |    2 
 drivers/isdn/hisax/hfc_usb.c              |    4 -
 drivers/media/common/tuners/tda18271-fe.c |    8 +-
 drivers/media/dvb/frontends/dib7000p.c    |    5 +
 drivers/media/video/em28xx/em28xx-audio.c |    5 +
 drivers/media/video/s2255drv.c            |    5 -
 drivers/misc/thinkpad_acpi.c              |    2 
 drivers/scsi/gdth.c                       |    2 
 drivers/usb/host/ohci-hcd.c               |    5 +
 drivers/usb/host/ohci-pci.c               |   20 ++++++
 drivers/usb/host/ohci-q.c                 |   18 +++--
 drivers/usb/host/ohci.h                   |    9 ++
 drivers/usb/serial/aircable.c             |    5 -
 drivers/usb/serial/belkin_sa.c            |    7 --
 drivers/usb/serial/cp2101.c               |    6 -
 drivers/usb/serial/cyberjack.c            |   20 ++++--
 drivers/usb/serial/cypress_m8.c           |   11 +--
 drivers/usb/serial/digi_acceleport.c      |   20 ++++--
 drivers/usb/serial/empeg.c                |    8 --
 drivers/usb/serial/ftdi_sio.c             |   14 ----
 drivers/usb/serial/garmin_gps.c           |   16 ++++
 drivers/usb/serial/generic.c              |    9 ++
 drivers/usb/serial/io_edgeport.c          |   29 ++++++--
 drivers/usb/serial/io_tables.h            |   12 ++-
 drivers/usb/serial/io_ti.c                |   22 +++++-
 drivers/usb/serial/ipaq.c                 |    7 --
 drivers/usb/serial/iuu_phoenix.c          |    6 -
 drivers/usb/serial/keyspan.c              |   13 +++-
 drivers/usb/serial/keyspan.h              |   12 ++-
 drivers/usb/serial/keyspan_pda.c          |    4 -
 drivers/usb/serial/kl5kusb105.c           |   39 ++++++------
 drivers/usb/serial/kobil_sct.c            |   12 +--
 drivers/usb/serial/mct_u232.c             |   13 +---
 drivers/usb/serial/mos7720.c              |    9 --
 drivers/usb/serial/mos7840.c              |   48 ++++++++++++--
 drivers/usb/serial/omninet.c              |   19 ++++-
 drivers/usb/serial/option.c               |   97 +++++++++++++++++++++++++++---
 drivers/usb/serial/oti6858.c              |    7 --
 drivers/usb/serial/pl2303.c               |    5 -
 drivers/usb/serial/sierra.c               |   28 +++++++-
 drivers/usb/serial/spcp8x5.c              |    5 -
 drivers/usb/serial/ti_usb_3410_5052.c     |   10 +--
 drivers/usb/serial/usb-serial.c           |   29 ++++----
 drivers/usb/serial/visor.c                |   13 +---
 drivers/usb/serial/whiteheat.c            |    6 -
 fs/fuse/dir.c                             |    3 
 fs/fuse/file.c                            |    3 
 fs/jffs2/read.c                           |    9 +-
 include/linux/usb/serial.h                |   12 ++-
 sound/arm/aaci.c                          |    6 +
 sound/usb/usbaudio.h                      |    2 
 54 files changed, 493 insertions(+), 244 deletions(-)

Alan Cox (3):
      tty_port: If we are opened non blocking we still need to raise the carrier
      tty: cp210x: Fix carrier handling
      tty_port: handle the nonblocking open of a dead port corner case

Alan Stern (2):
      USB: usbmon: fix bug in mon_buff_area_shrink
      USB: EHCI: don't send Clear-TT-Buffer following a STALL

Antti Kaijanmäki (1):
      hso: fix soft-lockup

Anuj Aggarwal (1):
      ASoC: AIC23: Fixing infinite loop in resume path

Becky Bruce (1):
      powerpc: Fix DEBUG_HIGHMEM build break from d4515646699

Ben Hutchings (2):
      acenic: Pass up error code from ace_load_firmware()
      sfc: Set ip_summed correctly for page buffers passed to GRO

Brandon Philips (1):
      sky2: set carrier off in probe

Chris Wilson (1):
      drm/i915: Select CONFIG_SHMEM

Chuck Ebbert (1):
      crypto: padlock-aes - Use the correct mask when checking whether copying is required

Clemens Ladisch (5):
      sound: rawmidi: disable active-sensing-on-close by default
      sound: rawmidi: fix checking of O_APPEND when opening MIDI device
      sound: rawmidi: fix double init when opening MIDI device with O_APPEND
      sound: rawmidi: fix MIDI device O_APPEND error handling
      drm/fb: fix FBIOGET/PUT_VSCREENINFO pixel clock handling

Csaba Henk (1):
      fuse: reject O_DIRECT flag also in fuse_create

Daniel J Blueman (1):
      ALSA: hda - Dell Studio 1557 hd-audio quirk

Daniel Mack (1):
      pxamci: call mmc_remove_host() before freeing resources

Dave Jones (1):
      gdth: Prevent negative offsets in ioctl CVE-2009-3080

David Ford (1):
      ipv4: additional update of dev_net(dev) to struct *net in ip_fragment.c, NULL ptr OOPS

David S. Miller (1):
      sparc: Move of_set_property_mutex acquisition outside of devtree_lock grab.

David Woodhouse (1):
      jffs2: Fix memory corruption in jffs2_read_inode_range()

Denis Loginov (1):
      V4L/DVB (12356): gspca - sonixj: Webcam 0c45:6148 added

Devin Heitmueller (1):
      V4L/DVB (13190): em28xx: fix panic that can occur when starting audio streaming

Eric Dumazet (2):
      udp: Fix udp_poll() and ioctl()
      net: fix sk_forward_alloc corruption

Eric W. Biederman (1):
      USB: ftdi_sio: Keep going when write errors are encountered.

Erik Andrén (3):
      V4L/DVB (13255): gspca - m5602-s5k4aa: Add vflip quirk for the Bruneinit laptop
      V4L/DVB (13256): gspca - m5602-s5k4aa: Add another MSI GX700 vflip quirk
      V4L/DVB (13257): gspca - m5602-s5k4aa: Add vflip for Fujitsu Amilo Xi 2528

Greg Kroah-Hartman (1):
      Linux 2.6.31.7

Hans Verkuil (2):
      V4L/DVB (13321): radio-gemtek-pci: fix double mutex_lock
      V4L/DVB (12948): v4l1-compat: fix VIDIOC_G_STD handling

Harald Welte (1):
      Enable ACPI PDC handshake for VIA/Centaur CPUs

Heiko Carstens (1):
      fs: add missing compat_ptr handling for FS_IOC_RESVSP ioctl

Helge Deller (1):
      modules: don't export section names of empty sections via sysfs

Henry Gebhardt (1):
      USB: cdc_acm: Fix race condition when opening tty

Jamal Hadi Salim (1):
      pkt_sched: pedit use proper struct

Jan Engelhardt (1):
      netfilter: xt_connlimit: fix regression caused by zero family value

Jasper Spaans (1):
      bonding: Modify hash transmit policies to use the packet's source MAC address

Jean Delvare (3):
      hwmon: (adt7475) Fix temperature fault flags
      hwmon: (adt7475) Cache limits for 60 seconds
      i2c: Fix userspace_device list corruption

Jean-Francois Moine (4):
      V4L/DVB (12280): gspca - sonixj: Remove auto gain/wb/expo for the ov7660 sensor.
      V4L/DVB (12501): gspca - sonixj: Do the ov7660 sensor work again.
      V4L/DVB (12691): gspca - sonixj: Don't use mdelay().
      V4L/DVB (12696): gspca - sonixj / sn9c102: Two drivers for 0c45:60fc and 0c45:613e.

Jeff Layton (2):
      cifs: don't use CIFSGetSrvInodeNumber in is_path_accessible
      cifs: clean up handling when server doesn't consistently support inode numbers

Jesse Barnes (1):
      drm: work around EDIDs with bad htotal/vtotal values

Johannes Berg (3):
      mac80211: fix two remote exploits
      mac80211: fix spurious delBA handling
      rfkill: fix miscdev ops

Jozsef Kadlecsik (1):
      netfilter: nf_nat: fix NAT issue in 2.6.30.4+

Julian Anastasov (1):
      ALSA: usb-audio: fix combine_word problem

KAMEZAWA Hiroyuki (1):
      memcg: fix wrong pointer initialization at page migration when memcg is disabled.

Kenji Kaneshige (1):
      PCI: Prevent AER driver from being loaded on non-root port PCIE devices

Larry Finger (2):
      rtl8187: Fix kernel oops when device is removed when LEDS enabled
      b43: Work around mac80211 race condition

Libin Yang (1):
      USB: ohci: quirk AMD prefetch for USB 1.1 ISO transfer

Mark Brown (1):
      ASoC: Fix suspend with active audio streams

Martin Samek (1):
      V4L/DVB (13079): dib0700: fixed xc2028 firmware loading kernel oops

Mel Gorman (2):
      page allocator: Do not allow interrupts to use ALLOC_HARDER
      page allocator: always wake kswapd when restarting an allocation attempt after direct reclaim failed

Michael Buesch (1):
      b43: Fix DMA TX bounce buffer copying

Michael Krufky (4):
      V4L/DVB (13107): tda18271: fix overflow in FM radio frequency calculation
      V4L/DVB (13202): smsusb: add autodetection support for three additional Hauppauge USB IDs
      V4L/DVB (13313): saa7134: add support for FORCE_TS_VALID mode for mpeg ts input
      V4L/DVB (13314): saa7134: set ts_force_val for the Hauppauge WinTV HVR-1150

Michal Simek (1):
      tty/of_serial: add missing ns16550a id

Mike Isely (3):
      V4L/DVB (13169): bttv: Fix potential out-of-order field processing
      V4L/DVB (13170): bttv: Fix reversed polarity error when switching video standard
      V4L/DVB (13230): s2255drv: Don't conditionalize video buffer completion on waiting processes

Mimi Zohar (1):
      ima: replace GFP_KERNEL with GFP_NOFS

Nanhai Zou (1):
      drm/i915: Fix IRQ stall issue on Ironlake

Neil Brown (1):
      block: use after free bug in __blkdev_get

NeilBrown (4):
      md: don't clear endpoint for resync when resync is interrupted.
      md/raid5: make sure curr_sync_completes is uptodate when reshape starts
      md/raid1/raid10: add a cond_resched
      md: revert incorrect fix for read error handling in raid1.

Nick Kossifidis (1):
      ath5k: Linear PCDAC code fixes

Oliver Neukum (1):
      USB: work around for EHCI with quirky periodic schedules

Paul Mackerras (1):
      perf_event: Adjust frequency and unthrottle for non-group-leader events

Peter Feuerer (3):
      acerhdf: fix fan control for AOA150 model
      acerhdf: additional BIOS versions
      acerhdf: return temperature in milidegree instead of degree

Robert Lowery (1):
      V4L/DVB (13436): cxusb: Fix hang on DViCO FusionHDTV DVB-T Dual Digital 4 (rev 1)

Rodolfo Giometti (2):
      pps: events reporting fix up
      pps: locking scheme fix up for PPS_GETPARAMS

Roel Kluin (3):
      thinkpad-acpi: fix sign of ERESTARTSYS return
      sparc64: replace parentheses in pmul()
      isdn: hfc_usb: Fix read buffer overflow

Russell King (3):
      ALSA: AACI: fix AC97 multiple-open bug
      ALSA: AACI: fix recording bug
      kmap: fix build errors with DEBUG_HIGHMEM enabled

Rusty Russell (4):
      sched: Fix boot crash by zalloc()ing most of the cpu masks
      sched: Fix isolcpus boot option
      speedstep-ich: fix error caused by 394122ab144dae4b276d74644a2f11c44a60ac5c
      param: don't complain about unused module parameters.

Ryusuke Konishi (1):
      nilfs2: fix kernel oops in error case of nilfs_ioctl_move_blocks

Samuel Thibault (1):
      Input: keyboard - fix braille keyboard keysym generation

Sarah Sharp (3):
      USB: xhci: Fix bug memory free after failed initialization.
      USB: xhci: Fix TRB physical to virtual address translation.
      USB: xhci: Fix scratchpad deallocation.

Scott Valentine (1):
      rtc: v3020: fix v3020_mmio_read_bit()

Sergei Shtylyov (1):
      USB: musb_gadget: fix STALL handling

Seth Barry (1):
      V4L/DVB (13109): tda18271: fix signedness issue in tda18271_rf_tracking_filters_init

Soeren Sandmann (2):
      highmem: Fix race in debug_kmap_atomic() which could cause warn_count to underflow
      highmem: Fix debug_kmap_atomic() to also handle KM_IRQ_PTE, KM_NMI, and KM_NMI_PTE

Steve French (2):
      CIFS: fix oops in cifs_lookup during net boot
      CIFS: Duplicate data on appending to some Samba servers

Sukadev Bhattiprolu (1):
      pidns: fix a leak in /proc dentries and inodes with pid namespaces.

Suresh Jayaraman (1):
      cifs: clear server inode number flag while autodisabling

Thomas Dahlmann (1):
      usb: amd5536udc: fixed shared interrupt bug and warning oops

Thomas Gleixner (1):
      uids: Prevent tear down race

Trond Myklebust (1):
      NFSv4: Fix a cache validation bug which causes getcwd() to return ENOENT

Wey-Yi Guy (2):
      iwlwifi: Use RTS/CTS as the preferred protection mechanism for 6000 series
      iwlwifi: Fix issue on file transfer stalled in HT mode

Zhang Le (1):
      USB: option.c: add support for D-Link DWM-162-U5

Zhenyu Wang (1):
      agp/intel: new host bridge support

