Return-Path: <linux-kernel-owner+w=401wt.eu-S1760553AbZAaC6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760553AbZAaC6o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 21:58:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756371AbZAaCrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 21:47:12 -0500
Received: from kroah.org ([198.145.64.141]:55113 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755994AbZAaCrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 21:47:06 -0500
Date: Fri, 30 Jan 2009 18:41:58 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: [patch 00/43] 2.6.28-stable review
Message-ID: <20090131024158.GA12368@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is the start of the stable review cycle for the 2.6.28.3 release.
There are 43 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Note, there still are some more .28 patches pending for the -stable
releases, but I wanted to get this release out now to fix the major
problems that have recently been found.

If you have sent patches to be included in .28, and you don't see them
here, please feel free to just drop stable@kernel.org a message with the
git commit ids to make sure they end up in the next release.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Monday, February 2, 00:00:00 UTC.  Anything
received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.28.3-rc1.gz
and the diffstat can be found below.


thanks,

greg k-h

 Makefile                               |    2 +-
 arch/alpha/kernel/irq_srm.c            |    2 +
 arch/x86/include/asm/pgalloc.h         |    1 +
 arch/x86/mm/pageattr.c                 |   49 ++++++++----
 arch/x86/mm/pat.c                      |   43 +++++++---
 crypto/async_tx/async_tx.c             |    2 +
 crypto/authenc.c                       |   24 ++++--
 crypto/ccm.c                           |    2 +
 drivers/ata/pata_via.c                 |   22 ++++-
 drivers/gpio/gpiolib.c                 |    1 +
 drivers/gpu/drm/drm_agpsupport.c       |    3 +-
 drivers/ide/it821x.c                   |   12 +++
 drivers/misc/sgi-xp/xpc_sn2.c          |   19 +++--
 drivers/misc/sgi-xp/xpc_uv.c           |    2 +-
 drivers/net/bnx2x_main.c               |    3 +
 drivers/net/wireless/ath5k/base.c      |   10 ++-
 drivers/net/wireless/rtl8187_dev.c     |    1 +
 drivers/net/wireless/rtl8187_rtl8225.c |   10 ++-
 drivers/pci/hotplug/pciehp_core.c      |    4 +-
 drivers/serial/8250_pci.c              |    3 +
 drivers/usb/core/devio.c               |   20 +++--
 drivers/usb/core/driver.c              |    2 +-
 drivers/usb/core/hub.c                 |    4 +-
 drivers/usb/core/inode.c               |    1 -
 drivers/usb/core/message.c             |   40 ++++++----
 drivers/usb/core/usb.h                 |    6 +-
 drivers/usb/mon/mon_bin.c              |  105 ++++++++++++++++---------
 drivers/usb/storage/unusual_devs.h     |    6 ++
 fs/eventpoll.c                         |   22 +----
 fs/ext3/namei.c                        |   20 ++++--
 fs/fuse/dev.c                          |    3 +-
 fs/fuse/file.c                         |    2 +-
 fs/fuse/inode.c                        |   10 ++-
 fs/inotify_user.c                      |  135 +++++++++++++++++--------------
 fs/sysfs/bin.c                         |    6 ++
 include/linux/Kbuild                   |    1 +
 include/linux/klist.h                  |    2 +-
 include/linux/pci_ids.h                |    6 ++
 include/linux/sched.h                  |    1 -
 kernel/relay.c                         |    4 +-
 kernel/resource.c                      |    9 ++
 mm/mmap.c                              |    9 ++-
 mm/vmalloc.c                           |   11 +++
 net/core/net_namespace.c               |    2 +-
 net/mac80211/tx.c                      |    6 +-
 sound/pci/hda/patch_conexant.c         |    1 +
 sound/pci/hda/patch_realtek.c          |    1 +
 sound/pci/hda/patch_sigmatel.c         |    2 +
 sound/pci/oxygen/virtuoso.c            |    1 +
 49 files changed, 427 insertions(+), 226 deletions(-)
