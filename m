Return-Path: <linux-kernel-owner+w=401wt.eu-S933939AbXKPSt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933939AbXKPSt5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 13:49:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbXKPStr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 13:49:47 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:38267 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918AbXKPStp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 13:49:45 -0500
Date: Fri, 16 Nov 2007 10:48:43 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.23.6
Message-ID: <20071116184843.GK9807@kroah.com>
References: <20071116183752.GA9807@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071116183752.GA9807@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.23.6 kernel.
It contains a number of bugfixes for drivers other than networking
(networking driver fixes were in 2.6.23.5).

I'll also be replying to this message with a copy of the patch between
2.6.23.5 and 2.6.23.6

The updated 2.6.23.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.23.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.23.y.git;a=summary

thanks,

greg k-h

--------

 Makefile                                |    2 
 drivers/acpi/sleep/main.c               |    5 -
 drivers/ata/ahci.c                      |  143 ++++++++++++++++++++++++++++++++
 drivers/ata/libata-core.c               |    9 +-
 drivers/ata/libata-eh.c                 |   32 +++++--
 drivers/char/drm/i915_irq.c             |    2 
 drivers/char/drm/radeon_cp.c            |    5 -
 drivers/char/drm/radeon_drv.h           |    1 
 drivers/char/moxa.c                     |    4 
 drivers/char/rocket.c                   |   14 ++-
 drivers/hwmon/lm87.c                    |    4 
 drivers/hwmon/w83627hf.c                |   78 +++++++++--------
 drivers/ide/pci/cs5535.c                |    2 
 drivers/ide/pci/serverworks.c           |    1 
 drivers/ide/pci/siimage.c               |    2 
 drivers/infiniband/core/uverbs_cmd.c    |    8 +
 drivers/infiniband/hw/mthca/mthca_cmd.c |    6 +
 drivers/isdn/hardware/avm/b1.c          |   28 ++----
 drivers/isdn/hardware/avm/c4.c          |   14 ++-
 drivers/md/bitmap.c                     |    2 
 drivers/md/dm-delay.c                   |    2 
 drivers/md/dm.c                         |    4 
 drivers/md/raid5.c                      |   17 +++
 drivers/pci/msi.c                       |    2 
 drivers/scsi/hptiop.c                   |    5 -
 drivers/usb/core/hcd.h                  |    8 +
 drivers/usb/core/hub.c                  |   15 +++
 drivers/usb/core/quirks.c               |   81 ------------------
 drivers/usb/core/urb.c                  |    2 
 drivers/usb/gadget/ether.c              |   12 ++
 drivers/usb/host/ehci-hcd.c             |    8 +
 drivers/usb/serial/generic.c            |    7 -
 drivers/video/platinumfb.c              |   48 +++++-----
 include/linux/ide.h                     |    7 +
 include/linux/libata.h                  |    2 
 include/linux/usb/quirks.h              |    7 -
 sound/core/Makefile                     |    3 
 sound/core/memalloc.c                   |    6 +
 sound/pci/emu10k1/emumixer.c            |    4 
 sound/pci/hda/patch_sigmatel.c          |   29 ++++--
 sound/pci/rme9652/hdsp.c                |    3 
 sound/usb/usbmixer.c                    |    2 
 42 files changed, 419 insertions(+), 217 deletions(-)

Summary of changes from v2.6.23.5 to v2.6.23.6
==============================================

Alan Stern (2):
      USB: remove USB_QUIRK_NO_AUTOSUSPEND
      USB: mutual exclusion for EHCI init and port resets

Alexey Starikovskiy (2):
      ACPI: sleep: Fix GPE suspend cleanup
      ACPI: suspend: Wrong order of GPE restore.

Benedikt Spranger (1):
      usb-gadget-ether: prevent oops caused by error interrupt race

Benjamin Herrenschmidt (4):
      POWERPC: Fix platinumfb framebuffer
      ide: Add ide_get_paired_drive() helper
      ide: Fix siimage driver accessing beyond array boundary
      ide: Fix cs5535 driver accessing beyond array boundary

Dan Williams (1):
      md: raid5: fix clearing of biofill operations

Dave Airlie (2):
      i915: fix vbl swap allocation size.
      radeon: set the address to access the GART table on the CPU side correctly

Greg Kroah-Hartman (1):
      Linux 2.6.23.6

HighPoint Linux Team (1):
      hptiop: avoid buffer overflow when returning sense data

Jean Delvare (4):
      hwmon/w83627hf: Fix setting fan min right after driver load
      hwmon/w83627hf: Don't assume bank 0
      hwmon/lm87: Fix a division by zero
      hwmon/lm87: Disable VID when it should be

Jiri Kosina (1):
      USB: usbserial - fix potential deadlock between write() and IRQ

Jiri Slaby (2):
      Char: rocket, fix dynamic_dev tty
      Char: moxa, fix and optimise empty timer

Jun'ichi Nomura (1):
      dm: fix thaw_bdev

Karsten Keil (2):
      i4l: Fix random hard freeze with AVM c4 card
      i4l: fix random freezes with AVM B1 drivers

Milan Broz (1):
      dm delay: fix status

NeilBrown (1):
      md: fix an unsigned compare to allow creation of bitmaps with v1.0 metadata

Oliver Neukum (1):
      USB: add URB_FREE_BUFFER to permissible flags

Roland Dreier (3):
      IB/uverbs: Fix checking of userspace object ownership
      IB/mthca: Use mmiowb() to avoid firmware commands getting jumbled up
      MSI: Use correct data offset for 32-bit MSI in read_msi_msg()

Russ Cox (1):
      ALSA: fix selector unit bug affecting some USB speakerphones

Takashi Iwai (5):
      ALSA: hda-codec - Avoid zero NID in line_out_pins[] of STAC codecs
      ALSA: Fix build error without CONFIG_HAS_DMA
      ALSA: emu10k1 - Fix memory corruption
      ALSA: hdsp - Fix zero division
      ALSA: hda-codec - Add array terminator for dmic in STAC codec

Tejun Heo (4):
      libata: sync NCQ blacklist with upstream
      libata: add HTS542525K9SA00 to NCQ blacklist
      libata: backport ATA_FLAG_NO_SRST and ATA_FLAG_ASSUME_ATA
      libata: backport ATA_FLAG_NO_SRST and ATA_FLAG_ASSUME_ATA, part 2

Tony Battersby (1):
      ide: fix serverworks.c UDMA regression

