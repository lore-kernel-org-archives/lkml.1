Return-Path: <linux-kernel-owner+w=401wt.eu-S1753825AbYGXQqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbYGXQqa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 12:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751842AbYGXQqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 12:46:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49779 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbYGXQqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 12:46:19 -0400
Date: Thu, 24 Jul 2008 09:43:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.25.12
Message-ID: <20080724164358.GA6792@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.25.12
kernel.

It contains loads of bugfixes, all over the map.  Any users of the
2.6.25 kernel series should upgrade to this version.  For details on the
fixes, see the changelog entries and the diffstat below.

I'll also be replying to this message with a copy of the patch between
2.6.25.11 and 2.6.25.12

The updated 2.6.25.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.25.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.25.y.git;a=summary

thanks,

greg k-h

-------------

 Makefile                                    |    2 
 arch/powerpc/kernel/of_platform.c           |    2 
 block/as-iosched.c                          |    2 
 crypto/chainiv.c                            |   10 +++-
 drivers/base/node.c                         |    4 -
 drivers/block/cciss.c                       |   66 +++++++++++++++-------------
 drivers/char/pcmcia/ipwireless/hardware.c   |    4 +
 drivers/char/rtc.c                          |    3 -
 drivers/char/tpm/tpm_tis.c                  |    1 
 drivers/hwmon/hdaps.c                       |    8 +++
 drivers/isdn/i4l/isdn_common.c              |    4 +
 drivers/md/md.c                             |    6 +-
 drivers/md/raid10.c                         |    2 
 drivers/md/raid5.c                          |   14 ++---
 drivers/media/dvb/dvb-usb/dib0700_devices.c |    7 ++
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h     |    3 -
 drivers/media/video/ov7670.c                |    4 +
 drivers/message/fusion/mptspi.c             |    9 ++-
 drivers/mmc/host/pxamci.c                   |   13 +++++
 drivers/mmc/host/sdhci.c                    |    6 +-
 drivers/net/3c59x.c                         |    5 +-
 drivers/net/wireless/b43/leds.c             |    3 +
 drivers/net/wireless/b43/main.c             |    9 ++-
 drivers/net/wireless/b43legacy/dma.c        |    2 
 drivers/net/wireless/b43legacy/main.c       |    6 +-
 drivers/net/wireless/zd1211rw/zd_usb.c      |    1 
 drivers/rapidio/rio-driver.c                |    2 
 drivers/scsi/esp_scsi.c                     |   22 ++++++++-
 drivers/scsi/ses.c                          |    2 
 drivers/serial/8250.c                       |    3 +
 drivers/serial/serial_core.c                |    4 +
 drivers/usb/core/hcd.c                      |   38 +++++++++++-----
 drivers/usb/host/ehci.h                     |   19 ++++----
 drivers/usb/host/ohci-hcd.c                 |   15 +++++-
 drivers/usb/host/ohci-q.c                   |   12 +++++
 drivers/usb/misc/sisusbvga/sisusb.c         |    2 
 drivers/video/fb_defio.c                    |   20 ++++++++
 fs/buffer.c                                 |   13 +++--
 fs/cifs/cifsacl.c                           |   10 ++--
 fs/exec.c                                   |    2 
 fs/reiserfs/inode.c                         |    2 
 include/linux/fs.h                          |    1 
 kernel/hrtimer.c                            |    8 +++
 lib/ts_bm.c                                 |    2 
 mm/slub.c                                   |    4 +
 net/can/af_can.c                            |   10 ++++
 net/can/bcm.c                               |   23 ++++++++-
 net/can/raw.c                               |    3 +
 net/mac80211/tx.c                           |    9 +++
 net/netfilter/nf_conntrack_proto_tcp.c      |   13 ++---
 50 files changed, 323 insertions(+), 112 deletions(-)

Alexander Simon (1):
      V4L/DVB (7475): Added support for Terratec Cinergy T USB XXS

Andres Salomon (1):
      ov7670: clean up ov7670_read semantics

Ben Dooks (1):
      OHCI: Fix problem if SM501 and another platform driver is selected

Dan Williams (1):
      md: ensure all blocks are uptodate or locked when syncing

Darren Jenkins (2):
      drivers/isdn/i4l/isdn_common.c fix small resource leak
      drivers/char/pcmcia/ipwireless/hardware.c fix resource leak

David Brownell (2):
      USB: ehci - fix timer regression
      USB: ohci - record data toggle after unlink

David S. Miller (1):
      SCSI: esp: Fix OOPS in esp_reset_cleanup().

Divyesh Shah (1):
      block: Fix the starving writes bug in the anticipatory IO scheduler

Dmitry Adamushko (1):
      slub: Fix use-after-preempt of per-CPU data structure

Eric W. Biederman (1):
      serial8250: sanity check nr_uarts on all paths.

Eugene Surovegin (1):
      rapidio: fix device reference counting

Firat Birlik (1):
      zd1211rw: add ID for AirTies WUS-201

Greg Kroah-Hartman (1):
      Linux 2.6.25.12

Guennadi Liakhovetski (1):
      serial: fix serial_match_port() for dynamic major tty-device numbers

Herbert Xu (1):
      crypto: chainiv - Invoke completion function

Hugh Dickins (1):
      exec: fix stack excutability without PT_GNU_STACK

Ingo Molnar (1):
      netdrvr: 3c59x: remove irqs_disabled warning from local_bh_enable

James Bottomley (2):
      SCSI: esp: tidy up target reference counting
      SCSI: mptspi: fix oops in mptspi_dv_renegotiate_work()

Jaya Kumar (1):
      fbdev: bugfix for multiprocess defio

Jeff Layton (1):
      cifs: fix wksidarr declaration to be big-endian friendly

Jeff Mahoney (1):
      reiserfs: discard prealloc in reiserfs_delete_inode

Jens Axboe (1):
      block: Properly notify block layer of sync writes

Johannes Berg (1):
      mac80211: detect driver tx bugs

John Blackwood (1):
      mm: switch node meminfo Active & Inactive pages to Kbytes

Joonwoo Park (1):
      textsearch: fix Boyer-Moore text search bug

Jozsef Kadlecsik (1):
      netfilter: nf_conntrack_tcp: fixing to check the lower bound of valid ACK

Karl Beldan (1):
      pxamci: trivial fix of DMA alignment register bit clearing

Marcin Obara (1):
      tpm: add Intel TPM TIS device HID

Matthew Wilcox (1):
      SCSI: ses: Fix timeout

Michael Buesch (4):
      b43legacy: Do not return TX_BUSY from op_tx
      b43: Do not return TX_BUSY from op_tx
      b43: Fix possible MMIO access while device is down
      b43legacy: Fix possible NULL pointer dereference in DMA code

Mike Miller (1):
      cciss: read config to obtain max outstanding commands per controller

Neil Brown (3):
      md: Fix error paths if md_probe fails.
      md: Don't acknowlege that stripe-expand is complete until it really is.
      md: Ensure interrupted recovery completed properly (v1 metadata plus bitmap)

Oliver Hartkopp (1):
      can: add sanity checks

Paul Gortmaker (1):
      rtc: fix reported IRQ rate for when HPET is enabled

Philipp Zabel (1):
      pxamci: fix byte aligned DMA transfers

Pierre Ossman (1):
      mmc: don't use DMA on newer ENE controllers

Stefan Becker (1):
      USB: fix interrupt disabling for HCDs with shared interrupt handlers

Steven Rostedt (1):
      hrtimer: prevent migration for raising softirq

Vitaly Bordug (1):
      powerpc: Add missing reference to coherent_dma_mask

Will Newton (1):
      sisusbvga: Fix oops on disconnect.

maximilian attems (1):
      hdaps: add support for various newer Lenovo thinkpads

