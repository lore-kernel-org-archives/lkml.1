Return-Path: <linux-kernel-owner+w=401wt.eu-S933703AbZHWN2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933703AbZHWN2T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 09:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933645AbZHWN2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 09:28:18 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:58451 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933644AbZHWN2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 09:28:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=skO8spimwBIeILEciFlPjZS2h8RUyVEShgZXmHKuVoqhkzVNt0oa6uhDiLd2c4LNEv
         /YtT2CwFAPZ9ZjMno/0OR9TMBxpUYZs4AAKQNdMs/A+FYi/00mFIqiKdwiH3JB+AfdQc
         IYHtv2Buh6aarkLeqZ1Q4053G8o1J73qM6qeE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Marcin Slusarz <marcin.slusarz@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Date: Sun, 23 Aug 2009 15:28:46 +0200
Message-Id: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
Subject: [PATCH 00/33] Staging: rt{286,287,307}0: merge rt3070 with rt2870
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

The final part of rt2870 and rt3070 merge.

It adds RT3070 chipset support to rt2870 driver and removes no longer needed
rt3070 driver (yes, it means one Ralink driver less in the staging tree!).

[ in the process many bugs in all Ralink drivers were fixed, RT2870 chipset
  support was converted to use the new firmware and ~1.5 KLOC were removed ]

I tested it on RT2860 and RT3070 chipsets already but I would need some help
from people with RT2870 hardware to verify those changes (Mike? Marcin?).

To make life easier there is also the combined patchset available at:

	http://www.kernel.org/pub/linux/kernel/people/bart/ralink-20090822.patch

which can be applied at the top of the current staging tree patch from:

	http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-07-staging-2.6.31-rc6.patch

[ which in turn applies just fine also at the top of 2.6.31-rc7 ]

Thanks!


diffstat:
 drivers/staging/rt2870/common/firmware.h                |  558 ----------------
 drivers/staging/rt3070/2870_main_dev.c                  |    1 
 drivers/staging/rt3070/Kconfig                          |    6 
 drivers/staging/rt3070/Makefile                         |   43 -
 drivers/staging/rt3070/action.h                         |    1 
 drivers/staging/rt3070/aironet.h                        |    1 
 drivers/staging/rt3070/ap.h                             |    1 
 drivers/staging/rt3070/chlist.h                         |    1 
 drivers/staging/rt3070/common/2870_rtmp_init.c          |    1 
 drivers/staging/rt3070/common/action.c                  |    1 
 drivers/staging/rt3070/common/ba_action.c               |    1 
 drivers/staging/rt3070/common/cmm_data.c                |    1 
 drivers/staging/rt3070/common/cmm_data_2870.c           |    1 
 drivers/staging/rt3070/common/cmm_info.c                |    1 
 drivers/staging/rt3070/common/cmm_sanity.c              |    1 
 drivers/staging/rt3070/common/cmm_sync.c                |    1 
 drivers/staging/rt3070/common/cmm_wpa.c                 |    1 
 drivers/staging/rt3070/common/dfs.c                     |    1 
 drivers/staging/rt3070/common/eeprom.c                  |    1 
 drivers/staging/rt3070/common/md5.c                     |    1 
 drivers/staging/rt3070/common/mlme.c                    |    1 
 drivers/staging/rt3070/common/rtmp_init.c               |    1 
 drivers/staging/rt3070/common/rtmp_tkip.c               |    1 
 drivers/staging/rt3070/common/rtmp_wep.c                |    1 
 drivers/staging/rt3070/common/rtusb_bulk.c              |    1 
 drivers/staging/rt3070/common/rtusb_data.c              |    1 
 drivers/staging/rt3070/common/rtusb_io.c                |    1 
 drivers/staging/rt3070/common/spectrum.c                |    1 
 drivers/staging/rt3070/dfs.h                            |    1 
 drivers/staging/rt3070/md5.h                            |    1 
 drivers/staging/rt3070/mlme.h                           |    1 
 drivers/staging/rt3070/oid.h                            |    1 
 drivers/staging/rt3070/rt2870.h                         |    1 
 drivers/staging/rt3070/rt28xx.h                         |    1 
 drivers/staging/rt3070/rt_config.h                      |    1 
 drivers/staging/rt3070/rt_linux.c                       |    1 
 drivers/staging/rt3070/rt_linux.h                       |    1 
 drivers/staging/rt3070/rt_main_dev.c                    |    1 
 drivers/staging/rt3070/rt_profile.c                     |    1 
 drivers/staging/rt3070/rtmp.h                           |    1 
 drivers/staging/rt3070/rtmp_ckipmic.h                   |    1 
 drivers/staging/rt3070/rtmp_def.h                       |    1 
 drivers/staging/rt3070/rtmp_type.h                      |    1 
 drivers/staging/rt3070/spectrum.h                       |    1 
 drivers/staging/rt3070/spectrum_def.h                   |    1 
 drivers/staging/rt3070/sta/aironet.c                    |    1 
 drivers/staging/rt3070/sta/assoc.c                      |    1 
 drivers/staging/rt3070/sta/auth.c                       |    1 
 drivers/staging/rt3070/sta/auth_rsp.c                   |    1 
 drivers/staging/rt3070/sta/connect.c                    |    2 
 drivers/staging/rt3070/sta/rtmp_data.c                  |    1 
 drivers/staging/rt3070/sta/sanity.c                     |    1 
 drivers/staging/rt3070/sta/sync.c                       |    1 
 drivers/staging/rt3070/sta/wpa.c                        |    1 
 drivers/staging/rt3070/sta_ioctl.c                      |    1 
 drivers/staging/rt3070/wpa.h                            |    1 
 b/drivers/staging/Kconfig                        |    2 
 b/drivers/staging/Makefile                       |    1 
 b/drivers/staging/rt2860/chlist.h                |    5 
 b/drivers/staging/rt2860/common/cmm_data.c       |  134 ---
 b/drivers/staging/rt2860/common/cmm_info.c       |   25 
 b/drivers/staging/rt2860/common/cmm_wpa.c        |   12 
 b/drivers/staging/rt2860/common/eeprom.c         |   23 
 b/drivers/staging/rt2860/common/mlme.c           |  295 --------
 b/drivers/staging/rt2860/common/rtmp_init.c      |  116 ---
 b/drivers/staging/rt2860/rt_main_dev.c           |    2 
 b/drivers/staging/rt2860/rt_profile.c            |   23 
 b/drivers/staging/rt2860/rtmp.h                  |   35 -
 b/drivers/staging/rt2860/sta/assoc.c             |    6 
 b/drivers/staging/rt2860/sta/connect.c           |    6 
 b/drivers/staging/rt2860/sta/rtmp_data.c         |    9 
 b/drivers/staging/rt2860/sta/wpa.c               |    9 
 b/drivers/staging/rt2860/sta_ioctl.c             |   81 --
 b/drivers/staging/rt2860/wpa.h                   |    1 
 b/drivers/staging/rt2870/2870_main_dev.c         |   33 
 b/drivers/staging/rt2870/Kconfig                 |    5 
 b/drivers/staging/rt2870/Makefile                |    2 
 b/drivers/staging/rt2870/common/2870_rtmp_init.c |    5 
 b/drivers/staging/rt2870/common/cmm_data_2870.c  |   30 
 b/drivers/staging/rt2870/common/rtusb_bulk.c     |    3 
 b/drivers/staging/rt2870/common/rtusb_io.c       |   54 -
 b/drivers/staging/rt2870/rt2870.h                |   27 
 82 files changed, 74 insertions(+), 1531 deletions(-)
