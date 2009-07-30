Return-Path: <linux-kernel-owner+w=401wt.eu-S1753028AbZG3XK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028AbZG3XK4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 19:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbZG3XKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 19:10:55 -0400
Received: from kroah.org ([198.145.64.141]:54518 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477AbZG3XKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 19:10:53 -0400
Date: Thu, 30 Jul 2009 16:09:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.30.4
Message-ID: <20090730230921.GA14928@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.30.4 kernel.  All users of the
2.6.30 kernel series are very strongly encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.30.3 and 2.6.30.4

The updated 2.6.30.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.30.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.30.y.git;a=summary

thanks,

greg k-h

------------

 Documentation/RCU/rculist_nulls.txt                        |    7 +
 Makefile                                                   |    2 
 arch/parisc/include/asm/system.h                           |    4 
 arch/parisc/include/asm/tlbflush.h                         |   14 +-
 arch/parisc/kernel/cache.c                                 |   23 +++-
 arch/parisc/kernel/pci-dma.c                               |   12 +-
 arch/powerpc/sysdev/mpic.c                                 |   29 +++--
 arch/x86/boot/video-vga.c                                  |   44 ++++++---
 arch/x86/include/asm/fixmap.h                              |   10 +-
 arch/x86/include/asm/io_apic.h                             |    2 
 arch/x86/include/asm/uaccess.h                             |    4 
 arch/x86/include/asm/uaccess_64.h                          |   10 +-
 arch/x86/kernel/apic/io_apic.c                             |   14 --
 arch/x86/kernel/mfgpt_32.c                                 |    2 
 arch/x86/kernel/setup.c                                    |   13 ++
 arch/x86/mm/gup.c                                          |    9 +
 arch/x86/mm/srat_64.c                                      |    6 -
 arch/x86/pci/i386.c                                        |    7 +
 drivers/ata/libata-eh.c                                    |    4 
 drivers/char/vc_screen.c                                   |    4 
 drivers/hid/usbhid/hiddev.c                                |    4 
 drivers/hwmon/max6650.c                                    |    1 
 drivers/input/misc/wistron_btns.c                          |    9 +
 drivers/isdn/gigaset/ev-layer.c                            |   44 ++++-----
 drivers/md/dm-raid1.c                                      |    1 
 drivers/mmc/host/mvsdio.c                                  |    4 
 drivers/net/8139too.c                                      |    1 
 drivers/net/arm/ixp4xx_eth.c                               |    4 
 drivers/net/ehea/ehea_main.c                               |    2 
 drivers/net/gianfar.c                                      |    2 
 drivers/net/plip.c                                         |    3 
 drivers/net/ps3_gelic_net.c                                |    1 
 drivers/net/ps3_gelic_wireless.c                           |    1 
 drivers/net/smc91x.c                                       |    1 
 drivers/net/smsc911x.c                                     |    1 
 drivers/net/sunvnet.c                                      |    2 
 drivers/net/usb/kaweth.c                                   |    3 
 drivers/net/usb/pegasus.c                                  |    3 
 drivers/net/via-rhine.c                                    |    1 
 drivers/net/wireless/orinoco/main.c                        |    3 
 drivers/scsi/sg.c                                          |    4 
 drivers/scsi/zalon.c                                       |    2 
 drivers/staging/rt2870/rt2870.h                            |    1 
 drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c |   12 +-
 drivers/usb/core/devio.c                                   |   57 ++++++-----
 drivers/usb/core/message.c                                 |   63 +++++++++----
 drivers/usb/gadget/ether.c                                 |   11 +-
 drivers/usb/host/ehci-sched.c                              |   12 +-
 drivers/usb/serial/ti_usb_3410_5052.c                      |    3 
 fs/binfmt_elf.c                                            |    4 
 fs/bio.c                                                   |   22 ++--
 fs/cifs/connect.c                                          |    1 
 fs/cifs/dir.c                                              |    9 +
 fs/ecryptfs/keystore.c                                     |   13 ++
 fs/nfsd/vfs.c                                              |    3 
 fs/nilfs2/cpfile.c                                         |    5 -
 fs/nilfs2/dat.c                                            |    9 -
 fs/nilfs2/segment.c                                        |   30 +-----
 fs/partitions/check.c                                      |    2 
 include/linux/blkdev.h                                     |    1 
 include/linux/sched.h                                      |    3 
 include/net/netfilter/nf_conntrack.h                       |    4 
 kernel/freezer.c                                           |    7 +
 kernel/sched.c                                             |    1 
 kernel/sched_rt.c                                          |   18 +++
 kernel/trace/trace_functions.c                             |    2 
 mm/filemap.c                                               |    1 
 mm/internal.h                                              |    4 
 mm/nommu.c                                                 |    3 
 mm/page_alloc.c                                            |   26 ++++-
 mm/slab.c                                                  |    2 
 mm/slob.c                                                  |    2 
 mm/slub.c                                                  |    2 
 mm/vmscan.c                                                |   11 +-
 net/dsa/mv88e6xxx.c                                        |    2 
 net/ipv4/netfilter/nf_nat_helper.c                         |   17 ++-
 net/netfilter/nf_conntrack_core.c                          |   36 ++++++-
 net/netfilter/nf_conntrack_proto_tcp.c                     |    6 -
 net/netfilter/nf_log.c                                     |   22 ++--
 net/netfilter/xt_quota.c                                   |    1 
 net/netfilter/xt_rateest.c                                 |    2 
 net/wireless/scan.c                                        |    1 
 sound/pci/ca0106/ca0106_main.c                             |    4 
 sound/pci/hda/patch_realtek.c                              |   33 +++---
 sound/pci/hda/patch_sigmatel.c                             |    7 +
 sound/pci/oxygen/virtuoso.c                                |    2 
 sound/soc/codecs/wm8753.c                                  |    2 
 sound/usb/usbaudio.c                                       |   14 ++
 88 files changed, 528 insertions(+), 282 deletions(-)

Alan Stern (2):
      USB: handle zero-length usbfs submissions correctly
      USB: EHCI: report actual_length for iso transfers

Alexey Fisher (1):
      x86: Add quirk for Intel DG45ID board to avoid low memory corruption

Amerigo Wang (1):
      elf: fix one check-after-use

Andi Kleen (1):
      x86-64: Fix bad_srat() to clear all state

Ben Hutchings (2):
      netdev: restore MAC address set and validate operations
      netdev: restore MTU change operation

Benjamin Herrenschmidt (1):
      powerpc/mpic: Fix mapping of "DCR" based MPIC variants

Clemens Ladisch (2):
      sound: virtuoso: fix Xonar D1/DX silence after resume
      sound: usb-audio: add workaround for Blue Microphones devices

Dan Aloni (1):
      Staging: prevent rtl8187se from crashing dev_ioctl() in SIOCGIWNAME

Daniel Mack (1):
      USB: fix LANGID=0 regression

David Brownell (1):
      USB: RNDIS gadget, fix issues talking from PXA

David Howells (1):
      NFSD: Don't hold unrefcounted creds over call to nfsd_setuser()

Eric Dumazet (1):
      nf_conntrack: nf_conntrack_alloc() fixes

FUJITA Tomonori (1):
      block: fix sg SG_DXFER_TO_FROM_DEV regression

Giuseppe Mazzotta (1):
      Input: wistron_btns - recognize Maxdata Pro 7000 notebooks

Greg Kroah-Hartman (2):
      USB: ti_usb_3410_5052: fix duplicate device ids.
      Linux 2.6.30.4

H. Peter Anvin (1):
      x86: Fix movq immediate operand constraints in uaccess.h

Hao Song (1):
      ALSA: hda - Add quirk for Gateway T6834c laptop

Heiko Carstens (1):
      partitions: fix broken uevent_suppress conversion

Helge Deller (2):
      parisc: ensure broadcast tlb purge runs single threaded
      parisc: fix ldcw inline assembler

James Bottomley (1):
      SCSI: zalon: fix oops on attach failure

Jan Beulich (1):
      x86: Fix fixmap ordering

Jan Engelhardt (1):
      netfilter: xt_quota: fix incomplete initialization

Jeff Layton (2):
      cifs: fix regression with O_EXCL creates and optimize away lookup
      cifs: free nativeFileSystem field before allocating a new one

Jiri Slaby (2):
      HID: hiddev, fix lock imbalance
      hwmon: (max6650) Fix lock imbalance

Jiro SEKIBA (1):
      nilfs2: fix disorder in cp count on error during deleting checkpoints

Johannes Berg (1):
      cfg80211: fix refcount leak

Jorrit Schippers (1):
      Staging: rt2870: Add USB ID for Sitecom WL-608

Josef Bacik (1):
      mm: mark page accessed before we write_end()

Kay Sievers (1):
      vc: create vcs(a) devices for consoles

Linus Torvalds (1):
      x86: don't use 'access_ok()' as a range check in get_user_pages_fast()

Marc Aurele La France (1):
      x86, setup (2.6.30-stable) fix 80x34 and 80x60 console modes

Mark Brown (1):
      ASoC: Fix register cache initialisation for WM8753

Mathieu Desnoyers (1):
      x86: Fix fixmap page order for FIX_TEXT_POKE0,1

Mel Gorman (1):
      vmscan: do not unconditionally treat zones that fail zone_reclaim() as full

Mikulas Patocka (1):
      dm raid1: wake kmirrord when requeueing delayed bios after remote recovery

Nicolas Pitre (1):
      mvsdio: fix handling of partial word at the end of PIO transfer

Oliver Neukum (2):
      USB: fix uninitialised variable in ti_do_download
      USB: fix memleak in usbfs

Patrick McHardy (6):
      netfilter: nf_log: fix sleeping function called from invalid context
      netfilter: nf_conntrack: fix confirmation race condition
      netfilter: nf_conntrack: fix conntrack lookup race
      netfilter: nf_log: fix direct userspace memory access in proc handler
      netfilter: xt_rateest: fix comparison with self
      netfilter: tcp conntrack: fix unacknowledged data detection with NAT

Paul E. McKenney (1):
      fix RCU-callback-after-kmem_cache_destroy problem in sl[aou]b

Paul Mundt (1):
      nommu: Provide mmap_min_addr definition.

Peter Zijlstra (1):
      sched_rt: Fix overload bug on rt group scheduling

Ramon de Carvalho Valle (1):
      eCryptfs: parse_tag_3_packet check tag 3 packet encrypted key size (CVE-2009-2407)

Ryusuke Konishi (3):
      nilfs2: remove unlikely directive causing mis-conversion of error code
      nilfs2: fix hang problem of log writer which occurs after write failures
      nilfs2: fix incorrect KERN_CRIT messages in case of write failures

Stephane Contri (1):
      dsa: fix 88e6xxx statistics counter snapshotting

Takashi Iwai (3):
      ALSA: ca0106 - Fix the max capture buffer size
      ALSA: hda - Fix pin-setup for Sony VAIO with STAC9872 codecs
      ALSA: hda - Fix mute control with some ALC262 models

Tejun Heo (1):
      libata: fix follow-up SRST failure path

Thomas Gleixner (2):
      sched: fix nr_uninterruptible accounting of frozen tasks really
      x86: geode: Mark mfgpt irq IRQF_TIMER to prevent resume failure

Tilman Schmidt (1):
      gigaset: accept connection establishment messages in any order

Tyler Hicks (1):
      eCryptfs: Check Tag 11 literal data buffer size (CVE-2009-2406)

Uros Bizjak (1):
      x86: Fix movq immediate operand constraints in uaccess_64.h

Xiao Guangrong (1):
      tracing/function: Fix the return value of ftrace_trace_onoff_callback()

Yinghai Lu (1):
      x86/pci: insert ioapic resource before assigning unassigned resources

