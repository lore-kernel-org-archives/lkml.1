Return-Path: <linux-kernel-owner+w=401wt.eu-S1755872AbYJ2Wmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872AbYJ2Wmq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 18:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754623AbYJ2WmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 18:42:08 -0400
Received: from kroah.org ([198.145.64.141]:43725 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754341AbYJ2WmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 18:42:05 -0400
Date: Wed, 29 Oct 2008 15:38:32 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] STAGING patches for 2.6-git
Message-ID: <20081029223832.GC21657@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some more staging patches against your 2.6 git tree, all safe
and self-contained in the drivers/staging/ portion of the tree.

There have been a lot of patches sent to me cleaning up lots of these
drivers, and that's the majority of the patches in this pull request.

There is also 3 new drivers added:
	- Ralink rt2860 wireless driver
	- Atheros otus wireless driver
	- agnx wireless driver

The agnx driver had been out-of-tree for a long time, the otus driver is
a new one from Atheros that needs a lot of work, and the rt2860 is a
driver for hardware that is present in a lot of netbooks and devices
today and is also being shipped by a number of distros.

There is another out-of-tree rt2860 driver that is being developed in a
"clean" fashion to not contain a separate wireless stack, but it does
not work at all yet.  When that driver is finished and merged, this
driver can be removed from the staging tree.  But until then, users can
at least use their hardware, and distros can coordinate bugfixes instead
of spreading them around the web in odd corners.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/staging-2.6.git/

These have all been in the past few -next releases with no known build
errors.

Patches will be sent as a follow-on to this message to lkml for people
to see, but odds are, the new drivers are too big for the mailing list.

thanks,

greg k-h

 drivers/staging/Kconfig                        |    6 +
 drivers/staging/Makefile                       |    3 +
 drivers/staging/agnx/Kconfig                   |    5 +
 drivers/staging/agnx/Makefile                  |    8 +
 drivers/staging/agnx/TODO                      |   22 +
 drivers/staging/agnx/agnx.h                    |  156 +
 drivers/staging/agnx/debug.h                   |  418 ++
 drivers/staging/agnx/pci.c                     |  650 ++
 drivers/staging/agnx/phy.c                     |  958 +++
 drivers/staging/agnx/phy.h                     |  409 ++
 drivers/staging/agnx/rf.c                      |  894 +++
 drivers/staging/agnx/sta.c                     |  219 +
 drivers/staging/agnx/sta.h                     |  222 +
 drivers/staging/agnx/table.c                   |  168 +
 drivers/staging/agnx/table.h                   |   10 +
 drivers/staging/agnx/xmit.c                    |  819 +++
 drivers/staging/agnx/xmit.h                    |  250 +
 drivers/staging/at76_usb/Kconfig               |    2 +-
 drivers/staging/at76_usb/at76_usb.c            | 4615 +++----------
 drivers/staging/at76_usb/at76_usb.h            |  227 +-
 drivers/staging/me4000/me4000.c                |    2 +-
 drivers/staging/otus/80211core/amsdu.c         |  134 +
 drivers/staging/otus/80211core/cagg.c          | 3611 ++++++++++
 drivers/staging/otus/80211core/cagg.h          |  435 ++
 drivers/staging/otus/80211core/ccmd.c          | 1861 +++++
 drivers/staging/otus/80211core/cfunc.c         | 1227 ++++
 drivers/staging/otus/80211core/cfunc.h         |  449 ++
 drivers/staging/otus/80211core/chb.c           |  200 +
 drivers/staging/otus/80211core/cic.c           |  496 ++
 drivers/staging/otus/80211core/cinit.c         | 1911 ++++++
 drivers/staging/otus/80211core/cmm.c           | 2141 ++++++
 drivers/staging/otus/80211core/cmmap.c         | 2402 +++++++
 drivers/staging/otus/80211core/cmmsta.c        | 5782 ++++++++++++++++
 drivers/staging/otus/80211core/coid.c          | 2695 ++++++++
 drivers/staging/otus/80211core/cprecomp.h      |   32 +
 drivers/staging/otus/80211core/cpsmgr.c        |  731 ++
 drivers/staging/otus/80211core/cscanmgr.c      |  535 ++
 drivers/staging/otus/80211core/ctkip.c         |  598 ++
 drivers/staging/otus/80211core/ctxrx.c         | 4096 +++++++++++
 drivers/staging/otus/80211core/cwep.c          |  299 +
 drivers/staging/otus/80211core/cwm.c           |  131 +
 drivers/staging/otus/80211core/cwm.h           |   45 +
 drivers/staging/otus/80211core/freqctrl.c      |  259 +
 drivers/staging/otus/80211core/ledmgr.c        |  557 ++
 drivers/staging/otus/80211core/performance.c   |  431 ++
 drivers/staging/otus/80211core/performance.h   |   97 +
 drivers/staging/otus/80211core/pub_usb.h       |  102 +
 drivers/staging/otus/80211core/pub_zfi.h       |  821 +++
 drivers/staging/otus/80211core/pub_zfw.h       |   93 +
 drivers/staging/otus/80211core/queue.c         |  303 +
 drivers/staging/otus/80211core/queue.h         |   37 +
 drivers/staging/otus/80211core/ratectrl.c      |  874 +++
 drivers/staging/otus/80211core/ratectrl.h      |   37 +
 drivers/staging/otus/80211core/struct.h        | 1315 ++++
 drivers/staging/otus/80211core/wlan.h          |  595 ++
 drivers/staging/otus/Kconfig                   |   32 +
 drivers/staging/otus/Makefile                  |   67 +
 drivers/staging/otus/TODO                      |    9 +
 drivers/staging/otus/apdbg.c                   |  457 ++
 drivers/staging/otus/athr_common.h             |  141 +
 drivers/staging/otus/hal/hpDKfwu.c             |  832 +++
 drivers/staging/otus/hal/hpani.c               |  732 ++
 drivers/staging/otus/hal/hpani.h               |  420 ++
 drivers/staging/otus/hal/hpfw2.c               | 1018 +++
 drivers/staging/otus/hal/hpfwbu.c              | 5269 ++++++++++++++
 drivers/staging/otus/hal/hpfwspiu.c            |  655 ++
 drivers/staging/otus/hal/hpfwu.c               | 1017 +++
 drivers/staging/otus/hal/hpfwu.c.drv_ba_resend |  742 ++
 drivers/staging/otus/hal/hpfwu_2k.c            | 1016 +++
 drivers/staging/otus/hal/hpfwu_BA.c            |  874 +++
 drivers/staging/otus/hal/hpfwu_FB50_mdk.c      |  721 ++
 drivers/staging/otus/hal/hpfwu_OTUS_RC.c       |  715 ++
 drivers/staging/otus/hal/hpfwu_txstream.c      | 1017 +++
 drivers/staging/otus/hal/hpfwuinit.c           |  240 +
 drivers/staging/otus/hal/hpmain.c              | 4643 +++++++++++++
 drivers/staging/otus/hal/hpreg.c               | 2481 +++++++
 drivers/staging/otus/hal/hpreg.h               |  524 ++
 drivers/staging/otus/hal/hprw.c                | 1557 +++++
 drivers/staging/otus/hal/hpusb.c               | 1584 +++++
 drivers/staging/otus/hal/hpusb.h               |  437 ++
 drivers/staging/otus/hal/otus.ini              |  414 ++
 drivers/staging/otus/ioctl.c                   | 2936 ++++++++
 drivers/staging/otus/oal_dt.h                  |   60 +
 drivers/staging/otus/oal_marc.h                |  135 +
 drivers/staging/otus/usbdrv.c                  | 1210 ++++
 drivers/staging/otus/usbdrv.h                  |  257 +
 drivers/staging/otus/wrap_buf.c                |  114 +
 drivers/staging/otus/wrap_dbg.c                |  101 +
 drivers/staging/otus/wrap_ev.c                 |  283 +
 drivers/staging/otus/wrap_mem.c                |  101 +
 drivers/staging/otus/wrap_mis.c                |  108 +
 drivers/staging/otus/wrap_pkt.c                |  178 +
 drivers/staging/otus/wrap_sec.c                |  127 +
 drivers/staging/otus/wrap_usb.c                |  195 +
 drivers/staging/otus/wwrap.c                   | 1207 ++++
 drivers/staging/otus/zdcompat.h                |  116 +
 drivers/staging/otus/zdusb.c                   |  295 +
 drivers/staging/otus/zdusb.h                   |   43 +
 drivers/staging/poch/README                    |    9 +-
 drivers/staging/poch/poch.c                    |  102 +-
 drivers/staging/rt2860/2860_main_dev.c         | 1377 ++++
 drivers/staging/rt2860/Kconfig                 |    5 +
 drivers/staging/rt2860/Makefile                |   41 +
 drivers/staging/rt2860/TODO                    |   17 +
 drivers/staging/rt2860/aironet.h               |  210 +
 drivers/staging/rt2860/ap.h                    |  557 ++
 drivers/staging/rt2860/chlist.h                | 1296 ++++
 drivers/staging/rt2860/common/2860_rtmp_init.c |  922 +++
 drivers/staging/rt2860/common/action.c         | 1031 +++
 drivers/staging/rt2860/common/action.h         |   68 +
 drivers/staging/rt2860/common/ba_action.c      | 1802 +++++
 drivers/staging/rt2860/common/cmm_data.c       | 3469 ++++++++++
 drivers/staging/rt2860/common/cmm_data_2860.c  | 1240 ++++
 drivers/staging/rt2860/common/cmm_info.c       | 3417 ++++++++++
 drivers/staging/rt2860/common/cmm_sanity.c     | 1633 +++++
 drivers/staging/rt2860/common/cmm_sync.c       |  702 ++
 drivers/staging/rt2860/common/cmm_wpa.c        | 1606 +++++
 drivers/staging/rt2860/common/dfs.c            |  453 ++
 drivers/staging/rt2860/common/eeprom.c         |  244 +
 drivers/staging/rt2860/common/firmware.h       |  558 ++
 drivers/staging/rt2860/common/md5.c            | 1427 ++++
 drivers/staging/rt2860/common/mlme.c           | 8667 ++++++++++++++++++++++++
 drivers/staging/rt2860/common/netif_block.c    |  144 +
 drivers/staging/rt2860/common/netif_block.h    |   58 +
 drivers/staging/rt2860/common/rtmp_init.c      | 3757 ++++++++++
 drivers/staging/rt2860/common/rtmp_tkip.c      | 1607 +++++
 drivers/staging/rt2860/common/rtmp_wep.c       |  499 ++
 drivers/staging/rt2860/common/spectrum.c       | 1877 +++++
 drivers/staging/rt2860/config.mk               |  245 +
 drivers/staging/rt2860/dfs.h                   |  100 +
 drivers/staging/rt2860/leap.h                  |  215 +
 drivers/staging/rt2860/link_list.h             |  134 +
 drivers/staging/rt2860/md4.h                   |   42 +
 drivers/staging/rt2860/md5.h                   |  107 +
 drivers/staging/rt2860/mlme.h                  | 1447 ++++
 drivers/staging/rt2860/oid.h                   |  995 +++
 drivers/staging/rt2860/rt2860.h                |  349 +
 drivers/staging/rt2860/rt28xx.h                | 2714 ++++++++
 drivers/staging/rt2860/rt_ate.c                | 6025 ++++++++++++++++
 drivers/staging/rt2860/rt_ate.h                |  353 +
 drivers/staging/rt2860/rt_config.h             |  101 +
 drivers/staging/rt2860/rt_linux.c              | 1054 +++
 drivers/staging/rt2860/rt_linux.h              |  926 +++
 drivers/staging/rt2860/rt_main_dev.c           | 1686 +++++
 drivers/staging/rt2860/rt_profile.c            | 1976 ++++++
 drivers/staging/rt2860/rtmp.h                  | 7177 ++++++++++++++++++++
 drivers/staging/rt2860/rtmp_ckipmic.h          |  113 +
 drivers/staging/rt2860/rtmp_def.h              | 1588 +++++
 drivers/staging/rt2860/rtmp_type.h             |   94 +
 drivers/staging/rt2860/spectrum.h              |  322 +
 drivers/staging/rt2860/spectrum_def.h          |   95 +
 drivers/staging/rt2860/sta/aironet.c           | 1312 ++++
 drivers/staging/rt2860/sta/assoc.c             | 1826 +++++
 drivers/staging/rt2860/sta/auth.c              |  474 ++
 drivers/staging/rt2860/sta/auth_rsp.c          |  167 +
 drivers/staging/rt2860/sta/connect.c           | 2751 ++++++++
 drivers/staging/rt2860/sta/dls.c               | 2201 ++++++
 drivers/staging/rt2860/sta/rtmp_data.c         | 2614 +++++++
 drivers/staging/rt2860/sta/sanity.c            |  420 ++
 drivers/staging/rt2860/sta/sync.c              | 1961 ++++++
 drivers/staging/rt2860/sta/wpa.c               | 2086 ++++++
 drivers/staging/rt2860/sta_ioctl.c             | 6944 +++++++++++++++++++
 drivers/staging/rt2860/wpa.h                   |  356 +
 drivers/staging/sxg/sxg.c                      |  316 +-
 drivers/staging/sxg/sxg.h                      |  121 +-
 drivers/staging/sxg/sxg_os.h                   |   24 +-
 drivers/staging/sxg/sxgdbg.h                   |   15 +-
 drivers/staging/sxg/sxghif.h                   |  139 +-
 drivers/staging/sxg/sxghw.h                    |   40 +-
 drivers/staging/sxg/sxgphycode.h               |    2 +-
 drivers/staging/usbip/Kconfig                  |    2 +-
 drivers/staging/winbond/adapter.h              |   65 +-
 drivers/staging/winbond/bss_f.h                |   68 +-
 drivers/staging/winbond/bssdscpt.h             |    8 +-
 drivers/staging/winbond/ds_tkip.h              |    4 +-
 drivers/staging/winbond/linux/common.h         |   21 -
 drivers/staging/winbond/linux/sysdef.h         |    1 -
 drivers/staging/winbond/linux/wb35reg.c        |  528 +-
 drivers/staging/winbond/linux/wb35reg_f.h      |    2 +-
 drivers/staging/winbond/linux/wb35reg_s.h      |   35 +-
 drivers/staging/winbond/linux/wb35rx.c         |   33 +-
 drivers/staging/winbond/linux/wb35rx_f.h       |    2 +-
 drivers/staging/winbond/linux/wb35tx.c         |   56 +-
 drivers/staging/winbond/linux/wb35tx_f.h       |    4 +-
 drivers/staging/winbond/linux/wbusb.c          |  172 +-
 drivers/staging/winbond/linux/wbusb_f.h        |   34 -
 drivers/staging/winbond/linux/wbusb_s.h        |    6 +-
 drivers/staging/winbond/localpara.h            |    2 +-
 drivers/staging/winbond/mds.c                  |   93 +-
 drivers/staging/winbond/mds_f.h                |   40 +-
 drivers/staging/winbond/mds_s.h                |   20 +-
 drivers/staging/winbond/mlme_mib.h             |   20 +-
 drivers/staging/winbond/mlmetxrx.c             |   92 +-
 drivers/staging/winbond/mlmetxrx_f.h           |   20 +-
 drivers/staging/winbond/mto.c                  |   20 +-
 drivers/staging/winbond/mto.h                  |   22 +-
 drivers/staging/winbond/mto_f.h                |    6 +-
 drivers/staging/winbond/phy_calibration.c      |   39 +-
 drivers/staging/winbond/reg.c                  |  348 +-
 drivers/staging/winbond/rxisr.c                |   18 +-
 drivers/staging/winbond/scan_s.h               |   12 +-
 drivers/staging/winbond/sme_s.h                |    4 +-
 drivers/staging/winbond/wbhal.c                |  353 +-
 drivers/staging/winbond/wbhal_f.h              |   11 +-
 drivers/staging/winbond/wbhal_s.h              |    8 +-
 drivers/staging/winbond/wblinux.c              |  143 +-
 drivers/staging/winbond/wblinux_f.h            |   26 +-
 drivers/staging/winbond/wblinux_s.h            |   45 -
 drivers/staging/wlan-ng/Kconfig                |    4 +-
 drivers/staging/wlan-ng/README                 |    1 -
 drivers/staging/wlan-ng/hfa384x.c              | 4018 -----------
 drivers/staging/wlan-ng/hfa384x.h              |  269 -
 drivers/staging/wlan-ng/hfa384x_usb.c          |  129 +-
 drivers/staging/wlan-ng/p80211conv.c           |   40 -
 drivers/staging/wlan-ng/p80211metadef.h        |  375 -
 drivers/staging/wlan-ng/p80211metastruct.h     |  118 -
 drivers/staging/wlan-ng/p80211mod.c            |   21 +-
 drivers/staging/wlan-ng/p80211netdev.c         |  238 +-
 drivers/staging/wlan-ng/p80211netdev.h         |   39 -
 drivers/staging/wlan-ng/p80211req.c            |    1 -
 drivers/staging/wlan-ng/p80211wep.c            |    1 -
 drivers/staging/wlan-ng/p80211wext.c           |  217 +-
 drivers/staging/wlan-ng/prism2_cs.c            | 1487 ----
 drivers/staging/wlan-ng/prism2_pci.c           |  332 -
 drivers/staging/wlan-ng/prism2_plx.c           |  472 --
 drivers/staging/wlan-ng/prism2_usb.c           |   58 +-
 drivers/staging/wlan-ng/prism2mgmt.c           | 1269 +---
 drivers/staging/wlan-ng/prism2mgmt.h           |   13 -
 drivers/staging/wlan-ng/prism2mib.c            | 1001 +---
 drivers/staging/wlan-ng/prism2sta.c            |  246 +-
 drivers/staging/wlan-ng/version.h              |   64 -
 drivers/staging/wlan-ng/wlan_compat.h          |  448 +--
 232 files changed, 168034 insertions(+), 16107 deletions(-)
 create mode 100644 drivers/staging/agnx/Kconfig
 create mode 100644 drivers/staging/agnx/Makefile
 create mode 100644 drivers/staging/agnx/TODO
 create mode 100644 drivers/staging/agnx/agnx.h
 create mode 100644 drivers/staging/agnx/debug.h
 create mode 100644 drivers/staging/agnx/pci.c
 create mode 100644 drivers/staging/agnx/phy.c
 create mode 100644 drivers/staging/agnx/phy.h
 create mode 100644 drivers/staging/agnx/rf.c
 create mode 100644 drivers/staging/agnx/sta.c
 create mode 100644 drivers/staging/agnx/sta.h
 create mode 100644 drivers/staging/agnx/table.c
 create mode 100644 drivers/staging/agnx/table.h
 create mode 100644 drivers/staging/agnx/xmit.c
 create mode 100644 drivers/staging/agnx/xmit.h
 create mode 100644 drivers/staging/otus/80211core/amsdu.c
 create mode 100644 drivers/staging/otus/80211core/cagg.c
 create mode 100644 drivers/staging/otus/80211core/cagg.h
 create mode 100644 drivers/staging/otus/80211core/ccmd.c
 create mode 100644 drivers/staging/otus/80211core/cfunc.c
 create mode 100644 drivers/staging/otus/80211core/cfunc.h
 create mode 100644 drivers/staging/otus/80211core/chb.c
 create mode 100644 drivers/staging/otus/80211core/cic.c
 create mode 100644 drivers/staging/otus/80211core/cinit.c
 create mode 100644 drivers/staging/otus/80211core/cmm.c
 create mode 100644 drivers/staging/otus/80211core/cmmap.c
 create mode 100644 drivers/staging/otus/80211core/cmmsta.c
 create mode 100644 drivers/staging/otus/80211core/coid.c
 create mode 100644 drivers/staging/otus/80211core/cprecomp.h
 create mode 100644 drivers/staging/otus/80211core/cpsmgr.c
 create mode 100644 drivers/staging/otus/80211core/cscanmgr.c
 create mode 100644 drivers/staging/otus/80211core/ctkip.c
 create mode 100644 drivers/staging/otus/80211core/ctxrx.c
 create mode 100644 drivers/staging/otus/80211core/cwep.c
 create mode 100644 drivers/staging/otus/80211core/cwm.c
 create mode 100644 drivers/staging/otus/80211core/cwm.h
 create mode 100644 drivers/staging/otus/80211core/freqctrl.c
 create mode 100644 drivers/staging/otus/80211core/ledmgr.c
 create mode 100644 drivers/staging/otus/80211core/performance.c
 create mode 100644 drivers/staging/otus/80211core/performance.h
 create mode 100644 drivers/staging/otus/80211core/pub_usb.h
 create mode 100644 drivers/staging/otus/80211core/pub_zfi.h
 create mode 100644 drivers/staging/otus/80211core/pub_zfw.h
 create mode 100644 drivers/staging/otus/80211core/queue.c
 create mode 100644 drivers/staging/otus/80211core/queue.h
 create mode 100644 drivers/staging/otus/80211core/ratectrl.c
 create mode 100644 drivers/staging/otus/80211core/ratectrl.h
 create mode 100644 drivers/staging/otus/80211core/struct.h
 create mode 100644 drivers/staging/otus/80211core/wlan.h
 create mode 100644 drivers/staging/otus/Kconfig
 create mode 100644 drivers/staging/otus/Makefile
 create mode 100644 drivers/staging/otus/TODO
 create mode 100644 drivers/staging/otus/apdbg.c
 create mode 100644 drivers/staging/otus/athr_common.h
 create mode 100644 drivers/staging/otus/hal/hpDKfwu.c
 create mode 100644 drivers/staging/otus/hal/hpani.c
 create mode 100644 drivers/staging/otus/hal/hpani.h
 create mode 100644 drivers/staging/otus/hal/hpfw2.c
 create mode 100644 drivers/staging/otus/hal/hpfwbu.c
 create mode 100644 drivers/staging/otus/hal/hpfwspiu.c
 create mode 100644 drivers/staging/otus/hal/hpfwu.c
 create mode 100644 drivers/staging/otus/hal/hpfwu.c.drv_ba_resend
 create mode 100644 drivers/staging/otus/hal/hpfwu_2k.c
 create mode 100644 drivers/staging/otus/hal/hpfwu_BA.c
 create mode 100644 drivers/staging/otus/hal/hpfwu_FB50_mdk.c
 create mode 100644 drivers/staging/otus/hal/hpfwu_OTUS_RC.c
 create mode 100644 drivers/staging/otus/hal/hpfwu_txstream.c
 create mode 100644 drivers/staging/otus/hal/hpfwuinit.c
 create mode 100644 drivers/staging/otus/hal/hpmain.c
 create mode 100644 drivers/staging/otus/hal/hpreg.c
 create mode 100644 drivers/staging/otus/hal/hpreg.h
 create mode 100644 drivers/staging/otus/hal/hprw.c
 create mode 100644 drivers/staging/otus/hal/hpusb.c
 create mode 100644 drivers/staging/otus/hal/hpusb.h
 create mode 100644 drivers/staging/otus/hal/otus.ini
 create mode 100644 drivers/staging/otus/ioctl.c
 create mode 100644 drivers/staging/otus/oal_dt.h
 create mode 100644 drivers/staging/otus/oal_marc.h
 create mode 100644 drivers/staging/otus/usbdrv.c
 create mode 100644 drivers/staging/otus/usbdrv.h
 create mode 100644 drivers/staging/otus/wrap_buf.c
 create mode 100644 drivers/staging/otus/wrap_dbg.c
 create mode 100644 drivers/staging/otus/wrap_ev.c
 create mode 100644 drivers/staging/otus/wrap_mem.c
 create mode 100644 drivers/staging/otus/wrap_mis.c
 create mode 100644 drivers/staging/otus/wrap_pkt.c
 create mode 100644 drivers/staging/otus/wrap_sec.c
 create mode 100644 drivers/staging/otus/wrap_usb.c
 create mode 100644 drivers/staging/otus/wwrap.c
 create mode 100644 drivers/staging/otus/zdcompat.h
 create mode 100644 drivers/staging/otus/zdusb.c
 create mode 100644 drivers/staging/otus/zdusb.h
 create mode 100644 drivers/staging/rt2860/2860_main_dev.c
 create mode 100644 drivers/staging/rt2860/Kconfig
 create mode 100644 drivers/staging/rt2860/Makefile
 create mode 100644 drivers/staging/rt2860/TODO
 create mode 100644 drivers/staging/rt2860/aironet.h
 create mode 100644 drivers/staging/rt2860/ap.h
 create mode 100644 drivers/staging/rt2860/chlist.h
 create mode 100644 drivers/staging/rt2860/common/2860_rtmp_init.c
 create mode 100644 drivers/staging/rt2860/common/action.c
 create mode 100644 drivers/staging/rt2860/common/action.h
 create mode 100644 drivers/staging/rt2860/common/ba_action.c
 create mode 100644 drivers/staging/rt2860/common/cmm_data.c
 create mode 100644 drivers/staging/rt2860/common/cmm_data_2860.c
 create mode 100644 drivers/staging/rt2860/common/cmm_info.c
 create mode 100644 drivers/staging/rt2860/common/cmm_sanity.c
 create mode 100644 drivers/staging/rt2860/common/cmm_sync.c
 create mode 100644 drivers/staging/rt2860/common/cmm_wpa.c
 create mode 100644 drivers/staging/rt2860/common/dfs.c
 create mode 100644 drivers/staging/rt2860/common/eeprom.c
 create mode 100644 drivers/staging/rt2860/common/firmware.h
 create mode 100644 drivers/staging/rt2860/common/md5.c
 create mode 100644 drivers/staging/rt2860/common/mlme.c
 create mode 100644 drivers/staging/rt2860/common/netif_block.c
 create mode 100644 drivers/staging/rt2860/common/netif_block.h
 create mode 100644 drivers/staging/rt2860/common/rtmp_init.c
 create mode 100644 drivers/staging/rt2860/common/rtmp_tkip.c
 create mode 100644 drivers/staging/rt2860/common/rtmp_wep.c
 create mode 100644 drivers/staging/rt2860/common/spectrum.c
 create mode 100644 drivers/staging/rt2860/config.mk
 create mode 100644 drivers/staging/rt2860/dfs.h
 create mode 100644 drivers/staging/rt2860/leap.h
 create mode 100644 drivers/staging/rt2860/link_list.h
 create mode 100644 drivers/staging/rt2860/md4.h
 create mode 100644 drivers/staging/rt2860/md5.h
 create mode 100644 drivers/staging/rt2860/mlme.h
 create mode 100644 drivers/staging/rt2860/oid.h
 create mode 100644 drivers/staging/rt2860/rt2860.h
 create mode 100644 drivers/staging/rt2860/rt28xx.h
 create mode 100644 drivers/staging/rt2860/rt_ate.c
 create mode 100644 drivers/staging/rt2860/rt_ate.h
 create mode 100644 drivers/staging/rt2860/rt_config.h
 create mode 100644 drivers/staging/rt2860/rt_linux.c
 create mode 100644 drivers/staging/rt2860/rt_linux.h
 create mode 100644 drivers/staging/rt2860/rt_main_dev.c
 create mode 100644 drivers/staging/rt2860/rt_profile.c
 create mode 100644 drivers/staging/rt2860/rtmp.h
 create mode 100644 drivers/staging/rt2860/rtmp_ckipmic.h
 create mode 100644 drivers/staging/rt2860/rtmp_def.h
 create mode 100644 drivers/staging/rt2860/rtmp_type.h
 create mode 100644 drivers/staging/rt2860/spectrum.h
 create mode 100644 drivers/staging/rt2860/spectrum_def.h
 create mode 100644 drivers/staging/rt2860/sta/aironet.c
 create mode 100644 drivers/staging/rt2860/sta/assoc.c
 create mode 100644 drivers/staging/rt2860/sta/auth.c
 create mode 100644 drivers/staging/rt2860/sta/auth_rsp.c
 create mode 100644 drivers/staging/rt2860/sta/connect.c
 create mode 100644 drivers/staging/rt2860/sta/dls.c
 create mode 100644 drivers/staging/rt2860/sta/rtmp_data.c
 create mode 100644 drivers/staging/rt2860/sta/sanity.c
 create mode 100644 drivers/staging/rt2860/sta/sync.c
 create mode 100644 drivers/staging/rt2860/sta/wpa.c
 create mode 100644 drivers/staging/rt2860/sta_ioctl.c
 create mode 100644 drivers/staging/rt2860/wpa.h
 delete mode 100644 drivers/staging/winbond/linux/wbusb_f.h
 delete mode 100644 drivers/staging/winbond/wblinux_s.h
 delete mode 100644 drivers/staging/wlan-ng/hfa384x.c
 delete mode 100644 drivers/staging/wlan-ng/prism2_cs.c
 delete mode 100644 drivers/staging/wlan-ng/prism2_pci.c
 delete mode 100644 drivers/staging/wlan-ng/prism2_plx.c
 delete mode 100644 drivers/staging/wlan-ng/version.h

---------------

Greg Kroah-Hartman (6):
      Staging: make usbip depend on CONFIG_NET
      Staging: w35und: remove usb_submit_urb wrapper function
      Staging: w35und: remove usb_alloc_urb wrapper function
      Staging: at76_usb: remove compiler warnings
      Staging: at76_usb: fix up all remaining checkpatch.pl warnings
      Staging: add rt2860 wireless driver

Harvey Harrison (1):
      staging: correct dubious use of !x & y

J.R. Mauro (2):
      Staging: sxg: remove typedefs
      Staging: sxg: break the build in a cleaner way when !x86

John W. Linville (1):
      Staging: at76_usb: update drivers/staging/at76_usb w/ mac80211 port

Li YanBo (1):
      Staging: add agnx wireless driver

Luis R. Rodriguez (1):
      Staging: add otus Atheros wireless network driver

Pekka Enberg (17):
      Staging: w35und: make wb35_probe() and wb35_disconnect() funtions static
      Staging: w35und: remove unused wb35_open() and wb35_close() functions
      Staging: w35und: use msleep() and udelay()
      Staging: w35und: remove the no-op pa_stall_execution macro
      Staging: w35und: purb typedef removal
      Staging: w35und: reg queue struct typedef removal
      Staging: w35und: wb35reg struct typedef removal
      Staging: w35und: padapter struct typedef removal
      Staging: w35und: merge wblinux struct to adapter
      Staging: w35und: wb35_probe() cleanup
      w35und: remove dead code from wbusb_f.h
      Staging: w35und: remove true/false boolean macros
      Staging: w35und: OS_MEMORY_ALLOC wrapper removal
      Staging: w35und: usb_put_dev() is missing from wb35_disconnect()
      Staging: w35und: remove macro magic from MLME_GetNextPacket()
      Staging: w35und: plug memory leak in wbsoft_tx()
      Staging: w35und: move supported band initialization out of wb35_probe()

Solomon Peachy (12):
      Staging: wlan-ng: Remove PCI/PLX/PCMCIA files.
      Staging: wlan-ng: Update Help text to mention prism3 devices.
      Staging: wlan-ng: Delete PCI/PLX/PCMCIA-specific code.
      Staging: wlan-ng: Make wlan-ng use WEXT mode by default.
      Staging: wlan-ng: Eliminate more <2.6 kernel support.
      Staging: wlan-ng: Eliminate all backwards-compatibility for <2.6.13 kernels.
      Staging: wlan-ng: Eliminate a boatload of tertiaryAP-only code.
      Staging: wlan-ng: Remove AP-only code from MLME functions.
      Staging: wlan-ng: Get rid of the MTU tests in the rx conversion path.
      Staging: wlan-ng: Eliminate one more rx mtu test.
      Staging: wlan-ng: Eliminate local 'version.h'
      Staging: wlan-ng: Eliminate usage of procfs.

vijaykumar@bravegnu.org (8):
      Staging: poch: Block size bug fix
      Staging: poch: Update TODO list
      Staging: poch: Correct pages from bytes.
      Staging: poch: minor fixes
      Staging: poch: Fix build warnings
      Staging: poch: Rx control register init
      Staging: poch: Fix user space protocol syncing
      Staging: poch: Fine grained locking

