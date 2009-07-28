Return-Path: <linux-kernel-owner+w=401wt.eu-S1753253AbZG1Xt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbZG1Xt2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753185AbZG1Xt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:49:28 -0400
Received: from kroah.org ([198.145.64.141]:35605 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752930AbZG1Xt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:49:27 -0400
Date: Tue, 28 Jul 2009 16:47:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [patch 00/71] [00/@num@] 2.6.30.4-stable review
Message-ID: <20090728234756.GA11917@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is the start of the stable review cycle for the 2.6.30.4 release.
There are 71 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Thursday, July 30, 22:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.30.4-rc1.gz
and the diffstat can be found below.


thanks,

greg k-h

--------------

 Documentation/RCU/rculist_nulls.txt                |    7 ++-
 Makefile                                           |    2 +-
 arch/parisc/include/asm/system.h                   |    4 +-
 arch/parisc/include/asm/tlbflush.h                 |   14 ++--
 arch/parisc/kernel/cache.c                         |   23 +++--
 arch/parisc/kernel/pci-dma.c                       |   12 ++-
 arch/powerpc/sysdev/mpic.c                         |   29 ++++---
 arch/x86/boot/video-vga.c                          |   44 +++++++---
 arch/x86/include/asm/fixmap.h                      |   10 +-
 arch/x86/include/asm/io_apic.h                     |    2 +
 arch/x86/include/asm/uaccess.h                     |    4 +-
 arch/x86/include/asm/uaccess_64.h                  |   10 +-
 arch/x86/kernel/apic/io_apic.c                     |   14 +---
 arch/x86/kernel/mfgpt_32.c                         |    2 +-
 arch/x86/kernel/setup.c                            |   13 +++
 arch/x86/mm/gup.c                                  |    9 ++-
 arch/x86/mm/srat_64.c                              |    6 +-
 arch/x86/pci/i386.c                                |    7 ++
 drivers/ata/libata-eh.c                            |    4 +
 drivers/char/vc_screen.c                           |    4 +
 drivers/hid/usbhid/hiddev.c                        |    4 +-
 drivers/hwmon/max6650.c                            |    1 +
 drivers/input/misc/wistron_btns.c                  |    9 ++
 drivers/isdn/gigaset/ev-layer.c                    |   44 +++++-----
 drivers/md/dm-raid1.c                              |    1 +
 drivers/mmc/host/mvsdio.c                          |    4 +-
 drivers/net/8139too.c                              |    1 +
 drivers/net/arm/ixp4xx_eth.c                       |    4 +-
 drivers/net/ehea/ehea_main.c                       |    2 +
 drivers/net/gianfar.c                              |    2 +
 drivers/net/plip.c                                 |    3 +
 drivers/net/ps3_gelic_net.c                        |    1 +
 drivers/net/ps3_gelic_wireless.c                   |    1 +
 drivers/net/smc91x.c                               |    1 +
 drivers/net/smsc911x.c                             |    1 +
 drivers/net/sunvnet.c                              |    2 +
 drivers/net/usb/kaweth.c                           |    3 +
 drivers/net/usb/pegasus.c                          |    3 +
 drivers/net/via-rhine.c                            |    1 +
 drivers/net/wireless/orinoco/main.c                |    3 +-
 drivers/scsi/sg.c                                  |    4 +
 drivers/scsi/zalon.c                               |    2 +-
 drivers/staging/rt2870/rt2870.h                    |    1 +
 .../rtl8187se/ieee80211/ieee80211_softmac_wx.c     |   12 ++--
 drivers/usb/core/devio.c                           |   57 +++++++------
 drivers/usb/core/hcd.h                             |    4 +
 drivers/usb/core/hub.c                             |   40 ++++++---
 drivers/usb/core/hub.h                             |    6 +-
 drivers/usb/core/message.c                         |   63 ++++++++++----
 drivers/usb/gadget/ether.c                         |   11 ++-
 drivers/usb/host/ehci-au1xxx.c                     |    2 +
 drivers/usb/host/ehci-fsl.c                        |    2 +
 drivers/usb/host/ehci-hcd.c                        |    2 +
 drivers/usb/host/ehci-ixp4xx.c                     |    2 +
 drivers/usb/host/ehci-orion.c                      |    2 +
 drivers/usb/host/ehci-pci.c                        |    2 +
 drivers/usb/host/ehci-ppc-of.c                     |    2 +
 drivers/usb/host/ehci-ps3.c                        |    2 +
 drivers/usb/host/ehci-q.c                          |   91 +++++++++++++++-----
 drivers/usb/host/ehci-sched.c                      |   12 ++-
 drivers/usb/host/ehci.h                            |    2 +
 drivers/usb/serial/ti_usb_3410_5052.c              |    3 +-
 fs/binfmt_elf.c                                    |    4 +-
 fs/bio.c                                           |   22 +++--
 fs/cifs/connect.c                                  |    1 +
 fs/cifs/dir.c                                      |    9 ++
 fs/ecryptfs/keystore.c                             |   13 +++
 fs/nfsd/vfs.c                                      |    3 +-
 fs/nilfs2/cpfile.c                                 |    5 +-
 fs/nilfs2/dat.c                                    |    9 --
 fs/nilfs2/segment.c                                |   30 ++-----
 fs/partitions/check.c                              |    2 +-
 include/linux/blkdev.h                             |    1 +
 include/linux/sched.h                              |    3 +-
 include/net/netfilter/nf_conntrack.h               |    4 +-
 kernel/freezer.c                                   |    7 ++
 kernel/sched.c                                     |    1 +
 kernel/sched_rt.c                                  |   18 ++++-
 kernel/trace/trace_functions.c                     |    2 +-
 mm/filemap.c                                       |    1 +
 mm/internal.h                                      |    4 +
 mm/nommu.c                                         |    3 +
 mm/page_alloc.c                                    |   26 +++++-
 mm/slab.c                                          |    2 +-
 mm/slob.c                                          |    2 +
 mm/slub.c                                          |    2 +
 mm/vmscan.c                                        |   11 ++-
 net/dsa/mv88e6xxx.c                                |    2 +-
 net/ipv4/netfilter/nf_nat_helper.c                 |   17 +++--
 net/netfilter/nf_conntrack_core.c                  |   36 +++++++--
 net/netfilter/nf_conntrack_proto_tcp.c             |    6 +-
 net/netfilter/nf_log.c                             |   22 +++--
 net/netfilter/xt_quota.c                           |    1 +
 net/netfilter/xt_rateest.c                         |    2 +-
 net/wireless/scan.c                                |    1 -
 sound/pci/ca0106/ca0106_main.c                     |    4 +-
 sound/pci/hda/patch_realtek.c                      |   33 ++++----
 sound/pci/hda/patch_sigmatel.c                     |    7 +-
 sound/pci/oxygen/virtuoso.c                        |    2 +
 sound/soc/codecs/wm8753.c                          |    2 +-
 sound/usb/usbaudio.c                               |   14 +++-
 101 files changed, 648 insertions(+), 321 deletions(-)
