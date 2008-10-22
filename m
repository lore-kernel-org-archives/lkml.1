Return-Path: <linux-kernel-owner+w=401wt.eu-S1755480AbYJVOUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480AbYJVOUx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 10:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752383AbYJVOUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 10:20:44 -0400
Received: from cluster-d.mailcontrol.com ([217.69.20.190]:60658 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbYJVOUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 10:20:42 -0400
Message-ID: <48FF3690.20905@csr.com>
Date: Wed, 22 Oct 2008 15:20:00 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Kernel development list <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] UWB, WUSB, and WLP subsystems for 2.6.28
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Oct 2008 14:20:00.0269 (UTC) FILETIME=[447B33D0:01C93451]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the new UWB, WUSB and WLP subsystems from:

git://git.kernel.org/pub/scm/linux/kernel/git/dvrabel/uwb.git for-upstream

This code was reviewed on the linux-usb mailing list and I am aware of
no outstanding issues that would make this code unsuitable for merging.

David

The following changes since commit 0cfd81031a26717fe14380d18275f8e217571615:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../gregkh/usb-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dvrabel/uwb.git for-upstream

Anderson Lizardo (7):
      wusb: fix error path for wusb_set_dev_addr()
      wusb: fix bmRequestType for Abort RPipe request
      uwb: Fix handling IEs with empty IE data in uwb_est_get_size()
      uwb: disable command/event filtering for D-Link DUB-1210
      uwb: add Intel i1480 HWA to the UWB RC quirk table
      uwb: i1480: remove MAC/PHY information checking function
      uwb: i1480/GUWA100U: fix firmware download issues

David Vrabel (17):
      bitmap: add bitmap_copy_le()
      uwb: add the UWB stack (reservation manager)
      uwb: add the UWB stack (debug support)
      uwb: add the umc bus
      uwb: add the driver to enumerate WHCI capabilities
      wusb: WHCI host controller driver
      uwb: initialize the debug sub-system
      uwb: dont tranmit identification IEs
      uwb: add symlinks in sysfs between radio controllers and PALs
      uwb: document UWB and WUSB sysfs files
      uwb: depend on EXPERIMENTAL
      uwb: add entries in the MAINTAINERS file
      Merge branch 'for-upstream' of
git://git.kernel.org/.../dvrabel/uwb into for-upstream
      uwb: use time_after() when purging stale beacons
      uwb: use kcalloc where appropriate
      uwb: don't use printk_ratelimit() so often
      Merge branch 'master' into for-upstream

Felipe Zimmerle (1):
      wusb: wusb-cbaf (CBA driver) sysfs ABI simplification

Frank Leipold (1):
      uwb: wrong sizeof argument in mac address compare

Greg Kroah-Hartman (3):
      uwb: add the UWB stack (build system)
      uwb: add WiMedia LLC Protocol (build system)
      wusb: add the Wireless USB core (build-system)

Inaky Perez-Gonzalez (17):
      uwb: add initial documentation
      uwb: add the uwb include files
      uwb: add the UWB stack (core files)
      uwb: add the UWB stack (radio controller interface)
      uwb: add the UWB stack (MLME)
      uwb: add whc-rc radio control driver
      uwb: add HWA radio controller driver
      uwb: add the i1480 DFU driver
      uwb: add the i1480 WLP driver
      wusb: add the Wireless USB include files.
      wusb: add the Wireless USB core
      wusb: add the Wireless USB core (protocol)
      wusb: add the Wireless USB core (security)
      wusb: add the USB wusb-cbaf driver
      wusb: add the Wire Adapter (WA) core
      wusb: add HWA host controller driver
      uwb: add credits for the original developers of the UWB/WUSB/WLP
subsystems

Reinette Chatre (3):
      uwb: add the WiMedia LLC Protocol stack
      uwb: add WiMedia LLC Protocol stack (messages)
      uwb: add WiMedia LLC Protocol stack (WSS)

 CREDITS                                        |   11 +
 Documentation/ABI/testing/sysfs-bus-umc        |   28 +
 Documentation/ABI/testing/sysfs-bus-usb        |   43 +
 Documentation/ABI/testing/sysfs-class-usb_host |   25 +
 Documentation/ABI/testing/sysfs-class-uwb_rc   |  144 ++
 Documentation/ABI/testing/sysfs-wusb_cbaf      |  100 ++
 Documentation/usb/WUSB-Design-overview.txt     |  448 ++++++
 Documentation/usb/wusb-cbaf                    |  139 ++
 MAINTAINERS                                    |   17 +
 arch/arm/Kconfig                               |    2 +
 arch/cris/Kconfig                              |    2 +
 arch/h8300/Kconfig                             |    2 +
 drivers/Kconfig                                |    2 +
 drivers/Makefile                               |    1 +
 drivers/usb/Kconfig                            |    2 +
 drivers/usb/Makefile                           |    3 +
 drivers/usb/host/Kconfig                       |   28 +
 drivers/usb/host/Makefile                      |    3 +
 drivers/usb/host/hwa-hc.c                      |  925 +++++++++++
 drivers/usb/host/whci/Kbuild                   |   11 +
 drivers/usb/host/whci/asl.c                    |  367 +++++
 drivers/usb/host/whci/hcd.c                    |  339 ++++
 drivers/usb/host/whci/hw.c                     |   87 ++
 drivers/usb/host/whci/init.c                   |  188 +++
 drivers/usb/host/whci/int.c                    |   95 ++
 drivers/usb/host/whci/pzl.c                    |  398 +++++
 drivers/usb/host/whci/qset.c                   |  567 +++++++
 drivers/usb/host/whci/whcd.h                   |  197 +++
 drivers/usb/host/whci/whci-hc.h                |  416 +++++
 drivers/usb/host/whci/wusb.c                   |  241 +++
 drivers/usb/wusbcore/Kconfig                   |   41 +
 drivers/usb/wusbcore/Makefile                  |   26 +
 drivers/usb/wusbcore/cbaf.c                    |  673 ++++++++
 drivers/usb/wusbcore/crypto.c                  |  538 +++++++
 drivers/usb/wusbcore/dev-sysfs.c               |  143 ++
 drivers/usb/wusbcore/devconnect.c              | 1297 ++++++++++++++++
 drivers/usb/wusbcore/mmc.c                     |  321 ++++
 drivers/usb/wusbcore/pal.c                     |   42 +
 drivers/usb/wusbcore/reservation.c             |  115 ++
 drivers/usb/wusbcore/rh.c                      |  477 ++++++
 drivers/usb/wusbcore/security.c                |  642 ++++++++
 drivers/usb/wusbcore/wa-hc.c                   |   95 ++
 drivers/usb/wusbcore/wa-hc.h                   |  417 +++++
 drivers/usb/wusbcore/wa-nep.c                  |  310 ++++
 drivers/usb/wusbcore/wa-rpipe.c                |  562 +++++++
 drivers/usb/wusbcore/wa-xfer.c                 | 1709 +++++++++++++++++++++
 drivers/usb/wusbcore/wusbhc.c                  |  418 +++++
 drivers/usb/wusbcore/wusbhc.h                  |  495 ++++++
 drivers/uwb/Kconfig                            |   90 ++
 drivers/uwb/Makefile                           |   29 +
 drivers/uwb/address.c                          |  374 +++++
 drivers/uwb/beacon.c                           |  642 ++++++++
 drivers/uwb/driver.c                           |  144 ++
 drivers/uwb/drp-avail.c                        |  288 ++++
 drivers/uwb/drp-ie.c                           |  232 +++
 drivers/uwb/drp.c                              |  461 ++++++
 drivers/uwb/est.c                              |  477 ++++++
 drivers/uwb/hwa-rc.c                           |  926 +++++++++++
 drivers/uwb/i1480/Makefile                     |    2 +
 drivers/uwb/i1480/dfu/Makefile                 |    9 +
 drivers/uwb/i1480/dfu/dfu.c                    |  217 +++
 drivers/uwb/i1480/dfu/i1480-dfu.h              |  260 ++++
 drivers/uwb/i1480/dfu/mac.c                    |  527 +++++++
 drivers/uwb/i1480/dfu/phy.c                    |  203 +++
 drivers/uwb/i1480/dfu/usb.c                    |  500 ++++++
 drivers/uwb/i1480/i1480-est.c                  |   99 ++
 drivers/uwb/i1480/i1480-wlp.h                  |  200 +++
 drivers/uwb/i1480/i1480u-wlp/Makefile          |    8 +
 drivers/uwb/i1480/i1480u-wlp/i1480u-wlp.h      |  284 ++++
 drivers/uwb/i1480/i1480u-wlp/lc.c              |  421 +++++
 drivers/uwb/i1480/i1480u-wlp/netdev.c          |  368 +++++
 drivers/uwb/i1480/i1480u-wlp/rx.c              |  486 ++++++
 drivers/uwb/i1480/i1480u-wlp/sysfs.c           |  408 +++++
 drivers/uwb/i1480/i1480u-wlp/tx.c              |  632 ++++++++
 drivers/uwb/ie.c                               |  541 +++++++
 drivers/uwb/lc-dev.c                           |  492 ++++++
 drivers/uwb/lc-rc.c                            |  495 ++++++
 drivers/uwb/neh.c                              |  616 ++++++++
 drivers/uwb/pal.c                              |   91 ++
 drivers/uwb/reset.c                            |  362 +++++
 drivers/uwb/rsv.c                              |  680 +++++++++
 drivers/uwb/scan.c                             |  133 ++
 drivers/uwb/umc-bus.c                          |  218 +++
 drivers/uwb/umc-dev.c                          |  104 ++
 drivers/uwb/umc-drv.c                          |   31 +
 drivers/uwb/uwb-debug.c                        |  367 +++++
 drivers/uwb/uwb-internal.h                     |  305 ++++
 drivers/uwb/uwbd.c                             |  410 +++++
 drivers/uwb/whc-rc.c                           |  520 +++++++
 drivers/uwb/whci.c                             |  269 ++++
 drivers/uwb/wlp/Makefile                       |   10 +
 drivers/uwb/wlp/driver.c                       |   43 +
 drivers/uwb/wlp/eda.c                          |  449 ++++++
 drivers/uwb/wlp/messages.c                     | 1946
++++++++++++++++++++++++
 drivers/uwb/wlp/sysfs.c                        |  709 +++++++++
 drivers/uwb/wlp/txrx.c                         |  374 +++++
 drivers/uwb/wlp/wlp-internal.h                 |  228 +++
 drivers/uwb/wlp/wlp-lc.c                       |  585 +++++++
 drivers/uwb/wlp/wss-lc.c                       | 1055 +++++++++++++
 include/linux/bitmap.h                         |    1 +
 include/linux/usb/wusb-wa.h                    |  271 ++++
 include/linux/usb/wusb.h                       |  376 +++++
 include/linux/uwb.h                            |  765 ++++++++++
 include/linux/uwb/debug-cmd.h                  |   57 +
 include/linux/uwb/debug.h                      |   82 +
 include/linux/uwb/spec.h                       |  727 +++++++++
 include/linux/uwb/umc.h                        |  194 +++
 include/linux/uwb/whci.h                       |  117 ++
 include/linux/wlp.h                            |  735 +++++++++
 lib/bitmap.c                                   |   22 +
 110 files changed, 35819 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-umc
 create mode 100644 Documentation/ABI/testing/sysfs-class-usb_host
 create mode 100644 Documentation/ABI/testing/sysfs-class-uwb_rc
 create mode 100644 Documentation/ABI/testing/sysfs-wusb_cbaf
 create mode 100644 Documentation/usb/WUSB-Design-overview.txt
 create mode 100644 Documentation/usb/wusb-cbaf
 create mode 100644 drivers/usb/host/hwa-hc.c
 create mode 100644 drivers/usb/host/whci/Kbuild
 create mode 100644 drivers/usb/host/whci/asl.c
 create mode 100644 drivers/usb/host/whci/hcd.c
 create mode 100644 drivers/usb/host/whci/hw.c
 create mode 100644 drivers/usb/host/whci/init.c
 create mode 100644 drivers/usb/host/whci/int.c
 create mode 100644 drivers/usb/host/whci/pzl.c
 create mode 100644 drivers/usb/host/whci/qset.c
 create mode 100644 drivers/usb/host/whci/whcd.h
 create mode 100644 drivers/usb/host/whci/whci-hc.h
 create mode 100644 drivers/usb/host/whci/wusb.c
 create mode 100644 drivers/usb/wusbcore/Kconfig
 create mode 100644 drivers/usb/wusbcore/Makefile
 create mode 100644 drivers/usb/wusbcore/cbaf.c
 create mode 100644 drivers/usb/wusbcore/crypto.c
 create mode 100644 drivers/usb/wusbcore/dev-sysfs.c
 create mode 100644 drivers/usb/wusbcore/devconnect.c
 create mode 100644 drivers/usb/wusbcore/mmc.c
 create mode 100644 drivers/usb/wusbcore/pal.c
 create mode 100644 drivers/usb/wusbcore/reservation.c
 create mode 100644 drivers/usb/wusbcore/rh.c
 create mode 100644 drivers/usb/wusbcore/security.c
 create mode 100644 drivers/usb/wusbcore/wa-hc.c
 create mode 100644 drivers/usb/wusbcore/wa-hc.h
 create mode 100644 drivers/usb/wusbcore/wa-nep.c
 create mode 100644 drivers/usb/wusbcore/wa-rpipe.c
 create mode 100644 drivers/usb/wusbcore/wa-xfer.c
 create mode 100644 drivers/usb/wusbcore/wusbhc.c
 create mode 100644 drivers/usb/wusbcore/wusbhc.h
 create mode 100644 drivers/uwb/Kconfig
 create mode 100644 drivers/uwb/Makefile
 create mode 100644 drivers/uwb/address.c
 create mode 100644 drivers/uwb/beacon.c
 create mode 100644 drivers/uwb/driver.c
 create mode 100644 drivers/uwb/drp-avail.c
 create mode 100644 drivers/uwb/drp-ie.c
 create mode 100644 drivers/uwb/drp.c
 create mode 100644 drivers/uwb/est.c
 create mode 100644 drivers/uwb/hwa-rc.c
 create mode 100644 drivers/uwb/i1480/Makefile
 create mode 100644 drivers/uwb/i1480/dfu/Makefile
 create mode 100644 drivers/uwb/i1480/dfu/dfu.c
 create mode 100644 drivers/uwb/i1480/dfu/i1480-dfu.h
 create mode 100644 drivers/uwb/i1480/dfu/mac.c
 create mode 100644 drivers/uwb/i1480/dfu/phy.c
 create mode 100644 drivers/uwb/i1480/dfu/usb.c
 create mode 100644 drivers/uwb/i1480/i1480-est.c
 create mode 100644 drivers/uwb/i1480/i1480-wlp.h
 create mode 100644 drivers/uwb/i1480/i1480u-wlp/Makefile
 create mode 100644 drivers/uwb/i1480/i1480u-wlp/i1480u-wlp.h
 create mode 100644 drivers/uwb/i1480/i1480u-wlp/lc.c
 create mode 100644 drivers/uwb/i1480/i1480u-wlp/netdev.c
 create mode 100644 drivers/uwb/i1480/i1480u-wlp/rx.c
 create mode 100644 drivers/uwb/i1480/i1480u-wlp/sysfs.c
 create mode 100644 drivers/uwb/i1480/i1480u-wlp/tx.c
 create mode 100644 drivers/uwb/ie.c
 create mode 100644 drivers/uwb/lc-dev.c
 create mode 100644 drivers/uwb/lc-rc.c
 create mode 100644 drivers/uwb/neh.c
 create mode 100644 drivers/uwb/pal.c
 create mode 100644 drivers/uwb/reset.c
 create mode 100644 drivers/uwb/rsv.c
 create mode 100644 drivers/uwb/scan.c
 create mode 100644 drivers/uwb/umc-bus.c
 create mode 100644 drivers/uwb/umc-dev.c
 create mode 100644 drivers/uwb/umc-drv.c
 create mode 100644 drivers/uwb/uwb-debug.c
 create mode 100644 drivers/uwb/uwb-internal.h
 create mode 100644 drivers/uwb/uwbd.c
 create mode 100644 drivers/uwb/whc-rc.c
 create mode 100644 drivers/uwb/whci.c
 create mode 100644 drivers/uwb/wlp/Makefile
 create mode 100644 drivers/uwb/wlp/driver.c
 create mode 100644 drivers/uwb/wlp/eda.c
 create mode 100644 drivers/uwb/wlp/messages.c
 create mode 100644 drivers/uwb/wlp/sysfs.c
 create mode 100644 drivers/uwb/wlp/txrx.c
 create mode 100644 drivers/uwb/wlp/wlp-internal.h
 create mode 100644 drivers/uwb/wlp/wlp-lc.c
 create mode 100644 drivers/uwb/wlp/wss-lc.c
 create mode 100644 include/linux/usb/wusb-wa.h
 create mode 100644 include/linux/usb/wusb.h
 create mode 100644 include/linux/uwb.h
 create mode 100644 include/linux/uwb/debug-cmd.h
 create mode 100644 include/linux/uwb/debug.h
 create mode 100644 include/linux/uwb/spec.h
 create mode 100644 include/linux/uwb/umc.h
 create mode 100644 include/linux/uwb/whci.h
 create mode 100644 include/linux/wlp.h
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/
