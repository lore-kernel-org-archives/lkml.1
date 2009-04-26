Return-Path: <linux-kernel-owner+w=401wt.eu-S1753563AbZDZP4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563AbZDZP4s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 11:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbZDZP4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 11:56:39 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:64168 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbZDZP4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 11:56:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=jg3bEgBOmFY5WXFrqx4N7LQlv0MfbQDmvYeY/6cWefD8tf3LYMAAazHEtD21tb6mE8
         hmbI2nZzJmq668cKPHrH0ysG0HKGihT2bcll5ZmbDKtuRz8S7pHlPvJPMfWYiZ6m1SUW
         14/3nwVeHXZxZtzlysrl02RbTxmWcSz8RVoks=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Greg KH <greg@kroah.com>
Subject: [git patches] Staging: rtxxx0: cleanup and "dumb" merge
Date: Sun, 26 Apr 2009 17:59:20 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29-next-20090403; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904261759.20923.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

This patchset cleans up rt{286,287,307}0 drivers (66 KLOC removed) and then
"dumb" (i.e. rt3070 shares code with rt2870 by including rt2870's .c files
and depends on ifdefs to get the correct end result) merges them (142 KLOC
removed).  All in all 208 KLOC are gone and we now use the common code for
all three Ralink drivers.

"dumb" merge is of course not the ideal solution but allows relatively easy
verification, makes the eventual real merge much easier and in the meantime
allows us to work with the common code for all drivers (since the initial
merge these drivers already became slightly out-of-sync with each other).

[ I know about rt2x00 project (http://rt2x00.serialmonkey.com/) and I praise
  their efforts.  However I still wanted to skim through the original code,
  mainly because I heard a lot of "interesting" things about it. ;)  Then I
  started to clean it to make reading easier and before I knew it I ended up
  with this monster patchset... ]


All changes are available in the following git tree (which is based on top
of next-20090424):

git://git.kernel.org:/pub/scm/linux/kernel/git/bart/misc.git rtsta-for-next

[ I'm not sending individual patches to LKML (they are too big and there
  is too many of them) but if somebody prefers to get them by mail instead
  of grabbing them from git tree please just ping me. ]


patches:

#001
- remove leftover files

#002-003
- remove compatibility wrappers for older kernels

#004-005
- remove IWE_STREAM_ADD_*() macros

#006-084
- remove dead and/or disabled features
- remove superfluous ifdefs

#085-087
- use empty ASSERT() macro (the current checks aren't really that useful, also
  the use of __FILE__ and __LINE__ preprocessor macros prevented semi-automatic
  verification of later changes) -- these patches can be reverted now if they
  turn out to be too controversial

#088-090
- remove dead code

#091-096:
- "dumb" merge rt3070 and rt2870 driver code

#097-102
- "dumb" merge rt{28,30}70 and rt2860 driver code


diffstat:

 drivers/staging/rt2860/2860_main_dev.c         |   41 +-
 drivers/staging/rt2860/Makefile                |    5 +-
 drivers/staging/rt2860/ap.h                    |   40 +-
 drivers/staging/rt2860/chlist.h                |   56 +-
 drivers/staging/rt2860/common/2860_rtmp_init.c |   25 -
 drivers/staging/rt2860/common/action.c         |  444 +--
 drivers/staging/rt2860/common/action.h         |    7 -
 drivers/staging/rt2860/common/ba_action.c      |  179 +-
 drivers/staging/rt2860/common/cmm_data.c       |  647 +--
 drivers/staging/rt2860/common/cmm_data_2860.c  |  105 +-
 drivers/staging/rt2860/common/cmm_info.c       |  271 +-
 drivers/staging/rt2860/common/cmm_sanity.c     |  401 +-
 drivers/staging/rt2860/common/cmm_sync.c       |  113 +-
 drivers/staging/rt2860/common/cmm_wpa.c        |   26 +-
 drivers/staging/rt2860/common/dfs.c            |   21 -
 drivers/staging/rt2860/common/eeprom.c         | 1268 ++++-
 drivers/staging/rt2860/common/md5.c            |   12 -
 drivers/staging/rt2860/common/mlme.c           | 1888 +++--
 drivers/staging/rt2860/common/netif_block.c    |  144 -
 drivers/staging/rt2860/common/netif_block.h    |   58 -
 drivers/staging/rt2860/common/rtmp_init.c      | 1251 +++-
 drivers/staging/rt2860/common/rtmp_tkip.c      |   21 -
 drivers/staging/rt2860/common/rtmp_wep.c       |    2 -
 drivers/staging/rt2860/common/spectrum.c       |   57 +-
 drivers/staging/rt2860/leap.h                  |  215 -
 drivers/staging/rt2860/mlme.h                  |  309 -
 drivers/staging/rt2860/oid.h                   |  173 +-
 drivers/staging/rt2860/rt28xx.h                | 1218 +---
 drivers/staging/rt2860/rt_ate.c                | 6009 ----------------
 drivers/staging/rt2860/rt_ate.h                |  347 -
 drivers/staging/rt2860/rt_config.h             |   33 +-
 drivers/staging/rt2860/rt_linux.c              |   45 +-
 drivers/staging/rt2860/rt_linux.h              |  187 +-
 drivers/staging/rt2860/rt_main_dev.c           |  717 +--
 drivers/staging/rt2860/rt_profile.c            |  161 +-
 drivers/staging/rt2860/rtmp.h                  | 1831 +++---
 drivers/staging/rt2860/rtmp_def.h              |  210 +-
 drivers/staging/rt2860/spectrum.h              |   30 -
 drivers/staging/rt2860/sta/assoc.c             |  584 +-
 drivers/staging/rt2860/sta/auth.c              |   14 -
 drivers/staging/rt2860/sta/auth_rsp.c          |   19 -
 drivers/staging/rt2860/sta/connect.c           |  602 +-
 drivers/staging/rt2860/sta/dls.c               | 2197 ------
 drivers/staging/rt2860/sta/rtmp_data.c         |  336 +-
 drivers/staging/rt2860/sta/sanity.c            |    2 -
 drivers/staging/rt2860/sta/sync.c              |  290 +-
 drivers/staging/rt2860/sta/wpa.c               |   12 +-
 drivers/staging/rt2860/sta_ioctl.c             | 1225 ++--
 drivers/staging/rt2860/wpa.h                   |   31 +-
 drivers/staging/rt2870/2870_main_dev.c         |  264 +-
 drivers/staging/rt2870/Makefile                |    4 -
 drivers/staging/rt2870/aironet.h               |  211 +-
 drivers/staging/rt2870/ap.h                    |  563 +--
 drivers/staging/rt2870/chlist.h                | 1297 +----
 drivers/staging/rt2870/common/2870_rtmp_init.c |  117 +-
 drivers/staging/rt2870/common/action.c         | 1047 +---
 drivers/staging/rt2870/common/action.h         |   69 +-
 drivers/staging/rt2870/common/ba_action.c      | 1799 +-----
 drivers/staging/rt2870/common/cmm_data.c       | 2732 +-------
 drivers/staging/rt2870/common/cmm_data_2870.c  |   73 +-
 drivers/staging/rt2870/common/cmm_info.c       | 3713 +----------
 drivers/staging/rt2870/common/cmm_sanity.c     | 1664 +-----
 drivers/staging/rt2870/common/cmm_sync.c       |  712 +--
 drivers/staging/rt2870/common/cmm_wpa.c        | 1655 +-----
 drivers/staging/rt2870/common/dfs.c            |  454 +--
 drivers/staging/rt2870/common/eeprom.c         |  255 +-
 drivers/staging/rt2870/common/md5.c            | 1428 +----
 drivers/staging/rt2870/common/mlme.c           | 8610 +----------------------
 drivers/staging/rt2870/common/netif_block.c    |  144 -
 drivers/staging/rt2870/common/rtmp_init.c      | 4133 +-----------
 drivers/staging/rt2870/common/rtmp_tkip.c      | 1614 +-----
 drivers/staging/rt2870/common/rtmp_wep.c       |  509 +--
 drivers/staging/rt2870/common/rtusb_bulk.c     |  775 +--
 drivers/staging/rt2870/common/rtusb_data.c     |   13 -
 drivers/staging/rt2870/common/rtusb_io.c       |  211 +-
 drivers/staging/rt2870/common/spectrum.c       | 1877 +-----
 drivers/staging/rt2870/dfs.h                   |  101 +-
 drivers/staging/rt2870/leap.h                  |  215 -
 drivers/staging/rt2870/link_list.h             |  135 +-
 drivers/staging/rt2870/md5.h                   |  108 +-
 drivers/staging/rt2870/mlme.h                  | 1472 +----
 drivers/staging/rt2870/netif_block.h           |   58 -
 drivers/staging/rt2870/oid.h                   | 1092 +---
 drivers/staging/rt2870/rt2870.h                |  252 +-
 drivers/staging/rt2870/rt28xx.h                | 2690 +-------
 drivers/staging/rt2870/rt_ate.c                | 6452 -----------------
 drivers/staging/rt2870/rt_ate.h                |  315 -
 drivers/staging/rt2870/rt_config.h             |  105 +-
 drivers/staging/rt2870/rt_linux.c              | 1096 +---
 drivers/staging/rt2870/rt_linux.h              |  907 +---
 drivers/staging/rt2870/rt_main_dev.c           | 1866 +-----
 drivers/staging/rt2870/rt_profile.c            | 2021 +------
 drivers/staging/rt2870/rtmp.h                  | 7587 +--------------------
 drivers/staging/rt2870/rtmp_ckipmic.h          |  114 +-
 drivers/staging/rt2870/rtmp_def.h              | 1623 +-----
 drivers/staging/rt2870/rtmp_type.h             |   95 +-
 drivers/staging/rt2870/spectrum.h              |  323 +-
 drivers/staging/rt2870/spectrum_def.h          |   96 +-
 drivers/staging/rt2870/sta/aironet.c           | 1313 +----
 drivers/staging/rt2870/sta/assoc.c             | 2040 +------
 drivers/staging/rt2870/sta/auth.c              |  475 +--
 drivers/staging/rt2870/sta/auth_rsp.c          |  167 +-
 drivers/staging/rt2870/sta/connect.c           | 2823 +--------
 drivers/staging/rt2870/sta/dls.c               | 2210 ------
 drivers/staging/rt2870/sta/rtmp_data.c         | 2620 +-------
 drivers/staging/rt2870/sta/sanity.c            |  421 +--
 drivers/staging/rt2870/sta/sync.c              | 1754 +-----
 drivers/staging/rt2870/sta/wpa.c               | 2108 +------
 drivers/staging/rt2870/sta_ioctl.c             | 7068 +------------------
 drivers/staging/rt2870/sta_ioctl.c.patch       |   18 -
 drivers/staging/rt2870/tmp60                   | 7037 ------------------
 drivers/staging/rt2870/tmp61                   | 7037 ------------------
 drivers/staging/rt2870/wpa.h                   |  358 +-
 drivers/staging/rt3070/2870_main_dev.c         | 1628 +-----
 drivers/staging/rt3070/Makefile                |    4 -
 drivers/staging/rt3070/action.h                |   69 +-
 drivers/staging/rt3070/aironet.h               |  211 +-
 drivers/staging/rt3070/ap.h                    |  558 +--
 drivers/staging/rt3070/chlist.h                | 1254 +----
 drivers/staging/rt3070/common/2870_rtmp_init.c | 1763 +-----
 drivers/staging/rt3070/common/action.c         | 1039 +---
 drivers/staging/rt3070/common/ba_action.c      | 1811 +-----
 drivers/staging/rt3070/common/cmm_data.c       | 2828 +--------
 drivers/staging/rt3070/common/cmm_data_2870.c  |  981 +---
 drivers/staging/rt3070/common/cmm_info.c       | 3396 +---------
 drivers/staging/rt3070/common/cmm_sanity.c     | 1670 +-----
 drivers/staging/rt3070/common/cmm_sync.c       |  712 +--
 drivers/staging/rt3070/common/cmm_wpa.c        | 1607 +-----
 drivers/staging/rt3070/common/dfs.c            |  442 +--
 drivers/staging/rt3070/common/eeprom.c         | 1499 +----
 drivers/staging/rt3070/common/md5.c            | 1428 +----
 drivers/staging/rt3070/common/mlme.c           | 9137 +-----------------------
 drivers/staging/rt3070/common/netif_block.c    |  136 -
 drivers/staging/rt3070/common/rtmp_init.c      | 4198 +-----------
 drivers/staging/rt3070/common/rtmp_tkip.c      | 1614 +-----
 drivers/staging/rt3070/common/rtmp_wep.c       |  509 +--
 drivers/staging/rt3070/common/rtusb_bulk.c     | 1383 +----
 drivers/staging/rt3070/common/rtusb_data.c     |  219 +-
 drivers/staging/rt3070/common/rtusb_io.c       | 1909 +-----
 drivers/staging/rt3070/common/spectrum.c       | 1877 +-----
 drivers/staging/rt3070/dfs.h                   |  101 +-
 drivers/staging/rt3070/leap.h                  |  215 -
 drivers/staging/rt3070/link_list.h             |  135 +-
 drivers/staging/rt3070/md5.h                   |  108 +-
 drivers/staging/rt3070/mlme.h                  | 1469 +----
 drivers/staging/rt3070/netif_block.h           |   58 -
 drivers/staging/rt3070/oid.h                   | 1143 +---
 drivers/staging/rt3070/rt2870.h                |  757 +--
 drivers/staging/rt3070/rt28xx.h                | 2726 +-------
 drivers/staging/rt3070/rt_ate.c                | 6506 -----------------
 drivers/staging/rt3070/rt_ate.h                |  294 -
 drivers/staging/rt3070/rt_config.h             |  122 +-
 drivers/staging/rt3070/rt_linux.c              | 1064 +---
 drivers/staging/rt3070/rt_linux.h              |  887 +---
 drivers/staging/rt3070/rt_main_dev.c           | 1802 +-----
 drivers/staging/rt3070/rt_profile.c            | 2042 +------
 drivers/staging/rt3070/rtmp.h                  | 7729 +--------------------
 drivers/staging/rt3070/rtmp_ckipmic.h          |  114 +-
 drivers/staging/rt3070/rtmp_def.h              | 1560 +----
 drivers/staging/rt3070/rtmp_type.h             |   96 +-
 drivers/staging/rt3070/spectrum.h              |  323 +-
 drivers/staging/rt3070/spectrum_def.h          |   96 +-
 drivers/staging/rt3070/sta/aironet.c           | 1313 +----
 drivers/staging/rt3070/sta/assoc.c             | 2061 +------
 drivers/staging/rt3070/sta/auth.c              |  476 +--
 drivers/staging/rt3070/sta/auth_rsp.c          |  168 +-
 drivers/staging/rt3070/sta/connect.c           | 2857 +--------
 drivers/staging/rt3070/sta/dls.c               | 2170 ------
 drivers/staging/rt3070/sta/rtmp_data.c         | 2638 +-------
 drivers/staging/rt3070/sta/sanity.c            |  421 +--
 drivers/staging/rt3070/sta/sync.c              | 1756 +-----
 drivers/staging/rt3070/sta/wpa.c               | 2100 +------
 drivers/staging/rt3070/sta_ioctl.c             | 7202 +-------------------
 drivers/staging/rt3070/wpa.h                   |  357 +-
 174 files changed, 7002 insertions(+), 215740 deletions(-)
 delete mode 100644 drivers/staging/rt2860/common/netif_block.c
 delete mode 100644 drivers/staging/rt2860/common/netif_block.h
 delete mode 100644 drivers/staging/rt2860/leap.h
 delete mode 100644 drivers/staging/rt2860/rt_ate.c
 delete mode 100644 drivers/staging/rt2860/rt_ate.h
 delete mode 100644 drivers/staging/rt2860/sta/dls.c
 delete mode 100644 drivers/staging/rt2870/common/netif_block.c
 delete mode 100644 drivers/staging/rt2870/leap.h
 delete mode 100644 drivers/staging/rt2870/netif_block.h
 delete mode 100644 drivers/staging/rt2870/rt_ate.c
 delete mode 100644 drivers/staging/rt2870/rt_ate.h
 delete mode 100644 drivers/staging/rt2870/sta/dls.c
 delete mode 100644 drivers/staging/rt2870/sta_ioctl.c.patch
 delete mode 100644 drivers/staging/rt2870/tmp60
 delete mode 100644 drivers/staging/rt2870/tmp61
 delete mode 100644 drivers/staging/rt3070/common/netif_block.c
 delete mode 100644 drivers/staging/rt3070/leap.h
 delete mode 100644 drivers/staging/rt3070/netif_block.h
 delete mode 100644 drivers/staging/rt3070/rt_ate.c
 delete mode 100644 drivers/staging/rt3070/rt_ate.h
 delete mode 100644 drivers/staging/rt3070/sta/dls.c


Bartlomiej Zolnierkiewicz (102):
      Staging: rt2870: remove unused files
      Staging: rt2870: remove kernel version compatibility wrappers
      Staging: rt3070: remove kernel version compatibility wrappers
      Staging: rt2860: remove IWE_STREAM_ADD_*() macros
      Staging: rt2870: remove IWE_STREAM_ADD_*() macros
      Staging: rt2860: remove dead WIN_NDIS code
      Staging: rt2860: remove dead UNDER_CE code
      Staging: rt2870: remove dead UNDER_CE code
      Staging: rt3070: remove dead UNDER_CE code
      Staging: rt2860: remove dead WSC_AP_SUPPORT code
      Staging: rt2870: remove dead WSC_AP_SUPPORT code
      Staging: rt3070: remove dead *WSC_INCLUDED code
      Staging: rt2860: remove dead WDS_SUPPORT code
      Staging: rt2870: remove dead WDS_SUPPORT code
      Staging: rt3070: remove dead WDS_SUPPORT code
      Staging: rt3070: remove dead MLME_EX code
      Staging: rt2860: remove dead APCLI_SUPPORT code
      Staging: rt2870: remove dead APCLI_SUPPORT code
      Staging: rt2860: remove dead CONFIG_APSTA_MIXED_SUPPORT code
      Staging: rt2870: remove dead CONFIG_APSTA_MIXED_SUPPORT code
      Staging: rt3070: remove dead CONFIG_APSTA_MIXED_SUPPORT code
      Staging: rt2860: remove dead UCOS code
      Staging: rt2870: remove dead UCOS code
      Staging: rt3070: remove dead UCOS code
      Staging: rt2860: remove dead NINTENDO_AP code
      Staging: rt2870: remove dead NINTENDO_AP code
      Staging: rt3070: remove dead NINTENDO_AP code
      Staging: rt2860: remove dead BIN_IN_FILE code
      Staging: rt2870: remove dead BIN_IN_FILE code
      Staging: rt3070: remove dead BIN_IN_FILE code
      Staging: rt2860: remove dead RALINK_ATE code
      Staging: rt2870: remove dead RALINK_ATE code
      Staging: rt3070: remove dead RALINK_ATE code
      Staging: rt2860: remove dead BLOCK_NET_IF code
      Staging: rt2870: remove dead BLOCK_NET_IF code
      Staging: rt3070: remove dead BLOCK_NET_IF code
      Staging: rt2860: remove dead DFS_SUPPORT code
      Staging: rt2870: remove dead DFS_SUPPORT code
      Staging: rt3070: remove dead DFS_SUPPORT code
      Staging: rt2860: remove dead CARRIER_DETECTION_SUPPORT code
      Staging: rt2870: remove dead CARRIER_DETECTION_SUPPORT code
      Staging: rt3070: remove dead CARRIER_DETECTION_SUPPORT code
      Staging: rt2860: remove dead MULTIPLE_CARD_SUPPORT code
      Staging: rt2870: remove dead MULTIPLE_CARD_SUPPORT code
      Staging: rt3070: remove dead MULTIPLE_CARD_SUPPORT code
      Staging: rt2860: remove dead QOS_DLS_SUPPORT code
      Staging: rt2870: remove dead QOS_DLS_SUPPORT code
      Staging: rt3070: remove dead QOS_DLS_SUPPORT code
      Staging: rt2860: remove dead EXT_BUILD_CHANNEL_LIST code
      Staging: rt2870: remove dead EXT_BUILD_CHANNEL_LIST code
      Staging: rt3070: remove dead EXT_BUILD_CHANNEL_LIST code
      Staging: rt2860: remove dead SNMP_SUPPORT code
      Staging: rt2870: remove dead SNMP_SUPPORT code
      Staging: rt3070: remove dead SNMP_SUPPORT code
      Staging: rt2860: remove dead SINGLE_SKU code
      Staging: rt2870: remove dead SINGLE_SKU code
      Staging: rt3070: remove dead SINGLE_SKU code
      Staging: rt2860: remove dead LEAP_SUPPORT code
      Staging: rt2870: remove dead LEAP_SUPPORT code
      Staging: rt3070: remove dead LEAP_SUPPORT code
      Staging: rt2860: remove dead DOT11N_DRAFT3 code
      Staging: rt2870: remove dead DOT11N_DRAFT3 code
      Staging: rt3070: remove dead DOT11N_DRAFT3 code
      Staging: rt2860: remove dead INF_AMAZON_SE code
      Staging: rt2870: remove dead INF_AMAZON_SE code
      Staging: rt3070: remove dead INF_AMAZON_SE code
      Staging: rt2860: remove dead RT_BIG_ENDIAN code
      Staging: rt2870: remove dead RT_BIG_ENDIAN code
      Staging: rt3070: remove dead RT_BIG_ENDIAN code
      Staging: rt2860: remove CONFIG_STA_SUPPORT ifdefs
      Staging: rt2870: remove CONFIG_STA_SUPPORT ifdefs
      Staging: rt3070: remove CONFIG_STA_SUPPORT ifdefs
      Staging: rt2860: remove NATIVE_WPA_SUPPLICANT_SUPPORT ifdefs
      Staging: rt2870: remove NATIVE_WPA_SUPPLICANT_SUPPORT ifdefs
      Staging: rt3070: remove NATIVE_WPA_SUPPLICANT_SUPPORT ifdefs
      Staging: rt2860: remove WPA_SUPPLICANT_SUPPORT ifdefs
      Staging: rt2870: remove WPA_SUPPLICANT_SUPPORT ifdefs
      Staging: rt3070: remove WPA_SUPPLICANT_SUPPORT ifdefs
      Staging: rt2860: remove DOT11_N_SUPPORT ifdefs
      Staging: rt2870: remove DOT11_N_SUPPORT ifdefs
      Staging: rt3070: remove DOT11_N_SUPPORT ifdefs
      Staging: rt2860: remove dead CONFIG_AP_SUPPORT code
      Staging: rt2870: remove dead CONFIG_AP_SUPPORT code
      Staging: rt3070: remove dead CONFIG_AP_SUPPORT code
      Staging: rt2860: use empty ASSERT() macro
      Staging: rt2870: use empty ASSERT() macro
      Staging: rt3070: use empty ASSERT() macro
      Staging: rt2860: remove dead code
      Staging: rt2870: remove dead code
      Staging: rt3070: remove dead code
      Staging: rt2870: prepare for rt{28,30}70/*.[ch] merge
      Staging: rt{28,30}70: merge rt{28,30}70/*.[ch]
      Staging: rt2870: prepare for rt{28,30}70/common/*.[ch] merge
      Staging: rt{28,30}70: merge rt{28,30}70/common/*.[ch]
      Staging: rt2870: prepare for rt{28,30}70/sta/*.[ch] merge
      Staging: rt{28,30}70: merge rt{28,30}70/sta/*.[ch]
      Staging: rt2860: prepare for rt28[67]0/*.[ch] merge
      Staging: rt28[67]0: merge rt28[67]0/*.[ch]
      Staging: rt2860: prepare for rt28[67]0/common/*.[ch] merge
      Staging: rt28[67]0: merge rt28[67]0/common/*.[ch]
      Staging: rt2860: prepare for rt28[67]0/sta/*.[ch] merge
      Staging: rt28[67]0: merge rt28[67]0/sta/*.[ch]

