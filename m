Return-Path: <linux-kernel-owner+w=401wt.eu-S1751606AbZIVSma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606AbZIVSma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 14:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbZIVSm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 14:42:27 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:36913 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbZIVSmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 14:42:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=vy9rlfKD64fF6xhZe1xurTR1N5jasJYK9oiYfTwUp4uURWBKF/WdofEOpCrChRHaQ7
         f4/+RSKQX7nFiEIt1Ozo5cUkmRn/h6dLAF2FRzW0OKj4sTT5KDHNs52sCrv8VTw88D7d
         ufOBuVRT4bJMV9dj8N6TiOLaWjg2jNzoKIhuo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Date: Tue, 22 Sep 2009 20:44:07 +0200
Message-Id: <20090922184407.7695.96809.sendpatchset@localhost.localdomain>
In-Reply-To: <20090922184321.7695.11150.sendpatchset@localhost.localdomain>
References: <20090922184321.7695.11150.sendpatchset@localhost.localdomain>
Subject: [PATCH 5/8] Staging: rt28x0: updates from vendor's V2.1.0.0 drivers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rt28x0: updates from vendor's V2.1.0.0 drivers

Port changes from:

* 2009_0420_RT2860_Linux_STA_V2.1.0.0
* 2009_0302_RT2870_Linux_STA_v2.1.0.0
* 2009_0525_RT3070_Linux_STA_v2.1.1.0

to in-kernel drivers.


>From the RT2860 driver release note:

[2.1.0.0]
1. New generation schema for multiple OS porting
2. Fixed Ad-hoc ping failed in noisy environment. (Probe Response has too
    many retry packet then cause "not enough space in MgmtRing")
3. Fixed WPA(2)PSK issue when group cipher of AP is WEP40 or WEP104.
4. Modified iwpriv ra0 get_site_survey:
	In scan list result: Security shows "NONE" when AP is OPEN/NONE,
	shows "WEP" when AP is OPEN/WEP or SHARED/WEP, shows
	"WPAPSK(WPA2PSK)/TKIP(AES)" when AP is WPAPSK(WPA2PSK)/TKIP(AES)
	shows "WPA(WPA2)/TKIP(AES)" when AP is WPA(WPA2)/TKIP(AES)
5. Support kthread.
6. Add New A band channel list region 15 contains the whole channels in
   the A band region 4 and the new CE channel 167,169,171,173
7. Add New IEEE802.11r functionality.
8. Fixed WPA2-Enterprise failed when AP reboot or turn off then turn on.
9. Fixed STA cannot connect to 11B only AP when the setting of is PHY_11GN.


>From the RT2870 driver release note:

[V2.1.0.0]
1. New generation schema for multiple OS porting.
2. Fixed Ad-hoc ping failed in noisy environment. (Probe Response has too
   many retry packet then cause "not enough space in MgmtRing").
3. Fixed WPS failed with D-Link DIR-628 in 5GHz.
4. Change FastRoaming in DAT file to AutoRoaming.
5. Support kthread.
6. Add New A band channel list region 15 contains the whole channels in
   the A band region and the new CE channel 167,169,171,173.
7. New IEEE802.11r functionality.


>From the RT3070 driver release note:

Version V2.1.1.0
       1. Linux kernel 2.6.29 support.
       2. Fix eFuse write from BIN file bug.

Version 2.1.0.0
       1. New generation schema for multiple OS porting
       2. Fixed Ad-hoc ping failed in noisy environment.
       3. Modified iwpriv ra0 get_site_survey:
       4. Change FastRoaming in DAT file to AutoRoaming.
       5. Support kthread.
       6. New IEEE802.11r functionality.


Tested with RT2860 and RT3070 chipsets.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
The patch itself can be obtained from:

http://www.kernel.org/pub/linux/kernel/people/bart/ralink/staging-rt28x0-updates-from-vendors-v2.1.0.0-driver.patch

[ it is too big for the mailing list ]

 drivers/staging/rt2860/2860_main_dev.c         | 1319 ---
 drivers/staging/rt2860/Makefile                |   26 
 drivers/staging/rt2860/aironet.h               |  210 
 drivers/staging/rt2860/ap.h                    |   12 
 drivers/staging/rt2860/chip/mac_pci.h          |  365 
 drivers/staging/rt2860/chip/mac_usb.h          |  365 
 drivers/staging/rt2860/chip/rt2860.h           |   56 
 drivers/staging/rt2860/chip/rt2870.h           |   47 
 drivers/staging/rt2860/chip/rt3070.h           |   68 
 drivers/staging/rt2860/chip/rt30xx.h           |   48 
 drivers/staging/rt2860/chip/rtmp_mac.h         | 1334 +++
 drivers/staging/rt2860/chip/rtmp_phy.h         |  405 +
 drivers/staging/rt2860/chips/rt3070.c          |  185 
 drivers/staging/rt2860/chips/rt30xx.c          |  525 +
 drivers/staging/rt2860/chlist.h                | 1215 ---
 drivers/staging/rt2860/common/2860_rtmp_init.c |  897 --
 drivers/staging/rt2860/common/action.c         |   12 
 drivers/staging/rt2860/common/ba_action.c      |  147 
 drivers/staging/rt2860/common/cmm_aes.c        | 1404 +++
 drivers/staging/rt2860/common/cmm_asic.c       | 2531 ++++++
 drivers/staging/rt2860/common/cmm_cfg.c        |  290 
 drivers/staging/rt2860/common/cmm_data.c       |  906 --
 drivers/staging/rt2860/common/cmm_data_2860.c  | 1197 ---
 drivers/staging/rt2860/common/cmm_data_pci.c   | 1153 +++
 drivers/staging/rt2860/common/cmm_data_usb.c   |  968 ++
 drivers/staging/rt2860/common/cmm_info.c       |  822 +-
 drivers/staging/rt2860/common/cmm_mac_pci.c    | 1504 +++
 drivers/staging/rt2860/common/cmm_mac_usb.c    | 1216 +++
 drivers/staging/rt2860/common/cmm_profile.c    | 1736 ++++
 drivers/staging/rt2860/common/cmm_sanity.c     |  233 
 drivers/staging/rt2860/common/cmm_sync.c       |   70 
 drivers/staging/rt2860/common/cmm_tkip.c       |  882 ++
 drivers/staging/rt2860/common/cmm_wep.c        |  499 +
 drivers/staging/rt2860/common/cmm_wpa.c        | 3332 +++++++-
 drivers/staging/rt2860/common/crypt_hmac.c     |  279 
 drivers/staging/rt2860/common/crypt_md5.c      |  352 
 drivers/staging/rt2860/common/crypt_sha2.c     |  535 +
 drivers/staging/rt2860/common/dfs.c            |   66 
 drivers/staging/rt2860/common/ee_efuse.c       | 1525 ++++
 drivers/staging/rt2860/common/ee_prom.c        |  270 
 drivers/staging/rt2860/common/eeprom.c         | 1462 ---
 drivers/staging/rt2860/common/firmware.h       |    2 
 drivers/staging/rt2860/common/firmware_3070.h  |  517 +
 drivers/staging/rt2860/common/md5.c            | 1415 ---
 drivers/staging/rt2860/common/mlme.c           | 9508 ++++++++-----------------
 drivers/staging/rt2860/common/rt_channel.c     | 1280 +++
 drivers/staging/rt2860/common/rt_rf.c          |  194 
 drivers/staging/rt2860/common/rtmp_init.c      | 1969 ++---
 drivers/staging/rt2860/common/rtmp_mcu.c       |  233 
 drivers/staging/rt2860/common/rtmp_timer.c     |  323 
 drivers/staging/rt2860/common/rtmp_tkip.c      | 1586 ----
 drivers/staging/rt2860/common/rtmp_wep.c       |  497 -
 drivers/staging/rt2860/common/spectrum.c       |  460 +
 drivers/staging/rt2860/config.mk               |  241 
 drivers/staging/rt2860/crypt_hmac.h            |   82 
 drivers/staging/rt2860/crypt_md5.h             |   80 
 drivers/staging/rt2860/crypt_sha2.h            |  109 
 drivers/staging/rt2860/dfs.h                   |   32 
 drivers/staging/rt2860/eeprom.h                |   93 
 drivers/staging/rt2860/iface/rtmp_pci.h        |   83 
 drivers/staging/rt2860/iface/rtmp_usb.h        |  200 
 drivers/staging/rt2860/md5.h                   |  107 
 drivers/staging/rt2860/mlme.h                  |   89 
 drivers/staging/rt2860/oid.h                   |  135 
 drivers/staging/rt2860/pci_main_dev.c          |  873 ++
 drivers/staging/rt2860/rt2860.h                |  333 
 drivers/staging/rt2860/rt28xx.h                | 1688 ----
 drivers/staging/rt2860/rt_config.h             |   32 
 drivers/staging/rt2860/rt_linux.c              |  615 +
 drivers/staging/rt2860/rt_linux.h              |  966 +-
 drivers/staging/rt2860/rt_main_dev.c           |  750 -
 drivers/staging/rt2860/rt_pci_rbus.c           |  877 ++
 drivers/staging/rt2860/rt_profile.c            | 1839 ----
 drivers/staging/rt2860/rt_usb.c                |  828 ++
 drivers/staging/rt2860/rtmp.h                  | 2894 +++----
 drivers/staging/rt2860/rtmp_chip.h             |  265 
 drivers/staging/rt2860/rtmp_def.h              |  289 
 drivers/staging/rt2860/rtmp_dot11.h            |  102 
 drivers/staging/rt2860/rtmp_iface.h            |   84 
 drivers/staging/rt2860/rtmp_mcu.h              |   55 
 drivers/staging/rt2860/rtmp_os.h               |   98 
 drivers/staging/rt2860/rtmp_timer.h            |  156 
 drivers/staging/rt2860/rtmp_type.h             |   55 
 drivers/staging/rt2860/rtusb_io.h              |  189 
 drivers/staging/rt2860/spectrum.h              |  169 
 drivers/staging/rt2860/spectrum_def.h          |  148 
 drivers/staging/rt2860/sta/aironet.c           | 1312 ---
 drivers/staging/rt2860/sta/assoc.c             |  327 
 drivers/staging/rt2860/sta/auth.c              |  138 
 drivers/staging/rt2860/sta/auth_rsp.c          |   16 
 drivers/staging/rt2860/sta/connect.c           |  637 -
 drivers/staging/rt2860/sta/rtmp_data.c         |  257 
 drivers/staging/rt2860/sta/sanity.c            |   44 
 drivers/staging/rt2860/sta/sync.c              |  398 -
 drivers/staging/rt2860/sta/wpa.c               | 1994 -----
 drivers/staging/rt2860/sta_ioctl.c             |  761 +-
 drivers/staging/rt2860/usb_main_dev.c          |  897 ++
 drivers/staging/rt2860/wpa.h                   |  104 
 drivers/staging/rt2870/2870_main_dev.c         | 1530 ----
 drivers/staging/rt2870/Makefile                |   32 
 drivers/staging/rt2870/chips/rt3070.c          |    1 
 drivers/staging/rt2870/chips/rt30xx.c          |    1 
 drivers/staging/rt2870/common/2870_rtmp_init.c | 1730 ----
 drivers/staging/rt2870/common/acction.c        |    1 
 drivers/staging/rt2870/common/cmm_aes.c        |    1 
 drivers/staging/rt2870/common/cmm_asic.c       |    1 
 drivers/staging/rt2870/common/cmm_cfg.c        |    1 
 drivers/staging/rt2870/common/cmm_data_2870.c  |  936 --
 drivers/staging/rt2870/common/cmm_data_usb.c   |    1 
 drivers/staging/rt2870/common/cmm_mac_usb.c    |    1 
 drivers/staging/rt2870/common/cmm_profile.c    |    1 
 drivers/staging/rt2870/common/cmm_tkip.c       |    1 
 drivers/staging/rt2870/common/cmm_wep.c        |    1 
 drivers/staging/rt2870/common/crypt_hmac.c     |    1 
 drivers/staging/rt2870/common/crypt_md5.c      |    1 
 drivers/staging/rt2870/common/crypt_sha2.c     |    1 
 drivers/staging/rt2870/common/ee_efuse.c       |    1 
 drivers/staging/rt2870/common/rt_channel.c     |    1 
 drivers/staging/rt2870/common/rt_rf.c          |    1 
 drivers/staging/rt2870/common/rtmp_mcu.c       |    1 
 drivers/staging/rt2870/common/rtmp_timer.c     |    1 
 drivers/staging/rt2870/common/rtusb_bulk.c     |   37 
 drivers/staging/rt2870/common/rtusb_data.c     |   55 
 drivers/staging/rt2870/common/rtusb_io.c       |  465 -
 drivers/staging/rt2870/rt2870.h                |  583 -
 drivers/staging/rt2870/rt_usb.c                |    1 
 drivers/staging/rt2870/usb_main_dev.c          |    1 
 drivers/staging/rt3070/firmware.h              |    2 
 128 files changed, 39592 insertions(+), 35692 deletions(-)
