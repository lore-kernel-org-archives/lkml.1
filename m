Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672AbZBFXpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbZBFXpj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 18:45:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753187AbZBFXp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 18:45:28 -0500
Received: from kroah.org ([198.145.64.141]:53276 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752912AbZBFXp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 18:45:26 -0500
Date: Fri, 6 Feb 2009 15:43:56 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.28.4
Message-ID: <20090206234356.GA30958@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.28.4
kernel.

It contains a wide range of bugfixes, and all users of the 2.6.28 kernel
series are strongly encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.28.2 and 2.6.28.4

The updated 2.6.28.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.28.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.28.y.git;a=summary

thanks,

greg k-h

------------


 Makefile                                   |    2 
 arch/m68knommu/Kconfig                     |    4 
 arch/x86/kernel/acpi/cstate.c              |    4 
 arch/x86/lib/usercopy_32.c                 |    4 
 arch/x86/lib/usercopy_64.c                 |    4 
 arch/x86/pci/irq.c                         |    1 
 drivers/acpi/battery.c                     |    5 
 drivers/acpi/namespace/nsutils.c           |    8 +
 drivers/acpi/pci_link.c                    |    4 
 drivers/acpi/video.c                       |    5 
 drivers/ata/sata_mv.c                      |    6 -
 drivers/ata/sata_nv.c                      |   77 +++++++++-----
 drivers/char/selection.c                   |    2 
 drivers/cpuidle/governors/menu.c           |   10 +
 drivers/input/keyboard/atkbd.c             |   25 ++++
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c |   12 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c  |   12 +-
 drivers/net/wireless/orinoco.c             |   30 ++---
 drivers/net/wireless/p54/p54common.c       |   12 +-
 drivers/net/wireless/p54/p54usb.c          |  149 +++++++++++++++++------------
 drivers/net/wireless/p54/p54usb.h          |    1 
 drivers/pci/msi.c                          |   16 +--
 drivers/serial/jsm/jsm_tty.c               |    6 +
 drivers/video/aty/mach64_ct.c              |   11 ++
 drivers/xen/balloon.c                      |   33 ++++++
 fs/cifs/connect.c                          |   18 +--
 fs/dlm/plock.c                             |    2 
 fs/nfsd/nfs4state.c                        |   31 +++---
 include/linux/pci_ids.h                    |    1 
 include/linux/slab_def.h                   |   10 -
 mm/mlock.c                                 |   47 ---------
 net/mac80211/rc80211_minstrel.c            |   10 +
 net/netfilter/nf_conntrack_netlink.c       |    3 
 33 files changed, 347 insertions(+), 218 deletions(-)


Abbas, Mohamed (1):
      iwlwifi: fix rs_get_rate WARN_ON()

Adrian Bunk (1):
      m68knommu: set NO_DMA

Alexey Starikovskiy (1):
      Newly inserted battery might differ from one just removed, so update of battery info fields is required.

Andi Kleen (1):
      x86: use early clobbers in usercopy*.c

Andrey Borzenkov (1):
      orinoco: move kmalloc(..., GFP_KERNEL) outside spinlock in orinoco_ioctl_set_genie

Christian Lamparter (3):
      p54: fix p54_read_eeprom to cope with tx_hdr_len
      p54usb: rewriting rx/tx routines to make use of usb_anchor's facilities
      minstrel: fix warning if lowest supported rate index is not 0

Greg Kroah-Hartman (1):
      Linux 2.6.28.4

Hidetoshi Seto (1):
      PCI/MSI: bugfix/utilize for msi_capability_init()

J. Bruce Fields (1):
      nfsd: Ensure nfsv4 calls the underlying filesystem on LOCKT

Jeff Layton (3):
      cifs: make sure we allocate enough storage for socket address
      nfsd: only set file_lock.fl_lmops in nfsd4_lockt if a stateowner is found
      dlm: initialize file_lock struct in GETLK before copying conflicting lock

Jeff Mahoney (1):
      kmalloc: return NULL instead of link failure

Jeremy Fitzhardinge (1):
      xen: make sysfs files behave as their names suggest

Johannes Berg (1):
      p54: fix lm87 checksum endianness

Lin Ming (1):
      ACPICA: Allow multiple backslash prefix in namepaths

Linus Torvalds (1):
      Manually revert "mlock: downgrade mmap sem while populating mlocked regions"

Mark Lord (2):
      sata_mv: fix 8-port timeouts on 508x/6081 chips
      sata_mv: Fix chip type for Hightpoint RocketRaid 1740/1742

Mikulas Patocka (1):
      Fix memory corruption in console selection

Patrick McHardy (1):
      netfilter: ctnetlink: fix scheduling while atomic

Paul Larson (1):
      Add enable_ms to jsm driver

Rafael J. Wysocki (1):
      ACPI: Do not modify SCI_EN directly

Risto Suominen (1):
      fbdev/atyfb: Fix DSP config on some PowerMacs & PowerBooks

Seth Heasley (1):
      PCI: irq and pci_ids patch for Intel Tigerpoint DeviceIDs

Stuart Hopkins (1):
      Input: atkbd - Samsung NC10 key repeat fix

Tejun Heo (3):
      sata_nv: rename nv_nf2_hardreset()
      sata_nv: fix MCP5x reset
      sata_nv: ck804 has borked hardreset too

Venkatesh Pallipadi (1):
      cpuidle: Add decaying history logic to menu idle predictor

Zhang Rui (1):
      video: always update the brightness when poking "brightness"

Zhao Yakui (1):
      ACPI: Avoid array address overflow when _CST MWAIT hint bits are set

