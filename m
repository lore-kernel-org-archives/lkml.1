Return-Path: <linux-kernel-owner+w=401wt.eu-S932692AbXKOGvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932692AbXKOGvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:51:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932323AbXKOGqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:46:31 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57792 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765771AbXKOGqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:46:30 -0500
Date: Wed, 14 Nov 2007 22:43:02 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [patch 00/40] 2.6.23-stable review, driver (sans network) changes
Message-ID: <20071115064302.GA19218@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.23.X release.
There are 40 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Friday 00:00:00 UTC.  Anything received
after that time might be too late.

This set of patches focuses on drivers except for networking (those were
in a different series).

The diffstat of this review series is included below.

thanks,

greg k-h

-----

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
 41 files changed, 418 insertions(+), 216 deletions(-)
