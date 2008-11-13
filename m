Return-Path: <linux-kernel-owner+w=401wt.eu-S1752918AbYKMTC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918AbYKMTC3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 14:02:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbYKMTCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 14:02:21 -0500
Received: from kroah.org ([198.145.64.141]:51707 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751279AbYKMTCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 14:02:20 -0500
Date: Thu, 13 Nov 2008 10:53:50 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.27.6
Message-ID: <20081113185350.GA3765@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.27.6
kernel.

It contains a wide range of bugfixes, and all users of the 2.6.27 kernel
series are strongly encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.27.5 and 2.6.27.6

The updated 2.6.27.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary

thanks,

greg k-h

------------

 Documentation/cciss.txt                     |    2 
 Makefile                                    |    2 
 arch/arm/mach-pxa/include/mach/reset.h      |    9 +
 arch/arm/mach-pxa/reset.c                   |    9 +
 arch/arm/mach-pxa/spitz.c                   |    2 
 arch/arm/mach-pxa/tosa.c                    |    2 
 arch/arm/mm/cache-xsc3l2.c                  |    4 
 arch/x86/Kconfig                            |   20 ++++
 arch/x86/kernel/setup.c                     |   41 ++++++++
 arch/x86/kernel/tsc.c                       |    8 -
 drivers/acpi/dock.c                         |    5 -
 drivers/ata/libata-eh.c                     |   21 ++--
 drivers/block/cciss.c                       |   28 +++++
 drivers/block/cpqarray.c                    |    7 +
 drivers/dca/dca-core.c                      |    2 
 drivers/dma/ioat_dma.c                      |   11 +-
 drivers/dma/iovlock.c                       |   17 +--
 drivers/hid/hidraw.c                        |    2 
 drivers/md/linear.c                         |    2 
 drivers/md/raid10.c                         |    2 
 drivers/mmc/core/core.c                     |    6 +
 drivers/mtd/chips/cfi_cmdset_0002.c         |   13 --
 drivers/mtd/chips/jedec_probe.c             |   10 --
 drivers/net/r8169.c                         |  134 ++++++++++++++--------------
 drivers/net/wireless/iwlwifi/iwl-5000-hw.h  |    7 +
 drivers/net/wireless/iwlwifi/iwl-5000.c     |   63 +------------
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   57 ++++++++---
 drivers/net/wireless/iwlwifi/iwl-calib.c    |   60 ++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.c     |   27 +----
 drivers/net/wireless/iwlwifi/iwl-core.h     |    8 +
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   15 +--
 drivers/net/wireless/iwlwifi/iwl-power.c    |   39 +++++++-
 drivers/net/wireless/iwlwifi/iwl-power.h    |    4 
 drivers/net/wireless/iwlwifi/iwl-scan.c     |    8 -
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    7 +
 drivers/net/wireless/zd1211rw/zd_usb.c      |    2 
 fs/ext3/super.c                             |   11 +-
 fs/hfs/catalog.c                            |    4 
 fs/jffs2/background.c                       |   10 +-
 fs/jffs2/compr_lzo.c                        |   15 +--
 include/asm-generic/memory_model.h          |    2 
 include/linux/mtd/cfi.h                     |   22 +++-
 include/net/af_unix.h                       |    1 
 kernel/cgroup.c                             |    1 
 mm/hugetlb.c                                |   49 +++++++++-
 mm/internal.h                               |   29 ++++++
 mm/page_alloc.c                             |   28 ++++-
 net/unix/af_unix.c                          |   31 +++++-
 net/unix/garbage.c                          |   49 +++++++---
 security/keys/internal.h                    |    1 
 security/keys/process_keys.c                |    2 
 security/keys/request_key.c                 |    4 
 sound/pci/hda/patch_sigmatel.c              |   15 +--
 53 files changed, 630 insertions(+), 300 deletions(-)

Alok Kataria (1):
      x86: don't use tsc_khz to calculate lpj if notsc is passed

Andre Noll (1):
      md: linear: Fix a division by zero bug for very small arrays.

Andrey Borzenkov (1):
      cpqarry: fix return value of cpqarray_init()

Andy Whitcroft (2):
      hugetlb: pull gigantic page initialisation out of the default path
      hugetlbfs: handle pages higher order than MAX_ORDER

Arthur Jones (1):
      ext3: wait on all pending commits in ext3_sync_fs

Dan Williams (2):
      ARM: xsc3: fix xsc3_l2_inv_range
      dca: fixup initialization dependency

Daniel Drake (1):
      zd1211rw: Add 2 device IDs

David Howells (1):
      KEYS: Make request key instantiate the per-user keyrings

David Woodhouse (1):
      JFFS2: Fix lack of locking in thread_should_wake()

Dmitry Baryshkov (1):
      ARM: 5300/1: fixup spitz reset during boot

Emmanuel Grumbach (2):
      iwlwifi: allow association on radar channel in power save
      iwlwifi: remove HT flags from RXON when not in HT anymore

Eric Sesterhenn (1):
      hfs: fix namelength memory corruption (CVE-2008-5025)

Eric W. Biederman (1):
      MTD: [NOR] Fix cfi_send_gen_cmd handling of x16 devices in x8 mode (v4)

Francois Romieu (3):
      r8169: get ethtool settings through the generic mii helper
      r8169: fix RxMissed register access
      r8169: wake up the PHY of the 8168

Geert Uytterhoeven (1):
      JFFS2: fix race condition in jffs2_lzo_compress()

Greg Kroah-Hartman (1):
      Linux 2.6.27.6

Ingo Molnar (3):
      x86: add DMI quirk for AMI BIOS which corrupts address 0xc000 during resume
      x86: reserve low 64K on AMI and Phoenix BIOS boxen
      x86: add X86_RESERVE_LOW_64K

Jiri Kosina (1):
      HID: fix incorrent length condition in hidraw_write()

Li Zefan (1):
      cgroups: fix invalid cgrp->dentry before cgroup has been completely removed

Maciej Sosnowski (3):
      I/OAT: fix channel resources free for not allocated channels
      I/OAT: fix dma_pin_iovec_pages() error handling
      I/OAT: fix async_tx.callback checking

Matthew Ranostay (1):
      ALSA: hda: make a STAC_DELL_EQ option

Mike Miller (3):
      cciss: fix regression firmware not displayed in procfs
      cciss: fix sysfs broken symlink regression
      cciss: new hardware support

Miklos Szeredi (1):
      net: unix: fix inflight counting bug in garbage collector

Neil Brown (1):
      md: fix bug in raid10 recovery.

Pierre Ossman (1):
      mmc: increase SD write timeout for crappy cards

Rafael J. Wysocki (1):
      Fix __pfn_to_page(pfn) for CONFIG_DISCONTIGMEM=y

Reinette Chatre (1):
      iwl3945: do not send scan command if channel count zero

Ron Rindjunsky (1):
      iwlwifi: allow consecutive scans in unassociated state

Shaohua Li (1):
      ACPI: dock: avoid check _STA method

Tejun Heo (1):
      libata: fix last_reset timestamp handling

Tomas Winkler (4):
      iwlwifi: don't fail if scan is issued too early
      iwlwifi: use correct DMA_MASK
      iwlwifi: fix suspend to RAM in iwlwifi
      iwlwifi: generic init calibrations framework

Yinghai Lu (2):
      x86: fix CONFIG_X86_RESERVE_LOW_64K=y
      x86: fix macro with bad_bios_dmi_table

Zhu Yi (1):
      iwl3945: fix deadlock on suspend

