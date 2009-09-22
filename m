Return-Path: <linux-kernel-owner+w=401wt.eu-S1751198AbZIVSlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751198AbZIVSlf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 14:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750977AbZIVSle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 14:41:34 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:50668 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbZIVSld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 14:41:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=R8mjTvsz//MyEaDQ7LcOERmeePcZeMxORQBaO+ptTR/0PDRVraab9rLL8Uuf2HqWfO
         F2oVXUlXL6H85gW/emTIG0WiO2xrXlNywNsRQnYMugn2C+0q7gGucght+kB5Z16FJBcZ
         8QTrIr+ZKauPzRA14Cb5YXFoeB7QZOMsMYCfI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Date: Tue, 22 Sep 2009 20:43:21 +0200
Message-Id: <20090922184321.7695.11150.sendpatchset@localhost.localdomain>
Subject: [PATCH 0/8] Staging: updates for Ralink drivers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Here are some major updates to Ralink drivers from the staging tree.

rt28x0 drivers are updated to match V2.1.0.0 vendor's drivers, rt2860
driver gets RT3090 PCIe chipset support and no longer needed separate
rt3090 driver is removed.

The end result is 100 KLOC gone and shared common code for all chipsets.

The patchset was tested with RT2860 and RT3070 chipsets.


patches:
 #1-4: update rt3090 driver to match other Ralink drivers
   #5: port changes from vendor's V2.1.0.0 rt28x0 drivers
   #6: remove unused DFS code from rt2x00 drivers
   #7: add RT3090 PCIe chipset support to rt2860 driver
   #8: remove no longer needed rt3090 driver


diffstat:
 drivers/staging/Kconfig                          |    2 
 drivers/staging/Makefile                         |    1 
 drivers/staging/rt2860/2860_main_dev.c           | 1319 ---
 drivers/staging/rt2860/Kconfig                   |    5 
 drivers/staging/rt2860/Makefile                  |   33 
 drivers/staging/rt2860/aironet.h                 |  210 
 drivers/staging/rt2860/ap.h                      |   12 
 drivers/staging/rt2860/chip/mac_pci.h            |  377 
 drivers/staging/rt2860/chip/mac_usb.h            |  365 
 drivers/staging/rt2860/chip/rt2860.h             |   56 
 drivers/staging/rt2860/chip/rt2870.h             |   47 
 drivers/staging/rt2860/chip/rt3070.h             |   68 
 drivers/staging/rt2860/chip/rt3090.h             |   72 
 drivers/staging/rt2860/chip/rt30xx.h             |   48 
 drivers/staging/rt2860/chip/rtmp_mac.h           | 1334 +++
 drivers/staging/rt2860/chip/rtmp_phy.h           |  588 +
 drivers/staging/rt2860/chips/rt3070.c            |  185 
 drivers/staging/rt2860/chips/rt3090.c            |  123 
 drivers/staging/rt2860/chips/rt30xx.c            |  537 +
 drivers/staging/rt2860/chlist.h                  | 1215 --
 drivers/staging/rt2860/common/2860_rtmp_init.c   |  897 --
 drivers/staging/rt2860/common/action.c           |   12 
 drivers/staging/rt2860/common/ba_action.c        |  147 
 drivers/staging/rt2860/common/cmm_aes.c          | 1404 +++
 drivers/staging/rt2860/common/cmm_asic.c         | 2560 ++++++
 drivers/staging/rt2860/common/cmm_cfg.c          |  290 
 drivers/staging/rt2860/common/cmm_data.c         |  906 --
 drivers/staging/rt2860/common/cmm_data_2860.c    | 1197 --
 drivers/staging/rt2860/common/cmm_data_pci.c     | 1159 ++
 drivers/staging/rt2860/common/cmm_data_usb.c     |  968 ++
 drivers/staging/rt2860/common/cmm_info.c         |  822 +
 drivers/staging/rt2860/common/cmm_mac_pci.c      | 1759 ++++
 drivers/staging/rt2860/common/cmm_mac_usb.c      | 1216 ++
 drivers/staging/rt2860/common/cmm_profile.c      | 1779 ++++
 drivers/staging/rt2860/common/cmm_sanity.c       |  233 
 drivers/staging/rt2860/common/cmm_sync.c         |   83 
 drivers/staging/rt2860/common/cmm_tkip.c         |  882 ++
 drivers/staging/rt2860/common/cmm_wep.c          |  499 +
 drivers/staging/rt2860/common/cmm_wpa.c          | 3332 ++++++-
 drivers/staging/rt2860/common/crypt_hmac.c       |  279 
 drivers/staging/rt2860/common/crypt_md5.c        |  352 
 drivers/staging/rt2860/common/crypt_sha2.c       |  535 +
 drivers/staging/rt2860/common/dfs.c              |  444 -
 drivers/staging/rt2860/common/ee_efuse.c         | 1525 +++
 drivers/staging/rt2860/common/ee_prom.c          |  270 
 drivers/staging/rt2860/common/eeprom.c           | 1462 ---
 drivers/staging/rt2860/common/firmware.h         |    2 
 drivers/staging/rt2860/common/firmware_3070.h    |  517 +
 drivers/staging/rt2860/common/md5.c              | 1415 ---
 drivers/staging/rt2860/common/mlme.c             | 9620 ++++++++---------------
 drivers/staging/rt2860/common/rt_channel.c       | 1280 +++
 drivers/staging/rt2860/common/rt_rf.c            |  202 
 drivers/staging/rt2860/common/rtmp_init.c        | 2042 ++--
 drivers/staging/rt2860/common/rtmp_mcu.c         |  331 
 drivers/staging/rt2860/common/rtmp_timer.c       |  327 
 drivers/staging/rt2860/common/rtmp_tkip.c        | 1586 ---
 drivers/staging/rt2860/common/rtmp_wep.c         |  497 -
 drivers/staging/rt2860/common/spectrum.c         |  460 -
 drivers/staging/rt2860/config.mk                 |  241 
 drivers/staging/rt2860/crypt_hmac.h              |   82 
 drivers/staging/rt2860/crypt_md5.h               |   80 
 drivers/staging/rt2860/crypt_sha2.h              |  109 
 drivers/staging/rt2860/dfs.h                     |  107 
 drivers/staging/rt2860/eeprom.h                  |   93 
 drivers/staging/rt2860/iface/rtmp_pci.h          |   85 
 drivers/staging/rt2860/iface/rtmp_usb.h          |  200 
 drivers/staging/rt2860/md5.h                     |  107 
 drivers/staging/rt2860/mlme.h                    |   89 
 drivers/staging/rt2860/oid.h                     |  135 
 drivers/staging/rt2860/pci_main_dev.c            | 1258 ++-
 drivers/staging/rt2860/rt2860.h                  |  333 
 drivers/staging/rt2860/rt28xx.h                  | 1688 ----
 drivers/staging/rt2860/rt_config.h               |   32 
 drivers/staging/rt2860/rt_linux.c                |  618 +
 drivers/staging/rt2860/rt_linux.h                |  979 +-
 drivers/staging/rt2860/rt_main_dev.c             |  767 -
 drivers/staging/rt2860/rt_pci_rbus.c             |  881 ++
 drivers/staging/rt2860/rt_profile.c              | 1839 ----
 drivers/staging/rt2860/rt_usb.c                  |  828 +
 drivers/staging/rt2860/rtmp.h                    | 2943 ++-----
 drivers/staging/rt2860/rtmp_chip.h               |  268 
 drivers/staging/rt2860/rtmp_def.h                |  294 
 drivers/staging/rt2860/rtmp_dot11.h              |  102 
 drivers/staging/rt2860/rtmp_iface.h              |   84 
 drivers/staging/rt2860/rtmp_mcu.h                |   55 
 drivers/staging/rt2860/rtmp_os.h                 |   98 
 drivers/staging/rt2860/rtmp_timer.h              |  156 
 drivers/staging/rt2860/rtmp_type.h               |   55 
 drivers/staging/rt2860/rtusb_io.h                |  189 
 drivers/staging/rt2860/spectrum.h                |  169 
 drivers/staging/rt2860/spectrum_def.h            |  148 
 drivers/staging/rt2860/sta/aironet.c             | 1312 ---
 drivers/staging/rt2860/sta/assoc.c               |  339 
 drivers/staging/rt2860/sta/auth.c                |  138 
 drivers/staging/rt2860/sta/auth_rsp.c            |   20 
 drivers/staging/rt2860/sta/connect.c             |  827 -
 drivers/staging/rt2860/sta/rtmp_data.c           |  258 
 drivers/staging/rt2860/sta/sanity.c              |   44 
 drivers/staging/rt2860/sta/sync.c                |  424 -
 drivers/staging/rt2860/sta/wpa.c                 | 2042 ----
 drivers/staging/rt2860/sta_ioctl.c               |  768 +
 drivers/staging/rt2860/usb_main_dev.c            |  897 ++
 drivers/staging/rt2860/wpa.h                     |  111 
 drivers/staging/rt2870/2870_main_dev.c           | 1530 ---
 drivers/staging/rt2870/Makefile                  |   32 
 drivers/staging/rt2870/chips/rt3070.c            |    1 
 drivers/staging/rt2870/chips/rt30xx.c            |    1 
 drivers/staging/rt2870/common/2870_rtmp_init.c   | 1730 ----
 drivers/staging/rt2870/common/acction.c          |    1 
 drivers/staging/rt2870/common/cmm_aes.c          |    1 
 drivers/staging/rt2870/common/cmm_asic.c         |    1 
 drivers/staging/rt2870/common/cmm_cfg.c          |    1 
 drivers/staging/rt2870/common/cmm_data_2870.c    |  936 --
 drivers/staging/rt2870/common/cmm_data_usb.c     |    1 
 drivers/staging/rt2870/common/cmm_mac_usb.c      |    1 
 drivers/staging/rt2870/common/cmm_profile.c      |    1 
 drivers/staging/rt2870/common/cmm_tkip.c         |    1 
 drivers/staging/rt2870/common/cmm_wep.c          |    1 
 drivers/staging/rt2870/common/crypt_hmac.c       |    1 
 drivers/staging/rt2870/common/crypt_md5.c        |    1 
 drivers/staging/rt2870/common/crypt_sha2.c       |    1 
 drivers/staging/rt2870/common/ee_efuse.c         |    1 
 drivers/staging/rt2870/common/rt_channel.c       |    1 
 drivers/staging/rt2870/common/rt_rf.c            |    1 
 drivers/staging/rt2870/common/rtmp_mcu.c         |    1 
 drivers/staging/rt2870/common/rtmp_timer.c       |    1 
 drivers/staging/rt2870/common/rtusb_bulk.c       |   37 
 drivers/staging/rt2870/common/rtusb_data.c       |   55 
 drivers/staging/rt2870/common/rtusb_io.c         |  465 -
 drivers/staging/rt2870/rt2870.h                  |  583 -
 drivers/staging/rt2870/rt_usb.c                  |    1 
 drivers/staging/rt2870/usb_main_dev.c            |    1 
 drivers/staging/rt3070/firmware.h                |    2 
 drivers/staging/rt3090/Kconfig                   |    5 
 drivers/staging/rt3090/Makefile                  |   80 
 drivers/staging/rt3090/action.h                  |   66 
 drivers/staging/rt3090/ap.h                      |  512 -
 drivers/staging/rt3090/ap_apcli.h                |  276 
 drivers/staging/rt3090/ap_autoChSel.h            |   79 
 drivers/staging/rt3090/ap_autoChSel_cmm.h        |   66 
 drivers/staging/rt3090/ap_cfg.h                  |  118 
 drivers/staging/rt3090/ap_ids.h                  |   82 
 drivers/staging/rt3090/ap_mbss.h                 |   72 
 drivers/staging/rt3090/ap_uapsd.h                |  636 -
 drivers/staging/rt3090/ap_wds.h                  |  212 
 drivers/staging/rt3090/chips/rt3090.c            |  123 
 drivers/staging/rt3090/chips/rt30xx.c            |  525 -
 drivers/staging/rt3090/chips/rt3370.c            |  121 
 drivers/staging/rt3090/chips/rt3390.c            |  122 
 drivers/staging/rt3090/chips/rt33xx.c            |  536 -
 drivers/staging/rt3090/chlist.h                  |  130 
 drivers/staging/rt3090/common/action.c           | 1057 --
 drivers/staging/rt3090/common/ba_action.c        | 1779 ----
 drivers/staging/rt3090/common/cmm_aes.c          | 1560 ---
 drivers/staging/rt3090/common/cmm_asic.c         | 2753 ------
 drivers/staging/rt3090/common/cmm_cfg.c          |  295 
 drivers/staging/rt3090/common/cmm_data.c         | 2763 ------
 drivers/staging/rt3090/common/cmm_data_pci.c     | 1576 ---
 drivers/staging/rt3090/common/cmm_info.c         | 3717 --------
 drivers/staging/rt3090/common/cmm_mac_pci.c      | 1757 ----
 drivers/staging/rt3090/common/cmm_profile.c      | 2321 -----
 drivers/staging/rt3090/common/cmm_sanity.c       | 1718 ----
 drivers/staging/rt3090/common/cmm_sync.c         |  734 -
 drivers/staging/rt3090/common/cmm_tkip.c         |  966 --
 drivers/staging/rt3090/common/cmm_wep.c          |  500 -
 drivers/staging/rt3090/common/cmm_wpa.c          | 3149 -------
 drivers/staging/rt3090/common/crypt_aes.c        | 1007 --
 drivers/staging/rt3090/common/crypt_biginteger.c | 1119 --
 drivers/staging/rt3090/common/crypt_dh.c         |  234 
 drivers/staging/rt3090/common/crypt_hmac.c       |  279 
 drivers/staging/rt3090/common/crypt_md5.c        |  353 
 drivers/staging/rt3090/common/crypt_sha2.c       |  536 -
 drivers/staging/rt3090/common/dfs.c              |  481 -
 drivers/staging/rt3090/common/ee_efuse.c         | 1548 ---
 drivers/staging/rt3090/common/ee_prom.c          |  308 
 drivers/staging/rt3090/common/eeprom.c           |   98 
 drivers/staging/rt3090/common/igmp_snoop.c       | 1365 ---
 drivers/staging/rt3090/common/mlme.c             | 6550 ---------------
 drivers/staging/rt3090/common/mlme_ex.c          |  215 
 drivers/staging/rt3090/common/netif_block.c      |  147 
 drivers/staging/rt3090/common/rt_channel.c       | 1287 ---
 drivers/staging/rt3090/common/rt_rf.c            |  201 
 drivers/staging/rt3090/common/rtmp_init.c        | 3882 ---------
 drivers/staging/rt3090/common/rtmp_mcu.c         |  568 -
 drivers/staging/rt3090/common/rtmp_timer.c       |  327 
 drivers/staging/rt3090/common/spectrum.c         | 2221 -----
 drivers/staging/rt3090/config.mk                 |  191 
 drivers/staging/rt3090/crypt_hmac.h              |   81 
 drivers/staging/rt3090/crypt_md5.h               |   78 
 drivers/staging/rt3090/crypt_sha2.h              |  107 
 drivers/staging/rt3090/dfs.h                     |  137 
 drivers/staging/rt3090/eeprom.h                  |   82 
 drivers/staging/rt3090/firmware.h                |    2 
 drivers/staging/rt3090/igmp_snoop.h              |  152 
 drivers/staging/rt3090/ipv6.h                    |  215 
 drivers/staging/rt3090/link_list.h               |  133 
 drivers/staging/rt3090/mac_pci.h                 |  454 -
 drivers/staging/rt3090/mlme.h                    | 1360 ---
 drivers/staging/rt3090/mlme_ex.h                 |   83 
 drivers/staging/rt3090/mlme_ex_def.h             |   53 
 drivers/staging/rt3090/netif_block.h             |   56 
 drivers/staging/rt3090/oid.h                     | 1144 --
 drivers/staging/rt3090/pci_main_dev.c            | 1195 --
 drivers/staging/rt3090/rt3090.h                  |   77 
 drivers/staging/rt3090/rt30xx.h                  |   48 
 drivers/staging/rt3090/rt3370.h                  |   64 
 drivers/staging/rt3090/rt3390.h                  |   77 
 drivers/staging/rt3090/rt33xx.h                  |   48 
 drivers/staging/rt3090/rt_ate.c                  | 6089 --------------
 drivers/staging/rt3090/rt_ate.h                  |  314 
 drivers/staging/rt3090/rt_config.h               |  126 
 drivers/staging/rt3090/rt_linux.c                | 1623 ---
 drivers/staging/rt3090/rt_linux.h                | 1034 --
 drivers/staging/rt3090/rt_main_dev.c             |  897 --
 drivers/staging/rt3090/rt_pci_rbus.c             |  989 --
 drivers/staging/rt3090/rt_profile.c              |  101 
 drivers/staging/rt3090/rtmp.h                    | 6873 ----------------
 drivers/staging/rt3090/rtmp_chip.h               |  355 
 drivers/staging/rt3090/rtmp_def.h                | 1650 ---
 drivers/staging/rt3090/rtmp_dot11.h              |  146 
 drivers/staging/rt3090/rtmp_iface.h              |   81 
 drivers/staging/rt3090/rtmp_mac.h                | 2304 -----
 drivers/staging/rt3090/rtmp_mcu.h                |   55 
 drivers/staging/rt3090/rtmp_os.h                 |   93 
 drivers/staging/rt3090/rtmp_pci.h                |  110 
 drivers/staging/rt3090/rtmp_phy.h                |  631 -
 drivers/staging/rt3090/rtmp_timer.h              |  162 
 drivers/staging/rt3090/rtmp_type.h               |  147 
 drivers/staging/rt3090/spectrum.h                |  234 
 drivers/staging/rt3090/spectrum_def.h            |  257 
 drivers/staging/rt3090/sta/assoc.c               | 1673 ---
 drivers/staging/rt3090/sta/auth.c                |  491 -
 drivers/staging/rt3090/sta/auth_rsp.c            |  151 
 drivers/staging/rt3090/sta/connect.c             | 2759 ------
 drivers/staging/rt3090/sta/dls.c                 | 2207 -----
 drivers/staging/rt3090/sta/rtmp_ckipmic.c        |  579 -
 drivers/staging/rt3090/sta/rtmp_data.c           | 2661 ------
 drivers/staging/rt3090/sta/sanity.c              |  382 
 drivers/staging/rt3090/sta/sync.c                | 1840 ----
 drivers/staging/rt3090/sta/wpa.c                 |  396 
 drivers/staging/rt3090/sta_ioctl.c               | 7561 ------------------
 drivers/staging/rt3090/vr_ikans.h                |   71 
 drivers/staging/rt3090/wpa.h                     |  447 -
 243 files changed, 41013 insertions(+), 141016 deletions(-)
